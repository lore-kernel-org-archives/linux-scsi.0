Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00D9C001B0
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjGXUJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:09:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjGXUJU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:09:20 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479DA10EC
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:09:20 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6726d5d92afso3782220b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:09:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690229360; x=1690834160;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6zmVElk4V6/0P8yn/quCuVnpnhtsVZ3Lp51ih5wasWI=;
        b=GrcLz7rFhjlLnuRo1o1BD8vD5iEVoG4olWGJmQYDqPOPtvpTdgApUPbTwYAy4AqpTq
         bxEpLQUk5vlX8u2INwuR4cEM/UgGEBdrO5K7V9Wi9X5GBG+ZCb7yN6zvWEU5uH5g4V0W
         Sk90UrAnEQpx2DQj6ubi0ToDWBIdF/dZE6PSw+RdzeuhUN+lhQ2v4077J/OAYLrXHI8S
         wtN1AsxhC+FHQEMK6Sol58vwf7vS+Vv2aSThfYCgFoILlhCH24MSjzl/Sn1jbnoRBMPR
         ZBD/eozo4zpxD/A+/fyBtc4gEiNck+iZBF0hRHvOSuawmF0TX7xWWVyqhx+xoEZGrSNr
         nz4w==
X-Gm-Message-State: ABy/qLbEk7dcPAQUgM3RCirs0BFuiAsTu5rszM2c0OvUoeChZ24Or4QF
        VMP9Qyu60GtZfC+UvQPt8B0=
X-Google-Smtp-Source: APBJJlFeWy7Qc0qGn3JGh6uhX4UmrypG7fjjZsZcNaYObyWcEVjU8T37GyKIqbe+plebRqe3I87AuA==
X-Received: by 2002:a17:90b:4b05:b0:268:1911:a1d1 with SMTP id lx5-20020a17090b4b0500b002681911a1d1mr337805pjb.4.1690229359633;
        Mon, 24 Jul 2023 13:09:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id e23-20020a17090ab39700b002609cadc56esm6726861pjr.11.2023.07.24.13.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:09:19 -0700 (PDT)
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
Subject: [PATCH v2 1/2] scsi: ufs: Fix residual handling
Date:   Mon, 24 Jul 2023 13:08:29 -0700
Message-ID: <20230724200843.3376570-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
In-Reply-To: <20230724200843.3376570-1-bvanassche@acm.org>
References: <20230724200843.3376570-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Only call scsi_set_resid() in case of an underflow. Do not call
scsi_set_resid() in case of an overflow.

Cc: Avri Altman <avri.altman@wdc.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Fixes: cb38845d90fc ("scsi: ufs: core: Set the residual byte count")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++++++--
 include/ufs/ufs.h         |  6 ++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c394dc50504a..27e1a4914837 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5222,9 +5222,17 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 	int result = 0;
 	int scsi_status;
 	enum utp_ocs ocs;
+	u8 upiu_flags;
+	u32 resid;
 
-	scsi_set_resid(lrbp->cmd,
-		be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count));
+	upiu_flags = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_0) >> 16;
+	resid = be32_to_cpu(lrbp->ucd_rsp_ptr->sr.residual_transfer_count);
+	/*
+	 * Test !overflow instead of underflow to support UFS devices that do
+	 * not set either flag.
+	 */
+	if (resid && !(upiu_flags & UPIU_RSP_FLAG_OVERFLOW))
+		scsi_set_resid(lrbp->cmd, resid);
 
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp, cqe);
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 0dd546a20503..c789252b5fad 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -104,6 +104,12 @@ enum {
 	UPIU_CMD_FLAGS_READ	= 0x40,
 };
 
+/* UPIU response flags */
+enum {
+	UPIU_RSP_FLAG_UNDERFLOW	= 0x20,
+	UPIU_RSP_FLAG_OVERFLOW	= 0x40,
+};
+
 /* UPIU Task Attributes */
 enum {
 	UPIU_TASK_ATTR_SIMPLE	= 0x00,
