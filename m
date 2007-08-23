From: Daniel Jabbour <djabbour@intronis.com>
Subject: Perc5i / MegaRaid / Linux SCSI subsystem issue
Date: Thu, 23 Aug 2007 10:18:51 -0400
Message-ID: <A38398DA74F72E4E90C146D53421216E5032633F@e2k7.intronis.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail4.intronis.com ([209.123.170.85]:33733 "EHLO
	mail4.intronis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758245AbXHWO30 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Aug 2007 10:29:26 -0400
Received: from e2k7.intronis.local (mail.intronis.com [208.125.3.10])
	by mail4.intronis.com (8.13.1/8.13.1) with ESMTP id l7NEJwdw019077
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 23 Aug 2007 10:19:59 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi,

I've recently acquired some Dell PowerEdge 2950 servers with integrated Perc 5i controllers (which use the MegaRaid driver).  I loaded Fedora Core 6 on them fine, did a yum update and much to my surprise the box kernel panics on boot.  I haven't loaded anything else on the box other than a stock OS.

I did some investigation and determined the issue only occurs with the latest (2.6.22.1-32) kernel in FC6.  It did not occur with 2.6.20 or 2.6.18.  It seems that the driver for the Perc 5i controller (megaraid_sas) is seeing through the BIOS of the controller and showing all 6 disks rather than one logical volume in the startup messages (I'm seeing SD 0-5).  Since the volume is actually RAID 10, it cannot mount the root filesystem.

This problem seem very similar to one detailed in an older kernel on the Ubuntu bug tracker:
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/55138

I also noticed that the bug has a patch applied in Ubuntu:
https://launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/57265


I have done some further diagnosis:

- I loaded the kernel.org sources for 2.6.22.1, with no luck, same issue.

- I downloaded the megaraid drivers from Dell and tried installing them for 2.6.22.1.  It prompted me that the drivers were older than the ones in 2.6.22, I forced it to install, rebuilt the initrd, and the same issue continues.  This leads me to believe that the issue might not be with the megaraid driver, but with something else in the kernel scsi subsystem, but I'm no kernel hacker.

What steps need to be taken to get this resolved?  I tried involving Dell, and have an open case with them, but since 2.6.22 isn't in RHEL yet, they say they have no escalation path and can't help.  Any suggestions from the list?  Thanks,

--
Daniel Jabbour
Network / Sytems Engineer
Intronis Technologies
Direct: (800) 569-0155 x242
Email: djabbour@intronis.com
www.intronis.com


