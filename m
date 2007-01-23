From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Date: Tue, 23 Jan 2007 15:45:00 +0200
Message-ID: <45B6115C.2010601@panasas.com>
References: <45B3F578.7090109@panasas.com> <20070122052938.GJ3531@rhun.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:41985 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965085AbXAWNq2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 08:46:28 -0500
In-Reply-To: <20070122052938.GJ3531@rhun.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>

Muli Ben-Yehuda wrote:
> On Mon, Jan 22, 2007 at 01:21:28AM +0200, Boaz Harrosh wrote:
> 
>> - Introduce a new enum dma_data_direction data_dir member in struct request.
>>   and remove the RW bit from request->cmd_flag
> 
> Some architecture use 'enum dma_data_direction' and some 'int
> dma_data_direction'. The consensus was to move to int over
> time. Please use 'int dma_data_direction'.

That should be fine (although I'm not sure what made you go this way :)
Please see my reply to Douglas, proposing an enum req_io_direction
at the block layer and up which will provide a better enumeration
for our use.

>>
>> +static inline int dma_write_dir(enum dma_data_direction dir)
>> +{
>> +	return (dir == DMA_TO_DEVICE) || (dir == DMA_BIDIRECTIONAL);
>> +}
> 
> "write" can mean "write to device" or "write to memory", depending on
> context. Not exactly something which should be a generic
> helper. Rename to 'dma_to_device(int dir)'?

much better. thanks!

> 
>> +static inline int dma_uni_dir(enum dma_data_direction dir)
>> +{
>> +	return (dir == DMA_TO_DEVICE) || (dir == DMA_FROM_DEVICE) ||
>> +	       (dir == DMA_NONE);
>> +}
> 
> While this doesn't look very useful. Why is "DMA_NONE" a uni-dir? I
> suggest replacing this with an open coded (dir != DMA_BIDIRECTIONAL).

The idea was to be resilient to invalid values. (dir != DMA_BIDIRECTIONAL)
is fine of course, but I'd add a BUG_ON such as (dir < 0 || dir > DMA_BIDIRECTIONAL)

Benny
