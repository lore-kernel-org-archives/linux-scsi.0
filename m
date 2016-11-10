From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Thu, 10 Nov 2016 15:48:02 +0100
Message-ID: <20161110144802.GA5984@lst.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de> <20161108145802.GB12817@lst.de> <81600b31-5977-f323-6609-7fc2e0ce55b0@suse.de> <20161108150149.GB13184@lst.de> <214a7d50-672e-bc5e-1dd3-c0c5e8366911@suse.de> <20161109213916.GA31665@lst.de> <864f9185-4485-7903-8779-1b16f9a3bed9@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38253 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933572AbcKJOsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 09:48:04 -0500
Content-Disposition: inline
In-Reply-To: <864f9185-4485-7903-8779-1b16f9a3bed9@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

On Thu, Nov 10, 2016 at 07:48:20AM +0100, Hannes Reinecke wrote:
> What I find quite irritating is that we still have to call
> irq_set_affinity_hint(irq, NULL) when freeing up interrupts.
> Can't we roll that into the call to free_irq() ?

If you do call it that's irritation, because you should not call
irq_set_affinity_hint ever if you are using PCI_IRQ_AFFINITY, and
the above branch doesn't call it.

> And you _do_ have to setup a cpumap within the driver :-)

For the non-mq case, yes - but only to keep the functionality
as-is.  We shouldn't add anything like this to a new driver.

> Anyway, remainder looks pretty close to what I've written up.
> Feel free to add my 'Reviewed-by:' to it.

I'm mostly looking for someone who has the hardware to actually
test it, though.
