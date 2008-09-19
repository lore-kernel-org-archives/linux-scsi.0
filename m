From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1 of 3] sd: Issue correct protection operation
Date: Fri, 19 Sep 2008 18:47:19 -0400
Message-ID: <7254e25b30fb2f0ba12a.1221864439@sermon.lab.mkp.net>
References: <patchbomb.1221864438@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:48234 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbYISW6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Sep 2008 18:58:54 -0400
In-Reply-To: <patchbomb.1221864438@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Use the same logic to prepare RD/WRPROTECT and the protection
operation.  Fixes a corner case where we could issue an unprotected
CDB and yet tell the HBA to do DIF to the drive.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
1 file changed, 4 insertions(+), 3 deletions(-)
drivers/scsi/sd.c |    7 ++++---



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


