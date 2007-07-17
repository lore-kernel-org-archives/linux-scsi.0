From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 16:24:36 +0900
Message-ID: <20070717162436V.fujita.tomonori@lab.ntt.co.jp>
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>
	<20070717063810.GY5195@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:56989 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbXGQHZI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 03:25:08 -0400
In-Reply-To: <20070717063810.GY5195@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: block/bsg.c
Date: Tue, 17 Jul 2007 08:38:11 +0200

> > As a reader of this code I'm wondering "hm, why is
> > BSG_SUB_PROTOCOL_SCSI_CMD unprivileged, while other modes require
> > CAP_SYS_RAWIO"?.
> >
> > This design/policy decision maybe was discussed on a mailing list
> > somewhere, or even perhaps in a changelog (although I can't find it).  But
> > it is so important, and is so unobvious from a reading of the code that I'd
> > suggest that it is worth some discussion right here, in a code comment.
> >
> It's not unprivileged, it goes through the blk_verify_command() check
> list.

SCSI commands goes to blk_verify_command() like SG v3
(block/scsi_ioctl.c and drivers/scsi/sg.c).

Except for SCSI commands, only SAS Management Protocol (SMP) is
supported now. Sending management requests needs CAP_SYS_RAWIO, that's
a reasonable policy, I guess.


> > And `struct sg_io_v4' has just become part of the kernel ABI?  Beware that
> > there is a move afoot to require test code, manpages and even LTP testcases
> > for new ABI extensions.  Is this interface documented anywhere?
> 
> The documentation is likely very scarce atm, if anything. The command
> layout was discussed at the storage summit and on linux-scsi.

Not the latest, but Doug's RFC:

http://lwn.net/Articles/208082/

gives pretty good information.



> > Would I be correct in assuming that it offers services to device drivers,
> > which have yet to be hooked up?
> 
> Yes. As mentioned many lines up, it is a SCSI generic type driver that
> uses the (now) defined version 4 command structure. So it'll get hooked
> up to ny capable device.

The SAS transport class use bsg to handle SAS Management
Protocol. Every SAS object (host, device, expander, etc) has the own
bsg device. They call bsg_register_queue() for the own request
queue. Users can send SMP requests to any object via its bsg device.

http://marc.info/?l=linux-scsi&m=118395317724148&w=2

I guess that James plan to put SMP patches in the second SCSI merge
for 2.6.22.
