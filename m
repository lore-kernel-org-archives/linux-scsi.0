From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/5] scsi: Deprecate SCSI_PROT_*_CONVERT operations
Date: Fri, 18 Sep 2009 17:32:59 -0400
Message-ID: <1253309583-22170-2-git-send-email-martin.petersen@oracle.com>
References: <1253309583-22170-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:29438 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbZIRVdJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2009 17:33:09 -0400
In-Reply-To: <1253309583-22170-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

The checksum format is orthogonal to whether the protection information
is being passed on beyond the HBA or not.  It is perfectly valid to use
a non-T10 CRC with WRITE_STRIP and READ_INSERT.

Consequently it no longer makes sense to explicitly refer to the
conversion in the protection operation.  Update sd_dif and lpfc
accordingly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Ihab Hamadi <Ihab.Hamadi@Emulex.Com>
---
 drivers/scsi/lpfc/lpfc_scsi.c |   15 +++------------
 drivers/scsi/sd_dif.c         |   20 ++++----------------
 include/scsi/scsi_cmnd.h      |    4 ----
 3 files changed, 7 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 61d0897..c88f59f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -56,8 +56,6 @@ static char *dif_op_str[] = {
 	"SCSI_PROT_WRITE_INSERT",
 	"SCSI_PROT_READ_PASS",
 	"SCSI_PROT_WRITE_PASS",
-	"SCSI_PROT_READ_CONVERT",
-	"SCSI_PROT_WRITE_CONVERT"
 };
 static void
 lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_scsi_buf *psb);
@@ -1131,13 +1129,11 @@ lpfc_sc_to_sli_prof(struct scsi_cmnd *sc)
 			ret_prof = LPFC_PROF_A1;
 			break;
 
-		case SCSI_PROT_READ_CONVERT:
-		case SCSI_PROT_WRITE_CONVERT:
+		case SCSI_PROT_READ_PASS:
+		case SCSI_PROT_WRITE_PASS:
 			ret_prof = LPFC_PROF_AST1;
 			break;
 
-		case SCSI_PROT_READ_PASS:
-		case SCSI_PROT_WRITE_PASS:
 		case SCSI_PROT_NORMAL:
 		default:
 			printk(KERN_ERR "Bad op/guard:%d/%d combination\n",
@@ -1157,8 +1153,6 @@ lpfc_sc_to_sli_prof(struct scsi_cmnd *sc)
 			ret_prof = LPFC_PROF_C1;
 			break;
 
-		case SCSI_PROT_READ_CONVERT:
-		case SCSI_PROT_WRITE_CONVERT:
 		case SCSI_PROT_READ_INSERT:
 		case SCSI_PROT_WRITE_STRIP:
 		case SCSI_PROT_NORMAL:
@@ -1209,8 +1203,7 @@ lpfc_get_cmd_dif_parms(struct scsi_cmnd *sc, uint16_t *apptagmask,
 	static int cnt;
 
 	if (protcnt && (op == SCSI_PROT_WRITE_STRIP ||
-				op == SCSI_PROT_WRITE_PASS ||
-				op == SCSI_PROT_WRITE_CONVERT)) {
+				op == SCSI_PROT_WRITE_PASS)) {
 
 		cnt++;
 		spt = page_address(sg_page(scsi_prot_sglist(sc))) +
@@ -1501,8 +1494,6 @@ lpfc_prot_group_type(struct lpfc_hba *phba, struct scsi_cmnd *sc)
 	case SCSI_PROT_WRITE_STRIP:
 	case SCSI_PROT_READ_PASS:
 	case SCSI_PROT_WRITE_PASS:
-	case SCSI_PROT_WRITE_CONVERT:
-	case SCSI_PROT_READ_CONVERT:
 		ret = LPFC_PG_TYPE_DIF_BUF;
 		break;
 	default:
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 82f14a9..84224dd 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -364,15 +364,9 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
  */
 void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif, unsigned int dix, unsigned int type)
 {
-	int csum_convert, prot_op;
+	int prot_op;
 
-	prot_op = 0;
-
-	/* Convert checksum? */
-	if (scsi_host_get_guard(scmd->device->host) != SHOST_DIX_GUARD_CRC)
-		csum_convert = 1;
-	else
-		csum_convert = 0;
+	prot_op = SCSI_PROT_NORMAL;
 
 	BUG_ON(dif && (scmd->cmnd[0] == READ_6 || scmd->cmnd[0] == WRITE_6));
 
@@ -382,10 +376,7 @@ void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif, unsigned int dix, unsig
 	case READ_12:
 	case READ_16:
 		if (dif && dix)
-			if (csum_convert)
-				prot_op = SCSI_PROT_READ_CONVERT;
-			else
-				prot_op = SCSI_PROT_READ_PASS;
+			prot_op = SCSI_PROT_READ_PASS;
 		else if (dif && !dix)
 			prot_op = SCSI_PROT_READ_STRIP;
 		else if (!dif && dix)
@@ -398,10 +389,7 @@ void sd_dif_op(struct scsi_cmnd *scmd, unsigned int dif, unsigned int dix, unsig
 	case WRITE_12:
 	case WRITE_16:
 		if (dif && dix)
-			if (csum_convert)
-				prot_op = SCSI_PROT_WRITE_CONVERT;
-			else
-				prot_op = SCSI_PROT_WRITE_PASS;
+			prot_op = SCSI_PROT_WRITE_PASS;
 		else if (dif && !dix)
 			prot_op = SCSI_PROT_WRITE_INSERT;
 		else if (!dif && dix)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 3878d1d..a5e885a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -229,10 +229,6 @@ enum scsi_prot_operations {
 	/* OS-HBA: Protected, HBA-Target: Protected */
 	SCSI_PROT_READ_PASS,
 	SCSI_PROT_WRITE_PASS,
-
-	/* OS-HBA: Protected, HBA-Target: Protected, checksum conversion */
-	SCSI_PROT_READ_CONVERT,
-	SCSI_PROT_WRITE_CONVERT,
 };
 
 static inline void scsi_set_prot_op(struct scsi_cmnd *scmd, unsigned char op)
-- 
1.6.0.6

