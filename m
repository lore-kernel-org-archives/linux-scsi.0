Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA4CEB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjGXU1Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjGXU1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:27:24 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6540CA4
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:27:23 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-66767d628e2so2689958b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230443; x=1690835243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wOov0520Tsvv1mNyYNP1GOHpEOTOTwae66oDFZbDj3U=;
        b=jqanxLVCm8m04pEl/u6zM8GylJMOxPJAkxowPPMboR82/9ZwdV6itGyG9l4pmnrRxG
         tfTIs+U84zSkafV0ha/fXFfkgb3BYbvlQHKY4vzTI2vbTXI3KAIfyFiA3M34hrsGjSfE
         4UuN3iaZsHRgUBisoQeomDwpzCzWpydkM37Aa/4YEOupM3YsQMHcfFBEX6B8dMdcPeyx
         CceOtdTNqheA8+97LbN0rtXBk4C7flcNtmE+7pcT6J/oIWUYp7hCXHA1LtkNSnViT1Cn
         apAGR8TUa9Txt+248A+x85j7bx8IY4OyEl26WabSmiirNTfhbLr7i1Qv6Tt6gtXqZNP4
         VtTw==
X-Gm-Message-State: ABy/qLYlk25omoz9VwXWkMpibpagM30FHZPSCr7vKDvgeZ0Mli2PEC6d
        cB3cWf3o9Om9V12/bkJkc8A=
X-Google-Smtp-Source: APBJJlEArGoERtQeFDS5mLkqZ3OkUICbkYlXE4szTkyIoo6NpV+WMKgXvrB7QhT8XTze8R/kraUwuA==
X-Received: by 2002:a05:6a20:1593:b0:133:dc0a:37e7 with SMTP id h19-20020a056a20159300b00133dc0a37e7mr8414581pzj.13.1690230442759;
        Mon, 24 Jul 2023 13:27:22 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:27:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH 06/12] scsi: ufs: Simplify zero-initialization
Date:   Mon, 24 Jul 2023 13:16:41 -0700
Message-ID: <20230724202024.3379114-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use { } instead of { { 0 }, } to zero-initialize data structures on the
stack. This patch fixes two W=2 warnings.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ca520f2b1820..5e248c60f887 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7040,7 +7040,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 		u8 tm_function, u8 *tm_response)
 {
-	struct utp_task_req_desc treq = { { 0 }, };
+	struct utp_task_req_desc treq = { };
 	enum utp_ocs ocs_value;
 	int err;
 
@@ -7205,7 +7205,7 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
 {
 	int err;
 	enum dev_cmd_type cmd_type = DEV_CMD_TYPE_QUERY;
-	struct utp_task_req_desc treq = { { 0 }, };
+	struct utp_task_req_desc treq = { };
 	enum utp_ocs ocs_value;
 	u8 tm_f = be32_to_cpu(req_upiu->header.dword_1) >> 16 & MASK_TM_FUNC;
 
