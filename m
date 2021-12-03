Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E186DC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:21:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383430AbhLCXYl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:24:41 -0500
Received: from mail-pj1-f44.google.com ([209.85.216.44]:35357 "EHLO
        mail-pj1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383421AbhLCXYl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:24:41 -0500
Received: by mail-pj1-f44.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso6363937pji.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:21:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=39KmaVXublhCNLRTgpUKfx7YNz4c3+aUjhGSuwczddg=;
        b=HI5IEuv+P9VPHo96cj0pEXB8BAluRlmuG2u4Aa7FebOorcwXipmSXyN8fVeeRiz4IH
         AI0R/fEIrNEAPODLjRDqmBlzZv+fLoA6p6YwPbHkUxyE2nd78a+ozQ5dz5b832BCY+z7
         BtCktJ5E8XKreWLqjQxIfBDMazc1J4CJK6OoeDLhLHfftPHC4STrzfzGsMoVnPxEMuMr
         P4x4qqoAdegwKfHN7QKxR5SfOCJVIZabSe+u0m3rHRsTQeUJYAki91GYbWLO+qKLI/nT
         +ivFjnJ/pBu5mS9Gm9zx89KkIUalD7z8lzQ2nPP3aUJe8zqxEM6wv+S4W5kmCvoB5E/h
         o0xg==
X-Gm-Message-State: AOAM531Z5eGMFS1RD0qKqsyZNectH0cl2EEguKBgAoMy4PYT7KGQRp4U
        6ridm/wXaNiErj6sxbCxcso=
X-Google-Smtp-Source: ABdhPJxBYQnoD9HdC7M2Y5tjvKzBkOEC2wqoxC7hF1anXnppjB2wOCDzDh0zTdlFUKddtRXABDskbg==
X-Received: by 2002:a17:90b:3848:: with SMTP id nl8mr17505203pjb.221.1638573676686;
        Fri, 03 Dec 2021 15:21:16 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:21:16 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v4 11/17] scsi: ufs: Remove the 'update_scaling' local variable
Date:   Fri,  3 Dec 2021 15:19:44 -0800
Message-Id: <20211203231950.193369-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch does not change any functionality but makes the next patch in
this series easier to read.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2cd777d92c7b..27574aef5374 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5225,7 +5225,6 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 	struct scsi_cmnd *cmd;
 	int result;
 	int index;
-	bool update_scaling = false;
 
 	for_each_set_bit(index, &completed_reqs, hba->nutrs) {
 		lrbp = &hba->lrb[index];
@@ -5243,18 +5242,16 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Do not touch lrbp after scsi done */
 			scsi_done(cmd);
 			ufshcd_release(hba);
-			update_scaling = true;
+			ufshcd_clk_scaling_update_busy(hba);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete) {
 				ufshcd_add_command_trace(hba, index,
 							 UFS_DEV_COMP);
 				complete(hba->dev_cmd.complete);
-				update_scaling = true;
+				ufshcd_clk_scaling_update_busy(hba);
 			}
 		}
-		if (update_scaling)
-			ufshcd_clk_scaling_update_busy(hba);
 	}
 }
 
