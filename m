From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/17] scsi: add support for per-host cmd pools
Date: Fri, 7 Feb 2014 04:46:40 -0800
Message-ID: <20140207124640.GC30510@infradead.org>
References: <20140205123930.150608699@bombadil.infradead.org>
 <20140205124019.946278511@bombadil.infradead.org>
 <52F4A8C4.8080602@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33605 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbaBGMqp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 07:46:45 -0500
Content-Disposition: inline
In-Reply-To: <52F4A8C4.8080602@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Fri, Feb 07, 2014 at 03:35:00AM -0600, Mike Christie wrote:
> It seems there is a issue with using the cmd_size to indicate the driver
> has its own cmd pool and also using that for scsi mq enabled drivers to
> indicate that we want the LLD's struct allocated by blk/scsi mq.
> 
> If a driver sets cmd_size for only the scsi/blk mq purpose, this patch
> wants the driver to also setup a cmd pool which I do not think is used
> when doing scsi/blk mq.

I don't quite understand what you mean.  cmd_size means that each
scsi_cmnd passed to the driver will have additional per-driver data.

For the old path it's implemented by creating a slab cache and storing
it in the host template to easily find it, for blk-mq it is used to
increase the allocation in the block core as scsi doesn't do it's own
allocations in this case.

Very different implementation underneath, but same effect for the
driver.
