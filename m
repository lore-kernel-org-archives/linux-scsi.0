From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/2] sg: factor out sg_fill_request_table()
Date: Fri, 15 Sep 2017 14:05:15 +0200
Message-ID: <1505477116-75013-2-git-send-email-hare@suse.de>
References: <1505477116-75013-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49366 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751230AbdIOMFY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 08:05:24 -0400
In-Reply-To: <1505477116-75013-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Alexander Potapenko <glider@google.com>, Ingo Molnar <mingo@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, security@kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Factor our sg_fill_request_table() for better readability.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sg.c | 62 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 03194c4..f1e20ca0 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -857,6 +857,40 @@ static int max_sectors_bytes(struct request_queue *q)
 	return max_sectors << 9;
 }
 
+static void
+sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
+{
+	Sg_request *srp;
+	int val;
+	unsigned int ms;
+
+	val = 0;
+	list_for_each_entry(srp, &sfp->rq_list, entry) {
+		if (val > SG_MAX_QUEUE)
+			break;
+		memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
+		rinfo[val].req_state = srp->done + 1;
+		rinfo[val].problem =
+			srp->header.masked_status &
+			srp->header.host_status &
+			srp->header.driver_status;
+		if (srp->done)
+			rinfo[val].duration =
+				srp->header.duration;
+		else {
+			ms = jiffies_to_msecs(jiffies);
+			rinfo[val].duration =
+				(ms > srp->header.duration) ?
+				(ms - srp->header.duration) : 0;
+		}
+		rinfo[val].orphan = srp->orphan;
+		rinfo[val].sg_io_owned = srp->sg_io_owned;
+		rinfo[val].pack_id = srp->header.pack_id;
+		rinfo[val].usr_ptr = srp->header.usr_ptr;
+		val++;
+	}
+}
+
 static long
 sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -1041,39 +1075,15 @@ static int max_sectors_bytes(struct request_queue *q)
 			return -EFAULT;
 		else {
 			sg_req_info_t *rinfo;
-			unsigned int ms;
 
 			rinfo = kmalloc(SZ_SG_REQ_INFO * SG_MAX_QUEUE,
 								GFP_KERNEL);
 			if (!rinfo)
 				return -ENOMEM;
 			read_lock_irqsave(&sfp->rq_list_lock, iflags);
-			val = 0;
-			list_for_each_entry(srp, &sfp->rq_list, entry) {
-				if (val > SG_MAX_QUEUE)
-					break;
-				memset(&rinfo[val], 0, SZ_SG_REQ_INFO);
-				rinfo[val].req_state = srp->done + 1;
-				rinfo[val].problem =
-					srp->header.masked_status &
-					srp->header.host_status &
-					srp->header.driver_status;
-				if (srp->done)
-					rinfo[val].duration =
-						srp->header.duration;
-				else {
-					ms = jiffies_to_msecs(jiffies);
-					rinfo[val].duration =
-						(ms > srp->header.duration) ?
-						(ms - srp->header.duration) : 0;
-				}
-				rinfo[val].orphan = srp->orphan;
-				rinfo[val].sg_io_owned = srp->sg_io_owned;
-				rinfo[val].pack_id = srp->header.pack_id;
-				rinfo[val].usr_ptr = srp->header.usr_ptr;
-				val++;
-			}
+			sg_fill_request_table(sfp, rinfo);
 			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+
 			result = __copy_to_user(p, rinfo,
 						SZ_SG_REQ_INFO * SG_MAX_QUEUE);
 			result = result ? -EFAULT : 0;
-- 
1.8.5.6
