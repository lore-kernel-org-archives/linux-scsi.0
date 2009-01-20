From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH ver2 printk_ratelimit] bsg: Error print if device is not
 bidi capable when refusing a bidi command
Date: Tue, 20 Jan 2009 17:01:28 +0200
Message-ID: <4975E748.6040705@panasas.com>
References: <4975DC00.2090005@panasas.com> <20090120141517.GM30821@kernel.dk> <4975E1EE.5070101@panasas.com> <20090120144608.GQ30821@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:3682 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761312AbZATPBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jan 2009 10:01:34 -0500
In-Reply-To: <20090120144608.GQ30821@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

Jens Axboe wrote:
> On Tue, Jan 20 2009, Boaz Harrosh wrote:
>> If a bidi command was issued to a request_queue not mark as
>> QUEUE_FLAG_BIDI. Issue an error report. This is a misconfiguration
>> an administrator would like to know about, which is otherwise
>> hard to detect.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  block/bsg.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/block/bsg.c b/block/bsg.c
>> index 44a2a0f..1da14fe 100644
>> --- a/block/bsg.c
>> +++ b/block/bsg.c
>> @@ -270,6 +270,11 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
>>  
>>  	if (rw == WRITE && hdr->din_xfer_len) {
>>  		if (!test_bit(QUEUE_FLAG_BIDI, &q->queue_flags)) {
>> +			if (printk_ratelimit()) {
>> +				printk(KERN_ERR
>> +					"bsg: Attempt to send a bidi command "
>> +					"to a none bidi device\n");
>> +			}
>>  			ret = -EOPNOTSUPP;
>>  			goto out;
>>  		}
>> -- 
>> 1.6.0.1
> 
> Thanks, that works. But why isn't the -EOPNOTSUPP error return (which the
> app can see and print info about) enough? Do we really need to put this
> in the kernel log?
> 

This is your call, I'm not very experienced with this things but ...

What I was thinking is in situations when things used to work fine, and
then later could stop working because of seemingly unrelated changes.
For example: The same iscsi target behind a new accelerated-iscsi-card like
cxgb3i, qla4xxx or iSER would stop working, since bidi is not enabled for
them.

But let me check I had problems with the return value. I'll try to detect
this condition from the application and report in the proper manner. Just
that I thought of the poor Admin that needs to fix that after the fact...
(me ;))

Thanks
Boaz
