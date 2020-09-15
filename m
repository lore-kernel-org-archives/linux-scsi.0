Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD21C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:50:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E38320771
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 20:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600203009;
	bh=iQVkWhUeydRTqFowSvAGvDoWIWi1b0xAmpNyoT5VH2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=n+1/7XYBg6aO6xxuaiS0ukHPThOugppNgCnKdoieAHGxj9WOEoQjYIT//oHoaLRTe
	 M8A5kNxw1+mQFDj09ET7gTgx3ZpxzorUpy3hYDr/YxbUfpIgdh2w49/HXBRvamVREH
	 UroiffacoMrZ3XpA1aAwxdTR3YY66geftiHC8Cow=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgIOUuE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 16:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgIOUqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Sep 2020 16:46:46 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79C7620B1F;
        Tue, 15 Sep 2020 20:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600202798;
        bh=iQVkWhUeydRTqFowSvAGvDoWIWi1b0xAmpNyoT5VH2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=REEoR9Z9zfNJqcyZLGcjIj5UQXlNdPoM9F/kW6GAD+oEQ1jMIDRo1otPQ6qgc/hM+
         E1/vT0nDts4E+YDxhY7ldIomLycRSrPUiOyJtluCaRMOi+vDRJzk93Su4CJd/lSQlW
         Qxr2GI+BythJRXMeWjrRqcJ4/7GKCHpJsLpdU/54=
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 5/6] scsi: ufs: show ufs part info in error case
Date:   Tue, 15 Sep 2020 13:45:31 -0700
Message-Id: <20200915204532.1672300-5-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
In-Reply-To: <20200915204532.1672300-1-jaegeuk@kernel.org>
References: <20200915204532.1672300-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@google.com>

This patch shows ufs part info in kernel messages for debugging purpose.
It's useful when we only have the last kernel message.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index bdc82cc3824aa..b81c116b976ff 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -500,6 +500,14 @@ static void ufshcd_print_tmrs(struct ufs_hba *hba, unsigned long bitmap)
 static void ufshcd_print_host_state(struct ufs_hba *hba)
 {
 	dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
+	if (hba->sdev_ufs_device) {
+		dev_err(hba->dev, " vendor = %.8s\n",
+					hba->sdev_ufs_device->vendor);
+		dev_err(hba->dev, " model = %.16s\n",
+					hba->sdev_ufs_device->model);
+		dev_err(hba->dev, " rev = %.4s\n",
+					hba->sdev_ufs_device->rev);
+	}
 	dev_err(hba->dev, "outstanding reqs=0x%lx tasks=0x%lx\n",
 		hba->outstanding_reqs, hba->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
-- 
2.28.0.618.gf4bc123cb7-goog

