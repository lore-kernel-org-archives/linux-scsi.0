From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] SCSI st: compile fix when DEBUG set to one
Date: Fri, 22 Feb 2008 20:11:21 +0200 (EET)
Message-ID: <alpine.LSU.1.00.0802222008210.5292@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:51712 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbYBVSLY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2008 13:11:24 -0500
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id BB2DF1B8DF
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2008 20:11:22 +0200 (EET)
Received: from kai.makisara.local (a88-114-81-250.elisa-laajakaista.fi [88.114.81.250])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id A8B45E53C2
	for <linux-scsi@vger.kernel.org>; Fri, 22 Feb 2008 20:11:21 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Remove the now useless counting of adjacent pages from the debugging code in
to make it compile when DEBUG is set non-zero.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---
The patch does not touch any code compiled when DEBUG is zero and is suitable
for 2.5.25.

 drivers/scsi/st.c |   11 ++++-------
 drivers/scsi/st.h |    1 -
 2 files changed, 4 insertions(+), 8 deletions(-)

Index: linux-2.6.25-rc2-q/drivers/scsi/st.c
===================================================================
--- linux-2.6.25-rc2-q.orig/drivers/scsi/st.c
+++ linux-2.6.25-rc2-q/drivers/scsi/st.c
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs support
  */
 
-static const char *verstr = "20080117";
+static const char *verstr = "20080221";
 
 #include <linux/module.h>
 
@@ -1172,7 +1172,7 @@ static int st_open(struct inode *inode, 
 	STp->try_dio_now = STp->try_dio;
 	STp->recover_count = 0;
 	DEB( STp->nbr_waits = STp->nbr_finished = 0;
-	     STp->nbr_requests = STp->nbr_dio = STp->nbr_pages = STp->nbr_combinable = 0; )
+	     STp->nbr_requests = STp->nbr_dio = STp->nbr_pages = 0; )
 
 	retval = check_tape(STp, filp);
 	if (retval < 0)
@@ -1226,8 +1226,8 @@ static int st_flush(struct file *filp, f
 	}
 
 	DEBC( if (STp->nbr_requests)
-		printk(KERN_DEBUG "%s: Number of r/w requests %d, dio used in %d, pages %d (%d).\n",
-		       name, STp->nbr_requests, STp->nbr_dio, STp->nbr_pages, STp->nbr_combinable));
+		printk(KERN_DEBUG "%s: Number of r/w requests %d, dio used in %d, pages %d.\n",
+		       name, STp->nbr_requests, STp->nbr_dio, STp->nbr_pages));
 
 	if (STps->rw == ST_WRITING && !STp->pos_unknown) {
 		struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
@@ -1422,9 +1422,6 @@ static int setup_buffering(struct scsi_t
 		     if (STbp->do_dio) {
 			STp->nbr_dio++;
 			STp->nbr_pages += STbp->do_dio;
-			for (i=1; i < STbp->do_dio; i++)
-				if (page_to_pfn(STbp->sg[i].page) == page_to_pfn(STbp->sg[i-1].page) + 1)
-					STp->nbr_combinable++;
 		     }
 		)
 	} else
Index: linux-2.6.25-rc2-q/drivers/scsi/st.h
===================================================================
--- linux-2.6.25-rc2-q.orig/drivers/scsi/st.h
+++ linux-2.6.25-rc2-q/drivers/scsi/st.h
@@ -164,7 +164,6 @@ struct scsi_tape {
 	int nbr_requests;
 	int nbr_dio;
 	int nbr_pages;
-	int nbr_combinable;
 	unsigned char last_cmnd[6];
 	unsigned char last_sense[16];
 #endif
