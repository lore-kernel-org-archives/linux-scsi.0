From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [6/21] Remove unchecked_isa_dma in advansys.c
Date: Sun, 16 Nov 2008 11:56:21 -0500
Message-ID: <1226854581.3556.14.camel@localhost.localdomain>
References: <200811161211.212948789@firstfloor.org>
	 <20081115231106.686F43E661A@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42670 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753920AbYKPQ4d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2008 11:56:33 -0500
In-Reply-To: <20081115231106.686F43E661A@basil.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org

On Sun, 2008-11-16 at 00:11 +0100, Andi Kleen wrote:
> That patch is a little more complicated than the others. advansys
> was the only ISA driver who actually passed ->cmnd to the firmware.
> So I implemented a simple own bounce buffer scheme for this case.
> Also did sense_buffer bouncing in the driver while I was at it;
> which means it doesn't require the mid layer to do this anymore.
> 
> - allocate hostdata with GFP_DMA separately for the ISA case
> - Tell block layer explicitely to bounce for ISA case
> - remove unchecked_isa_dma
> 
> Untested due to lack of hardware
> 
> v2: use dma api for all allocations

Just a minute:  this is another driver where you allocate coherent
memory for the host structure but fail to use it for I/O as far as I can
tell.

What's going on here?  If this is just a ploy to get GFP_DMA memory,
then this isn't the way to do it.  Firstly, it doesn't seem to be needed
and secondly, coherent memory is hard (or impossible) to manufacture on
certain platforms.  You should only use it for DMA mailboxes and other
register exchanges between the device and main memory ... expanding its
use is asking for resource exhaustion.

James


