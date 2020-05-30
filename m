Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97544C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 01:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A10208A7
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 01:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgE3BDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 21:03:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45979 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728297AbgE3BDP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 May 2020 21:03:15 -0400
Received: (qmail 14534 invoked by uid 1000); 29 May 2020 21:03:14 -0400
Date:   Fri, 29 May 2020 21:03:14 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Zebediah Figura <zfigura@codeweavers.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
        SCSI development list <linux-scsi@vger.kernel.org>
Subject: Re: Bug 207877: ASMedia drive (174c:55aa) hangs in ioctl
 CDROM_DRIVE_STATUS when mounting a DVD
Message-ID: <20200530010314.GA12419@rowland.harvard.edu>
References: <7d0b20b9-4735-bbed-bb50-72764aefd6d8@codeweavers.com>
 <20200528075440.GA2881385@kroah.com>
 <465eaae3-fa60-f37e-1d62-c52236720798@codeweavers.com>
 <20200528160420.GA14188@rowland.harvard.edu>
 <232b68f8-9a5c-89fd-2e12-bf63f49dbe38@codeweavers.com>
 <20200528170509.GC14188@rowland.harvard.edu>
 <cb5371de-984f-bdf3-4cfe-a7343998515d@codeweavers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb5371de-984f-bdf3-4cfe-a7343998515d@codeweavers.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 28, 2020 at 02:27:52PM -0500, Zebediah Figura wrote:
> On 5/28/20 12:05 PM, Alan Stern wrote:
> > I get the impression that the SCSI error handler may have tried to reset
> > the device without first aborting the current transfer.  But it's not
> > easy to tell if that's what really happened.  You might be able to get
> > more information by enabling CONFIG_USB_STORAGE_DEBUG and rebuilding the
> > usb-storage driver, or by turning on SCSI debugging.
> 
> I've attached a kernel log with CONFIG_USB_STORAGE_DEBUG to the bug report.
> I'm not able to properly interpret the results, but I do see "device_reset
> called" as the last USB/SCSI-related message without any nearby mention of
> cancellation...?
> 
> The backtrace looks different, though.

I don't think that matters.

> With respect to SCSI debugging, the best instructions I was able to find
> directed me to try:
> 
> hazel@watership:~$ cat /proc/scsi/sg/debug
> max_active_device=2  def_reserved_size=32768
> 
> while the hang was taking place. If there's more useful debugging I can do,
> I'll need pointers. I did enable CONFIG_SCSI_LOGGING in the above build.

Maybe someone from the linux-scsi mailing list will help.

Here is the problem we are facing, as shown in the following debugging 
log.  The log includes a sequence of six commands sent to a DVD drive.  
The first READ succeeds:

May 28 14:03:05 watership kernel: *** thread awakened
May 28 14:03:05 watership kernel: Command READ_10 (10 bytes)
May 28 14:03:05 watership kernel: bytes: 28 00 00 00 00 fa 00 00 06 00
May 28 14:03:05 watership kernel: Bulk Command S 0x43425355 T 0x222 L 12288 F 128 Trg 0 LUN 0 CL 10
May 28 14:03:05 watership kernel: xfer 31 bytes
May 28 14:03:05 watership kernel: Status code 0; transferred 31/31
May 28 14:03:05 watership kernel: -- transfer complete
May 28 14:03:05 watership kernel: Bulk command transfer result=0
May 28 14:03:05 watership kernel: xfer 12288 bytes, 1 entries
May 28 14:03:05 watership kernel: Status code 0; transferred 12288/12288
May 28 14:03:05 watership kernel: -- transfer complete
May 28 14:03:05 watership kernel: Bulk data transfer result 0x0
May 28 14:03:05 watership kernel: Attempting to get CSW...
May 28 14:03:05 watership kernel: xfer 13 bytes
May 28 14:03:05 watership kernel: Status code 0; transferred 13/13
May 28 14:03:05 watership kernel: -- transfer complete
May 28 14:03:05 watership kernel: Bulk status result = 0
May 28 14:03:05 watership kernel: Bulk Status S 0x53425355 T 0x222 R 0 Stat 0x0
May 28 14:03:05 watership kernel: scsi cmd done, result=0x0
May 28 14:03:05 watership kernel: *** thread sleeping

The second READ hangs for 30 seconds (reason unknown) and then gets 
aborted.  Following the abort, usb-storage automatically performs a 
reset:

May 28 14:03:05 watership kernel: *** thread awakened
May 28 14:03:05 watership kernel: Command READ_10 (10 bytes)
May 28 14:03:05 watership kernel: bytes: 28 00 00 3e 38 00 00 00 3c 00
May 28 14:03:05 watership kernel: Bulk Command S 0x43425355 T 0x223 L 122880 F 128 Trg 0 LUN 0 CL 10
May 28 14:03:05 watership kernel: xfer 31 bytes
May 28 14:03:05 watership kernel: Status code 0; transferred 31/31
May 28 14:03:05 watership kernel: -- transfer complete
May 28 14:03:05 watership kernel: Bulk command transfer result=0
May 28 14:03:05 watership kernel: xfer 122880 bytes, 15 entries
May 28 14:03:37 watership kernel: command_abort called
May 28 14:03:37 watership kernel: -- cancelling sg request
May 28 14:03:37 watership kernel: Status code -104; transferred 2048/122880
May 28 14:03:37 watership kernel: -- transfer cancelled
May 28 14:03:37 watership kernel: Bulk data transfer result 0x4
May 28 14:03:37 watership kernel: -- command was aborted
May 28 14:03:37 watership kernel: usb 1-5: reset high-speed USB device number 3 using xhci_hcd
May 28 14:03:37 watership kernel: usb_reset_device returns 0
May 28 14:03:37 watership kernel: scsi command aborted
May 28 14:03:37 watership kernel: *** thread sleeping
May 28 14:03:37 watership kernel: sr 1:0:0:0: [sr0] tag#0 FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=31s
May 28 14:03:37 watership kernel: sr 1:0:0:0: [sr0] tag#0 CDB: Read(10) 28 00 00 3e 38 00 00 00 3c 00
May 28 14:03:37 watership kernel: blk_update_request: I/O error, dev sr0, sector 16310272 op 0x0:(READ) flags 0x80700 phys_seg 15 prio class 0

Next is a GET EVENT/STATUS NOTIFICATION...

May 28 14:03:37 watership kernel: *** thread awakened
May 28 14:03:37 watership kernel: Command GET EVENT/STATUS NOTIFICATION (10 bytes)
May 28 14:03:37 watership kernel: bytes: 4a 01 00 00 10 00 00 00 08 00
May 28 14:03:37 watership kernel: Bulk Command S 0x43425355 T 0x224 L 8 F 128 Trg 0 LUN 0 CL 10
May 28 14:03:37 watership kernel: xfer 31 bytes
May 28 14:03:37 watership kernel: Status code 0; transferred 31/31
May 28 14:03:37 watership kernel: -- transfer complete
May 28 14:03:37 watership kernel: Bulk command transfer result=0
May 28 14:03:37 watership kernel: xfer 8 bytes, 1 entries
May 28 14:03:37 watership kernel: Status code 0; transferred 8/8
May 28 14:03:37 watership kernel: -- transfer complete
May 28 14:03:37 watership kernel: Bulk data transfer result 0x0
May 28 14:03:37 watership kernel: Attempting to get CSW...
May 28 14:03:37 watership kernel: xfer 13 bytes
May 28 14:03:37 watership kernel: Status code 0; transferred 13/13
May 28 14:03:37 watership kernel: -- transfer complete
May 28 14:03:37 watership kernel: Bulk status result = 0
May 28 14:03:37 watership kernel: Bulk Status S 0x53425355 T 0x224 R 0 Stat 0x0
May 28 14:03:37 watership kernel: scsi cmd done, result=0x0
May 28 14:03:37 watership kernel: *** thread sleeping

... followed by a retry attempt of the previous READ, which hangs and is 
aborted again:

May 28 14:03:37 watership kernel: *** thread awakened
May 28 14:03:37 watership kernel: Command READ_10 (10 bytes)
May 28 14:03:37 watership kernel: bytes: 28 00 00 3e 38 00 00 00 02 00
May 28 14:03:37 watership kernel: Bulk Command S 0x43425355 T 0x225 L 4096 F 128 Trg 0 LUN 0 CL 10
May 28 14:03:37 watership kernel: xfer 31 bytes
May 28 14:03:37 watership kernel: Status code 0; transferred 31/31
May 28 14:03:37 watership kernel: -- transfer complete
May 28 14:03:37 watership kernel: Bulk command transfer result=0
May 28 14:03:37 watership kernel: xfer 4096 bytes, 1 entries
May 28 14:04:08 watership kernel: command_abort called
May 28 14:04:08 watership kernel: -- cancelling sg request
May 28 14:04:08 watership kernel: Status code -104; transferred 2048/4096
May 28 14:04:08 watership kernel: -- transfer cancelled
May 28 14:04:08 watership kernel: Bulk data transfer result 0x4
May 28 14:04:08 watership kernel: -- command was aborted
May 28 14:04:08 watership kernel: usb 1-5: reset high-speed USB device number 3 using xhci_hcd
May 28 14:04:08 watership kernel: usb_reset_device returns 0
May 28 14:04:08 watership kernel: scsi command aborted
May 28 14:04:08 watership kernel: *** thread sleeping

Then there's another successful GET EVENT/STATUS NOTIFICATION:

May 28 14:04:08 watership kernel: *** thread awakened
May 28 14:04:08 watership kernel: Command GET EVENT/STATUS NOTIFICATION (10 bytes)
May 28 14:04:08 watership kernel: bytes: 4a 01 00 00 10 00 00 00 08 00
May 28 14:04:08 watership kernel: Bulk Command S 0x43425355 T 0x226 L 8 F 128 Trg 0 LUN 0 CL 10
May 28 14:04:08 watership kernel: xfer 31 bytes
May 28 14:04:08 watership kernel: Status code 0; transferred 31/31
May 28 14:04:08 watership kernel: -- transfer complete
May 28 14:04:08 watership kernel: Bulk command transfer result=0
May 28 14:04:08 watership kernel: xfer 8 bytes, 1 entries
May 28 14:04:08 watership kernel: Status code 0; transferred 8/8
May 28 14:04:08 watership kernel: -- transfer complete
May 28 14:04:08 watership kernel: Bulk data transfer result 0x0
May 28 14:04:08 watership kernel: Attempting to get CSW...
May 28 14:04:08 watership kernel: xfer 13 bytes
May 28 14:04:08 watership kernel: Status code 0; transferred 13/13
May 28 14:04:08 watership kernel: -- transfer complete
May 28 14:04:08 watership kernel: Bulk status result = 0
May 28 14:04:08 watership kernel: Bulk Status S 0x53425355 T 0x226 R 0 Stat 0x0
May 28 14:04:08 watership kernel: scsi cmd done, result=0x0
May 28 14:04:08 watership kernel: *** thread sleeping

And a third attempt at the READ, which hangs as before:

May 28 14:04:08 watership kernel: *** thread awakened
May 28 14:04:08 watership kernel: Command READ_10 (10 bytes)
May 28 14:04:08 watership kernel: bytes: 28 00 00 3e 38 00 00 00 02 00
May 28 14:04:08 watership kernel: Bulk Command S 0x43425355 T 0x227 L 4096 F 128 Trg 0 LUN 0 CL 10
May 28 14:04:08 watership kernel: xfer 31 bytes
May 28 14:04:08 watership kernel: Status code 0; transferred 31/31
May 28 14:04:08 watership kernel: -- transfer complete
May 28 14:04:08 watership kernel: Bulk command transfer result=0
May 28 14:04:08 watership kernel: xfer 4096 bytes, 1 entries

But this time, instead of aborting the command, the SCSI core calls the 
device_reset routine.  This causes usb-storage to lock up; the reset 
can't proceed while the READ command is still executing:

May 28 14:04:38 watership kernel: device_reset called
May 28 14:06:48 watership kernel: INFO: task scsi_eh_1:240 blocked for more than 122 seconds.
May 28 14:06:48 watership kernel:       Not tainted 5.7.0-rc7local #4
May 28 14:06:48 watership kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 28 14:06:48 watership kernel: scsi_eh_1       D    0   240      2 0x80004000
May 28 14:06:48 watership kernel: Call Trace:
May 28 14:06:48 watership kernel:  __schedule+0x2a5/0x8c0
May 28 14:06:48 watership kernel:  schedule+0x46/0xf0
May 28 14:06:48 watership kernel:  schedule_preempt_disabled+0x14/0x20
May 28 14:06:48 watership kernel:  __mutex_lock.constprop.0+0x180/0x510
May 28 14:06:48 watership kernel:  device_reset+0x33/0x60 [usb_storage]
May 28 14:06:48 watership kernel:  scsi_eh_ready_devs+0x5f4/0xa40 [scsi_mod]
May 28 14:06:48 watership kernel:  ? _raw_spin_unlock_irqrestore+0x20/0x40
May 28 14:06:48 watership kernel:  ? __pm_runtime_resume+0x49/0x60
May 28 14:06:48 watership kernel:  scsi_error_handler+0x448/0x510 [scsi_mod]
May 28 14:06:48 watership kernel:  ? scsi_eh_get_sense+0x1f0/0x1f0 [scsi_mod]
May 28 14:06:48 watership kernel:  kthread+0x13e/0x160
May 28 14:06:48 watership kernel:  ? __kthread_bind_mask+0x60/0x60
May 28 14:06:48 watership kernel:  ret_from_fork+0x22/0x40
May 28 14:06:48 watership kernel: INFO: task usb-storage:242 blocked for more than 122 seconds.
May 28 14:06:48 watership kernel:       Not tainted 5.7.0-rc7local #4
May 28 14:06:48 watership kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 28 14:06:48 watership kernel: usb-storage     D    0   242      2 0x80004000
May 28 14:06:48 watership kernel: Call Trace:
May 28 14:06:48 watership kernel:  __schedule+0x2a5/0x8c0
May 28 14:06:48 watership kernel:  schedule+0x46/0xf0
May 28 14:06:48 watership kernel:  schedule_timeout+0x12d/0x170
May 28 14:06:48 watership kernel:  wait_for_completion+0x9e/0x100
May 28 14:06:48 watership kernel:  usb_sg_wait+0xc9/0x190
May 28 14:06:48 watership kernel:  usb_stor_bulk_transfer_sglist.part.0.constprop.0+0x7f/0x100 [usb_storage]
May 28 14:06:48 watership kernel:  ? fill_inquiry_response+0x10/0x10 [usb_storage]
May 28 14:06:48 watership kernel:  usb_stor_Bulk_transport+0x1f9/0x5b0 [usb_storage]
May 28 14:06:48 watership kernel:  ? fill_inquiry_response+0x10/0x10 [usb_storage]
May 28 14:06:48 watership kernel:  usb_stor_invoke_transport+0x59/0x6c0 [usb_storage]
May 28 14:06:48 watership kernel:  ? fill_inquiry_response+0x10/0x10 [usb_storage]
May 28 14:06:48 watership kernel:  usb_stor_control_thread+0x17d/0x390 [usb_storage]
May 28 14:06:48 watership kernel:  kthread+0x13e/0x160
May 28 14:06:48 watership kernel:  ? __kthread_bind_mask+0x60/0x60
May 28 14:06:48 watership kernel:  ret_from_fork+0x22/0x40

So here's the question: Why doesn't the SCSI error handler abort the 
ongoing command (like it did the first two times) before resetting the 
device?

Note: The kernel version is 5.7-rc7.

Alan Stern
