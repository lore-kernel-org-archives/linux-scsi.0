From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9010] SCSI device is not offlined properly and tries to cache data from previous device
Date: Fri, 21 Mar 2008 07:30:46 -0700 (PDT)
Message-ID: <20080321143046.33EBB10803F@picon.linux-foundation.org>
References: <bug-9010-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbYCUOas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 10:30:48 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2LEUlQF029356
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2008 07:30:48 -0700
In-Reply-To: <bug-9010-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9010





------- Comment #27 from anonymous@kernel-bugs.osdl.org  2008-03-21 07:30 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Fri, 2008-03-21 at 06:35 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9010
> 
> 
> 
> 
> 
> ------- Comment #26 from lkmlist@gmail.com  2008-03-21 06:35 -------
> To make it short:
> 
> Attach drive for the first time: --> sdb1
> The disk works, I can access it.
> 
> When I remove it is removed... somehow... but It looks like there is a ghost
> disk added (still with the kernelname sdb1) but not accessible (of couse.. I
> hold the disk in my hand...).
> 
> replugging the same device doesn't fix the problem and does not work.
> 
> here's a short version of the above dmsg:
[...]

All of this seems to show a hotplug failure in libata.  The SCSI
mid-layer handles this reasonably well (there are problems with
unplugging and replugging a device very rapidly).  All of our hotplug
busses (SAS, FC, iSCSI) work just fine.  For the non-hotplug busses like
SPI, you have to tell the kernel you've removed the disk manually, but
otherwise even that works.

This seems to be the place where the trouble is:


> Feb 17 16:30:47 freax [ 4315.384346] ata2.00: device is on DMA blacklist,
> disabling DMA
> Feb 17 16:30:47 freax [ 4315.384425] ata2.00: configured for PIO4
> Feb 17 16:30:47 freax [ 4315.384430] ata2: EH complete
> Feb 17 16:30:47 freax [ 4315.384437] sd 1:0:0:0: [sdb] Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE,SUGGEST_OK
> Feb 17 16:30:47 freax [ 4315.384440] sd 1:0:0:0: [sdb] Sense Key : Aborted
> Command [current] [descriptor]
> Feb 17 16:30:47 freax [ 4315.384456] sd 1:0:0:0: [sdb] Add. Sense: No
> additional sense information
> Feb 17 16:30:47 freax [ 4315.384469] sd 1:0:0:0: [sdb] Stopping disk

This last message is from sd just before it tries to do the final put of
the device.  This is the tricky one, it's a special path only used by
libata (which sets the manage_start_stop flag).  After finishing this,
the device should be dead and gone.

> Feb 17 16:30:47 freax [ 4315.384614] scsi 1:0:0:0: Direct-Access     ATA     
> Config  Disk     RGL1 PQ: 0 ANSI: 5
> Feb 17 16:30:47 freax [ 4315.384699] sd 1:0:0:0: [sdb] 640 512-byte hardware
> sectors (0 MB)
> Feb 17 16:30:47 freax [ 4315.384710] sd 1:0:0:0: [sdb] Write Protect is off
> Feb 17 16:30:47 freax [ 4315.384712] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Feb 17 16:30:47 freax [ 4315.384731] sd 1:0:0:0: [sdb] Write cache: disabled,
> read cache: enabled, doesn't support DPO or FUA
> Feb 17 16:30:47 freax [ 4315.384796] sd 1:0:0:0: [sdb] 640 512-byte hardware
> sectors (0 MB)
> Feb 17 16:30:47 freax [ 4315.384816] sd 1:0:0:0: [sdb] Write Protect is off
> Feb 17 16:30:47 freax [ 4315.384827] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Feb 17 16:30:47 freax [ 4315.384853] sd 1:0:0:0: [sdb] Write cache: disabled,
> read cache: enabled, doesn't support DPO or FUA
> Feb 17 16:30:47 freax [ 4315.384872]  sdb: unknown partition table
> Feb 17 16:30:47 freax [ 4315.385908] sd 1:0:0:0: [sdb] Attached SCSI disk
> Feb 17 16:30:47 freax [ 4315.385954] sd 1:0:0:0: Attached scsi generic sg1 type
> 0
> Feb 17 16:30:47 freax [ 4315.385988] sd 1:0:0:0: [sdb] 640 512-byte hardware
> sectors (0 MB)
> Feb 17 16:30:47 freax [ 4315.385999] sd 1:0:0:0: [sdb] Write Protect is off
> Feb 17 16:30:47 freax [ 4315.386001] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Feb 17 16:30:47 freax [ 4315.386020] sd 1:0:0:0: [sdb] Write cache: disabled,
> read cache: enabled, doesn't support DPO or FUA
> Feb 17 16:30:47 freax [ 4315.921044] ata2.00: exception Emask 0x10 SAct 0x0
> SErr 0x10000 action 0xa frozen

This is pretty bad ... SCSI has been told to readd the disk somehow, so
it has to do a rescan.  This must have come from some piece of
libata ... it's definitely using the cached data in libata to
manufacture the INQUIRY that makes SCSI think something is there.

Then your log actually repeats this sequence

> Feb 17 16:31:04 freax [ 4332.745067] Buffer I/O error on device sdb, logical
> block 79
> Feb 17 16:31:04 freax [ 4332.745074] ata2.00: detaching (SCSI 1:0:0:0)
> Feb 17 16:31:04 freax [ 4332.745342] sd 1:0:0:0: [sdb] Stopping disk
> Feb 17 16:31:04 freax [ 4332.745690] scsi 1:0:0:0: Direct-Access     ATA     
> Config  Disk     RGL1 PQ: 0 ANSI: 5
> Feb 17 16:31:04 freax [ 4332.745768] sd 1:0:0:0: [sdb] 640 512-byte hardware
> sectors (0 MB)
> Feb 17 16:31:04 freax [ 4332.745779] sd 1:0:0:0: [sdb] Write Protect is off
> Feb 17 16:31:04 freax [ 4332.745781] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Feb 17 16:31:04 freax [ 4332.745800] sd 1:0:0:0: [sdb] Write cache: disabled,
> read cache: enabled, doesn't support DPO or FUA
> Feb 17 16:31:04 freax [ 4332.745845] sd 1:0:0:0: [sdb] 640 512-byte hardware
> sectors (0 MB)
> Feb 17 16:31:04 freax [ 4332.745855] sd 1:0:0:0: [sdb] Write Protect is off
> Feb 17 16:31:04 freax [ 4332.745857] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Feb 17 16:31:04 freax [ 4332.745875] sd 1:0:0:0: [sdb] Write cache: disabled,
> read cache: enabled, doesn't support DPO or FUA
> Feb 17 16:31:04 freax [ 4332.745878]  sdb: unknown partition table
> Feb 17 16:31:04 freax [ 4332.745959] sd 1:0:0:0: [sdb] Attached SCSI disk
> Feb 17 16:31:04 freax [ 4332.745998] sd 1:0:0:0: Attached scsi generic sg1 type

So, the bottom line is that hotplug does work in SCSI (I can even
demonstrate it with SATA as long as I use a SAS controller), so this
does look to be a libata issue.  The complicating factor is that libata
does have special shutdown paths in SCSI ... they don't look like they
could be causing this, but it's not impossible.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
