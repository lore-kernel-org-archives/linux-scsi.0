From: Boaz Harrosh <bharrosh@panasas.com>
Subject: ultrastor.c is a bit-rot
Date: Mon, 17 Mar 2008 16:59:02 +0200
Message-ID: <47DE8736.8020405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:9990 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753054AbYCQO7Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 10:59:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>


Inspecting ultrastor.c it is clear to me that this was never used for
a loooooooooong time. Not since a PC has more then 2^24 bit of memory.
Let me explain below.

Now I'm not saying it should be fixed. I'm saying that it should be dumped
in the account that it is not used by any one and that it does not work.

Why it never worked?
~~~~~~~~~~~~~~~~~~~~~

The driver's header says it supports 3 cards

 *	14F - ISA first-party DMA HA with floppy support and WD1003 emulation.
 *	24F - EISA Bus Master HA with floppy support and WD1003 emulation.
 *	34F - VL-Bus Bus Master HA with floppy support (no WD1003 emulation).

But Kconfig only specifies ISA. I'm not sure what a VL-Bus is.


now the driver defines a static array of structures like this:

	struct {
	  ...
	
	  struct mscp mscp[ULTRASTOR_MAX_CMDS];
	} config = {0};

and allocates a struct mscp in .queuecommand like this:
	    my_mscp = &config.mscp[mscp_index];

it will go on preparing this my_mscp structure including stuffing
some mapped pointers. Lets put that aside for now.
At the very end it will pass this my_mscp structure to the card's 
firmware like this:

	    /* Store pointer in OGM address bytes */
	outl(isa_virt_to_bus(my_mscp), config.ogm_address);

Now this is one hell of a smart ISA card. But putting this aside.

if the machine has more then 2^24 of memory. Then this will never
work, right? or I'm missing it completely?

(Also none of the emails in this file are valid)

Boaz

