From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: pass through support: question: blk_rq_map_sg() usage...
Date: Fri, 10 Oct 2008 06:26:38 -0700
Message-ID: <CD8CD8F6-4762-43D0-BC96-6D0695C5DB76@qlogic.com>
References: <F86BE6EA-AE56-4780-96A4-01C67625C0D5@qlogic.com> <20081010100102W.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:18297 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbYJJN0k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Oct 2008 09:26:40 -0400
In-Reply-To: <20081010100102W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org


On Oct 9, 2008, at 6:28 PM, FUJITA Tomonori wrote:

> On Thu, 9 Oct 2008 11:08:37 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>
>> I've got a quick question on the blk_rq_map_sg() API usage.
>> In an efforts of implementing pass through support on FC transport
>> layer, the transport would call blk_rq_map_sg() API to map the pages
>> in the bio structure so that the LLD could DMA to/from the mapped
>> addresses - as specified in the section 2.2 of the ~/Documentation/
>> block/biodoc.txt.
>> To me, it seems like a right way to do..., could anyone comment on
>> this approach?
>
> Sounds reasonable for me.
>
> fc transport calls blk_rq_map_sg() and then llds easily call
> dma_map_sg and do DMA transfer.
Yes,  figured out that it needs to call dma_map_sg() after the  
blk_rq_map_sg().

>
>
>
>> Also, I couldn't find symmetric counter-part for the API (i.e.,
>> blk_rq_unmap_sg() or similar).
>> Does this means that we don't need to unmap those addresses?
>
> There is no symmetric counterpart for blk_rq_unmap_sg. All you need to
> do is to free scatter lists. dma_map_sg maps addresses in scatter
> lists to DMA-capable addresses. So you need to call its symmetric
> counterpart, dma_unmap_sg after the completion of DMA transfer.
OK. Thanks for the clarification.

Seokmann
