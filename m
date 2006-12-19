From: akpm@osdl.org
Subject: [patch 07/26] scsi: remove unnecessary check in drivers/scsi/sg.c
Date: Tue, 19 Dec 2006 13:14:42 -0800
Message-ID: <200612192114.kBJLEgIc010694@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35977 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbWLSVOw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Dec 2006 16:14:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, snakebyte@gmx.de, dougg@torque.net

From: Eric Sesterhenn <snakebyte@gmx.de>

coverity spotted this (cid #758).  All callers dereference sfp, so we dont
need this check.  In addition to this, we dereference it earlier in the
function.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sg.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sg.c~remove-unnecessary-check-in-drivers-scsi-sgc drivers/scsi/sg.c
--- a/drivers/scsi/sg.c~remove-unnecessary-check-in-drivers-scsi-sgc
+++ a/drivers/scsi/sg.c
@@ -1837,7 +1837,7 @@ sg_build_indirect(Sg_scatter_hold * schp
 	int blk_size = buff_size;
 	struct page *p = NULL;
 
-	if ((blk_size < 0) || (!sfp))
+	if (blk_size < 0)
 		return -EFAULT;
 	if (0 == blk_size)
 		++blk_size;	/* don't know why */
_
