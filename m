From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Make host_no an unsigned int
Date: Tue, 15 Jul 2008 14:54:16 -0600
Message-ID: <20080715205415.GJ14894@parisc-linux.org>
References: <48775DCD.5010202@linux.vnet.ibm.com> <487D059C.60400@linux.vnet.ibm.com> <20080715202507.GI14894@parisc-linux.org> <487D0933.1010201@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59826 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761416AbYGOUyR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2008 16:54:17 -0400
Content-Disposition: inline
In-Reply-To: <487D0933.1010201@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Daniel Debonzi <debonzi@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

On Tue, Jul 15, 2008 at 03:31:47PM -0500, Brian King wrote:
> Matthew Wilcox wrote:
> > Or we could make the host_no a u64 and avoid the problem ever happening
> > in our lifetimes.  I'm amazed that anyone's had the time to do 4 billion
> > add/removes, to be honest.  Assuming it takes 1 second per add/remove
> > cycle, and there's not even time to scan a bus in that time, that's
> > still 136 years.
> 
> That was my thought as well, until I checked struct scsi_host and saw
> that hostno is actually defined as a short there, which makes the problem
> slightly easier to hit. So, we could just increase both of them to u64's
> and be done with it...

Oh, right.

It's an unsigned short, between two ints, so there's no additional space
consumed by making it an unsigned int.  An experienced hacker also notes
the 'SCSI_IOCTL_GET_IDLUN' comment, researches it, and finds out you
only get the bottom 8 bits of host_no anyway.

----

[PATCH] Make host_no an unsigned int

Daniel Debonzi reports that he has managed to wrap host_no.  Increasing
the number of host numbers available to 32-bit from 16-bit allows the
problem to be evaded for another hundred years.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 1834fdf..062161d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -547,7 +547,7 @@ struct Scsi_Host {
 	unsigned int host_failed;	   /* commands that failed. */
 	unsigned int host_eh_scheduled;    /* EH scheduled without command */
     
-	unsigned short host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
+	unsigned int host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
 	int resetting; /* if set, it means that last_reset is a valid value */
 	unsigned long last_reset;
 

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
