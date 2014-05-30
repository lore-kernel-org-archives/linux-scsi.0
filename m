From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 1/9] block: make timeout_list protectd by REQ_ATOM_COMPLETE bit
Date: Fri, 30 May 2014 16:15:39 +0800
Message-ID: <1401437747-2097-2-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:52455 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaE3IMv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:12:51 -0400
Received: by mail-yh0-f43.google.com with SMTP id v1so1288360yhn.16
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:12:50 -0700 (PDT)
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

The "request->timeout_list" is under the risk of modified by both timeout
(abort handler) and a "finishing" handler. Using bit REQ_ATOM_COMPLETE in
atomic_flags as a guard to shield this issue.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 block/blk-timeout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 7a882f7..d3067f0 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -120,13 +120,14 @@ void blk_rq_check_expired(struct request *rq, unsigned long *next_timeout,
 			  unsigned int *next_set)
 {
 	if (time_after_eq(jiffies, rq->deadline)) {
-		list_del_init(&rq->timeout_list);
 
 		/*
 		 * Check if we raced with end io completion
 		 */
-		if (!blk_mark_rq_complete(rq))
+		if (!blk_mark_rq_complete(rq)) {
+			list_del_init(&rq->timeout_list);
 			blk_rq_timed_out(rq);
+		}
 	} else if (!*next_set || time_after(*next_timeout, rq->deadline)) {
 		*next_timeout = rq->deadline;
 		*next_set = 1;
-- 
1.8.1.4

