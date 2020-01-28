Return-Path: <SRS0=0wOg=3R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F583C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF04B22527
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jan 2020 00:23:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ig9675zw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgA1AXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jan 2020 19:23:43 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34475 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgA1AXn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2020 19:23:43 -0500
Received: by mail-wm1-f67.google.com with SMTP id s144so585127wme.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2020 16:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JClbluDvB3qn8jCDAMB9gs/ojiMID1/QUB0i1vfmT3w=;
        b=ig9675zwb+efKtfkuuoYsitR0VLeEk+/zk+FnpGmehCsCpgPSxAhaW7vDTnjvczz3n
         B9dNpyXzRUK8nuhah4Bvi43KTZOxBxCj3uD6c7r9DoA8WUAvmifaNkxn5/Q6HPN/jzd0
         WujKJwJrYK7gvg9u6YWmGZRFrfDhMOTKfqSuP2vKRY7SNcZ8w+dInTd3sASarQniprIb
         rsP5QA5lvFrV5kUYSfazYWEg6n8jmBf18a4CCf6gh4z6pdaaNklTnQHAmwh7U1L8TWBA
         YTlMteeBzc9HQDPXa0BVSrSF/l4IMDgz30P6Nm5KHTepj0GaVInScBg1SvzNz5HVLSQZ
         Sjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JClbluDvB3qn8jCDAMB9gs/ojiMID1/QUB0i1vfmT3w=;
        b=bTEd6jjrg2eU9HYQOURSecD9R949lnl3jAYAZ32vSQSMLuYQyJTc+qDyRSTBYhK/su
         GpHg1GwG3yAyCIsm404jf0sboMqWEL6BNaeXWFwQoUPwG424rPEZm1MGbPg3HI7nTbbH
         rCRGNkYmWb1BFkAPX8ICedWJSap9AatMagp0PKdzNUwn9r6nHzzezjVMFPv40EdKkc26
         Z7/9L7KxNoJ+4FVRRbIntgHQahFeT5fT/3oiZ9m+QO/uQQZqQ0N5JfreKiQGOaAOhN9S
         36zkRi3b/xNutw0lHDzvMZkQEs/r7w+TPdLHAxAUk0T/rEtwa5MHfl9ioSzpNvd6l1cd
         SI9Q==
X-Gm-Message-State: APjAAAUbDehDVUp8s7TET8ngr1C3BY0pGDhJLhhtFH4rt6UEh9NMHviI
        JvW+MR6Drm++Z5oaNDfSFZebHj/Y
X-Google-Smtp-Source: APXvYqyOQ59qMp+XjlBBxGA6nLQ6ztJMv7mRYdfXG3Gdhvs27MbJqRHBDvAfC77bBbAiHhAA2iGJ+w==
X-Received: by 2002:a1c:1b4d:: with SMTP id b74mr1279513wmb.33.1580171018477;
        Mon, 27 Jan 2020 16:23:38 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z19sm583769wmi.43.2020.01.27.16.23.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 16:23:38 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/12] lpfc: Remove handler for obsolete ELS - Read Port Status (RPS)
Date:   Mon, 27 Jan 2020 16:23:08 -0800
Message-Id: <20200128002312.16346-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200128002312.16346-1-jsmart2021@gmail.com>
References: <20200128002312.16346-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There was report of an odd "Fix me..." log message, which was tracked
down to the lpfc_els_rcv_rps() routine. This was in handling of a very
old and obsolete ELS - Read Port Status. The RPS ELS was defined in
FC-LS-1, but deprecated in FC-LS-2, and removed from all later FC-LS
revisions. It was replaced by the Read Diagnostic Parameters (RDP) ELS
and the Link Error Status Block descriptor.

There should be no support for the RSP ELS.  Removed support from driver.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h     |   1 -
 drivers/scsi/lpfc/lpfc_els.c | 193 ++-----------------------------------------
 drivers/scsi/lpfc/lpfc_hw.h  |  20 -----
 3 files changed, 5 insertions(+), 209 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 3f2cb17c4574..cebbad1b3e55 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -262,7 +262,6 @@ struct lpfc_stats {
 	uint32_t elsRcvPRLI;
 	uint32_t elsRcvLIRR;
 	uint32_t elsRcvRLS;
-	uint32_t elsRcvRPS;
 	uint32_t elsRcvRPL;
 	uint32_t elsRcvRRQ;
 	uint32_t elsRcvRTV;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 42a2bf38eaea..371599d67eb4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7135,108 +7135,12 @@ lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 }
 
 /**
- * lpfc_els_rsp_rps_acc - Completion callbk func for MBX_READ_LNK_STAT mbox cmd
- * @phba: pointer to lpfc hba data structure.
- * @pmb: pointer to the driver internal queue element for mailbox command.
- *
- * This routine is the completion callback function for the MBX_READ_LNK_STAT
- * mailbox command. This callback function is to actually send the Accept
- * (ACC) response to a Read Port Status (RPS) unsolicited IOCB event. It
- * collects the link statistics from the completion of the MBX_READ_LNK_STAT
- * mailbox command, constructs the RPS response with the link statistics
- * collected, and then invokes the lpfc_sli_issue_iocb() routine to send ACC
- * response to the RPS.
- *
- * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
- * will be incremented by 1 for holding the ndlp and the reference to ndlp
- * will be stored into the context1 field of the IOCB for the completion
- * callback function to the RPS Accept Response ELS IOCB command.
- *
- **/
-static void
-lpfc_els_rsp_rps_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
-{
-	MAILBOX_t *mb;
-	IOCB_t *icmd;
-	RPS_RSP *rps_rsp;
-	uint8_t *pcmd;
-	struct lpfc_iocbq *elsiocb;
-	struct lpfc_nodelist *ndlp;
-	uint16_t status;
-	uint16_t oxid;
-	uint16_t rxid;
-	uint32_t cmdsize;
-
-	mb = &pmb->u.mb;
-
-	ndlp = (struct lpfc_nodelist *)pmb->ctx_ndlp;
-	rxid = (uint16_t)((unsigned long)(pmb->ctx_buf) & 0xffff);
-	oxid = (uint16_t)(((unsigned long)(pmb->ctx_buf) >> 16) & 0xffff);
-	pmb->ctx_ndlp = NULL;
-	pmb->ctx_buf = NULL;
-
-	if (mb->mbxStatus) {
-		mempool_free(pmb, phba->mbox_mem_pool);
-		return;
-	}
-
-	cmdsize = sizeof(RPS_RSP) + sizeof(uint32_t);
-	mempool_free(pmb, phba->mbox_mem_pool);
-	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
-				     lpfc_max_els_tries, ndlp,
-				     ndlp->nlp_DID, ELS_CMD_ACC);
-
-	/* Decrement the ndlp reference count from previous mbox command */
-	lpfc_nlp_put(ndlp);
-
-	if (!elsiocb)
-		return;
-
-	icmd = &elsiocb->iocb;
-	icmd->ulpContext = rxid;
-	icmd->unsli3.rcvsli3.ox_id = oxid;
-
-	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
-	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
-	pcmd += sizeof(uint32_t); /* Skip past command */
-	rps_rsp = (RPS_RSP *)pcmd;
-
-	if (phba->fc_topology != LPFC_TOPOLOGY_LOOP)
-		status = 0x10;
-	else
-		status = 0x8;
-	if (phba->pport->fc_flag & FC_FABRIC)
-		status |= 0x4;
-
-	rps_rsp->rsvd1 = 0;
-	rps_rsp->portStatus = cpu_to_be16(status);
-	rps_rsp->linkFailureCnt = cpu_to_be32(mb->un.varRdLnk.linkFailureCnt);
-	rps_rsp->lossSyncCnt = cpu_to_be32(mb->un.varRdLnk.lossSyncCnt);
-	rps_rsp->lossSignalCnt = cpu_to_be32(mb->un.varRdLnk.lossSignalCnt);
-	rps_rsp->primSeqErrCnt = cpu_to_be32(mb->un.varRdLnk.primSeqErrCnt);
-	rps_rsp->invalidXmitWord = cpu_to_be32(mb->un.varRdLnk.invalidXmitWord);
-	rps_rsp->crcCnt = cpu_to_be32(mb->un.varRdLnk.crcCnt);
-	/* Xmit ELS RPS ACC response tag <ulpIoTag> */
-	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_ELS,
-			 "0118 Xmit ELS RPS ACC response tag x%x xri x%x, "
-			 "did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
-			 elsiocb->iotag, elsiocb->iocb.ulpContext,
-			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
-			 ndlp->nlp_rpi);
-	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
-	phba->fc_stat.elsXmitACC++;
-	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) == IOCB_ERROR)
-		lpfc_els_free_iocb(phba, elsiocb);
-	return;
-}
-
-/**
  * lpfc_els_rcv_rls - Process an unsolicited rls iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
  *
- * This routine processes Read Port Status (RPL) IOCB received as an
+ * This routine processes Read Link Status (RLS) IOCB received as an
  * ELS unsolicited event. It first checks the remote port state. If the
  * remote port is not in NLP_STE_UNMAPPED_NODE state or NLP_STE_MAPPED_NODE
  * state, it invokes the lpfc_els_rsl_reject() routine to send the reject
@@ -7258,7 +7162,7 @@ lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))
-		/* reject the unsolicited RPS request and done with it */
+		/* reject the unsolicited RLS request and done with it */
 		goto reject_out;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
@@ -7306,7 +7210,7 @@ lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
  * will be incremented by 1 for holding the ndlp and the reference to ndlp
  * will be stored into the context1 field of the IOCB for the completion
- * callback function to the RPS Accept Response ELS IOCB command.
+ * callback function to the RTV Accept Response ELS IOCB command.
  *
  * Return codes
  *   0 - Successfully processed rtv iocb (currently always return 0)
@@ -7325,7 +7229,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 
 	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))
-		/* reject the unsolicited RPS request and done with it */
+		/* reject the unsolicited RTV request and done with it */
 		goto reject_out;
 
 	cmdsize = sizeof(struct RTV_RSP) + sizeof(uint32_t);
@@ -7378,84 +7282,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	return 0;
 }
 
-/* lpfc_els_rcv_rps - Process an unsolicited rps iocb
- * @vport: pointer to a host virtual N_Port data structure.
- * @cmdiocb: pointer to lpfc command iocb data structure.
- * @ndlp: pointer to a node-list data structure.
- *
- * This routine processes Read Port Status (RPS) IOCB received as an
- * ELS unsolicited event. It first checks the remote port state. If the
- * remote port is not in NLP_STE_UNMAPPED_NODE state or NLP_STE_MAPPED_NODE
- * state, it invokes the lpfc_els_rsp_reject() routine to send the reject
- * response. Otherwise, it issue the MBX_READ_LNK_STAT mailbox command
- * for reading the HBA link statistics. It is for the callback function,
- * lpfc_els_rsp_rps_acc(), set to the MBX_READ_LNK_STAT mailbox command
- * to actually sending out RPS Accept (ACC) response.
- *
- * Return codes
- *   0 - Successfully processed rps iocb (currently always return 0)
- **/
-static int
-lpfc_els_rcv_rps(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
-		 struct lpfc_nodelist *ndlp)
-{
-	struct lpfc_hba *phba = vport->phba;
-	uint32_t *lp;
-	uint8_t flag;
-	LPFC_MBOXQ_t *mbox;
-	struct lpfc_dmabuf *pcmd;
-	RPS *rps;
-	struct ls_rjt stat;
-
-	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
-	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))
-		/* reject the unsolicited RPS request and done with it */
-		goto reject_out;
-
-	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
-	lp = (uint32_t *) pcmd->virt;
-	flag = (be32_to_cpu(*lp++) & 0xf);
-	rps = (RPS *) lp;
-
-	if ((flag == 0) ||
-	    ((flag == 1) && (be32_to_cpu(rps->un.portNum) == 0)) ||
-	    ((flag == 2) && (memcmp(&rps->un.portName, &vport->fc_portname,
-				    sizeof(struct lpfc_name)) == 0))) {
-
-		printk("Fix me....\n");
-		dump_stack();
-		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
-		if (mbox) {
-			lpfc_read_lnk_stat(phba, mbox);
-			mbox->ctx_buf = (void *)((unsigned long)
-				((cmdiocb->iocb.unsli3.rcvsli3.ox_id << 16) |
-				cmdiocb->iocb.ulpContext)); /* rx_id */
-			mbox->ctx_ndlp = lpfc_nlp_get(ndlp);
-			mbox->vport = vport;
-			mbox->mbox_cmpl = lpfc_els_rsp_rps_acc;
-			if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
-				!= MBX_NOT_FINISHED)
-				/* Mbox completion will send ELS Response */
-				return 0;
-			/* Decrement reference count used for the failed mbox
-			 * command.
-			 */
-			lpfc_nlp_put(ndlp);
-			mempool_free(mbox, phba->mbox_mem_pool);
-		}
-	}
-
-reject_out:
-	/* issue rejection response */
-	stat.un.b.lsRjtRsvd0 = 0;
-	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
-	stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
-	stat.un.b.vendorUnique = 0;
-	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
-	return 0;
-}
-
-/* lpfc_issue_els_rrq - Process an unsolicited rps iocb
+/* lpfc_issue_els_rrq - Process an unsolicited rrq iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: pointer to a node-list data structure.
  * @did: DID of the target.
@@ -8632,16 +8459,6 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
-	case ELS_CMD_RPS:
-		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
-			"RCV RPS:         did:x%x/ste:x%x flg:x%x",
-			did, vport->port_state, ndlp->nlp_flag);
-
-		phba->fc_stat.elsRcvRPS++;
-		lpfc_els_rcv_rps(vport, elsiocb, ndlp);
-		if (newnode)
-			lpfc_nlp_put(ndlp);
-		break;
 	case ELS_CMD_RPL:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 			"RCV RPL:         did:x%x/ste:x%x flg:x%x",
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index b5642c872593..9a5979075646 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -597,7 +597,6 @@ struct fc_vft_header {
 #define ELS_CMD_ADISC     0x52000000
 #define ELS_CMD_FARP      0x54000000
 #define ELS_CMD_FARPR     0x55000000
-#define ELS_CMD_RPS       0x56000000
 #define ELS_CMD_RPL       0x57000000
 #define ELS_CMD_FAN       0x60000000
 #define ELS_CMD_RSCN      0x61040000
@@ -639,7 +638,6 @@ struct fc_vft_header {
 #define ELS_CMD_ADISC     0x52
 #define ELS_CMD_FARP      0x54
 #define ELS_CMD_FARPR     0x55
-#define ELS_CMD_RPS       0x56
 #define ELS_CMD_RPL       0x57
 #define ELS_CMD_FAN       0x60
 #define ELS_CMD_RSCN      0x0461
@@ -919,24 +917,6 @@ typedef struct _RNID {		/* Structure is in Big Endian format */
 	} un;
 } __packed RNID;
 
-typedef struct  _RPS {		/* Structure is in Big Endian format */
-	union {
-		uint32_t portNum;
-		struct lpfc_name portName;
-	} un;
-} RPS;
-
-typedef struct  _RPS_RSP {	/* Structure is in Big Endian format */
-	uint16_t rsvd1;
-	uint16_t portStatus;
-	uint32_t linkFailureCnt;
-	uint32_t lossSyncCnt;
-	uint32_t lossSignalCnt;
-	uint32_t primSeqErrCnt;
-	uint32_t invalidXmitWord;
-	uint32_t crcCnt;
-} RPS_RSP;
-
 struct RLS {			/* Structure is in Big Endian format */
 	uint32_t rls;
 #define rls_rsvd_SHIFT		24
-- 
2.13.7

