Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC62EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:28:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjGXU23 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjGXU22 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:28:28 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6636012C
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:28:27 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-666edfc50deso3084982b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:28:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230507; x=1690835307;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7T53idmAJlaUUsVT8486ZpTuANeBFWS6664r+dJZlOQ=;
        b=JUMJH5EPDM4bqAGtpHWzTBZATl5xJDTENRf/uOKykOXVYk8DWColaCLE9iQlhrekEB
         cRmv+C7gqfZiRbk77AbiFDR+1xjw8WSnlu1FFiAGvgPFTNQ3ew8lpWdsQzz6lzSguxbe
         pYwSme8nivXsl2KpyTjYmfRGq+5kkTxD2KTLFLBghpUnw1ocjM77yv0XRfYudAMnGNik
         GjAmFmUWsvKl7+x038C1obrxjaZC+4Mr2I73NyNHgkx/nv4d9Lh5E5hxsvTnDlpxjNQF
         pO33pQtDEciul6q5OH7vvY3EJjZrS+A4mEzd+/DmBj5FYHRHRanW1Y7kGEre42GxLMG8
         Kv3w==
X-Gm-Message-State: ABy/qLb8rnZN1hYNsID37vsH37KQ662RdMr1R9MMczh8BGOAb+wEX6We
        A+lbDZenHLo+pzMIS8TlDqc=
X-Google-Smtp-Source: APBJJlEM3mDwUNOn9nzVoX9aPGnGyjfJs5AvOeO+3Ib24w3h/qfpqJsV3lxZTuL+QZIqOIpR3R9PSA==
X-Received: by 2002:a05:6a21:6d87:b0:133:38cb:2b93 with SMTP id wl7-20020a056a216d8700b0013338cb2b93mr433880pzb.9.1690230506800;
        Mon, 24 Jul 2023 13:28:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:28:26 -0700 (PDT)
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
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Po-Wen Kao <powen.kao@mediatek.com>,
        Eric Biggers <ebiggers@google.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Daniil Lunev <dlunev@chromium.org>
Subject: [PATCH 10/12] scsi: ufs: Remove a member variable
Date:   Mon, 24 Jul 2023 13:16:45 -0700
Message-ID: <20230724202024.3379114-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724202024.3379114-1-bvanassche@acm.org>
References: <20230724202024.3379114-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the 'response' member variable because no code reads its value.
Additionally, move the ufs_query_req and ufs_query_res data structure
definitions into include/ufs/ufshcd.h because these data structures
are related to the UFS host controller driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c |  6 +-----
 include/ufs/ufs.h         | 20 --------------------
 include/ufs/ufshcd.h      | 19 +++++++++++++++++++
 3 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bf76ea59ba6c..4348b0dfde29 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -3014,12 +3014,8 @@ static int ufshcd_clear_cmd(struct ufs_hba *hba, u32 task_tag)
 static int
 ufshcd_check_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
-	struct ufs_query_res *query_res = &hba->dev_cmd.query.response;
-
-	/* Get the UPIU response */
-	query_res->response = ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) >>
+	return ufshcd_get_rsp_upiu_result(lrbp->ucd_rsp_ptr) >>
 				UPIU_RSP_CODE_OFFSET;
-	return query_res->response;
 }
 
 /**
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 6ee7844b9670..20063a2f01a4 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -536,26 +536,6 @@ struct utp_upiu_rsp {
 	};
 };
 
-/**
- * struct ufs_query_req - parameters for building a query request
- * @query_func: UPIU header query function
- * @upiu_req: the query request data
- */
-struct ufs_query_req {
-	u8 query_func;
-	struct utp_upiu_query upiu_req;
-};
-
-/**
- * struct ufs_query_resp - UPIU QUERY
- * @response: device response code
- * @upiu_res: query response data
- */
-struct ufs_query_res {
-	u8 response;
-	struct utp_upiu_query upiu_res;
-};
-
 /*
  * VCCQ & VCCQ2 current requirement when UFS device is in sleep state
  * and link is in Hibern8 state.
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 2b1f4f2a4464..bf4070a4b95f 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -202,6 +202,25 @@ struct ufshcd_lrb {
 	bool req_abort_skip;
 };
 
+/**
+ * struct ufs_query_req - parameters for building a query request
+ * @query_func: UPIU header query function
+ * @upiu_req: the query request data
+ */
+struct ufs_query_req {
+	u8 query_func;
+	struct utp_upiu_query upiu_req;
+};
+
+/**
+ * struct ufs_query_resp - UPIU QUERY
+ * @response: device response code
+ * @upiu_res: query response data
+ */
+struct ufs_query_res {
+	struct utp_upiu_query upiu_res;
+};
+
 /**
  * struct ufs_query - holds relevant data structures for query request
  * @request: request upiu and function
