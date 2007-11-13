From: Joe Perches <joe@perches.com>
Subject: [PATCH] drivers/scsi/lpfc/ - remove ptr comparisons to 0, minor
	reformatting
Date: Tue, 13 Nov 2007 14:16:54 -0800
Message-ID: <1194992214.5163.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4580 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760913AbXKMWRL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Nov 2007 17:17:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

fix sparse warnings "Using plain integer as NULL pointer"
Use error labels for error handling

Signed-off-by: Joe Perches <joe@perches.com>

---

 drivers/scsi/lpfc/lpfc_els.c  |   64 +++++++++++++++++++++-------------------
 drivers/scsi/lpfc/lpfc_init.c |   64 +++++++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_mbox.c |   60 ++++++++++++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_sli.c  |    6 ++--
 4 files changed, 105 insertions(+), 89 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 8085900..70dec81 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -109,30 +109,23 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 
 	/* fill in BDEs for command */
 	/* Allocate buffer for command payload */
-	if (((pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL)) == 0) ||
-	    ((pcmd->virt = lpfc_mbuf_alloc(phba,
-					   MEM_PRI, &(pcmd->phys))) == 0)) {
-		kfree(pcmd);
-
-		lpfc_sli_release_iocbq(phba, elsiocb);
-		return NULL;
-	}
+	pcmd = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!pcmd)
+		goto out;
+	pcmd->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &(pcmd->phys));
+	if (!pcmd->virt)
+		goto out1;
 
 	INIT_LIST_HEAD(&pcmd->list);
 
 	/* Allocate buffer for response payload */
 	if (expectRsp) {
 		prsp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
-		if (prsp)
-			prsp->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
-						     &prsp->phys);
-		if (prsp == 0 || prsp->virt == 0) {
-			kfree(prsp);
-			lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
-			kfree(pcmd);
-			lpfc_sli_release_iocbq(phba, elsiocb);
-			return NULL;
-		}
+		if (!prsp)
+			goto out2;
+		prsp->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &prsp->phys);
+		if (!prsp->virt)
+			goto out3;
 		INIT_LIST_HEAD(&prsp->list);
 	} else {
 		prsp = NULL;
@@ -140,18 +133,12 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 
 	/* Allocate buffer for Buffer ptr list */
 	pbuflist = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
-	if (pbuflist)
-		pbuflist->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
-						 &pbuflist->phys);
-	if (pbuflist == 0 || pbuflist->virt == 0) {
-		lpfc_sli_release_iocbq(phba, elsiocb);
-		lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
-		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
-		kfree(pcmd);
-		kfree(prsp);
-		kfree(pbuflist);
-		return NULL;
-	}
+	if (!pbuflist)
+		goto out4;
+
+	pbuflist->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &pbuflist->phys);
+	if (!pbuflist->virt)
+		goto out5;
 
 	INIT_LIST_HEAD(&pbuflist->list);
 
@@ -222,6 +209,23 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 				 cmdSize);
 	}
 	return elsiocb;
+
+out5:
+	kfree(pbuflist);
+out4:
+	if (prsp) {
+		lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
+		kfree(prsp->virt);
+	}
+out3:
+	kfree(prsp);
+out2:
+	lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
+out1:
+	kfree(pcmd);
+out:
+	lpfc_sli_release_iocbq(phba, elsiocb);
+	return NULL;
 }
 
 
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ecebdfa..34013fa 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1061,7 +1061,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 /*                                                */
 /*   This routine will post count buffers to the  */
 /*   ring with the QUE_RING_BUF_CN command. This  */
-/*   allows 3 buffers / command to be posted.     */
+/*   allows 2 buffers / command to be posted.     */
 /*   Returns the number of buffers NOT posted.    */
 /**************************************************/
 int
@@ -1076,43 +1076,30 @@ lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt,
 
 	/* While there are buffers to post */
 	while (cnt > 0) {
-		/* Allocate buffer for  command iocb */
+		/* Allocate buffer for command iocb */
 		iocb = lpfc_sli_get_iocbq(phba);
-		if (iocb == NULL) {
-			pring->missbufcnt = cnt;
-			return cnt;
-		}
+		if (!iocb)
+			goto out;
 		icmd = &iocb->iocb;
 
 		/* 2 buffers can be posted per command */
 		/* Allocate buffer to post */
 		mp1 = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL);
-		if (mp1)
-		    mp1->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
-						&mp1->phys);
-		if (mp1 == 0 || mp1->virt == 0) {
-			kfree(mp1);
-			lpfc_sli_release_iocbq(phba, iocb);
-			pring->missbufcnt = cnt;
-			return cnt;
-		}
+		if (!mp1)
+			goto out1;
+		mp1->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &mp1->phys);
+		if (!mp1->virt)
+			goto out2;
 
 		INIT_LIST_HEAD(&mp1->list);
 		/* Allocate buffer to post */
 		if (cnt > 1) {
 			mp2 = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL);
-			if (mp2)
-				mp2->virt = lpfc_mbuf_alloc(phba, MEM_PRI,
-							    &mp2->phys);
-			if (mp2 == 0 || mp2->virt == 0) {
-				kfree(mp2);
-				lpfc_mbuf_free(phba, mp1->virt, mp1->phys);
-				kfree(mp1);
-				lpfc_sli_release_iocbq(phba, iocb);
-				pring->missbufcnt = cnt;
-				return cnt;
-			}
-
+			if (!mp2)
+				goto out3;
+			mp2->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &mp2->phys);
+			if (!mp2->virt)
+				goto out4;
 			INIT_LIST_HEAD(&mp2->list);
 		} else {
 			mp2 = NULL;
@@ -1135,17 +1122,12 @@ lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt,
 		icmd->ulpLe = 1;
 
 		if (lpfc_sli_issue_iocb(phba, pring, iocb, 0) == IOCB_ERROR) {
-			lpfc_mbuf_free(phba, mp1->virt, mp1->phys);
-			kfree(mp1);
 			cnt++;
 			if (mp2) {
-				lpfc_mbuf_free(phba, mp2->virt, mp2->phys);
-				kfree(mp2);
 				cnt++;
+				goto out5;
 			}
-			lpfc_sli_release_iocbq(phba, iocb);
-			pring->missbufcnt = cnt;
-			return cnt;
+			goto out3;
 		}
 		lpfc_sli_ringpostbuf_put(phba, pring, mp1);
 		if (mp2)
@@ -1153,6 +1135,20 @@ lpfc_post_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring, int cnt,
 	}
 	pring->missbufcnt = 0;
 	return 0;
+
+out5:
+	lpfc_mbuf_free(phba, mp2->virt, mp2->phys);
+out4:
+	kfree(mp2);
+out3:
+	lpfc_mbuf_free(phba, mp1->virt, mp1->phys);
+out2:
+	kfree(mp1);
+out1:
+	lpfc_sli_release_iocbq(phba, iocb);
+out:
+	pring->missbufcnt = cnt;
+	return cnt;
 }
 
 /************************************************************************/
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index a592733..9322761 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -122,7 +122,7 @@ lpfc_read_la(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, struct lpfc_dmabuf *mp)
 	 */
 	pmb->context1 = (uint8_t *) mp;
 	mb->mbxOwner = OWN_HOST;
-	return (0);
+	return 0;
 }
 
 /**********************************************/
@@ -270,15 +270,13 @@ lpfc_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, int vpi)
 
 	/* Get a buffer to hold the HBAs Service Parameters */
 
-	if (((mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL)) == 0) ||
-	    ((mp->virt = lpfc_mbuf_alloc(phba, 0, &(mp->phys))) == 0)) {
-		kfree(mp);
-		mb->mbxCommand = MBX_READ_SPARM64;
-		/* READ_SPARAM: no buffers */
-		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
-			        "0301 READ_SPARAM: no buffers\n");
-		return (1);
-	}
+	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!mp)
+		goto out;
+	mp->virt = lpfc_mbuf_alloc(phba, 0, &(mp->phys));
+	if (!mp->virt)
+		goto out1;
+
 	INIT_LIST_HEAD(&mp->list);
 	mb->mbxCommand = MBX_READ_SPARM64;
 	mb->un.varRdSparm.un.sp64.tus.f.bdeSize = sizeof (struct serv_parm);
@@ -289,7 +287,17 @@ lpfc_read_sparam(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb, int vpi)
 	/* save address for completion */
 	pmb->context1 = mp;
 
-	return (0);
+	return 0;
+
+out1:
+	kfree(mp);
+out:
+	mb->mbxCommand = MBX_READ_SPARM64;
+	/* READ_SPARAM: no buffers */
+	lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
+			"0301 READ_SPARAM: no buffers\n");
+	return 1;
+
 }
 
 /********************************************/
@@ -369,16 +377,13 @@ lpfc_reg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t did,
 	mb->mbxOwner = OWN_HOST;
 
 	/* Get a buffer to hold NPorts Service Parameters */
-	if (((mp = kmalloc(sizeof (struct lpfc_dmabuf), GFP_KERNEL)) == NULL) ||
-	    ((mp->virt = lpfc_mbuf_alloc(phba, 0, &(mp->phys))) == 0)) {
-		kfree(mp);
-		mb->mbxCommand = MBX_REG_LOGIN64;
-		/* REG_LOGIN: no buffers */
-		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
-				"0302 REG_LOGIN: no buffers, VPI:%d DID:x%x, "
-				"flag x%x\n", vpi, did, flag);
-		return (1);
-	}
+	mp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!mp)
+		goto out;
+	mp->virt = lpfc_mbuf_alloc(phba, 0, &(mp->phys));
+	if (!mp->virt)
+		goto out1;
+
 	INIT_LIST_HEAD(&mp->list);
 	sparam = mp->virt;
 
@@ -393,7 +398,18 @@ lpfc_reg_login(struct lpfc_hba *phba, uint16_t vpi, uint32_t did,
 	mb->un.varRegLogin.un.sp64.addrHigh = putPaddrHigh(mp->phys);
 	mb->un.varRegLogin.un.sp64.addrLow = putPaddrLow(mp->phys);
 
-	return (0);
+	return 0;
+
+out1:
+	kfree(mp);
+out:
+	mb->mbxCommand = MBX_REG_LOGIN64;
+	/* REG_LOGIN: no buffers */
+	lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
+			"0302 REG_LOGIN: no buffers, VPI:%d DID:x%x, "
+			"flag x%x\n", vpi, did, flag);
+	return 1;
+
 }
 
 /**********************************************/
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index ce348c5..d60bc63 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1921,8 +1921,8 @@ lpfc_sli_brdkill(struct lpfc_hba *phba)
 			"0329 Kill HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
-	if ((pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
-						  GFP_KERNEL)) == 0)
+	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!pmb)
 		return 1;
 
 	/* Disable the error attention */
@@ -3699,7 +3699,7 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq,
 	unsigned long flag;
 
 	/* The caller must leave context1 empty. */
-	if (pmboxq->context1 != 0)
+	if (pmboxq->context1)
 		return MBX_NOT_FINISHED;
 
 	/* setup wake call as IOCB callback */


