Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797C9C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 14:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E23C61209
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 14:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbhEXO5G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 10:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234174AbhEXOyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 10:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56AC76142D;
        Mon, 24 May 2021 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867720;
        bh=7+3A1Pukmv3Q1p12fd4IG939MkFyNpZf9mJ1LLh8o5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J0COBcLreyL3+EI3AKAdAzDvU2UvJMJB8vfxDWAdJdd2TAfw49bEzuSvt4/2Nh4zu
         enBY3BLQ3gR+OWzsMYZcG8FnXKfPyl5W6JKVb/YsfzU10eXPIlO/WSWzPQF0w+z7FR
         lyNqL7zaj+r0bGqdAE/T2iOv3PKJTZHE7v4j2/95xqPqhrIQf1dgKyNSBW1Aq7oH0b
         bPsnJ2yuwBmyrOWo4f9F0o56gNIcJngNw6quewW38OqrYxKp/JDgq8UQ12lMqSL3c2
         FjUUeI0Gnl0UWuauYZh34dZ8yGfmRh/b352Tzp36+tB+JZFPO1VTNX0j9GwG6rL7Zz
         tsk6xs7FJ1PGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Wang <peter.wang@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 45/62] scsi: ufs: ufs-mediatek: Fix power down spec violation
Date:   Mon, 24 May 2021 10:47:26 -0400
Message-Id: <20210524144744.2497894-45-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144744.2497894-1-sashal@kernel.org>
References: <20210524144744.2497894-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit c625b80b9d00f3546722cd77527f9697c8c4c911 ]

As per spec, e.g. JESD220E chapter 7.2, while powering off the UFS device,
RST_N signal should be between VSS(Ground) and VCCQ/VCCQ2. The power down
sequence after fixing:

Power down:

 1. Assert RST_N low

 2. Turn-off VCC

 3. Turn-off VCCQ/VCCQ2

Link: https://lore.kernel.org/r/1620813706-25331-1-git-send-email-peter.wang@mediatek.com
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 09d2ac20508b..aace13399a7f 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -824,6 +824,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
+	struct arm_smccc_res res;
 
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_lpm(hba);
@@ -844,6 +845,9 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufs_mtk_vreg_set_lpm(hba, true);
 	}
 
+	if (ufshcd_is_link_off(hba))
+		ufs_mtk_device_reset_ctrl(0, res);
+
 	return 0;
 }
 
-- 
2.30.2

