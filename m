Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A45C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 21:45:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344997AbiFMVpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 17:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbiFMVpL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 17:45:11 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BFE463F0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 14:45:10 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 129so6753376pgc.2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 14:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UhfEfvl0r2NBkOBg8gADR1ZqMrK/zdzBIc2zKDop9kQ=;
        b=oW0i61EltoXgdpmWwXuReWslQOvP72gcdeXw+VCx2Wi7VMwJeG+BFH+aUVMzbDJopY
         0IVZrwxPZKUiFhLOib+4JKKgAz3DOlArNoKmeC909+fp7MnGee/CLOt1wHbYbhaiFE+5
         baShUUJYQNDfa3IIrw7v+FWaRtwpZn/d4aPuOabk3MNZQo0BBJcTNnwSL4h7bfR942yz
         LLCL27YlsCpWJL2mZ7Vy4s1oABbLzElEmo7ZLjgofZmK98tB1B5hyLiGnyFC0JGDcD+p
         +m57F2zQtwaQWGlMV1IkTU9MQN+gTkuorafveBSNMHy7appZvF+Kxfm4/ZC2RL3Ykn9S
         3vbg==
X-Gm-Message-State: AOAM530PMQG3s+rbDeG22c4mnVa2Us+Z0q3bbw2eZxpVLnVj+TH1Kmmm
        qTn2/doxuXO/G50K3Bxou3Y=
X-Google-Smtp-Source: ABdhPJx95L5Cc9IBcxxTvtWukROJsgaLinWfX20ecOD0DuiTKzI95Uoqg9OxtHl4WWKqhmNhikuK9g==
X-Received: by 2002:a63:67c3:0:b0:3fe:465:bfa2 with SMTP id b186-20020a6367c3000000b003fe0465bfa2mr1472427pgc.12.1655156709455;
        Mon, 13 Jun 2022 14:45:09 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6862:a290:1a09:5af5])
        by smtp.gmail.com with ESMTPSA id ji2-20020a170903324200b001622c377c3esm5585833plb.117.2022.06.13.14.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 14:45:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 1/3] scsi: ufs: Simplify ufshcd_clear_cmd()
Date:   Mon, 13 Jun 2022 14:44:40 -0700
Message-Id: <20220613214442.212466-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
In-Reply-To: <20220613214442.212466-1-bvanassche@acm.org>
References: <20220613214442.212466-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the local variable 'err'. This patch does not change any
functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index bb6cbd514a69..4ed2f6c29e80 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2868,7 +2868,6 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 static int
 ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 {
-	int err = 0;
 	unsigned long flags;
 	u32 mask = 1 << tag;
 
@@ -2881,11 +2880,8 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 	 * wait for h/w to clear corresponding bit in door-bell.
 	 * max. wait is 1 sec.
 	 */
-	err = ufshcd_wait_for_register(hba,
-			REG_UTP_TRANSFER_REQ_DOOR_BELL,
-			mask, ~mask, 1000, 1000);
-
-	return err;
+	return ufshcd_wait_for_register(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL,
+					mask, ~mask, 1000, 1000);
 }
 
 static int
