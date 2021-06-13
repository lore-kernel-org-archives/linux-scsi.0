Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84B0C48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF3F861222
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 10:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhFMK25 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 06:28:57 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:45562 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbhFMK24 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 06:28:56 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d10 with ME
        id GaSu2500G21Fzsu03aSuh8; Sun, 13 Jun 2021 12:26:54 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 12:26:54 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] scsi: mptsas: switch from 'pci_' to 'dma_' API in 'mptsas_exp_repmanufacture_info()'
Date:   Sun, 13 Jun 2021 12:26:53 +0200
Message-Id: <a3a781f9a08760fdc23c24955f75d33fe7566bc9.1623579809.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1623579808.git.christophe.jaillet@wanadoo.fr>
References: <cover.1623579808.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The only caller of 'mptsas_exp_repmanufacture_info()' is
'mptsas_probe_one_phy()'. This function already calls
'sas_end_device_alloc()' or 'sas_expander_alloc()'. They both already use
GFP_KERNEL.

As no spin_lock is held at this point, it is safe to also use GFP_KERNEL
here.


While at it, also fix an ugly alignment issue in this function.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/message/fusion/mptsas.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 1c898322316a..c6af453c7874 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2896,7 +2896,8 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
 
 	sz = sizeof(struct rep_manu_request) + sizeof(struct rep_manu_reply);
 
-	data_out = pci_alloc_consistent(ioc->pcidev, sz, &data_out_dma);
+	data_out = dma_alloc_coherent(&ioc->pcidev->dev, sz, &data_out_dma,
+				      GFP_KERNEL);
 	if (!data_out) {
 		printk(KERN_ERR "Memory allocation failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
@@ -2935,7 +2936,7 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
 	flagsLength = flagsLength << MPI_SGE_FLAGS_SHIFT;
 	flagsLength |= sizeof(struct rep_manu_reply);
 	ioc->add_sge(psge, flagsLength, data_out_dma +
-	sizeof(struct rep_manu_request));
+					sizeof(struct rep_manu_request));
 
 	INITIALIZE_MGMT_STATUS(ioc->sas_mgmt.status)
 	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
@@ -2987,7 +2988,8 @@ mptsas_exp_repmanufacture_info(MPT_ADAPTER *ioc,
 	}
 out_free:
 	if (data_out_dma)
-		pci_free_consistent(ioc->pcidev, sz, data_out, data_out_dma);
+		dma_free_coherent(&ioc->pcidev->dev, sz, data_out,
+				  data_out_dma);
 put_mf:
 	if (mf)
 		mpt_free_msg_frame(ioc, mf);
-- 
2.30.2

