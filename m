From: Pat LaVarre <p.lavarre@ieee.org>
Subject: sg MiB writes scheduling while atomic
Date: 10 Sep 2003 12:49:37 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063219776.3669.72.camel@patehci2>
References: <Pine.LNX.4.44L0.0309101219190.905-100000@ida.rowland.org>
	 <1063217791.3669.43.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:21125 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265466AbTIJSse
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 14:48:34 -0400
In-Reply-To: <1063217791.3669.43.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


In reply to `modprobe -r sg`, linux-2.6.0-test5 dmesg tells me:

Debug: sleeping function called from invalid context at
include/linux/rwsem.h:66
...
bad: scheduling while atomic!

Those lines appear in the log below.  The ... ellipses you see were
typed by me, sorry I don't have a more complete intact log, nor have I
yet repeated this result myself.

To provoke this log overnight I ran a shell script to repeat something
like:
pldd of=/dev/sg1 if=/dev/zero bs=1m

The "usb 1-1: sg_complete, unlink --> -19" appeared when or before an
ioctl SG_IO hung.  The Debug/ Call Trace appeared in response to a
`modprobe -r sg` that hung.  I'm confident the cable was not unplugged
because rebooting the system made sg work again.  I'm confident the
drive power was not cycled because reboot provoked only an SK ASC = x 6
29 Reset unit attention, without an SK ASC = x 6 28 GoneReady unit
attention.

[usb-storage] folk tell me some linux-scsi folk may appreciate me
mentioning this.

Pat LaVarre

...
usb-storage: Command WRITE_10 (10 bytes)
usb-storage:  2a 00 00 ce 26 00 00 02 00 00
usb-storage: Bulk Command S 0x43425355 T 0x439c9 L 1048576 F 0 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 1048576 bytes, 32 entries
usb-storage: Status code 0; transferred 1048576/1048576
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x439c9 R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command WRITE_10 (10 bytes)
usb-storage:  2a 00 00 ce 28 00 00 02 00 00
usb-storage: Bulk Command S 0x43425355 T 0x439ca L 1048576 F 0 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 1048576 bytes, 32 entries
usb-storage: Status code 0; transferred 1048576/1048576
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result = 0
usb-storage: Bulk Status S 0x53425355 T 0x439ca R 0 Stat 0x0
usb-storage: scsi cmd done, result=0x0
usb-storage: *** thread sleeping.
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command WRITE_10 (10 bytes)
usb-storage:  2a 00 00 ce 2a 00 00 02 00 00
usb-storage: Bulk Command S 0x43425355 T 0x439cb L 1048576 F 0 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 1048576 bytes, 32 entries
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
usb 1-1: sg_complete, unlink --> -19
...

Debug: sleeping function called from invalid context at
include/linux/rwsem.h:66
Call Trace:
 [<c0121f16>] __might_sleep+0x5f/0x72
 [<c0280ec0>] scsi_device_put+0x3c/0xfe
 [<df9179bc>] sg_remove+0x146/0x1bd [sg]
 [<c024db2f>] class_interface_unregister+0x7c/0xc0
 [<df91a7b3>] exit_sg+0x17/0x56 [sg]
 [<c013b533>] sys_delete_module+0x18e/0x1d1
 [<c0151695>] sys_munmap+0x58/0x77
 [<c010b46d>] sysenter_past_esp+0x52/0x71
 
bad: scheduling while atomic!
Call Trace:
 [<c012018e>] schedule+0x57a/0x57f
 [<c01251d6>] printk+0x180/0x1cc
 [<c01eca67>] rwsem_down_write_failed+0xa3/0x15c
 [<c010c279>] dump_stack+0x1e/0x22
 [<c0281189>] .text.lock.scsi+0xa7/0xce
 [<df9179bc>] sg_remove+0x146/0x1bd [sg]
 [<c024db2f>] class_interface_unregister+0x7c/0xc0
 [<df91a7b3>] exit_sg+0x17/0x56 [sg]
 [<c013b533>] sys_delete_module+0x18e/0x1d1
 [<c0151695>] sys_munmap+0x58/0x77
 [<c010b46d>] sysenter_past_esp+0x52/0x71
...


