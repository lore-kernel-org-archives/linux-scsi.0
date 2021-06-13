Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF66CC48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 08:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C301861261
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 08:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhFMIZO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 04:25:14 -0400
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:48824 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbhFMIZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 04:25:14 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d41 with ME
        id GYPB2500E21Fzsu03YPBdx; Sun, 13 Jun 2021 10:23:12 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 10:23:12 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/3] scsi: mptbase: switch from 'pci_' to 'dma_' API in 'mpt_alloc_fw_memory()'
Date:   Sun, 13 Jun 2021 10:23:09 +0200
Message-Id: <98e4d8fa2567fcb81a3eb7626b1e2cb0ebc3ee82.1623571676.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1623571676.git.christophe.jaillet@wanadoo.fr>
References: <cover.1623571676.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

'mpt_alloc_fw_memory()' should still use GFP_ATOMIC, because it can be
called from 'mpt_do_upload()' which might sleep.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Instead of using GFP_ATOMIC, we could pass the 'sleepFlag' from
'mpt_do_upload()' and check all other callers to pass the expected flag.
---
 drivers/message/fusion/mptbase.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a9f261b6f613..2add74f92323 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -3517,7 +3517,8 @@ mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size)
 		rc = 0;
 		goto out;
 	}
-	ioc->cached_fw = pci_alloc_consistent(ioc->pcidev, size, &ioc->cached_fw_dma);
+	ioc->cached_fw = dma_alloc_coherent(&ioc->pcidev->dev, size,
+					    &ioc->cached_fw_dma, GFP_ATOMIC);
 	if (!ioc->cached_fw) {
 		printk(MYIOC_s_ERR_FMT "Unable to allocate memory for the cached firmware image!\n",
 		    ioc->name);
@@ -3550,7 +3551,8 @@ mpt_free_fw_memory(MPT_ADAPTER *ioc)
 	sz = ioc->facts.FWImageSize;
 	dinitprintk(ioc, printk(MYIOC_s_DEBUG_FMT "free_fw_memory: FW Image  @ %p[%p], sz=%d[%x] bytes\n",
 		 ioc->name, ioc->cached_fw, (void *)(ulong)ioc->cached_fw_dma, sz, sz));
-	pci_free_consistent(ioc->pcidev, sz, ioc->cached_fw, ioc->cached_fw_dma);
+	dma_free_coherent(&ioc->pcidev->dev, sz, ioc->cached_fw,
+			  ioc->cached_fw_dma);
 	ioc->alloc_total -= sz;
 	ioc->cached_fw = NULL;
 }
-- 
2.30.2

