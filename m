From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] bsg: return SAM device status code
Date: Fri, 23 Feb 2007 10:12:31 -0500
Message-ID: <20070223151231.GA15228@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:49158 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932615AbXBWPdp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Feb 2007 10:33:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

Use the status codes from the standard, not the shifted-by-one codes
that are marked deprecated in scsi.h.  This makes bsg v4 status
report the same value as sg v3 status too.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 block/bsg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index c85d961..e39a321 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -438,7 +438,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = status_byte(rq->errors);
+	hdr->device_status = rq->errors & 0xff;
 	hdr->transport_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
-- 
1.4.4.2

