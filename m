From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 09:24:14 -0500
Message-ID: <1209651854.3067.8.camel@localhost.localdomain>
References: <4819C9DB.60104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60501 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751968AbYEAOYS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 10:24:18 -0400
In-Reply-To: <4819C9DB.60104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>

On Thu, 2008-05-01 at 16:47 +0300, Boaz Harrosh wrote:
> [PATCH 1/4] scsi_free_command API change - Don't support GFP_DMA
>   ISA support is going away and is not needed by any potential clients
>   of this code. So change the API now before it has any users.

What makes you think this?  We still have lots of ISA installations out
there (and some broken PCI ones requiring ISA DMA masks) that we have to
support.

For gdth you have an ISA board that *you* need to support, so the isa
board has to have this flag.  The reason no-one's run into a bug here is
that the problematic allocation is the sense buffer not the command.
Unfortunately, when the fix was added to the gdth driver for the sense
buffer separation:

commit 1b96f8955aaeeb05f7fb7ff548aa12415fbf3904
Author: Sven Schnelle <svens@bitebene.org>
Date:   Mon Mar 10 22:50:04 2008 +0100

    [SCSI] gdth: Allocate sense_buffer to prevent NULL pointer dereference

We actually forgot about this case.  Right at the moment, any ioctl that
uses gdth_execute on an ISA device will probably fail if the executed
command resturns sense and there look to be paths down gdth_execute even
for special commands where the OpCode flips to a regular command (-1)
and so DMAs into the sense buffer.

James


