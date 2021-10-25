Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481DEC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 01:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2906B61029
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 01:53:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbhJYB4M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 21:56:12 -0400
Received: from mx22.baidu.com ([220.181.50.185]:42584 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229706AbhJYB4L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Oct 2021 21:56:11 -0400
Received: from BC-Mail-EX08.internal.baidu.com (unknown [172.31.51.48])
        by Forcepoint Email with ESMTPS id 30846EB9DBE718AAD120;
        Mon, 25 Oct 2021 09:53:44 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX08.internal.baidu.com (172.31.51.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Mon, 25 Oct 2021 09:53:43 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 25 Oct 2021 09:53:43 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <john.garry@huawei.com>
CC:     Cai Huoqing <caihuoqing@baidu.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] scsi: bnx2fc: Make use of the helper macro kthread_run()
Date:   Mon, 25 Oct 2021 09:53:45 +0800
Message-ID: <20211025015347.166-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex05.internal.baidu.com (10.127.64.15) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace kthread_create/wake_up_process() with kthread_run()
to simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
v1->v2:
	*Remove wake_up_process()
	*Fix typo in changelog, Repalce->Replace

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 71fa62bd3083..69488f1b2349 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2723,14 +2723,12 @@ static int __init bnx2fc_mod_init(void)
 
 	bg = &bnx2fc_global;
 	skb_queue_head_init(&bg->fcoe_rx_list);
-	l2_thread = kthread_create(bnx2fc_l2_rcv_thread,
-				   (void *)bg,
-				   "bnx2fc_l2_thread");
+	l2_thread = kthread_run(bnx2fc_l2_rcv_thread,
+				(void *)bg, "bnx2fc_l2_thread");
 	if (IS_ERR(l2_thread)) {
 		rc = PTR_ERR(l2_thread);
 		goto free_wq;
 	}
-	wake_up_process(l2_thread);
 	spin_lock_bh(&bg->fcoe_rx_list.lock);
 	bg->kthread = l2_thread;
 	spin_unlock_bh(&bg->fcoe_rx_list.lock);
-- 
2.25.1

