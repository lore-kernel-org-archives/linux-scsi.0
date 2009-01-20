From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Subject: [PATCH] bsg: Error print if device is not bidi capable when
 refusing a bidi command
Date: Tue, 20 Jan 2009 16:13:00 +0200
Message-ID: <4975DBEC.4000700@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:8933 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756773AbZATONF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 09:13:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>


If a bidi command was issued to a request_queue not mark as
QUEUE_FLAG_BIDI. Issue an error report. This is a misconfiguration
an administrator would like to know about, which is otherwise
hard to detect.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/bsg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 44a2a0f..977547a 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -270,6 +270,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 
 	if (rw == WRITE && hdr->din_xfer_len) {
 		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
+			printk(KERN_ERR "bsg: Attempt to send a bidi command "
+			       "to a none bidi device\n");
 			ret = -EOPNOTSUPP;
 			goto out;
 		}
-- 
1.6.0.1

