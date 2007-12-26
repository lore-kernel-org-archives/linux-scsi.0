From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/7] sg_ring: convert core ATA code to sg_ring.
Date: Wed, 26 Dec 2007 11:12:59 -0600
Message-ID: <1198689179.3317.16.camel@localhost.localdomain>
References: <200712191731.26512.rusty@rustcorp.com.au>
	 <200712191836.06769.rusty@rustcorp.com.au>
	 <200712191837.04697.rusty@rustcorp.com.au>
	 <200712191838.27363.rusty@rustcorp.com.au>  <47721294.7030401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <47721294.7030401@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 2007-12-26 at 17:36 +0900, Tejun Heo wrote:
> (PS, I haven't followed the sg chaining discussion.  Why is sg chaining
> an optional feature?  Performance overhead on low end machines?)

The idea of SG chaining is to allow drivers that wish to take advantage
of it to increase their transfer lengths beyond
MAX_HW_SEGMENTS*PAGE_SIZE by using chaining.  However, drivers that stay
below MAX_HW_SEGMENTS for the scatterlist length don't need to be
altered.

The ultimate goal (well, perhaps more wish) is to have all drivers
converted, so SCSI can use something small for the default scatterlist
sizing and dump all the sglist mempool stuff (although this may never be
reached).

James


