From: James Smart <james.smart@emulex.com>
Subject: [PATCH 05/12] lpfc 8.3.34: Simplify BlockGuard lpfc_printf_vlog
 messages
Date: Tue, 14 Aug 2012 14:25:50 -0400
Message-ID: <1344968750.4432.20.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24935 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2HNS0O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Simplify BlockGuard lpfc_printf_vlog messages


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   58 ++++++++++++++--------------------------------------------
 1 file changed, 14 insertions(+), 44 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:51.928924265 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:52.078924258 -0400
@@ -60,12 +60,6 @@ static char *dif_op_str[] = {
 	"PROT_WRITE_PASS",
 };
 
-static char *dif_grd_str[] = {
-	"NO_GUARD",
-	"DIF_CRC",
-	"DIX_IP",
-};
-
 struct scsi_dif_tuple {
 	__be16 guard_tag;       /* Checksum */
 	__be16 app_tag;         /* Opaque storage */
@@ -4311,49 +4305,25 @@ lpfc_queuecommand(struct Scsi_Host *shos
 
 	if (scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
 		if (vport->phba->cfg_enable_bg) {
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-				"9033 BLKGRD: rcvd protected cmd:%02x op=%s "
-				"guard=%s\n", cmnd->cmnd[0],
-				dif_op_str[scsi_get_prot_op(cmnd)],
-				dif_grd_str[scsi_host_get_guard(shost)]);
-			if (cmnd->cmnd[0] == READ_10)
-				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-					"9035 BLKGRD: READ @ sector %llu, "
-					"cnt %u, rpt %d\n",
-					(unsigned long long)scsi_get_lba(cmnd),
-					blk_rq_sectors(cmnd->request),
-					(cmnd->cmnd[1]>>5));
-			else if (cmnd->cmnd[0] == WRITE_10)
-				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-					"9036 BLKGRD: WRITE @ sector %llu, "
-					"cnt %u, wpt %d\n",
-					(unsigned long long)scsi_get_lba(cmnd),
-					blk_rq_sectors(cmnd->request),
-					(cmnd->cmnd[1]>>5));
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_BG,
+					 "9033 BLKGRD: rcvd %s cmd:x%x "
+					 "sector x%llx cnt %u pt %x\n",
+					 dif_op_str[scsi_get_prot_op(cmnd)],
+					 cmnd->cmnd[0],
+					 (unsigned long long)scsi_get_lba(cmnd),
+					 blk_rq_sectors(cmnd->request),
+					 (cmnd->cmnd[1]>>5));
 		}
-
 		err = lpfc_bg_scsi_prep_dma_buf(phba, lpfc_cmd);
 	} else {
 		if (vport->phba->cfg_enable_bg) {
-			lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-				"9038 BLKGRD: rcvd unprotected cmd:"
-				"%02x op=%s guard=%s\n", cmnd->cmnd[0],
-				dif_op_str[scsi_get_prot_op(cmnd)],
-				dif_grd_str[scsi_host_get_guard(shost)]);
-			if (cmnd->cmnd[0] == READ_10)
-				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-					"9040 dbg: READ @ sector %llu, "
-					"cnt %u, rpt %d\n",
-					(unsigned long long)scsi_get_lba(cmnd),
+			lpfc_printf_vlog(vport, KERN_INFO, LOG_BG,
+					 "9038 BLKGRD: rcvd PROT_NORMAL cmd: "
+					 "x%x sector x%llx cnt %u pt %x\n",
+					 cmnd->cmnd[0],
+					 (unsigned long long)scsi_get_lba(cmnd),
 					 blk_rq_sectors(cmnd->request),
-					(cmnd->cmnd[1]>>5));
-			else if (cmnd->cmnd[0] == WRITE_10)
-				lpfc_printf_vlog(vport, KERN_WARNING, LOG_BG,
-					"9041 dbg: WRITE @ sector %llu, "
-					"cnt %u, wpt %d\n",
-					(unsigned long long)scsi_get_lba(cmnd),
-					blk_rq_sectors(cmnd->request),
-					(cmnd->cmnd[1]>>5));
+					 (cmnd->cmnd[1]>>5));
 		}
 		err = lpfc_scsi_prep_dma_buf(phba, lpfc_cmd);
 	}



