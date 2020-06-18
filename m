Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4EDC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB5A20884
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592446487;
	bh=d9AYsEQJGWrQPuhepMSkj3olfNftcEJXAwTAup6nUME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZMQprTHdxtT8OaIDP5+7fFg1MK+/Ll842jolmfQIVjnJzaOD+MwetRtbwhVU3+PsE
	 zwrnqne56QRW8rIrqAcsmhHiLFGzGcfNHZ6+vrrUZt3cf5iyfMUZpWqD0LXfHv9oh5
	 BKleAP/59M47nbdVtD965cE3FGnC2nev8xYm24f4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgFRBUo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:53026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730346AbgFRBUo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0680206F1;
        Thu, 18 Jun 2020 01:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443243;
        bh=d9AYsEQJGWrQPuhepMSkj3olfNftcEJXAwTAup6nUME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5o+YL42aJiI0c+GLWsqC1ik/pfr1eBBCVEr6wrBFCxfivn2WFrs3T6y35nveRrOL
         h95B0R1YMKQjd45SpTTG54q8ZlUTUCIJ4d+j7rIqvdgKc4Gof6UGq34KyWQE5nEQBn
         ynfcP8XnnV974JzAj7cqQu+iSMSsy8mPYmI0lETQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 194/266] scsi: ufs-qcom: Fix scheduling while atomic issue
Date:   Wed, 17 Jun 2020 21:15:19 -0400
Message-Id: <20200618011631.604574-194-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>

[ Upstream commit 3be60b564de49875e47974c37fabced893cd0931 ]

ufs_qcom_dump_dbg_regs() uses usleep_range, a sleeping function, but can be
called from atomic context in the following flow:

ufshcd_intr -> ufshcd_sl_intr -> ufshcd_check_errors ->
ufshcd_print_host_regs -> ufshcd_vops_dbg_register_dump ->
ufs_qcom_dump_dbg_regs

This causes a boot crash on the Lenovo Miix 630 when the interrupt is
handled on the idle thread.

Fix the issue by switching to udelay().

Link: https://lore.kernel.org/r/20200525204125.46171-1-jeffrey.l.hugo@gmail.com
Fixes: 9c46b8676271 ("scsi: ufs-qcom: dump additional testbus registers")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 411ef60b2c14..c49e9f6c46f8 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1546,11 +1546,11 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
 
 	/* sleep a bit intermittently as we are dumping too much data */
 	ufs_qcom_print_hw_debug_reg_all(hba, NULL, ufs_qcom_dump_regs_wrapper);
-	usleep_range(1000, 1100);
+	udelay(1000);
 	ufs_qcom_testbus_read(hba);
-	usleep_range(1000, 1100);
+	udelay(1000);
 	ufs_qcom_print_unipro_testbus(hba);
-	usleep_range(1000, 1100);
+	udelay(1000);
 }
 
 /**
-- 
2.25.1

