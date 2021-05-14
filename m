Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5529DC43461
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F6A61574
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhENT5k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbhENT5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A43C061761
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:12 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id x188so495648pfd.7
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QLG8DymrIbaQHUikE5drW8MgQcYyu7Jws7+5YH8KuPo=;
        b=uzt5njepWKOjFat99E0tdT562poni6srMSn/7v9yhWcm+13nHdLxJ6lSElr9bwv/kg
         seFRPTU2bq50Z7Qj9wfQEvpw/iRdlV/QJeQ46c7KMo2f/o+oLHiJBNi5tIruz33IIa2L
         UxvcOZsQy2UM6Ohl++qLZoiz178NoetucxnSWQFmXkdyZ0pvr6V9QANcT2EVtcA28Mma
         C8N0Uq4VOuEfycAsZIA7VoJBRl71Uuh3M773j6Z15scIvywbpB68py/xckA5IGSfMRJl
         k5qpTkOvTKuF+es8XtchmXqu4wOGNn1pzQJbS2wisVVsAfI/J5qc/xPEA1nEm48Kndhs
         oF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QLG8DymrIbaQHUikE5drW8MgQcYyu7Jws7+5YH8KuPo=;
        b=CL034FQX9r1DkeXYq85jARKYipqWTPvA0a+AIGyBXU+BMvXimYRrrIoWZFm7YQWvu8
         MNjt1RyFNeHkc2HuNGNJVasBWvhoGYSjg74x92jo/mc0GQ0baTxVhDgUERRdoaYz6gqt
         MCeDPW8Q6zqbYnwI5F4d3d9jIvVqf9abhqXz3ZgKpm8KIBeCHuaYr4dU9djOjvIuso++
         XTUMxQW5sj0YgOLV+MQQ4ilo+faBnHuq3T73msyTm79AK9Qpi5hlVBYL0bmt/W9nRhex
         sHGmHd5Bcq4WnsXWL16x8CiNfapVYjouwUuYggmRrawBoolryn2ldZ8Wd2+HkPxaYpEl
         SCbw==
X-Gm-Message-State: AOAM53113etV1uHzCNnQKMtXKD//u0BzmnXStg9Ylcj3gnj2YnqQv3i5
        xqxe8Oq19jHJpFWJc87+bx2GQGT8oWg=
X-Google-Smtp-Source: ABdhPJzEhcIzBTkcrXQR0v7vu9mEIYloDuEI4259etCtT10JdNbaRqexla1e71SWxLSSLDZE7rYoZQ==
X-Received: by 2002:a62:ea05:0:b029:27a:6fc6:af83 with SMTP id t5-20020a62ea050000b029027a6fc6af83mr46659947pfh.24.1621022171965;
        Fri, 14 May 2021 12:56:11 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:11 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 10/11] lpfc: Reregister FPIN types if receive ELS_RDF from fabric controller
Date:   Fri, 14 May 2021 12:55:58 -0700
Message-Id: <20210514195559.119853-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FC-LS-5 specifies that a received RDF implies a possible change to
fabric supported diagnostic functions. Endpoints are to re-perform the
RDF exchange with the fabric to enable possible new features or adapt
to changes in values.

This patch adds the logic to RDF receive to re-perform the RDF exchange
with the switch.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h     |  1 +
 drivers/scsi/lpfc/lpfc_els.c | 75 ++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 487780ede17e..eb4472951cc6 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -266,6 +266,7 @@ struct lpfc_stats {
 	uint32_t elsRcvECHO;
 	uint32_t elsRcvLCB;
 	uint32_t elsRcvRDP;
+	uint32_t elsRcvRDF;
 	uint32_t elsXmitFLOGI;
 	uint32_t elsXmitFDISC;
 	uint32_t elsXmitPLOGI;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 690827888edf..be9c92d97d63 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3670,6 +3670,43 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 	return 0;
 }
 
+ /**
+  * lpfc_els_rcv_rdf - Receive RDF ELS request from the fabric.
+  * @vport: pointer to a host virtual N_Port data structure.
+  * @cmdiocb: pointer to lpfc command iocb data structure.
+  * @ndlp: pointer to a node-list data structure.
+  *
+  * A received RDF implies a possible change to fabric supported diagnostic
+  * functions.  This routine sends LS_ACC and then has the Nx_Port issue a new
+  * RDF request to reregister for supported diagnostic functions.
+  *
+  * Return code
+  *   0 - Success
+  *   -EIO - Failed to process received RDF
+  **/
+static int
+lpfc_els_rcv_rdf(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
+		 struct lpfc_nodelist *ndlp)
+{
+	/* Send LS_ACC */
+	if (lpfc_els_rsp_acc(vport, ELS_CMD_RDF, cmdiocb, ndlp, NULL)) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "1623 Failed to RDF_ACC from x%x for x%x\n",
+				 ndlp->nlp_DID, vport->fc_myDID);
+		return -EIO;
+	}
+
+	/* Issue new RDF for reregistering */
+	if (lpfc_issue_els_rdf(vport, 0)) {
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "2623 Failed to re register RDF for x%x\n",
+				 vport->fc_myDID);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /**
  * lpfc_cancel_retry_delay_tmo - Cancel the timer with delayed iocb-cmd retry
  * @vport: pointer to a host virtual N_Port data structure.
@@ -4803,6 +4840,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 	uint16_t cmdsize;
 	int rc;
 	ELS_PKT *els_pkt_ptr;
+	struct fc_els_rdf_resp *rdf_resp;
 
 	oldcmd = &oldiocb->iocb;
 
@@ -4914,6 +4952,29 @@ lpfc_els_rsp_acc(struct lpfc_vport *vport, uint32_t flag,
 			"Issue ACC PRLO:  did:x%x flg:x%x",
 			ndlp->nlp_DID, ndlp->nlp_flag, 0);
 		break;
+	case ELS_CMD_RDF:
+		cmdsize = sizeof(*rdf_resp);
+		elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry,
+					     ndlp, ndlp->nlp_DID, ELS_CMD_ACC);
+		if (!elsiocb)
+			return 1;
+
+		icmd = &elsiocb->iocb;
+		icmd->ulpContext = oldcmd->ulpContext;	/* Xri / rx_id */
+		icmd->unsli3.rcvsli3.ox_id = oldcmd->unsli3.rcvsli3.ox_id;
+		pcmd = (((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+		rdf_resp = (struct fc_els_rdf_resp *)pcmd;
+		memset(rdf_resp, 0, sizeof(*rdf_resp));
+		rdf_resp->acc_hdr.la_cmd = ELS_LS_ACC;
+
+		/* FC-LS-5 specifies desc_list_len shall be set to 12 */
+		rdf_resp->desc_list_len = cpu_to_be32(12);
+
+		/* FC-LS-5 specifies LS REQ Information descriptor */
+		rdf_resp->lsri.desc_tag = cpu_to_be32(1);
+		rdf_resp->lsri.desc_len = cpu_to_be32(sizeof(u32));
+		rdf_resp->lsri.rqst_w0.cmd = ELS_RDF;
+		break;
 	default:
 		return 1;
 	}
@@ -9027,6 +9088,20 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 
 		/* There are no replies, so no rjt codes */
 		break;
+	case ELS_CMD_RDF:
+		phba->fc_stat.elsRcvRDF++;
+		/* Accept RDF only from fabric controller */
+		if (did != Fabric_Cntl_DID) {
+			lpfc_printf_vlog(vport, KERN_WARNING, LOG_ELS,
+					 "1115 Received RDF from invalid DID "
+					 "x%x\n", did);
+			rjt_err = LSRJT_PROTOCOL_ERR;
+			rjt_exp = LSEXP_NOTHING_MORE;
+			goto lsrjt;
+		}
+
+		lpfc_els_rcv_rdf(vport, elsiocb, ndlp);
+		break;
 	default:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 			"RCV ELS cmd:     cmd:x%x did:x%x/ste:x%x",
-- 
2.26.2

