From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: GFP_DMA use in SCSI midlayer
Date: Sun, 01 Oct 2006 15:40:18 -0500
Message-ID: <1159735218.3542.16.camel@mulgrave.il.steeleye.com>
References: <200610012213.24123.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:41962 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932344AbWJAUk0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 16:40:26 -0400
In-Reply-To: <200610012213.24123.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: linux-scsi@vger.kernel.org, Christoph Lameter <clameter@sgi.com>

On Sun, 2006-10-01 at 22:13 +0200, Andi Kleen wrote:
> GFP_DMA in general is deprecated and should be replaced by appropiate
> dma_alloc_coherent()

Um, no it shouldn't.

All of the places where we use GFP_DMA are because we might be
addressing an ISA card or other strange mask limited card (gated usually
by unchecked_isa_dma).  However, what is wanted in every case is
ordinary memory, not coherent memory.  They can't simply be replaced
with dma_alloc_coherent because

a) it will waste memory for platforms that only do it in page size
multiples
b) It will fail on platforms that can't do it at all.

Coherent memory is really only for device drivers to use in mailboxes
and shared ring buffers.

> or similar.  And I can't imagine any modern systems still need them, and for 
> the few still non CONFIG_BROKEN ISA drivers maybe some other way can be found?
> And do they really require the mid layer data structures to be GFP_DMA too?

Well, it's the "or similar" that's still the problem.  All they need is
ordinary memory which respects the device mask (then I can get rid of
the unchecked_isa_dma flag as well).

One could argue, I suppose, that when we get every SCSI path to go via
sg, then the block layer will bounce this for us, and we don't need to
worry at all.

> Is it possible to get rid of those GFP_DMAs in the mid layer and the 
> higher level drivers like sd,sr,ch etc.?

James


