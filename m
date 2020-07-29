Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54F79C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 09:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E85221744
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 09:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgG2JSd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 05:18:33 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:43570 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728014AbgG2JSd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 05:18:33 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8FA3DA2313EBFCBF4DC2;
        Wed, 29 Jul 2020 17:18:30 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 29 Jul 2020
 17:18:26 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <sathya.prakash@broadcom.com>, <sreekanth.reddy@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>
CC:     <MPT-FusionLinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] scsi: Remove unneeded cast from memory allocation
Date:   Wed, 29 Jul 2020 17:19:50 +0800
Message-ID: <1596014390-18605-1-git-send-email-liheng40@huawei.com>
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

./drivers/message/fusion/mptctl.c:2596:14-31: WARNING: casting value returned by memory allocation function to (SCSIDevicePage0_t *) is useless.
./drivers/message/fusion/mptctl.c:2660:15-32: WARNING: casting value returned by memory allocation function to (SCSIDevicePage3_t *) is useless.

Signed-off-by: Li Heng <liheng40@huawei.com>
---
 drivers/message/fusion/mptctl.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 1074b88..dbf5255 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2455,7 +2455,7 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 		}
 	}
 
-	/* 
+	/*
 	 * Gather ISTWI(Industry Standard Two Wire Interface) Data
 	 */
 	if ((mf = mpt_get_msg_frame(mptctl_id, ioc)) == NULL) {
@@ -2593,7 +2593,7 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
        /* Get the data transfer speeds
         */
 	data_sz = ioc->spi_data.sdp0length * 4;
-	pg0_alloc = (SCSIDevicePage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	pg0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
 	if (pg0_alloc) {
 		hdr.PageVersion = ioc->spi_data.sdp0version;
 		hdr.PageLength = data_sz;
@@ -2657,8 +2657,7 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 		/* Issue the second config page request */
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 		data_sz = (int) cfg.cfghdr.hdr->PageLength * 4;
-		pg3_alloc = (SCSIDevicePage3_t *) pci_alloc_consistent(
-							ioc->pcidev, data_sz, &page_dma);
+		pg3_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
 		if (pg3_alloc) {
 			cfg.physAddr = page_dma;
 			cfg.pageAddr = (karg.hdr.channel << 8) | karg.hdr.id;
-- 
2.7.4

