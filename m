From: Andrew Morton <akpm@osdl.org>
Subject: Fw: [Bugme-new] [Bug 4268] New: SCSI performance regression in
 2.6.10
Date: Mon, 28 Feb 2005 23:11:41 -0800
Message-ID: <20050228231141.3ac7c145.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from fire.osdl.org ([65.172.181.4]:30669 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261277AbVCAHMD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 02:12:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: duraid@octopus.com.au


Did anything change in the mpt fusion driver?

I'm seeing the same thing, again with mpt-fusion.  38MB/sec when it should
be getting >60.


Begin forwarded message:

Date: Mon, 28 Feb 2005 22:03:57 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4268] New: SCSI performance regression in 2.6.10


http://bugme.osdl.org/show_bug.cgi?id=4268

           Summary: SCSI performance regression in 2.6.10
    Kernel Version: 2.6.10
            Status: NEW
          Severity: normal
             Owner: andmike@us.ibm.com
         Submitter: duraid@octopus.com.au


Distribution: Debian 'unstable', pristine 2.6.10 kernel
Hardware Environment: HP rx2600 (ia64), LSI 53C1030 U320 SCSI host (Fusion MPT)
Problem Description: There is a quite severe performance regression in 2.6.10
when using SCSI disk drives. (I've tested against 2.4.20, 2.6.8 and 2.6.9, none
of which exhibit this problem)

Steps to reproduce: dd if=/dev/sdXX of=/dev/null bs=1048576 count=10000
(streaming read the first 10GB of scsi disk XX)

In 2.6.10, with a Fujitsu 10Krpm SCSI disk I get 34MB/sec, with a Maxtor 15Krpm
SCSI disk I get 37MB/sec. CPU usage of 'dd' is ~2% and %system time is about the
same.

Using 2.6.9 (or earlier), I get 63MB/sec for the 10K disk and 95MB/sec for the
15K disk. CPU usage goes up in proportion. (OK, fair enough.)

This is a real performance issue (shows up everywhere, not just in 'dd'), and
affects both reads and writes. Does anyone know what's going on here?

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
