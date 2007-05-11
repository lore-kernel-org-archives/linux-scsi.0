From: akpm@linux-foundation.org
Subject: [patch 03/28] scsi: remove unnecessary check in drivers/scsi/sg.c
Date: Thu, 10 May 2007 23:00:47 -0700
Message-ID: <200705110600.l4B60lc6008124@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756863AbXEKGBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:01:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, snakebyte@gmx.de, dougg@torque.net

From: Eric Sesterhenn <snakebyte@gmx.de>

coverity spotted this (cid #758).  All callers dereference sfp, so we dont
need this check.  In addition to this, we dereference it earlier in the
function.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sg.c~remove-unnecessary-check-in-drivers-scsi-sgc drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~remove-unnecessary-check-in-drivers-scsi-sgc
+++ a/drivers/scsi/sg.c
@@ -1842,7 +1842,7 @@ sg_build_indirect(Sg_scatter_hold * schp
 	int blk_size = buff_size;
 	struct page *p = NULL;
 
-	if ((blk_size < 0) || (!sfp))
+	if (blk_size < 0)
 		return -EFAULT;
 	if (0 == blk_size)
 		++blk_size;	/* don't know why */
_
