From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: switch to pci_alloc_irq_vectors
Date: Thu, 10 Nov 2016 07:48:20 +0100
Message-ID: <864f9185-4485-7903-8779-1b16f9a3bed9@suse.de>
References: <1478589145-74280-1-git-send-email-hare@suse.de>
 <20161108145802.GB12817@lst.de>
 <81600b31-5977-f323-6609-7fc2e0ce55b0@suse.de>
 <20161108150149.GB13184@lst.de>
 <214a7d50-672e-bc5e-1dd3-c0c5e8366911@suse.de>
 <20161109213916.GA31665@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46463 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752621AbcKJGsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Nov 2016 01:48:22 -0500
In-Reply-To: <20161109213916.GA31665@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Don Brace <don.brace@microsemi.com>

On 11/09/2016 10:39 PM, Christoph Hellwig wrote:
> On Tue, Nov 08, 2016 at 04:02:54PM +0100, Hannes Reinecke wrote:
>>> I've looked at the them but haven't started work, so feel free to go
>>> ahead.  The MSI-X handling in mpt3sas is pretty nasty, so be careful.
>>>
>>> I've also started playing with lpfc, something I'll need to send to
>>> you and James for testing and feedback soon.
>>>
>> Bah. Another duplicate then.
>> Let's see who is faster :-)
> 
> Here are the lpfc patches - note that it's in a branch that merges
> the recent irq affinity changes from the tip tree into the scsi tree
> first, as we need updates from both of them:
> 
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/lpfc-msix
> 
What I find quite irritating is that we still have to call
irq_set_affinity_hint(irq, NULL) when freeing up interrupts.
Can't we roll that into the call to free_irq() ?
Thing is, we're not _calling_ irq_set_affinity_hint() when setting up
the interrupt, so it'll be one of the things which will be easily forgotten.

And you _do_ have to setup a cpumap within the driver :-)

Anyway, remainder looks pretty close to what I've written up.
Feel free to add my 'Reviewed-by:' to it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
