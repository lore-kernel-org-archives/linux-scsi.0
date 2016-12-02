From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] mpt3sas: switch to pci_alloc_irq_vectors
Date: Fri, 2 Dec 2016 15:45:50 +0100
Message-ID: <300db668-b679-3a2b-2f0b-cce50f645bde@suse.de>
References: <1480679607-79306-1-git-send-email-hare@suse.de>
 <20161202143036.GB31264@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55157 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752602AbcLBOpy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 09:45:54 -0500
In-Reply-To: <20161202143036.GB31264@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 12/02/2016 03:30 PM, Christoph Hellwig wrote:
>> +static inline u16
>>  _base_get_msix_index(struct MPT3SAS_ADAPTER *ioc)
>>  {
>> +	return pci_irq_get_affinity_vector(ioc->pdev, raw_smp_processor_id());
>>  }
>
> This looks extremely sketchy. Are we guaranteed to always have enough
> MSI-X vectors that each CPU has it's own?  I'd much prefer to keep the
> indirection array of the existing code.
>
Hmm. Okay. will be doing so.

>> +static int scsih_map_queues(struct Scsi_Host *shost)
>> +{
>> +	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
>> +
>> +	return blk_mq_pci_map_queues(&shost->tag_set, ioc->pdev, 0);
>> +}
>
> Given that mpt3sas only supports a single hardware queue (and doesn't
> set the nr_hw_queues field) this is pointless and won't have any effect.
>
Well, it does, actually.
But this is part of another patchset enabling 'real' mq support.
I'll be redoing the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
