Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7399C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 16:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D02906115B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 16:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbhDPQdI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 12:33:08 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:60113 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbhDPQdH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 12:33:07 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 210EB2EA0C6;
        Fri, 16 Apr 2021 12:32:42 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id RI--5nT84QUN; Fri, 16 Apr 2021 12:13:16 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id DB32E2EA06F;
        Fri, 16 Apr 2021 12:32:40 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi_debug: fix cmd_per_lun, set to max_queue
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        kashyap.desai@broadcom.com, ming.lei@redhat.com, axboe@kernel.dk
References: <20210415015031.607153-1-dgilbert@interlog.com>
 <408b1dce-3c6e-48dc-2f8b-23fe999ab3db@huawei.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <85dec8eb-8eab-c7d6-b0fb-5622747c5499@interlog.com>
Date:   Fri, 16 Apr 2021 12:32:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <408b1dce-3c6e-48dc-2f8b-23fe999ab3db@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-16 5:12 a.m., John Garry wrote:
> On 15/04/2021 02:50, Douglas Gilbert wrote:
>> Make sure that the cmd_per_lun value placed in the host template
>> never exceeds the can_queue value. If the max_queue driver
>> parameter is not specified then both cmd_per_lun and can_queue are
>> set to CAN_QUEUE. CAN_QUEUE is a compile time constant and is used
>> to dimension an array to hold queued requests. If the max_queue
>> driver parameter is given it is must be less than or equal to
>> CAN_QUEUE and if so, the host template values are adjusted.
>>
>> Remove undocumented code that allowed queue_depth to exceed
>> CAN_QUEUE and cause stack full type errors. There is a documented
>> way to do that with every_nth and
>>      echo 0x8000 > /sys/bus/pseudo/drivers/scsi_debug/opts
>> See: https://sg.danny.cz/sg/scsi_debug.html
>>
>> Tweak some formatting, and add a suggestion to the "trim
>> poll_queues" warning.
>>
>> Reported-by: Kashyap Desai <kashyap.desai@broadcom.com>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> 
> Just one comment, below:

The scsi_debug driver has around 64 driver startup and sysfs
parameters, many from other users. Trying to track and document
these is a pain, so to lighten my load I try to keep them in
alphabetical order. In my experience suggesting that a new patch
follows that convention doesn't always work, it gets applied in
its original form.

Anyway, I just updated:
    https://sg.danny.cz/sg/scsi_debug.html

Suggested improvements welcome.

> Reviewed-by: John Garry <john.garry@hauwei.com>

Thanks.

Doug Gilbert

>> ---
>>   drivers/scsi/scsi_debug.c | 24 ++++++++++++++++--------
>>   1 file changed, 16 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
>> index 70165be10f00..a5d1633b5bd8 100644
>> --- a/drivers/scsi/scsi_debug.c
>> +++ b/drivers/scsi/scsi_debug.c
>> @@ -218,7 +218,7 @@ static const char *sdebug_version_date = "20200710";
>>    */
>>   #define SDEBUG_CANQUEUE_WORDS  3    /* a WORD is bits in a long */
>>   #define SDEBUG_CANQUEUE  (SDEBUG_CANQUEUE_WORDS * BITS_PER_LONG)
>> -#define DEF_CMD_PER_LUN  255
>> +#define DEF_CMD_PER_LUN  SDEBUG_CANQUEUE
>>   /* UA - Unit Attention; SA - Service Action; SSU - Start Stop Unit */
>>   #define F_D_IN            1    /* Data-in command (e.g. READ) */
>> @@ -5695,8 +5695,8 @@ MODULE_PARM_DESC(lbpu, "enable LBP, support UNMAP 
>> command (def=0)");
>>   MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit 
>> (def=0)");
>>   MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit 
>> (def=0)");
>>   MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
>> -MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
>>   MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat 
>> address method");
>> +MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
> 
> Changes like this should really be in another patch.
> 
>>   MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
>>   MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on 
>> MEDIUM error");
>>   MODULE_PARM_DESC(medium_error_start, "starting sector number to return 
>> MEDIUM error");
>> @@ -5710,7 +5710,7 @@ MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer 
>> length granularity exponent
>>   MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 
>> 8->recovered_err... (def=0)");
>>   MODULE_PARM_DESC(per_host_store, "If set, next positive add_host will get 
>> new store (def=0)");
>>   MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
>> -MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues (1 to 
>> max(submit_queues - 1)");
>> +MODULE_PARM_DESC(poll_queues, "support for iouring iopoll queues (1 to 
>> max(submit_queues - 1))");
>>   MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
>>   MODULE_PARM_DESC(random, "If set, uniformly randomize command duration 
>> between 0 and delay_in_ns");
>>   MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
>> @@ -7165,12 +7165,15 @@ static int sdebug_change_qdepth(struct scsi_device 
>> *sdev, int qdepth)
>>       }
>>       num_in_q = atomic_read(&devip->num_in_q);
>> +    if (qdepth > SDEBUG_CANQUEUE) {
>> +        qdepth = SDEBUG_CANQUEUE;
>> +        pr_warn("%s: requested qdepth [%d] exceeds canqueue [%d], trim\n", 
>> __func__,
>> +            qdepth, SDEBUG_CANQUEUE);
>> +    }
>>       if (qdepth < 1)
>>           qdepth = 1;
>> -    /* allow to exceed max host qc_arr elements for testing */
>> -    if (qdepth > SDEBUG_CANQUEUE + 10)
>> -        qdepth = SDEBUG_CANQUEUE + 10;
>> -    scsi_change_queue_depth(sdev, qdepth);
>> +    if (qdepth != sdev->queue_depth)
>> +        scsi_change_queue_depth(sdev, qdepth);
>>       if (SDEBUG_OPT_Q_NOISE & sdebug_opts) {
>>           sdev_printk(KERN_INFO, sdev, "%s: qdepth=%d, num_in_q=%d\n",
>> @@ -7558,6 +7561,7 @@ static int sdebug_driver_probe(struct device *dev)
>>       sdbg_host = to_sdebug_host(dev);
>>       sdebug_driver_template.can_queue = sdebug_max_queue;
>> +    sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
>>       if (!sdebug_clustering)
>>           sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
>> @@ -7593,7 +7597,11 @@ static int sdebug_driver_probe(struct device *dev)
>>        * If condition not met, trim poll_queues to 1 (just for simplicity).
>>        */
>>       if (poll_queues >= submit_queues) {
>> -        pr_warn("%s: trim poll_queues to 1\n", my_name);
>> +        if (submit_queues < 3)
>> +            pr_warn("%s: trim poll_queues to 1\n", my_name);
>> +        else
>> +            pr_warn("%s: trim poll_queues to 1. Perhaps try poll_queues=%d\n",
>> +                my_name, submit_queues - 1);
>>           poll_queues = 1;
>>       }
>>       if (poll_queues)
>>
> 

