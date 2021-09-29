Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEAEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 242B86140F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 22:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347202AbhI2WKH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 18:10:07 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:41615 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347207AbhI2WJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2021 18:09:58 -0400
Received: by mail-pj1-f53.google.com with SMTP id oa12-20020a17090b1bcc00b0019f2d30c08fso3179429pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2021 15:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GQiNUHe4VG2dDuIe/xdPmevSqTv9Ab7eKcPTFQlf7/g=;
        b=rDN4IuvNtzTFps0aLHmwhnfSKJKuSjSu50SXFfGyqEmZl5LKkf5HOa00Nuha+CH8Mg
         rO/6OzvUi/R5ZfWRqPWkj0TtKr8yAJh2EPik5u3c025uXo2Uxo6H9nX/tYRGqD1jxo8R
         3Foq4CcPWW/uB6187VD6XWQUtDrRv1h4Ig+LtCEQ4k77eL0lutFSB/CDzHp2j3hIvkcl
         vqOn+5EAlTeCbl2OP985v5baARxCjeKbXD9iS/58qf+WXriL6SbZIbhoAhC/AeAQtdHv
         Nj9+8C0u4fRTV35reELuu5WOqR6D+J0ic9FeaaFfTh1YeMphCTWWphu4R9HQVPE2OgEm
         sPBA==
X-Gm-Message-State: AOAM530ae3jbEO1zVQRiqfun75VK5jj+huRCCm+otQb7mqJw+fmM6hKK
        /iFV1syaWO3Mzfl2j7zAkxg=
X-Google-Smtp-Source: ABdhPJylFE6yrYGyW69+/1sjBhTc/Y9zMALOaSYeagkzX5sV7WAP355l7shSQ6yNKqVr0XPmss7e5Q==
X-Received: by 2002:a17:903:1207:b0:138:e2f9:6c98 with SMTP id l7-20020a170903120700b00138e2f96c98mr800278plh.11.1632953296898;
        Wed, 29 Sep 2021 15:08:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5c11:c4f:db56:119])
        by smtp.gmail.com with ESMTPSA id gk14sm2785585pjb.35.2021.09.29.15.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 15:08:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 74/84] ufs: Call scsi_done() directly
Date:   Wed, 29 Sep 2021 15:05:50 -0700
Message-Id: <20210929220600.3509089-75-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929220600.3509089-1-bvanassche@acm.org>
References: <20210929220600.3509089-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Conditional statements are faster than indirect calls. Hence call
scsi_done() directly.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9faf02cbb9ad..d20efd73555f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2702,7 +2702,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		if (hba->pm_op_in_progress) {
 			hba->force_reset = true;
 			set_host_byte(cmd, DID_BAD_TARGET);
-			cmd->scsi_done(cmd);
+			scsi_done(cmd);
 			goto out;
 		}
 		fallthrough;
@@ -2711,7 +2711,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
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
