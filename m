From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: [PATCH 1/2] scsi_transport_fc: FC pass through support via bsg interface - revised
Date: Wed, 22 Oct 2008 19:27:35 -0700
Message-ID: <32C8BF3A-87D5-4F89-AF4B-7731548CCD4A@qlogic.com>
References: <D5161DF5-A488-4E02-A4D4-74F5E96CC43A@qlogic.com> <20081020204604A.fujita.tomonori@lab.ntt.co.jp> <51A5EBA1-15ED-4568-98B1-824B52D6F4F6@qlogic.com> <20081020223617E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:9714 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYJWC1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 22:27:39 -0400
In-Reply-To: <20081020223617E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Smart@Emulex.Com, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com, michaelc@cs.wisc.edu, bharrosh@panasas.com, robert.w.love@intel.com


On Oct 20, 2008, at 6:36 AM, FUJITA Tomonori wrote:

> On Mon, 20 Oct 2008 05:46:22 -0700
> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>
>>
>> On Oct 20, 2008, at 4:45 AM, FUJITA Tomonori wrote:
>>
>>> On Mon, 20 Oct 2008 03:59:18 -0700
>>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>>
>>>>
>>>> On Oct 14, 2008, at 7:13 AM, Seokmann Ju wrote:
>>>>
>>>>>
>>>>> On Oct 14, 2008, at 6:34 AM, FUJITA Tomonori wrote:
>>>>>
>>>>>> On Tue, 14 Oct 2008 04:44:17 -0700
>>>>>> Seokmann Ju <seokmann.ju@qlogic.com> wrote:
>>>>>>
>>>>>>>>> +static int
>>>>>>>>> +fc_service_handler(struct Scsi_Host *shost, struct fc_rport
>>>>>>>>> *rport,
>>>>>>>>> +			  struct request *req, struct request_queue *q)
>>>>>>>>> +{
>>>>>>>>> +	int ret;
>>>>>>>>> +	struct request *rsp = req->next_rq;
>>>>>>>>> +
>>>>>>>>> +	if (!rsp) {
>>>>>>>>> +		printk(KERN_ERR "ERROR: space for a FC service"
>>>>>>>>> +		   " response is missing\n");
>>>>>>>>> +		return -EINVAL;
>>>>>>>>> +	}
>>>>>>>>> +
>>>>>>>>> +	if ((req->bio->bi_vcnt > FC_SERVICE_MAX_SG) ||
>>>>>>>>> +	    (rsp->bio->bi_vcnt > FC_SERVICE_MAX_SG)) {
>>>>>>>>> +		printk(KERN_ERR "ERROR: a FC service"
>>>>>>>>> +		    " supports no more than %d SGs\n", FC_SERVICE_MAX_SG);
>>>>>>>>> +		return -EINVAL;
>>>>>>>>> +	}
>>>>>>>>
>>>>>>>> This doesn't look correct. bi_vcnt is not related with the  
>>>>>>>> number
>>>>>>>> of
>>>>>>>> sg. You use scatter-gather for large data transfer. You don't
>>>>>>>> need to
>>>>>>>> worry about bi_vcnt.
>>>>>>> I see...
>>>>>>> Is there is a way to check, then, how many SG entries the  
>>>>>>> service
>>>>>>> needs before the blk_rq_map_sg()?
>>>>>>
>>>>>> As I wrote in the previous mail, via blk_queue_max_hw_segments()
>>>>>> and
>>>>>> blk_queue_max_phys_segments(), you can tell the block layer the
>>>>>> number
>>>>>> of sg segments you can handle.
>>>> One more question here...
>>>> With addition of a timer into the FC transport layer for fc_service
>>>> handing, the
>>>> system seems getting locked up, as below trace shows.
>>>> I've been trying to figure out the reasons but not able to do.
>>>> It seems like that there is something that I don't know,
>>>> fundamentally
>>>> about
>>>> the timer usage...
>>>> Could you please comments on what might be the things causing the
>>>> problem?
>>>
>>> Hmm, why do you need to invent the own timeout mechanism?
>> I was trying to have similar timeout mechanism as in the SCSI I/O,
>> just like 'scsi_add_timer()' in scsi.c:scsi_dispatch_cmd()....
>> I assume this is not right approach...?
>>
>>> I think that you can use the block layer timeout feature. It doesn't
>>> work for fc transport pass through? You can just remove struct
>>> timer_list in struct fc_service. Check out how scsi-ml uses
>>> blk_queue_rq_timed_out and blk_queue_rq_timeout.
>> OK. Thanks, I will try out this.
>> What are the exact name of those APIs, again?
>> It seems like that none of them are available in the source tree....
>
> You need the latest git kernel. The block layer timeout feature was
> introduced post 2.6.27. scsi_add_timer() has gone.
With this approach, I'm getting panic as below...
---
[  995.673318] qla2xxx 0000:0a:00.0: Cable is unplugged...
[  996.005310] qla2xxx 0000:0a:00.1: Cable is unplugged...
[ 1017.853786] ELS/CT: comp_status = 15
[ 1017.867789] general protection fault: 0000 [#1] SMP
[ 1017.871766] last sysfs file: /sys/block/sda/sda2/stat
[ 1017.877376] CPU 3
[ 1017.879586] Modules linked in: qla2xxx scsi_transport_fc
[ 1017.883579] Pid: 5717, comm: X Not tainted 2.6.27 #3
[ 1017.883579] RIP: 0010:[<ffffffff80348a2f>]  [<ffffffff80348a2f>]  
blk_rq_timed
_out_timer+0x63/0x13d
...

GNU gdb 6.6
Copyright (C) 2006 Free Software Foundation, Inc.
GDB is free software, covered by the GNU General Public License, and  
you are
welcome to change it and/or distribute copies of it under certain  
conditions.
Type "show copying" to see the conditions.
There is absolutely no warranty for GDB.  Type "show warranty" for  
details.
This GDB was configured as "x86_64-suse-linux"...
Using host libthread_db library "/lib64/libthread_db.so.1".
(gdb) l **blk_rq_timed_out_timer+0x63
0x1bf is in blk_rq_timed_out_timer (block/blk-timeout.c:126).
121             unsigned long flags, uninitialized_var(next), next_set  
= 0;
122             struct request *rq, *tmp;
123
124             spin_lock_irqsave(q->queue_lock, flags);
125
126             list_for_each_entry_safe(rq, tmp, &q->timeout_list,  
timeout_list) {
127                     if (time_after_eq(jiffies, rq->deadline)) {
128                             list_del_init(&rq->timeout_list);
129
130                             /*
(gdb)
---

And it seems like that the panic is happening due to the fact that  
blk_delete_timer() is not called upon having completion of the service.
In other words, the block layer calls blk_add_timer() prior to  
dispatch the service but, it doesn't call blk_delete_timer() when it  
returned.
Just for heck of it, I've tried out by adding blk_delete_timer() in  
the ~/block/blk-exec.c:blk_end_sync_rq() and it seems fixes the problem.
Seems like that there are APIs in the block layer that are call the  
blk_delete_timer(), including,
- blk_end_io()
- __blk_end_request()

Could you guide me what is right way to fix the problem?

Seokmann
