Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB12BC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4F8B60FC4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 23:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhHMXB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 19:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235495AbhHMXBv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 19:01:51 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C98DC0617AE
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:01:24 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id u21-20020a17090a8915b02901782c36f543so22898088pjn.4
        for <linux-scsi@vger.kernel.org>; Fri, 13 Aug 2021 16:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NR2nsA+CsS2cAHEcsdJeCbbR/C+OLD9Y0JkWO0fkFp8=;
        b=O+AgGfvMzNUhakZ1rCAqD1EvPgLJgGl80gq/daIknE5rqTVXg4nE5y/RJTbvjjU2lj
         nRsSPDL7CsQ0XuC8YnmvCWlbeVhIwBqWe/azgNRIqPGvtJMVG4blesxazqTQw5WSinHr
         YXI76AMdKUaIreuZ6jWoiB7SzU2IdMr7KqFnSGpnCXbtmPFmgUeo3rErgihfoQtAOTFp
         E9uqz+UG/HOTpJwVU89kS030hsy5WCHQ6XArcJU4eeHe/N+YyA43M76UxSLLrT2hMhoc
         cYGbFmU9e0FhBxko0CsEPViwTpivMlKlb8uAXpchxisNLy0JjEB8pWdhNaMWG0UuNnpL
         BOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NR2nsA+CsS2cAHEcsdJeCbbR/C+OLD9Y0JkWO0fkFp8=;
        b=I9+lAdzUWkrm+/NGx8/KEJrced6WXpzCXWwRB/pnIprGTWcOjrg1+ePpdIz9WiKw3s
         J37zaLGsD4uMJM13qtiO1EdmlqYjUP6ubsBLBqadHuoBlv2rUZxO/3UPuqt7uKOIA0eX
         7skFl/HQU3RYnspoZlW8R0LoC+R9TE/DKCMy6NaS9mBD3/XsRLoDUiwEjqbMdFrEAJma
         QEWU8v6BPzTJB05e6FBU/x+PH0pAIV0fEbYAk5m7flCE6aHac80EXV3NDlWS2KS1+LMZ
         IIpZjylI+uYUzdOrsWj+3qZu/EjpuMJX5IWbWsH7g+JtojkfUna+6/U/T86iX7zVB+Gt
         C1Zw==
X-Gm-Message-State: AOAM533GkKOn8Up9MRJ7lj9/m9i03nbZpR9/ZVMEnRIR4pG3/QBaBFf5
        Ip2bDZfUiAtPLGo7+6Bj9YbuMrGkHNk=
X-Google-Smtp-Source: ABdhPJyPtSzvD+jgYyfMcY5AB335e+tNYVf6SSzlBn40hVotkfeih8kjxSFuxB58r8LUoUGoO+upVw==
X-Received: by 2002:a63:de56:: with SMTP id y22mr2221208pgi.157.1628895684028;
        Fri, 13 Aug 2021 16:01:24 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e8sm4001997pgg.31.2021.08.13.16.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 16:01:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v2 14/16] lpfc: Add bsg support for retrieving adapter cmf data
Date:   Fri, 13 Aug 2021 16:00:37 -0700
Message-Id: <20210813230039.110546-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813230039.110546-1-jsmart2021@gmail.com>
References: <20210813230039.110546-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds a bsg ioctl to allow user applications to retrieve the
adapter congestion management framework buffer.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c | 89 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_bsg.h |  8 ++++
 2 files changed, 97 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 38cfe1bc6a4d..fdf08cb57207 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5751,6 +5751,92 @@ lpfc_get_trunk_info(struct bsg_job *job)
 
 }
 
+static int
+lpfc_get_cgnbuf_info(struct bsg_job *job)
+{
+	struct lpfc_vport *vport = shost_priv(fc_bsg_to_shost(job));
+	struct lpfc_hba *phba = vport->phba;
+	struct fc_bsg_request *bsg_request = job->request;
+	struct fc_bsg_reply *bsg_reply = job->reply;
+	struct get_cgnbuf_info_req *cgnbuf_req;
+	struct lpfc_cgn_info *cp;
+	uint8_t *cgn_buff;
+	int size, cinfosz;
+	int  rc = 0;
+
+	if (job->request_len < sizeof(struct fc_bsg_request) +
+	    sizeof(struct get_cgnbuf_info_req)) {
+		rc = -ENOMEM;
+		goto job_exit;
+	}
+
+	if (!phba->sli4_hba.pc_sli4_params.cmf) {
+		rc = -ENOENT;
+		goto job_exit;
+	}
+
+	if (!phba->cgn_i || !phba->cgn_i->virt) {
+		rc = -ENOENT;
+		goto job_exit;
+	}
+
+	cp = phba->cgn_i->virt;
+	if (cp->cgn_info_version < LPFC_CGN_INFO_V3) {
+		rc = -EPERM;
+		goto job_exit;
+	}
+
+	cgnbuf_req = (struct get_cgnbuf_info_req *)
+		bsg_request->rqst_data.h_vendor.vendor_cmd;
+
+	/* For reset or size == 0 */
+	bsg_reply->reply_payload_rcv_len = 0;
+
+	if (cgnbuf_req->reset == LPFC_BSG_CGN_RESET_STAT) {
+		lpfc_init_congestion_stat(phba);
+		goto job_exit;
+	}
+
+	/* We don't want to include the CRC at the end */
+	cinfosz = sizeof(struct lpfc_cgn_info) - sizeof(uint32_t);
+
+	size = cgnbuf_req->read_size;
+	if (!size)
+		goto job_exit;
+
+	if (size < cinfosz) {
+		/* Just copy back what we can */
+		cinfosz = size;
+		rc = -E2BIG;
+	}
+
+	/* Allocate memory to read congestion info */
+	cgn_buff = vmalloc(cinfosz);
+	if (!cgn_buff) {
+		rc = -ENOMEM;
+		goto job_exit;
+	}
+
+	memcpy(cgn_buff, cp, cinfosz);
+
+	bsg_reply->reply_payload_rcv_len =
+		sg_copy_from_buffer(job->reply_payload.sg_list,
+				    job->reply_payload.sg_cnt,
+				    cgn_buff, cinfosz);
+
+	vfree(cgn_buff);
+
+job_exit:
+	bsg_reply->result = rc;
+	if (!rc)
+		bsg_job_done(job, bsg_reply->result,
+			     bsg_reply->reply_payload_rcv_len);
+	else
+		lpfc_printf_log(phba, KERN_ERR, LOG_LIBDFC,
+				"2724 GET CGNBUF error: %d\n", rc);
+	return rc;
+}
+
 /**
  * lpfc_bsg_hst_vendor - process a vendor-specific fc_bsg_job
  * @job: fc_bsg_job to handle
@@ -5813,6 +5899,9 @@ lpfc_bsg_hst_vendor(struct bsg_job *job)
 	case LPFC_BSG_VENDOR_GET_TRUNK_INFO:
 		rc = lpfc_get_trunk_info(job);
 		break;
+	case LPFC_BSG_VENDOR_GET_CGNBUF_INFO:
+		rc = lpfc_get_cgnbuf_info(job);
+		break;
 	default:
 		rc = -EINVAL;
 		bsg_reply->reply_payload_rcv_len = 0;
diff --git a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
index 2dc71243775d..17012bcc7c38 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.h
+++ b/drivers/scsi/lpfc/lpfc_bsg.h
@@ -43,6 +43,7 @@
 #define LPFC_BSG_VENDOR_RAS_GET_CONFIG		18
 #define LPFC_BSG_VENDOR_RAS_SET_CONFIG		19
 #define LPFC_BSG_VENDOR_GET_TRUNK_INFO		20
+#define LPFC_BSG_VENDOR_GET_CGNBUF_INFO		21
 
 struct set_ct_event {
 	uint32_t command;
@@ -386,6 +387,13 @@ struct get_trunk_info_req {
 	uint32_t command;
 };
 
+struct get_cgnbuf_info_req {
+	uint32_t command;
+	uint32_t read_size;
+	uint32_t reset;
+#define LPFC_BSG_CGN_RESET_STAT		1
+};
+
 /* driver only */
 #define SLI_CONFIG_NOT_HANDLED		0
 #define SLI_CONFIG_HANDLED		1
-- 
2.26.2

