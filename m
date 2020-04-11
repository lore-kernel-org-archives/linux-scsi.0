Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B08C2BBFD
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 978CD21973
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586646559;
	bh=fDSd34PBPzhwVwoX+CKkeAQM9GR8iiPfzQBw9iG9avU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ffrw+q77gLQ0/5XyaBEytjCo+wLFkDv9q43U63n4I+UODBxKDRMRBzjKhcMNtqX2v
	 BsP+HMWKVxEc7i7Zt93xgaEtya6nxpXZJ00501RRRHot0rZ5Q99zPe0nDLUdwrpT4v
	 4kCJmJrD7dgJtJbRQDcT//kY9QswErC8dSpNdXRg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgDKXJS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbgDKXJR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3E9D216FD;
        Sat, 11 Apr 2020 23:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646557;
        bh=fDSd34PBPzhwVwoX+CKkeAQM9GR8iiPfzQBw9iG9avU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUOP8I9zyt6LFl6ykkxhAXmN/qorCdARVvJcPDqYmB5CxiGGS70OWNveJ2NcD2iy3
         SHmo5ja9q4RZMd/lXEQJWpIJp7HUEzPCojJrZnrESGNGev7QCbmQlPm5u1oYenhRZ2
         Q1DBgRZdmAMKPztU0bDY+nKWXKtm6JLpcuUGojrg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>, Hongwu Su <hongwus@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 106/121] scsi: ufs: Fix ufshcd_hold() caused scheduling while atomic
Date:   Sat, 11 Apr 2020 19:06:51 -0400
Message-Id: <20200411230706.23855-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit c63d6099a7959ecc919b2549dc6b71f53521f819 ]

The async version of ufshcd_hold(async == true), which is only called in
queuecommand path as for now, is expected to work in atomic context, thus
it should not sleep or schedule out. When it runs into the condition that
clocks are ON but link is still in hibern8 state, it should bail out
without flushing the clock ungate work.

Fixes: f2a785ac2312 ("scsi: ufshcd: Fix race between clk scaling and ungate work")
Link: https://lore.kernel.org/r/1581392451-28743-6-git-send-email-cang@codeaurora.org
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5340a980d24b8..04f161b50660a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1542,6 +1542,11 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 */
 		if (ufshcd_can_hibern8_during_gating(hba) &&
 		    ufshcd_is_link_hibern8(hba)) {
+			if (async) {
+				rc = -EAGAIN;
+				hba->clk_gating.active_reqs--;
+				break;
+			}
 			spin_unlock_irqrestore(hba->host->host_lock, flags);
 			flush_work(&hba->clk_gating.ungate_work);
 			spin_lock_irqsave(hba->host->host_lock, flags);
-- 
2.20.1

