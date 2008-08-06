From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Issue correct protection operation
Date: Wed, 06 Aug 2008 14:07:01 -0400
Message-ID: <yq13alivwze.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:57511 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbYHFSHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 14:07:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com


Use the same logic to prepare RD/WRPROTECT and the protection
operation.  Fixes a corner case where we could issue an unprotected
CDB and yet tell the HBA to do DIF to the drive.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -378,7 +378,7 @@ static int sd_prep_fn(struct request_que
 	sector_t threshold;
 	unsigned int this_count = rq->nr_sectors;
 	unsigned int timeout = sdp->timeout;
-	int ret;
+	int ret, host_dif;
 
 	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
@@ -509,7 +509,8 @@ static int sd_prep_fn(struct request_que
 					rq->nr_sectors));
 
 	/* Set RDPROTECT/WRPROTECT if disk is formatted with DIF */
-	if (scsi_host_dif_capable(sdp->host, sdkp->protection_type))
+	host_dif = scsi_host_dif_capable(sdp->host, sdkp->protection_type);
+	if (host_dif)
 		SCpnt->cmnd[1] = 1 << 5;
 	else
 		SCpnt->cmnd[1] = 0;
@@ -567,7 +568,7 @@ static int sd_prep_fn(struct request_que
 	SCpnt->sdb.length = this_count * sdp->sector_size;
 
 	/* If DIF or DIX is enabled, tell HBA how to handle request */
-	if (sdkp->protection_type || scsi_prot_sg_count(SCpnt))
+	if (host_dif || scsi_prot_sg_count(SCpnt))
 		sd_dif_op(SCpnt, sdkp->protection_type, scsi_prot_sg_count(SCpnt));
 
 	/*
