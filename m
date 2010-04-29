From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: SYNCHRONIZE_CACHE from sd_preppare_flush does not have retries.!
Date: Thu, 29 Apr 2010 16:13:03 -0400
Message-ID: <4BD9E84F.8000707@redhat.com>
References: <1C9608B8A4CD534FB19C7C7543CBB249021C7718FA@inbmail02.lsi.com>	 <4BCC82DB.1070402@cs.wisc.edu>	 <201004192014.51019.bernd.schubert@fastmail.fm> <1271702740.2849.67.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157Ab0D3RV6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:58 -0400
In-Reply-To: <1271702740.2849.67.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>, Mike Christie <michaelc@cs.wisc.edu>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 04/19/2010 02:45 PM, James Bottomley wrote:
> On Mon, 2010-04-19 at 20:14 +0200, Bernd Schubert wrote:
>    
>> On Monday 19 April 2010, Mike Christie wrote:
>>      
>>> On 04/19/2010 06:32 AM, Desai, Kashyap wrote:
>>>        
>>>> I am facing one issue with scsi stack.
>>>> Here is a background of my test.
>>>>
>>>> Mount ext3 file system with journaling support with barrier=1, commit=5
>>>> Now, with this setup file system will do submit_bh with  WRITE_BARRIER
>>>> flag set for interval of 5 seconds. (This is a part of journaling.)
>>>> Eventually it will call queue_flush() which will generate SCSI command of
>>>> CDB: SYNCHRONIZE_CAHCE and insert it into the request queue. I observed
>>>> that creation of SYNCHRONIZE_CACHE is a part of sd_prepare_flush(). Here
>>>> we have timeout set to SD_TIMEOUT but retries are not set. Because of
>>>> retries of the request is not set, there is no retries allowed for
>>>> SYNCHRONIZE_CACHE at mid layer.
>>>>
>>>> Because of zero retries for SYNCHRONIZE_CACHE command at mid-layer, it is
>>>> creating trouble for file system. In current situation, Even though LLD
>>>> send back commands with DID_RESET, SYNCHRONIZE_CACHE will fail
>>>> immediately without going for any retries, when HBA is in recovery state.
>>>> Eventually this information goes to File system and it sees
>>>> SYNCHRONIZE_CAHCE is failed and file system goes to Read only mode.
>>>>
>>>> My question is "Can we add in sd_prepare_flush(), rq->retries = X" some
>>>> reasonable retries value ?
>>>>          
>>> I am not sure where we want it, but I think we want to be able to set
>>> both the retries and timeout. I have seen where a sync cache can take
>>> longer than the default 30 secs.
>>>
>>> Do you think we want to the block layer to manage retries/timeouts for
>>> all block device flushes or is this more device specific? I was thinking
>>> that we may want to create a sysfs interface under the block dirs and
>>> have blk-sysfs.c and blk-barrier.c handle this. queue_flush could set
>>> the timeout and retries that is set by some new files under
>>> /sys/block/sdX/queue/ ?
>>>        
>>
>> Good that now also other people run into it. 30s is far too small for any
>> hardware raid unit with SATA disks.
>>      
> It's far too short for just about any HW RAID since they all tend to
> have multi-megabytes to gigabytes of cache (some of the high end have
> terrabytes).  It has to be said that most arrays with battery backed
> caches lie when asked to flush the cache, but we probably need to get
> users into the habit of not using flush barriers with external Arrays.
>
>    

As you say, a lot of arrays don't do anything with these requests. We 
should be using barriers (and sending down the synch commands) when the 
device advertises a write back cache.

For a simple hardware RAID card, it is not sufficient simply to flush 
the write cache on the HBA. It must also either disable the write cache 
on the downstream devices (S-ATA/SAS disks, etc) or send cache flush 
commands to each device.

In those cases, this could be a quite lengthy process...

>> http://markmail.org/message/ewicheafcvgwm4p7
>>
>> I wrote this patch while having trouble with Infortrend Raids, but it also
>> comes up with DDN storage if the write back cache is enabled.
>> Shall I update the patch, add retries and then resend the entire series?
>>      
> rq->timeout is the timeout of the request triggering the flush ... it's
> likely the wrong value since it's for a fast completing r/w operation,
> whereas this is a slow drain operation.
>
> James
>
>    

