From: Bryan Henderson <hbryan@us.ibm.com>
Subject: RE: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 10:40:24 -0700
Message-ID: <OF5B21133C.F5A53509-ON8825705A.005F65D9-8825705A.00611764@us.ibm.com>
References: <1123776475.5062.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45546 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932310AbVHKRkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 13:40:24 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7BHeNwt010123
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 13:40:23 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7BHeNtc243650
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 13:40:23 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7BHeM6x009268
	for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2005 13:40:22 -0400
In-Reply-To: <1123776475.5062.22.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.orglinux-scsi, Harald Seipp <SEIPP@de.ibm.com>

>> The problem with pushing this policy to the user is that software
>> applications have no means to determine that a device is currently
>> in-use. For instance, the net result of pulling a device on a mounted
>> filesystem is an eventual kernel panic.
>
>The kernel only panics if you told it to with the mount option
>errors=panic (or if you have errors=panic set in the superblock flags).
>
>For file systems on removable devices ...

This is all valid argument for removable devices, but I don't think that's 
really what we're talking about here.  I think we're talking about a 
device that can't physically disappear, but can, unfortunately, logically 
disappear via remove-single-device.

For a fixed device, it is perfectly reasonable to design a system that 
assumes the device sticks around.  Any older system would definitely be 
designed that way.  Such a system, whether it technically panics or not, 
will probably utterly fail if the disk disappears.  It was accessing that 
disk for a reason.

Because removable devices exist, we do have to allow remove-single-device 
of an in-use device in general, but it would be good (and probably easy) 
to provide for the other case as well.  The code obviously knows that the 
device is in use, because /dev/sda doesn't get reused.  If there were a 
version of remove-single-device that said, "only if unused," that would 
solve the problem.  If there are synchronization issues that make that 
hard, then making it possible for the user to query that in-use state 
would still go a long way toward solving the problem.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Filesystems

