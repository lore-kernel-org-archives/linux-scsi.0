From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Thu, 10 Nov 2016 15:50:05 +0100
Message-ID: <f33b4673-3640-f7a9-dba1-6a4bf22f2238@suse.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de>
 <20161108145802.GB12817@lst.de>
 <81600b31-5977-f323-6609-7fc2e0ce55b0@suse.de>
 <20161108150149.GB13184@lst.de>
 <214a7d50-672e-bc5e-1dd3-c0c5e8366911@suse.de>
 <20161109213916.GA31665@lst.de>
 <864f9185-4485-7903-8779-1b16f9a3bed9@suse.de> <20161110144802.GA5984@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34661 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933572AbcKJOuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 09:50:10 -0500
In-Reply-To: <20161110144802.GA5984@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

On 11/10/2016 03:48 PM, Christoph Hellwig wrote:
> On Thu, Nov 10, 2016 at 07:48:20AM +0100, Hannes Reinecke wrote:
>> What I find quite irritating is that we still have to call
>> irq_set_affinity_hint(irq, NULL) when freeing up interrupts.
>> Can't we roll that into the call to free_irq() ?
> 
> If you do call it that's irritation, because you should not call
> irq_set_affinity_hint ever if you are using PCI_IRQ_AFFINITY, and
> the above branch doesn't call it.
> 
Ah. Sorry to have misread that.

>> And you _do_ have to setup a cpumap within the driver :-)
> 
> For the non-mq case, yes - but only to keep the functionality
> as-is.  We shouldn't add anything like this to a new driver.
> 
>> Anyway, remainder looks pretty close to what I've written up.
>> Feel free to add my 'Reviewed-by:' to it.
> 
> I'm mostly looking for someone who has the hardware to actually
> test it, though.
> 
Ah. Right.

Will give it a spin tomorrow.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
