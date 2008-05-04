From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 1/2] SCSI tape: fix buffer position in partial write
Date: Sun, 4 May 2008 22:13:38 +0300 (EEST)
Message-ID: <alpine.LSU.1.10.0805042211490.5805@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52107 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbYEDTXO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 15:23:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Move buffer pointer back when data could not be written. Bug found by Mike Christie.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---
The patch is against 2.6.26-rc1.

 drivers/scsi/st.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc1-q/drivers/scsi/st.c
===================================================================
--- linux-2.6.26-rc1-q.orig/drivers/scsi/st.c
+++ linux-2.6.26-rc1-q/drivers/scsi/st.c
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20080224";
+static const char *verstr = "20080504";
 
 #include <linux/module.h>
 
@@ -1663,6 +1663,7 @@ st_write(struct file *filp, const char _
 				if (undone <= do_count) {
 					/* Only data from this write is not written */
 					count += undone;
+					b_point -= undone;
 					do_count -= undone;
 					if (STp->block_size)
 						blks = (transfer - undone) / STp->block_size;
