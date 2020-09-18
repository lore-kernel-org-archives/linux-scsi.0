Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1972DC43464
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F92239D0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 02:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600394787;
	bh=UTORA0vFhKrSQVJFeXxzWe2A2a4craZybvPVO4CRqC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MTd7K9mWnUDdmFTteC6CwF8z5AYStVhaQLEWbqUF0KqmjyS/GQmCpPdV4W/+aAoIG
	 Y9Z3R2CEiLQpAsL6wQuJLMIFgvzPo1iU4dSoclvUvU/rfFNIxuZx4MnPJEJ/2r0KqK
	 AnoSxkxG3Gz6maqpJe+Fwnd7LF3791Ayq6NNMNT8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgIRCGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 22:06:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbgIRCGL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 22:06:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0364A238E2;
        Fri, 18 Sep 2020 02:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394770;
        bh=UTORA0vFhKrSQVJFeXxzWe2A2a4craZybvPVO4CRqC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wbVVJfYMUsyjwVw4qyiI4nxUAlNqTXqNDlyWvWM4sKTxh/2GjvSxiTsKQYAs/yhio
         ia9rPyeGrUAkpBFoS+HbYA1ty6RqAdR8pqgqzcCSKpJQ/DF0nuPnCXZKeMNjpg7WCc
         WSAs5SD+BiUqckms/9oR+t3HJ3DYbQgyY42z5kG4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 245/330] scsi: aacraid: Fix error handling paths in aac_probe_one()
Date:   Thu, 17 Sep 2020 21:59:45 -0400
Message-Id: <20200918020110.2063155-245-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
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
index 514aed38b5afe..1035f947f1bcf 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1607,7 +1607,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	struct Scsi_Host *shost;
 	struct aac_dev *aac;
 	struct list_head *insert = &aac_devices;
-	int error = -ENODEV;
+	int error;
 	int unique_id = 0;
 	u64 dmamask;
 	int mask_bits = 0;
@@ -1632,7 +1632,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;
-	error = -ENODEV;
 
 	if (!(aac_drivers[index].quirks & AAC_QUIRK_SRC)) {
 		error = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
@@ -1664,8 +1663,10 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_set_master(pdev);
 
 	shost = scsi_host_alloc(&aac_driver_template, sizeof(struct aac_dev));
-	if (!shost)
+	if (!shost) {
+		error = -ENOMEM;
 		goto out_disable_pdev;
+	}
 
 	shost->irq = pdev->irq;
 	shost->unique_id = unique_id;
@@ -1690,8 +1691,11 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
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

