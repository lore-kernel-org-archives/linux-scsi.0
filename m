From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 08/11] zfcp: Merge FCP task management setup with regular FCP command setup
Date: Tue, 22 Feb 2011 19:54:45 +0100
Message-ID: <20110222185537.039643969@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:60844 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab1BVSzj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:39 -0500
Content-Disposition: inline; filename=708-zfcp-fcp-task-mgmnt.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

For task management commands, only LUN and flags are required. The
regular FCP setup already sets the LUN in the fcp_cmnd. All is
required for merging the function is setting up the TM flags.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_fc.h  |   22 ++++++++--------------
 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 2 files changed, 10 insertions(+), 16 deletions(-)
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -164,14 +164,21 @@ struct zfcp_fc_wka_ports {
  * zfcp_fc_scsi_to_fcp - setup FCP command with data from scsi_cmnd
  * @fcp: fcp_cmnd to setup
  * @scsi: scsi_cmnd where to get LUN, task attributes/flags and CDB
+ * @tm: task management flags to setup task management command
  */
 static inline
-void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi)
+void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
+			 u8 tm_flags)
 {
 	char tag[2];
 
 	int_to_scsilun(scsi->device->lun, (struct scsi_lun *) &fcp->fc_lun);
 
+	if (unlikely(tm_flags)) {
+		fcp->fc_tm_flags = tm_flags;
+		return;
+	}
+
 	if (scsi_populate_tag_msg(scsi, tag)) {
 		switch (tag[0]) {
 		case MSG_ORDERED_TAG:
@@ -198,19 +205,6 @@ void zfcp_fc_scsi_to_fcp(struct fcp_cmnd
 }
 
 /**
- * zfcp_fc_fcp_tm - setup FCP command as task management command
- * @fcp: fcp_cmnd to setup
- * @dev: scsi_device where to send the task management command
- * @tm: task management flags to setup tm command
- */
-static inline
-void zfcp_fc_fcp_tm(struct fcp_cmnd *fcp, struct scsi_device *dev, u8 tm_flags)
-{
-	int_to_scsilun(dev->lun, (struct scsi_lun *) &fcp->fc_lun);
-	fcp->fc_tm_flags |= tm_flags;
-}
-
-/**
  * zfcp_fc_evap_fcp_rsp - evaluate FCP RSP IU and update scsi_cmnd accordingly
  * @fcp_rsp: FCP RSP IU to evaluate
  * @scsi: SCSI command where to update status and sense buffer
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2210,7 +2210,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *
 	zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction);
 
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
-	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
+	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd, 0);
 
 	if (scsi_prot_sg_count(scsi_cmnd)) {
 		zfcp_qdio_set_data_div(qdio, &req->qdio_req,
@@ -2299,7 +2299,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_m
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
-	zfcp_fc_fcp_tm(fcp_cmnd, scmnd->device, tm_flags);
+	zfcp_fc_scsi_to_fcp(fcp_cmnd, scmnd, tm_flags);
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
 	if (!zfcp_fsf_req_send(req))

