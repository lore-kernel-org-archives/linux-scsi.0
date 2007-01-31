From: Ric Wheeler <ric@emc.com>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Tue, 30 Jan 2007 22:20:14 -0500
Message-ID: <45C00AEE.1090708@emc.com>
References: <200701301947.08478.liml@rtr.ca>	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com> <311601c90701301725n53d25a74g652b7ca3bfc64c56@mail.gmail.com> <45BFF3D6.9050605@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:15756 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbXAaDwn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2007 22:52:43 -0500
In-Reply-To: <45BFF3D6.9050605@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: "Eric D. Mudama" <edmudama@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>



Mark Lord wrote:

> Eric D. Mudama wrote:
>
>>
>> Actually, it's possibly worse, since each failure in libata will 
>> generate 3-4 retries.  With existing ATA error recovery in the 
>> drives, that's about 3 seconds per retry on average, or 12 seconds 
>> per failure.  Multiply that by the number of blocks past the error to 
>> complete the request..
>
>
> It really beats the alternative of a forced reboot
> due to, say, superblock I/O failing because it happened
> to get merged with an unrelated I/O which then failed..
> Etc..
>
> Definitely an improvement.
>
> The number of retries is an entirely separate issue.
> If we really care about it, then we should fix SD_MAX_RETRIES.
>
> The current value of 5 is *way* too high.  It should be zero or one.
>
> Cheers
>
I think that drives retry enough, we should leave retry at zero for 
normal (non-removable) drives. Should this  be a policy we can set like 
we do with NCQ queue depth via /sys ?

We need to be able to layer things like MD on top of normal drive errors 
in a way that will produce a system that provides reasonable response 
time despite any possible IO error on a single component.  Another case 
that we end up doing on a regular basis is drive recovery. Errors need 
to be limited in scope to just the impacted area and dispatched up to 
the application layer as quickly as we can so that you don't spend days 
watching a copy of  huge drive (think 750GB or more) ;-)

ric

