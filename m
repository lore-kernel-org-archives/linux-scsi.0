From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Tue, 03 Mar 2009 10:49:15 -0600
Message-ID: <49AD5F8B.8060602@cs.wisc.edu>
References: <20090302145650.GW15340@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35098 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZCCQxO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Mar 2009 11:53:14 -0500
In-Reply-To: <20090302145650.GW15340@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

scameron@beardog.cca.cpqcorp.net wrote:
> [...]
>>> +/*
>>> + * For operations that cannot sleep, a command block is allocated at init,
>>> + * and managed by cmd_alloc() and cmd_free() using a simple bitmap to track
>>> + * which ones are free or in use.  Lock must be held when calling this.
>>> + * cmd_free() is the complement.
>>> + */
>>> +static struct CommandList_struct *cmd_alloc(struct ctlr_info *h)
>>> +{
>>> +     struct CommandList_struct *c;
>>> +     int i;
>>> +     union u64bit temp64;
>>> +     dma_addr_t cmd_dma_handle, err_dma_handle;
>>> +
>>> +     do {
>>> +             i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
>>> +             if (i == h->nr_cmds)
>>> +                     return NULL;
>>> +     } while (test_and_set_bit
>>> +              (i & (BITS_PER_LONG - 1),
>>> +               h->cmd_pool_bits + (i / BITS_PER_LONG)) != 0);
>> Using bitmap to manage free commands looks too complicated a bit to
>> me. Can we just use lists for command management?
> 
> Hmm, this doesn't seem all that complicated to me, and this code snippet
> has been pretty stable for about 10 years. it's nearly identical to what's in
> cpqarray in the 2.2.13 kernel from 1999:
> 
>                 do {
>                         i = find_first_zero_bit(h->cmd_pool_bits, NR_CMDS);
>                         if (i == NR_CMDS)
>                                 return NULL;
>                 } while(test_and_set_bit(i%32, h->cmd_pool_bits+(i/32)) != 0)
> 
> It's fast, works well, and has needed very little maintenance over the 
> years.  Without knowing what you have in mind specifically, I don't see a
> big need to change this.
> 

Other drivers have had to convert to and modify the host tagging to get 
merged. They too had stable and fast code, and we complained and fought 
against changing it :) I have had to convert or help convert libfc and 
qla4xxx and I will now convert iscsi, so I feel your pain :)

To create the map call scsi_init_shared_tag_map after you allocate the 
scsi host and before you add it. Then in slave_alloc set the 
sdev->tag_supported  = 1 and call scsi_activate_tcq. Then replace your 
bitmap with:

for scsi commands:

c = h->cmd_pool + scsi_cmnd->request->tag

And for the reset path I was thinking you could use my patch in the 
other mail and do

tag = blk_map_start_tag(scsi_host->bqt, NULL, 0);
if (tag < 0)
	goto fail;
c = h->cmd_pool + tag;
c->cmdindex = tag;

In the completion path you need to do a blk_map_end_tag(scsi_host->bqt, 
c->cmdindex);. The scsi/block layer will free the tag for scsi commadns.
