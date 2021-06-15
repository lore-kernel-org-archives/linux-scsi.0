Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE78C48BDF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 06:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C68613FA
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Jun 2021 06:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhFOGlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 02:41:24 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:7268 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhFOGlX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 02:41:23 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G3z7G3Ss1z1BMXb;
        Tue, 15 Jun 2021 14:34:18 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:39:17 +0800
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 15 Jun 2021 14:39:16 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <linuxdrivers@attotech.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] scsi: esas2r: esas2r_int: Convert list_for_each to entry variant
Date:   Tue, 15 Jun 2021 14:57:48 +0800
Message-ID: <1623740268-15916-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

convert list_for_each() to list_for_each_entry() where
applicable.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/scsi/esas2r/esas2r_int.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_int.c b/drivers/scsi/esas2r/esas2r_int.c
index 5281d93..584c7c3 100644
--- a/drivers/scsi/esas2r/esas2r_int.c
+++ b/drivers/scsi/esas2r/esas2r_int.c
@@ -392,7 +392,6 @@ void esas2r_process_adapter_reset(struct esas2r_adapter *a)
 	struct esas2r_disc_context *dc;
 
 	LIST_HEAD(comp_list);
-	struct list_head *element;
 
 	esas2r_trace_enter();
 
@@ -429,9 +428,7 @@ void esas2r_process_adapter_reset(struct esas2r_adapter *a)
 	set_bit(AF_COMM_LIST_TOGGLE, &a->flags);
 
 	/* Kill all the requests on the active list */
-	list_for_each(element, &a->defer_list) {
-		rq = list_entry(element, struct esas2r_request, req_list);
-
+	list_for_each_entry(rq, &a->defer_list, req_list) {
 		if (rq->req_stat == RS_STARTED)
 			if (esas2r_ioreq_aborted(a, rq, RS_ABORTED))
 				list_add_tail(&rq->comp_list, &comp_list);
@@ -446,7 +443,6 @@ void esas2r_process_adapter_reset(struct esas2r_adapter *a)
 static void esas2r_process_bus_reset(struct esas2r_adapter *a)
 {
 	struct esas2r_request *rq;
-	struct list_head *element;
 	unsigned long flags;
 
 	LIST_HEAD(comp_list);
@@ -458,8 +454,7 @@ static void esas2r_process_bus_reset(struct esas2r_adapter *a)
 	spin_lock_irqsave(&a->queue_lock, flags);
 
 	/* kill all the requests on the deferred queue */
-	list_for_each(element, &a->defer_list) {
-		rq = list_entry(element, struct esas2r_request, req_list);
+	list_for_each_entry(rq, &a->defer_list, req_list) {
 		if (esas2r_ioreq_aborted(a, rq, RS_ABORTED))
 			list_add_tail(&rq->comp_list, &comp_list);
 	}
-- 
2.6.2

