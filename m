From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] block: fix oops with block tag queueing
Date: Thu, 21 May 2009 19:47:06 +0300
Message-ID: <4A15858A.5000906@panasas.com>
References: <1242839186.2881.57.camel@localhost.localdomain> <4A14B4A1.5050303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:31664 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755203AbZEUQrO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2009 12:47:14 -0400
In-Reply-To: <4A14B4A1.5050303@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <Jens.Axboe@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/21/2009 04:55 AM, Tejun Heo wrote:
> James Bottomley wrote:
>> commit e8939a50466fd963eb1ba9118c34b9ffb7ff6aa6
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Fri May 8 11:54:16 2009 +0900
>>
>>     block: implement and enforce request peek/start/fetch
>>
>> Added a BUG_ON(blk_queued_rq(req)) to the top of blk_finish_req().
>> Unfortunately, this checks whether req->queuelist is empty.  This list
>> is doing double duty both as the queue list and the tag list, so tagged
>> requests come in here with this not empty and boom (the tag list is
>> emptied by blk_queue_end_tag() lower down).
>>
>> Fix this by moving the BUG_ON to below the end tag we also seem
>> vulnerable to this in blk_requeue_request() as well.  I think all uses
>> of blk_queued_rq() need auditing because the check is clearly wrong in
>> the tagged case.
>>
>> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> Oops,
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> There are also some drivers which use queuelist for internal purposes
> after dequeueing, which also screws up blk_queued_rq() test in
> addition to being questionable practice to begin with.  Maybe we would
> be better off with a flag?
> 

What is the REQ_STARTED flag for?

> Thanks.
> 

Boaz
