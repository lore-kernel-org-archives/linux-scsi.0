From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Wed, 03 Oct 2007 13:57:37 -0400
Message-ID: <4703D811.90507@garzik.org>
References: <3ae72650710020823j17219ab5u6c2aefe491884ca6@mail.gmail.com>	<20071002152534.GT12049@parisc-linux.org>	<20071002164413.GA12571@suse.de> <20071003231034P.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:50259 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbXJCR7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 13:59:04 -0400
In-Reply-To: <20071003231034P.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: gregkh@suse.de, matthew@wil.cx, kay.sievers@vrfy.org, James.Bottomley@steeleye.com, jens.axboe@oracle.com, hch@infradead.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

FUJITA Tomonori wrote:
> On Tue, 2 Oct 2007 09:44:13 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
>> On Tue, Oct 02, 2007 at 09:25:34AM -0600, Matthew Wilcox wrote:
>>> On Tue, Oct 02, 2007 at 05:23:39PM +0200, Kay Sievers wrote:
>>>> Just looking at the number of devices, it seems that allocating it
>>>> dynamically would be the better deal. We allocate the name of every
>>>> kobject dynamically today, so I guess it's fine to do that with the
>>>> DMA data too.
>>> But we don't need to allocate it dynamically.  We can embed it in the
>>> pci_dev, eisa_dev, zorro_dev, mca_dev and parisc_device.
>> But then you run into the issue that James pointed out originally.
>>
>> Anyway, I don't care which, let's see some patches :)
> 
> How about this (based on James' proposal)?
> 
> - Currently, there are only max_segment_size and segment_boundary_mask
> in struct device_dma_parameters (I'll add segment_boundary_mask
> support later after I finish the iommu part). We'll move more dma
> stuff in struct device (like dma_mask) to struct device_dma_parameters
> later (needs some cleanups before that).
> 
> - New accessors for the dma parameters are added. So we can easily
> change where to place struct device_dma_parameters in the future.
> 
> - the default max_segment_size is set to 64K, same to the block
> layer's default value.

ACK


