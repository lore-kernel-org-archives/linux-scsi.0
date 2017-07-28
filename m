From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 15/22] zfcp: use common code fcp_cmnd and fcp_resp with union in fsf_qtcb_bottom_io
Date: Fri, 28 Jul 2017 12:31:01 +0200
Message-ID: <a8ebb2d5f6436063a6cc2560b676957178c3cae1.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35925 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751937AbdG1KbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:16 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SATF3v124565
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:15 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2byuv9t6rm-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:15 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:13 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAVBmJ39190720
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:11 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E79611C08E
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:23 +0100 (BST)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5177011C092
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:23 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:28:23 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Steffen Maier <maier@linux.vnet.ibm.com>

This eases crash dump analysis by automatically dissecting these
protocol headers at least somewhat rather than getting a string
interpretation of large unstructured character array buffer fields.

Also, we can get rid of some unnecessary and error-prone type casts.

This change is possible since v2.6.33 commit 4318e08c84e4
("[SCSI] zfcp: Update FCP protocol related code").

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |  3 +--
 drivers/s390/scsi/zfcp_dbf.h |  2 +-
 drivers/s390/scsi/zfcp_fsf.c | 10 ++++++----
 drivers/s390/scsi/zfcp_fsf.h | 12 +++++++++---
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 34367d172961..225e60d5d3fc 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -573,8 +573,7 @@ void zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *sc,
 	if (fsf) {
 		rec->fsf_req_id = fsf->req_id;
 		rec->pl_len = FCP_RESP_WITH_EXT;
-		fcp_rsp = (struct fcp_resp_with_ext *)
-				&(fsf->qtcb->bottom.io.fcp_rsp);
+		fcp_rsp = &(fsf->qtcb->bottom.io.fcp_rsp.iu);
 		/* mandatory parts of FCP_RSP IU in this SCSI record */
 		memcpy(&rec->fcp_rsp, fcp_rsp, FCP_RESP_WITH_EXT);
 		if (fcp_rsp->resp.fr_flags & FCP_RSP_LEN_VAL) {
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index b60667c145fd..33ccf15b63e0 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -301,7 +301,7 @@ bool zfcp_dbf_hba_fsf_resp_suppress(struct zfcp_fsf_req *req)
 
 	if (qtcb->prefix.qtcb_type != FSF_IO_COMMAND)
 		return false; /* not an FCP response */
-	fcp_rsp = (struct fcp_resp *)&qtcb->bottom.io.fcp_rsp;
+	fcp_rsp = &qtcb->bottom.io.fcp_rsp.iu.resp;
 	rsp_flags = fcp_rsp->fr_flags;
 	fr_status = fcp_rsp->fr_status;
 	return (fsf_stat == FSF_FCP_RSP_AVAILABLE) &&
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 9f73b8fc7f3b..6ddaee5f3701 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2143,7 +2143,8 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 		zfcp_scsi_dif_sense_error(scpnt, 0x3);
 		goto skip_fsfstatus;
 	}
-	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
+	BUILD_BUG_ON(sizeof(struct fcp_resp_with_ext) > FSF_FCP_RSP_SIZE);
+	fcp_rsp = &req->qtcb->bottom.io.fcp_rsp.iu;
 	zfcp_fc_eval_fcp_rsp(fcp_rsp, scpnt);
 
 skip_fsfstatus:
@@ -2256,7 +2257,8 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 	if (zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction))
 		goto failed_scsi_cmnd;
 
-	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
+	BUILD_BUG_ON(sizeof(struct fcp_cmnd) > FSF_FCP_CMND_SIZE);
+	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd, 0);
 
 	if ((scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) &&
@@ -2301,7 +2303,7 @@ static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
 
 	zfcp_fsf_fcp_handler_common(req);
 
-	fcp_rsp = (struct fcp_resp_with_ext *) &req->qtcb->bottom.io.fcp_rsp;
+	fcp_rsp = &req->qtcb->bottom.io.fcp_rsp.iu;
 	rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
 
 	if ((rsp_info->rsp_code != FCP_TMF_CMPL) ||
@@ -2350,7 +2352,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
-	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
+	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scmnd, tm_flags);
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index ea3c76ac0de1..88feba5bfda4 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -3,7 +3,7 @@
  *
  * Interface to the FSF support functions.
  *
- * Copyright IBM Corp. 2002, 2016
+ * Copyright IBM Corp. 2002, 2017
  */
 
 #ifndef FSF_H
@@ -312,8 +312,14 @@ struct fsf_qtcb_bottom_io {
 	u32 data_block_length;
 	u32 prot_data_length;
 	u8  res2[4];
-	u8  fcp_cmnd[FSF_FCP_CMND_SIZE];
-	u8  fcp_rsp[FSF_FCP_RSP_SIZE];
+	union {
+		u8		byte[FSF_FCP_CMND_SIZE];
+		struct fcp_cmnd iu;
+	}   fcp_cmnd;
+	union {
+		u8			 byte[FSF_FCP_RSP_SIZE];
+		struct fcp_resp_with_ext iu;
+	}   fcp_rsp;
 	u8  res3[64];
 } __attribute__ ((packed));
 
-- 
2.11.2
