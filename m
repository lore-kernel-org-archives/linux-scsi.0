From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 15:28:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40424B86.3000703@pobox.com>
References: <4041292C.3090700@pobox.com> <20040229091350.GC3149@suse.de> <137982704.1078081053@aslan.btc.adaptec.com> <404236C1.5000001@pobox.com> <156412704.1078082931@aslan.btc.adaptec.com> <40423F7B.4020102@pobox.com> <162922704.1078083749@aslan.btc.adaptec.com> <4042410C.7070701@pobox.com> <20040229200636.GI31904@suse.de> <404249AA.4050808@pobox.com> <20040229202742.GJ31904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:10706 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262131AbUB2U3G
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 15:29:06 -0500
In-Reply-To: <20040229202742.GJ31904@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Jens Axboe wrote:
> On Sun, Feb 29 2004, Jeff Garzik wrote:
> 
>>Jens Axboe wrote:
>>
>>>Don't forget that this isn't the only condition. What about pci dma
>>>mapping failures?
>>
>>
>>hehe, granted there might be other conditions, but for PCI DMA mapping 
>>specifically, it is (unfortunately) currently defined to not fail.
> 
> 
> Which is bogus and must be changed anyways... Besides, that was just one
> example. There could be other resource shortages that can happen which
> prevent queueing.

Agreed.


>>That wants changing for ppc64 and x86-64 iommu, which are a -lot- more 
>>likely to fail an iommu transaction than parisc or sparc64... but that's 
>>the way it is for now.  Way too many drivers assume PCI DMA mapping 
>>always succeeds.
> 
> 
> I just don't like _at all_ that it's assumed it cannot fail, when in
> fact it _can_ fail. Likeliness just means it's less of a problem for
> those archs, it's still an eye sore.

I agree with you completely...  but the current PCI DMA API is reality. 
  We just need to change reality.  :)

	Jeff



