From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/5] add dma_max_segment_size option to scsi_host_template
Date: Wed, 26 Sep 2007 10:42:06 -0400
Message-ID: <46FA6FBE.2060100@garzik.org>
References: <20070925142144Z.tomof@acm.org>	<46FA3061.9060408@garzik.org> <20070925200037W.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49473 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbXIZOmU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 10:42:20 -0400
In-Reply-To: <20070925200037W.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> On Wed, 26 Sep 2007 06:11:45 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> FUJITA Tomonori wrote:
>>> This patch moves blk_queue_max_segment_size to scsi_alloc_queue from
>>> llds. It enables scsi_add_host to tells iommu lld's
>>> dma_max_segment_size. If a low-level driver doesn't specify
>>> dma_max_segment_size, scsi-ml uses 65536 (MAX_SEGMENT_SIZE). So there
>>> are not any functional changes.
>>>
>>> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>>> ---
>>>  drivers/scsi/hosts.c     |    5 +++++
>>>  drivers/scsi/scsi_lib.c  |    1 +
>>>  include/scsi/scsi_host.h |    6 ++++++
>>>  3 files changed, 12 insertions(+), 0 deletions(-)
>> hmmmmm...  All the patches look technically correct, but IMO this really 
>> should behave more the the dma_mask interface:  platform sets a sane 
>> dma_mask (usually 0xffffffff), and LLDD calls dma_set_mask() or 
>> pci_set_dma_mask().
>>
>> Thus, IMO an LLDD should call dma_set_max_seg(), and then SCSI midlayer 
>> can obtain that value from struct device.
> 
> Yeah, I agreed that max_segment_size should work like dma_mask (that's
> why I simply put max_segment_size to device structure).

Yep!


> scsi_debug doesn't use dma but calls blk_queue_max_segment_size (I
> guess that it wants large I/Os). If we can remove it (thanks to
> chaining sg), scsi-ml gets that value that llds set via
> dma_set_max_seg and calls blk_queue_max_segment_size.

[/me checks the code]  Actually scsi_debug has its own pseudo-bus and 
struct device, so it sounds like scsi_debug can call dma_set_max_seg() 
just like any other LLDD?

Maybe dev_set_max_seg() is a better name, if people get really picky (I 
don't care).

	Jeff


