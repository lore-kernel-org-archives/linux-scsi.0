From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Wed, 31 Jan 2007 00:09:35 -0500
Message-ID: <45C0248F.80008@torque.net>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com> <45BFF3D6.9050605@rtr.ca> <45C00AEE.1090708@emc.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52730 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbXAaFJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 31 Jan 2007 00:09:46 -0500
In-Reply-To: <45C00AEE.1090708@emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: Mark Lord <liml@rtr.ca>, "Eric D. Mudama" <edmudama@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Ric Wheeler wrote:
> 
> 
> Mark Lord wrote:
> 
>> Eric D. Mudama wrote:
>>
>>>
>>> Actually, it's possibly worse, since each failure in libata will
>>> generate 3-4 retries.  With existing ATA error recovery in the
>>> drives, that's about 3 seconds per retry on average, or 12 seconds
>>> per failure.  Multiply that by the number of blocks past the error to
>>> complete the request..
>>
>>
>> It really beats the alternative of a forced reboot
>> due to, say, superblock I/O failing because it happened
>> to get merged with an unrelated I/O which then failed..
>> Etc..
>>
>> Definitely an improvement.
>>
>> The number of retries is an entirely separate issue.
>> If we really care about it, then we should fix SD_MAX_RETRIES.
>>
>> The current value of 5 is *way* too high.  It should be zero or one.
>>
>> Cheers
>>
> I think that drives retry enough, we should leave retry at zero for
> normal (non-removable) drives. Should this  be a policy we can set like
> we do with NCQ queue depth via /sys ?

The transport might also want a say. I see ABORTED COMMAND
errors often enough with SAS (e.g. due to expander congestion)
to warrant at least one retry (which works in my testing).
SATA disks behind SAS infrastructure would also be
susceptible to the same "random" failures.

Transport Layer Retries (TLR) in SAS should remove this class
of transport errors but only SAS tape drives support TLR as
far as I know.

Doug Gilbert

> We need to be able to layer things like MD on top of normal drive errors
> in a way that will produce a system that provides reasonable response
> time despite any possible IO error on a single component.  Another case
> that we end up doing on a regular basis is drive recovery. Errors need
> to be limited in scope to just the impacted area and dispatched up to
> the application layer as quickly as we can so that you don't spend days
> watching a copy of  huge drive (think 750GB or more) ;-)
> 
> ric


