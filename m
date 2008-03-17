From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: ultrastor.c is a bit-rot
Date: Mon, 17 Mar 2008 09:23:44 -0600
Message-ID: <20080317152344.GE26285@parisc-linux.org>
References: <47DE8736.8020405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53231 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbYCQPXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 11:23:46 -0400
Content-Disposition: inline
In-Reply-To: <47DE8736.8020405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, Mar 17, 2008 at 04:59:02PM +0200, Boaz Harrosh wrote:
> The driver's header says it supports 3 cards
> 
>  *	14F - ISA first-party DMA HA with floppy support and WD1003 emulation.
>  *	24F - EISA Bus Master HA with floppy support and WD1003 emulation.
>  *	34F - VL-Bus Bus Master HA with floppy support (no WD1003 emulation).
> 
> But Kconfig only specifies ISA. I'm not sure what a VL-Bus is.

VESA Local Bus.  It was (in some sense) the predecessor of AGP.  We
treat it like ISA inside the kernel.  On x86, EISA depends on ISA, so
the dependency, while wrong, does not affect any x86 users who have an
EISA card.

> now the driver defines a static array of structures like this:
> 
> 	struct {
> 	  ...
> 	
> 	  struct mscp mscp[ULTRASTOR_MAX_CMDS];
> 	} config = {0};
> 
> and allocates a struct mscp in .queuecommand like this:
> 	    my_mscp = &config.mscp[mscp_index];
> 
> it will go on preparing this my_mscp structure including stuffing
> some mapped pointers. Lets put that aside for now.
> At the very end it will pass this my_mscp structure to the card's 
> firmware like this:
> 
> 	    /* Store pointer in OGM address bytes */
> 	outl(isa_virt_to_bus(my_mscp), config.ogm_address);
> 
> Now this is one hell of a smart ISA card. But putting this aside.
> 
> if the machine has more then 2^24 of memory. Then this will never
> work, right? or I'm missing it completely?

I believe this will work for VESA and EISA cards, though not, indeed for
ISA cards.

> (Also none of the emails in this file are valid)

That doesn't mean it doesn't have users ...

On the other hand, the u14-34f driver is supposed to be preferred to
the ultrastor drivers.  Only problem: it doesn't support the 24F card.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
