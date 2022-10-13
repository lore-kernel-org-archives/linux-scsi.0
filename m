Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CF5C4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Oct 2022 00:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiJMAfo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Oct 2022 20:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiJMAcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2022 20:32:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06E9DCAC4;
        Wed, 12 Oct 2022 17:28:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFAA0B81CFA;
        Thu, 13 Oct 2022 00:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABF2FC4347C;
        Thu, 13 Oct 2022 00:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620787;
        bh=YzIQwmqfE2s9hKK5FABSVnPtBIwFJRppvwDBQ0Ueq18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiDsaOrrRv6MTy2bYoAfSZZg6mCeebzpRfhztwwywV/J24D4CvOGhzsrDojfsxLVU
         zqkxkKL+ngskp2gNeaXkPnqKn+fbYVslK7IpBfx/6AfQNg7nMF3ixnBcTy3bzgpEyZ
         wMPmXAwo8em1XSmfdqAB/fy/43iXLvc1sR5P70/j0t1k7PmtTLztH7AMX2+hT8HZTJ
         240kKnbmirbZ/mTP3sHvJS6ZZfK4nyDVm7bumIJALZXBVLtJLjJst2v5YJHPybA8YV
         ZIpKpzByLtgigIj9hOGzpSQ3dErXn9Ko2zsEXItNNldRSygE7sMB2mv4gzwoe6Z1B5
         OHfzy58n6Zu2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>, Zheyu Ma <zheyuma97@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/19] scsi: 3w-9xxx: Avoid disabling device if failing to enable it
Date:   Wed, 12 Oct 2022 20:26:01 -0400
Message-Id: <20221013002623.1895576-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002623.1895576-1-sashal@kernel.org>
References: <20221013002623.1895576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Letu Ren <fantasquex@gmail.com>

[ Upstream commit 7eff437b5ee1309b34667844361c6bbb5c97df05 ]

The original code will "goto out_disable_device" and call
pci_disable_device() if pci_enable_device() fails. The kernel will generate
a warning message like "3w-9xxx 0000:00:05.0: disabling already-disabled
device".

We shouldn't disable a device that failed to be enabled. A simple return is
fine.

Link: https://lore.kernel.org/r/20220829110115.38789-1-fantasquex@gmail.com
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/3w-9xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 27521fc3ef5a..ea2cd8ecc3a5 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2009,7 +2009,7 @@ static int twa_probe(struct pci_dev *pdev, const struct pci_device_id *dev_id)
 	retval = pci_enable_device(pdev);
 	if (retval) {
 		TW_PRINTK(host, TW_DRIVER, 0x34, "Failed to enable pci device");
-		goto out_disable_device;
+		return -ENODEV;
 	}
 
 	pci_set_master(pdev);
-- 
2.35.1

