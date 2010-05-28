From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 3/6] cciss: check for msi in interrupt_not_for_us
Date: Fri, 28 May 2010 15:03:11 -0500
Message-ID: <20100528200311.GB6989@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:18716 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab0E1T6b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 May 2010 15:58:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, Steve Cameron <scameron@beardog.cce.hp.com>

Patch 3 of 4
cciss: check for msi in interrupt_no_for_us
This patch checks to see if h->msi[x]_vector is set. We need this for a
following patch. Without this check we process one interrupt then stop
because in msi[x] mode the interrupt pending bit is not set. Not sure why we
didn't encounter this before.

From: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/block/cciss.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index cae6a13..cd830cb 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3333,8 +3333,9 @@ static inline int interrupt_pending(ctlr_info_t *h)
 
 static inline long interrupt_not_for_us(ctlr_info_t *h)
 {
-	return (((h->access.intr_pending(h) == 0) ||
-		(h->interrupts_enabled == 0)));
+	return !(h->msi_vector || h->msix_vector) &&
+		((h->access.intr_pending(h) == 0) ||
+		(h->interrupts_enabled == 0));
 }
 
 static inline int bad_tag(ctlr_info_t *h, u32 tag_index,
