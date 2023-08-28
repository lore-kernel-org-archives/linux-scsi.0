Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F07C83F11
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Aug 2023 12:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjH1Mhv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Aug 2023 08:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbjH1Mho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Aug 2023 08:37:44 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282FBE5
        for <linux-scsi@vger.kernel.org>; Mon, 28 Aug 2023 05:37:42 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4RZ93n3mW4zLp5k;
        Mon, 28 Aug 2023 20:34:29 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Mon, 28 Aug
 2023 20:37:39 +0800
From:   Jinjie Ruan <ruanjinjie@huawei.com>
To:     <linux-scsi@vger.kernel.org>,
        Bradley Grove <linuxdrivers@attotech.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH -next] [SCSI] esas2r: Use list_for_each_entry() helper
Date:   Mon, 28 Aug 2023 20:37:33 +0800
Message-ID: <20230828123733.361547-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Convert list_for_each() to list_for_each_entry() so that the element
list_head pointer and list_entry() call are no longer needed, which
can reduce a few lines of code. No functional changed.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 drivers/scsi/esas2r/esas2r_disc.c |  4 +---
 drivers/scsi/esas2r/esas2r_int.c  | 10 ++--------
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_disc.c b/drivers/scsi/esas2r/esas2r_disc.c
index ba42536d1e87..c32d45cc2192 100644
--- a/drivers/scsi/esas2r/esas2r_disc.c
+++ b/drivers/scsi/esas2r/esas2r_disc.c
@@ -1161,14 +1161,12 @@ static void esas2r_disc_fix_curr_requests(struct esas2r_adapter *a)
 	unsigned long flags;
 	struct esas2r_target *t;
 	struct esas2r_request *rq;
-	struct list_head *element;
 
 	/* update virt_targ_id in any outstanding esas2r_requests  */
 
 	spin_lock_irqsave(&a->queue_lock, flags);
 
-	list_for_each(element, &a->defer_list) {
-		rq = list_entry(element, struct esas2r_request, req_list);
+	list_for_each_entry(rq, &a->defer_list, req_list) {
 		if (rq->vrq->scsi.function == VDA_FUNC_SCSI) {
 			t = a->targetdb + rq->target_id;
 
diff --git a/drivers/scsi/esas2r/esas2r_int.c b/drivers/scsi/esas2r/esas2r_int.c
index 5281d9356327..8fbbd53319fc 100644
--- a/drivers/scsi/esas2r/esas2r_int.c
+++ b/drivers/scsi/esas2r/esas2r_int.c
@@ -390,9 +390,7 @@ void esas2r_process_adapter_reset(struct esas2r_adapter *a)
 	struct esas2r_request *rq = &a->general_req;
 	unsigned long flags;
 	struct esas2r_disc_context *dc;
-
 	LIST_HEAD(comp_list);
-	struct list_head *element;
 
 	esas2r_trace_enter();
 
@@ -429,9 +427,7 @@ void esas2r_process_adapter_reset(struct esas2r_adapter *a)
 	set_bit(AF_COMM_LIST_TOGGLE, &a->flags);
 
 	/* Kill all the requests on the active list */
-	list_for_each(element, &a->defer_list) {
-		rq = list_entry(element, struct esas2r_request, req_list);
-
+	list_for_each_entry(rq, &a->defer_list, req_list) {
 		if (rq->req_stat == RS_STARTED)
 			if (esas2r_ioreq_aborted(a, rq, RS_ABORTED))
 				list_add_tail(&rq->comp_list, &comp_list);
@@ -446,7 +442,6 @@ void esas2r_process_adapter_reset(struct esas2r_adapter *a)
 static void esas2r_process_bus_reset(struct esas2r_adapter *a)
 {
 	struct esas2r_request *rq;
-	struct list_head *element;
 	unsigned long flags;
 
 	LIST_HEAD(comp_list);
@@ -458,8 +453,7 @@ static void esas2r_process_bus_reset(struct esas2r_adapter *a)
 	spin_lock_irqsave(&a->queue_lock, flags);
 
 	/* kill all the requests on the deferred queue */
-	list_for_each(element, &a->defer_list) {
-		rq = list_entry(element, struct esas2r_request, req_list);
+	list_for_each_entry(rq, &a->defer_list, req_list) {
 		if (esas2r_ioreq_aborted(a, rq, RS_ABORTED))
 			list_add_tail(&rq->comp_list, &comp_list);
 	}
-- 
2.34.1

