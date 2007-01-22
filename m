From: William Studenmund <wrstuden@apple.com>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Date: Mon, 22 Jan 2007 13:53:27 -0800
Message-ID: <A5D5F816-B98C-4637-B92F-E2AAF37469D3@apple.com>
References: <45B3F578.7090109@panasas.com> <45B40458.9010107@torque.net> <45B4547A.3020105@panasas.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out4.apple.com ([17.254.13.23]:56509 "EHLO
	mail-out4.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbXAVWXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 17:23:02 -0500
In-Reply-To: <45B4547A.3020105@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: dougg@torque.net, Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>

On Jan 21, 2007, at 10:06 PM, Benny Halevy wrote:

> Douglas Gilbert wrote:
>> Boaz Harrosh wrote:
>>> - Introduce a new enum dma_data_direction data_dir member in  
>>> struct request.
>>>   and remove the RW bit from request->cmd_flag
>>> - Add new API to query request direction.
>>> - Adjust existing API and implementation.
>>> - Cleanup wrong use of DMA_BIDIRECTIONAL
>>> - Introduce new blk_rq_init_unqueued_req() and use it in places  
>>> ad-hoc
>>>   requests were used and bzero'ed.
>>
>> With a bi-directional transfer is it always unambiguous
>> which transfer occurs first (or could they occur at
>> the same time)?
>
> The bidi transfers can occur in any order and in parallel.

Yes.

However it's not that hard. If you're a target (which open-iscsi  
isn't), you know what the command needs. If you're an initiator, you  
just send the unsolicited data (if any), then let the target tell you  
what it needs next.

While it is possible for commands to have multiple phases, all the  
BiDi commands I'm familiar with use the Data-Out phase to send extra  
command data, then use the Data-In phase to get either an extended  
response to the query (such as a search command) or extended status  
(OSD commands). So it's not that bad in reality.

Take care,

Bill
