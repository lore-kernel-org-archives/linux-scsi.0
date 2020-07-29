Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58636C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 09:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D8C221744
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 09:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgG2JR4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 05:17:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8850 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727914AbgG2JRz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 05:17:55 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D9CD7C6CDDC368B2FDA7;
        Wed, 29 Jul 2020 17:17:52 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Jul 2020
 17:17:51 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <sathya.prakash@broadcom.com>, <sreekanth.reddy@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>
CC:     <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] scsi: Remove unneeded cast from memory allocation
Date:   Wed, 29 Jul 2020 17:19:14 +0800
Message-ID: <1596014354-59935-1-git-send-email-liheng40@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove casting the values returned by memory allocation function.

Coccinelle emits WARNING:

./drivers/message/fusion/mptfc.c:766:17-30: WARNING: casting value returned by memory allocation function to (FCPortPage0_t *) is useless.
./drivers/message/fusion/mptfc.c:907:17-30: WARNING: casting value returned by memory allocation function to (FCPortPage1_t *) is useless.

Signed-off-by: Li Heng <liheng40@huawei.com>
---
 drivers/message/fusion/mptfc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 4314a33..34ca9af 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -763,7 +763,7 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
 
 	data_sz = hdr.PageLength * 4;
 	rc = -ENOMEM;
-	ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
+	ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
 	if (ppage0_alloc) {
 
  try_again:
@@ -904,7 +904,7 @@ mptfc_GetFcPortPage1(MPT_ADAPTER *ioc, int portnum)
 		if (data_sz < sizeof(FCPortPage1_t))
 			data_sz = sizeof(FCPortPage1_t);
 
-		page1_alloc = (FCPortPage1_t *) pci_alloc_consistent(ioc->pcidev,
+		page1_alloc = pci_alloc_consistent(ioc->pcidev,
 						data_sz,
 						&page1_dma);
 		if (!page1_alloc)
-- 
2.7.4

