From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 24/24] ide-scsi.c: convert to data accessors and !use_sg
 cleanup
Date: Tue, 18 Sep 2007 10:49:25 +0200
Message-ID: <46EF9115.5030705@panasas.com>
References: <46E6F92D.2090409@panasas.com> <46E72F13.3090200@panasas.com> <200709171304.08503.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:22410 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXIRIts (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2007 04:49:48 -0400
Received: by ug-out-1314.google.com with SMTP id z38so56577ugc
        for <linux-scsi@vger.kernel.org>; Tue, 18 Sep 2007 01:49:47 -0700 (PDT)
In-Reply-To: <200709171304.08503.bzolnier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, James Bottomley <James.Bottomley@steeleye.com>, Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, "David S. Miller" <davem@davemloft.net>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, linux-scsi <linux-scsi@vger.kernel.org>, "Maciej W. Rozycki" <macro@linux-mips.org>, Mark Fortescue <mark@mtfhpc.demon.co.uk>

On Mon, Sep 17 2007 at 13:04 +0200, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> On Wednesday 12 September 2007, Boaz Harrosh wrote:
>>  - Convert ide-scsi to the new data accessors and cleanup
>>    the !use_sg code paths.
>>
>>   Inspecting old code I can see places that still assume
>>   scsi_cmnd->request_buffer is a linear char pointer. Though I
>>   admit this assumption is hidden behind a flag:
>>   test_bit(PC_TRANSFORM, &pc->flags).
> 
> Sigh... somebody forgot to update ide-scsi.c while making SCSI use
> only sg for REQ_TYPE_BLOCK_PC.
> 
>>   I have commented out the offending code and put a
>>   WARN_ON(1) in it's place. So if there is missing functionality
> 
> in idescsi_transform_pc2():
> 
>         if (drive->media == ide_cdrom || drive->media == ide_optical) {
> ...
> 		WARN_ON(1) + #if/#endif 0 should be here
> ...
> 	}
> 
> rest of the changes look OK and you can add my ACK after fixing
> idescsi_transform_pc2()
> 
>>   it will complain but will not crash the kernel.
> 
> sr is likely to complain due to scsi_mode_sense() usage :(
> 
>>   Maintainer of this driver please inspect if this functionality
>>   is still needed, if not then please remove the commented code.
>>
>>   Thanks
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---

Ok I had an hard look on this code and finally understood what is
going on. It looks like the ATAPI devices do not like the short 
mode_sense_6" commands and friends, and will translate them to 
the xxx_10 variant on the fly. Upper layer like sr still sends
short commands for compatibility with old scsi HW.

This stuff did not work for ages. and was usually bailing out on a NULL
pointer. Though I'm almost sure that there is one potential crash in there
and if Jeff is correct in saying that it gets used, than I do not understand
how it did not trigger.

In any way I have codded a fix. I have based my hack on the assumption that
SENSE INQUIRY and SELECT commands come with sg_count of 1. If not than I
just truncate the command to the first sg. I than do a kmap/kunmap on the
first sg and let the code do what it did before.

Please Note that I did not reference the standard and have not verified
at all the bit keeping in there. I have just converted the old code that
assumed a !use_sg in block pc commands to now assume an sg_count==1.

Please, anyone that can, give it an hard testing with any HW you have 
because that change is not trivial.

I will send the patch as reply to the first patch.

Boaz
 
