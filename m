From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/2] sg: fixup infoleak when using SG_GET_REQUEST_TABLE
Date: Fri, 15 Sep 2017 14:05:16 +0200
Message-ID: <1505477116-75013-3-git-send-email-hare@suse.de>
References: <1505477116-75013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49373 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751184AbdIOMFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 08:05:24 -0400
In-Reply-To: <1505477116-75013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, security@kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When calling SG_GET_REQUEST_TABLE ioctl that only a half-filled
table is returned; the remaining part will then contain stale
kernel memory information.
This patch zeroes out the entire table to avoid this issue.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index f1e20ca0..7f98ab4 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -868,7 +868,6 @@ static int max_sectors_bytes(struct request_queue *q)
 	list_for_each_entry(srp, &sfp->rq_list, entry) {
 		if (val > SG_MAX_QUEUE)
 			break;
-		memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
 		rinfo[val].req_state = srp->done + 1;
 		rinfo[val].problem =
 			srp->header.masked_status &
@@ -1076,8 +1075,8 @@ static int max_sectors_bytes(struct request_queue *q)
 		else {
 			sg_req_info_t *rinfo;
 
-			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
-								GFP_KERNEL);
+			rinfo = kzalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
+					GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
-- 
1.8.5.6
