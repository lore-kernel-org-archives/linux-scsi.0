From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 1/2] scsi_dh: Check error code from try_module_get()
Date: Fri, 04 Jul 2008 15:46:40 +0200
Message-ID: <20080704134640.B125F10B5DD@craiglockhart-ipmi.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:43072 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759162AbYGDNqm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2008 09:46:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


In some corner cases try_module_get() actually might fail.
So we should better check for return values there.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  |    5 +++--
 drivers/scsi/device_handler/scsi_dh_emc.c   |    5 +++--
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |    5 +++--
 drivers/scsi/device_handler/scsi_dh_ontap.c |    7 +++++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |    5 +++--
 5 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 99624e7..a3c89df 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -739,12 +739,13 @@ static int alua_bus_attach(struct scsi_device *sdev)
 	if (err != SCSI_DH_OK)
 		goto failed;
 
+	if (!try_module_get(THIS_MODULE))
+		goto failed;
+
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-	try_module_get(THIS_MODULE);
-
 	return 0;
 
 failed:
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 89ca2dd..599d748 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -614,6 +614,9 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 	if (err != SCSI_DH_OK)
 		goto failed;
 
+	if (!try_module_get(THIS_MODULE))
+		goto failed;
+
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
@@ -624,8 +627,6 @@ static int clariion_bus_attach(struct scsi_device *sdev)
 		    h->port, lun_state[h->lun_state],
 		    h->default_sp + 'A');
 
-	try_module_get(THIS_MODULE);
-
 	return 0;
 
 failed:
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index c0e00b7..d7bc3d6 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -327,12 +327,13 @@ static int hp_sw_bus_attach(struct scsi_device *sdev)
 	if (ret != SCSI_DH_OK || h->path_state == HP_SW_PATH_UNINITIALIZED)
 		goto failed;
 
+	if (!try_module_get(THIS_MODULE))
+		goto failed;
+
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
-	try_module_get(THIS_MODULE);
-
 	sdev_printk(KERN_INFO, sdev, "%s: attached to %s path\n",
 		    HP_SW_NAME, h->path_state == HP_SW_PATH_ACTIVE?
 		    "active":"passive");
diff --git a/drivers/scsi/device_handler/scsi_dh_ontap.c b/drivers/scsi/device_handler/scsi_dh_ontap.c
index 175d657..0e928f1 100644
--- a/drivers/scsi/device_handler/scsi_dh_ontap.c
+++ b/drivers/scsi/device_handler/scsi_dh_ontap.c
@@ -105,14 +105,17 @@ static int ontap_bus_attach(struct scsi_device *sdev)
 	h = (struct ontap_dh_data *) scsi_dh_data->buf;
 	h->state = ONTAP_STATE_ACTIVE;
 
+	if (!try_module_get(THIS_MODULE)) {
+		kfree(scsi_dh_data);
+		return -ENODEV;
+	}
+
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 
 	sdev_printk(KERN_NOTICE, sdev, "Attached %s.\n", ONTAP_NAME);
 
-	try_module_get(THIS_MODULE);
-
 	return 0;
 }
 
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index e11e522..b915957 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -634,6 +634,9 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 	if (err != SCSI_DH_OK)
 		goto failed;
 
+	if (!try_module_get(THIS_MODULE))
+		goto failed;
+
 	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
 	sdev->scsi_dh_data = scsi_dh_data;
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
@@ -642,8 +645,6 @@ static int rdac_bus_attach(struct scsi_device *sdev)
 		    "%s: LUN %d (%s)\n",
 		    RDAC_NAME, h->lun, lun_state[(int)h->lun_state]);
 
-	try_module_get(THIS_MODULE);
-
 	return 0;
 
 failed:
-- 
1.5.2.4

