Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE2DC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:35:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0DC12073E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 08:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbgFQIf5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:35:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:52110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726879AbgFQIfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 04:35:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 891A7AD5E;
        Wed, 17 Jun 2020 08:35:57 +0000 (UTC)
From:   mwilck@suse.com
To:     Don Brace <don.brace@microsemi.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        shane.seymour@hpe.com, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2 1/3] scsi: smartpqi: grab scsi device ref in slave_configure()
Date:   Wed, 17 Jun 2020 10:35:12 +0200
Message-Id: <20200617083514.19174-2-mwilck@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200617083514.19174-1-mwilck@suse.com>
References: <20200617083514.19174-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

We have observed kernel crashes caused by the smartpqi driver holding
a pointer to a struct scsi_device that had been removed already.
Fix this by getting and holding a ref for the device as long as
the driver uses it.

Use a lock to avoid races between device probing and removal.

Reviewed-by: Shane Seymour <shane.seymour@hpe.com>
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/smartpqi/smartpqi.h      |   1 +
 drivers/scsi/smartpqi/smartpqi_init.c | 122 +++++++++++++++++++++-----
 2 files changed, 103 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index 1129fe7a27ed..5801080c8dbc 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -954,6 +954,7 @@ struct pqi_scsi_dev {
 	struct raid_map *raid_map;	/* RAID bypass map */
 
 	struct pqi_sas_port *sas_port;
+	spinlock_t sdev_lock;		/* protect access to sdev */
 	struct scsi_device *sdev;
 
 	struct list_head scsi_device_list_entry;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index cd157f11eb22..54a72f465f85 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -1514,6 +1514,18 @@ static int pqi_add_device(struct pqi_ctrl_info *ctrl_info,
 
 #define PQI_PENDING_IO_TIMEOUT_SECS	20
 
+static inline struct scsi_device *
+pqi_get_scsi_device(struct pqi_scsi_dev *device)
+{
+	unsigned long flags;
+	struct scsi_device *sdev;
+
+	spin_lock_irqsave(&device->sdev_lock, flags);
+	sdev = device->sdev;
+	spin_unlock_irqrestore(&device->sdev_lock, flags);
+	return sdev;
+}
+
 static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info,
 	struct pqi_scsi_dev *device)
 {
@@ -1530,9 +1542,26 @@ static inline void pqi_remove_device(struct pqi_ctrl_info *ctrl_info,
 			device->target, device->lun,
 			atomic_read(&device->scsi_cmds_outstanding));
 
-	if (pqi_is_logical_device(device))
-		scsi_remove_device(device->sdev);
-	else
+	if (pqi_is_logical_device(device)) {
+		struct scsi_device *sdev;
+		unsigned long flags;
+
+		spin_lock_irqsave(&device->sdev_lock, flags);
+		sdev = device->sdev;
+		if (sdev)
+			get_device(&sdev->sdev_gendev);
+		spin_unlock_irqrestore(&device->sdev_lock, flags);
+
+		/*
+		 * As scsi_remove_device() will call pqi_slave_destroy(),
+		 * we can't keep the sdev_lock held. But we've taken a ref,
+		 * so sdev will not go away under us.
+		 */
+		if (sdev) {
+			scsi_remove_device(sdev);
+			put_device(&sdev->sdev_gendev);
+		}
+	} else
 		pqi_remove_sas_device(device);
 }
 
@@ -1749,7 +1778,7 @@ static inline bool pqi_is_device_added(struct pqi_scsi_dev *device)
 	if (device->is_expander_smp_device)
 		return device->sas_port != NULL;
 
-	return device->sdev != NULL;
+	return pqi_get_scsi_device(device) != NULL;
 }
 
 static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
@@ -1861,11 +1890,24 @@ static void pqi_update_device_list(struct pqi_ctrl_info *ctrl_info,
 	 */
 	list_for_each_entry(device, &ctrl_info->scsi_device_list,
 		scsi_device_list_entry) {
-		if (device->sdev && device->queue_depth !=
-			device->advertised_queue_depth) {
-			device->advertised_queue_depth = device->queue_depth;
-			scsi_change_queue_depth(device->sdev,
-				device->advertised_queue_depth);
+		struct scsi_device *sdev;
+		unsigned long flags;
+
+		spin_lock_irqsave(&device->sdev_lock, flags);
+		sdev = device->sdev;
+		if (sdev)
+			get_device(&sdev->sdev_gendev);
+		spin_unlock_irqrestore(&device->sdev_lock, flags);
+
+		if (sdev) {
+			if (device->queue_depth !=
+			    device->advertised_queue_depth) {
+				device->advertised_queue_depth =
+					device->queue_depth;
+				scsi_change_queue_depth(sdev,
+					device->advertised_queue_depth);
+			}
+			put_device(&sdev->sdev_gendev);
 		}
 	}
 
@@ -2082,6 +2124,7 @@ static int pqi_update_scsi_devices(struct pqi_ctrl_info *ctrl_info)
 			device = list_first_entry(&new_device_list_head,
 				struct pqi_scsi_dev, new_device_list_entry);
 
+		spin_lock_init(&device->sdev_lock);
 		memcpy(device->scsi3addr, scsi3addr, sizeof(device->scsi3addr));
 		device->is_physical_device = is_physical_device;
 		if (is_physical_device) {
@@ -5785,6 +5828,7 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 	struct pqi_ctrl_info *ctrl_info;
 	struct scsi_target *starget;
 	struct sas_rphy *rphy;
+	int ret;
 
 	ctrl_info = shost_to_hba(sdev->host);
 
@@ -5806,23 +5850,59 @@ static int pqi_slave_alloc(struct scsi_device *sdev)
 
 	if (device) {
 		sdev->hostdata = device;
-		device->sdev = sdev;
-		if (device->queue_depth) {
-			device->advertised_queue_depth = device->queue_depth;
-			scsi_change_queue_depth(sdev,
-				device->advertised_queue_depth);
-		}
-		if (pqi_is_logical_device(device))
-			pqi_disable_write_same(sdev);
-		else
-			sdev->allow_restart = 1;
-	}
+		ret = 0;
+	} else
+		ret = -ENXIO;
 
 	spin_unlock_irqrestore(&ctrl_info->scsi_device_list_lock, flags);
 
+	return ret;
+}
+
+static int pqi_slave_configure(struct scsi_device *sdev)
+{
+	struct pqi_scsi_dev *device = sdev->hostdata;
+	unsigned long flags;
+
+	/*
+	 * Grab a ref to the SCSI device, lest it be removed under us. It will
+	 * be dropped in pqi_slave_destroy().
+	 * Don't use scsi_device_get() here, we'd increment our own  use count
+	 */
+	if (!get_device(&sdev->sdev_gendev))
+		return -ENXIO;
+
+	spin_lock_irqsave(&device->sdev_lock, flags);
+	device->sdev = sdev;
+	spin_unlock_irqrestore(&device->sdev_lock, flags);
+
+	if (device->queue_depth) {
+		device->advertised_queue_depth = device->queue_depth;
+		scsi_change_queue_depth(sdev,
+					device->advertised_queue_depth);
+	}
+	if (pqi_is_logical_device(device))
+		pqi_disable_write_same(sdev);
+	else
+		sdev->allow_restart = 1;
 	return 0;
 }
 
+static void pqi_slave_destroy(struct scsi_device *sdev)
+{
+	struct pqi_scsi_dev *device = sdev->hostdata;
+	unsigned long flags;
+
+	if (!device)
+		return;
+
+	spin_lock_irqsave(&device->sdev_lock, flags);
+	sdev = device->sdev;
+	device->sdev = NULL;
+	spin_unlock_irqrestore(&device->sdev_lock, flags);
+	put_device(&sdev->sdev_gendev);
+}
+
 static int pqi_map_queues(struct Scsi_Host *shost)
 {
 	struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
@@ -6501,6 +6581,8 @@ static struct scsi_host_template pqi_driver_template = {
 	.eh_device_reset_handler = pqi_eh_device_reset_handler,
 	.ioctl = pqi_ioctl,
 	.slave_alloc = pqi_slave_alloc,
+	.slave_configure = pqi_slave_configure,
+	.slave_destroy = pqi_slave_destroy,
 	.map_queues = pqi_map_queues,
 	.sdev_attrs = pqi_sdev_attrs,
 	.shost_attrs = pqi_shost_attrs,
-- 
2.26.2

