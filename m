From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix jiffies compare warning in osst
Date: Tue, 11 Mar 2003 20:13:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311201301.B986@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.39/drivers/scsi/osst.c	Sun Feb  2 17:50:23 2003
+++ edited/drivers/scsi/osst.c	Mon Mar 10 14:35:46 2003
@@ -777,7 +777,7 @@
 #define OSST_POLL_PER_SEC 10
 static int osst_wait_frame(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int curr, int minlast, int to)
 {
-	long	startwait     = jiffies;
+	unsigned long startwait = jiffies;
 	char  * name          = tape_name(STp);
 #if DEBUG
 	char	notyetprinted = 1;
@@ -1288,7 +1288,7 @@
 	int             logical_blk_num  = ntohl(STp->buffer->aux->logical_blk_num) 
 						- (nframes + pending - 1) * blks_per_frame;
 	char          * name             = tape_name(STp);
-	long		startwait        = jiffies;
+	unsigned long	startwait        = jiffies;
 #if DEBUG
 	int		dbg              = debugging;
 #endif
@@ -1477,7 +1477,7 @@
 	int		expected  = 0;
 	int		attempts  = 1000 / skip;
 	int		flag      = 1;
-	long		startwait = jiffies;
+	unsigned long	startwait = jiffies;
 #if DEBUG
 	int		dbg       = debugging;
 #endif
