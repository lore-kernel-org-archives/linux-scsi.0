From: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>
Subject: [mpt3sas driver 04/10] mpt3sas: Never block the Enclosure device
Date: Thu, 28 Jan 2016 12:07:01 +0530
Message-ID: <1453963027-19770-5-git-send-email-suganath-prabu.subramani@avagotech.com>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35843 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965305AbcA1Ghw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 01:37:52 -0500
Received: by mail-pa0-f53.google.com with SMTP id yy13so18007827pab.3
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2016 22:37:51 -0800 (PST)
In-Reply-To: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@avagotech.com, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com

From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>

Never block the SEP device (i.e. Never invoke the
scsi_internal_device_block() API for SEP device) even for the delay not
responding events. Blocking the SEP device will create a deadlock while
adding any device to the OS.

Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h  |  1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 22 +++++++++++++++++++++-
 2 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 5ad271e..2786222 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -398,6 +398,7 @@ struct MPT3SAS_DEVICE {
 	u8	configured_lun;
 	u8	block;
 	u8	tlr_snoop_check;
+	u8	ignore_delay_remove;
 };
 
 #define MPT3_CMD_NOT_USED	0x8000	/* free */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 686a46a..dcb4c18 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1953,7 +1953,15 @@ scsih_slave_configure(struct scsi_device *sdev)
 	if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_SSP_TARGET) {
 		qdepth = MPT3SAS_SAS_QUEUE_DEPTH;
 		ssp_target = 1;
-		ds = "SSP";
+		if (sas_device->device_info &
+				MPI2_SAS_DEVICE_INFO_SEP) {
+			sdev_printk(KERN_WARNING, sdev,
+			"set ignore_delay_remove for handle(0x%04x)\n",
+			sas_device_priv_data->sas_target->handle);
+			sas_device_priv_data->ignore_delay_remove = 1;
+			ds = "SES";
+		} else
+			ds = "SSP";
 	} else {
 		qdepth = MPT3SAS_SATA_QUEUE_DEPTH;
 		if (sas_device->device_info & MPI2_SAS_DEVICE_INFO_STP_TARGET)
@@ -2943,6 +2951,12 @@ _scsih_block_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 			continue;
 		if (sas_device_priv_data->block)
 			continue;
+		if (sas_device_priv_data->ignore_delay_remove) {
+			sdev_printk(KERN_INFO, sdev,
+			"%s skip device_block for SES handle(0x%04x)\n",
+			__func__, sas_device_priv_data->sas_target->handle);
+			continue;
+		}
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
 	}
 }
@@ -2975,6 +2989,12 @@ _scsih_block_io_device(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 			continue;
 		if (sas_device->pend_sas_rphy_add)
 			continue;
+		if (sas_device_priv_data->ignore_delay_remove) {
+			sdev_printk(KERN_INFO, sdev,
+			"%s skip device_block for SES handle(0x%04x)\n",
+			__func__, sas_device_priv_data->sas_target->handle);
+			continue;
+		}
 		_scsih_internal_device_block(sdev, sas_device_priv_data);
 	}
 
-- 
1.8.3.1

