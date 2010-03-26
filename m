From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [usb-storage] System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 26 Mar 2010 13:23:58 -0700
Message-ID: <20100326202358.GA22506@xanatos>
References: <4BA9D74F.9040507@gmail.com>
 <4BA7797F.8060605@gmail.com>
 <20100324155917.GA4382@xanatos>
 <59ca64281003241107x40c5d83co29d1ee03d8d3a0d1@mail.gmail.com>
 <20100326184021.GA4350@xanatos>
 <20100326192757.GA1187@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:63123 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751976Ab0CZUYB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2010 16:24:01 -0400
Content-Disposition: inline
In-Reply-To: <20100326192757.GA1187@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Mar 26, 2010 at 12:27:57PM -0700, Matthew Dharm wrote:
> On Fri, Mar 26, 2010 at 11:40:21AM -0700, Sarah Sharp wrote:
> > I think the amount of information is fine, but I'm not sure why the
> > device would respond with a stall to this particular command, so I'm
> > CC'ing the USB storage list and SCSI list.  Does anyone know what the
> > third command is?  The USB storage driver reports it as an "unknown
> > command".  I can see from scsi.h that 0x85 is the code for ATA_16, but
> > I'm not sure what that command actually does.
> 
> I've got nothing.  BUT, usb-storage translates the command codes to names
> via a table maintained by the SCSI people.  If it's not in the table, then
> it's very likely coming from a userspace program.

Probably from gpartd trying to partition the drive.

> > Mar 24 18:53:36 js-workstation kernel: [  253.414217] usb-storage: queuecommand called
> > Mar 24 18:53:36 js-workstation kernel: [  253.414222] usb-storage: *** thread awakened.
> > 
> > Mar 24 18:53:36 js-workstation kernel: [  253.414223] usb-storage: Command (unknown command) (16 bytes)
> > Mar 24 18:53:36 js-workstation kernel: [  253.414224] usb-storage:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
> > Mar 24 18:53:36 js-workstation kernel: [  253.414229] usb-storage: Bulk Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
> > Mar 24 18:53:36 js-workstation kernel: [  253.414230] usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> > Mar 24 18:53:36 js-workstation kernel: [  253.414378] usb-storage: Status code 0; transferred 31/31
> > Mar 24 18:53:36 js-workstation kernel: [  253.414379] usb-storage: -- transfer complete
> > Mar 24 18:53:36 js-workstation kernel: [  253.414380] usb-storage: Bulk command transfer result=0
> > Mar 24 18:53:36 js-workstation kernel: [  253.414381] usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
> > Mar 24 18:53:36 js-workstation kernel: [  253.414458] xhci_hcd 0000:03:00.0: WARN: Stalled endpoint
> > Mar 24 18:53:36 js-workstation kernel: [  253.414529] usb-storage: Status code -32; transferred 0/512
> > Mar 24 18:53:36 js-workstation kernel: [  253.414530] usb-storage: clearing endpoint halt for pipe 0xc0008280
> > Mar 24 18:53:36 js-workstation kernel: [  253.414532] usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
> > Mar 24 18:53:36 js-workstation kernel: [  253.414894] usb-storage: usb_stor_clear_halt: result = 0
> > Mar 24 18:53:36 js-workstation kernel: [  253.414895] usb-storage: Bulk data transfer result 0x2
> > Mar 24 18:53:36 js-workstation kernel: [  253.414896] usb-storage: Attempting to get CSW...
> > Mar 24 18:53:36 js-workstation kernel: [  253.414897] usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> > Mar 24 18:53:36 js-workstation kernel: [  253.414902] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB anyway.
> > Mar 24 18:53:36 js-workstation kernel: [  253.415168] usb-storage: Status code 0; transferred 13/13
> > Mar 24 18:53:36 js-workstation kernel: [  253.415169] usb-storage: -- transfer complete
> > Mar 24 18:53:36 js-workstation kernel: [  253.415170] usb-storage: Bulk status result = 0
> > Mar 24 18:53:36 js-workstation kernel: [  253.415171] usb-storage: Bulk Status S 0x53425355 T 0x2f R 512 Stat 0x2
> > Mar 24 18:53:36 js-workstation kernel: [  253.415172] usb-storage: -- transport indicates error, resetting
> > Mar 24 18:53:36 js-workstation kernel: [  253.415174] usb-storage: usb_stor_pre_reset
> > Mar 24 18:53:36 js-workstation kernel: [  253.415204] usb-storage: usb_stor_post_reset
> > 
> > I'm trying to figure out if this device would benefit from any USB
> > storage quirks being set.
> 
> Not that I'm aware of.
> 
> I find it interesting that an endpoint stalled, we cleared the endpoint,
> but then it is still listed as halted.  That seems odd to me....

It looks odd, but it's normal.  The issue is that the xHCI hardware
keeps track of whether an endpoint is halted or not, and the xHCI driver
must issue a command to the xHCI hardware to reset the endpoint,
separate from the control transfer to the device to clear the stall.

The xHCI's reset endpoint command hasn't completed before the URB is
submitted, but once the hardware processes the command, the xHCI driver
re-rings the doorbell to get the URB restarted.  The rest of the log
file (which I trimmed) looked fine.

Sarah
