From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Re: SYNCHRONIZE_CACHE from sd_preppare_flush does not
 have retries.!
Date: Tue, 20 Apr 2010 14:32:44 -0500
Message-ID: <4BCE015C.7060307@cs.wisc.edu>
References: <1C9608B8A4CD534FB19C7C7543CBB249021C7718FA@inbmail02.lsi.com> <201004192117.15625.bs_lists@aakef.fastmail.fm> <1C9608B8A4CD534FB19C7C7543CBB249021C7719CF@inbmail02.lsi.com> <201004201654.04934.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50566 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754213Ab0DTTce (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Apr 2010 15:32:34 -0400
In-Reply-To: <201004201654.04934.bs_lists@aakef.fastmail.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Cc: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/20/2010 09:54 AM, Bernd Schubert wrote:
> On Tuesday 20 April 2010, Desai, Kashyap wrote:
>>>>>> all block device flushes or is this more device specific? I was
>>>>>> thinking that we may want to create a sysfs interface under the
>>>
>>> block
>>>
>>>>>> dirs and have blk-sysfs.c and blk-barrier.c handle this.
>>>
>>> queue_flush
>>>
>>>>>> could set the timeout and retries that is set by some new files
>>>
>>> under
>>>
>>>>>> /sys/block/sdX/queue/ ?
>>
>> Thanks a lot for your comments.
>>
>> This is very close to my understanding. I feel this is more close to block
>>   layer and I am almost agreeing with your thought. I tried to understand
>>   why upstream does not have retries at queue_flush()/sd_prepare_flush() ???
>>   It looks like there is not specific reason. If I am wrong can someone
>>   explain is there any specific reason not to set rq->retries in
>>   sd_prepare_flush?
>
> I don't understand why we should need another queue timeout, when we
> already have a device timeout that is used as queue timeout?


I think a possible problem is that the one timeout setting is now being 
used for two different operations. Currently, for disks that timeout is 
used for READ/WRITEs. For the sync cache, if we are hitting a problem 
with it taking longer than the current value of 30 secs, then could we 
want to set the READ/WRITE timeout to a lower value like 60 secs, but 
then the sync cache timeout might have to be multiple minutes.
