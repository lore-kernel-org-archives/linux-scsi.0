Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 209B6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 062BE61100
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 20:46:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241263AbhJGUsW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 16:48:22 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:43571 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbhJGUsV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 16:48:21 -0400
Received: by mail-pj1-f48.google.com with SMTP id k23-20020a17090a591700b001976d2db364so6140547pji.2
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 13:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z2KIcbMyDQWu85zscZeDvvn79i07oQpu1zZ0ct8FFEQ=;
        b=Fpy/+i5S21l6VnQYhaGeZ8JTJImh04HKq5H9gNRrRCe3wJuHcblij4g4L492zYEOZh
         hYbKwa81qzMdSwP0cthr7FoyKv3Yp7J4njbl4F0U1hkZ+DVbuiukcTjKBpygFtJiGJTu
         5hZQF5oCXaDpRuajkHykT2tClUGwBc8CLDIcao8S7PAmwAR/Q/n1bdlTGf+SYoI16IMf
         h4q0e0+9tMl5OEm21gM41JpumXpCm4O7vbA1sx1SWvUFTen6c0SkBr87YILNFq1Cc9Vl
         KkaQa2vOef4oxl4fKuzswEx9B/JVC3uIvEL5Tsgk1wG1+yQroedZJa4ido1qHs0QmaXC
         FuWQ==
X-Gm-Message-State: AOAM530abqM9tMpgPasE7pxK+Q6iURpmN+FPW0TU6Stq1J88i3o6yzlC
        TUdMP/N5Thjzy0iJWDg1Cqo=
X-Google-Smtp-Source: ABdhPJwvdo/mmogxtNaZB5FMe64EQ2VGJozgJPH2R+aLWZxN7R+gtpqpBc+/37AnCHpxR34IV6qeKA==
X-Received: by 2002:a17:90a:414c:: with SMTP id m12mr7860603pjg.187.1633639587328;
        Thu, 07 Oct 2021 13:46:27 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id 17sm280831pfh.216.2021.10.07.13.46.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:46:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v3 75/88] ufs: Call scsi_done() directly
Date:   Thu,  7 Oct 2021 13:46:01 -0700
Message-Id: <20211007204618.2196847-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
In-Reply-To: <20211007202923.2174984-1-bvanassche@acm.org>
References: <20211007202923.2174984-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d91a405fd181..a04c373e6b07 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2704,7 +2704,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		if (hba->pm_op_in_progress) {
 			hba->force_reset = true;
 			set_host_byte(cmd, DID_BAD_TARGET);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			goto out;
 		}
 		fallthrough;
@@ -2713,7 +2713,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		goto out;
 	case UFSHCD_STATE_ERROR:
 		set_host_byte(cmd, DID_ERROR);
-		cmd->scsi_done(cmd);
+		scsi_done(cmd);
 		goto out;
 	}
 
@@ -5294,7 +5294,7 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Mark completed command as NULL in LRB */
 			lrbp->cmd = NULL;
 			/* Do not touch lrbp after scsi done */
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			ufshcd_release(hba);
 			update_scaling = true;
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
