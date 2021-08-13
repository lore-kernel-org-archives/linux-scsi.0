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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FB5C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF319610A7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 02:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbhHMCJl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 22:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbhHMCJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 22:09:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E77C0617A8
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so13843368pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Aug 2021 19:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NR2nsA+CsS2cAHEcsdJeCbbR/C+OLD9Y0JkWO0fkFp8=;
        b=vh9eC1LYd7/ugKRiWrqCHRJXIWVqSJnGugNlHL8WeDnAH/AxIos+4KX6XBy14IOe8p
         EWk1hHBeUvHgWcC+QUcmB5zYbkHTNX69Ap9077tAgnxy23p8Fz8vg11k3Hr7M1ByDjLz
         1pKWxC0xcLiOAXvEL3ExedxGbT6QyiGM2T6n0RBa2u2DyS6RpjkL0+kPcxhl+nFremEi
         tyuLcbCNskr6TPhMaNOD22S74Mk9m3kfw7X3htdlTnuX8sZOfu5JmkqloYF4xpTkAZF5
         bHCvUQbUv9bTyhtAKqU5+VgMlOeSZci72uJm0LeQLM0Y1FEyKsHBReDCocMTqpHffUC0
         xvzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NR2nsA+CsS2cAHEcsdJeCbbR/C+OLD9Y0JkWO0fkFp8=;
        b=pI1V0NMKPMQh8+bIjDxgGFnkuSVtU7dnBdPIwVI1mNwiQb3ZRwLDBO5He71Ub6FuLG
         Mnr2JlaJDWvTByQO6kY3ZmmYwdeTdogv6mczeKo4MxVL4CNGSvuLwLdE/LMULWimW4+L
         lJ+jDRh1Q531WI7p1aoMTllDX2Ltq9JotFt8Gs0HDQuB6z7QIw/pNewOqYdlb8A3MnM4
         5gzoJhUIRCd4FvUEmuoOoqwTzUf/DbowhpkjkzcEHB99GcdIOGHWRlcE9hRad4fNq9+/
         KyT81q3EvftzqWaEvJwWNIJpknyFk3WCT+HnSURc+wQeDbVHOKUMp9b+wUw6QFJauL19
         Ar0Q==
X-Gm-Message-State: AOAM533sHwlikcph4TDvNg9S6mNQHALh9R1FJJiAufJIXzFzv8Ve+Fwv
        DX85py/cf8JJ2AGQgL46OOKChHnwZf8=
X-Google-Smtp-Source: ABdhPJzLNYcTMFsdalIFYeDbhG0lNmVrQFIJeST9diIEwNPksZzsMC5DWvqbHRjvBlVrNTIYqyTZ4A==
X-Received: by 2002:a17:90a:930e:: with SMTP id p14mr97949pjo.132.1628820538260;
        Thu, 12 Aug 2021 19:08:58 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ca7sm102619pjb.11.2021.08.12.19.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 19:08:58 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 14/16] lpfc: Add bsg support for retrieving adapter cmf data
Date:   Thu, 12 Aug 2021 19:08:10 -0700
Message-Id: <20210813020812.99014-15-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210813020812.99014-1-jsmart2021@gmail.com>
References: <20210813020812.99014-1-jsmart2021@gmail.com>
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

