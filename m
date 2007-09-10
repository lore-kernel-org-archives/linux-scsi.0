From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patchset 0/5] Refactoring scsi_error to facilitate in
	synchronous REQUEST_SENSE
Date: Mon, 10 Sep 2007 12:09:32 -0500
Message-ID: <1189444172.12245.7.camel@localhost.localdomain>
References: <46E5508B.7030108@panasas.com>
	 <20070910170334.GA12369@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45194 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757165AbXIJRJf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 13:09:35 -0400
In-Reply-To: <20070910170334.GA12369@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Christoph Hellwig <hch@infradead.org>

On Mon, 2007-09-10 at 10:03 -0700, Matthew Dharm wrote:
> On Mon, Sep 10, 2007 at 05:11:23PM +0300, Boaz Harrosh wrote:
> > 
> > In motivation to abstract scsi_cmnd members and insulate
> > drivers/transports from scsi_cmnd internals. The last
> > place left was the REQUEST_SENSE sequence when done
> > synchronous, by drivers.
> 
> This probably isn't serious, but I noticed one thing (beyond what Alan's
> analysis noted)...
> 
> I've always assumed that the scatterlist structs passed to an HCD were,
> themselves, allocated from DMA-able memory.  That is, not just the transfer
> buffers themselves, but the struct scatterlist also.

They are, but this is an artifact of the command allocation.  Commands
(as in the 6, 10 12 or 16 bytes of command sequence) are designed to be
DMAable, meaning that everything that makes up a struct scsi_cmnd is
automatically DMAable.  However, the design is for the dma_mapped
scatterlist to be converted to a form the underlying HBA can use.  I
don't currently know of any HBA whose descriptor format matches those of
struct scatterlist, so I don't think there'll be any impact to putting
the scatterlist in memory that might not be DMAable by the HBA.

> In this implementation, the struct scatterlist used for the single-element
> transfer of the request sense buffer is part of the
> struct scsi_eh_save_cmnd_info, which is allocated on the stack (for at
> least usb-storage).  And, stack isn't DMA-able on all arches.
> 
> It is not a problem for usb-storage, since the struct scatterlists are
> processed in code into a series of URBs, so nobody actually does DMA the
> scatterlist structures.  However, I don't know enough about the other HCDs
> to be certain about them.

James


