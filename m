Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD3FC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 13:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAE2860F44
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 13:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhJRNSw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 09:18:52 -0400
Received: from mx22.baidu.com ([220.181.50.185]:59876 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231167AbhJRNSv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 09:18:51 -0400
Received: from BJHW-Mail-Ex07.internal.baidu.com (unknown [10.127.64.17])
        by Forcepoint Email with ESMTPS id 5633A34E8BD8722DFF6C;
        Mon, 18 Oct 2021 21:16:39 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex07.internal.baidu.com (10.127.64.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 18 Oct 2021 21:16:39 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 18 Oct 2021 21:16:38 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: fnic: Make use of vzalloc() instead of vmalloc/memset()
Date:   Mon, 18 Oct 2021 21:16:37 +0800
Message-ID: <20211018131637.381-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex07_2021-10-18 21:16:39:314
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replacing vmalloc()/memset() with vzalloc() to simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/scsi/fnic/fnic_debugfs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index e7326505cabb..e2fea5b574c3 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -216,25 +216,21 @@ static int fnic_trace_debugfs_open(struct inode *inode,
 		return -ENOMEM;
 
 	if (*rdata_ptr == fc_trc_flag->fnic_trace) {
-		fnic_dbg_prt->buffer = vmalloc(array3_size(3, trace_max_pages,
+		fnic_dbg_prt->buffer = vzalloc(array3_size(3, trace_max_pages,
 							   PAGE_SIZE));
 		if (!fnic_dbg_prt->buffer) {
 			kfree(fnic_dbg_prt);
 			return -ENOMEM;
 		}
-		memset((void *)fnic_dbg_prt->buffer, 0,
-		3 * (trace_max_pages * PAGE_SIZE));
 		fnic_dbg_prt->buffer_len = fnic_get_trace_data(fnic_dbg_prt);
 	} else {
 		fnic_dbg_prt->buffer =
-			vmalloc(array3_size(3, fnic_fc_trace_max_pages,
+			vzalloc(array3_size(3, fnic_fc_trace_max_pages,
 					    PAGE_SIZE));
 		if (!fnic_dbg_prt->buffer) {
 			kfree(fnic_dbg_prt);
 			return -ENOMEM;
 		}
-		memset((void *)fnic_dbg_prt->buffer, 0,
-			3 * (fnic_fc_trace_max_pages * PAGE_SIZE));
 		fnic_dbg_prt->buffer_len =
 			fnic_fc_trace_get_data(fnic_dbg_prt, *rdata_ptr);
 	}
-- 
2.25.1

