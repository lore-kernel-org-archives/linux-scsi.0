From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 4/6] cciss: make interrupt access methods return type bool
Date: Fri, 28 May 2010 15:06:45 -0500
Message-ID: <20100528200645.GC6989@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:42696 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab0E1UCG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 16:02:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, Steve Cameron <scameron@beardog.cce.hp.com>

Patch 4 of 6
cciss: change return type from interrupt pending to return bool
This patch change the return type of our interrupt access routines to bool
from unsigned long. It makes more sense that way.

From: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>

---
 drivers/block/cciss.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/cciss.h b/drivers/block/cciss.h
index c5d4111..c527932 100644
--- a/drivers/block/cciss.h
+++ b/drivers/block/cciss.h
@@ -25,7 +25,7 @@ struct access_method {
 	void (*submit_command)(ctlr_info_t *h, CommandList_struct *c);
 	void (*set_intr_mask)(ctlr_info_t *h, unsigned long val);
 	unsigned long (*fifo_full)(ctlr_info_t *h);
-	unsigned long (*intr_pending)(ctlr_info_t *h);
+	bool (*intr_pending)(ctlr_info_t *h);
 	unsigned long (*command_completed)(ctlr_info_t *h);
 };
 typedef struct _drive_info_struct
@@ -253,7 +253,7 @@ static unsigned long SA5_completed(ctlr_info_t *h)
 /*
  *	Returns true if an interrupt is pending.. 
  */
-static unsigned long SA5_intr_pending(ctlr_info_t *h)
+static bool SA5_intr_pending(ctlr_info_t *h)
 {
 	unsigned long register_value  = 
 		readl(h->vaddr + SA5_INTR_STATUS);
@@ -268,7 +268,7 @@ static unsigned long SA5_intr_pending(ctlr_info_t *h)
 /*
  *      Returns true if an interrupt is pending..
  */
-static unsigned long SA5B_intr_pending(ctlr_info_t *h)
+static bool SA5B_intr_pending(ctlr_info_t *h)
 {
         unsigned long register_value  =
                 readl(h->vaddr + SA5_INTR_STATUS);
