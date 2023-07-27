Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ACEC001DC
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjG0TsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231299AbjG0TsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:48:09 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03334E44
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:48:09 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-686f1240a22so1121907b3a.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:48:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487288; x=1691092088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X4EGceuHmtqG25ez8dghTb/6tvuIDMjB2PXg61pkD+Y=;
        b=H+3lZqEhuft5rMupFsazrqJJ6A0hC0ZJ895p8zrH3yi0Vr6fuQdkgDu2ZGDM0KaKNK
         UgO/mmUtCb2MrLKSxd9aZqWAU2nZuCi1hFiSGxvB9OTUIUNtZ2Y9o5TnhemccP9sfAL1
         mauHJJPVQ/DxKiLfuAn/K5elMKUAPq/KQi8jn4ukfJWowypYjXOu91vqEjuN9/c5B5Ap
         bYs8tohAPsaubAiverys0yukKOf/nuT3DLboTroQWGGnA2bQiqcFjpv1et8dEdAwnKkE
         M4hKqbwX6Soin2KqQ9qFdrS1L5mvdYhBQN3QNHybOF4VRM7BHfcKiN6gqbgVb2oZHset
         F4mA==
X-Gm-Message-State: ABy/qLY6bhNNvKL/vw//x3e14FinuPIwSlY23ihbzxB/k64DScABO+/n
        /lHfPewQcgCc1FzPOkJxb7Oz5vgZgB4=
X-Google-Smtp-Source: APBJJlFRn524sNIQJFIYhtgMn9rSODpNdVzHgyfKaHDo8itj13o3mLC6oyNfWEoe/5bENw7gsbcDbQ==
X-Received: by 2002:a05:6a20:3ca2:b0:134:8d7f:f4d9 with SMTP id b34-20020a056a203ca200b001348d7ff4d9mr53359pzj.52.1690487288321;
        Thu, 27 Jul 2023 12:48:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:48:07 -0700 (PDT)
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
Subject: [PATCH v2 10/12] scsi: ufs: Remove a member variable
Date:   Thu, 27 Jul 2023 12:41:22 -0700
Message-ID: <20230727194457.3152309-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230727194457.3152309-1-bvanassche@acm.org>
References: <20230727194457.3152309-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the 'response' member variable because no code reads its value.
Additionally, move the ufs_query_req and ufs_query_res data structure
definitions into include/ufs/ufshcd.h because these data structures
are related to the UFS host controller driver.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
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
index 797bf033c19a..0ee1fdf2fe83 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -537,26 +537,6 @@ struct utp_upiu_rsp {
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
