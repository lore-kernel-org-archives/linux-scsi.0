From: Jens Axboe <axboe@suse.de>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Sat, 28 Aug 2004 19:55:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040828175547.GA8339@suse.de>
References: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org> <Pine.LNX.4.44L0.0408271100590.1238-100000@ida.rowland.org> <20040828143124.GB2518@suse.de> <1093715498.3682.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:36821 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S267482AbUH1Rzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 13:55:41 -0400
Content-Disposition: inline
In-Reply-To: <1093715498.3682.4.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Pat LaVarre <p.lavarre@ieee.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, Aug 28 2004, James Bottomley wrote:
> On Sat, 2004-08-28 at 10:31, Jens Axboe wrote:
> > > usb-storage, for example, where the protocol only limits us to 4 GB per
> > > transfer, there would be no problem allowing max_sectors to go as high as
> > > 65535?
> > 
> > If the hardware and driver can handle it, there's no other limit.
> 
> Actually, if you go through the SCSI stack, you're limited by our SG
> list slot allocation which we use a mempool for.  The default maximum is
> 128, although there's an option to increase this to 256.
> 
> These slots are the number of entries in the SG list we allow.  If your
> driver disables clustering, and you havea no IOMMU, this limits you to
> 128*<page size> = 512kb on x86 bytes.  Otherwise, it can go higher
> depending on the HW capabilities.  Remember too that a lot of HW limits
> the number of SG slots (see the sg_tablesize entry for each driver).

Oh yes, I know. bio layer has similar limits, there are no bio_io_vec
entries for > 256 pages. Should have made that more clear, sorry. The sg
table limits are reflected in the queue.

Probably bio and SCSI should use a unified MAX_PAGES define, there's not
much point in bio setting up a 256 page bio_io_vec slab and mempool, if
noone can use it.

-- 
Jens Axboe

