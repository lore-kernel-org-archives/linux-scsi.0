From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 4/5] bsg: bidi fix
Date: Sat, 22 Dec 2007 15:10:12 -0500
Message-ID: <20071222202000.1D79D900CE0@quasar.osc.edu>
References: <20071222201558.GA25063@osc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:53853 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbXLVUcF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Dec 2007 15:32:05 -0500
In-Reply-To: <20071222201558.GA25063@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

Fixes for bsg to handle bidirectional commands.  The next_rq part
of a bidi command must be marked REQ_TYPE_BLOCK_PC for scsi_init_sgtable.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 0d9364d..fc3a024 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -291,6 +291,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 			goto out;
 		}
 		rq->next_rq = next_rq;
+		next_rq->cmd_type = REQ_TYPE_BLOCK_PC;
 
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
 		ret =  blk_rq_map_user(q, next_rq, dxferp, hdr->din_xfer_len);
-- 
1.5.3.6

