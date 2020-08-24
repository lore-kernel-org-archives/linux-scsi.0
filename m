Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51245C433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 17:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 286222074D
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598289021;
	bh=tkg9bPdu0y9UhxNaRVT+Km3iLfj26SZ4ErlN1m0KU+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=G2YUMb46WJldC9VPtZbFoIDSYDQpjyITlNCE8DMuVSTrX5te5NKet2+MZbU9el2xS
	 qujCj+TeQuK20p9f0lW3z4jQdC09KmVH6IOXkgflKSeJp4Hu65bxk/e6aIe1lsKCiL
	 PfL2gaqu3A5pPBXciBH/GFt1DwTzM7rYyMvP9px8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgHXRKU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 13:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728409AbgHXQh5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Aug 2020 12:37:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22F1122DA7;
        Mon, 24 Aug 2020 16:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287041;
        bh=tkg9bPdu0y9UhxNaRVT+Km3iLfj26SZ4ErlN1m0KU+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=106jkt8Wa769B+hbkeGRoPFa1jNgnDE+3pCsz97kOHgoEyFYOLNRkZ9yMeshXqBS0
         FP7BYGuHyebhm4E6vTQXiwwdiwnZ5WqdI2t1KqswZALSBREMDBFh484Po2RJswGDBK
         o8XltN0be8rFbiXV/Tl4e0BnuiQihn9qeY3NHc7Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Andy Teng <andy.teng@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 34/54] scsi: ufs: Fix possible infinite loop in ufshcd_hold
Date:   Mon, 24 Aug 2020 12:36:13 -0400
Message-Id: <20200824163634.606093-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163634.606093-1-sashal@kernel.org>
References: <20200824163634.606093-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit 93b6c5db06028a3b55122bbb74d0715dd8ca4ae0 ]

In ufshcd_suspend(), after clk-gating is suspended and link is set
as Hibern8 state, ufshcd_hold() is still possibly invoked before
ufshcd_suspend() returns. For example, MediaTek's suspend vops may
issue UIC commands which would call ufshcd_hold() during the command
issuing flow.

Now if UFSHCD_CAP_HIBERN8_WITH_CLK_GATING capability is enabled,
then ufshcd_hold() may enter infinite loops because there is no
clk-ungating work scheduled or pending. In this case, ufshcd_hold()
shall just bypass, and keep the link as Hibern8 state.

Link: https://lore.kernel.org/r/20200809050734.18740-1-stanley.chu@mediatek.com
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Co-developed-by: Andy Teng <andy.teng@mediatek.com>
Signed-off-by: Andy Teng <andy.teng@mediatek.com>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 477b6cfff381b..a61f95ffd45fd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1540,6 +1540,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 int ufshcd_hold(struct ufs_hba *hba, bool async)
 {
 	int rc = 0;
+	bool flush_result;
 	unsigned long flags;
 
 	if (!ufshcd_is_clkgating_allowed(hba))
@@ -1571,7 +1572,9 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 				break;
 			}
 			spin_unlock_irqrestore(hba->host->host_lock, flags);
-			flush_work(&hba->clk_gating.ungate_work);
+			flush_result = flush_work(&hba->clk_gating.ungate_work);
+			if (hba->clk_gating.is_suspended && !flush_result)
+				goto out;
 			spin_lock_irqsave(hba->host->host_lock, flags);
 			goto start;
 		}
-- 
2.25.1

