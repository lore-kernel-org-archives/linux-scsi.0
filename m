From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] bsg: Remove bogus check against request_queue->max_sectors
Date: Tue, 20 Jan 2009 15:08:22 +0200
Message-ID: <4975CCC6.7000009@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:32401 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754516AbZATNI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 08:08:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>


bsg submits REQ_TYPE_BLOCK_PC so the right check is max_hw_sectors.
But I've removed this check because right after, bsg proceeds with
calling blk_rq_map_user() which does all the right checks.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 block/bsg.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 0ce8806..44a2a0f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -218,9 +218,6 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
 
 	if (hdr->guard != 'Q')
 		return -EINVAL;
-	if (hdr->dout_xfer_len > (q->max_sectors << 9) ||
-	    hdr->din_xfer_len > (q->max_sectors << 9))
-		return -EIO;
 
 	switch (hdr->protocol) {
 	case BSG_PROTOCOL_SCSI:
-- 
1.6.0.1

