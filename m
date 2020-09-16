Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 592ECC43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 06:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34884208E4
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 06:21:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgIPGVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Sep 2020 02:21:09 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12725 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726438AbgIPGVF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Sep 2020 02:21:05 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6CD40DC7D8F9BF50CBAA;
        Wed, 16 Sep 2020 14:21:03 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.487.0; Wed, 16 Sep 2020 14:20:53 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Qinglang Miao" <miaoqinglang@huawei.com>
Subject: [PATCH -next] scsi: dpt_i2o: remove unnecessary spin_lock_init()
Date:   Wed, 16 Sep 2020 14:21:34 +0800
Message-ID: <20200916062134.191050-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The spinlock adpt_post_wait_lock is initialized statically. It is
unnecessary to initialize by spin_lock_init().

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/scsi/dpt_i2o.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 4251212ac..79e69d9c9 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1001,7 +1001,6 @@ static int adpt_install_hba(struct scsi_host_template* sht, struct pci_dev* pDev
 
 	// Initializing the spinlocks
 	spin_lock_init(&pHba->state_lock);
-	spin_lock_init(&adpt_post_wait_lock);
 
 	if(raptorFlag == 0){
 		printk(KERN_INFO "Adaptec I2O RAID controller"
-- 
2.23.0

