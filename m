From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/7] mptsas : Use max_id to infinite value.
Date: Wed, 5 Aug 2009 12:52:58 +0530
Message-ID: <20090805072245.GF14031@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:45512 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896AbZHEHn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 03:43:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Do not set max_id value received from FW. Once SAS transport layer is
introduced max_id value is missleading to SCSI mid layer. Use max_id to
infinite value.

logic of can queue of scsi host is changed.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 936e35a..a63810c 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4761,10 +4761,9 @@ mptsas_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* set 16 byte cdb's */
 	sh->max_cmd_len = 16;
-
-	sh->max_id = ioc->pfacts[0].PortSCSIID;
+	sh->can_queue = min_t(int, ioc->req_depth - 10, sh->can_queue);
+	sh->max_id = -1;
 	sh->max_lun = max_lun;
-
 	sh->transportt = mptsas_transport_template;
 
 	/* Required entry.
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 1466a5a..0e402eb 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2290,7 +2290,10 @@ mptscsih_change_queue_depth(struct scsi_device *sdev, int qdepth)
 		else
 			max_depth = MPT_SCSI_CMD_PER_DEV_LOW;
 	} else
-		max_depth = MPT_SCSI_CMD_PER_DEV_HIGH;
+		 max_depth = ioc->sh->can_queue;
+
+	if (!sdev->tagged_supported)
+		max_depth = 1;
 
 	if (qdepth > max_depth)
 		qdepth = max_depth;
