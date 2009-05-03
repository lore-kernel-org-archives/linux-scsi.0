From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add	block/blk-map.c:blk_rq_map_kern_sg()
 usage
Date: Sun, 03 May 2009 16:32:35 +0300
Message-ID: <49FD9CF3.5070005@panasas.com>
References: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>	 <49F97157.4070901@panasas.com> <1241118643.32740.517.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:7541 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751627AbZECNfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 May 2009 09:35:02 -0400
In-Reply-To: <1241118643.32740.517.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>

On 04/30/2009 10:10 PM, Nicholas A. Bellinger wrote:
> On Thu, 2009-04-30 at 12:37 +0300, Boaz Harrosh wrote:
>>> Currently *without* the blk-map patches on v2.6.30-rc3, is target_core_mod/pSCSI export is
>>> limited to TYPE_DISK and TYPE_ROM that reference a struct block_device using the ConfigFS
>>> 'file descriptor' method.  This is because bio_add_page() expects struct block_device to be
>> Better use bio_add_pc_page(). bio_add_page is only meant for fs requests.
>>
> 
> <nod>, I was only using bio_add_page() in the pre v2.6.30 code for
> target_core_mod/pSCSI because bio_add_pc_page() is not exported from
> fs/bio.c.  Perhaps since bio_add_pc_page() is intended to be for SCSI
> target mode with struct request it should be EXPORT_SYMBOL_GPL()..?
> 

It is very much exported with plain EXPORT_SYMBOL(). If not then I would have
trouble in exofs as a module and so will lots of other Kernel modules. It is
used in more then one place.

>>> each struct bio associated with the struct request w/o Tejun's blk_rq_map_kern_sg().
>>>
>>> Thanks Tejun for this patch series!  Things have been stable so far and I hope to try some
>>> 'bare-metal' and IOV enabled Linux/SCSI target exports using this patch series, along with validating
>>> blk-map on some non TYPE_DISK exports using target_core_mod/pSCSI.  I believe you intend this series for
>>> v2.6.31 correct..? 
>>>
>>> Boaz, have you had a chance to port your stuff over to this yet..?  Other comments..?
>>>
>> No. As I said, these patches were not good for me. I do not have scatterlist at all.
>> I have a pre-made bio, both from filesystem and a block device. So my needs are different.
> 
> Understood..
> 
>> Please note that the patches as last sent, were not good in my opinion, for regressing on
>> some robustness and performance issues.
>>
>> There might be another solution for you, BTW. I'll be reposting a James Bottomley's
>> patch in 1-2 days that makes blk_rq_map_kern() append the buffers it receives instead
>> of only supporting a single call. So you can allocate the request and call blk_rq_map_kern()
>> in a loop for-each-sg. The bad thing with this is that the biovec inside will be allocated
>> multiple times, jumping from small pools to bigger ones.
> 
> Ok, I will plan on testing both methods (single call
> blk_rq_map_kern_sg() vs. appending buffers with blk_rq_map_kern()) using
> the pSCSI export on v2.6.30-rc3..
> 
>>  If only there was a way to specify a pre-allocated bio-size.
> 
> Hrrmm, can you explain a bit more about what this would entail..?  From
> the SCSI target API side, mapping a contigious array of struct

"contiguous" scatterlist array is only up to 128 max on x86_64. This is
the trivial case that is easy to implement with direct bio_xxx exported
calls. The problem start when we need chained scatterlist, to chained
bios, and do not want to invent the block-layer for that.

> scatterlist's from the caller into struct request (and struct bio) in
> place of bvec would still make the most sense I think.
> 

If you want to consider long term. Then I think Tejum's suggestion is best.
That is: To separate scatterlist into a virtual-part and physical-dma-part.
The former just being a reincarnation of bvec (Held at bio as you imagined)
and the later filled and returned by IOMMUs.

> In the OSD case where you are already passing into pre-formatted bio's
> it would be up to the caller to format and validate the your pages via
> an internally allocated (or preallocated) array of scatterlists.
> 

No, in the OSD case I receive a bio that was either built by the block-layer
itself, in the case of a stacking block device, or one built from a filesystem
with the use of exported bio API, that is bio_alloc+bio_add_pc_page*128.

So if bio will use the new-scatterlist internally, it will not affect any of
OSD code since it tries not to touch any bio internal parts.

> Anyways, I will think about it some more and see what can be found..
> 

Yes, time will tell. One good thing is that things are chainging and
a solution will present itself.

Boaz
