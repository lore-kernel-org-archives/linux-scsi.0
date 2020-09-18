Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10BEC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 906CE23444
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600396982;
	bh=23Jo1Tkt1KPyo/S63TYB6ybU+tXFKhZiLTe118m/j5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rmW1EDzIwF4W2Ub6XKKYM3vyKqhxC9v8JEIf4SAI0GU7SsyeYgN5O/pF6OGF1+6GF
	 XMTzrq/J2EcmD00gHrmbVb/2bqC1MdgRi8iZ8aXnEFqRZyv7qbPR5aQjc1qQ9/BjOS
	 vJz/bs22L0T8FJaXhLfWzSfp5/2JeV5VlyDw1Lts=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbgIRCmp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:42:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728561AbgIRCLF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E4522311D;
        Fri, 18 Sep 2020 02:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395064;
        bh=23Jo1Tkt1KPyo/S63TYB6ybU+tXFKhZiLTe118m/j5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TQnWGgLLVxIuNOzqoRvCut25Yvzl+pQKNlm2jABzncEuWmOaKeSDVINB5hjh2kxwr
         vlrVPFUiuZA+LHR3U5+GaJ4E4YDpi9e1CMkkO/84m36Lsp681RmuJLTl+nqa6zbwlJ
         ojN3Xz/DVUd2Q2CSIFW2zjZt48Cgtb06kOs0d0bg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 150/206] scsi: aacraid: Fix error handling paths in aac_probe_one()
Date:   Thu, 17 Sep 2020 22:07:06 -0400
Message-Id: <20200918020802.2065198-150-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit f7854c382240c1686900b2f098b36430c6f5047e ]

If 'scsi_host_alloc()' or 'kcalloc()' fail, 'error' is known to be 0. Set
it explicitly to -ENOMEM before branching to the error handling path.

While at it, remove 2 useless assignments to 'error'. These values are
overwridden a few lines later.

Link: https://lore.kernel.org/r/20200412094039.8822-1-christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aacraid/linit.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0142547aaadd2..eecffc03084c0 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1620,7 +1620,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *shost;
 	struct aac_dev *aac;
 	struct list_head *insert = &aac_devices;
-	int error = -ENODEV;
+	int error;
 	int unique_id = 0;
 	u64 dmamask;
 	int mask_bits = 0;
@@ -1645,7 +1645,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;
-	error = -ENODEV;
 
 	if (!(aac_drivers[index].quirks & AAC_QUIRK_SRC)) {
 		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
@@ -1677,8 +1676,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
-	if (!shost)
+	if (!shost) {
+		error = -ENOMEM;
 		goto out_disable_pdev;
+	}
 
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
@@ -1703,8 +1704,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	aac->fibs = kcalloc(shost->can_queue + AAC_NUM_MGT_FIB,
 			    sizeof(struct fib),
 			    GFP_KERNEL);
-	if (!aac->fibs)
+	if (!aac->fibs) {
+		error = -ENOMEM;
 		goto out_free_host;
+	}
+
 	spin_lock_init(&aac->fib_lock);
 
 	mutex_init(&aac->ioctl_mutex);
-- 
2.25.1

