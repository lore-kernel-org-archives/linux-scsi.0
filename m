From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: How to directly pass a dma physical address and length from
	SCSI upper layer to LLD without mapping the dma memory to kernel pages
Date: Mon, 09 Jun 2008 16:43:57 -0500
Message-ID: <1213047837.3508.85.camel@localhost.localdomain>
References: <6B24EEDBA38D764293B27C04FE414CC64E40604DE0@G1W0491.americas.hpqcorp.net>
	 <1213045577.3508.79.camel@localhost.localdomain>
	 <6B24EEDBA38D764293B27C04FE414CC64E40604E33@G1W0491.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40386 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366AbYFIVoA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 17:44:00 -0400
In-Reply-To: <6B24EEDBA38D764293B27C04FE414CC64E40604E33@G1W0491.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Pan, Weimin" <weimin.pan@hp.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

[please don't drop the mailing list from the cc because others might be
interested]

On Mon, 2008-06-09 at 21:19 +0000, Pan, Weimin wrote:
> One simple example is a router. If I want to router data from one
> interface (front-end) to another (back-end), I only need to know where
> the data is (physical memory address DMAed in). I can pass this
> address to another interface driver to move the data out (DMAed out).

There's not really such thing as a "router" use for the SCSI mid-layer.
The closest we come is the target infrastructure.  For user space
implementations like STGT there's no choice, the vma is what you have to
hang the implementation on.  For kernel implementations like SCST you
can get away without having any mappings.

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

Then you want to look at how STGT does it (in fact, you probably want to
be using STGT because that's the way it was designed).  However, there's
no getting away from the need for a user space mapping for the data in
that case.  On the flip side, there's not a huge performance overhead
having the mapping set up.  If you don't have a mapping somewhere, the
pages aren't pinned in the page cache and may be reused.

James


