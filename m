From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 2/2] cciss: fix XFER_READ/XFER_WRITE in do_cciss_request
Date: Fri, 15 Dec 2006 15:28:17 -0600
Message-ID: <20061215212817.GA10996@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel10.hp.com ([156.153.255.245]:39799 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965125AbWLOV2U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Dec 2006 16:28:20 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, daniel_frazier@hp.com, andrew.patterson@hp.com

Patch 2 of 2

This patch fixes a stupid bug. Sometime during the 2tb enhancement I ended up
replacing the macros XFER_READ and XFER_WRITE with h->cciss_read and
h->cciss_write respectively. It seemed to work somehow at least on x86_64 and
ia64. I don't know how. But people started complaining about command timeouts
on older controllers like the 64xx series and only on ia32. This resolves the
issue reproduced in our lab. Please consider this for inclusion. 

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>
--------------------------------------------------------------------------------

 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss_xfer_fix drivers/block/cciss.c
--- linux-2.6-work/drivers/block/cciss.c~cciss_xfer_fix	2006-12-15 08:56:40.000000000 -0600
+++ linux-2.6-work-mikem/drivers/block/cciss.c	2006-12-15 08:58:20.000000000 -0600
@@ -2492,7 +2492,7 @@ static void do_cciss_request(request_que
 	c->Request.Type.Type = TYPE_CMD;	// It is a command.
 	c->Request.Type.Attribute = ATTR_SIMPLE;
 	c->Request.Type.Direction =
-	    (rq_data_dir(creq) == READ) ? h->cciss_read : h->cciss_write;
+	    (rq_data_dir(creq) == READ) ? XFER_READ : XFER_WRITE;
 	c->Request.Timeout = 0;	// Don't time out
 	c->Request.CDB[0] =
 	    (rq_data_dir(creq) == READ) ? h->cciss_read : h->cciss_write;
_
