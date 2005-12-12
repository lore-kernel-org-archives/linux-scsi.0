From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Read-only paranoia during data recovery
Date: Mon, 12 Dec 2005 11:49:26 +1000
Message-ID: <439CD726.7000100@torque.net>
References: <9A6F28681255C988725DE82A@[10.0.0.14]>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:58589 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751029AbVLLBsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Dec 2005 20:48:02 -0500
In-Reply-To: <9A6F28681255C988725DE82A@[10.0.0.14]>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kenneth Porter <shiva@sewingwitch.com>
Cc: linux-scsi@vger.kernel.org

Kenneth Porter wrote:
> I have a friend who needs to recover some data from a SCSI drive from a
> SCO system, and he wants to make sure nothing writes to the drive if he
> mounts it on his Linux system. I just want to verify that mounting it
> read-only is sufficient and won't attempt to write anything to it. (I
> recall in the old days when HD's had a write-protect jumper to protect
> it at the firmware level.) Are there other measures he should take?

Kenneth,
Many SCSI disks still have write protect jumpers, typically
on the same block that selects the SCSI id of the parallel
interface. From recent SCSI disk product manuals, I can see
that Maxtor supports the Software Write Protect (SWP) bit in
the control mode page.
A tool like sdparm could be used to set SWP:
 # sdparm --set=SWP --save /dev/sda
You need to be careful that the system you do this on
(or the following dd suggestion) does not automount file
systems.

To be safe, you could copy the contents of the SCSI disk
to the same size or larger disk (ATA or SCSI).
Something like:
 # dd if=/dev/sda of=/dev/hdb bs=512
where /dev/sda is your reference disk and /dev/hdb has nothing
important on it and is the same size or larger than /dev/sda **
Then power down the system, remove /dev/sda, power up and
try and mount the SCO partition on /dev/hdb . After getting
the data from /dev/hdb you may need to use fdisk to repartition
it (so that its extra size is not wasted).


** Using a command like 'fdisk -ul', is one way of checking
   that a disk has been copied. Keeping the first 63 sectors
   of the original /dev/hdb may also be prudent:
   "dd if=/dev/hdb of=hdb_0_62.img bs=512 count=63"

Doug Gilbert
