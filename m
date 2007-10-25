From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/4] [SCSI] ips: remove ips_ha members that duplicate
 struct pci_dev members
Date: Thu, 25 Oct 2007 17:04:38 +0200
Message-ID: <4720B086.4070505@panasas.com>
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org>	<20071024234827.74AD61F81A1@havoc.gtf.org> <20071024212710.ae6e5120.akpm@linux-foundation.org> <4720251E.1030206@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24549 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758809AbXJYPEx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 11:04:53 -0400
In-Reply-To: <4720251E.1030206@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org

On Thu, Oct 25 2007 at 7:09 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Andrew Morton wrote:
>> On Wed, 24 Oct 2007 19:48:26 -0400 (EDT) Jeff Garzik <jeff@garzik.org> wrote:
>>
>>>  drivers/scsi/ips.c |  178 ++++++++++++++++++++++++----------------------------
>> this driver seems a bit of a basket case :(
>>
>>
>> What's going on here?
>>
>> 		scb->dcdb.cmd_attribute =
>> 		    ips_command_direction[scb->scsi_cmd->cmnd[0]];
>>
>>         /* Allow a WRITE BUFFER Command to Have no Data */
>>         /* This is Used by Tape Flash Utilites          */
>>         if ((scb->scsi_cmd->cmnd[0] == WRITE_BUFFER) && (scb->data_len == 0)) 
>>             scb->dcdb.cmd_attribute = 0;                  
>>
>> 		if (!(scb->dcdb.cmd_attribute & 0x3))
>> 			scb->dcdb.transfer_length = 0;
>>
>> 		if (scb->data_len >= IPS_MAX_XFER) {
>>
>> I hope that's just busted indentation and not a missing {} block.
> 
> The driver is one of the grotty drivers people are afraid to touch, 
> therefore it bitrots even faster, in a vicious cycle.  You don't have to 
> look hard at all to find checkpatch pukeage, very real bugs, and 
> Pythonesque silliness.
> 
> Not having hardware I went only for changes that are provable and 
> obvious, really...
> 
> 	Jeff
> 

>From the experience with gdth I would say that a first patch of any
serious cleanup, should be the whitespace and formating cleanup.
And now that we can all read what it says, start changing.

In the gdth case I know of 3 bugs that happen just because of that mess.
And I promise to send that patch for gdth soooon.

I found that lint, even with the command line options recommended by 
kernel, is to aggressive, and leaves lots of work to be fixed by hand.
(e.g it will touch the comments)

I found that a small util called astyle with the right settings for the 
tab==8/use-tabs will give you a clean tab indent, but will not touch the
longer than 80, broken out lines, which keeps things better formated.

Morton checkpatch is very good in whining about bad files, but did anyone
attempt a script for linux-style Indentation, formating, and whitespace cleanup,
that give you something like 95% success. As it is lint gives you 50-70%
and astyle 60-80%

Boaz
