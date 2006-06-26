From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [29/82] x86_64: Rename IOMMU option, fix help and mark option embedded.
Date: Mon, 26 Jun 2006 08:24:45 +0200
Message-ID: <200606260824.45506.ak@suse.de>
References: <449C852C.mailCZT11F9YB@suse.de> <200606252132.41121.ak@suse.de> <20060625222115.GA17213@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:58329 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S964832AbWFZGY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jun 2006 02:24:58 -0400
In-Reply-To: <20060625222115.GA17213@devserv.devel.redhat.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: torvalds@osdl.org, discuss@x86-64.org, akpm@osdl.org, markh@osdl.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Monday 26 June 2006 00:21, Alan Cox wrote:
> On Sun, Jun 25, 2006 at 09:32:41PM +0200, Andi Kleen wrote:
> > > From a tiny 16MB DMA pool that can't sustain the required load ? Or has that
> > > bit changed.
> > 
> > It should be ok because it blocks. It will be slow, but what else do you expect
> > from broken hardware like this? 
> 
> Sustained 80Mbyte/second I/O rates. At least thats what it gets in other OS
> products. This is one of the reasons (broadcomm 4400 was another) that a 30
> or 31 bit DMA zone not a 32bit one was called for, which also didn't happen
> it seems.

Should we hurt everybody for two terminally broken devices?

BCM4400 and its wireless brethen is fine with GFP_DMA btw and mostly only 
exists in low end machines where most/all of the memory is below 2GB anyways
(so the check first approach works quite well) 

> 
> The ifdef approach isnt perfect but it essentially means you get good
> performance on x86-32 and only x86-64 has problems which seems fine to me,
> because its an old card.

Blk-bounce would have the same effect.

If you set blk-bounce then the block layer will only bounce if the
address is < limit and it knows about the different zones on 32bit
and will use GFP_NORMAL there.

If you have upto 6GB you have a 50:50% chance of not bouncing at least.

The ifdef approach is just broken. Please fix it.

-Andi
