From: Sacher Khoudari <ng04@craesh.net>
Subject: Re: [linux-usb-devel] Fw: [Bug 3466] New: Bug while connecting  
 USB-HDD (fwd)
Date: Wed, 29 Sep 2004 00:02:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <cjcmtl$knh$1@sea.gmane.org>
References: <Pine.LNX.4.44L0.0409261704460.32350-100000@netrider.rowland.org> 	<1096236347.10924.97.camel@mulgrave> <1096389644.1717.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090204000701020104060304"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:12961 "EHLO main.gmane.org")
	by vger.kernel.org with ESMTP id S268090AbUI1XVO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 19:21:14 -0400
Received: from root by main.gmane.org with local (Exim 3.35 #1 (Debian))
	id 1CCRHV-0005lq-00
	for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2004 01:21:13 +0200
Received: from vpn026a.rzuser.uni-heidelberg.de ([129.206.196.26])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2004 01:21:07 +0200
Received: from ng04 by vpn026a.rzuser.uni-heidelberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Wed, 29 Sep 2004 01:21:07 +0200
In-Reply-To: <1096389644.1717.45.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-usb-devel@lists.sourceforge.net

This is a multi-part message in MIME format.
--------------090204000701020104060304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

James Bottomley wrote:
| On Sun, 2004-09-26 at 18:05, James Bottomley wrote:
|
|>There's not enough information to say why it happened.  However, all the
|>SCSI code checks out (it's dated ... open coded reference counting
|>instead of kref, but it looks sound).  The scenario described could be
|>seen if there's a problem in the host reference counting.
|>
|>In that case, there should have been a slab error earlier on in the logs
|>at the point the error occurred saying something like "slab error in
|>kmem_cache_destory(): can't free all objects"
|>
|>It's possible this could be caused by a refcounting race on the
|>commands.
|
|
| OK, I have a definite theory about this, but it hinges on finding the
| above message in the logs.
|
| I think we tried to destroy the command slab while some commands were
| still active.  The refcounting only applies to in-flight commands, but
| commands can also be allocated and queued in the block layer.
|
| If I'm right, the attached will close this refcounting hole.
|
| James


Hi!

I think you theory is right. I just found some interesting linesin
kern.log (see attachment). I remember I had some problems with my
USB-HDD while copying some big files, I had to detach the drive and plug
in again. As I can see in the logs there were some errors reading the
FAT-filesystem (although the filesytem fscks without errors). Strange...

Greatings!
Sacher

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBWd9ndiWjuQmpvxoRApOTAJsFt+iP5KArj2WCUoBIVdfv2ux+hQCaAnwM
hj8tgIXW0KutMt2h1bmLZuE=
=LvF+
-----END PGP SIGNATURE-----

--------------090204000701020104060304
Content-Type: text/x-log;
 name="usb-bug.kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb-bug.kernel.log"

Sep 26 00:04:16 dontpanic kernel: usb 5-2.4: new full speed USB device using address 8
Sep 26 00:04:17 dontpanic kernel: usb 5-2.4: not running at top speed; connect to a high speed hub
Sep 26 00:04:17 dontpanic kernel: scsi1 : SCSI emulation for USB Mass Storage devices
Sep 26 00:04:17 dontpanic kernel:   Vendor: Genesys   Model: USB to IDE Disk   Rev: 0002
Sep 26 00:04:17 dontpanic kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Sep 26 00:04:17 dontpanic kernel: SCSI device sda: 78242976 512-byte hdwr sectors (40060 MB)
Sep 26 00:04:17 dontpanic kernel: sda: assuming Write Enabled
Sep 26 00:04:17 dontpanic kernel: sda: assuming drive cache: write through
Sep 26 00:04:17 dontpanic kernel:  sda: sda1 < sda5 sda6 > sda2 sda3
Sep 26 00:04:17 dontpanic kernel: Attached scsi removable disk sda at scsi1, channel 0, id 0, lun 0
Sep 26 00:04:17 dontpanic kernel: Attached scsi generic sg0 at scsi1, channel 0, id 0, lun 0,  type 0
Sep 26 00:04:17 dontpanic kernel: USB Mass Storage device found at 8
Sep 26 00:08:30 dontpanic kernel: i2c_adapter i2c-0: Error: command never completed
Sep 26 00:10:25 dontpanic kernel: i2c_adapter i2c-0: Resetting entire SMB Bus to clear busy condition (08)
Sep 26 00:10:25 dontpanic kernel: i2c_adapter i2c-0: SMBus reset failed! (0x08) - controller or device on bus is probably hung
Sep 26 00:11:05 dontpanic kernel: i2c_adapter i2c-0: Resetting entire SMB Bus to clear busy condition (08)
Sep 26 00:11:05 dontpanic kernel: i2c_adapter i2c-0: SMBus reset failed! (0x08) - controller or device on bus is probably hung
Sep 26 00:15:55 dontpanic kernel: i2c_adapter i2c-0: Resetting entire SMB Bus to clear busy condition (08)
Sep 26 00:15:55 dontpanic kernel: i2c_adapter i2c-0: SMBus reset failed! (0x08) - controller or device on bus is probably hung
Sep 26 00:16:01 dontpanic kernel: usb 5-2.4: control timeout on ep0in
Sep 26 00:16:26 dontpanic last message repeated 5 times
Sep 26 00:17:36 dontpanic kernel: usb 5-2.4: reset full speed USB device using address 8
Sep 26 00:17:41 dontpanic kernel: usb 5-2.4: control timeout on ep0out
Sep 26 00:17:46 dontpanic kernel: usb 5-2.4: control timeout on ep0out
Sep 26 00:17:46 dontpanic kernel: usb 5-2.4: device not accepting address 8, error -110
Sep 26 00:17:46 dontpanic kernel: scsi: Device offlined - not ready after error recovery: host 1 channel 0 id 0 lun 0
Sep 26 00:17:46 dontpanic kernel: SCSI error : <1 0 0 0> return code = 0x50000
Sep 26 00:17:46 dontpanic kernel: end_request: I/O error, dev sda, sector 11709629
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926044
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: scsi1 (0:0): rejecting I/O to offline device
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926045
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926046
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926047
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926048
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926049
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926050
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926051
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926052
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: Buffer I/O error on device sda2, logical block 1926053
Sep 26 00:17:46 dontpanic kernel: lost page write due to I/O error on sda2
Sep 26 00:17:46 dontpanic kernel: scsi1 (0:0): rejecting I/O to offline device
Sep 26 00:17:46 dontpanic last message repeated 3 times
Sep 26 00:17:46 dontpanic kernel: usb 5-2.4: USB disconnect, address 8
Sep 26 00:17:46 dontpanic kernel: scsi1 (0:0): rejecting I/O to device being removed
Sep 26 00:17:46 dontpanic kernel: FAT: unable to read inode block for updating (i_pos 17963979)
Sep 26 00:17:46 dontpanic kernel: scsi1 (0:0): rejecting I/O to device being removed
Sep 26 00:17:46 dontpanic kernel: usb 5-2.4: new full speed USB device using address 9
Sep 26 00:17:51 dontpanic kernel: usb 5-2.4: control timeout on ep0out
Sep 26 00:17:56 dontpanic kernel: usb 5-2.4: control timeout on ep0out
Sep 26 00:17:57 dontpanic kernel: usb 5-2.4: device not accepting address 9, error -110
Sep 26 00:17:57 dontpanic kernel: usb 5-2.4: new full speed USB device using address 10
Sep 26 00:17:57 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:17:57 dontpanic kernel: FAT: Directory bread(block 1122748) failed
Sep 26 00:17:57 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:17:57 dontpanic kernel: FAT: Directory bread(block 1122749) failed
[...430 lines...]
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122770) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122771) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122772) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122773) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122774) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122775) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122776) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122777) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122778) failed
Sep 26 00:18:13 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:18:13 dontpanic kernel: FAT: Directory bread(block 1122779) failed
Sep 26 00:18:21 dontpanic kernel: usb 5-2.4: new full speed USB device using address 11
Sep 26 00:18:21 dontpanic kernel: usb 5-2.4: not running at top speed; connect to a high speed hub
Sep 26 00:18:21 dontpanic kernel: scsi2 : SCSI emulation for USB Mass Storage devices
Sep 26 00:18:21 dontpanic kernel:   Vendor: Genesys   Model: USB to IDE Disk   Rev: 0002
Sep 26 00:18:21 dontpanic kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Sep 26 00:18:21 dontpanic kernel: SCSI device sdb: 78242976 512-byte hdwr sectors (40060 MB)
Sep 26 00:18:21 dontpanic kernel: sdb: assuming Write Enabled
Sep 26 00:18:21 dontpanic kernel: sdb: assuming drive cache: write through
Sep 26 00:18:22 dontpanic kernel:  sdb: sdb1 < sdb5 sdb6 > sdb2 sdb3
Sep 26 00:18:22 dontpanic kernel: Attached scsi removable disk sdb at scsi2, channel 0, id 0, lun 0
Sep 26 00:18:22 dontpanic kernel: Attached scsi generic sg0 at scsi2, channel 0, id 0, lun 0,  type 0
Sep 26 00:18:22 dontpanic kernel: USB Mass Storage device found at 11
Sep 26 00:18:22 dontpanic kernel: usb 5-2.4: USB disconnect, address 11
Sep 26 00:18:26 dontpanic kernel: usb 5-2.2: new full speed USB device using address 12
Sep 26 00:18:26 dontpanic kernel: usb 5-2.2: not running at top speed; connect to a high speed hub
Sep 26 00:18:26 dontpanic kernel: scsi3 : SCSI emulation for USB Mass Storage devices
Sep 26 00:18:26 dontpanic kernel:   Vendor: Genesys   Model: USB to IDE Disk   Rev: 0002
Sep 26 00:18:26 dontpanic kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Sep 26 00:18:26 dontpanic kernel: SCSI device sdb: 78242976 512-byte hdwr sectors (40060 MB)
Sep 26 00:18:26 dontpanic kernel: sdb: assuming Write Enabled
Sep 26 00:18:26 dontpanic kernel: sdb: assuming drive cache: write through
Sep 26 00:18:27 dontpanic kernel:  sdb: sdb1 < sdb5 sdb6 > sdb2 sdb3
Sep 26 00:18:27 dontpanic kernel: Attached scsi removable disk sdb at scsi3, channel 0, id 0, lun 0
Sep 26 00:18:27 dontpanic kernel: Attached scsi generic sg0 at scsi3, channel 0, id 0, lun 0,  type 0
Sep 26 00:18:27 dontpanic kernel: USB Mass Storage device found at 12
Sep 26 00:19:08 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:19:08 dontpanic kernel:     clusters badly computed (0 != 134217727)
Sep 26 00:19:08 dontpanic kernel:     File system has been set read-only
Sep 26 00:19:08 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:19:08 dontpanic kernel:     clusters badly computed (1 != 0)
Sep 26 00:19:08 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:19:08 dontpanic kernel:     clusters badly computed (2 != 1)
Sep 26 00:19:08 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:19:08 dontpanic kernel:     clusters badly computed (3 != 2)
Sep 26 00:19:08 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:19:08 dontpanic kernel:     clusters badly computed (4 != 3)
[...36380 lines...]
Sep 26 00:26:28 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:26:28 dontpanic kernel:     clusters badly computed (18195 != 18194)
Sep 26 00:26:28 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:26:28 dontpanic kernel:     clusters badly computed (18196 != 18195)
Sep 26 00:26:28 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:26:28 dontpanic kernel:     clusters badly computed (18197 != 18196)
Sep 26 00:26:28 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:26:28 dontpanic kernel:     clusters badly computed (18198 != 18197)
Sep 26 00:26:28 dontpanic kernel: FAT: Filesystem panic (dev sdb2)
Sep 26 00:26:28 dontpanic kernel:     clusters badly computed (18199 != 18198)
Sep 26 00:28:56 dontpanic kernel: scsi1 (0:0): rejecting I/O to dead device
Sep 26 00:28:56 dontpanic kernel: FAT bread failed in fat_clusters_flush
Sep 26 00:32:38 dontpanic kernel: usb 2-1: USB disconnect, address 6
Sep 26 00:32:45 dontpanic kernel: usb 5-2.2: USB disconnect, address 12
Sep 26 00:32:45 dontpanic kernel: slab error in kmem_cache_destroy(): cache `scsi_cmd_cache': Can't free all objects
Sep 26 00:32:45 dontpanic kernel:  [<c0105e6e>] dump_stack+0x1e/0x20
Sep 26 00:32:45 dontpanic kernel:  [<c0142d0b>] kmem_cache_destroy+0x9b/0x120
Sep 26 00:32:45 dontpanic kernel:  [<c031d7fe>] scsi_destroy_command_freelist+0x6e/0xa0
Sep 26 00:32:45 dontpanic kernel:  [<c031e582>] scsi_host_dev_release+0x32/0x90
Sep 26 00:32:45 dontpanic kernel:  [<c02ecb58>] device_release+0x58/0x60
Sep 26 00:32:45 dontpanic kernel:  [<c0298c9d>] kobject_cleanup+0x8d/0x90
Sep 26 00:32:45 dontpanic kernel:  [<e09a5a52>] usb_stor_release_resources+0x62/0x100 [usb_storage]
Sep 26 00:32:45 dontpanic kernel:  [<e09a5d7b>] storage_disconnect+0x7b/0x87 [usb_storage]
Sep 26 00:32:45 dontpanic kernel:  [<c0333ef6>] usb_unbind_interface+0x76/0x80
Sep 26 00:32:45 dontpanic kernel:  [<c02edf06>] device_release_driver+0x66/0x70
Sep 26 00:32:45 dontpanic kernel:  [<c02ee18c>] bus_remove_device+0x7c/0xc0
Sep 26 00:32:45 dontpanic kernel:  [<c02ecefe>] device_del+0x6e/0xb0
Sep 26 00:32:45 dontpanic kernel:  [<c033ac18>] usb_disable_device+0xc8/0x110
Sep 26 00:32:45 dontpanic kernel:  [<c033607e>] usb_disconnect+0xbe/0x190
Sep 26 00:32:45 dontpanic kernel:  [<c0337158>] hub_port_connect_change+0x3d8/0x410
Sep 26 00:32:45 dontpanic kernel:  [<c033740f>] hub_events+0x27f/0x3d0
Sep 26 00:32:45 dontpanic kernel:  [<c0337595>] hub_thread+0x35/0x110
Sep 26 00:32:45 dontpanic kernel:  [<c01032b1>] kernel_thread_helper+0x5/0x14


--------------090204000701020104060304--

