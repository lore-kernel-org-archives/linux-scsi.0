Return-Path: <SRS0=dRcH=6T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4174C47247
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 07:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F00F20663
	for <linux-scsi@archiver.kernel.org>; Tue,  5 May 2020 07:39:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEEHjA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 May 2020 03:39:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3408 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgEEHi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 May 2020 03:38:59 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 3E7FBBFDE342362353CE;
        Tue,  5 May 2020 15:38:56 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:38:45 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <anil.gurumurthy@qlogic.com>, <sudarsana.kalluru@qlogic.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <tglx@linutronix.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: bfa: make bfad_iocmd_ioc_get_stats() static
Date:   Tue, 5 May 2020 15:38:07 +0800
Message-ID: <20200505073807.40332-1-yanaijie@huawei.com>
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

drivers/scsi/bfa/bfad_bsg.c:140:1: warning: symbol
'bfad_iocmd_ioc_get_stats' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/bfa/bfad_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index a76c968dbac5..412dbe125e10 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -136,7 +136,7 @@ bfad_iocmd_ioc_get_attr(struct bfad_s *bfad, void *cmd)
 	return 0;
 }
 
-int
+static int
 bfad_iocmd_ioc_get_stats(struct bfad_s *bfad, void *cmd)
 {
 	struct bfa_bsg_ioc_stats_s *iocmd = (struct bfa_bsg_ioc_stats_s *)cmd;
-- 
2.21.1

