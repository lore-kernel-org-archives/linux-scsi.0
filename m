From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: 28 Aug 2004 14:20:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093717255.3682.13.camel@mulgrave>
References: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org>
	<Pine.LNX.4.44L0.0408271100590.1238-100000@ida.rowland.org>
	<20040828143124.GB2518@suse.de> <1093715498.3682.4.camel@mulgrave>
	<20040828175547.GA8339@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:193 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266845AbUH1SU7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 14:20:59 -0400
In-Reply-To: <20040828175547.GA8339@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pat LaVarre <p.lavarre@ieee.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2004-08-28 at 13:55, Jens Axboe wrote:
> Probably bio and SCSI should use a unified MAX_PAGES define, there's not
> much point in bio setting up a 256 page bio_io_vec slab and mempool, if
> noone can use it.

Sure, ours is SCSI_MAX_PHYS_SEGMENTS ... by default, we just use
MAX_PHYS_SEGMENTS from the bio headers for this, which is 128, we could
set this to BIO_MAX_PAGES, sure.

We allow values of 32,64,128 and 256 (the smaller ones were for tiny
systems with SCSI stacks), the largest one for SGI/Qlogic.

However, I did ask the IBM spearker at OLS who was doing the elevator
analysis to retry with 256 instead of 128, and he reported no difference
within error, so I don't think there's much evidence that 256 actually
does anything useful (other than consume a bit of spare memory).

James


