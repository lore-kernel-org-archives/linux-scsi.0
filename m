From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: How to directly pass a dma physical address and length from
	SCSI upper layer to LLD without mapping the dma memory to kernel pages
Date: Mon, 09 Jun 2008 16:06:17 -0500
Message-ID: <1213045577.3508.79.camel@localhost.localdomain>
References: <6B24EEDBA38D764293B27C04FE414CC64E40604DE0@G1W0491.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:34153 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbYFIVGV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 17:06:21 -0400
In-Reply-To: <6B24EEDBA38D764293B27C04FE414CC64E40604DE0@G1W0491.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Pan, Weimin" <weimin.pan@hp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2008-06-09 at 20:52 +0000, Pan, Weimin wrote:
> SCSI upper layer can pass a scatterlist to middle layer and LLD.
> Normally the page_link, length, and offset is set in the scatterlist.
> LLD will convert to dma_address from pages by itself. That means the
> dma physical memory has to map to kernel memory space before it can be
> passed to LLD for data transfer.

Actually, it's for exactly the reason that we *don't* want to map the
data into kernel space that we use scatterlists.  A scatterlist has the
struct page (what you call the page link) which can be used to convert
to dma_address independently of any virtual mapping.

If you're saying that the submission path from user space has to have a
mapping, then yes ... for the reason that the user presumably had
something to do with the data they're requesting ...

>  If I have a large dma memroy and it doesn't need to be touched by
> kernel or user mode Apps, it is a performance penalty to force to do
> that.

I don't quite see how a user application needs to do disk I/O on data it
doesn't touch.  If you're writing out, what are you writing out and if
you're reading in, you're not likely to throw the data away are you?
Somewhere, somehow, the data has to be made visible to the user
application ... and via memory mappings are pretty standard ways of
doing it.

> Is there a way to directly pass a dma physical address from upper
> layer to LLD (like use dma_address in a scatterlist)?
> I looked at a couple of LLD drivers and none of them handle this kind
> of situation.

Tell us where the data comes from if it's not in the application address
space and we might be better placed to answer a question like this ...
is this something to do with I2O?

James


