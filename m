From: Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 4/4] 2.4 SCSI error handling fixes
Date: Thu, 12 Sep 2002 19:18:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020912191824.D4739@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17pYXq-0005Cp-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:18:26 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17pYXo-0001Ln-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:18:24 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been chasing a few SCSI problems today, and here's 4 patches to
address the issues I found.  These patches are against 2.4.19.

My main aim here was to solve the bad behaviour with a medium error.
Some problems were found in my HBA driver, but some were found in
the error handling code.

Problems found were:

a) retrying a command with stale or invalid command information.
   (Patches 1 and 2)
b) reporting the wrong command on IO error.
   (Patch 3)
c) drives behaving badly in error condition, reporting success without
   data transfer.
   (Patch 4)

Results of investigation into these issues can be found at in my lkml
messages at:

  http://marc.theaimsgroup.com/?l=linux-kernel&m=103184937214222&w=2

Patch 4 is the one I'm least happy about; we shouldn't unconditionally
set the FUA bit in READ10 commands.  It seems that we need to set this
bit only after receiving an error, and only when we try to read the
remaining blocks which we believe are good.

Patch 4: set FUA bit for READ10/WRITE10 commands.

*** NOTE *** This needs a better solution.  Setting the
FUA bit bypasses the drives cache altogether.  You should
read the message at the URL above *before* commenting for
a detailed explaination of the problem, and why I've had
to make this change.

--- orig/drivers/scsi/sd.c	Mon Aug  5 13:31:25 2002
+++ linux/drivers/scsi/sd.c	Thu Sep 12 17:55:55 2002
@@ -399,6 +399,7 @@
 			this_count = 0xffff;
 
 		SCpnt->cmnd[0] += READ_10 - READ_6;
+		SCpnt->cmnd[1] |= 1 << 3; /* Set FUA --rmk */
 		SCpnt->cmnd[2] = (unsigned char) (block >> 24) & 0xff;
 		SCpnt->cmnd[3] = (unsigned char) (block >> 16) & 0xff;
 		SCpnt->cmnd[4] = (unsigned char) (block >> 8) & 0xff;


-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

