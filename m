From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
Date: Wed, 18 Jul 2007 17:13:02 +0300
Message-ID: <469E1FEE.9060106@panasas.com>
References: <468CDB3C.4060500@panasas.com>	<468CF58E.1020901@panasas.com>	<46967C78.3070100@cs.wisc.edu> <20070712154739K.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:24998 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755543AbXGRONy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 10:13:54 -0400
In-Reply-To: <20070712154739K.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>, michaelc@cs.wisc.edu
Cc: James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

FUJITA Tomonori wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> Subject: Re: [RFC 4/8] scsi-ml: scsi_sgtable implementation
> Date: Thu, 12 Jul 2007 14:09:44 -0500
> 
>> Boaz Harrosh wrote:
>>> +/*
>>> + * Should fit within a single page.
>>> + */
>>> +enum { SCSI_MAX_SG_SEGMENTS =
>>> +	((PAGE_SIZE - sizeof(struct scsi_sgtable)) /
>>> +	sizeof(struct scatterlist)) };
>>> +
>>> +enum { SG_MEMPOOL_NR =
>>> +	(SCSI_MAX_SG_SEGMENTS >= 7) +
>>> +	(SCSI_MAX_SG_SEGMENTS >= 15) +
>>> +	(SCSI_MAX_SG_SEGMENTS >= 31) +
>>> +	(SCSI_MAX_SG_SEGMENTS >= 63) +
>>> +	(SCSI_MAX_SG_SEGMENTS >= 127) +
>>> +	(SCSI_MAX_SG_SEGMENTS >= 255) +
>>> +	(SCSI_MAX_SG_SEGMENTS >= 511)
>>> +};
>>>  
>> What does SCSI_MAX_SG_SEGMENTS end up being on x86 now? On x86_64 or 
>> some other arch, we were going over a page when doing 
>> SCSI_MAX_PHYS_SEGMENTS of 256 right?
> 
> Seems that 170 with x86 and 127 with x86_64.
> 

with scsi_sgtable we get one less than now

Arch                      | SCSI_MAX_SG_SEGMENTS =  | sizeof(struct scatterlist)
--------------------------|-------------------------|---------------------------
x86_64                    | 127                     |32
i386 CONFIG_HIGHMEM64G=y  | 204                     |20
i386 other                | 255                     |16

What's nice about this code is that now finally it is
automatically calculated in compile time. Arch people
don't have the headache "did I break SCSI-ml?". 
For example observe the current bug with i386 
CONFIG_HIGHMEM64G=y.

The same should be done with BIO's. Than ARCHs with big
pages can gain even more.

> 
>> What happened to Jens's scatter list chaining and how does this relate 
>> to it then?
> 
> With Jens' sglist, we can set SCSI_MAX_SG_SEGMENTS to whatever we
> want. We can remove the above code.
> 
> We need to push this and Jens' sglist together in one merge window, I
> think.

No Tomo the above does not go away. What goes away is maybe:

 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
-	blk_queue_max_phys_segments(q, SCSI_MAX_SG_SEGMENTS);
 	blk_queue_max_sectors(q, shost->max_sectors);

I'm working on a convergence patches that will do scsi_sg_pools cleanup
which is common to both our patches, than scsi_sgtable, and than 
sg-chaining on top of that. I hope it gets accepted. 
The sg-chaining is much much simpler over scsi_sgtables.

If both sg_chaining and scsi_sgtables gets into the same merge window
it could be grate. It will need some testing period.

Boaz
