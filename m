From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 3/6] scsi_debug: add multiple queue support
Date: Tue, 10 May 2016 00:30:43 +0200
Message-ID: <57310F93.2000709@interlog.com>
References: <1462509629-24282-1-git-send-email-dgilbert@interlog.com>
 <1462509629-24282-4-git-send-email-dgilbert@interlog.com>
 <5730B6EC.90001@sandisk.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:43310 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446AbcEIWau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 May 2016 18:30:50 -0400
In-Reply-To: <5730B6EC.90001@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, tomas.winkler@intel.com, emilne@redhat.com

On 2016-05-09 06:12 PM, Bart Van Assche wrote:
> On 05/05/2016 09:40 PM, Douglas Gilbert wrote:
>>   static bool stop_queued_cmnd(struct scsi_cmnd *cmnd)
>>   {
>>       unsigned long iflags;
>> -    int k, qmax, r_qmax;
>> +    int j, k, qmax, r_qmax;
>> +    struct sdebug_queue *sqp;
>>       struct sdebug_queued_cmd *sqcp;
>>       struct sdebug_dev_info *devip;
>>       struct sdebug_defer *sd_dp;
>>
>> -    [ ... ]
>> +    for (j = 0, sqp = sdebug_q_arr; j < submit_queues; ++j, ++sqp) {
>> +        spin_lock_irqsave(&sqp->qc_lock, iflags);
>> +        qmax = sdebug_max_queue;
>> +        r_qmax = atomic_read(&retired_max_queue);
>> +        if (r_qmax > qmax)
>> +            qmax = r_qmax;
>> +        for (k = 0; k < qmax; ++k) {
>> +            if (test_bit(k, sqp->in_use_bm)) {
>> +                sqcp = &sqp->qc_arr[k];
>> +                if (cmnd != sqcp->a_cmnd)
>> +                    continue;
>> +                /* found */
>> +                [ ... ]
>
> It is not clear to me why a for-loop is used in this function to look up the sqp
> pointer instead of calling get_queue() or using sqa_idx?

Yes get_queue() could be used to remove the outer loop.

sqa_idx is found in the sdebug_defer structure and instances of it
exist only for scsi commands that are currently deferred (on or work
item or a hr timer). There is a pointer from scsi_defer to the
corresponding scsi_cmnd but not vice versa.

Using the every_nth parameter, scsi commands can be ignored, meaning
they are neither deferred (queued) nor completed (by calling scsi_done()).
In this case the driver just returns on the command delivery thread
(without error) and forgets about that scsi command instance. It is
simulating an unreported transport or LLD failure. So there is an
extremely high chance the mid-level will attempt to abort that command.
In that case there is no related sqa_idx and that scsi command will not
be found by stop_queued_cmnd(). That is fine since there are no related
resources to free up.

So IMO the code is correct as it stands but its efficiency could be
improved by using get_queue() to replace the outer loop.

>>   static const char * scsi_debug_info(struct Scsi_Host * shp)
>>   {
>> -    sprintf(sdebug_info,
>> -        "scsi_debug, version %s [%s], dev_size_mb=%d, opts=0x%x",
>> -        SDEBUG_VERSION, sdebug_version_date, sdebug_dev_size_mb,
>> -        sdebug_opts);
>> +    int k;
>> +
>> +    k = scnprintf(sdebug_info, sizeof(sdebug_info),
>> +              "%s: version %s [%s], dev_size_mb=%d, opts=0x%x\n",
>> +              my_name, SDEBUG_VERSION, sdebug_version_date,
>> +              sdebug_dev_size_mb, sdebug_opts);
>> +    if (k >= (sizeof(sdebug_info) - 1))
>> +        return sdebug_info;
>> +    scnprintf(sdebug_info + k, sizeof(sdebug_info) - k,
>> +          "%s: submit_queues=%d, statistics=%d\n", my_name,
>> +          submit_queues, (int)sdebug_statistics);
>>       return sdebug_info;
>>   }
>
>  From the comment above the definition of scnprintf(): "The return value is the
> number of characters written into @buf not including the trailing '\0'". Maybe
> you need snprintf() instead of scnprintf()?

The maximum return value from the first scnprintf(sdebug_info ...)
is (sizeof(sdebug_info) - 1)). So strictly speaking the early return
comparison should be "==" for scnprintf and ">=" for snprintf. Given
that snprintf is more dangerous then scnprintf (e.g. with repeated
"k += snprintf(buff + k, buff_len - k, ...)" statements) then I would
prefer to keep scnprintf and yes, ">=" is overkill but will work.

Doug Gilbert
