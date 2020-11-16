Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3CBC63697
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 02:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2D5D22263
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 02:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbgKPChK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 21:37:10 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7542 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgKPChK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Nov 2020 21:37:10 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CZCrk4ZhYzhZ69;
        Mon, 16 Nov 2020 10:36:54 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Mon, 16 Nov 2020 10:36:57 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     Satish Kharat <satishkh@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: fnic: Fix error return in fnic_probe
Date:   Mon, 16 Nov 2020 10:41:38 +0800
Message-ID: <20201116024138.22519-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If mempool_create_slab_pool fails, return -ENOMEM.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/scsi/fnic/fnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5f8a7ef8f6a8..4f7befb43d60 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -740,6 +740,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < FNIC_IO_LOCKS; i++)
 		spin_lock_init(&fnic->io_req_lock[i]);
 
+	err = -ENOMEM;
 	fnic->io_req_pool = mempool_create_slab_pool(2, fnic_io_req_cache);
 	if (!fnic->io_req_pool)
 		goto err_out_free_resources;
-- 
2.26.2

