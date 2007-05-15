From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/19] clean ups on the drivers
Date: Tue, 15 May 2007 16:49:19 -0400
Message-ID: <1179262159.3685.56.camel@mulgrave.il.steeleye.com>
References: <1179230056.3685.2.camel@mulgrave.il.steeleye.com>
	 <20070515115748.GA12461@infradead.org>
	 <1179248245.3685.23.camel@mulgrave.il.steeleye.com>
	 <20070515.133730.120446537.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47478 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756739AbXEOUtk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2007 16:49:40 -0400
In-Reply-To: <20070515.133730.120446537.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, stefanr@s5r6.in-berlin.de, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Tue, 2007-05-15 at 13:37 -0700, David Miller wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> Date: Tue, 15 May 2007 12:57:25 -0400
> 
> > It might make sense to put it in lib ... however, I don't think many
> > architectures have the problems we have ... specifically certain boxes
> > can have >1 IOMMU, then you really have to know *which* iommu you're
> > programming.
> 
> Sparc64 boxes will have this at some point, but what I'm
> going to do is simply fill in the dev_archdata properly at
> device scan time.
> 
> Instead of doing a bus walk up the parent every IOMMU request, why not
> cache those results in the dev_archdata?  That seems to make the most
> sense.

That is what we do ... except parisc caches the result in platform_data,
largely because dev_archdata wasn't around when the scheme was
concocted.  However, if we find a NULL platform_data we walk up the tree
until we find a non-NULL value and use that (IOMMUs are on a
disconnected bus topology).

> If there is some probing complexity, catch not-setup dev_archdata at
> the IOMMU request, and slow path into a resolver of some sort.

Yes, that's where we do the walk if the cache is NULL.

James


