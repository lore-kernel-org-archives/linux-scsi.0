From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Mon, 17 Mar 2008 08:59:22 -0500
Message-ID: <1205762362.6767.123.camel@localhost.localdomain>
References: <20080307653.720459648@firstfloor.org>
	 <20080307175408.E290E1B41AE@basil.firstfloor.org>
	 <1205445980.2893.85.camel@localhost.localdomain>
	 <20080314134814.GS17940@kernel.dk>
	 <20080314135945.GO2522@one.firstfloor.org>
	 <20080317082711.GB17940@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43980 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbYCQN7Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 09:59:25 -0400
In-Reply-To: <20080317082711.GB17940@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org

On Mon, 2008-03-17 at 09:27 +0100, Jens Axboe wrote:
> > In my original patchkit I didn't have blk_kmalloc etc. but just relied 
> > on the block layer bouncing everything for ISA as needed, but James
> > thought it was important that SCSI LUN scan etc do not bounce for ISA.
> > That is when I came up with these helpers.
> > 
> > You think it should go back to always bouncing? That would be fine
> > for me too. With that they wouldn't be needed.
> 
> I don't see a reason for not bouncing for scanning - James?

If we didn't know the allocation mask, or it was hard to get, then yes,
I'd agree.  However, I think that any time the kernel has the device
mask available, it should actually use it for an allocation to avoid
bouncing.

James


