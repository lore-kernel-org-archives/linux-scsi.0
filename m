Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D46E7D0A2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 19:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjIUTZs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjIUTZr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 15:25:47 -0400
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6A4EA621
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:25:41 -0700 (PDT)
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6c0a3a2cc20so803065a34.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:25:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695324341; x=1695929141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3s8urz1tWkoV2X1wuWzASjhZARx7FJLNBaHhUOuZVP0=;
        b=eBWHrRCrmoXrg6MaY/8P3NQ99tOzYsV9fy8P5LvixtYG1HLOywdOclL6Ze0OkI/Eaj
         ccsBiXQxYiAoNrqfolza7gXXk6+xrkgUScJrm6V7TcBNCNl35YpOL7zXJSBKGnO+A3q7
         ivVz42OdNAERMNWiufpKIVr0SbWNVQAuPbgLKI+oD9QI3E3glYElSUGldOQulV4wQsn4
         /PHY8Vc8Y0bCIjXvsPERbb4QeSuycTLZFLt2VQmetQLl+Mhs7a0RuFsPWApCpUgN5jZ6
         0osLNkARDlpxnlo0TiFpXcNRQpJ8NGKkmc/o4n/PSv3EFQgjQ/YzEOuQ7CA1leACRb4Q
         b8Ww==
X-Gm-Message-State: AOJu0YwmUe+mkDqi2/jfWo8IpfQLLhyG/FxoJtKbs72VLqE0L0XcBavo
        gXEkCF2PzI7GDR4rbrcMtBE=
X-Google-Smtp-Source: AGHT+IFFO2vKeNDUp6lzLUhLjeu1n+dBqLe4/P5LLEXJzr6k65b/J3q6qcZlo1QCoQbBxKxrbP2Wng==
X-Received: by 2002:a05:6830:ed5:b0:6b7:1d93:72e0 with SMTP id dq21-20020a0568300ed500b006b71d9372e0mr6357770otb.32.1695324340964;
        Thu, 21 Sep 2023 12:25:40 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6903:9a1f:51f3:593e])
        by smtp.gmail.com with ESMTPSA id fm1-20020a056a002f8100b00679a4b56e41sm1760061pfb.43.2023.09.21.12.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 12:25:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v2 4/4] scsi: ufs: Set the Command Priority (CP) flag for RT requests
Date:   Thu, 21 Sep 2023 12:22:49 -0700
Message-ID: <20230921192335.676924-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
In-Reply-To: <20230921192335.676924-1-bvanassche@acm.org>
References: <20230921192335.676924-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the UFS device execute realtime (RT) requests before other requests.
This will be used in Android to reduce the I/O latency of the foreground
app.

Note: UFS devices do not support CDL so using CDL is not a viable
alternative.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++++
 include/ufs/ufs.h         | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8561383076e8..c614619f06bd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2717,6 +2717,8 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
  */
 static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
+	struct request *rq = scsi_cmd_to_rq(lrbp->cmd);
+	unsigned int ioprio_class = IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 	u8 upiu_flags;
 
 	if (hba->ufs_version <= ufshci_version(1, 1))
@@ -2726,6 +2728,8 @@ static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 
 	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
 				    lrbp->cmd->sc_data_direction, 0);
+	if (ioprio_class == IOPRIO_CLASS_RT)
+		upiu_flags |= UPIU_CMD_FLAGS_CP;
 	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 }
 
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 0cced88f4531..e77ab1786856 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -98,9 +98,10 @@ enum upiu_response_transaction {
 	UPIU_TRANSACTION_REJECT_UPIU	= 0x3F,
 };
 
-/* UPIU Read/Write flags */
+/* UPIU Read/Write flags. See also table "UPIU Flags" in the UFS standard. */
 enum {
 	UPIU_CMD_FLAGS_NONE	= 0x00,
+	UPIU_CMD_FLAGS_CP	= 0x04,
 	UPIU_CMD_FLAGS_WRITE	= 0x20,
 	UPIU_CMD_FLAGS_READ	= 0x40,
 };
