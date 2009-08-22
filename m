From: Chris Webb <chris@arachsys.com>
Subject: Re: oops during scsi scanning disk setup
Date: Sat, 22 Aug 2009 12:55:35 +0100
Message-ID: <20090822115535.GB1976@arachsys.com>
References: <20090820180549.GD7542@arachsys.com> <1250807161.4302.167.camel@mulgrave.site> <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com> <20090821092326.GF32115@arachsys.com> <1250863216.3844.1.camel@mulgrave.site> <20090821145141.GR32115@arachsys.com> <1250869674.7363.89.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:36534 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbZHVLzh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2009 07:55:37 -0400
Content-Disposition: inline
In-Reply-To: <1250869674.7363.89.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> writes:

> Can you try this as a partial fix?  (It should prevent the oops, but
> you'll still lose the disk).

Hi James. Thanks for patch. I've applied this, although the context is quite
a bit different in the released 2.6.30.x from your patch against head. (E.g.
in sd_probe, there's no get_device(&sdp->sdev_gendev) at all before the
async_schedule(). Instead that happens in sd_probe_async.)

I'm now seeing a warning backtrace for every scsi attach in the machine,
including the main system hard drives, so I think something's not quite
right. For instance, in my test virtual machine:

  scsi0 : ata_piix
  scsi1 : ata_piix
  ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
  ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
  Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
  Copyright (c) 1999-2006 Intel Corporation.
  ata1.01: NODEV after polling detection
  ata1.00: ATA-7: QEMU HARDDISK, 0.10.6, max UDMA/100
  ata1.00: 20971520 sectors, multi 16: LBA48 
  ata1.00: configured for MWDMA2
  scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.10 PQ: 0 ANSI: 5
  ------------[ cut here ]------------
  WARNING: at lib/kref.c:43 kref_get+0x23/0x2d()
  Hardware name: 
  Modules linked in:
  Pid: 578, comm: async/0 Not tainted 2.6.30.4-elastic-lon-p #3
  Call Trace:
   [<ffffffff80419d84>] ? vgacon_set_cursor_size+0xfd/0x109
   [<ffffffff80257fa5>] warn_slowpath_common+0x77/0x8f
   [<ffffffff80257fcc>] warn_slowpath_null+0xf/0x11
   [<ffffffff803fbfb6>] kref_get+0x23/0x2d
   [<ffffffff803fb167>] kobject_get+0x1a/0x22
   [<ffffffff804708c1>] get_device+0x14/0x1a
   [<ffffffff80493d56>] sd_probe+0x1b7/0x21d
   [<ffffffff80473a1e>] driver_probe_device+0x9a/0x11f
   [<ffffffff80473b54>] __device_attach+0x35/0x3a
   [<ffffffff80473b1f>] ? __device_attach+0x0/0x3a
   [<ffffffff80472fd4>] bus_for_each_drv+0x51/0x88
   [<ffffffff80473be1>] device_attach+0x5e/0x75
   [<ffffffff80472e3c>] bus_attach_device+0x26/0x58
   [<ffffffff80471a5d>] device_add+0x3ff/0x562
   [<ffffffff80485104>] scsi_sysfs_add_sdev+0xb5/0x252
   [<ffffffff80482f72>] scsi_probe_and_add_lun+0x910/0xa32
   [<ffffffff80483e98>] __scsi_add_device+0xb3/0xdf
   [<ffffffff804a104d>] ata_scsi_scan_host+0x74/0x16e
   [<ffffffff8026b1c3>] ? autoremove_wake_function+0x0/0x34
   [<ffffffff8049f3b8>] async_port_probe+0xab/0xb3
   [<ffffffff80270482>] async_thread+0x10c/0x20d
   [<ffffffff802545ff>] ? default_wake_function+0x0/0xf
   [<ffffffff80270376>] ? async_thread+0x0/0x20d
   [<ffffffff8026ad89>] kthread+0x55/0x80
   [<ffffffff8022be6a>] child_rip+0xa/0x20
   [<ffffffff8026ad34>] ? kthread+0x0/0x80
   [<ffffffff8022be60>] ? child_rip+0x0/0x20
  ---[ end trace cce8275f5d03fa65 ]---
  sd 0:0:0:0: Attached scsi generic sg0 type 0
  sd 0:0:0:0: [sda] 20971520 512-byte hardware sectors: (10.7 GB/10.0 GiB)
  sd 0:0:0:0: [sda] Write Protect is off
  sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
  sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
   sda: sda1 sda2
  sd 0:0:0:0: [sda] Attached SCSI disk
  [...]

  scsi2 : iSCSI Initiator over TCP/IP
  scsi 2:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
  scsi 2:0:0:0: Attached scsi generic sg1 type 12
  scsi 2:0:0:1: Direct-Access     IET      VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
  ------------[ cut here ]------------
  WARNING: at lib/kref.c:43 kref_get+0x23/0x2d()
  Hardware name: 
  Modules linked in:
  Pid: 1156, comm: iscsid Tainted: G        W  2.6.30.4-elastic-lon-p #3
  Call Trace:
   [<ffffffff80419d84>] ? vgacon_set_cursor_size+0xfd/0x109
   [<ffffffff80257fa5>] warn_slowpath_common+0x77/0x8f
   [<ffffffff80257fcc>] warn_slowpath_null+0xf/0x11
   [<ffffffff803fbfb6>] kref_get+0x23/0x2d
   [<ffffffff803fb167>] kobject_get+0x1a/0x22
   [<ffffffff804708c1>] get_device+0x14/0x1a
   [<ffffffff80493d56>] sd_probe+0x1b7/0x21d
   [<ffffffff80473a1e>] driver_probe_device+0x9a/0x11f
   [<ffffffff80473b54>] __device_attach+0x35/0x3a
   [<ffffffff80473b1f>] ? __device_attach+0x0/0x3a
   [<ffffffff80472fd4>] bus_for_each_drv+0x51/0x88
   [<ffffffff80473be1>] device_attach+0x5e/0x75
   [<ffffffff80472e3c>] bus_attach_device+0x26/0x58
   [<ffffffff80471a5d>] device_add+0x3ff/0x562
   [<ffffffff80485104>] scsi_sysfs_add_sdev+0xb5/0x252
   [<ffffffff80482f72>] scsi_probe_and_add_lun+0x910/0xa32
   [<ffffffff8048363c>] __scsi_scan_target+0x3a5/0x542
   [<ffffffff8029e08d>] ? zone_statistics+0x60/0x65
   [<ffffffff80293369>] ? get_page_from_freelist+0x4ad/0x67a
   [<ffffffff80483dce>] scsi_scan_target+0x97/0xae
   [<ffffffff80487c3b>] iscsi_user_scan_session+0xcd/0xe4
   [<ffffffff80487b6e>] ? iscsi_user_scan_session+0x0/0xe4
   [<ffffffff80470f95>] device_for_each_child+0x35/0x6c
   [<ffffffff80487b53>] iscsi_user_scan+0x28/0x2a
   [<ffffffff8048471c>] store_scan+0x9b/0xc6
   [<ffffffff80470765>] dev_attr_store+0x1b/0x1d
   [<ffffffff8030b61d>] sysfs_write_file+0xf2/0x12e
   [<ffffffff802c1711>] vfs_write+0xad/0x129
   [<ffffffff802c1846>] sys_write+0x45/0x6c
   [<ffffffff8022aeeb>] system_call_fastpath+0x16/0x1b
  ---[ end trace cce8275f5d03fa67 ]---
  sd 2:0:0:1: Attached scsi generic sg2 type 0
  sd 2:0:0:1: [sdb] 10485760 512-byte hardware sectors: (5.36 GB/5.00 GiB)
  sd 2:0:0:1: [sdb] Write Protect is off
  sd 2:0:0:1: [sdb] Mode Sense: 79 00 00 08
  sd 2:0:0:1: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
   sdb: unknown partition table
  sd 2:0:0:1: [sdb] Attached SCSI disk
  [...]

etc.

> As for a printk, there's no real way to do that.  What I did was make sure
> we take a reference to the scsi disk.  Holding that reference should
> prevent us from losing the partition table ... but the issue itself is
> legitimate (add racing with remove), and there's not really a good way of
> detecting it.

I was thinking of a debug hack like

  if (atomic_read(&sdkp->dev.kobj.kref.refcount) < 2)
          printk("James' patch has just protected us from a crash: send him a beer\n");

just before

  put_device(&sdkp->dev);

in sd_probe_async(). I know the refcount could still drop between the
atomic_read and put_device, but we wouldn't have crashed in that case anyway
and at least if we do see the message over the next few days in our kernel
logs, I could definitely confirm your theory. Otherwise, given it's such a
rare crash, I might not know whether or not we've just been lucky for a
couple of weeks!

Best wishes,

Chris.
