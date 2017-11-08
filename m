From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 3/3] zfcp: drop open coded assignments of timer_list.function
Date: Wed,  8 Nov 2017 15:17:09 +0100
Message-ID: <20171108141709.79074-4-maier@linux.vnet.ibm.com>
References: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47044 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752649AbdKHOSL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2017 09:18:11 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vA8EFPMW012540
        for <linux-scsi@vger.kernel.org>; Wed, 8 Nov 2017 09:18:11 -0500
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2e437msfrr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 08 Nov 2017 09:18:10 -0500
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Wed, 8 Nov 2017 14:18:07 -0000
In-Reply-To: <20171108141709.79074-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Kees Cook <keescook@chromium.org>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>

The majority of requests is regular SCSI I/O on the hot path.
Since these use a timeout owned by the block layer, zfcp does not use
zfcp_fsf_req.timer. Hence, the very early unconditional and even
incomplete (handler function yet unknown) timer initialization in
zfcp_fsf_req_create() is not necessary.

Instead defer the timer initialization to when we know zfcp needs to use
its own request timeout in zfcp_fsf_start_timer() and
zfcp_fsf_start_erp_timer(). At that point in time we also know the handler
function. So drop open coded assignments of timer_list.function and
instead use the new timer API wrapper function timer_setup().

This way, we don't have to touch zfcp again, when the cast macro
TIMER_FUNC_TYPE gets removed again after the global conversion to
timer_setup() is complete.

Depends-on: v4.14-rc3 commit 686fef928bba ("timer: Prepare to change timer callback argument type")
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Jens Remus <jremus@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 51b81c0a0652..c8e368f0f299 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -34,7 +34,7 @@ static void zfcp_fsf_request_timeout_handler(struct timer_list *t)
 static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
 				 unsigned long timeout)
 {
-	fsf_req->timer.function = (TIMER_FUNC_TYPE)zfcp_fsf_request_timeout_handler;
+	timer_setup(&fsf_req->timer, zfcp_fsf_request_timeout_handler, 0);
 	fsf_req->timer.expires = jiffies + timeout;
 	add_timer(&fsf_req->timer);
 }
@@ -42,7 +42,7 @@ static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
 static void zfcp_fsf_start_erp_timer(struct zfcp_fsf_req *fsf_req)
 {
 	BUG_ON(!fsf_req->erp_action);
-	fsf_req->timer.function = (TIMER_FUNC_TYPE)zfcp_erp_timeout_handler;
+	timer_setup(&fsf_req->timer, zfcp_erp_timeout_handler, 0);
 	fsf_req->timer.expires = jiffies + 30 * HZ;
 	add_timer(&fsf_req->timer);
 }
@@ -692,7 +692,6 @@ static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_qdio *qdio,
 		adapter->req_no++;
 
 	INIT_LIST_HEAD(&req->list);
-	timer_setup(&req->timer, NULL, 0);
 	init_completion(&req->completion);
 
 	req->adapter = adapter;
-- 
2.13.5
