From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 5819] New: aic7xxx with tape drive connected
Date: Tue, 3 Jan 2006 14:06:21 -0800
Message-ID: <20060103140621.3ad2d632.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:8862 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932513AbWACWGj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 17:06:39 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k03M6ZDZ028445
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jan 2006 14:06:35 -0800
Received: from bix (shell0.pdx.osdl.net [10.9.0.31])
	by shell0.pdx.osdl.net (8.13.1/8.11.6) with SMTP id k03M6W1o026280
	for <linux-scsi@vger.kernel.org>; Tue, 3 Jan 2006 14:06:33 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Begin forwarded message:

Date: Tue, 3 Jan 2006 06:58:30 -0800
From: bugme-daemon@bugzilla.kernel.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 5819] New: aic7xxx with tape drive connected


http://bugzilla.kernel.org/show_bug.cgi?id=5819

           Summary: aic7xxx with tape drive connected
    Kernel Version: 2.6.13.x, 2.6.14.x
            Status: NEW
          Severity: blocking
             Owner: andmike@us.ibm.com
         Submitter: freelsjd@ornl.gov


Most recent kernel where this bug did not occur: 2.6.12.6
Distribution: Debian/Sarge
Hardware Environment: AMD64, Intel Xeon, both SMP (2 processors)
Software Environment: AMANDA tape backup
Problem Description:

This problem is similar to, if not identical to, bug #5268 of the kernel bug 
tracker.

If using the aic7xxx driver on a dual-processor amd64 system and the Debian/
Sarge distribution, the AMANDA tape backup problem will hang the system 
completely on all stable kernels greater than 2.6.12.6 I have tried.  The last 
kernel I have tried is 2.6.14.5.  If I use the 2.6.12.6 kernel (similar to bug #
5268 workaround), the problem will not occur.  On the amd64 system, the tape 
drive is the only scsi device on the scsi bus; however the scsi-sata interface 
is enabled due to the sata drives on this system.  See bug report #5268 for the 
Intel-Xeon setup which is similar.

Steps to reproduce:

Compile kernel > 2.6.12.6 with the aic7xxx driver enabled. Note:  I have also 
tried the aic7xxx_old driver and it also has this problem (at least on 2.6.14.5 
kernel).

Run a routine AMANDA backup with a reasonably large data set.  I typically 
backup 40 GB per day.  The error will occur with about 1 GB of data or more.

The system will indicate many scsi errors to the console and log files.  Many 
appear to originate from the "taper" module of AMANDA which does the writing of 
data to the tape drive.  Tape drive writes have to occur to uncover this bug.  
Note also the "st" fix from 2.6.14.4 to 2.6.14.5 did not correct this problem !

The only solution is to reset the system.  If I avoid tape writes, this hang 
never occurs.  However, I cannot do that as one of the primary missions of this 
machine is to perform system backups of several machines.

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
