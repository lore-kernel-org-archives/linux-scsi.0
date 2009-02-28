From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: Transport identifier
Date: Sat, 28 Feb 2009 10:54:02 -0500
Message-ID: <yq11vtieew5.fsf@sermon.lab.mkp.net>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
	<1235663301.19035.44.camel@localhost.localdomain>
	<yq1prh5ey7b.fsf@sermon.lab.mkp.net>
	<49A94FEB.6050400@s5r6.in-berlin.de>
	<20090228150633.GQ16891@parisc-linux.org>
	<49A95616.3070502@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:45480 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZB1PyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Feb 2009 10:54:20 -0500
In-Reply-To: <49A95616.3070502@s5r6.in-berlin.de> (Stefan Richter's message of "Sat\, 28 Feb 2009 16\:19\:50 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Stefan" == Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

Stefan> So, while it may be prudent to deduct "it's USB" -> "don't try
Stefan> READ CAPACITY 16", why not keep implementing this in way #2?

I predict our scanning will involve much more heuristics than it does
now.  In relatively near future we will have to start using a less
conservative approach to sending commands because 4KB drives and drives
with odd alignment require us to use READ CAPACITY(16).

The triggers at the device level which would help (protocol mode pages,
version descriptors) are generally not filled out.  Not even in brand
new enterprise drives.

For DIF I had the luxury of being able to trigger off the PROTECT bit in
INQUIRY.  And even that broke because some USB devices returned random
garbage causing DIF to be enabled by accident.

The other problem we are facing is that right now the reported version
kinda-sorta works but that may not continue to be the case.  There are
several drive vendors that deliberately return a much older version than
the command set actually supported by the drive.  This is to work around
problems in legacy proprietary operating systems.

Originally my plan was to key off of the presence of the block limits
VPD page and submit RC16 if that was present.  But the VPD is mostly
aimed at RAID vendors and I'm told that drive vendors are not going to
bother filling it out.

-- 
Martin K. Petersen	Oracle Linux Engineering
