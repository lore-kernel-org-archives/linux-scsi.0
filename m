Return-Path: <SRS0=HoCN=7I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FAEC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 23:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0987620899
	for <linux-scsi@archiver.kernel.org>; Tue, 26 May 2020 23:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590534759;
	bh=bYPj04D+9CH6Q+PkarWq2Fihu9hhCGyUuw7J1yZIY+M=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=R0TgDaQdz05qv00oJ84k0suoshO702pDMfXA/8BlEu3SXp+dNk0vWEIwPVnqL4oLl
	 bMf/M4h24+muST/S9rCb2BWW6No+PaiffeEMjFKJhX2ciCPAz5w8I/38z/ZDBXNCcW
	 5TixsisOYx4y6dfJpegqyRna+E8XLmJnKKqe2IlA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391521AbgEZXMi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 May 2020 19:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388915AbgEZXMh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 May 2020 19:12:37 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3853E20707;
        Tue, 26 May 2020 23:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590534757;
        bh=bYPj04D+9CH6Q+PkarWq2Fihu9hhCGyUuw7J1yZIY+M=;
        h=From:To:Cc:Subject:Date:From;
        b=TQ3JwnLHifEgfTwusT+E8L+4xArvdkEEicARCqtxBAHproF4hBgio509sv/v+9ySE
         Gl1MjrkrIHHa+tX8mXCfSJkZ67HFv/o04ow5qo5e2DaSM2sPBfGZJwRQxjIfF2s0p6
         UAw7JQFTIxofYiCpHXoTCKFmKTxIweVYQkY9iP78=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        linux-scsi@vger.kernel.org, Can Guo <cang@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4/4.19/4.14/4.9/4.4] scsi: ufs: Release clock if DMA map fails
Date:   Tue, 26 May 2020 16:09:39 -0700
Message-Id: <20200526230939.85557-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

commit 17c7d35f141ef6158076adf3338f115f64fcf760 upstream.
[Please apply to 5.4-stable and earlier.]

In queuecommand path, if DMA map fails, it bails out with clock held.  In
this case, release the clock to keep its usage paired.

[mkp: applied by hand]

Link: https://lore.kernel.org/r/0101016ed3d66395-1b7e7fce-b74d-42ca-a88a-4db78b795d3b-000000@us-west-2.amazonses.com
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[EB: resolved cherry-pick conflict caused by newer kernels not having
 the clear_bit_unlock() line]
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 13ab1494c384..bc73181b0405 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2480,6 +2480,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 
 	err = ufshcd_map_sg(hba, lrbp);
 	if (err) {
+		ufshcd_release(hba);
 		lrbp->cmd = NULL;
 		clear_bit_unlock(tag, &hba->lrb_in_use);
 		goto out;
-- 
2.27.0.rc0.183.gde8f92d652-goog

