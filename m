Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F17B1CCA47C
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 17:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345157AbiFCRrK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239027AbiFCRqi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 13:46:38 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 911FF532DE
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2022 10:43:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id w2-20020a17090ac98200b001e0519fe5a8so7646442pjt.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2022 10:43:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wewEppFm0xz+tE3mu3MsP/tDp/xuSKRq2CYeWLrIEgw=;
        b=Epbuzzkt03cr7SRy401aVU1c+PzNCtizaWaaDVn8Vc4iYp2cduCq82u2SaUlbQPrIA
         JGitcLb3sJGEZkraoVaMzbdguadflZ5Uwym/gohnUuHjf7r7fn/7KNOs8hr2PEsv+Gw7
         js69T/UvKnTjCM/DYA/AW1djpM2Gri2yem2i+UCtsDPt1tyXgk3tmXfzkoihG+qTGpB1
         FuD8EJ6CFmqFWiN4yB82tAGHqBoUJyiVW0ZN3y1UYWlDBLjo63UifZ2QRyqvvR1GCUy+
         tqgaf6ZnIbcMhgcbaq2iJEHhcm20OZzDhoQ3t19uDrqVEnyKN0CwJafjzOmt4obgdaXw
         C1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wewEppFm0xz+tE3mu3MsP/tDp/xuSKRq2CYeWLrIEgw=;
        b=RnNgLGrgiQoaKCwKUCV+ahyJ1LjP8jLDi4hY9rygVCT0gnT6T0L4riHK9A4Ut97CFC
         H+/1toBmLhIkewiQKrsrzi+Jxsin1y2PH7jx5Q+mTru7iBaY8UixkDzAOm+lU7Y+OWNg
         xS5hBicSab19Y58Q7vqTsudnX54gE+og/g+Ma3miOfgJzItAvikiq2GY8Q/edzODl95b
         sSIJLqs+cE5nd4tEmfPPyDXFhR5y5ghuT6wCGurl+XNSJjzaXyvM0nks+8bH4cn6JMQf
         41vikqkHw4qa++vKyuFHLQiIR1DXLr1Wf4tKWAQa4bgWutTGakJEw1b/6kptGiCQNGUY
         qaZQ==
X-Gm-Message-State: AOAM530ZV3LMOsC+ldlqujzE8ao5dNfXeXupTtExfHE07Fr8bw8/TueU
        JTvKfjq/0/rgjMUHrFYOpazuDq29DCo=
X-Google-Smtp-Source: ABdhPJxQBN/HCVYfnHpltNXTvfoHgmXTZjbv5IKxxQaThwcJqiH7oO6aZTkYJVb1EUhD/8ARKkj8/w==
X-Received: by 2002:a17:90b:1c8e:b0:1bf:364c:dd7a with SMTP id oo14-20020a17090b1c8e00b001bf364cdd7amr11907286pjb.103.1654278221985;
        Fri, 03 Jun 2022 10:43:41 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:41 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 8/9] lpfc: Allow reduced polling rate for nvme_admin_async_event cmd completion
Date:   Fri,  3 Jun 2022 10:43:28 -0700
Message-Id: <20220603174329.63777-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220603174329.63777-1-jsmart2021@gmail.com>
References: <20220603174329.63777-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

NVME Asynchronous Event Request commands have no command timeout value per
specifications.

Set WQE option to allow a reduced FLUSH polling rate for I/O error
detection specifically for nvme_admin_async_event commands.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  3 +++
 drivers/scsi/lpfc/lpfc_nvme.c | 11 +++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 8511369d2cf8..f024415731ac 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4487,6 +4487,9 @@ struct wqe_common {
 #define wqe_sup_SHIFT         6
 #define wqe_sup_MASK          0x00000001
 #define wqe_sup_WORD          word11
+#define wqe_ffrq_SHIFT         6
+#define wqe_ffrq_MASK          0x00000001
+#define wqe_ffrq_WORD          word11
 #define wqe_wqec_SHIFT        7
 #define wqe_wqec_MASK         0x00000001
 #define wqe_wqec_WORD         word11
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 9cc22cefcb37..cd10ee6482fc 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1207,7 +1207,8 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 {
 	struct lpfc_hba *phba = vport->phba;
 	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvmeCmd;
-	struct lpfc_iocbq *pwqeq = &(lpfc_ncmd->cur_iocbq);
+	struct nvme_common_command *sqe;
+	struct lpfc_iocbq *pwqeq = &lpfc_ncmd->cur_iocbq;
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	uint32_t req_len;
 
@@ -1264,8 +1265,14 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 		cstat->control_requests++;
 	}
 
-	if (pnode->nlp_nvme_info & NLP_NVME_NSLER)
+	if (pnode->nlp_nvme_info & NLP_NVME_NSLER) {
 		bf_set(wqe_erp, &wqe->generic.wqe_com, 1);
+		sqe = &((struct nvme_fc_cmd_iu *)
+			nCmd->cmdaddr)->sqe.common;
+		if (sqe->opcode == nvme_admin_async_event)
+			bf_set(wqe_ffrq, &wqe->generic.wqe_com, 1);
+	}
+
 	/*
 	 * Finish initializing those WQE fields that are independent
 	 * of the nvme_cmnd request_buffer
-- 
2.26.2

