From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] Don't retry SG_IO (REQ_BLOCK_PC) commands.
Date: Thu, 20 Nov 2003 08:55:55 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031120085555.A20609@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:56505 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262330AbTKTQ4I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 11:56:08 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dmitrik@users.sourceforge.net, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, Jens Axboe <axboe@suse.de>

On Thu, Nov 20, 2003 at 08:57:15AM -0700, Pat LaVarre wrote:

> This also could matter.  In our kernel code who wrongly thinks we gave
> permission to retry SG_IO?  This evidence echoes someone else's - may

sg.c looks OK, Dmitri must be using /dev/sdN. We need this fix, patch
is for the current scsi-bugfixes-2.6:

Don't retry SG_IO (REQ_BLOCK_PC) commands.

===== drivers/scsi/sd.c 1.138 vs edited =====
--- 1.138/drivers/scsi/sd.c	Fri Oct 17 16:14:06 2003
+++ edited/drivers/scsi/sd.c	Thu Nov 20 08:18:34 2003
@@ -347,9 +347,9 @@
 	 */
 	SCpnt->transfersize = sdp->sector_size;
 	SCpnt->underflow = this_count << 9;
+	SCpnt->allowed = SD_MAX_RETRIES;
 
 queue:
-	SCpnt->allowed = SD_MAX_RETRIES;
 	SCpnt->timeout_per_command = timeout;
 
 	/*


