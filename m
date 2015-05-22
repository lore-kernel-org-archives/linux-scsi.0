From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] hpsa: Controller lockup detected: 0x00150028
Date: Fri, 22 May 2015 18:40:02 +0200
Message-ID: <20150522164002.GJ3644@twins.programming.kicks-ass.net>
References: <20150518124058.GH21418@twins.programming.kicks-ass.net>
 <EC48209BE0009041A0D3C6A996EAD2AE27A7FAEE@G9W0754.americas.hpqcorp.net>
 <20150518152034.GC5404@twins.programming.kicks-ass.net>
 <20150518160345.GA18673@twins.programming.kicks-ass.net>
 <20150518161146.GB18673@twins.programming.kicks-ass.net>
 <555F46F4.2090002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794AbbEVQkH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2015 12:40:07 -0400
Content-Disposition: inline
In-Reply-To: <555F46F4.2090002@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "Oelke, Mark" <mark.oelke@hp.com>, "don.brace@pmcs.com" <don.brace@pmcs.com>, ISS StorageDev <iss_storagedev@hp.com>, "storagedev@pmcs.com" <storagedev@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, May 22, 2015 at 05:10:44PM +0200, Tomas Henzl wrote:
> >> I've updated to 6.62 and it appears to be working now; or rather, it has

I've since gotten 6.64 from HP to test; which does not seem public yet.

6.64 actually fixes the issue for me.

> An older issue for mptsas seems to handle a similar case
> 2a1b7e575b [SCSI] mptsas: fix hangs caused by ATA pass-through
> that might be for hpsa -

> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -1067,6 +1067,8 @@ static int hpsa_slave_alloc(struct scsi_device *sdev)
>         if (sd != NULL)
>                 sdev->hostdata = sd;
>         spin_unlock_irqrestore(&h->devlock, flags);
> +
> +       blk_queue_dma_alignment (sdev->request_queue, 512 - 1);
>         return 0;
>  }

That does indeed seem _very_ similar; I'll have to defer to Mark Oelke
and or Don Brace to say if the above is a useful alternative. Since they
seem to now know what was the root cause.
