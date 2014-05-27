From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 1/3] Remove two cancel_delayed_work() calls from the error
 handler
Date: Tue, 27 May 2014 10:06:07 +0200
Message-ID: <5384476F.6010705@acm.org>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org> <53835C55.6070400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:35793 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717AbaE0IGJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 May 2014 04:06:09 -0400
In-Reply-To: <53835C55.6070400@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/26/14 17:23, Paolo Bonzini wrote:
> Il 26/05/2014 17:14, Bart Van Assche ha scritto:
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 88d46fe..c972eab 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -334,7 +334,7 @@ void scsi_put_command(struct scsi_cmnd *cmd)
>>      list_del_init(&cmd->list);
>>      spin_unlock_irqrestore(&cmd->device->list_lock, flags);
>>
>> -    cancel_delayed_work(&cmd->abort_work);
>> +    WARN_ON_ONCE(delayed_work_pending(&cmd->abort_work));
>>
>>      __scsi_put_command(cmd->device->host, cmd);
>>  }
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index f17aa7a..5232583 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -193,7 +193,7 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>>          SCSI_LOG_ERROR_RECOVERY(3,
>>              scmd_printk(KERN_INFO, scmd,
>>                      "scmd %p previous abort failed\n", scmd));
>> -        cancel_delayed_work(&scmd->abort_work);
>> +        WARN_ON_ONCE(delayed_work_pending(&scmd->abort_work));
>>          return FAILED;
>>      }
>>
>>
> 
> I still prefer a BUG_ON in scsi_put_command, but anyway: series
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Hello Paolo,

As you probably know scsi_put_command() can get called from softirq
context. A BUG_ON() in that context might make it unnecessary hard for a
user to collect call traces.

Bart.
