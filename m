Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF01C41604
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 20:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85A252076A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 20:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UU0HIyL2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438483AbgJTU1i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 16:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438481AbgJTU1i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 16:27:38 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E89C0613CE
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 13:27:38 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id j7so45606pgk.5
        for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2020 13:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=CHTW+PsRF5FB59I3e5ygYbg/8stoN+CHgQHp2Pq9gF8=;
        b=UU0HIyL2G4Jlu162tlWwUyRXikmiaf3ptc/aUhT1Mgg3WoPBAegfGAmkwkKHSCKkRo
         pNBs77U/UW33Nfl48M5tp7s1zgbVK+WI1EGY3tys1mEXkFFbtcHdGY5OioiaHhGQp+/y
         imFJG+QcuYIB3hY4umG5h9PeJ0unQxGxwF9E8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=CHTW+PsRF5FB59I3e5ygYbg/8stoN+CHgQHp2Pq9gF8=;
        b=gT1KRtinkc2MNpKBrBZZfpNWn91vcIYVYDTnpBsxfJIvlOUhW+gztO1eAo+fSb8Xr2
         M2Taa45Zr8CtXB8JxlNkdkHeUI/kGV/JwMkGUwxgSDfjXwVQvqaMv4RaojBsaXgWghFx
         L2eLPErLovIwu7jFMI+BdR+keGbtxvdA6IBSU0QwWXTiwRWgixDJZ/70EcWUpb6eI+pe
         QxzgemBEe0buqI5whcv2y1TD3GAMa38QEEG69+nVgG0xRD6uBczwDwbWo5zMpQBXlFtI
         7gf84x/UzOpa4CIPIZ9d9FsIz1DiLa433oKzgZymyAy/EiRT8mmTVGZo0TRjcnfZOQmu
         Pz5g==
X-Gm-Message-State: AOAM533Swyj1M23jMHXcszttFpV9h+O4aFOCCCPTd+YaRC1xmQyLRZqM
        ZuMHWLGSgtifN/PB5oPe1jMMVdgBR2qp80vvUaZDbui1U/KqNYyHCZHStx6xViBKiVXektfHHqq
        4UdmX3iEqLBNoxx3rAuNPFa28CfUv7RaK+Z6S30b71nM5ayy0Q3Fz+SArxm2LfwBqJAMMeozH+K
        3+u2w=
X-Google-Smtp-Source: ABdhPJwrg1RfHCoYZ4hhPtGduz91klKL9TDxlDt0cHSEdIzZ3gCzjh8yFzUXxnX2Tw2BZ8HtfqHiKw==
X-Received: by 2002:a63:4e5e:: with SMTP id o30mr64940pgl.251.1603225656799;
        Tue, 20 Oct 2020 13:27:36 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b16sm2871404pfp.195.2020.10.20.13.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 13:27:36 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 8/9] lpfc: Reject CT request for MIB commands
Date:   Tue, 20 Oct 2020 13:27:18 -0700
Message-Id: <20201020202719.54726-9-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020202719.54726-1-james.smart@broadcom.com>
References: <20201020202719.54726-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000cee8f805b2200f4a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000cee8f805b2200f4a
Content-Transfer-Encoding: 8bit

Now that MIB support was registered with FDMI, the driver may receive
CT requests for MIB-related commands. At this time, no command is
supported. However, the driver needs to be graceful and reject the
CT request.

This patch adds identification of the requests as well as sending the
reject response.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c |  21 +--
 drivers/scsi/lpfc/lpfc_ct.c  | 311 ++++++++++++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_hw.h  |   3 +
 3 files changed, 296 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 6f9d648a9b9c..5b66b8ea8363 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -939,28 +939,9 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	INIT_LIST_HEAD(&head);
 	list_add_tail(&head, &piocbq->list);
 
-	if (piocbq->iocb.ulpBdeCount == 0 ||
-	    piocbq->iocb.un.cont64[0].tus.f.bdeSize == 0)
-		goto error_ct_unsol_exit;
-
-	if (phba->link_state == LPFC_HBA_ERROR ||
-		(!(phba->sli.sli_flag & LPFC_SLI_ACTIVE)))
-		goto error_ct_unsol_exit;
-
-	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
-		dmabuf = bdeBuf1;
-	else {
-		dma_addr = getPaddr(piocbq->iocb.un.cont64[0].addrHigh,
-				    piocbq->iocb.un.cont64[0].addrLow);
-		dmabuf = lpfc_sli_ringpostbuf_get(phba, pring, dma_addr);
-	}
-	if (dmabuf == NULL)
-		goto error_ct_unsol_exit;
-	ct_req = (struct lpfc_sli_ct_request *)dmabuf->virt;
+	ct_req = (struct lpfc_sli_ct_request *)bdeBuf1;
 	evt_req_id = ct_req->FsType;
 	cmd = ct_req->CommandResponse.bits.CmdRsp;
-	if (!(phba->sli3_options & LPFC_SLI3_HBQ_ENABLED))
-		lpfc_sli_ringpostbuf_put(phba, pring, dmabuf);
 
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index bff7d0b3ce7b..d7811fa2407c 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -99,21 +99,265 @@ lpfc_ct_unsol_buffer(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq,
 	lpfc_ct_ignore_hbq_buffer(phba, piocbq, mp, size);
 }
 
+/**
+ * lpfc_ct_unsol_cmpl : Completion callback function for unsol ct commands
+ * @phba : pointer to lpfc hba data structure.
+ * @cmdiocb : pointer to lpfc command iocb data structure.
+ * @rspiocb : pointer to lpfc response iocb data structure.
+ *
+ * This routine is the callback function for issuing unsol ct reject command.
+ * The memory allocated in the reject command path is freed up here.
+ **/
+static void
+lpfc_ct_unsol_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
+		   struct lpfc_iocbq *rspiocb)
+{
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_dmabuf *mp, *bmp;
+
+	ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
+	if (ndlp)
+		lpfc_nlp_put(ndlp);
+
+	mp = cmdiocb->context2;
+	bmp = cmdiocb->context3;
+	if (mp) {
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
+		kfree(mp);
+		cmdiocb->context2 = NULL;
+	}
+
+	if (bmp) {
+		lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
+		kfree(bmp);
+		cmdiocb->context3 = NULL;
+	}
+
+	lpfc_sli_release_iocbq(phba, cmdiocb);
+}
+
+/**
+ * lpfc_ct_reject_event : Issue reject for unhandled CT MIB commands
+ * @ndlp : pointer to a node-list data structure.
+ * ct_req : pointer to the CT request data structure.
+ * rx_id : rx_id of the received UNSOL CT command
+ * ox_id : ox_id of the UNSOL CT command
+ *
+ * This routine is invoked by the lpfc_ct_handle_mibreq routine for sending
+ * a reject response. Reject response is sent for the unhandled commands.
+ **/
+static void
+lpfc_ct_reject_event(struct lpfc_nodelist *ndlp,
+		     struct lpfc_sli_ct_request *ct_req,
+		     u16 rx_id, u16 ox_id)
+{
+	struct lpfc_vport *vport = ndlp->vport;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_sli_ct_request *ct_rsp;
+	struct lpfc_iocbq *cmdiocbq = NULL;
+	struct lpfc_dmabuf *bmp = NULL;
+	struct lpfc_dmabuf *mp = NULL;
+	struct ulp_bde64 *bpl;
+	IOCB_t *icmd;
+	u8 rc = 0;
+
+	/* fill in BDEs for command */
+	mp = kmalloc(sizeof(*mp), GFP_KERNEL);
+	if (!mp) {
+		rc = 1;
+		goto ct_exit;
+	}
+
+	mp->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &mp->phys);
+	if (!mp->virt) {
+		rc = 2;
+		goto ct_free_mp;
+	}
+
+	/* Allocate buffer for Buffer ptr list */
+	bmp = kmalloc(sizeof(*bmp), GFP_KERNEL);
+	if (!bmp) {
+		rc = 3;
+		goto ct_free_mpvirt;
+	}
+
+	bmp->virt = lpfc_mbuf_alloc(phba, MEM_PRI, &bmp->phys);
+	if (!bmp->virt) {
+		rc = 4;
+		goto ct_free_bmp;
+	}
+
+	INIT_LIST_HEAD(&mp->list);
+	INIT_LIST_HEAD(&bmp->list);
+
+	bpl = (struct ulp_bde64 *)bmp->virt;
+	memset(bpl, 0, sizeof(struct ulp_bde64));
+	bpl->addrHigh = le32_to_cpu(putPaddrHigh(mp->phys));
+	bpl->addrLow = le32_to_cpu(putPaddrLow(mp->phys));
+	bpl->tus.f.bdeFlags = BUFF_TYPE_BLP_64;
+	bpl->tus.f.bdeSize = (LPFC_CT_PREAMBLE - 4);
+	bpl->tus.w = le32_to_cpu(bpl->tus.w);
+
+	ct_rsp = (struct lpfc_sli_ct_request *)mp->virt;
+	memset(ct_rsp, 0, sizeof(struct lpfc_sli_ct_request));
+
+	ct_rsp->RevisionId.bits.Revision = SLI_CT_REVISION;
+	ct_rsp->RevisionId.bits.InId = 0;
+	ct_rsp->FsType = ct_req->FsType;
+	ct_rsp->FsSubType = ct_req->FsSubType;
+	ct_rsp->CommandResponse.bits.Size = 0;
+	ct_rsp->CommandResponse.bits.CmdRsp =
+		cpu_to_be16(SLI_CT_RESPONSE_FS_RJT);
+	ct_rsp->ReasonCode = SLI_CT_REQ_NOT_SUPPORTED;
+	ct_rsp->Explanation = SLI_CT_NO_ADDITIONAL_EXPL;
+
+	cmdiocbq = lpfc_sli_get_iocbq(phba);
+	if (!cmdiocbq) {
+		rc = 5;
+		goto ct_free_bmpvirt;
+	}
+
+	icmd = &cmdiocbq->iocb;
+	icmd->un.genreq64.bdl.ulpIoTag32 = 0;
+	icmd->un.genreq64.bdl.addrHigh = putPaddrHigh(bmp->phys);
+	icmd->un.genreq64.bdl.addrLow = putPaddrLow(bmp->phys);
+	icmd->un.genreq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
+	icmd->un.genreq64.bdl.bdeSize = sizeof(struct ulp_bde64);
+	icmd->un.genreq64.w5.hcsw.Fctl = (LS | LA);
+	icmd->un.genreq64.w5.hcsw.Dfctl = 0;
+	icmd->un.genreq64.w5.hcsw.Rctl = FC_RCTL_DD_SOL_CTL;
+	icmd->un.genreq64.w5.hcsw.Type = FC_TYPE_CT;
+	icmd->ulpCommand = CMD_XMIT_SEQUENCE64_CX;
+	icmd->ulpBdeCount = 1;
+	icmd->ulpLe = 1;
+	icmd->ulpClass = CLASS3;
+
+	/* Save for completion so we can release these resources */
+	cmdiocbq->context1 = lpfc_nlp_get(ndlp);
+	cmdiocbq->context2 = (uint8_t *)mp;
+	cmdiocbq->context3 = (uint8_t *)bmp;
+	cmdiocbq->iocb_cmpl = lpfc_ct_unsol_cmpl;
+	icmd->ulpContext = rx_id;  /* Xri / rx_id */
+	icmd->unsli3.rcvsli3.ox_id = ox_id;
+	icmd->un.ulpWord[3] =
+		phba->sli4_hba.rpi_ids[ndlp->nlp_rpi];
+	icmd->ulpTimeout = (3 * phba->fc_ratov);
+
+	cmdiocbq->retry = 0;
+	cmdiocbq->vport = vport;
+	cmdiocbq->context_un.ndlp = NULL;
+	cmdiocbq->drvrTimeout = icmd->ulpTimeout + LPFC_DRVR_TIMEOUT;
+
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
+	if (!rc)
+		return;
+
+	rc = 6;
+	lpfc_nlp_put(ndlp);
+	lpfc_sli_release_iocbq(phba, cmdiocbq);
+ct_free_bmpvirt:
+	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
+ct_free_bmp:
+	kfree(bmp);
+ct_free_mpvirt:
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
+ct_free_mp:
+	kfree(mp);
+ct_exit:
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+			 "6440 Unsol CT: Rsp err %d Data: x%x\n",
+			 rc, vport->fc_flag);
+}
+
+/**
+ * lpfc_ct_handle_mibreq - Process an unsolicited CT MIB request data buffer
+ * @phba: pointer to lpfc hba data structure.
+ * @ctiocb: pointer to lpfc CT command iocb data structure.
+ *
+ * This routine is used for processing the IOCB associated with a unsolicited
+ * CT MIB request. It first determines whether there is an existing ndlp that
+ * matches the DID from the unsolicited IOCB. If not, it will return.
+ **/
+static void
+lpfc_ct_handle_mibreq(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocbq)
+{
+	struct lpfc_sli_ct_request *ct_req;
+	struct lpfc_nodelist *ndlp = NULL;
+	struct lpfc_vport *vport = NULL;
+	IOCB_t *icmd = &ctiocbq->iocb;
+	u32 mi_cmd, vpi;
+	u32 did = 0;
+
+	vpi = ctiocbq->iocb.unsli3.rcvsli3.vpi;
+	vport = lpfc_find_vport_by_vpid(phba, vpi);
+	if (!vport) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
+				"6437 Unsol CT: VPORT NULL vpi : x%x\n",
+				vpi);
+		return;
+	}
+
+	did = ctiocbq->iocb.un.rcvels.remoteID;
+	if (icmd->ulpStatus) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "6438 Unsol CT: status:x%x/x%x did : x%x\n",
+				 icmd->ulpStatus, icmd->un.ulpWord[4], did);
+		return;
+	}
+
+	/* Ignore traffic received during vport shutdown */
+	if (vport->fc_flag & FC_UNLOADING)
+		return;
+
+	ndlp = lpfc_findnode_did(vport, did);
+	if (!ndlp) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "6439 Unsol CT: NDLP Not Found for DID : x%x",
+				 did);
+		return;
+	}
+
+	ct_req = ((struct lpfc_sli_ct_request *)
+		 (((struct lpfc_dmabuf *)ctiocbq->context2)->virt));
+
+	mi_cmd = ct_req->CommandResponse.bits.CmdRsp;
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "6442 : MI Cmd : x%x Not Supported\n", mi_cmd);
+	lpfc_ct_reject_event(ndlp, ct_req,
+			     ctiocbq->iocb.ulpContext,
+			     ctiocbq->iocb.unsli3.rcvsli3.ox_id);
+}
+
+/**
+ * lpfc_ct_unsol_event - Process an unsolicited event from a ct sli ring
+ * @phba: pointer to lpfc hba data structure.
+ * @pring: pointer to a SLI ring.
+ * @ctiocbq: pointer to lpfc ct iocb data structure.
+ *
+ * This routine is used to process an unsolicited event received from a SLI
+ * (Service Level Interface) ring. The actual processing of the data buffer
+ * associated with the unsolicited event is done by invoking appropriate routine
+ * after properly set up the iocb buffer from the SLI ring on which the
+ * unsolicited event was received.
+ **/
 void
 lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
-		    struct lpfc_iocbq *piocbq)
+		    struct lpfc_iocbq *ctiocbq)
 {
 	struct lpfc_dmabuf *mp = NULL;
-	IOCB_t *icmd = &piocbq->iocb;
+	IOCB_t *icmd = &ctiocbq->iocb;
 	int i;
 	struct lpfc_iocbq *iocbq;
-	dma_addr_t paddr;
+	dma_addr_t dma_addr;
 	uint32_t size;
 	struct list_head head;
-	struct lpfc_dmabuf *bdeBuf;
+	struct lpfc_sli_ct_request *ct_req;
+	struct lpfc_dmabuf *bdeBuf1 = ctiocbq->context2;
+	struct lpfc_dmabuf *bdeBuf2 = ctiocbq->context3;
 
-	if (lpfc_bsg_ct_unsol_event(phba, pring, piocbq) == 0)
-		return;
+	ctiocbq->context1 = NULL;
+	ctiocbq->context2 = NULL;
+	ctiocbq->context3 = NULL;
 
 	if (unlikely(icmd->ulpStatus == IOSTAT_NEED_BUFFER)) {
 		lpfc_sli_hbqbuf_add_hbqs(phba, LPFC_ELS_HBQ);
@@ -127,46 +371,75 @@ lpfc_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		return;
 	}
 
-	/* If there are no BDEs associated with this IOCB,
-	 * there is nothing to do.
+	/* If there are no BDEs associated
+	 * with this IOCB, there is nothing to do.
 	 */
 	if (icmd->ulpBdeCount == 0)
 		return;
 
+	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
+		ctiocbq->context2 = bdeBuf1;
+		if (icmd->ulpBdeCount == 2)
+			ctiocbq->context3 = bdeBuf2;
+	} else {
+		dma_addr = getPaddr(icmd->un.cont64[0].addrHigh,
+				    icmd->un.cont64[0].addrLow);
+		ctiocbq->context2 = lpfc_sli_ringpostbuf_get(phba, pring,
+							     dma_addr);
+		if (icmd->ulpBdeCount == 2) {
+			dma_addr = getPaddr(icmd->un.cont64[1].addrHigh,
+					    icmd->un.cont64[1].addrLow);
+			ctiocbq->context3 = lpfc_sli_ringpostbuf_get(phba,
+								     pring,
+								     dma_addr);
+		}
+	}
+
+	ct_req = ((struct lpfc_sli_ct_request *)
+		 (((struct lpfc_dmabuf *)ctiocbq->context2)->virt));
+
+	if (ct_req->FsType == SLI_CT_MANAGEMENT_SERVICE &&
+	    ct_req->FsSubType == SLI_CT_MIB_Subtypes) {
+		lpfc_ct_handle_mibreq(phba, ctiocbq);
+	} else {
+		if (!lpfc_bsg_ct_unsol_event(phba, pring, ctiocbq))
+			return;
+	}
+
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 		INIT_LIST_HEAD(&head);
-		list_add_tail(&head, &piocbq->list);
+		list_add_tail(&head, &ctiocbq->list);
 		list_for_each_entry(iocbq, &head, list) {
 			icmd = &iocbq->iocb;
 			if (icmd->ulpBdeCount == 0)
 				continue;
-			bdeBuf = iocbq->context2;
+			bdeBuf1 = iocbq->context2;
 			iocbq->context2 = NULL;
 			size  = icmd->un.cont64[0].tus.f.bdeSize;
-			lpfc_ct_unsol_buffer(phba, piocbq, bdeBuf, size);
-			lpfc_in_buf_free(phba, bdeBuf);
+			lpfc_ct_unsol_buffer(phba, ctiocbq, bdeBuf1, size);
+			lpfc_in_buf_free(phba, bdeBuf1);
 			if (icmd->ulpBdeCount == 2) {
-				bdeBuf = iocbq->context3;
+				bdeBuf2 = iocbq->context3;
 				iocbq->context3 = NULL;
 				size  = icmd->unsli3.rcvsli3.bde2.tus.f.bdeSize;
-				lpfc_ct_unsol_buffer(phba, piocbq, bdeBuf,
+				lpfc_ct_unsol_buffer(phba, ctiocbq, bdeBuf2,
 						     size);
-				lpfc_in_buf_free(phba, bdeBuf);
+				lpfc_in_buf_free(phba, bdeBuf2);
 			}
 		}
 		list_del(&head);
 	} else {
 		INIT_LIST_HEAD(&head);
-		list_add_tail(&head, &piocbq->list);
+		list_add_tail(&head, &ctiocbq->list);
 		list_for_each_entry(iocbq, &head, list) {
 			icmd = &iocbq->iocb;
 			if (icmd->ulpBdeCount == 0)
 				lpfc_ct_unsol_buffer(phba, iocbq, NULL, 0);
 			for (i = 0; i < icmd->ulpBdeCount; i++) {
-				paddr = getPaddr(icmd->un.cont64[i].addrHigh,
-						 icmd->un.cont64[i].addrLow);
+				dma_addr = getPaddr(icmd->un.cont64[i].addrHigh,
+						    icmd->un.cont64[i].addrLow);
 				mp = lpfc_sli_ringpostbuf_get(phba, pring,
-							      paddr);
+							      dma_addr);
 				size = icmd->un.cont64[i].tus.f.bdeSize;
 				lpfc_ct_unsol_buffer(phba, iocbq, mp, size);
 				lpfc_in_buf_free(phba, mp);
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 28b8a394f796..42682d95af52 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1380,6 +1380,9 @@ struct lpfc_fdmi_reg_hba {
 	struct lpfc_fdmi_reg_port_list rpl;
 };
 
+/******** MI MIB ********/
+#define SLI_CT_MIB_Subtypes	0x11
+
 /*
  * Register HBA Attributes (RHAT)
  */
-- 
2.26.2


--000000000000cee8f805b2200f4a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
AanDaJF6fE9TEzbfn5AWgVgHkbqS3VY3Gq05xkLhRugDQ60IGwT29K1B+wGfcujKSaalhQIDAQAB
o4IBzzCCAcswDgYDVR0PAQH/BAQDAgWgMIGeBggrBgEFBQcBAQSBkTCBjjBNBggrBgEFBQcwAoZB
aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NwZXJzb25hbHNpZ24yc2hhMmcz
b2NzcC5jcnQwPQYIKwYBBQUHMAGGMWh0dHA6Ly9vY3NwMi5nbG9iYWxzaWduLmNvbS9nc3BlcnNv
bmFsc2lnbjJzaGEyZzMwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0
dHBzOi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwRAYDVR0fBD0w
OzA5oDegNYYzaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc3BlcnNvbmFsc2lnbjJzaGEyZzMu
Y3JsMCMGA1UdEQQcMBqBGGphbWVzLnNtYXJ0QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUUXCHNA1n5KXj
CXL1nHkJ8oKX5wYwDQYJKoZIhvcNAQELBQADggEBAGQDKmIdULu06w+bE15XZJOwlarihiP2PHos
/4bNU3NRgy/tCQbTpJJr3L7LU9ldcPam9qQsErGZKmb5ypUjVdmS5n5M7KN42mnfLs/p7+lOOY5q
ZwPZfsjYiUuaCWDGMvVpuBgJtdADOE1v24vgyyLZjtCbvSUzsgKKda3/Z/iwLFCRrIogixS1L6Vg
2JU2wwirL0Sy5S1DREQmTMAuHL+M9Qwbl+uh/AprkVqaSYuvUzWFwBVgafOl2XgGdn8r6ubxSZhX
9SybOi1fAXGcISX8GzOd85ygu/3dFqvMyCBpNke4vdweIll52KZIMyWji3y2PKJYfgqO+bxo7BAa
ROYxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMCDH5i
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg/NWkmCu+crApM4VI
bEXP1gyMrMklLm5OcWcyMvdbIl8wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMDIwMjAyNzM3WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAJunA1weyfVapm744T11DczDQICXBXfHLpgo
+X4oXNIuRneORe591ylsMWIsF8Kbr71cr5p61Lhs5xvZWGwt4RYOtUAaEXKNMT3g4BxfcFwGQlxm
coRLVpOQ9peJnlZnGjl1MrJY5HTueieG+MMIeudFQyoHCTCuJbKajH2HblpQ5764HdwnK6VTSQ6q
aogq6aGBLceW5cyvUHvx+sTEezFo1kiBBvr8KQUCSBGiMgb2cvK6EZjN4I70CIWBFOBj/FXi3Tp+
ftFO/wRKrHN+NAuAeorQKcrb+1HRVMAEsQRfIJ5uQnoZ2K8/m1HNb6x0gZq6Evb4OzoCZFZlcLOM
2wI=
--000000000000cee8f805b2200f4a--
