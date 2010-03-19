From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/5] bfa: fix the issue of not handling scsi_cmnd sg chaining case
Date: Fri, 19 Mar 2010 11:06:05 -0700
Message-ID: <1269021965-11013-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:54860 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391Ab0CSSVv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Mar 2010 14:21:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, huangj@brocade.com

Currently the driver doesn't take into consideraion of possible sg chaining
when it walks through the sg list. This is fixed by using the sg_next()
which automatically handles the chaining case. Obosolete code is removed
as a result of this change.  

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_cb_ioim_macros.h |   29 -----------------------------
 drivers/scsi/bfa/bfa_ioim.c           |   22 +++++++++++++++++-----
 2 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_cb_ioim_macros.h b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
index 961fe43..53a616f 100644
--- a/drivers/scsi/bfa/bfa_cb_ioim_macros.h
+++ b/drivers/scsi/bfa/bfa_cb_ioim_macros.h
@@ -117,35 +117,6 @@ bfa_cb_ioim_get_timeout(struct bfad_ioim_s *dio)
 }
 
 /**
- * Get SG element for the I/O request given the SG element index
- */
-static inline union bfi_addr_u
-bfa_cb_ioim_get_sgaddr(struct bfad_ioim_s *dio, int sgeid)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
-	struct scatterlist *sge;
-	u64        addr;
-
-	sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
-	addr = (u64) sg_dma_address(sge);
-
-	return *((union bfi_addr_u *) &addr);
-}
-
-static inline u32
-bfa_cb_ioim_get_sglen(struct bfad_ioim_s *dio, int sgeid)
-{
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *)dio;
-	struct scatterlist *sge;
-	u32        len;
-
-	sge = (struct scatterlist *)scsi_sglist(cmnd) + sgeid;
-	len = sg_dma_len(sge);
-
-	return len;
-}
-
-/**
  * Get Command Reference Number for the I/O request. 0 if none.
  */
 static inline u8
diff --git a/drivers/scsi/bfa/bfa_ioim.c b/drivers/scsi/bfa/bfa_ioim.c
index 5b107ab..8a1be20 100644
--- a/drivers/scsi/bfa/bfa_ioim.c
+++ b/drivers/scsi/bfa/bfa_ioim.c
@@ -731,6 +731,9 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	static struct fcp_cmnd_s cmnd_z0 = { 0 };
 	struct bfi_sge_s      *sge;
 	u32        pgdlen = 0;
+	u64 addr;
+	struct scatterlist *sg;
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) ioim->dio;
 
 	/**
 	 * check for room in queue to send request now
@@ -754,8 +757,10 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	 */
 	sge = &m->sges[0];
 	if (ioim->nsges) {
-		sge->sga = bfa_cb_ioim_get_sgaddr(ioim->dio, 0);
-		pgdlen = bfa_cb_ioim_get_sglen(ioim->dio, 0);
+		sg = (struct scatterlist *)scsi_sglist(cmnd);
+		addr = (u64) sg_dma_address(sg);
+		sge->sga = *(union bfi_addr_u *) &addr;
+		pgdlen = sg_dma_len(sg);
 		sge->sg_len = pgdlen;
 		sge->flags = (ioim->nsges > BFI_SGE_INLINE) ?
 					BFI_SGE_DATA_CPL : BFI_SGE_DATA_LAST;
@@ -868,10 +873,16 @@ bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
 	struct bfi_sge_s      *sge;
 	struct bfa_sgpg_s *sgpg;
 	u32        pgcumsz;
+	u64        addr;
+	struct scatterlist *sg;
+	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) ioim->dio;
 
 	sgeid = BFI_SGE_INLINE;
 	ioim->sgpg = sgpg = bfa_q_first(&ioim->sgpg_q);
 
+	sg = scsi_sglist(cmnd);
+	sg = sg_next(sg);
+
 	do {
 		sge = sgpg->sgpg->sges;
 		nsges = ioim->nsges - sgeid;
@@ -879,9 +890,10 @@ bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
 			nsges = BFI_SGPG_DATA_SGES;
 
 		pgcumsz = 0;
-		for (i = 0; i < nsges; i++, sge++, sgeid++) {
-			sge->sga = bfa_cb_ioim_get_sgaddr(ioim->dio, sgeid);
-			sge->sg_len = bfa_cb_ioim_get_sglen(ioim->dio, sgeid);
+		for (i = 0; i < nsges; i++, sge++, sgeid++, sg = sg_next(sg)) {
+			addr = (u64) sg_dma_address(sg);
+			sge->sga = *(union bfi_addr_u *) &addr;
+			sge->sg_len = sg_dma_len(sg);
 			pgcumsz += sge->sg_len;
 
 			/**
-- 
1.6.5.2

