From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/11] lpfc 8.3.37: Provide support for change_queue_type
Date: Thu, 3 Jan 2013 15:43:03 -0500
Message-ID: <1357245783.2628.15.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:27018 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3ACUss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:48:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Provide support for change_queue_type method in scsi_host_template


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-12-12 13:32:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-01-02 16:26:35.665352067 -0500
@@ -288,6 +288,26 @@ lpfc_change_queue_depth(struct scsi_devi
 }
 
 /**
+ * lpfc_change_queue_type() - Change a device's scsi tag queuing type
+ * @sdev: Pointer the scsi device whose queue depth is to change
+ * @tag_type: Identifier for queue tag type
+ */
+static int
+lpfc_change_queue_type(struct scsi_device *sdev, int tag_type)
+{
+	if (sdev->tagged_supported) {
+		scsi_set_tag_type(sdev, tag_type);
+		if (tag_type)
+			scsi_activate_tcq(sdev, sdev->queue_depth);
+		else
+			scsi_deactivate_tcq(sdev, sdev->queue_depth);
+	} else
+		tag_type = 0;
+
+	return tag_type;
+}
+
+/**
  * lpfc_rampdown_queue_depth - Post RAMP_DOWN_QUEUE event to worker thread
  * @phba: The Hba for which this call is being executed.
  *
@@ -3972,7 +3992,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 			break;
 		}
 	} else
-		fcp_cmnd->fcpCntl1 = 0;
+		fcp_cmnd->fcpCntl1 = SIMPLE_Q;
 
 	sli4 = (phba->sli_rev == LPFC_SLI_REV4);
 
@@ -5150,6 +5170,7 @@ struct scsi_host_template lpfc_template
 	.max_sectors		= 0xFFFF,
 	.vendor_id		= LPFC_NL_VENDOR_ID,
 	.change_queue_depth	= lpfc_change_queue_depth,
+	.change_queue_type	= lpfc_change_queue_type,
 };
 
 struct scsi_host_template lpfc_vport_template = {
@@ -5172,4 +5193,5 @@ struct scsi_host_template lpfc_vport_tem
 	.shost_attrs		= lpfc_vport_attrs,
 	.max_sectors		= 0xFFFF,
 	.change_queue_depth	= lpfc_change_queue_depth,
+	.change_queue_type	= lpfc_change_queue_type,
 };



