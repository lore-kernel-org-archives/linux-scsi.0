From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 08:21:29 +0200
Message-ID: <20050524062128.GT9855@suse.de>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:46495 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261182AbVEXGVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 02:21:39 -0400
Content-Disposition: inline
In-Reply-To: <1116886206.5021.42.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

On Mon, May 23 2005, James Bottomley wrote:
> On Mon, 2005-05-23 at 16:45 -0400, Jeff Garzik wrote:
> > On Mon, May 23, 2005 at 03:41:15PM -0500, James Bottomley wrote:
> > > The thread petered out before a resolution, however, I think
> > > at least disk devices should be doing a synchronize cache on suspend.
> > 
> > Agreed.
> 
> OK, try this as a straw horse.  It plumbs our scsi bus model into
> suspend and resume via the driver (which would be the ULD) function.
> The only ULD which has an extra function is sd, and all it does is
> synchronize the cache if it was writeback.  I believe you translate SYNC
> CACHE in libata, so this patch should be sufficient (unless we still
> have a problem with ATA devices that lie about their cache types?)
> 
> I think this is sufficient, because if the LLD also wants this
> information, it can get it from the model of the bus it's attached to.

suspend/resume is a lot more complicated than just flushing a cache, the
below will probably get you safe asleep but you will never get devices
alive again after power-up on suspend-to-ram.

I also greatly prefer issuing a standby command to the drive after the
flush, so that we don't risk using the emergency parks of the drive. If
a drive happens to lie about wrt the flush command, it gets an extra
chance to flush the cache as it now knows that power will be gone very
soon. So I think the ->suspend/->resume hooks should belong to the LLD,
not the ULD as the ULD has no idea how to suspend all devices types.


-- 
Jens Axboe

