From: Brian Auld <bauld@lefthandnetworks.com>
Subject: Question about the use of PERSISTENT RESERVATION IN/OUT
Date: Thu, 01 Apr 2004 14:06:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <406C8467.5090903@lefthandnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lefthandnetworks.com ([207.174.0.250]:44683 "EHLO
	mail.lefthandnetworks.com") by vger.kernel.org with ESMTP
	id S263169AbUDAVHl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 16:07:41 -0500
Received: from lefthandnetworks.com (unknown [10.0.11.117])
	by mail.lefthandnetworks.com (Postfix) with ESMTP id 29ABF37E59
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2004 14:07:52 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Sorry for the initial staggered email.

I was able to acquire some level of understanding of the use of "persistent
reservation in/out" commands after having read some SCSI specs and browsing
this mailing list's archives. I have made some presumptions and wanted 
to run
them by this list to make sure I wasn't too far out in left field.


I'm designing a linux-based application that is going to use LUNs for 
storage
from a backend FC SAN. It's not very sexy, but there is a one to one
relationship for i) boxes running my appl and ii) LUNs. One of the 
requirements
that has been imposed on the appl is that once a given backend LUN has been
assigned to my application, any other physical entity (i.e. a different
initiator on a different box, which could be running my appl) is to be
prevented from accessing this LUN using some kind of protection mechanism.


Once a LUN is assigned to a specific box running my appl, this protection
should exist until I explicitly deassign this LUN in my user interface. In
other words, the protection should persist across host reboots and target
reset/reboots.


I have made the following assumptions and decisions about how this will be
handled:


1) As I understand it, there is no reserve/release (persistent or old)
mechanism in the scsi subsystem itself.


2) WRT (1), there are however 2 mechanisms for sending pass-through commands
through the scsi subsystem directly to a target device: namely, (i) using an
sg device or (ii) sd ioctls.


3) What I would like to do is setup my application so the following 
occurs when
a LUN is assigned/deassigned to my appl:


assigned:
-------------
In my appl, send an appropriate combination of PERSISTENT RESERVE 
OUT(service
action: reserve ...) commands to effectivly lock this device so that any
initiator not included in the list I provide will be prevented from 
accessing
my LUN. I would use the sg mechanism or sd ioctls to do this.


deassigned:
---------------
In my appl, send an appropriate combination of PERSISTENT RESERVE OUT 
(service
action: release) commands to free up this LUN. Again, I would use sd ioctls
or the sg mechanism to do this.


Is this basic approach flawed? It would seem to be doable based on what 
I have
read so far, but I don't know for sure.


Any feedback would be appreciated.


Thanks,
Brian


