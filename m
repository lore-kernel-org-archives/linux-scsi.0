Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EFDE7D0A6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 19:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjIUTZe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:25:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjIUTZd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 15:25:33 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB935EA623
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:25:26 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-690b8859c46so1209589b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695324326; x=1695929126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFGti6mPmsiIN0phUdSSiDliF2yxOnTU9rGyLzwSGBo=;
        b=hOUICXqcKClrtAirqMTiCaU2zrfPDsco3aPjmpWj8DOyOsZr1MgK15UHdxAzyIx5E1
         0ngsXFUvGbW20LIcSw2oA974jFqca8w+hW1Y8zhdU4Hu8Ai61HZ2bmXyNVWcTOfzRRfF
         W3J0CJsg2ahg4GHMivpPzOkDHBqj3soGBn/jO4hg0Wjggwoo89DmoIACJ6Il9HMT4zdS
         pkKbUs5yYCFMHPk4iNorFADuvvtG92CGHmsPv9Px3Cgmk3mWg7Awc8RP0IVpoxh31bu+
         oBymKDRLQT5D0YF6g4hkMx0cNGtjZrWXgo3SPyJVEa4STQ+megu14AocgHXFpz2zCEfS
         xSzA==
X-Gm-Message-State: AOJu0YysU+3/o0IPk6Gsadvs9WL0mXEUO0IQ0GL//13BJnEefOyPSjRp
        PF1UwrobojLzkbVkNHXYDpU=
X-Google-Smtp-Source: AGHT+IFHicz24ocyWKCySlP5vPOn5W7ssjMPggsjMgCC/lBwPy/q8fvfYeQLKnTYsLf6HcKCMzSrJA==
X-Received: by 2002:a05:6a00:16d1:b0:68c:5cec:30d4 with SMTP id l17-20020a056a0016d100b0068c5cec30d4mr6991980pfc.27.1695324326250;
        Thu, 21 Sep 2023 12:25:26 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6903:9a1f:51f3:593e])
        by smtp.gmail.com with ESMTPSA id fm1-20020a056a002f8100b00679a4b56e41sm1760061pfb.43.2023.09.21.12.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 12:25:25 -0700 (PDT)
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
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: [PATCH v2 3/4] scsi: ufs: Simplify ufshcd_comp_scsi_upiu()
Date:   Thu, 21 Sep 2023 12:22:48 -0700
Message-ID: <20230921192335.676924-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
In-Reply-To: <20230921192335.676924-1-bvanassche@acm.org>
References: <20230921192335.676924-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ufshcd_comp_scsi_upiu() has one caller and that caller ensures that
lrbp->cmd != NULL. Hence leave out the lrbp->cmd check from
ufshcd_comp_scsi_upiu().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 379229d51f04..8561383076e8 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2714,27 +2714,19 @@ static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
  *			   for SCSI Purposes
  * @hba: per adapter instance
  * @lrbp: pointer to local reference block
- *
- * Return: 0 upon success; < 0 upon failure.
  */
-static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static void ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	u8 upiu_flags;
-	int ret = 0;
 
 	if (hba->ufs_version <= ufshci_version(1, 1))
 		lrbp->command_type = UTP_CMD_TYPE_SCSI;
 	else
 		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
-	if (likely(lrbp->cmd)) {
-		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, lrbp->cmd->sc_data_direction, 0);
-		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
-	} else {
-		ret = -EINVAL;
-	}
-
-	return ret;
+	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
+				    lrbp->cmd->sc_data_direction, 0);
+	ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
 }
 
 /**
