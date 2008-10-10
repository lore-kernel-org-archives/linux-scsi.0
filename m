From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: pass through support: question: blk_rq_map_sg() usage...
Date: Fri, 10 Oct 2008 10:28:03 +0900
Message-ID: <20081010100102W.fujita.tomonori@lab.ntt.co.jp>
References: <F86BE6EA-AE56-4780-96A4-01C67625C0D5@qlogic.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:45469 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381AbYJJB2Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Oct 2008 21:28:16 -0400
In-Reply-To: <F86BE6EA-AE56-4780-96A4-01C67625C0D5@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: seokmann.ju@qlogic.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Smart@Emulex.Com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

On Thu, 9 Oct 2008 11:08:37 -0700
Seokmann Ju <seokmann.ju@qlogic.com> wrote:

> I've got a quick question on the blk_rq_map_sg() API usage.
> In an efforts of implementing pass through support on FC transport  
> layer, the transport would call blk_rq_map_sg() API to map the pages  
> in the bio structure so that the LLD could DMA to/from the mapped  
> addresses - as specified in the section 2.2 of the ~/Documentation/ 
> block/biodoc.txt.
> To me, it seems like a right way to do..., could anyone comment on  
> this approach?

Sounds reasonable for me.

fc transport calls blk_rq_map_sg() and then llds easily call
dma_map_sg and do DMA transfer.


> Also, I couldn't find symmetric counter-part for the API (i.e.,  
> blk_rq_unmap_sg() or similar).
> Does this means that we don't need to unmap those addresses?

There is no symmetric counterpart for blk_rq_unmap_sg. All you need to
do is to free scatter lists. dma_map_sg maps addresses in scatter
lists to DMA-capable addresses. So you need to call its symmetric
counterpart, dma_unmap_sg after the completion of DMA transfer.
