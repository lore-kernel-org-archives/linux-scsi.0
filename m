From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH RFC] Remove the cancel_delayed_work() call from scsi_put_command()
Date: Thu, 22 May 2014 19:41:06 +0200
Message-ID: <537E36B2.6040500@acm.org>
References: <537CAA79.2030304@acm.org> <537E2435.7030705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:48724 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaEVRlK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 13:41:10 -0400
In-Reply-To: <537E2435.7030705@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>

On 05/22/14 18:22, Paolo Bonzini wrote:
> Il 21/05/2014 15:30, Bart Van Assche ha scritto:
>> +static bool scmd_being_handled_in_other_context(struct scsi_cmnd *scmd)
>> +{
>> +    struct Scsi_Host *shost = scmd->device->host;
>> +    struct scsi_cmnd *c;
>> +    unsigned long flags;
>> +    bool ret = false;
>> +
>> +    if (!blk_rq_completed(scmd->request))
>> +        return true;
>> +
>> +    spin_lock_irqsave(shost->host_lock, flags);
>> +    list_for_each_entry(c, &shost->eh_cmd_q, eh_entry) {
>> +        if (c == scmd) {
>> +            ret = true;
>> +            break;
>> +        }
>> +    }
>> +    spin_unlock_irqrestore(shost->host_lock, flags);
>> +
>> +    return ret;
>> +}
>> +
>>  /**
>>   * scmd_eh_abort_handler - Handle command aborts
>>   * @work:    command to be aborted.
>> @@ -120,6 +142,8 @@ scmd_eh_abort_handler(struct work_struct *work)
>>      struct scsi_device *sdev = scmd->device;
>>      int rtn;
>>
>> +    WARN_ON_ONCE(scmd_being_handled_in_other_context(scmd));
> 
> What about a simpler, though less accuracte
> 
>     WARN_ON(!blk_rq_completed(scmd->request));
> 
> that doesn't need the host_lock?

One reason why I posted this patch as an RFC was to invite feedback. I'm
fine with leaving out the loop over the eh_cmd_q list although I do not
expect that will make a significant performance difference. None of the
functions in which a check was added are in the hot path.

Bart.

