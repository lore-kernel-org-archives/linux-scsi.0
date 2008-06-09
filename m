From: "Pan, Weimin" <weimin.pan@hp.com>
Subject: RE: How to directly pass a dma physical address and length from
	SCSI upper layer to LLD without mapping the dma memory to kernel pages
Date: Mon, 9 Jun 2008 21:53:00 +0000
Message-ID: <6B24EEDBA38D764293B27C04FE414CC64E40604E8F@G1W0491.americas.hpqcorp.net>
References: <6B24EEDBA38D764293B27C04FE414CC64E40604DE0@G1W0491.americas.hpqcorp.net>
	 <1213045577.3508.79.camel@localhost.localdomain>
	 <6B24EEDBA38D764293B27C04FE414CC64E40604E33@G1W0491.americas.hpqcorp.net>
 <1213047837.3508.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:40858 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYFIVx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 17:53:28 -0400
In-Reply-To: <1213047837.3508.85.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>> One simple example is a router. If I want to router data from one
>> interface (front-end) to another (back-end), I only need to know where
>> the data is (physical memory address DMAed in). I can pass this
>> address to another interface driver to move the data out (DMAed out).

>There's not really such thing as a "router" use for the SCSI mid-layer.
>The closest we come is the target infrastructure.  For user space implementations like STGT there's no choice, the vma is what >you have to hang the implementation on.  For kernel implementations like SCST you can get away without having any mappings.

How can you get away without having any mappings in SCST? Do you mean that we can pass physical S/G list without mapping these physical memory into kernel space? Since we have large physical memory (>1GB), there is a performance hit by mapping it into kernel space using HI_MEM.


>> But I like to put the command process in user space. So I only need to
>>know where the data is (from ioctl) and pass this to sg driver (for
>> example). Right now, I can pass a S/G list to sg but sg driver assumes
>> it is a virtual memory address list. I don't mind to write a new upper
>> layer driver to handle physical address S/G instead of user space
>> virtual address S/G. But I don't want to change middle layer and LLD
>> interface. I saw middler layer passes scatterlist to LLD. But LLD
>> always assumes the scatterlist's page_link is set and dma_address is
>> not set. Is it possible that I set up dma_address=phy memory address
>> and page_link=0? I just don't understand why SCSI subsystem doesn't
>> clearly define this usage model.

>Then you want to look at how STGT does it (in fact, you probably want to be using STGT because that's the way it was
>designed).  However, there's no getting away from the need for a user space mapping for the data in that case.  On the flip
>side, there's not a huge performance overhead having the mapping set up.  If you don't have a mapping somewhere, the pages
>aren't pinned in the page cache and may be reused.

I thought that SCST has a virtual user mode handler which can do the cmd process in user space (the same as STGT). Is that a true statement?

Weimin

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Monday, June 09, 2008 4:44 PM
To: Pan, Weimin
Cc: linux-scsi
Subject: RE: How to directly pass a dma physical address and length from SCSI upper layer to LLD without mapping the dma memory to kernel pages

[please don't drop the mailing list from the cc because others might be interested]

On Mon, 2008-06-09 at 21:19 +0000, Pan, Weimin wrote:
> One simple example is a router. If I want to router data from one
> interface (front-end) to another (back-end), I only need to know where
> the data is (physical memory address DMAed in). I can pass this
> address to another interface driver to move the data out (DMAed out).

There's not really such thing as a "router" use for the SCSI mid-layer.
The closest we come is the target infrastructure.  For user space implementations like STGT there's no choice, the vma is what you have to hang the implementation on.  For kernel implementations like SCST you can get away without having any mappings.

> But I like to put the command process in user space. So I only need to
> know where the data is (from ioctl) and pass this to sg driver (for
> example). Right now, I can pass a S/G list to sg but sg driver assumes
> it is a virtual memory address list. I don't mind to write a new upper
> layer driver to handle physical address S/G instead of user space
> virtual address S/G. But I don't want to change middle layer and LLD
> interface. I saw middler layer passes scatterlist to LLD. But LLD
> always assumes the scatterlist's page_link is set and dma_address is
> not set. Is it possible that I set up dma_address=phy memory address
> and page_link=0? I just don't understand why SCSI subsystem doesn't
> clearly define this usage model.

Then you want to look at how STGT does it (in fact, you probably want to be using STGT because that's the way it was designed).  However, there's no getting away from the need for a user space mapping for the data in that case.  On the flip side, there's not a huge performance overhead having the mapping set up.  If you don't have a mapping somewhere, the pages aren't pinned in the page cache and may be reused.

James


