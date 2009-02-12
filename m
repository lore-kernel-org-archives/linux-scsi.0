From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] [RFC] block: Don't let blk_put_request leak BIOs
Date: Thu, 12 Feb 2009 15:56:46 +0200
Message-ID: <49942A9E.8090405@panasas.com>
References: <4993DCCA.8080508@panasas.com>	<20090212174124S.fujita.tomonori@lab.ntt.co.jp>	<4993E85A.20805@panasas.com> <20090212184208X.fujita.tomonori@lab.ntt.co.jp> <499413DB.2020208@panasas.com> <499428E1.1000009@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:32807 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751339AbZBLN4t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2009 08:56:49 -0500
In-Reply-To: <499428E1.1000009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>

Boaz Harrosh wrote:
> Boaz Harrosh wrote:
>> If a block ULD had allocated a request and mapped some memory into it,
>> using one of blk_rq_map_xxx routines, but then for some reason failed to
>> execute the request through one of the blk_execute_request routines.
>> Then the associated BIO would leak, unless ULD resorts to low-level loops
>> intimate of block internals.
>>
>> [RFC]
>>   This code will also catch situations where LLD failed to complete
>>   the request before aborting it. Such situations are a BUG. Should we
>>   use WARN_ON_ONCE() in that case. The situation above is possible and
>>   can happen normally in memory pressure situations so maybe we should
>>   devise a bit-flag that ULD denotes that the request was aborted and
>>   only WARN_ON if flag was not set.
>>
>>   I'm sending this before any-tests so people can comment on possible
>>   pitfalls.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
> 
> I've booted a Linux PC with lots of sata disks, connected an iscsi
> target, ran OSD tests. It looks like it's working which means
> request->bio is set to NULL after it is used in the regular path.
> 
> This needs to sit in Linux next and be tested for a long while.
> 
> Jens I'll be waiting for your comment and will send a proper
> patch for the block bits. We will have to time this with James
> to see when the OSD bits can be submitted after that, then TOMO's
> patch for un-exporting blk_req_append_bio can be merged. Or maybe
> it can all go in one patch through scsi?
> 
> Thanks
> Boaz

Spock to soon this patch is shit, I'll look into it

Sorry for the noise

Boaz
