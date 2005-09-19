From: Anton Blanchard <anton@samba.org>
Subject: scsi error handling oops on current git
Date: Tue, 20 Sep 2005 01:52:46 +1000
Message-ID: <20050919155245.GD25588@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:1444 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S932463AbVISPxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 11:53:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

I managed to hit this on a screwy setup (bad interrupt routing). Its the 
sym2 driver.

It looks like the error handler thread freed the same sgtable twice.
Second time through we mempool_free on a NULL pointer and die.

Anton

 0:0:0:0: ABORT operation started.
 0:0:0:0: ABORT operation timed-out.
 0:0:0:0: DEVICE RESET operation started.
 0:0:0:0: DEVICE RESET operation timed-out.
 0:0:0:0: BUS RESET operation started.
 0:0:0:0: BUS RESET operation timed-out.
 0:0:0:0: HOST RESET operation started.
sym0: SCSI BUS has been reset.
 0:0:0:0: HOST RESET operation timed-out.
scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0

scsi_free_sgtable sgp c0000000006679e0 sgl c00000000fc18c80
Call Trace:
[c000000000338c60] scsi_io_completion+0x250/0x520
[c00000000032fe34] scsi_finish_command+0xa4/0x130
[c0000000003363cc] scsi_error_handler+0x65c/0xb20
[c000000000071558] kthread+0x178/0x190

scsi_free_sgtable sgp c0000000006679e0 sgl 0
Call Trace:
[c00000000033734c] scsi_release_buffers+0x8c/0xc0
[c0000000003373c8] scsi_unprep_request+0x48/0x70
[c0000000003386a8] scsi_requeue_command+0x28/0x80
[c000000000338da8] scsi_io_completion+0x398/0x520
[c00000000032fe34] scsi_finish_command+0xa4/0x130
[c0000000003363cc] scsi_error_handler+0x65c/0xb20
[c000000000071558] kthread+0x178/0x190

cpu 0x0: Vector: 300 (Data Access) at [c000000003ddf5c0]
   pc: c000000000096d14: .kmem_cache_free+0x64/0x230
   lr: c00000000008e7ac: .mempool_free_slab+0x1c/0x30

   dar: c0000040bfff3fc0     <---- this is the bad address

   pid   = 752, comm = scsi_eh_0
