From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata: clustering on or off?
Date: Sun, 28 Aug 2005 13:32:09 -0400
Message-ID: <4311F519.5050300@pobox.com>
References: <20050828094218.GA29145@havoc.gtf.org> <1125224541.3219.13.camel@laptopd505.fenrus.org> <20050828142018.GS4018@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050828142018.GS4018@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jens Axboe wrote:
> On Sun, Aug 28 2005, Arjan van de Ven wrote:
> 
>>On Sun, 2005-08-28 at 05:42 -0400, Jeff Garzik wrote:
>>
>>>The constant ATA_SHT_USE_CLUSTERING in include/linux/libata.h controls
>>>the use of SCSI layer's use_clustering feature, for a great many libata
>>>drivers.
>>>
>>>The current setup has clustering disabled, which in theory causes the
>>>block layer to do less work, at the expense of a greater number of
>>>scatter/gather table entries used.
>>>
>>>Any opinions WRT turning on clustering for libata?
>>
>>in 2.4 clustering was expensive due to a large number of checks that
>>were done (basically the number of fragments got recounted a gazilion
>>times). In 2.6 Jens fixed that afaik to make it basically free...
>>at which point it's a win always.

> Yeah, it wont cost any extra cycles,

A simple grep for QUEUE_FLAG_CLUSTER-related code shows that it -does- 
cost extra cycles.


>>Imo clustering on the driver level should announce driver capabilities.
>>If clustering for some arch/kernel makes it slower, that should be
>>decided at a midlayer level and not in each driver; eg the midlayer
>>would chose to ignore the drivers capabilities.
>>So .. my opinion would be that libata should announce the capability (it
>>seems the code/hw can do it). 
> 
> 
> Agree, we should just remove the ability to control clustering, as it
> really overlaps with the segment settings anyways.

OK, I guess the consensus is to use clustering :)

We'll see if anything blows up in 2.6.14...

	Jeff



