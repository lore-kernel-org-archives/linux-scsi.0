From: Brad Parker <brad@heeltoe.com>
Subject: usb flash disks w/o partition tables + 2.4 kernel can hang
Date: Wed, 31 Aug 2005 08:16:26 -0400
Message-ID: <200508311216.j7VCGRNa023345@mwave.heeltoe.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.heeltoe.com ([66.134.219.32]:46194 "HELO
	gateway.heeltoe.com") by vger.kernel.org with SMTP id S932506AbVHaMQ2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Aug 2005 08:16:28 -0400
Received: from mwave.heeltoe.com (localhost.localdomain [127.0.0.1])
	by mwave.heeltoe.com (8.12.11/8.12.11) with ESMTP id j7VCGRtd023349
	for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2005 08:16:27 -0400
Received: from mwave (brad@localhost)
	by mwave.heeltoe.com (8.12.11/8.12.11/Submit) with ESMTP id j7VCGRNa023345
	for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2005 08:16:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'm not on this list but I thought someone here might be interested.
(please cc me if you respond)

I was tracking down a problem where some USB flash disks could not be
used with a 2.4.21 kernel.  Apparently lots of "READ CAPACITY failed"
messages are generated.

It turns out the problem was caused by USB flash disks which have no
partition table.  The have a valid FAT-16 file system starting at block
zero (0).

If the disk is inserted and the "partition 1" block device
(/dev/discs/disc0/part1) is read, the disk will 'hang' after a read and
not respond.  Subsequent accesses get "READ CAPACITY failed" messages
and the disk will get into a state where TEST_UNIT_READY will always
return "not ready".

I think I have a trace where I can dig out the actual SCSI read command
and see what block number it's asking form.  I suspect it's some
gigantic number.

I'm guessing the invalid parition map caused the scsi code to ask the
disk to read off into space and the disk went south. (technical
description :-)

Note that if the 'raw' partition (/dev/discs/disc0/disc) is used, all is well.

I realize it's hard/impossible to validate the partition map.  In this
case it has the correct '55 aa' signature.  But none of the partition
'types' are valid and most are zero.

I'm a little suprised that reading from */part1 worked at all, but
perhaps it just the perils of using an ms-dos parition map...

I'm also suprised a bad partition map could generate a read which would
'crash' the disk, so to speak.  I may dig into it a little further.  I
believe the traces I have showed the original READ CAPACITY worked, so
the scsi code should know how big the drive actually is.

-brad
