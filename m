Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DA4C64E7A
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52AD9223BF
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Qpg+tgzy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgKOT1N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbgKOT1L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:11 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BA5C0617A6
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:11 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id g11so7012696pll.13
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=zjOJPDeBX3AXCrjD5CQFZUFYeDftOQGdV4WLWjobvEk=;
        b=Qpg+tgzybkiJbiMDMvIE8jzgq/5j9pBRTCm2KddVSbABRE2eV6/fQDP6yblfzcqQZW
         1oN8KcsXFJO6FvGuI+Go14XDQORlmSpVSYfp37SZu71mw3rUT6Yw0dGMOMsvO88NeyFx
         kjdfFQbAX+smSWELQrkVQhQE12h2b1lXMEruo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=zjOJPDeBX3AXCrjD5CQFZUFYeDftOQGdV4WLWjobvEk=;
        b=haaG3WG8oPKZqolUOZSMuZzrDQa61OHAW5h0nKZkjBDLX9mN4uQQArLzMNArJjIHUU
         VRfNads/FNWknkwNuxe23rfq1D+Iz63NvT7iUT3M9KQzV35wzmZoPWLOUL1cUtlwiBxl
         8k2fO/IXMgd/1V/CdTEE85UXYHJHNOJbZfdcFUmlPGx4mZdE0+Ja5bT4XMM+bU00peM5
         6qkHjPdDmnZjfzEzRIujF4ljls9XfM4vWcZPkU4fhPihw3N/sS+ihCudkJC1+vv1Aaad
         U6/BeIVWhRNU4JD/o9ZCcsvlBT/af6m4yh7sJctwgUYsShRKSsqnlo6V6i6ouAy6/m6c
         rivg==
X-Gm-Message-State: AOAM531fUOi0pcfeMhFCokm3Zn6oTBQheQYTLRA8K7fFF6tTKqFJzk9u
        vVwchzNK3XEodYSKRd0xD3dSscCyK3V6NVCd3g4R6lIr+PKvg04kB8ui0yDhjnE9rNB/K0j5FMS
        0Rg/nn9hfR1jNiDmGIySOi7kvnIxb3rgFv3rW0f9XOmCSX3ap0bJ1PsBuTiYiEbLPGz2yhGJv2U
        yfYzs=
X-Google-Smtp-Source: ABdhPJxHBljHfTkc0dsJ4aEDfn2BrDW9kdNC09QDzbYUvHKoxX8IXFufsMbkaoo1uMiPYt6PaBWb0w==
X-Received: by 2002:a17:902:6b84:b029:d8:d13d:14e with SMTP id p4-20020a1709026b84b02900d8d13d014emr10722880plk.29.1605468430477;
        Sun, 15 Nov 2020 11:27:10 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:09 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 12/17] lpfc: Enable common send_io interface for SCSI and NVME
Date:   Sun, 15 Nov 2020 11:26:41 -0800
Message-Id: <20201115192646.12977-13-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008918cf05b42a3f80"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008918cf05b42a3f80
Content-Transfer-Encoding: 8bit

To setup up common use by the SCSI and NVME io paths, create a new
routine that issues FCP io commands which can be used by either protocol.
The new routine addresses sli-3 vs sli-4 differences within its
implementation.

Replace the (sli-3 centric) iocb routine in the scsi path with this new
wqe-centric common routine.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h      |  3 ++
 drivers/scsi/lpfc/lpfc_crtn.h |  2 +
 drivers/scsi/lpfc/lpfc_scsi.c |  6 ++-
 drivers/scsi/lpfc/lpfc_sli.c  | 87 +++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 2b92aa7a0762..63a87c103bc5 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -669,6 +669,9 @@ struct lpfc_hba {
 	int (*__lpfc_sli_issue_iocb)
 		(struct lpfc_hba *, uint32_t,
 		 struct lpfc_iocbq *, uint32_t);
+	int (*__lpfc_sli_issue_fcp_io)
+		(struct lpfc_hba *phba, uint32_t ring_number,
+		 struct lpfc_iocbq *piocb, uint32_t flag);
 	void (*__lpfc_sli_release_iocbq)(struct lpfc_hba *,
 			 struct lpfc_iocbq *);
 	int (*lpfc_hba_down_post)(struct lpfc_hba *phba);
diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 03560478f2ce..2b1540c0c82e 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -320,6 +320,8 @@ void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
 			struct lpfc_iocbq *, uint32_t);
+int lpfc_sli_issue_fcp_io(struct lpfc_hba *phba, uint32_t ring_number,
+			  struct lpfc_iocbq *piocb, uint32_t flag);
 int lpfc_sli4_issue_wqe(struct lpfc_hba *phba, struct lpfc_sli4_hdw_queue *qp,
 			struct lpfc_iocbq *pwqe);
 struct lpfc_sglq *__lpfc_clear_active_sglq(struct lpfc_hba *phba, uint16_t xri);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index bd605bb87dfc..5ec1fc1372fa 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4634,8 +4634,10 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	if (unlikely(phba->hdwqstat_on & LPFC_CHECK_SCSI_IO))
 		this_cpu_inc(phba->sli4_hba.c_stat->xmt_io);
 #endif
-	err = lpfc_sli_issue_iocb(phba, LPFC_FCP_RING,
-				  &lpfc_cmd->cur_iocbq, SLI_IOCB_RET_IOCB);
+	/* Issue IO to adapter */
+	err = lpfc_sli_issue_fcp_io(phba, LPFC_FCP_RING,
+				    &lpfc_cmd->cur_iocbq,
+				    SLI_IOCB_RET_IOCB);
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	if (start) {
 		lpfc_cmd->ts_cmd_start = start;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b1d5b4484015..31c524a3373f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -276,6 +276,7 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, union lpfc_wqe128 *wqe)
 	/* sanity check on queue memory */
 	if (unlikely(!q))
 		return -ENOMEM;
+
 	temp_wqe = lpfc_sli4_qe(q, q->host_index);
 
 	/* If the host has not yet processed the next entry then we are done */
@@ -10228,6 +10229,71 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 	return 0;
 }
 
+/**
+ * __lpfc_sli_issue_fcp_io_s3 - SLI3 device for sending fcp io iocb
+ * @phba: Pointer to HBA context object.
+ * @ring_number: SLI ring number to issue wqe on.
+ * @piocb: Pointer to command iocb.
+ * @flag: Flag indicating if this command can be put into txq.
+ *
+ * __lpfc_sli_issue_fcp_io_s3 is wrapper function to invoke lockless func to
+ * send  an iocb command to an HBA with SLI-4 interface spec.
+ *
+ * This function takes the hbalock before invoking the lockless version.
+ * The function will return success after it successfully submit the wqe to
+ * firmware or after adding to the txq.
+ **/
+static int
+__lpfc_sli_issue_fcp_io_s3(struct lpfc_hba *phba, uint32_t ring_number,
+			   struct lpfc_iocbq *piocb, uint32_t flag)
+{
+	unsigned long iflags;
+	int rc;
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	return rc;
+}
+
+/**
+ * __lpfc_sli_issue_fcp_io_s4 - SLI4 device for sending fcp io wqe
+ * @phba: Pointer to HBA context object.
+ * @ring_number: SLI ring number to issue wqe on.
+ * @piocb: Pointer to command iocb.
+ * @flag: Flag indicating if this command can be put into txq.
+ *
+ * __lpfc_sli_issue_fcp_io_s4 is used by other functions in the driver to issue
+ * an wqe command to an HBA with SLI-4 interface spec.
+ *
+ * This function is a lockless version. The function will return success
+ * after it successfully submit the wqe to firmware or after adding to the
+ * txq.
+ **/
+static int
+__lpfc_sli_issue_fcp_io_s4(struct lpfc_hba *phba, uint32_t ring_number,
+			   struct lpfc_iocbq *piocb, uint32_t flag)
+{
+	struct lpfc_sli_ring *pring;
+	struct lpfc_queue *eq;
+	unsigned long iflags;
+	int rc;
+
+	eq = phba->sli4_hba.hdwq[piocb->hba_wqidx].hba_eq;
+
+	pring = lpfc_sli4_calc_ring(phba, piocb);
+	if (unlikely(pring == NULL))
+		return IOCB_ERROR;
+
+	spin_lock_irqsave(&pring->ring_lock, iflags);
+	rc = __lpfc_sli_issue_iocb(phba, ring_number, piocb, flag);
+	spin_unlock_irqrestore(&pring->ring_lock, iflags);
+
+	lpfc_sli4_poll_eq(eq, LPFC_POLL_FASTPATH);
+	return rc;
+}
+
 /**
  * __lpfc_sli_issue_iocb_s4 - SLI4 device lockless ver of lpfc_sli_issue_iocb
  * @phba: Pointer to HBA context object.
@@ -10324,6 +10390,25 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba *phba, uint32_t ring_number,
 	return 0;
 }
 
+/**
+ * lpfc_sli_issue_fcp_io - Wrapper func for issuing fcp i/o
+ *
+ * This routine wraps the actual fcp i/o function for issusing WQE for sli-4
+ * or IOCB for sli-3  function.
+ * pointer from the lpfc_hba struct.
+ *
+ * Return codes:
+ * IOCB_ERROR - Error
+ * IOCB_SUCCESS - Success
+ * IOCB_BUSY - Busy
+ **/
+int
+lpfc_sli_issue_fcp_io(struct lpfc_hba *phba, uint32_t ring_number,
+		      struct lpfc_iocbq *piocb, uint32_t flag)
+{
+	return phba->__lpfc_sli_issue_fcp_io(phba, ring_number, piocb, flag);
+}
+
 /*
  * __lpfc_sli_issue_iocb - Wrapper func of lockless version for issuing iocb
  *
@@ -10359,10 +10444,12 @@ lpfc_sli_api_table_setup(struct lpfc_hba *phba, uint8_t dev_grp)
 	case LPFC_PCI_DEV_LP:
 		phba->__lpfc_sli_issue_iocb = __lpfc_sli_issue_iocb_s3;
 		phba->__lpfc_sli_release_iocbq = __lpfc_sli_release_iocbq_s3;
+		phba->__lpfc_sli_issue_fcp_io = __lpfc_sli_issue_fcp_io_s3;
 		break;
 	case LPFC_PCI_DEV_OC:
 		phba->__lpfc_sli_issue_iocb = __lpfc_sli_issue_iocb_s4;
 		phba->__lpfc_sli_release_iocbq = __lpfc_sli_release_iocbq_s4;
+		phba->__lpfc_sli_issue_fcp_io = __lpfc_sli_issue_fcp_io_s4;
 		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.26.2


--0000000000008918cf05b42a3f80
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg4aZcKjGeY5V8H+90
D1fKoHk1YH66lUA5gahiej1WmwUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzExWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAFk47SRxedW3R4anl25ZaZJciySdDOStzTcq
qO7JyXo1PfJhG0xZnhu5ZaDYRJ/OlaiwWIk03Ma1bO9KbxjIjfgOQNbPejLtZ8tlmRdGyvJUPY/1
YvfiOGhTx5vyYQhkNZF+Vi/5pe7iHAh7Utl24IC3L9MCJXORdw79orlUh7lgZJvepVbRB3L2FhTj
KfARpJKeEi4Ys5JMjXKS6ZLPkWND3dYefDsntzTh9fkQbOYa6AwVR/yjH7Kn54Cn3gnzKPMg15x4
xPYLIvKT4Ef4Z/dCDpV+PSGNpW5FwlovSui1CcRK4WnAA5PxD6O50Jx54JWUliwqEpD6MCKC2DZc
jY8=
--0000000000008918cf05b42a3f80--
