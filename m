From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Missing allowable state transition?
Date: 18 Sep 2004 22:45:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095561933.2483.18.camel@mulgrave>
References: <20040919023749.GF642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:26059 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269733AbUISCpe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2004 22:45:34 -0400
In-Reply-To: <20040919023749.GF642@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2004-09-18 at 22:37, Matthew Wilcox wrote:
> I got forwarded this dmesg from a PA-RISC user ...
> 
> ----- Forwarded message from Stuart Brady -----
> 
> Linux version 2.6.9-rc2-pa5 (sdb@1986u10) (gcc version 3.3.4 (Debian 1:3.3.4-6sarge1)) #2 Sat Sep 18 19:38:34 BST 2004
> [...]
> 53c700: Version 2.8 By James.Bottomley@HansenPartnership.com
> scsi0: 53c710 rev 2 
> scsi0 : LASI SCSI 53c700
> Using anticipatory io scheduler
> scsi0 (6:0) New error handler wants to abort command
> 	scsi0 : destination target 6, lun 0
>         command = 0x12 00 00 00 24 00 
> scsi0 (6:0) New error handler wants device reset
> 	scsi0 : destination target 6, lun 0
>         command = 0x12 00 00 00 24 00 
> scsi0 (6:0) New error handler wants BUS reset, cmd 107d1cc0
> 	scsi0 : destination target 6, lun 0
>         command = 0x12 00 00 00 24 00 
> scsi0: Bus Reset detected, executing command 107d1cc0, slot 00008520, dsp 007f0528[0528]
>  failing command because of reset, slot 00008520, cmnd 107d1cc0
>  0:0:6:0: Illegal state transition created->quiesce
> Badness in scsi_device_set_state at drivers/scsi/scsi_lib.c:1688
> Backtrace:
>  [<10211750>] scsi_device_set_state+0xf0/0x164
>  [<102117d8>] scsi_device_quiesce+0x14/0x64
>  [<10216274>] spi_dv_device+0x68/0x178
>  [<1021639c>] spi_dv_device_work_wrapper+0x18/0x38
>  [<10139eb4>] worker_thread+0x1ac/0x278
>  [<1013ea14>] kthread+0xdc/0xe4
>  [<1010ec5c>] ret_from_kernel_thread+0x1c/0x24

Actually, the transition is correctly disallowed.  The reason it's being
seen is because the 53c700 is being sent an initial INQUIRY to probe for
a device and is hanging on it.  The driver contains a
spi_schedule_dv_device() in the reset routine to retrain the target
after a reset ... however, we don't want to do that in this case, we
want to stay at async.

James


