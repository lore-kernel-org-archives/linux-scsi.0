From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: blk-mq vs kmemleak
Date: Mon, 3 Aug 2015 18:50:53 +0100
Message-ID: <20150803175053.GF11772@e104818-lin.cambridge.arm.com>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
 <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
 <559BDB49.70209@sandisk.com>
 <20150708081740.GA3374@infradead.org>
 <55BC14AE.3090200@sandisk.com>
 <20150803104309.GB4033@e104818-lin.cambridge.arm.com>
 <55BF9F77.90906@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([146.101.78.143]:30028 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbbHCRu4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2015 13:50:56 -0400
In-Reply-To: <55BF9F77.90906@sandisk.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>

On Mon, Aug 03, 2015 at 06:05:59PM +0100, Bart Van Assche wrote:
> On 08/03/2015 03:43 AM, Catalin Marinas wrote:
> > The pages allocated for struct request contain pointers to other slab
> > allocations (via ops->init_request). Since kmemleak does not track/scan
> > page allocations, the slab objects will be reported as leaks (false
> > positives). This patch adds kmemleak callbacks to allow tracking of such
> > pages.
> >
> > Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
> > Reported-by: Bart Van Assche<bart.vanassche@sandisk.com>
> 
> That patch works fine on my test setup, hence:
> 
> Tested-by: Bart Van Assche<bart.vanassche@sandisk.com>

Thanks for testing.

Cc'ing the block layer maintainer since the patches touches this part.
Jens, are you ok with the patch posted below? If yes, would you like me
to re-post or you're happy to pick it up from the list:

http://lkml.kernel.org/r/20150803104309.GB4033@e104818-lin.cambridge.arm.com

Thanks.

-- 
Catalin

