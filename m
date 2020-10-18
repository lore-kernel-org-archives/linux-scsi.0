Return-Path: <SRS0=jquQ=DZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A6AC43457
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26D3F207DE
	for <linux-scsi@archiver.kernel.org>; Sun, 18 Oct 2020 19:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603050440;
	bh=Y/1hHBO6KE75jBvjkA30cN0pMayafi/gat7ttIbSo9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=p/fGueDnmi9n9n1noPJ+fZJVr7bb5ck7S42hSB1NV/Xt0+uFPgpABTxkVETL/YP6e
	 GmBdVs7qIF3XilL4uG8LfSSUyFzxxAQIjqwDxKn45/jja6vhI333HozXBq7fG7Qxel
	 tRzYlgFzj5hnYcw+GkN1Dose1LeGJo8ntOaZXB4U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729842AbgJRTW0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:35180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729829AbgJRTWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E185C2137B;
        Sun, 18 Oct 2020 19:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048944;
        bh=Y/1hHBO6KE75jBvjkA30cN0pMayafi/gat7ttIbSo9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djI+LAz5K2PMj4fzDWYy4am5zIEMrdDS1YKY/HTRB5/sSrOP44bgnfhp22QoKroRV
         iei4Qnpmf9Hx8VNfD01c9/Nb67+KkbBpUEtndziCLklQ9EV5qj/gbobXaEwQS76XUs
         lkd6Wy/ITj+48pNg/7p/Xn/6YYbzKg9YE1LD5q4I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>, Hongwu Su <hongwus@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 097/101] scsi: ufs: ufs-qcom: Fix race conditions caused by ufs_qcom_testbus_config()
Date:   Sun, 18 Oct 2020 15:20:22 -0400
Message-Id: <20201018192026.4053674-97-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 89dd87acd40a44de8ff3358138aedf8f73f4efc6 ]

If ufs_qcom_dump_dbg_regs() calls ufs_qcom_testbus_config() from
ufshcd_suspend/resume and/or clk gate/ungate context, pm_runtime_get_sync()
and ufshcd_hold() will cause a race condition. Fix this by removing the
unnecessary calls of pm_runtime_get_sync() and ufshcd_hold().

Link: https://lore.kernel.org/r/1596975355-39813-3-git-send-email-cang@codeaurora.org
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2e6ddb5cdfc23..7da27eed1fe7b 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1604,9 +1604,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	 */
 	}
 	mask <<= offset;
-
-	pm_runtime_get_sync(host->hba->dev);
-	ufshcd_hold(host->hba, false);
 	ufshcd_rmwl(host->hba, TEST_BUS_SEL,
 		    (u32)host->testbus.select_major << 19,
 		    REG_UFS_CFG1);
@@ -1619,8 +1616,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	 * committed before returning.
 	 */
 	mb();
-	ufshcd_release(host->hba);
-	pm_runtime_put_sync(host->hba->dev);
 
 	return 0;
 }
-- 
2.25.1

