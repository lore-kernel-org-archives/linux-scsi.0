From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/10] mpt3sas: switch to pci_alloc_irq_vectors
Date: Thu, 16 Feb 2017 11:01:52 +0100
Message-ID: <e5d05b3c-48ca-1c85-92fd-260526a162f5@suse.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de>
 <1485854760-122683-2-git-send-email-hare@suse.de>
 <CAK=zhgoV2d1e9CuiPyXO6cj-vzYSsuYduG_xp3h9zBm=ma8V0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40602 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753537AbdBPKBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 05:01:54 -0500
In-Reply-To: <CAK=zhgoV2d1e9CuiPyXO6cj-vzYSsuYduG_xp3h9zBm=ma8V0A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 02/16/2017 10:32 AM, Sreekanth Reddy wrote:
> On Tue, Jan 31, 2017 at 2:55 PM, Hannes Reinecke <hare@suse.de> wrote:
>> Cleanup the MSI-X handling allowing us to use
>> the PCI-layer provided vector allocation.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 100 +++++++++++++++++-------------------
>>  drivers/scsi/mpt3sas/mpt3sas_base.h |   2 -
>>  2 files changed, 46 insertions(+), 56 deletions(-)
>>
[ .. ]
>>
>>         ioc->msix_enable = 1;
>> -       for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++) {
>> -               r = _base_request_irq(ioc, i, a->vector);
>> +       ioc->msix_vector_count = r;
> 
> Here we should also reinitialize ioc->reply_queue_count if
> pci_alloc_irq_vectors returns with value less than requested MSIx
> vector count (i.e. ioc->reply_queue_count).
> 
Sigh. The usual confusion between 'reply_queue_count' and
'msix_vector_count'.

I have _tried_ to make 'reply_queue_count' the number of _allocated_
reply queues, and 'msix_vector_count' the number of MSI-x vectors allocated.
As pci_alloc_irq_vectors might be returning less vectors than specified
(but we don't modify the allocation for reply_queue_count in that case)
I considered it an error to modify reply_queue_count, too.

But I'd _very_ much appreciate if we could clear up the confusion and
fix the meaning of 'reply_queue_count' and 'msix_vector_count'.
ATM I don't think we have a consistent usage here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
