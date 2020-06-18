Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8A5C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31399214DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 02:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592447098;
	bh=rg6dt3CgmhuAqP0vnDsrUS7uZ9EdNF3ayal5wE+ExhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Yfadk8oLIn3gs1k7J7VPIEJVPS4b2YHaQMER/2HxE+WdAjfRqtGcEFh6Mm15GCXgv
	 0hjdGFAtY1u829Y78JPbsUOzbfGolWn8Z5+y9sPCjBBF+VGWck68f4OZBT1FWGmavy
	 fs4uJZ+4jU+CHNcnm6r4VwSRW/bNHev+VqQLh+Os=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbgFRCYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 22:24:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728878AbgFRBRi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 21:17:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46CE7206F1;
        Thu, 18 Jun 2020 01:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443058;
        bh=rg6dt3CgmhuAqP0vnDsrUS7uZ9EdNF3ayal5wE+ExhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKSWhK/jktlyFrX0JWHAn19Oquu0/KDMbSbB2bQO4uwYsy136Qsa/njabdAd4LKqI
         4z1uxCByBKlh8/q8LmuAdybyLlwXu0sHmF8rFvfpYTzBMyivOXKkMB1W69xabAKk+4
         Qab/ex5TWfjTr/5WQ2H/Z8uEn3aKkUruEN3aIyRc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 049/266] scsi: hisi_sas: Do not reset phy timer to wait for stray phy up
Date:   Wed, 17 Jun 2020 21:12:54 -0400
Message-Id: <20200618011631.604574-49-sashal@kernel.org>
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

From: Luo Jiaxing <luojiaxing@huawei.com>

[ Upstream commit e16b9ed61e078d836a0f24a82080cf29d7539c7e ]

We found out that after phy up, the hardware reports another oob interrupt
but did not follow a phy up interrupt:

oob ready -> phy up -> DEV found -> oob read -> wait phy up -> timeout

We run link reset when wait phy up timeout, and it send a normal disk into
reset processing. So we made some circumvention action in the code, so that
this abnormal oob interrupt will not start the timer to wait for phy up.

Link: https://lore.kernel.org/r/1589552025-165012-2-git-send-email-john.garry@huawei.com
Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6f4692f0d714..031aa4043c5e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -904,8 +904,11 @@ void hisi_sas_phy_oob_ready(struct hisi_hba *hisi_hba, int phy_no)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct device *dev = hisi_hba->dev;
 
+	dev_dbg(dev, "phy%d OOB ready\n", phy_no);
+	if (phy->phy_attached)
+		return;
+
 	if (!timer_pending(&phy->timer)) {
-		dev_dbg(dev, "phy%d OOB ready\n", phy_no);
 		phy->timer.expires = jiffies + HISI_SAS_WAIT_PHYUP_TIMEOUT * HZ;
 		add_timer(&phy->timer);
 	}
-- 
2.25.1

