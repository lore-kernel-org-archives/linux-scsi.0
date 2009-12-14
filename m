From: "Caspar Smit" <c.smit@truebit.nl>
Subject: Problem with disks shutting down at random
Date: Mon, 14 Dec 2009 11:07:06 +0100 (CET)
Message-ID: <26198.87.210.74.220.1260785226.squirrel@ketsers.dhs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:44789 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855AbZLNKOg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2009 05:14:36 -0500
Received: from ns1.emsolutions.nl (www-data@localhost.localdomain [127.0.0.1])
	by ns1.emsolutions.nl (8.13.8/8.13.8/Debian-3) with ESMTP id nBEA768v014545
	for <linux-scsi@vger.kernel.org>; Mon, 14 Dec 2009 11:07:06 +0100
References: 
In-Reply-To: 
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



Hi,

I already posted this on the linux-ide mailinglist but that
didn't end up with a solution and/or cause to this problem.

I'm
having a problem where a harddisk (not always the same) randomly shuts
down and is disconnected from the linux kernel. In other words I have to
reboot the system or physically unplug/replug the disk to get it to work
again. As stated this will happen to different disk at different times.

I will provide my configuration:

SuperMicro
SC-216
chassis (24 bay 2,5" disks)
24x Seagate ST9500420AS 500Gb
7200 RPM Hard Drives
3x SuperMicro AOC-SAT2-MV8 (SATA Controller
using the sata_mv kernel driver)

I use Debian Lenny 5.0
and
kernel: linux-image-2.6.30-bpo.2-amd64
(2.6.30-8~bpo50+1)
from the
backports repository.

The symptom is that after a
while of
operation a disk is shut down and kicked out of a RAID set.
It doesn't matter if there is load or not on the system.

The
logging
says:

sd 11:0:0:0: [sdk] Unhandled error code
sd 11:0:0:0:
Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
sd 11:0:0:0:
end_request: I/O error, dev
sdk, sector 0 

In this case sdk,
but it happens to all
disks.
Then the disk is not readable by the
system anymore.

When I check the disk for errors
(badblocks/smart) in another
system it doesn't give any errors.
I
only have this with
2,5" systems.

Is this a sata_mv
problem? A disk
problem? or anything else?
I can provide more info if
needed.

>From the kern.log:
Saeed Bishara replied to my kern.log with
the following.

the following lines from the kern.log:
Nov 24 23:03:23
supernas02 kernel: [131523.808631] ata19.00: exception
Emask 0x0 SAct
0x0 SErr 0x0 action 0x6 frozen
Nov 24 23:03:23 supernas02 kernel:
[131523.808690] ata19.00: cmd
b0/da:00:00:4f:c2/00:00:00:00:00/00 tag
0
Nov 24 23:03:23 supernas02 kernel: [131523.808691]          res
40/00:01:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
Nov 24
23:03:23 supernas02 kernel: [131523.808770] ata19.00: status: { DRDY }
Nov 24 23:03:23 supernas02 kernel: [131523.808801] ata19: hard resetting
link
Nov 24 23:03:28 supernas02 kernel: [131529.324010] ata19: link
is slow
to respond, please be patient (ready=0)
Nov 24 23:03:33
supernas02 kernel: [131533.860010] ata19: SRST failed
(errno=-16)
Nov 24 23:03:33 supernas02 kernel: [131533.860038] ata19: hard resetting
link
Nov 24 23:03:38 supernas02 kernel: [131539.376009] ata19: link
is slow
to respond, please be patient (ready=0)
Nov 24 23:03:43
supernas02 kernel: [131543.912006] ata19: SRST failed
(errno=-16)
Nov 24 23:03:43 supernas02 kernel: [131543.912033] ata19: hard resetting
link
Nov 24 23:03:48 supernas02 kernel: [131549.428010] ata19: link
is slow
to respond, please be patient (ready=0)
Nov 24 23:04:18
supernas02 kernel: [131578.940012] ata19: SRST failed
(errno=-16)
Nov 24 23:04:18 supernas02 kernel: [131578.940048] ata19: limiting
SATA link speed to 1.5 Gbps
Nov 24 23:04:18 supernas02 kernel:
[131578.940077] ata19: hard resetting link
Nov 24 23:04:23 supernas02
kernel: [131583.952009] ata19: SRST failed
(errno=-16)
Nov 24
23:04:23 supernas02 kernel: [131583.958191] ata19: reset
failed,
giving up
Nov 24 23:04:23 supernas02 kernel: [131583.958218]
ata19.00: disabled
Nov 24 23:04:23 supernas02 kernel: [131583.958253]
ata19: EH complete

means that a timeout error occurred, the
after then, the disk didn't respond.
is it the same disks that fails
all the time?
---
As I said it doesn't happen to the same
disk.

Anyone knows where to look for a cause for this problem?

Kind
regards,
Caspar Smit





