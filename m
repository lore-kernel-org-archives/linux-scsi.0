From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH ver2 printk_ratelimit] bsg: Error print if device is not bidi
 capable when refusing a bidi command
Date: Tue, 20 Jan 2009 16:38:38 +0200
Message-ID: <4975E1EE.5070101@panasas.com>
References: <4975DC00.2090005@panasas.com> <20090120141517.GM30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:22242 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbZATOip (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 09:38:45 -0500
Received: by ug-out-1314.google.com with SMTP id 39so285709ugf.37
        for <linux-scsi@vger.kernel.org>; Tue, 20 Jan 2009 06:38:43 -0800 (PST)
In-Reply-To: <20090120141517.GM30821@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>


If a bidi command was issued to a request_queue not mark as
QUEUE_FLAG_BIDI. Issue an error report. This is a misconfiguration
an administrator would like to know about, which is otherwise
hard to detect.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/bsg.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 44a2a0f..1da14fe 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -270,6 +270,11 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 
 	if (rw == WRITE && hdr->din_xfer_len) {
 		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
+			if (printk_ratelimit()) {
+				printk(KERN_ERR
+					"bsg: Attempt to send a bidi command "
+					"to a none bidi device\n");
+			}
 			ret = -EOPNOTSUPP;
 			goto out;
 		}
-- 
1.6.0.1


