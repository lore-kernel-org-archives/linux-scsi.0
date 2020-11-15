Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE32C64E7C
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73F1322384
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 19:27:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N03FBSyb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKOT1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 14:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgKOT1K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 14:27:10 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8740DC0613D2
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:10 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c66so11359293pfa.4
        for <linux-scsi@vger.kernel.org>; Sun, 15 Nov 2020 11:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=oah2QsHwcMd8GPh0MHUWkZhxXfedUa1zp9SbiHkXdZQ=;
        b=N03FBSybDZl7kQaePmAClOV9oNOXYOoF2BjOYveBXna63R0MHtJkOF0jVmftpGuRGm
         0PabfrKK77ndQfuvJTg+h86D/n7NrGxthcL1fBc81NkQ7Y+IjSvgUSfa8g3YscamXsBw
         QVv9BPWBhckZGs2xa16NV+qO94/Khxz+3iwcw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=oah2QsHwcMd8GPh0MHUWkZhxXfedUa1zp9SbiHkXdZQ=;
        b=FVl7R29VWZoZ2nFkQXDH2yTGbVMJbenGdKQVs5TNbikDCRuOzIgQI1uRYBNYwB8mqV
         Qh2TLOqwerXQAJbycsYduo7EdI6FwnclIFgo3CnM2wbFLd4mt2b6O9ijGqD3NJKKl4Kr
         Axs6gcg5IBTaXqwb3mIjTUHW6h7p7TSiBhq8CcZrAdCg/c4KC2IBG6mMewSeyt0vp4VD
         YzF3I6I/VwEzH1JxqBFAnpYto8GGWMeqWoIMh/9iyMH5yTGfM60lLjnhMrQCeIKUGQCt
         mNuoa3/Rtyr3Y3b2XUzai2cjro9npvqvRHHK0mIWEn77Qxev2dtf7udWPulBOTwIFrWd
         KQow==
X-Gm-Message-State: AOAM533tOQyz1P9JUUtGYt1R4y7m1uJZJ1VRY1kgTkKtN6+kBr+f7Fd5
        2qU2NmHQzhHwOvAhSAXse3SS75hnd2m8gOwk0MEF9OhcJ54OhiMeKf0Uc65U8a9nqeurBctDQ9K
        INYQcAgAfkuutj/Ay8Wf4tTdQoBNVNam4vrwvaY8v4CMLCO0MszrUioUD89aVG9a+srVGahoxPb
        eEDHU=
X-Google-Smtp-Source: ABdhPJzaER+sPCWva599IpCgYDoDqpOqhr52RuBp09V2puEnE+0VN28Zf2uL86cntCrC0vbQZb2KCg==
X-Received: by 2002:aa7:8430:0:b029:18b:b3f5:ea4b with SMTP id q16-20020aa784300000b029018bb3f5ea4bmr10889829pfn.61.1605468429197;
        Sun, 15 Nov 2020 11:27:09 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v126sm15864604pfb.137.2020.11.15.11.27.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 11:27:08 -0800 (PST)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 11/17] lpfc: Enable common wqe_template support for both scsi and nvme
Date:   Sun, 15 Nov 2020 11:26:40 -0800
Message-Id: <20201115192646.12977-12-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201115192646.12977-1-james.smart@broadcom.com>
References: <20201115192646.12977-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000074563005b42a3f9d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000074563005b42a3f9d
Content-Transfer-Encoding: 8bit

The driver is currently using sli-4 wqe templates only for NVME.
Refactor the template and the placement of the service routine
so that it can be used by both SCSI and NVME.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h |   5 +-
 drivers/scsi/lpfc/lpfc_init.c |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c | 133 +---------------------------------
 drivers/scsi/lpfc/lpfc_sli.c  | 126 ++++++++++++++++++++++++++++++++
 4 files changed, 134 insertions(+), 132 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 903151aa6f02..03560478f2ce 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -590,7 +590,7 @@ struct lpfc_io_buf *lpfc_get_io_buf(struct lpfc_hba *phba,
 void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd,
 			 struct lpfc_sli4_hdw_queue *qp);
 void lpfc_io_ktime(struct lpfc_hba *phba, struct lpfc_io_buf *ncmd);
-void lpfc_nvme_cmd_template(void);
+void lpfc_wqe_cmd_template(void);
 void lpfc_nvmet_cmd_template(void);
 void lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn);
 void lpfc_nvme_prep_abort_wqe(struct lpfc_iocbq *pwqeq, u16 xritag, u8 opt);
@@ -598,3 +598,6 @@ extern int lpfc_enable_nvmet_cnt;
 extern unsigned long long lpfc_enable_nvmet[];
 extern int lpfc_no_hba_reset_cnt;
 extern unsigned long lpfc_no_hba_reset[];
+extern union lpfc_wqe128 lpfc_iread_cmd_template;
+extern union lpfc_wqe128 lpfc_iwrite_cmd_template;
+extern union lpfc_wqe128 lpfc_icmnd_cmd_template;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 86d9ab4bcebb..f4de75b2f64f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -14120,7 +14120,7 @@ lpfc_init(void)
 		fc_release_transport(lpfc_transport_template);
 		goto unregister;
 	}
-	lpfc_nvme_cmd_template();
+	lpfc_wqe_cmd_template();
 	lpfc_nvmet_cmd_template();
 
 	/* Initialize in case vector mapping is needed */
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index c5acf6800fb6..5458b8ef949f 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -62,136 +62,6 @@ lpfc_release_nvme_buf(struct lpfc_hba *, struct lpfc_io_buf *);
 
 static struct nvme_fc_port_template lpfc_nvme_template;
 
-static union lpfc_wqe128 lpfc_iread_cmd_template;
-static union lpfc_wqe128 lpfc_iwrite_cmd_template;
-static union lpfc_wqe128 lpfc_icmnd_cmd_template;
-
-/* Setup WQE templates for NVME IOs */
-void
-lpfc_nvme_cmd_template(void)
-{
-	union lpfc_wqe128 *wqe;
-
-	/* IREAD template */
-	wqe = &lpfc_iread_cmd_template;
-	memset(wqe, 0, sizeof(union lpfc_wqe128));
-
-	/* Word 0, 1, 2 - BDE is variable */
-
-	/* Word 3 - cmd_buff_len, payload_offset_len is zero */
-
-	/* Word 4 - total_xfer_len is variable */
-
-	/* Word 5 - is zero */
-
-	/* Word 6 - ctxt_tag, xri_tag is variable */
-
-	/* Word 7 */
-	bf_set(wqe_cmnd, &wqe->fcp_iread.wqe_com, CMD_FCP_IREAD64_WQE);
-	bf_set(wqe_pu, &wqe->fcp_iread.wqe_com, PARM_READ_CHECK);
-	bf_set(wqe_class, &wqe->fcp_iread.wqe_com, CLASS3);
-	bf_set(wqe_ct, &wqe->fcp_iread.wqe_com, SLI4_CT_RPI);
-
-	/* Word 8 - abort_tag is variable */
-
-	/* Word 9  - reqtag is variable */
-
-	/* Word 10 - dbde, wqes is variable */
-	bf_set(wqe_qosd, &wqe->fcp_iread.wqe_com, 0);
-	bf_set(wqe_xchg, &wqe->fcp_iread.wqe_com, LPFC_NVME_XCHG);
-	bf_set(wqe_iod, &wqe->fcp_iread.wqe_com, LPFC_WQE_IOD_READ);
-	bf_set(wqe_lenloc, &wqe->fcp_iread.wqe_com, LPFC_WQE_LENLOC_WORD4);
-	bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 0);
-	bf_set(wqe_wqes, &wqe->fcp_iread.wqe_com, 1);
-
-	/* Word 11 - pbde is variable */
-	bf_set(wqe_cmd_type, &wqe->fcp_iread.wqe_com, COMMAND_DATA_IN);
-	bf_set(wqe_cqid, &wqe->fcp_iread.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-	bf_set(wqe_pbde, &wqe->fcp_iread.wqe_com, 0);
-
-	/* Word 12 - is zero */
-
-	/* Word 13, 14, 15 - PBDE is variable */
-
-	/* IWRITE template */
-	wqe = &lpfc_iwrite_cmd_template;
-	memset(wqe, 0, sizeof(union lpfc_wqe128));
-
-	/* Word 0, 1, 2 - BDE is variable */
-
-	/* Word 3 - cmd_buff_len, payload_offset_len is zero */
-
-	/* Word 4 - total_xfer_len is variable */
-
-	/* Word 5 - initial_xfer_len is variable */
-
-	/* Word 6 - ctxt_tag, xri_tag is variable */
-
-	/* Word 7 */
-	bf_set(wqe_cmnd, &wqe->fcp_iwrite.wqe_com, CMD_FCP_IWRITE64_WQE);
-	bf_set(wqe_pu, &wqe->fcp_iwrite.wqe_com, PARM_READ_CHECK);
-	bf_set(wqe_class, &wqe->fcp_iwrite.wqe_com, CLASS3);
-	bf_set(wqe_ct, &wqe->fcp_iwrite.wqe_com, SLI4_CT_RPI);
-
-	/* Word 8 - abort_tag is variable */
-
-	/* Word 9  - reqtag is variable */
-
-	/* Word 10 - dbde, wqes is variable */
-	bf_set(wqe_qosd, &wqe->fcp_iwrite.wqe_com, 0);
-	bf_set(wqe_xchg, &wqe->fcp_iwrite.wqe_com, LPFC_NVME_XCHG);
-	bf_set(wqe_iod, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_IOD_WRITE);
-	bf_set(wqe_lenloc, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_LENLOC_WORD4);
-	bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 0);
-	bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
-
-	/* Word 11 - pbde is variable */
-	bf_set(wqe_cmd_type, &wqe->fcp_iwrite.wqe_com, COMMAND_DATA_OUT);
-	bf_set(wqe_cqid, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-	bf_set(wqe_pbde, &wqe->fcp_iwrite.wqe_com, 0);
-
-	/* Word 12 - is zero */
-
-	/* Word 13, 14, 15 - PBDE is variable */
-
-	/* ICMND template */
-	wqe = &lpfc_icmnd_cmd_template;
-	memset(wqe, 0, sizeof(union lpfc_wqe128));
-
-	/* Word 0, 1, 2 - BDE is variable */
-
-	/* Word 3 - payload_offset_len is variable */
-
-	/* Word 4, 5 - is zero */
-
-	/* Word 6 - ctxt_tag, xri_tag is variable */
-
-	/* Word 7 */
-	bf_set(wqe_cmnd, &wqe->fcp_icmd.wqe_com, CMD_FCP_ICMND64_WQE);
-	bf_set(wqe_pu, &wqe->fcp_icmd.wqe_com, 0);
-	bf_set(wqe_class, &wqe->fcp_icmd.wqe_com, CLASS3);
-	bf_set(wqe_ct, &wqe->fcp_icmd.wqe_com, SLI4_CT_RPI);
-
-	/* Word 8 - abort_tag is variable */
-
-	/* Word 9  - reqtag is variable */
-
-	/* Word 10 - dbde, wqes is variable */
-	bf_set(wqe_qosd, &wqe->fcp_icmd.wqe_com, 1);
-	bf_set(wqe_xchg, &wqe->fcp_icmd.wqe_com, LPFC_NVME_XCHG);
-	bf_set(wqe_iod, &wqe->fcp_icmd.wqe_com, LPFC_WQE_IOD_NONE);
-	bf_set(wqe_lenloc, &wqe->fcp_icmd.wqe_com, LPFC_WQE_LENLOC_NONE);
-	bf_set(wqe_dbde, &wqe->fcp_icmd.wqe_com, 0);
-	bf_set(wqe_wqes, &wqe->fcp_icmd.wqe_com, 1);
-
-	/* Word 11 */
-	bf_set(wqe_cmd_type, &wqe->fcp_icmd.wqe_com, COMMAND_DATA_IN);
-	bf_set(wqe_cqid, &wqe->fcp_icmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
-	bf_set(wqe_pbde, &wqe->fcp_icmd.wqe_com, 0);
-
-	/* Word 12, 13, 14, 15 - is zero */
-}
-
 /**
  * lpfc_nvme_prep_abort_wqe - set up 'abort' work queue entry.
  * @pwqeq: Pointer to command iocb.
@@ -1403,6 +1273,9 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 	/* Word 9 */
 	bf_set(wqe_reqtag, &wqe->generic.wqe_com, pwqeq->iotag);
 
+	/* Word 10 */
+	bf_set(wqe_xchg, &wqe->fcp_iwrite.wqe_com, LPFC_NVME_XCHG);
+
 	/* Words 13 14 15 are for PBDE support */
 
 	pwqeq->vport = vport;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 116a6822c201..b1d5b4484015 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -90,12 +90,138 @@ static void __lpfc_sli4_consume_cqe(struct lpfc_hba *phba,
 				    struct lpfc_queue *cq,
 				    struct lpfc_cqe *cqe);
 
+union lpfc_wqe128 lpfc_iread_cmd_template;
+union lpfc_wqe128 lpfc_iwrite_cmd_template;
+union lpfc_wqe128 lpfc_icmnd_cmd_template;
+
 static IOCB_t *
 lpfc_get_iocb_from_iocbq(struct lpfc_iocbq *iocbq)
 {
 	return &iocbq->iocb;
 }
 
+/* Setup WQE templates for IOs */
+void lpfc_wqe_cmd_template(void)
+{
+	union lpfc_wqe128 *wqe;
+
+	/* IREAD template */
+	wqe = &lpfc_iread_cmd_template;
+	memset(wqe, 0, sizeof(union lpfc_wqe128));
+
+	/* Word 0, 1, 2 - BDE is variable */
+
+	/* Word 3 - cmd_buff_len, payload_offset_len is zero */
+
+	/* Word 4 - total_xfer_len is variable */
+
+	/* Word 5 - is zero */
+
+	/* Word 6 - ctxt_tag, xri_tag is variable */
+
+	/* Word 7 */
+	bf_set(wqe_cmnd, &wqe->fcp_iread.wqe_com, CMD_FCP_IREAD64_WQE);
+	bf_set(wqe_pu, &wqe->fcp_iread.wqe_com, PARM_READ_CHECK);
+	bf_set(wqe_class, &wqe->fcp_iread.wqe_com, CLASS3);
+	bf_set(wqe_ct, &wqe->fcp_iread.wqe_com, SLI4_CT_RPI);
+
+	/* Word 8 - abort_tag is variable */
+
+	/* Word 9  - reqtag is variable */
+
+	/* Word 10 - dbde, wqes is variable */
+	bf_set(wqe_qosd, &wqe->fcp_iread.wqe_com, 0);
+	bf_set(wqe_iod, &wqe->fcp_iread.wqe_com, LPFC_WQE_IOD_READ);
+	bf_set(wqe_lenloc, &wqe->fcp_iread.wqe_com, LPFC_WQE_LENLOC_WORD4);
+	bf_set(wqe_dbde, &wqe->fcp_iread.wqe_com, 0);
+	bf_set(wqe_wqes, &wqe->fcp_iread.wqe_com, 1);
+
+	/* Word 11 - pbde is variable */
+	bf_set(wqe_cmd_type, &wqe->fcp_iread.wqe_com, COMMAND_DATA_IN);
+	bf_set(wqe_cqid, &wqe->fcp_iread.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+	bf_set(wqe_pbde, &wqe->fcp_iread.wqe_com, 0);
+
+	/* Word 12 - is zero */
+
+	/* Word 13, 14, 15 - PBDE is variable */
+
+	/* IWRITE template */
+	wqe = &lpfc_iwrite_cmd_template;
+	memset(wqe, 0, sizeof(union lpfc_wqe128));
+
+	/* Word 0, 1, 2 - BDE is variable */
+
+	/* Word 3 - cmd_buff_len, payload_offset_len is zero */
+
+	/* Word 4 - total_xfer_len is variable */
+
+	/* Word 5 - initial_xfer_len is variable */
+
+	/* Word 6 - ctxt_tag, xri_tag is variable */
+
+	/* Word 7 */
+	bf_set(wqe_cmnd, &wqe->fcp_iwrite.wqe_com, CMD_FCP_IWRITE64_WQE);
+	bf_set(wqe_pu, &wqe->fcp_iwrite.wqe_com, PARM_READ_CHECK);
+	bf_set(wqe_class, &wqe->fcp_iwrite.wqe_com, CLASS3);
+	bf_set(wqe_ct, &wqe->fcp_iwrite.wqe_com, SLI4_CT_RPI);
+
+	/* Word 8 - abort_tag is variable */
+
+	/* Word 9  - reqtag is variable */
+
+	/* Word 10 - dbde, wqes is variable */
+	bf_set(wqe_qosd, &wqe->fcp_iwrite.wqe_com, 0);
+	bf_set(wqe_iod, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_IOD_WRITE);
+	bf_set(wqe_lenloc, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_LENLOC_WORD4);
+	bf_set(wqe_dbde, &wqe->fcp_iwrite.wqe_com, 0);
+	bf_set(wqe_wqes, &wqe->fcp_iwrite.wqe_com, 1);
+
+	/* Word 11 - pbde is variable */
+	bf_set(wqe_cmd_type, &wqe->fcp_iwrite.wqe_com, COMMAND_DATA_OUT);
+	bf_set(wqe_cqid, &wqe->fcp_iwrite.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+	bf_set(wqe_pbde, &wqe->fcp_iwrite.wqe_com, 0);
+
+	/* Word 12 - is zero */
+
+	/* Word 13, 14, 15 - PBDE is variable */
+
+	/* ICMND template */
+	wqe = &lpfc_icmnd_cmd_template;
+	memset(wqe, 0, sizeof(union lpfc_wqe128));
+
+	/* Word 0, 1, 2 - BDE is variable */
+
+	/* Word 3 - payload_offset_len is variable */
+
+	/* Word 4, 5 - is zero */
+
+	/* Word 6 - ctxt_tag, xri_tag is variable */
+
+	/* Word 7 */
+	bf_set(wqe_cmnd, &wqe->fcp_icmd.wqe_com, CMD_FCP_ICMND64_WQE);
+	bf_set(wqe_pu, &wqe->fcp_icmd.wqe_com, 0);
+	bf_set(wqe_class, &wqe->fcp_icmd.wqe_com, CLASS3);
+	bf_set(wqe_ct, &wqe->fcp_icmd.wqe_com, SLI4_CT_RPI);
+
+	/* Word 8 - abort_tag is variable */
+
+	/* Word 9  - reqtag is variable */
+
+	/* Word 10 - dbde, wqes is variable */
+	bf_set(wqe_qosd, &wqe->fcp_icmd.wqe_com, 1);
+	bf_set(wqe_iod, &wqe->fcp_icmd.wqe_com, LPFC_WQE_IOD_NONE);
+	bf_set(wqe_lenloc, &wqe->fcp_icmd.wqe_com, LPFC_WQE_LENLOC_NONE);
+	bf_set(wqe_dbde, &wqe->fcp_icmd.wqe_com, 0);
+	bf_set(wqe_wqes, &wqe->fcp_icmd.wqe_com, 1);
+
+	/* Word 11 */
+	bf_set(wqe_cmd_type, &wqe->fcp_icmd.wqe_com, COMMAND_DATA_IN);
+	bf_set(wqe_cqid, &wqe->fcp_icmd.wqe_com, LPFC_WQE_CQ_ID_DEFAULT);
+	bf_set(wqe_pbde, &wqe->fcp_icmd.wqe_com, 0);
+
+	/* Word 12, 13, 14, 15 - is zero */
+}
+
 #if defined(CONFIG_64BIT) && defined(__LITTLE_ENDIAN)
 /**
  * lpfc_sli4_pcimem_bcopy - SLI4 memory copy function
-- 
2.26.2


--00000000000074563005b42a3f9d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQPwYJKoZIhvcNAQcCoIIQMDCCECwCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg2UMIIE6DCCA9CgAwIBAgIOSBtqCRO9gCTKXSLwFPMwDQYJKoZIhvcNAQELBQAwTDEgMB4GA1UE
CxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMT
Ckdsb2JhbFNpZ24wHhcNMTYwNjE1MDAwMDAwWhcNMjQwNjE1MDAwMDAwWjBdMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTEzMDEGA1UEAxMqR2xvYmFsU2lnbiBQZXJzb25h
bFNpZ24gMiBDQSAtIFNIQTI1NiAtIEczMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
tpZok2X9LAHsYqMNVL+Ly6RDkaKar7GD8rVtb9nw6tzPFnvXGeOEA4X5xh9wjx9sScVpGR5wkTg1
fgJIXTlrGESmaqXIdPRd9YQ+Yx9xRIIIPu3Jp/bpbiZBKYDJSbr/2Xago7sb9nnfSyjTSnucUcIP
ZVChn6hKneVGBI2DT9yyyD3PmCEJmEzA8Y96qT83JmVH2GaPSSbCw0C+Zj1s/zqtKUbwE5zh8uuZ
p4vC019QbaIOb8cGlzgvTqGORwK0gwDYpOO6QQdg5d03WvIHwTunnJdoLrfvqUg2vOlpqJmqR+nH
9lHS+bEstsVJtZieU1Pa+3LzfA/4cT7XA/pnwwIDAQABo4IBtTCCAbEwDgYDVR0PAQH/BAQDAgEG
MGoGA1UdJQRjMGEGCCsGAQUFBwMCBggrBgEFBQcDBAYIKwYBBQUHAwkGCisGAQQBgjcUAgIGCisG
AQQBgjcKAwQGCSsGAQQBgjcVBgYKKwYBBAGCNwoDDAYIKwYBBQUHAwcGCCsGAQUFBwMRMBIGA1Ud
EwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFGlygmIxZ5VEhXeRgMQENkmdewthMB8GA1UdIwQYMBaA
FI/wS3+oLkUkrk1Q+mOai97i3Ru8MD4GCCsGAQUFBwEBBDIwMDAuBggrBgEFBQcwAYYiaHR0cDov
L29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3RyMzA2BgNVHR8ELzAtMCugKaAnhiVodHRwOi8vY3Js
Lmdsb2JhbHNpZ24uY29tL3Jvb3QtcjMuY3JsMGcGA1UdIARgMF4wCwYJKwYBBAGgMgEoMAwGCisG
AQQBoDIBKAowQQYJKwYBBAGgMgFfMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2JhbHNp
Z24uY29tL3JlcG9zaXRvcnkvMA0GCSqGSIb3DQEBCwUAA4IBAQConc0yzHxn4gtQ16VccKNm4iXv
6rS2UzBuhxI3XDPiwihW45O9RZXzWNgVcUzz5IKJFL7+pcxHvesGVII+5r++9eqI9XnEKCILjHr2
DgvjKq5Jmg6bwifybLYbVUoBthnhaFB0WLwSRRhPrt5eGxMw51UmNICi/hSKBKsHhGFSEaJQALZy
4HL0EWduE6ILYAjX6BSXRDtHFeUPddb46f5Hf5rzITGLsn9BIpoOVrgS878O4JnfUWQi29yBfn75
HajifFvPC+uqn+rcVnvrpLgsLOYG/64kWX/FRH8+mhVe+mcSX3xsUpcxK9q9vLTVtroU/yJUmEC4
OcH5dQsbHBqjMIIDXzCCAkegAwIBAgILBAAAAAABIVhTCKIwDQYJKoZIhvcNAQELBQAwTDEgMB4G
A1UECxMXR2xvYmFsU2lnbiBSb290IENBIC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNV
BAMTCkdsb2JhbFNpZ24wHhcNMDkwMzE4MTAwMDAwWhcNMjkwMzE4MTAwMDAwWjBMMSAwHgYDVQQL
ExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UEAxMK
R2xvYmFsU2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMwldpB5BngiFvXAg7aE
yiie/QV2EcWtiHL8RgJDx7KKnQRfJMsuS+FggkbhUqsMgUdwbN1k0ev1LKMPgj0MK66X17YUhhB5
uzsTgHeMCOFJ0mpiLx9e+pZo34knlTifBtc+ycsmWQ1z3rDI6SYOgxXG71uL0gRgykmmKPZpO/bL
yCiR5Z2KYVc3rHQU3HTgOu5yLy6c+9C7v/U9AOEGM+iCK65TpjoWc4zdQQ4gOsC0p6Hpsk+QLjJg
6VfLuQSSaGjlOCZgdbKfd/+RFO+uIEn8rUAVSNECMWEZXriX7613t2Saer9fwRPvm2L7DWzgVGkW
qQPabumDk3F2xmmFghcCAwEAAaNCMEAwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8w
HQYDVR0OBBYEFI/wS3+oLkUkrk1Q+mOai97i3Ru8MA0GCSqGSIb3DQEBCwUAA4IBAQBLQNvAUKr+
yAzv95ZURUm7lgAJQayzE4aGKAczymvmdLm6AC2upArT9fHxD4q/c2dKg8dEe3jgr25sbwMpjjM5
RcOO5LlXbKr8EpbsU8Yt5CRsuZRj+9xTaGdWPoO4zzUhw8lo/s7awlOqzJCK6fBdRoyV3XpYKBov
Hd7NADdBj+1EbddTKJd+82cEHhXXipa0095MJ6RMG3NzdvQXmcIfeg7jLQitChws/zyrVQ4PkX42
68NXSb7hLi18YIvDQVETI53O9zJrlAGomecsMx86OyXShkDOOyyGeMlhLxS67ttVb9+E7gUJTb0o
2HLO02JQZR7rkpeDMdmztcpHWD9fMIIFQTCCBCmgAwIBAgIMfmKtsn6cI8G7HjzCMA0GCSqGSIb3
DQEBCwUAMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTMwMQYDVQQD
EypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMwHhcNMjAwOTE3MDU0
NjI0WhcNMjIwOTE4MDU0NjI0WjCBjDELMAkGA1UEBhMCSU4xEjAQBgNVBAgTCUthcm5hdGFrYTES
MBAGA1UEBxMJQmFuZ2Fsb3JlMRYwFAYDVQQKEw1Ccm9hZGNvbSBJbmMuMRQwEgYDVQQDEwtKYW1l
cyBTbWFydDEnMCUGCSqGSIb3DQEJARYYamFtZXMuc21hcnRAYnJvYWRjb20uY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0B4Ym0dby5rc/1eyTwvNzsepN0S9eBGyF45ltfEmEmoe
sY3NAmThxJaLBzoPYjCpfPWh65cxrVIOw9R3a9TrkDN+aISE1NPyyHOabU57I8bKvfS8WMpCQKSJ
pDWUbzanP3MMP4C2qbJgQW+xh9UDzBi8u69f40kP+cLEPNJWbz0KxNNp7H/4zWNyTouJRtO6QKVh
XqR+mg0QW4TJlH5sJ7NIbVGZKzs0PEbUJJJw0zJsp3m0iS6AzNFtTGHWVO1me58DIYR/VDSiY9Sh
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
rbJ+nCPBux48wjANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgRii4aAgVgJvRuV9y
Nvo6GguCQ8h8sp8fWhJ2ECAvdwQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjAxMTE1MTkyNzA5WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0BAQcw
CwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAE6ZuhCKsGFaebJ952WovhrTaDC4mRr4DlKq
dLqs1WBrXa50L59eIK8n9aiQU3ZMjXS2WeRhmwGLGcr7O6gX9QaZM+yohTZq2SbDSzhsQ5yxPoGz
ytz7+Tj23CxpYnr1FTDT3vu4kpn1W+a2xYmLwOs5CxPhVARwk8ErrjXFOqq2gNwgL5a/gjNltW2I
Flhi+zdeEXQr3p0XFkrbDLuGDpGXWZduEVLhpbZdpHUfrn5PpxlwReu1c/uvvQzjGED98y42GaBj
RJWwXiN2O+4A5r8jPcM08AWtnNr0PszNOFwVwDiCZKTeqviBzNuN1jA7uiAwH4+GNmXe33y77Tnb
JJI=
--00000000000074563005b42a3f9d--
