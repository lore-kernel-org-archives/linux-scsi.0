Return-Path: <SRS0=W9vy=DJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43401C47423
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1716A206B2
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Oct 2020 14:35:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgJBOew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Oct 2020 10:34:52 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14801 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388122AbgJBOek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Oct 2020 10:34:40 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B9DB3BE3A2EE155DDC13;
        Fri,  2 Oct 2020 22:34:34 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 2 Oct 2020 22:34:26 +0800
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 1/7] scsi: hisi_sas: Use hisi_hba->cq_nvecs for calling calling synchronize_irq()
Date:   Fri, 2 Oct 2020 22:30:32 +0800
Message-ID: <1601649038-25534-2-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
References: <1601649038-25534-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

We got one call trace when running function level reset with online CPUs
number less than 16 and enable MSI auto-affinity.

[16538.348038] Call trace:
[16538.348422]  pci_irq_vector+0x98/0xc0
[16538.348947]  disable_host_v3_hw+0x8c/0x288 [hisi_sas_v3_hw]
[16538.349706]  hisi_sas_reset_prepare_v3_hw+0x60/0x88 [hisi_sas_v3_hw]
[16538.350631]  pci_dev_save_and_disable+0x38/0x68
[16538.351290]  pci_reset_function+0x44/0x88
[16538.351846]  reset_store+0x6c/0xb8
[16538.352429]  dev_attr_store+0x44/0x60
[16538.353035]  sysfs_kf_write+0x58/0x80
[16538.353558]  kernfs_fop_write+0x140/0x230
[16538.354175]  __vfs_write+0x48/0x80
[16538.354675]  vfs_write+0xb8/0x1d8
[16538.355145]  ksys_write+0x74/0xf8
[16538.355615]  __arm64_sys_write+0x24/0x30
[16538.356240]  el0_svc_common.constprop.4+0x80/0x1f0
[16538.356905]  do_el0_svc+0x2c/0x38
[16538.357408]  el0_svc+0x14/0x40
[16538.357848]  el0_sync_handler+0xbc/0x2ec
[16538.358388]  el0_sync+0x140/0x180

The reason is that if we use pci_alloc_irq_vectors_affinity() to alloc IRQ,
the number of CQ IRQs can only be less than or equal to the number of
online CPUs, but we use hisi_hba->queue_count(alway 16) for cycle at
interrupt_disable_v3_hw(). So pci_irq_vector() warn us by this call trace.

So use hisi_hba->cq_nvecs to replace hisi_hba->queue_count to avoid
synchronize IRQ which is not existed.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 87bda037303f..0cc186fcbca8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2525,10 +2525,11 @@ static void interrupt_disable_v3_hw(struct hisi_hba *hisi_hba)
 	synchronize_irq(pci_irq_vector(pdev, 1));
 	synchronize_irq(pci_irq_vector(pdev, 2));
 	synchronize_irq(pci_irq_vector(pdev, 11));
-	for (i = 0; i < hisi_hba->queue_count; i++) {
+	for (i = 0; i < hisi_hba->queue_count; i++)
 		hisi_sas_write32(hisi_hba, OQ0_INT_SRC_MSK + 0x4 * i, 0x1);
+
+	for (i = 0; i < hisi_hba->cq_nvecs; i++)
 		synchronize_irq(pci_irq_vector(pdev, i + 16));
-	}
 
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK1, 0xffffffff);
 	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK2, 0xffffffff);
-- 
2.26.2

