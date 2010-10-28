From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13602] some HFS CD-ROM's can't be read
Date: Thu, 28 Oct 2010 16:40:35 GMT
Message-ID: <201010281640.o9SGeZ4d018797@demeter1.kernel.org>
References: <bug-13602-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58190 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759319Ab0J1Qkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 12:40:36 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o9SGeZ9B018799
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 16:40:35 GMT
In-Reply-To: <bug-13602-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=13602


Bill McGonigle <bill-osdl.org-bugzilla@bfccomputing.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
     Kernel Version|2.6.29.4-167.fc11.i586      |2.6.34.7-56.fc13.x86_64




--- Comment #5 from Bill McGonigle <bill-osdl.org-bugzilla@bfccomputing.com>  2010-10-28 16:40:30 ---
@Christoph: good workaround.  I can losetup my /dev/sr0 and mount the discs
(tested 1 anyway).  I need to omit the session=1 option on the loopback but it
does mount that way.  Just to be sure, I confirmed sr0 won't mount without the
session option.  Not sure what would happen if the data were on session=2.

For the HFS vs. SCSI question, I'm not clear why 22 out of 25 discs in this set
work OK but the remaining 3 would not.  They're factory-stamped discs, no idea
how they were mastered.

The only dmesg I get is:

 hfs: unable to set blocksize to 512
 hfs: can't find a HFS filesystem on dev sr0.

This is now kernel 2.6.34.7-56.fc13.x86_64.

Not sure if it's helpful, but here are the /sys sizes:

[bfccomputing@zpm sr0]$ more `pwd`/queue/*size
::::::::::::::
/sys/block/sr0/queue/hw_sector_size
::::::::::::::
2048
::::::::::::::
/sys/block/sr0/queue/logical_block_size
::::::::::::::
2048
::::::::::::::
/sys/block/sr0/queue/max_segment_size
::::::::::::::
65536
::::::::::::::
/sys/block/sr0/queue/minimum_io_size
::::::::::::::
2048
::::::::::::::
/sys/block/sr0/queue/optimal_io_size
::::::::::::::
0
::::::::::::::
/sys/block/sr0/queue/physical_block_size
::::::::::::::
2048

I can't even say this is a feature implemented in MacOSX for compatibility that
linux lacks - for all I know, they do some sort of loopback mount automagically
if certain kinds of discs are detected.

I don't know if there are any linux equivalents for doing something similar by
the kernel; one could imagine userland machinations that could do the right
thing, though perhaps costly.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
