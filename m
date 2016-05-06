From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2.5 3/6] scsi_debug: add multiple queue support
Date: Thu, 5 May 2016 23:47:58 -0400
Message-ID: <572C13EE.2040800@interlog.com>
References: <1462070687-12689-1-git-send-email-dgilbert@interlog.com>
 <1462070687-12689-4-git-send-email-dgilbert@interlog.com>
 <572A7888.6000804@sandisk.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55335 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026AbcEFDsH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 May 2016 23:48:07 -0400
In-Reply-To: <572A7888.6000804@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 2016-05-04 06:32 PM, Bart Van Assche wrote:
> On 04/30/2016 07:44 PM, Douglas Gilbert wrote:
>> +static struct sdebug_queue *get_queue(void)
>> +{
>> +    struct sdebug_queue *sqp = sdebug_q_arr;
>> +
>> +    return sqp + (raw_smp_processor_id() % submit_queues);
>> +}
>
> Does this function have the same purpose as blk_mq_map_queue()? If so, why has
> this function been introduced instead of using blk_mq_map_queue()?

No, it is copied from drivers/block/null_blk.c, the nullb_to_queue()
function. scsi_lib.c seems to be the only user of blk_mq_map_queue().

>> @@ -5001,6 +5158,10 @@ static int scsi_debug_queuecommand(struct Scsi_Host
>> *shost,
>>       bool has_wlun_rl;
>>
>>       scsi_set_resid(scp, 0);
>> +    if (sdebug_statistics) {
>> +        sqp = get_queue();
>> +        atomic_inc(&sqp->cmnd_count);
>> +    }
>
> Why does scsi_debug_queuecommand() call get_queue() instead of
> blk_mq_unique_tag() and blk_mq_unique_tag_to_hwq() which is what other scsi-mq
> drivers do?

Okay I have switched to using:
     u32 tag = blk_mq_unique_tag(cmnd->request);
     u16 hwq = blk_mq_unique_tag_to_hwq(tag);
     return sqp + hwq;

and as far as I can tell it works just as well as:
     return sqp + (raw_smp_processor_id() % submit_queues);

> Is the role of the sqp->cmnd_count counter identical to that of
> blk_mq_hw_ctx.queued? If so, can sqp->cmnd_count be left out and can
> blk_mq_hw_ctx.queued be used instead?

Not quite, it counts commands in, some of which may get
responded to in the same thread (e.g. when a SCSI illegal request
type error is being reported). But it is very close to my
"completions" count.

So I'll move those counters back into file scope which simplifies
scsi_debug's logic. The cmnd_counter is used in the injection of
pseudo errors "every_nth" command. Can blk_mq_hw_ctx.queued be
viewed from the user space?

>> @@ -5168,6 +5328,16 @@ static int sdebug_driver_probe(struct device * dev)
>> +    if (sdebug_mq_available && (submit_queues > 1))
>> +        hpnt->nr_hw_queues = submit_queues;
>
> There is already a submit_queues < 1 check in scsi_debug_init(). Is the
> submit_queues > 1 check in sdebug_driver_probe() needed?

I noticed that the other (2) scsi mq LLDs take care only to set
hpnt->nr_hw_queues when the submit_queues > 1 .

Tomorrow I plan to issue a "v3" of this patchset.

Doug Gilbert
