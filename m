From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: SuSE hwinfo/yast2 still confusing SYM53C8XX, killing tape backups (was: [BK PATCH] SCSI -rc1 fixes)
Date: Mon, 15 Nov 2004 02:09:09 +0100
Message-ID: <m34qjrx6iy.fsf_-_@merlin.emma.line.org>
References: <1100467267.23710.7.camel@mulgrave> <4197E4B7.3050008@pobox.com>
	<1100473795.23649.26.camel@mulgrave>
	<m3hdnsvvfd.fsf@merlin.emma.line.org>
	<1100477105.24921.3.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:49381 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261400AbUKOBJO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 20:09:14 -0500
In-Reply-To: <1100477105.24921.3.camel@mulgrave> (James Bottomley's message of
	"14 Nov 2004 18:04:58 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: snwint@suse.de
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> writes:

> Well, I think we're stuck on that one.  SUSE doesn't seem willing to
> debug hwscan enough to give a coherent description of the problem or a
> non hwscan test case and no-one else wants to take hwscan apart to find
> out exactly what it is doing.

I'm CC:ing Steffen Winterfeldt of hwinfo fame, in the hopes that he
might know his child is doing (if not, he might want to look), and I've
taken linux-kernel from the Cc: list.

He's listed as author and packager of this insufficiently documented
piece of s...ymbios adaptor confusion.  

Steffen, SuSE's hwinfo package throws parity errors on SYM53C8xx
hardware.  Same issue with all kernels SuSE shipped for 9.1 including
the current 2.6.5-7.111 kernel as well as vanilla 2.6.9.
hwinfo-8.62-0.2. hotplugctl-0.08-256 - yet another undocumented piece of
who-knows-what-its-good-for.

Common trouble introduced by running yast2 or hwinfo is SCSI parity
error, phase mismatch, bus reset and sometimes the machine going out to
lunch for 2 minutes. It is unclear whether hwinfo probes the hardware
directly, confusing the sym53c8xx, or uses some SCSI ioctl that confuses
the adaptor. Please help finding _this_ out and if it's hwinfo hacking
PCI registers directly, don't do that on ncr/sym/lsi53c8xx and 53c1010
chips.

Some hotplug event on SuSE 9.1 is apparently sufficient to throw the
whole backup over - Tandberg SLR2 and SLR4 drives, although rock solid
otherwise, strongly dislike bus resets, request sense and the st driver
propagates an error. Amanda doesn't like that and aborts the dump...

The logs below look as though inserting the floppy driver caused my tape
backup to go failing THIS TIME. Running yast2 while a backup is running
is fatal for the backup, this isn't related to the floppy driver.

I will help debug this if needed, but need directions.  If you need some
hardware, get a Tekram DC-390U or DC-390F or DC-310U and some devices
that make some noise after a bus reset.

Tandberg SLR6/SLR24 make a horrible noise as part of their reset self
test %-)

Log excerpt below, I stripped the timestamps, everything happens within
7 seconds, Vanilla 2.6.9 kernel. Blank lines inserted to make the
interesting parts stand out.

...
kernel: sr0: scsi-1 drive
kernel: Attached scsi CD-ROM sr0 at scsi0, channel 0, id 2, lun 0
kernel: inserting floppy driver for 2.6.9
kernel: Floppy drive(s): fd0 is 1.44M
kernel: FDC 0 is a post-1991 82077

/sbin/hotplug[23123]: add block
/sbin/hotplug[23129]: add block
/sbin/hotplug[23130]: add platform
/sbin/hotplug[23123]: LOGPID=23123 OLDPWD=/ DEVPATH=/block/sr0 PATH=/sbin:/usr/sbin:/bin:/usr/bin ACTION=add PWD=/etc/hotplug SHLVL=1 HOME=/ SEQNUM=516 _=/usr/bin/env
/sbin/hotplug[23129]: LOGPID=23129 OLDPWD=/ DEVPATH=/block/fd0 PATH=/sbin:/usr/sbin:/bin:/usr/bin ACTION=add PWD=/etc/hotplug SHLVL=1 HOME=/ SEQNUM=517 _=/usr/bin/env
/sbin/hotplug[23130]: LOGPID=23130 OLDPWD=/ DEVPATH=/devices/platform/floppy0 PATH=/sbin:/usr/sbin:/bin:/usr/bin ACTION=add PWD=/etc/hotplug SHLVL=1 HOME=/ SEQNUM=518 _=/usr/bin/env
/etc/hotplug/block.agent[23129]: try 1 while waiting for /block/fd0's bus_id 
/etc/hotplug/block.agent[23123]: 0:0:2:0: page 0 not available.
/etc/hotplug/block.agent[23123]: line P: /block/sr0
/etc/hotplug/block.agent[23123]: line N: sr0
/etc/hotplug/block.agent[23123]: ncookie sr0
/etc/hotplug/block.agent[23123]: line M: 0640
/etc/hotplug/block.agent[23123]: line S: by-path/pci-0000:00:0d.0-scsi-0:0:2:0
/etc/hotplug/block.agent[23123]: scookie by-path/pci-0000:00:0d.0-scsi-0:0:2:0
/etc/hotplug/block.agent[23123]: line O: root
/etc/hotplug/block.agent[23123]: line G: disk
/etc/hotplug/block.agent[23123]: line
/etc/hotplug/block.agent[23123]: new block device /block/sr0
/etc/hotplug/block.agent[23129]: try 2 while waiting for /block/fd0's bus_id 
/etc/hotplug/block.agent[23129]: try 3 while waiting for /block/fd0's bus_id 
/etc/hotplug/block.agent[23129]: try 4 while waiting for /block/fd0's bus_id 

kernel: sym0: SCSI parity error detected: SCR1=3 DBC=50000000 SBCL=0
kernel: sym0: SCSI phase error fixup: CCB already dequeued.
kernel: sym0: SCSI BUS reset detected.
kernel: sym0: SCSI BUS has been reset.
kernel: st0: Error 80000 (sugg. bt 0x0, driver bt 0x0, host bt 0x8).

/etc/hotplug/block.agent[23129]: try 5 while waiting for /block/fd0's bus_id 
/etc/hotplug/block.agent[23129]: line P: /block/fd0
/etc/hotplug/block.agent[23129]: line N: fd0
/etc/hotplug/block.agent[23129]: ncookie fd0
/etc/hotplug/block.agent[23129]: line M: 0660
/etc/hotplug/block.agent[23129]: line S:
/etc/hotplug/block.agent[23129]: line O: root
/etc/hotplug/block.agent[23129]: line G: disk
/etc/hotplug/block.agent[23129]: line
/etc/hotplug/block.agent[23129]: new block device /block/fd0
/sbin/hotplug[23130]: no runnable /etc/hotplug/platform.agent is installed
kernel: program hwscan is using a deprecated SCSI ioctl, please convert it to SG_IO
/sbin/hotplug[23234]: add scsi_generic
/sbin/hotplug[23234]: LOGPID=23234 OLDPWD=/ DEVPATH=/class/scsi_generic/sg0 PATH=/sbin:/usr/sbin:/bin:/usr/bin ACTION=add PWD=/etc/hotplug SHLVL=1 HOME=/ SEQNUM=519 _=/usr/bin/env
kernel: Attached scsi generic sg0 at scsi0, channel 0, id 1, lun 0,  type 0
/sbin/hotplug[23243]: add scsi_generic
kernel: Attached scsi generic sg1 at scsi0, channel 0, id 2, lun 0,  type 5
/sbin/hotplug[23251]: add scsi_generic
/sbin/hotplug[23251]: LOGPID=23251 OLDPWD=/ DEVPATH=/class/scsi_generic/sg2 PATH=/sbin:/usr/sbin:/bin:/usr/bin ACTION=add PWD=/etc/hotplug SHLVL=1 HOME=/ SEQNUM=521 _=/usr/bin/env
kernel: Attached scsi generic sg2 at scsi0, channel 0, id 6, lun 0,  type 1
/sbin/hotplug[23260]: add scsi_generic
/sbin/hotplug[23260]: LOGPID=23260 OLDPWD=/ DEVPATH=/class/scsi_generic/sg3 PATH=/sbin:/usr/sbin:/bin:/usr/bin ACTION=add PWD=/etc/hotplug SHLVL=1 HOME=/ SEQNUM=522 _=/usr/bin/env

kernel: st0: Error with sense data: Current st0: sense key Unit Attention
kernel: Additional sense: Power on, reset, or bus device reset occurred
kernel: st0: Error on write filemark.

Boom, it's dead.

-- 
Matthias Andree
