Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F13EAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Dec 2021 23:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383417AbhLCXYU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:24:20 -0500
Received: from mail-pg1-f172.google.com ([209.85.215.172]:33674 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376419AbhLCXYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2021 18:24:19 -0500
Received: by mail-pg1-f172.google.com with SMTP id f125so4589586pgc.0
        for <linux-scsi@vger.kernel.org>; Fri, 03 Dec 2021 15:20:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xnK/yQe9eicvD/7ZRJSIPZCIvlJeOYBgRPK+Xw3/s9Y=;
        b=akPd8cnm6FIY/VvZqS3u4LuIWMOl2cjQ1BOHH0khJh6Jr3KogblojRWoos877JppYG
         rYDQ/nH0NK4dG8MxgcnRx40c1kpVLyw3cT6m9lAuUPrenEg1X9x82vGNYyLOCzVD4jYi
         8SIh75S7/CBgX2P+Bo3cE1jBs2uZDexgiNyhqmIUh9lOFI4uE+J4CwihvlKtAZIrA0pm
         zA0P8Udoj/5K4/FbCjW5FqHu3gkh/KoFCg7JM3vUXEpJAPOCNHphSCHXphx0ccqKpaMJ
         tPXUQXMI7YysC3bu7do6yTvx78I90fyjbPvzPAbILOgd81hfOo/XkKLF29TAf2+0jyJl
         ckUA==
X-Gm-Message-State: AOAM531x0bz45gt713gDTJVAk4W18Msmro2+0zxazE3daGUbxwKc0FH2
        9y01o1R4mpJ5LeWUFhXQdWI=
X-Google-Smtp-Source: ABdhPJwI+sd5o5yu5cWFZN1FFfY+S2bN4qe8l42FkgT5hQQozVbqZ/JaXkoU6+SneRnmIR5t8fVgcQ==
X-Received: by 2002:a63:155:: with SMTP id 82mr6905426pgb.485.1638573654773;
        Fri, 03 Dec 2021 15:20:54 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f942:89a1:6ccd:130])
        by smtp.gmail.com with ESMTPSA id k18sm3233849pgb.70.2021.12.03.15.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:20:54 -0800 (PST)
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
Subject: [PATCH v4 08/17] scsi: ufs: Rework ufshcd_change_queue_depth()
Date:   Fri,  3 Dec 2021 15:19:41 -0800
Message-Id: <20211203231950.193369-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org>
References: <20211203231950.193369-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for making sdev->host->can_queue less than hba->nutrs. This patch
does not change any functionality.

Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 974bf47e733c..2d0f59424b00 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4936,11 +4936,7 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
  */
 static int ufshcd_change_queue_depth(struct scsi_device *sdev, int depth)
 {
-	struct ufs_hba *hba = shost_priv(sdev->host);
-
-	if (depth > hba->nutrs)
-		depth = hba->nutrs;
-	return scsi_change_queue_depth(sdev, depth);
+	return scsi_change_queue_depth(sdev, min(depth, sdev->host->can_queue));
 }
 
 static void ufshcd_hpb_destroy(struct ufs_hba *hba, struct scsi_device *sdev)
