From: Dan Aloni <da-x@monatomic.org>
Subject: Re: [PATCH] scsi_execute_async() should add to the tail of the queue
Date: Tue, 19 Dec 2006 12:34:54 +0200
Message-ID: <4587C04E.10307@monatomic.org>
References: <20061219083507.GA20847@localdomain> <1166522613.3365.1198.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from noname.neutralserver.com ([70.84.186.210]:20838 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbWLSKfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Dec 2006 05:35:03 -0500
In-Reply-To: <1166522613.3365.1198.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@fenrus.demon.nl>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

Arjan van de Ven wrote:
> On Tue, 2006-12-19 at 10:35 +0200, Dan Aloni wrote:
>   
>> Hello,
>>
>> scsi_execute_async() has replaced scsi_do_req() a few versions ago, 
>> but it also incurred a change of behavior. I noticed that over-queuing 
>> a SCSI device using that function causes I/Os to be starved from 
>> low-level queuing for no justified reason.
>>  
>> I think it makes much more sense to perserve the original behaviour 
>> of scsi_do_req() and add the request to the tail of the queue.
>>     
>
> Hi,
>
> some things should really be added to the head of the queue, like
> maintenance requests and error handling requests. Are you sure this is
> the right change? At least I'd expect 2 apis, one for a head and one for
> a "normal" queueing...
>   
Since a user of scsi_execute_async() would most likely want to have
control over this, it would be better to add a parameter and fix the
current users of the function.

However, if we take this route we might have duplicate code
across mid-layer drivers (sg, st, osst), because they may choose to
prioritize I/Os in similar ways.

So instead of adding a parameter, we can make scsi_execute_async()
decide for itself based on the SCSI command, with read/write I/Os
taking the lowest priority.

Suggestions?

