From: Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH 0/17] Clear up bidi command confusion
Date: Thu, 29 Jan 2015 15:00:15 +0200
Message-ID: <54CA2EDF.7060405@plexistor.com>
References: <54C2390A.3000700@sandisk.com> <20150123131249.GA8045@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62348 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbbA2NAS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2015 08:00:18 -0500
Received: by mail-wi0-f181.google.com with SMTP id fb4so24219657wid.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jan 2015 05:00:17 -0800 (PST)
In-Reply-To: <20150123131249.GA8045@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 01/23/2015 03:12 PM, Christoph Hellwig wrote:
> On Fri, Jan 23, 2015 at 01:05:30PM +0100, Bart Van Assche wrote:
>> There is some confusion in the SCSI core and in SCSI LLDs around the
>> meaning of sc_data_direction and whether or not this member can have the
>> value DMA_BIDIRECTIONAL. Clear up this confusion. The patches in this
>> series are:
> 
> I wonder if we should change the code to set DMA_BIDIRECTIONAL for
> bidi commands.  That seems a lot more logical than the current
> version.
> 

You cannot do this. Because a Bidi Command is actually two commands
one for the WRITE side (DMA_TO_DEVICE) which is this one, and another
command for the READ side (DMA_FROM_DEVICE).

The DMA_XXX_ enum must not to be confused with the t10-scsi Bidi commands.
In DMA world the enum means: What are the allowed access on the memory buffer,
is Device allowed to read-from-memory-only or write-to-memory-only or both
simultaneously "on the same buffer".
It is a flag to the IO-mmu on the direction of its mappings.

A t10-scsi bidi command is "two buffers". The command caries two distinct
buffers one is only-written-to 2nd only-read-from. But these are two distinct
buffers each his proper direction.

If you ask me you need to remove sc_data_direction all together and just
go directly to the READ/WRITE flag at request level. SCSI has no business
duplicating the same information in another member another way.

In any way t10-scsi has no use in the entire of its STD of the DMA_BIDIRECTIONAL
sense. ie. same buffer, two directional access. So DMA_BIDIRECTIONAL is just
dead code for sc_data_direction. It could be imagined but t10-scsi does not
have a use for it.

Again Not to be confused with one-command two buffers, which is exactly the opposite.

> Also I don't think all the debug checks for bidi commands that you
> change should stay at all - driver need to set the QUEUE_FLAG_BIDI to
> ever see a bidi command.
> 

Exactly just remove the all checks.

> It would also nice to add a host template flag for bidi support instead
> of having to poke into the block layer request_queue while we're at it.

Cheers
Boaz


