Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38EC7C2BA1A
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 03:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1012E2074F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 03:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbgDGDXm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Apr 2020 23:23:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12687 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726663AbgDGDXm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 6 Apr 2020 23:23:42 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 1AF2E6E67A0627D7E796;
        Tue,  7 Apr 2020 11:23:40 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Tue, 7 Apr 2020
 11:23:32 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 5/7] scsi: bfa: bfa_ioc_ct.c: make two funcitons static
Date:   Tue, 7 Apr 2020 11:22:00 +0800
Message-ID: <20200407032202.36789-6-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200407032202.36789-1-yanaijie@huawei.com>
References: <20200407032202.36789-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following sparse warning:

drivers/scsi/bfa/bfa_ioc_ct.c:368:1: warning: symbol
'bfa_ioc_ct2_lpu_read_stat' was not declared. Should it be static?
drivers/scsi/bfa/bfa_ioc_ct.c:748:1: warning: symbol
'bfa_ioc_ct2_mac_reset' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/bfa/bfa_ioc_ct.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 18b58b2f304f..6fd3383ee538 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -364,7 +364,7 @@ bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 	writel(r32, rb + FNC_PERS_REG);
 }
 
-bfa_boolean_t
+static bfa_boolean_t
 bfa_ioc_ct2_lpu_read_stat(struct bfa_ioc_s *ioc)
 {
 	u32	r32;
@@ -744,7 +744,7 @@ bfa_ioc_ct2_mem_init(void __iomem *rb)
 	writel(0, (rb + CT2_MBIST_CTL_REG));
 }
 
-void
+static void
 bfa_ioc_ct2_mac_reset(void __iomem *rb)
 {
 	/* put port0, port1 MAC & AHB in reset */
-- 
2.17.2

