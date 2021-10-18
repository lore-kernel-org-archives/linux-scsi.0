Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D645C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 13:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 500836103C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 13:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhJRNWm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 09:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhJRNWj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 09:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7220A6103D;
        Mon, 18 Oct 2021 13:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634563227;
        bh=FEQkeCeHNlf9/VijMNNnZDKsvPpnX5/75zjmn6URwyU=;
        h=From:To:Cc:Subject:Date:From;
        b=BoSIof50bn3wOeWzmaLZ4H/xm3Ln7k/OHudTuwRDOYoKEbY0TiKF08ygtybXKrtvD
         Jo1kINXlULGjZ7RZPlTqtktTRubzrH5MP0gwITlEA9B9N8SJuxs0ZWLt7mCBiUb9qm
         wCSK4cjqZ9W9kySai7o4bJ8wdfNucFUYIzH/8AqHVhS0xMV+IOdvRPqIWOtAb+QRQG
         BSIaQipWRQKf58E5vqkTbyl9z5188irS3KV3LBawg9IdwBCtWb7pVFH7m3HnVcqq2O
         TH6my8wf1F9wMn/lwpih5lSHLNuDjjOBLUrReyFWDU0cOctyehzvchKdKN+GpBTww6
         T29x00OADloDg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] scsi: ufs: mediatek: avoid sched_clock() misuse
Date:   Mon, 18 Oct 2021 15:20:01 +0200
Message-Id: <20211018132022.2281589-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

sched_clock() is not meant to be used in portable driver code,
and assuming a particular clock frequency is not how this is
meant to be used. It also causes a build failure because of
a missing header inclusion:

drivers/scsi/ufs/ufs-mediatek.c:321:12: error: implicit declaration of function 'sched_clock' [-Werror,-Wimplicit-function-declaration]
        timeout = sched_clock() + retry_ms * 1000000UL;

A better interface to use here ktime_get_mono_fast_ns(), which
works mostly like ktime_get() but is safe to use inside of a
suspend callback.

Fixes: 9561f58442e4 ("scsi: ufs: mediatek: Support vops pre suspend to disable auto-hibern8")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/ufs/ufs-mediatek.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index d1696db70ce8..a47241ed0a57 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -318,15 +318,15 @@ static void ufs_mtk_wait_idle_state(struct ufs_hba *hba,
 	u32 val, sm;
 	bool wait_idle;
 
-	timeout = sched_clock() + retry_ms * 1000000UL;
-
+	/* cannot use plain ktime_get() in suspend */
+	timeout = ktime_get_mono_fast_ns() + retry_ms * 1000000UL;
 
 	/* wait a specific time after check base */
 	udelay(10);
 	wait_idle = false;
 
 	do {
-		time_checked = sched_clock();
+		time_checked = ktime_get_mono_fast_ns();
 		ufs_mtk_dbg_sel(hba);
 		val = ufshcd_readl(hba, REG_UFS_PROBE);
 
-- 
2.29.2

