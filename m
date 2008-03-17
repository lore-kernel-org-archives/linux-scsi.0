From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ultrastor.c is a bit-rot
Date: Mon, 17 Mar 2008 10:23:03 -0500
Message-ID: <1205767383.6767.139.camel@localhost.localdomain>
References: <47DE8736.8020405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:38108 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbYCQPXH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 11:23:07 -0400
In-Reply-To: <47DE8736.8020405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2008-03-17 at 16:59 +0200, Boaz Harrosh wrote:
> Inspecting ultrastor.c it is clear to me that this was never used for
> a loooooooooong time. Not since a PC has more then 2^24 bit of memory.
> Let me explain below.
> 
> Now I'm not saying it should be fixed. I'm saying that it should be dumped
> in the account that it is not used by any one and that it does not work.
> 
> Why it never worked?
> ~~~~~~~~~~~~~~~~~~~~~
> 
> The driver's header says it supports 3 cards
> 
>  *	14F - ISA first-party DMA HA with floppy support and WD1003 emulation.
>  *	24F - EISA Bus Master HA with floppy support and WD1003 emulation.
>  *	34F - VL-Bus Bus Master HA with floppy support (no WD1003 emulation).
> 
> But Kconfig only specifies ISA. I'm not sure what a VL-Bus is.

VL is vesa local ... it was an ISA like graphics bus that was fast and
could reach > 16MB.

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

It will definitely work for EISA and VL bus.  I think if you analyse the
placement of kernel data segments for compiled in drivers, it might also
work for ISA too, since I think the pfn will be low enough.  It should
fail as a module not just because the area will be out of range for ISA,
but also because the module data segment is in vmalloc space, so the
virt_to_bus assumptions of contiguity could be violated.

James


