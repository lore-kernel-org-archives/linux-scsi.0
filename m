From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 7246] 3w-xxxx, IOMMU and >1go RAM
Date: Mon, 25 Feb 2008 01:34:24 -0800 (PST)
Message-ID: <20080225093425.03433108017@picon.linux-foundation.org>
References: <bug-7246-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:45679 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbYBYJe7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2008 04:34:59 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [207.189.120.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m1P9YPDT013342
	for <linux-scsi@vger.kernel.org>; Mon, 25 Feb 2008 01:34:26 -0800
In-Reply-To: <bug-7246-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=7246


mailinglists.javier@gmail.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |mailinglists.javier@gmail.co
                   |                            |m




------- Comment #12 from mailinglists.javier@gmail.com  2008-02-25 01:34 -------
(In reply to comment #11)
> If there is no more problems then it looks like the bug can be closed now.
> Thanks.
> 

The bug still exists as you can see in the following bug report on debian:

"linux-2.6.18-6-amd64: 3w-xxxx v1.26.02.001 causes datacorruption with
AMD64/EM64T with >2GB RAM"
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=464923

The problem is with the driver included in the kernel. More information on
http://www.3ware.com/KB/article.aspx?id=15243

I'll quote the first post of the bug report, it includes very relevant/useful
information:

"
Package: linux-2.6.18-6-amd64
Severity: critical
Tags: patch
Justification: causes serious data loss


How to reproduce:

10036:/tmp# uname -a
Linux 10036 2.6.18-6-amd64 #1 SMP Wed Jan 23 06:27:23 UTC 2008 x86_64 GNU/Linux
10036:/tmp# grep MemTotal /proc/meminfo
MemTotal:      8179992 kB
10036:/tmp# dd if=/dev/urandom bs=1048576 count=10240 | tee testfile | md5sum
00a513dc3da637c4c86557102b0e6098  -
10239+1 records in
10239+1 records out
10737297534 bytes (11 GB) copied, 1584.6 seconds, 6.8 MB/s
10036:/tmp# md5sum testfile
bfceb91a358dfc3d09e22ad74b7ebefb  testfile
10036:/tmp#

How to fix:
There is a 3ware KB article on this:
http://www.3ware.com/KB/article.aspx?id=15243

This includes "3ware Storage Controller device driver for Linux
v1.26.03.000-2.6.18."
>From the driver:

        1.26.03.000 - Use default DMA data direction to prevent data corruption
                 when using SWIOTLB with 4GB+ on EM64T.

Installing this fixes the problem for me.


-- System Information:
Debian Release: 4.0
  APT prefers stable
  APT policy: (500, 'stable')
Architecture: i386 (i686)
Shell:  /bin/sh linked to /bin/bash
Kernel: Linux 2.6.18-4-vserver-k7
Locale: LANG=C, LC_CTYPE=C (charmap=ANSI_X3.4-1968)
"

My server installation is also suffering from this bug (datacorruption):

Debian Release: 4.0 (stable)
Architecture: amd64 (64bits)
Kernel: 2.6.18-5-amd64
RAM: 4GB
RAID Controller: 3w-8500 series
Processor: Intel Xeon - EMT64

As I've stated before, the problem resides in the driver included in the
kernel, so it's just a matter of replacing it as a patch in the kernel.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
