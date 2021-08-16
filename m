Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EF1C432BE
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C2260FD7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhHPQaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhHPQaS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:30:18 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E688C061764
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:46 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id l11so21318507plk.6
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NR2nsA+CsS2cAHEcsdJeCbbR/C+OLD9Y0JkWO0fkFp8=;
        b=C9yR5aJHQ9opPJd8l8p4jgT/77/x9qnI8ugH4eoitArjVgl+hhmObVHyOldKPdv6Hy
         x7r4B/5B0gi6RyllcQv8XeAuqGH5zbjJuWTls6wX9DcmI+LhbJARJSbpx1rB0hY+zZs4
         RHazWaAlh8JIbgHCAbducoKWHJmMrUS0jTe6/vRP0BwO23aJPiultH9BKrdvFxlx0mGl
         a8pRo04XYNG7IQ7I1RG35Qv2MpsywhQrNbI5WigWDSdoDcf+ZOMHsU/4MH2Su0zDom+N
         yiP12eFCMWWbw+nhEYODhRI22HYCduKFU47d63l78mK3nySeOp4UvyB6P4Rg3LdpkNwx
         RhtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NR2nsA+CsS2cAHEcsdJeCbbR/C+OLD9Y0JkWO0fkFp8=;
        b=LwDG9WcUzi/Ud3jxfpIEi3teNkyBURgBSehnm4UskU4l76K47kTLxinSAEidCggdf9
         Km3EhZMEwTdereH561SgmS8baEror1AsCnc/wv9hSMl2LiQfw21jINTeIJ2aB8UzUrVx
         GJUqy2rZqnObpSkki3KhmQbZ/tgPju/h/cseGJppoNcmX+nCAng6OKD9aJ7PlPtYPWXA
         9FjM+1MCcpn9H+2Jqco8t89VSG3wrhCjq+0cExroJ93ewCpziMMaag5MuM3aizZuuedE
         hY3FeNMrou2Zjg81ouC9Pw7joK9TUWI2wJRaROziO0v4wGwktqgWS8L9LjCVFUUvPMTA
         Nhpg==
X-Gm-Message-State: AOAM5331uzCsN0GnfPnQ4F2bq6XTAY+EvNCP8YcXxUFLNB1qoUzMY23k
        YuCWJGNtDdTYiTcI5PBWGFrBDJOF0ek=
X-Google-Smtp-Source: ABdhPJw0NZR++jG8fs3RhM6AP3aV+bVyCj3SA/XMQ/PoX0D71+mLunRQbga9FxIs9/mH9864zD0e3w==
X-Received: by 2002:a17:902:aa43:b029:12d:242f:32eb with SMTP id c3-20020a170902aa43b029012d242f32ebmr13882513plr.66.1629131386097;
        Mon, 16 Aug 2021 09:29:46 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm11257938pfv.131.2021.08.16.09.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:29:45 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH v3 14/16] lpfc: Add bsg support for retrieving adapter cmf data
Date:   Mon, 16 Aug 2021 09:28:59 -0700
Message-Id: <20210816162901.121235-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210816162901.121235-1-jsmart2021@gmail.com>
References: <20210816162901.121235-1-jsmart2021@gmail.com>
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

