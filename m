From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/4] [SCSI] ips: remove ips_ha members that duplicate
 struct pci_dev members
Date: Thu, 25 Oct 2007 18:42:04 -0400
Message-ID: <47211BBC.40608@garzik.org>
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>	<20071024234827.74AD61F81A1@havoc.gtf.org> <20071024212710.ae6e5120.akpm@linux-foundation.org> <4720251E.1030206@garzik.org> <4720B086.4070505@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60762 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298AbXJYWmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 18:42:11 -0400
In-Reply-To: <4720B086.4070505@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
> On Thu, Oct 25 2007 at 7:09 +0200, Jeff Garzik <jeff@garzik.org> wrote:
>> Andrew Morton wrote:
>>> On Wed, 24 Oct 2007 19:48:26 -0400 (EDT) Jeff Garzik <jeff@garzik.org> wrote:
>>>
>>>>  drivers/scsi/ips.c |  178 ++++++++++++++++++++++++----------------------------
>>> this driver seems a bit of a basket case :(
>>>
>>>
>>> What's going on here?
>>>
>>> 		scb->dcdb.cmd_attribute =
>>> 		    ips_command_direction[scb->scsi_cmd->cmnd[0]];
>>>
>>>         /* Allow a WRITE BUFFER Command to Have no Data */
>>>         /* This is Used by Tape Flash Utilites          */
>>>         if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) && (scb->data_len == 0)) 
>>>             scb->dcdb.cmd_attribute = 0;                  
>>>
>>> 		if (!(scb->dcdb.cmd_attribute & 0x3))
>>> 			scb->dcdb.transfer_length = 0;
>>>
>>> 		if (scb->data_len >= IPS_MAX_XFER) {
>>>
>>> I hope that's just busted indentation and not a missing {} block.
>> The driver is one of the grotty drivers people are afraid to touch, 
>> therefore it bitrots even faster, in a vicious cycle.  You don't have to 
>> look hard at all to find checkpatch pukeage, very real bugs, and 
>> Pythonesque silliness.
>>
>> Not having hardware I went only for changes that are provable and 
>> obvious, really...
>>
>> 	Jeff
>>
> 
>>From the experience with gdth I would say that a first patch of any
> serious cleanup, should be the whitespace and formating cleanup.
> And now that we can all read what it says, start changing.
> 
> In the gdth case I know of 3 bugs that happen just because of that mess.
> And I promise to send that patch for gdth soooon.
> 
> I found that lint, even with the command line options recommended by 
> kernel, is to aggressive, and leaves lots of work to be fixed by hand.
> (e.g it will touch the comments)

Yeah, I hear you, but don't mistake my kill-warnings work for embarking 
upon a new clean-this-driver project ;-)

I tend to make incremental improvements all over the tree, "rising tide 
lifts all boats" and that sort of thing.

If I remained and worked on cleaning every grotty driver I come across 
while killing warnings or fixing interrupt handlers, I would have no 
free time at all :)

	Jeff



