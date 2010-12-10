From: Maggie Zhang <xmzhang@brocade.com>
Subject: [PATCH 4/7] bfa: scatter gather processing change
Date: Thu, 9 Dec 2010 19:10:27 -0800
Message-ID: <1291950627-13965-1-git-send-email-xmzhang@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56111 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab0LJDpZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Dec 2010 22:45:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@blc-10-10.brocade.com, Maggie Zhang <xmzhang@brocade.com>, Jing Huang <huangj@brocade.com>

Modified scatter gather processing to use the kernel provided scsi_for_each_sg() macro.

1) Instead of allocating and setting up sgpg in bfa_ioim_sge_setup(), we only do allocation. 
As a result, we remove bfa_ioim_sgpg_setup() and rename bfa_ioim_sge_setup() to bfa_ioim_sgpg_alloc().

2) bfa_ioim_send_ioreq() call scsi_for_each_sg() to handle both inline and sgpg setup.

Signed-off-by: Maggie Zhang <xmzhang@brocade.com>
Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_fcpim.c |  140 ++++++++++++++++++------------------------
 1 files changed, 59 insertions(+), 81 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index d6aea5d..898864a 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -218,8 +218,7 @@ static void     bfa_itnim_sm_deleting_qfull(struct bfa_itnim_s *itnim,
  * forward declaration for BFA IOIM functions
  */
 static bfa_boolean_t	bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim);
-static bfa_boolean_t	bfa_ioim_sge_setup(struct bfa_ioim_s *ioim);
-static void		bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim);
+static bfa_boolean_t	bfa_ioim_sgpg_alloc(struct bfa_ioim_s *ioim);
 static bfa_boolean_t	bfa_ioim_send_abort(struct bfa_ioim_s *ioim);
 static void		bfa_ioim_notify_cleanup(struct bfa_ioim_s *ioim);
 static void __bfa_cb_ioim_good_comp(void *cbarg, bfa_boolean_t complete);
@@ -1621,7 +1620,7 @@ bfa_ioim_sm_uninit(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 		}
 
 		if (ioim->nsges > BFI_SGE_INLINE) {
-			if (!bfa_ioim_sge_setup(ioim)) {
+			if (!bfa_ioim_sgpg_alloc(ioim)) {
 				bfa_sm_set_state(ioim, bfa_ioim_sm_sgalloc);
 				return;
 			}
@@ -2304,7 +2303,7 @@ bfa_ioim_sgpg_alloced(void *cbarg)
 
 	ioim->nsgpgs = BFA_SGPG_NPAGE(ioim->nsges);
 	list_splice_tail_init(&ioim->iosp->sgpg_wqe.sgpg_q, &ioim->sgpg_q);
-	bfa_ioim_sgpg_setup(ioim);
+	ioim->sgpg = bfa_q_first(&ioim->sgpg_q);
 	bfa_sm_send_event(ioim, BFA_IOIM_SM_SGALLOCED);
 }
 
@@ -2317,12 +2316,14 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	struct bfa_itnim_s *itnim = ioim->itnim;
 	struct bfi_ioim_req_s *m;
 	static struct fcp_cmnd_s cmnd_z0 = { 0 };
-	struct bfi_sge_s      *sge;
+	struct bfi_sge_s *sge, *sgpge;
 	u32	pgdlen = 0;
 	u32	fcp_dl;
 	u64 addr;
 	struct scatterlist *sg;
+	struct bfa_sgpg_s *sgpg;
 	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) ioim->dio;
+	u32 i, sge_id, pgcumsz;
 
 	/*
 	 * check for room in queue to send request now
@@ -2342,20 +2343,59 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
 	m->rport_hdl = ioim->itnim->rport->fw_handle;
 	m->io_timeout = bfa_cb_ioim_get_timeout(ioim->dio);
 
-	/*
-	 * build inline IO SG element here
-	 */
 	sge = &m->sges[0];
-	if (ioim->nsges) {
-		sg = (struct scatterlist *)scsi_sglist(cmnd);
-		addr = bfa_os_sgaddr(sg_dma_address(sg));
-		sge->sga = *(union bfi_addr_u *) &addr;
-		pgdlen = sg_dma_len(sg);
-		sge->sg_len = pgdlen;
-		sge->flags = (ioim->nsges > BFI_SGE_INLINE) ?
+	sgpg = ioim->sgpg;
+	sge_id = 0;
+	sgpge = NULL;
+	pgcumsz = 0;
+	scsi_for_each_sg(cmnd, sg, ioim->nsges, i) {
+		if (i == 0) {
+			/* build inline IO SG element */
+			addr = bfa_os_sgaddr(sg_dma_address(sg));
+			sge->sga = *(union bfi_addr_u *) &addr;
+			pgdlen = sg_dma_len(sg);
+			sge->sg_len = pgdlen;
+			sge->flags = (ioim->nsges > BFI_SGE_INLINE) ?
 					BFI_SGE_DATA_CPL : BFI_SGE_DATA_LAST;
-		bfa_sge_to_be(sge);
-		sge++;
+			bfa_sge_to_be(sge);
+			sge++;
+		} else {
+			if (sge_id == 0)
+				sgpge = sgpg->sgpg->sges;
+
+			addr = bfa_os_sgaddr(sg_dma_address(sg));
+			sgpge->sga = *(union bfi_addr_u *) &addr;
+			sgpge->sg_len = sg_dma_len(sg);
+			pgcumsz += sgpge->sg_len;
+
+			/* set flags */
+			if (i < (ioim->nsges - 1) &&
+					sge_id < (BFI_SGPG_DATA_SGES - 1))
+				sgpge->flags = BFI_SGE_DATA;
+			else if (i < (ioim->nsges - 1))
+				sgpge->flags = BFI_SGE_DATA_CPL;
+			else
+				sgpge->flags = BFI_SGE_DATA_LAST;
+
+			bfa_sge_to_le(sgpge);
+
+			sgpge++;
+			if (i == (ioim->nsges - 1)) {
+                        	sgpge->flags = BFI_SGE_PGDLEN;
+                        	sgpge->sga.a32.addr_lo = 0;
+                        	sgpge->sga.a32.addr_hi = 0;
+                		sgpge->sg_len = pgcumsz;
+                		bfa_sge_to_le(sgpge);
+                	} else if (++sge_id == BFI_SGPG_DATA_SGES) {
+				sgpg = (struct bfa_sgpg_s *) bfa_q_next(sgpg);
+                        	sgpge->flags = BFI_SGE_LINK;
+                        	sgpge->sga = sgpg->sgpg_pa;
+                		sgpge->sg_len = pgcumsz;
+                		bfa_sge_to_le(sgpge);
+				sge_id = 0;
+				pgcumsz = 0;
+                	}
+		}
 	}
 
 	if (ioim->nsges > BFI_SGE_INLINE) {
@@ -2414,7 +2454,7 @@ bfa_ioim_send_ioreq(struct bfa_ioim_s *ioim)
  * at queuing time.
  */
 static bfa_boolean_t
-bfa_ioim_sge_setup(struct bfa_ioim_s *ioim)
+bfa_ioim_sgpg_alloc(struct bfa_ioim_s *ioim)
 {
 	u16	nsgpgs;
 
@@ -2434,73 +2474,11 @@ bfa_ioim_sge_setup(struct bfa_ioim_s *ioim)
 	}
 
 	ioim->nsgpgs = nsgpgs;
-	bfa_ioim_sgpg_setup(ioim);
+	ioim->sgpg = bfa_q_first(&ioim->sgpg_q);
 
 	return BFA_TRUE;
 }
 
-static void
-bfa_ioim_sgpg_setup(struct bfa_ioim_s *ioim)
-{
-	int		sgeid, nsges, i;
-	struct bfi_sge_s      *sge;
-	struct bfa_sgpg_s *sgpg;
-	u32	pgcumsz;
-	u64        addr;
-	struct scatterlist *sg;
-	struct scsi_cmnd *cmnd = (struct scsi_cmnd *) ioim->dio;
-
-	sgeid = BFI_SGE_INLINE;
-	ioim->sgpg = sgpg = bfa_q_first(&ioim->sgpg_q);
-
-	sg = scsi_sglist(cmnd);
-	sg = sg_next(sg);
-
-	do {
-		sge = sgpg->sgpg->sges;
-		nsges = ioim->nsges - sgeid;
-		if (nsges > BFI_SGPG_DATA_SGES)
-			nsges = BFI_SGPG_DATA_SGES;
-
-		pgcumsz = 0;
-		for (i = 0; i < nsges; i++, sge++, sgeid++, sg = sg_next(sg)) {
-			addr = bfa_os_sgaddr(sg_dma_address(sg));
-			sge->sga = *(union bfi_addr_u *) &addr;
-			sge->sg_len = sg_dma_len(sg);
-			pgcumsz += sge->sg_len;
-
-			/*
-			 * set flags
-			 */
-			if (i < (nsges - 1))
-				sge->flags = BFI_SGE_DATA;
-			else if (sgeid < (ioim->nsges - 1))
-				sge->flags = BFI_SGE_DATA_CPL;
-			else
-				sge->flags = BFI_SGE_DATA_LAST;
-
-			bfa_sge_to_le(sge);
-		}
-
-		sgpg = (struct bfa_sgpg_s *) bfa_q_next(sgpg);
-
-		/*
-		 * set the link element of each page
-		 */
-		if (sgeid == ioim->nsges) {
-			sge->flags = BFI_SGE_PGDLEN;
-			sge->sga.a32.addr_lo = 0;
-			sge->sga.a32.addr_hi = 0;
-		} else {
-			sge->flags = BFI_SGE_LINK;
-			sge->sga = sgpg->sgpg_pa;
-		}
-		sge->sg_len = pgcumsz;
-
-		bfa_sge_to_le(sge);
-	} while (sgeid < ioim->nsges);
-}
-
 /*
  * Send I/O abort request to firmware.
  */
-- 
1.7.2.1

