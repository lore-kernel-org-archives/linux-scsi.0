From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bsg: Fix sense buffer bug in SG_IO
Date: Thu, 29 Jan 2009 13:36:20 +0200
Message-ID: <498194B4.6040202@panasas.com>
References: <4975CC4F.40006@panasas.com> <20090120130941.GI30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:6392 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752937AbZA2LgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2009 06:36:22 -0500
In-Reply-To: <20090120130941.GI30821@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Jens Axboe wrote:
> On Tue, Jan 20 2009, Boaz Harrosh wrote:
>> When submitting requests via SG_IO, which does a sync io, a
>> bsg_command is not allocated, so an in-Kernel sense_buffer was not
>> set. However when calling blk_execute_rq() with no sense buffer
>> one is provided from the stack. Now bsg at blk_complete_sgv4_hdr_rq()
>> would check if rq->sense_len and a sense was requested by sg_io_v4
>> the rq->sense was copy_user() back, but by now it is already mangled
>> stack memory.
>>
>> I have fixed that by forcing a sense_buffer when calling bsg_map_hdr().
>> The bsg_command->sense is provided in the write/read path like before,
>> and on-the-stack buffer is provided when doing SG_IO.
>>
>> I have also fixed a dprintk message to print rq->errors in hex because
>> of the scsi bit-field use of this member. For other block devices it
>> does not matter anyway.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> 
> Acked-by: Jens Axboe <jens.axboe@oracle.com>
> 

Jens hi.

Do we need to push this for 2.6.29-rcx. As this is a theoretical
security problem, copying and returning to user-mode a mangled
Kernel stack? Also we might need to push this to stable?

Thanks
Boaz
