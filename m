From: Steve McIntyre <smcintyre@software.plasmon.com>
Subject: sg problems with an 8KB sector size and blank checks
Date: Fri, 11 Feb 2005 17:40:28 +0000
Message-ID: <20050211174028.GT6301@software.plasmon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail.software.plasmon.co.uk ([194.130.136.212]:32207 "EHLO
	mail.software.plasmon.com") by vger.kernel.org with ESMTP
	id S262044AbVBKRkq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 12:40:46 -0500
Received: from leo.devel.pcs ([10.4.2.17] ident=mail)
	by mail.software.plasmon.com with esmtp (Exim 3.35 #1 (Debian))
	id 1CzemL-0001iE-00
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2005 17:40:29 +0000
Received: from steve by leo.devel.pcs with local (Exim 3.36 #1 (Debian))
	id 1CzemK-0007Ev-00
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2005 17:40:28 +0000
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Guys, I hope somebody can help here. A little context:

At Plasmon we've developed a driver for our new UDO (Ultra Density
Optical) drive. It's a new blu-ray optical drive with an 8KB sector
size, which makes it rather awkward to support directly using sd in
the kernel. To solve that problem, we've written a userland driver
using FUSE to plug in to the VFS layer in kernel. We write to the
drive using sg, and generally things have gone well. As it's an
optical drive, the losses through context switching and multiple data
copies don't make a significant difference to the performance we
get. We're planning on supporting both RW and WORM media using our own
filesystems in userland.

Our target systems at this point are Fedora Core 1, 2 and 3. I've been
developing and testing reliably on FC2 without any major issue.
Recently we've started WORM testing on FC1, 2 and 3, and now we're
seeing problems.

1: Verbose blank check error reporting
--------------------------------------

The kernel complains a lot about SCSI blank check errors when reading
sectors. The filesystems know about blank checks, and are written to
cope with these errors appropriately - this is a common issue when
developing WORM filesystems. It would be nice to be able to disable
the warnings about blank checks, as the errors streaming up the
console are very disconcerting.

2: Verbose CONDITION MET reporting
----------------------------------

The other common way to write a WORM filesystem is to use Medium Scan
to find unwritten sectors before reading them. Unfortunately (as I've
just tested), the kernel then complains about the SCSI CONDITION MET
return from Medium Scan, e.g.:

Feb 11 16:58:26 trabant kernel: SCSI error : <1 0 2 0> return code=0x4

so I can't get away from errors being reported that way either.

3: Data overruns after blank checks on FC3
------------------------------------------

Lastly, on FC3 I've seen even worse problems with blank checks. After
a blank check error, I'd expect the transfer buffers to be filled with
the leading sectors that _could_ be read (i.e. up to the first blank
sector in the range requested), and the LBA of the first blank sector
should be reported in the sense data. Indeed, that's how things work
for me on FC2. In FC3, I'm seeing data overruns reported from the
kernel when this happens, and I'm getting no data back in userland:

Feb 11 12:04:19 trabant kernel: (scsi1:A:2:0): data overrun detected in Data-in phase.  Tag == 0x3.
Feb 11 12:04:19 trabant kernel: (scsi1:A:2:0): Have seen Data Phase. Length = 36864.  NumSGs = 3.
Feb 11 12:04:19 trabant kernel: sg[0] - Addr 0x0635b000 : Length 4096
Feb 11 12:04:19 trabant kernel: sg[1] - Addr 0x03800000 : Length 16384
Feb 11 12:04:19 trabant kernel: sg[2] - Addr 0x02680000 : Length 16384
Feb 11 12:04:19 trabant kernel: SCSI error : <1 0 2 0> return code = 0x8000002
Feb 11 12:04:19 trabant kernel: Info fld=0xa1, Current sda: sense key Blank Check

I'm not 100% sure, but it looks like there _might_ be a problem
transferring the 8KB sectors out in the error path for blank checks. I
could be wrong, of course - please don't get me wrong! I've written a
little workaround for this (if we get a blank check, re-read just the
sectors that were known to contain data), but of course I still get
the verbose error report as above in (1).

I understand that an 8KB sector size is awkward. I'm happy to dig into
the kernel code here and supply patches if necessary, but I'd like to
hear if anyone has any useful comments / suggestions first. Please?
Obviously, just ask if there's any more information I can provide.

Thanks,
-- 
Steve McIntyre, Plasmon                         smcintyre@software.plasmon.com

