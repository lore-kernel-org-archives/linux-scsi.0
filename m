From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Fri, 11 Jun 2004 11:30:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040611093027.GW13836@suse.de>
References: <1086807083.3741.21.camel@patibmrh9> <1086823857.5997.124.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:41671 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262802AbUFKJad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jun 2004 05:30:33 -0400
Content-Disposition: inline
In-Reply-To: <1086823857.5997.124.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Wed, Jun 09 2004, Pat LaVarre wrote:
> Jens A:
> 
> > > a) ...
> > > ...
> > > e) ...
> > ...
> > f) issue some command that transfers data as well.
> 
> I tried an op x12 (18) Inquiry for up to x24 (36) bytes.
> 
> I got back zeroes even when I memset my data originally to equal
> catenated copies of "\xAE" (174).
> 
> Under such provocations, dmesg then consistently reports:
> 
> hdd: The disk reports a capacity of 250640384 bytes, but the drive only handles 250609664
> hdd: unknown partition table
> hdd: leftover data in idefloppy_input_buffers, bcount == 36

Ah that's a good hint. Can you try changing the pc->buffer = NULL in
idefloppy_blockpc_cmd() to pc->buffer = rq->data? Also, only set
PC_DMA_RECOMMENDED if it isn't set. Something ala

	pc->buffer = rq->data;
	if (rq->bio)
		set_bit(PC_DMA_RECOMMENDED, &pc->flags);

that should work, I think. Do this on top of the patch you are already
using.

-- 
Jens Axboe

