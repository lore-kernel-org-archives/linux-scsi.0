From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH 1/3] bsg bidi block pc
Date: Wed, 15 Aug 2007 14:16:01 -0500
Message-ID: <20070815191601.GB14977@osc.edu>
References: <20070815191523.GA14977@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:51176 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbXHOTXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2007 15:23:24 -0400
Content-Disposition: inline
In-Reply-To: <20070815191523.GA14977@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Set cmd_type on rq->next_rq to BLOCK_PC so that scsi_init_sgtable
knows to look at req->data_len rather than nr_sectors.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index ba4353a..eb0aaf4 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -278,6 +278,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 			ret = -ENOMEM;
 			goto out;
 		}
+		next_rq->cmd_type = REQ_TYPE_BLOCK_PC;
 		rq->next_rq = next_rq;
 
 		dxferp = (void*)(unsigned long)hdr->din_xferp;
-- 
1.5.2.4

