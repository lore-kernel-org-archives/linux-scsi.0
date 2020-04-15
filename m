Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB9CC2BB85
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9338D20775
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894453AbgDOIYh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:24:37 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2327 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2894444AbgDOIY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 04:24:27 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id C8545996016A81A97853;
        Wed, 15 Apr 2020 16:24:25 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 15 Apr 2020
 16:24:17 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <yanaijie@huawei.com>, <rfontana@redhat.com>,
        <kstewart@linuxfoundation.org>, <allison@lohutok.net>,
        <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <arnd@arndb.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: mvsas: make mvst_host_attrs static
Date:   Wed, 15 Apr 2020 16:50:44 +0800
Message-ID: <20200415085044.7460-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warning:

drivers/scsi/mvsas/mv_init.c:28:25: warning: symbol 'mvst_host_attrs'
was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/mvsas/mv_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 7af9173c4925..f82728b2c32f 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -25,7 +25,7 @@ static const struct mvs_chip_info mvs_chips[] = {
 	[chip_1320] =	{ 2, 4, 0x800, 17, 64, 8,  9, &mvs_94xx_dispatch, },
 };
 
-struct device_attribute *mvst_host_attrs[];
+static struct device_attribute *mvst_host_attrs[];
 
 #define SOC_SAS_NUM 2
 
@@ -785,7 +785,7 @@ static void __exit mvs_exit(void)
 	sas_release_transport(mvs_stt);
 }
 
-struct device_attribute *mvst_host_attrs[] = {
+static struct device_attribute *mvst_host_attrs[] = {
 	&dev_attr_driver_version,
 	&dev_attr_interrupt_coalescing,
 	NULL,
-- 
2.21.1

