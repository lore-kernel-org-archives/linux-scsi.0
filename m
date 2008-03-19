From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device
 causes infinite loop in 2.6.24
Date: Wed, 19 Mar 2008 16:34:13 -0500
Message-ID: <47E186D5.5040701@sgi.com>
References: <47D7035F.5000700@sgi.com> <47D7B4A1.6020909@panasas.com> <47D7FECE.1020901@sgi.com> <47D8002C.9010306@panasas.com> <47DA798E.5080305@sgi.com> <47DFE9E4.6070301@sgi.com> <47DFEBBD.7080702@panasas.com> <47DFF369.90805@sgi.com> <47DFF989.80903@panasas.com> <47E137ED.1090205@sgi.com> <47E13CC9.7060706@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.171.29]:51912 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932814AbYCSVeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 17:34:16 -0400
In-Reply-To: <47E13CC9.7060706@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>



Boaz Harrosh wrote:
> On Wed, Mar 19 2008 at 17:57 +0200, Michael Reed <mdr@sgi.com> wrote:
>> New patch at end....
>>
>> Boaz Harrosh wrote:
>>> On Tue, Mar 18 2008 at 18:52 +0200, Michael Reed <mdr@sgi.com> wrote:
>>>> Boaz Harrosh wrote:
>>>>> On Tue, Mar 18 2008 at 18:12 +0200, Michael Reed <mdr@sgi.com> wrote:
>>>>>> Michael Reed wrote:
>>>>>>> Boaz Harrosh wrote:
>>>>>>> <snip>
>>>>>>>>>> Just to demonstrate what I mean a patch is attached. Just as an RFC, totally
>>>>>>>>>> untested.
>>>>>>>>> I can try this out and see what happens.
>>>>>>>>>
>>>>>>>>>
>>>>>>>> Will not compile here is a cleaner one
>>>>>>> Still in my queue.  Hopefully I'll get to poke at this today.
>>>>>> Patch compiles cleanly and appears to have no effect on the misc.
>>>>>> sg_* commands I've executed including sg_dd, sg_inq, sg_luns, sg_readcap.
>>>>>>
>>>>>> Mike
>>>>>>
>>>>>>> Mike
>>>>>>>
>>>>> <patch sniped>
>>>>>
>>>>> If you remove the original fix to sg.c
>>>>> ([PATCH] 2.6.25-rc4-git3 - inquiry cmd issued via /dev/sg? device causes infinite loop in 2.6.24)
>>>>>
>>>>> and apply this patch, does it solve your original infinite loop?
>>>> Unfortunately, the infinite loop only occurred at 2.6.24.  I'll see if
>>>> I can break the current rc by removing some known fixes.
>>>>
>>>> Care to gen a patch for 2.6.24?
>>>>
>>>> Mike
>>>>
>>>>> Thanks
>>>>> Boaz
>>>>>
>>> here is the same principle on Linux 2.6.24
>>> ---
>>> [PATCH] scsi: Always complete BLOCK_PC commands
>>>
>>> Current code, in some IO combinations could wrongly retry
>>> a BLOCK_PC command in chunks. This was never intended.
>>> Fix it that BLOCK_PC will always complete atomically
>>>
>>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>>> ---
>>> git-diff --stat -p
>>>  drivers/scsi/scsi_lib.c |    9 +++++++++
>>>  1 files changed, 9 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index a9ac5b1..ae32012 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -966,7 +966,16 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>>>  				req->sense_len = len;
>>>  			}
>>>  		}
>>> +		good_bytes = req->data_len;
>>>  		req->data_len = cmd->resid;
>>> +retry_end_req:
>>> +		if (scsi_end_request(cmd, 1, good_bytes, 0) != NULL) {
>>> +			WARN_ON(1);
>>> +			good_bytes = req->data_len;
>>> +			goto retry_end_req;
>>> +		}
>>> +		
>>> +		return;
>>>  	}
>>>  
>>>  	/*
>> I applied the patch to 2.6.24 and here's the result.  It first completes 255 bytes,
>> then repeatedly completes 56 bytes until it's all completed.  This seems rather cumbersome.
>> And points out that the rounding in sg_build_indirect() needs to be fixed.
>>
>> scsi_execute_async: inquiry buf length 255, use_sg 1, bio e0000170820fae00, bi_size 512
>> mptscsih_qcmd: cmd e0000170b06e1980 / 18, dd 2, sg_count 1, sglist e0000170b340e900, bufflen 255, bi_size 512
>> scsi_io_completion: e0000170b06e1980: inquiry completion: result 0, good_bytes 255, bufflen 255, sense_valid 0, sense e0000170b34ac5c0 / 0
>> WARNING: at drivers/scsi/scsi_lib.c:1025 scsi_io_completion()
>>
>> Call Trace:
>>  [<a000000100013ac0>] show_stack+0x40/0xa0
>>                                 sp=e0000170821c79b0 bsp=e0000170821c1050
>>  [<a000000100013b50>] dump_stack+0x30/0x60
>>                                 sp=e0000170821c7b80 bsp=e0000170821c1038
>>  [<a0000001005628b0>] scsi_io_completion+0x350/0x980
>>                                 sp=e0000170821c7b80 bsp=e0000170821c0fd0
>>  [<a0000001005547b0>] scsi_finish_command+0x1d0/0x200
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0fa0
>>  [<a000000100564070>] scsi_softirq_done+0x270/0x2a0
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0f70
>>  [<a0000001003a8480>] blk_done_softirq+0x140/0x1a0
>>                                 sp=e0000170821c7bb0 bsp=e0000170821c0f58
>>  [<a0000001000b6eb0>] __do_softirq+0xf0/0x240
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0ee0
>>  [<a0000001000b7070>] do_softirq+0x70/0xc0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e80
>>  [<a0000001000b7360>] irq_exit+0x80/0xa0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e68
>>  [<a000000100011250>] ia64_handle_irq+0x2f0/0x320
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a00000010000b100>] ia64_leave_kernel+0x0/0x270
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a000000100014bf0>] default_idle+0x110/0x180
>>                                 sp=e0000170821c7d90 bsp=e0000170821c0df0
>>  [<a000000100013870>] cpu_idle+0x230/0x360
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0db0
>>  [<a000000100961910>] start_secondary+0x4d0/0x500
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>>  [<a0000001007619c0>] __kprobes_text_end+0x340/0x370
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>> scsi_io_completion: e0000170b06e1980: inquiry completion: result 0, good_bytes 56, bufflen 255, sense_valid 0, sense e0000170b34ac5c0 / 0
>> WARNING: at drivers/scsi/scsi_lib.c:1025 scsi_io_completion()
>>
>> Call Trace:
>>  [<a000000100013ac0>] show_stack+0x40/0xa0
>>                                 sp=e0000170821c79b0 bsp=e0000170821c1050
>>  [<a000000100013b50>] dump_stack+0x30/0x60
>>                                 sp=e0000170821c7b80 bsp=e0000170821c1038
>>  [<a0000001005628b0>] scsi_io_completion+0x350/0x980
>>                                 sp=e0000170821c7b80 bsp=e0000170821c0fd0
>>  [<a0000001005547b0>] scsi_finish_command+0x1d0/0x200
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0fa0
>>  [<a000000100564070>] scsi_softirq_done+0x270/0x2a0
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0f70
>>  [<a0000001003a8480>] blk_done_softirq+0x140/0x1a0
>>                                 sp=e0000170821c7bb0 bsp=e0000170821c0f58
>>  [<a0000001000b6eb0>] __do_softirq+0xf0/0x240
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0ee0
>>  [<a0000001000b7070>] do_softirq+0x70/0xc0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e80
>>  [<a0000001000b7360>] irq_exit+0x80/0xa0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e68
>>  [<a000000100011250>] ia64_handle_irq+0x2f0/0x320
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a00000010000b100>] ia64_leave_kernel+0x0/0x270
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a000000100014bf0>] default_idle+0x110/0x180
>>                                 sp=e0000170821c7d90 bsp=e0000170821c0df0
>>  [<a000000100013870>] cpu_idle+0x230/0x360
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0db0
>>  [<a000000100961910>] start_secondary+0x4d0/0x500
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>>  [<a0000001007619c0>] __kprobes_text_end+0x340/0x370
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>> scsi_io_completion: e0000170b06e1980: inquiry completion: result 0, good_bytes 56, bufflen 255, sense_valid 0, sense e0000170b34ac5c0 / 0
>> WARNING: at drivers/scsi/scsi_lib.c:1025 scsi_io_completion()
>>
>> Call Trace:
>>  [<a000000100013ac0>] show_stack+0x40/0xa0
>>                                 sp=e0000170821c79b0 bsp=e0000170821c1050
>>  [<a000000100013b50>] dump_stack+0x30/0x60
>>                                 sp=e0000170821c7b80 bsp=e0000170821c1038
>>  [<a0000001005628b0>] scsi_io_completion+0x350/0x980
>>                                 sp=e0000170821c7b80 bsp=e0000170821c0fd0
>>  [<a0000001005547b0>] scsi_finish_command+0x1d0/0x200
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0fa0
>>  [<a000000100564070>] scsi_softirq_done+0x270/0x2a0
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0f70
>>  [<a0000001003a8480>] blk_done_softirq+0x140/0x1a0
>>                                 sp=e0000170821c7bb0 bsp=e0000170821c0f58
>>  [<a0000001000b6eb0>] __do_softirq+0xf0/0x240
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0ee0
>>  [<a0000001000b7070>] do_softirq+0x70/0xc0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e80
>>  [<a0000001000b7360>] irq_exit+0x80/0xa0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e68
>>  [<a000000100011250>] ia64_handle_irq+0x2f0/0x320
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a00000010000b100>] ia64_leave_kernel+0x0/0x270
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a000000100014bf0>] default_idle+0x110/0x180
>>                                 sp=e0000170821c7d90 bsp=e0000170821c0df0
>>  [<a000000100013870>] cpu_idle+0x230/0x360
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0db0
>>  [<a000000100961910>] start_secondary+0x4d0/0x500
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>>  [<a0000001007619c0>] __kprobes_text_end+0x340/0x370
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>> scsi_io_completion: e0000170b06e1980: inquiry completion: result 0, good_bytes 56, bufflen 255, sense_valid 0, sense e0000170b34ac5c0 / 0
>> WARNING: at drivers/scsi/scsi_lib.c:1025 scsi_io_completion()
>>
>> Call Trace:
>>  [<a000000100013ac0>] show_stack+0x40/0xa0
>>                                 sp=e0000170821c79b0 bsp=e0000170821c1050
>>  [<a000000100013b50>] dump_stack+0x30/0x60
>>                                 sp=e0000170821c7b80 bsp=e0000170821c1038
>>  [<a0000001005628b0>] scsi_io_completion+0x350/0x980
>>                                 sp=e0000170821c7b80 bsp=e0000170821c0fd0
>>  [<a0000001005547b0>] scsi_finish_command+0x1d0/0x200
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0fa0
>>  [<a000000100564070>] scsi_softirq_done+0x270/0x2a0
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0f70
>>  [<a0000001003a8480>] blk_done_softirq+0x140/0x1a0
>>                                 sp=e0000170821c7bb0 bsp=e0000170821c0f58
>>  [<a0000001000b6eb0>] __do_softirq+0xf0/0x240
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0ee0
>>  [<a0000001000b7070>] do_softirq+0x70/0xc0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e80
>>  [<a0000001000b7360>] irq_exit+0x80/0xa0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e68
>>  [<a000000100011250>] ia64_handle_irq+0x2f0/0x320
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a00000010000b100>] ia64_leave_kernel+0x0/0x270
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a000000100014bf0>] default_idle+0x110/0x180
>>                                 sp=e0000170821c7d90 bsp=e0000170821c0df0
>>  [<a000000100013870>] cpu_idle+0x230/0x360
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0db0
>>  [<a000000100961910>] start_secondary+0x4d0/0x500
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>>  [<a0000001007619c0>] __kprobes_text_end+0x340/0x370
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>> scsi_io_completion: e0000170b06e1980: inquiry completion: result 0, good_bytes 56, bufflen 255, sense_valid 0, sense e0000170b34ac5c0 / 0
>> WARNING: at drivers/scsi/scsi_lib.c:1025 scsi_io_completion()
>>
>> Call Trace:
>>  [<a000000100013ac0>] show_stack+0x40/0xa0
>>                                 sp=e0000170821c79b0 bsp=e0000170821c1050
>>  [<a000000100013b50>] dump_stack+0x30/0x60
>>                                 sp=e0000170821c7b80 bsp=e0000170821c1038
>>  [<a0000001005628b0>] scsi_io_completion+0x350/0x980
>>                                 sp=e0000170821c7b80 bsp=e0000170821c0fd0
>>  [<a0000001005547b0>] scsi_finish_command+0x1d0/0x200
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0fa0
>>  [<a000000100564070>] scsi_softirq_done+0x270/0x2a0
>>                                 sp=e0000170821c7ba0 bsp=e0000170821c0f70
>>  [<a0000001003a8480>] blk_done_softirq+0x140/0x1a0
>>                                 sp=e0000170821c7bb0 bsp=e0000170821c0f58
>>  [<a0000001000b6eb0>] __do_softirq+0xf0/0x240
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0ee0
>>  [<a0000001000b7070>] do_softirq+0x70/0xc0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e80
>>  [<a0000001000b7360>] irq_exit+0x80/0xa0
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e68
>>  [<a000000100011250>] ia64_handle_irq+0x2f0/0x320
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a00000010000b100>] ia64_leave_kernel+0x0/0x270
>>                                 sp=e0000170821c7bc0 bsp=e0000170821c0e38
>>  [<a000000100014bf0>] default_idle+0x110/0x180
>>                                 sp=e0000170821c7d90 bsp=e0000170821c0df0
>>  [<a000000100013870>] cpu_idle+0x230/0x360
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0db0
>>  [<a000000100961910>] start_secondary+0x4d0/0x500
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>>  [<a0000001007619c0>] __kprobes_text_end+0x340/0x370
>>                                 sp=e0000170821c7e30 bsp=e0000170821c0d70
>> scsi_io_completion: e0000170b06e1980: inquiry completion: result 0, good_bytes 56, bufflen 255, sense_valid 0, sense e0000170b34ac5c0 / 0
>>
>>
>> How 'bout this instead?  It completes what finished and then
>> ends the request.  I think.  I tried it using 2.6.24 and got
>> no infinite loop.
>>
>>
>>
>> --- kdbu/drivers/scsi/scsi_lib.c	2008-01-24 14:58:37.000000000 -0800
>> +++ kdb/drivers/scsi/scsi_lib.c	2008-03-19 08:49:19.456568385 -0700
>> @@ -657,13 +657,12 @@ static struct scsi_cmnd *scsi_end_reques
>>  	/*
>>  	 * If there are blocks left over at the end, set up the command
>>  	 * to queue the remainder of them.
>> +	 * blk_pc_requests are never requeued.
>>  	 */
>> -	if (end_that_request_chunk(req, uptodate, bytes)) {
>> +	if (end_that_request_chunk(req, uptodate, bytes) &&
>> +	    !blk_pc_request(req)) {
>>  		int leftover = (req->hard_nr_sectors << 9);
>>  
>> -		if (blk_pc_request(req))
>> -			leftover = req->data_len;
>> -
>>  		/* kill remainder if no retrys */
>>  		if (!uptodate && blk_noretry_request(req))
>>  			end_that_request_chunk(req, 0, leftover);
>>
>> Signed-off-by: Michael Reed <mdr@sgi.com>
> 
> This will not work. Failing to complete the remaining of the request like that
> will leak BIOs. The  upper layer bugs must be fixed. The WARN_ON is good because
> it identifies a bug at upper layer that must be fixed but goes on to
> complete the request. What you could do that will work well is at:
> +			WARN_ON(1);
> +			good_bytes = req->data_len;
> +			goto retry_end_req;
> change that to be:
> 
> +			WARN_ON(1);
> +			good_bytes = ~0;
> +			goto retry_end_req;
> 
> This will always insure a full complete of the request the second round, but
> will keep the WARN_ON for one time. The patch to scsi_req_map_sg should be applied
> for the stable 2.6.24.x releases, it is a bug.

scsi_end_that_request() doesn't do that for non-block_pc requests.  If blk_no_retry_request
is set, it just ends the leftovers.  Does that make it subject to the same leaking bio 
problem?

Could you just pass ~0 to the call to end_that_request_chunk() instead
of leftover?  This would handle the case of other code paths that get
bi_size wrong also.  (Granted, this should never happen.)

How 'bout this?  


--- a/drivers/scsi/scsi_lib.c	2008-01-24 14:58:37.000000000 -0800
+++ b/drivers/scsi/scsi_lib.c	2008-03-19 14:01:32.637078500 -0700
@@ -657,16 +657,13 @@ static struct scsi_cmnd *scsi_end_reques
 	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
+	 * blk_pc_requests are never requeued.
 	 */
 	if (end_that_request_chunk(req, uptodate, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9);
-
-		if (blk_pc_request(req))
-			leftover = req->data_len;
-
 		/* kill remainder if no retrys */
-		if (!uptodate && blk_noretry_request(req))
-			end_that_request_chunk(req, 0, leftover);
+		if ((!uptodate && blk_noretry_request(req)) ||
+		    blk_pc_request(req))
+			end_that_request_chunk(req, uptodate, ~0);
 		else {
 			if (requeue) {
 				/*


Mike
