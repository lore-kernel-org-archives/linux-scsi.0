Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22FCC3A59D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 06:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FC792082F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 06:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="F2hdSMKh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731615AbfHVGTQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 02:19:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46359 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727476AbfHVGTP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2019 02:19:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id c2so2800809plz.13
        for <linux-scsi@vger.kernel.org>; Wed, 21 Aug 2019 23:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=cx4+pHSHlvPh/qgyUhOxVOLljlEmwcwTtezxtvmr7uc=;
        b=F2hdSMKhv7bcqx93Ac49nBnVYQMDSexcMX1KIOKHH7xPJphq3JCd0dZdUqcB2js0QN
         yLIb49z0Bc+KQGOKJR8TCT1wN3d7a8ojE8CUme1Dx+hOEfnAaAhusGMvYgdvgVa00QLA
         5Va3or3Qc7jqeJZyMDYrbQDlLXOH6C74mPKzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cx4+pHSHlvPh/qgyUhOxVOLljlEmwcwTtezxtvmr7uc=;
        b=Js3Vl3mq5LlgZeWkm0xbyPzYTyzp3eCRQ5G0sqae0toJD9d31WzoWmUr/DONSJlBXJ
         FsgHMxAusMNTyr5C8f7HwYHtqq5ZBLPKUuhdrh1UJ0rn8BY3cpmboxlIIMXZ5oQL0/cV
         TSZkkD/jskr7eQZQC1snNjFg0ciHEpQI9tR54MYRC4DNhQBpRib4TYyahbZCqqeofbvn
         gXPxee3xx0VjicjwQkxRMAJvj9FCeoNzsWRUdxEUBK89W6RwVaRlMPMnGGcftHKV3e2i
         pf5jd09zOSVe79wKJtacq/9j0b4aw0ObOUYrf+K3jiWdMkN1kIFJxrerithywW9QMGmz
         Memw==
X-Gm-Message-State: APjAAAVn4sQ1Wm3VBm4gmYZHrtz03+Xkrlv1HNUsgHbsZmlsPkZKr+h6
        WREbsS3UjDc9xg7ohidMOFJ/EkmvRYc=
X-Google-Smtp-Source: APXvYqxygVHqX4UDhQTlp5nGtl401HES5cCplVm0x4Yyj58l4bo3/EJasQw6yWaAGIt8cdrgTJHXLA==
X-Received: by 2002:a17:902:9041:: with SMTP id w1mr38360113plz.132.1566454754839;
        Wed, 21 Aug 2019 23:19:14 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id g19sm43531372pfk.0.2019.08.21.23.19.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 23:19:14 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH] mpt3sas: Add sysfs parameter to set sdev qd to host can_queue
Date:   Thu, 22 Aug 2019 02:19:01 -0400
Message-Id: <1566454741-34409-1-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch provides the module parameter and sysfs interface
named 'enable_sdev_max_qd' to switch between the driver provided
(optimal)queue depth and controller queue depth (can_queue).

When 'enable_sdev_max_qd' is set to one then all the device's queue depth
is set to shost's can_queue value. When this sysfs is reset to zero then
all the devices queue depth is set to corresponding device type's default
(i.e. optimal) value defined by the driver.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   2 +
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 102 +++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  40 ++++++++++++--
 3 files changed, 140 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 745e0e1..faca0a5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1232,6 +1232,7 @@ struct MPT3SAS_ADAPTER {
 	u16		thresh_hold;
 	u8		high_iops_queues;
 	u32		drv_support_bitmap;
+	bool		enable_sdev_max_qd;
 
 	/* internal commands, callback index */
 	u8		scsi_io_cb_idx;
@@ -1587,6 +1588,7 @@ struct _pcie_device *mpt3sas_get_pdev_by_handle(struct MPT3SAS_ADAPTER *ioc,
 void mpt3sas_port_enable_complete(struct MPT3SAS_ADAPTER *ioc);
 struct _raid_device *
 mpt3sas_raid_device_find_by_handle(struct MPT3SAS_ADAPTER *ioc, u16 handle);
+void mpt3sas_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth);
 
 /* config shared API */
 u8 mpt3sas_config_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index da29005..7d69695 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3400,6 +3400,107 @@ drv_support_bitmap_show(struct device *cdev,
 }
 static DEVICE_ATTR_RO(drv_support_bitmap);
 
+/**
+ * enable_sdev_max_qd_show - display whether sdev max qd is enabled/disabled
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * A sysfs read/write shost attribute. This attribute is used to set the
+ * targets queue depth to HBA IO queue depth if this attribute is enabled.
+ */
+static ssize_t
+enable_sdev_max_qd_show(struct device *cdev,
+	struct device_attribute *attr, char *buf)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", ioc->enable_sdev_max_qd);
+}
+
+/**
+ * enable_sdev_max_qd_store - Enable/disable sdev max qd
+ * @cdev - pointer to embedded class device
+ * @buf - the buffer returned
+ *
+ * A sysfs read/write shost attribute. This attribute is used to set the
+ * targets queue depth to HBA IO queue depth if this attribute is enabled.
+ * If this attribute is disabled then targets will have corresponding default
+ * queue depth.
+ */
+static ssize_t
+enable_sdev_max_qd_store(struct device *cdev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(cdev);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+	struct MPT3SAS_DEVICE *sas_device_priv_data;
+	struct MPT3SAS_TARGET *sas_target_priv_data;
+	int val = 0;
+	struct scsi_device *sdev;
+	struct _raid_device *raid_device;
+	int qdepth;
+
+	if (kstrtoint(buf, 0, &val) != 0)
+		return -EINVAL;
+
+	switch (val) {
+	case 0:
+		ioc->enable_sdev_max_qd = 0;
+		shost_for_each_device(sdev, ioc->shost) {
+			sas_device_priv_data = sdev->hostdata;
+			if (!sas_device_priv_data)
+				continue;
+			sas_target_priv_data = sas_device_priv_data->sas_target;
+			if (!sas_target_priv_data)
+				continue;
+
+			if (sas_target_priv_data->flags &
+			    MPT_TARGET_FLAGS_VOLUME) {
+				raid_device =
+				    mpt3sas_raid_device_find_by_handle(ioc,
+				    sas_target_priv_data->handle);
+
+				switch (raid_device->volume_type) {
+				case MPI2_RAID_VOL_TYPE_RAID0:
+					if (raid_device->device_info &
+					    MPI2_SAS_DEVICE_INFO_SSP_TARGET)
+						qdepth =
+						    MPT3SAS_SAS_QUEUE_DEPTH;
+					else
+						qdepth =
+						    MPT3SAS_SATA_QUEUE_DEPTH;
+					break;
+				case MPI2_RAID_VOL_TYPE_RAID1E:
+				case MPI2_RAID_VOL_TYPE_RAID1:
+				case MPI2_RAID_VOL_TYPE_RAID10:
+				case MPI2_RAID_VOL_TYPE_UNKNOWN:
+				default:
+					qdepth = MPT3SAS_RAID_QUEUE_DEPTH;
+				}
+			} else if (sas_target_priv_data->flags &
+			    MPT_TARGET_FLAGS_PCIE_DEVICE)
+				qdepth = MPT3SAS_NVME_QUEUE_DEPTH;
+			else
+				qdepth = MPT3SAS_SAS_QUEUE_DEPTH;
+
+			mpt3sas_scsih_change_queue_depth(sdev, qdepth);
+		}
+		break;
+	case 1:
+		ioc->enable_sdev_max_qd = 1;
+		shost_for_each_device(sdev, ioc->shost)
+			mpt3sas_scsih_change_queue_depth(sdev,
+			    shost->can_queue);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return strlen(buf);
+}
+static DEVICE_ATTR_RW(enable_sdev_max_qd);
+
 struct device_attribute *mpt3sas_host_attrs[] = {
 	&dev_attr_version_fw,
 	&dev_attr_version_bios,
@@ -3427,6 +3528,7 @@ struct device_attribute *mpt3sas_host_attrs[] = {
 	&dev_attr_diag_trigger_mpi,
 	&dev_attr_drv_support_bitmap,
 	&dev_attr_BRM_status,
+	&dev_attr_enable_sdev_max_qd,
 	NULL,
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 9904775..d0c2f8d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -155,6 +155,10 @@ static int prot_mask = -1;
 module_param(prot_mask, int, 0444);
 MODULE_PARM_DESC(prot_mask, " host protection capabilities mask, def=7 ");
 
+static bool enable_sdev_max_qd;
+module_param(enable_sdev_max_qd, bool, 0444);
+MODULE_PARM_DESC(enable_sdev_max_qd,
+	"Enable sdev max qd as can_queue, def=disabled(0)");
 
 /* raid transport support */
 static struct raid_template *mpt3sas_raid_template;
@@ -1519,7 +1523,13 @@ scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 
 	max_depth = shost->can_queue;
 
-	/* limit max device queue for SATA to 32 */
+	/*
+	 * limit max device queue for SATA to 32 if enable_sdev_max_qd
+	 * is disabled.
+	 */
+	if (ioc->enable_sdev_max_qd)
+		goto not_sata;
+
 	sas_device_priv_data = sdev->hostdata;
 	if (!sas_device_priv_data)
 		goto not_sata;
@@ -1549,6 +1559,25 @@ scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 }
 
 /**
+ * mpt3sas_scsih_change_queue_depth - setting device queue depth
+ * @sdev: scsi device struct
+ * @qdepth: requested queue depth
+ *
+ * Returns nothing.
+ */
+void
+mpt3sas_scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+
+	if (ioc->enable_sdev_max_qd)
+		qdepth = shost->can_queue;
+
+	scsih_change_queue_depth(sdev, qdepth);
+}
+
+/**
  * scsih_target_alloc - target add routine
  * @starget: scsi target struct
  *
@@ -2306,7 +2335,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 						MPT3SAS_RAID_MAX_SECTORS);
 		}
 
-		scsih_change_queue_depth(sdev, qdepth);
+		mpt3sas_scsih_change_queue_depth(sdev, qdepth);
 
 		/* raid transport support */
 		if (!ioc->is_warpdrive)
@@ -2370,7 +2399,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
-		scsih_change_queue_depth(sdev, qdepth);
+		mpt3sas_scsih_change_queue_depth(sdev, qdepth);
 		/* Enable QUEUE_FLAG_NOMERGES flag, so that IOs won't be
 		 ** merged and can eliminate holes created during merging
 		 ** operation.
@@ -2430,7 +2459,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 		_scsih_display_sata_capabilities(ioc, handle, sdev);
 
 
-	scsih_change_queue_depth(sdev, qdepth);
+	mpt3sas_scsih_change_queue_depth(sdev, qdepth);
 
 	if (ssp_target) {
 		sas_read_port_mode_page(sdev);
@@ -10507,6 +10536,9 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * Enable MEMORY MOVE support flag.
 	 */
 	ioc->drv_support_bitmap |= MPT_DRV_SUPPORT_BITMAP_MEMMOVE;
+
+	ioc->enable_sdev_max_qd = enable_sdev_max_qd;
+
 	/* misc semaphores and spin locks */
 	mutex_init(&ioc->reset_in_progress_mutex);
 	/* initializing pci_access_mutex lock */
-- 
1.8.3.1

