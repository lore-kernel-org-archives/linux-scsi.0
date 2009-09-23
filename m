From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 11/20] mpt2sas: Limit the max_depth to 32 for SATA devices which are not part of volume
Date: Wed, 23 Sep 2009 17:30:22 +0530
Message-ID: <20090923120022.GP6772@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:50278 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbZIWMXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2009 08:23:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Added sanity check in _scsih_change_queue_depth to limit the max_depth to 32
for SATA devices. This is only for physical devices not part of a volume.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 90587d5..d241769 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -1107,8 +1107,33 @@ _scsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 	struct Scsi_Host *shost = sdev->host;
 	int max_depth;
 	int tag_type;
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
+	struct MPT2SAS_DEVICE *sas_device_priv_data;
+	struct MPT2SAS_TARGET *sas_target_priv_data;
+	struct _sas_device *sas_device;
+	unsigned long flags;
 
 	max_depth = shost->can_queue;
+
+	/* limit max device queue for SATA to 32 */
+	sas_device_priv_data = sdev->hostdata;
+	if (!sas_device_priv_data)
+		goto not_sata;
+	sas_target_priv_data = sas_device_priv_data->sas_target;
+	if (!sas_target_priv_data)
+		goto not_sata;
+	if ((sas_target_priv_data->flags & MPT_TARGET_FLAGS_VOLUME))
+		goto not_sata;
+	spin_lock_irqsave(&ioc->sas_device_lock, flags);
+	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
+	   sas_device_priv_data->sas_target->sas_address);
+	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
+	if (sas_device && sas_device->device_info &
+	    MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
+		max_depth = MPT2SAS_SATA_QUEUE_DEPTH;
+
+ not_sata:
+
 	if (!sdev->tagged_supported)
 		max_depth = 1;
 	if (qdepth > max_depth)
