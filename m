From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH resend] bsg: return SAM device status code
Date: Tue, 24 Apr 2007 13:25:02 -0400
Message-ID: <20070424172502.GA21882@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:42078 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422782AbXDXRZE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2007 13:25:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

Use the status codes from the spec, not the shifted-by-one codes
that are marked deprecated in scsi.h  This makes bsg v4 status
report the same value as sg v3 status too.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
Acked-by: Douglas Gilbert <dougg@torque.net>
---
 block/bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index f0753c0..92be6fa 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -440,7 +440,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = status_byte(rq->errors);
+	hdr->device_status = rq->errors & 0xff;
 	hdr->transport_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
-- 
1.5.0.6

