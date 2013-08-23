From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Fri, 23 Aug 2013 14:27:54 +0200
Message-ID: <5217554A.8070506@suse.de>
References: <1372688671-85639-1-git-send-email-hare@suse.de> <1372688671-85639-4-git-send-email-hare@suse.de> <5215D123.7030908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291Ab3HWL03 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Aug 2013 07:26:29 -0400
In-Reply-To: <5215D123.7030908@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

On 08/22/2013 10:51 AM, Ren Mingxin wrote:
> Hi, Hannes:
>
> On 07/01/2013 10:24 PM, Hannes Reinecke wrote:
>> When a command runs into a timeout we need to send an 'ABORT TASK'
>> TMF. This is typically done by the 'eh_abort_handler' LLDD callback.
>>
>> Conceptually, however, this function is a normal SCSI command, so
>> there is no need to enter the error handler.
>>
>> This patch implements a new scsi_abort_command() function which
>> invokes an asynchronous function scsi_eh_abort_handler() to
>> abort the commands via the usual 'eh_abort_handler'.
>>
>> If abort succeeds the command is either retried or terminated,
>> depending on the number of allowed retries. However, 'eh_eflags'
>> records the abort, so if the retry would fail again the
>> command is pushed onto the error handler without trying to
>> abort it (again); it'll be cleared up from SCSI EH.
>>
>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>> ---
>>   drivers/scsi/scsi.c       |   1 +
>>   drivers/scsi/scsi_error.c | 139
>> ++++++++++++++++++++++++++++++++++++++++++----
>>   drivers/scsi/scsi_priv.h  |   2 +
>>   include/scsi/scsi_cmnd.h  |   2 +
>>   4 files changed, 132 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index ebe3b0a..06257cf 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -297,6 +297,7 @@ struct scsi_cmnd *scsi_get_command(struct
>> scsi_device *dev, gfp_t gfp_mask)
>>
>>           cmd->device =3D dev;
>>           INIT_LIST_HEAD(&cmd->list);
>> +        INIT_WORK(&cmd->abort_work, scmd_eh_abort_handler);
>>           spin_lock_irqsave(&dev->list_lock, flags);
>>           list_add_tail(&cmd->list,&dev->cmd_list);
>>           spin_unlock_irqrestore(&dev->list_lock, flags);
>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>> index e76e895..835f7e4 100644
>> --- a/drivers/scsi/scsi_error.c
>> +++ b/drivers/scsi/scsi_error.c
>> @@ -55,6 +55,7 @@ static void scsi_eh_done(struct scsi_cmnd *scmd);
>>   #define HOST_RESET_SETTLE_TIME  (10)
>>
>>   static int scsi_eh_try_stu(struct scsi_cmnd *scmd);
>> +static int scsi_try_to_abort_cmd(struct scsi_host_template *, struc=
t
>> scsi_cmnd *);
>>
>>   /* called with shost->host_lock held */
>>   void scsi_eh_wakeup(struct Scsi_Host *shost)
>> @@ -102,6 +103,111 @@ static int scsi_host_eh_past_deadline(struct
>> Scsi_Host *shost)
>>   }
>>
>>   /**
>> + * scmd_eh_abort_handler - Handle command aborts
>> + * @work:    command to be aborted.
>> + */
>> +void
>> +scmd_eh_abort_handler(struct work_struct *work)
>> +{
>> +    struct scsi_cmnd *scmd =3D
>> +        container_of(work, struct scsi_cmnd, abort_work);
>> +    struct scsi_device *sdev =3D scmd->device;
>> +    unsigned long flags;
>> +    int rtn;
>> +
>> +    spin_lock_irqsave(sdev->host->host_lock, flags);
>> +    if (scsi_host_eh_past_deadline(sdev->host)) {
>> +        spin_unlock_irqrestore(sdev->host->host_lock, flags);
>> +        SCSI_LOG_ERROR_RECOVERY(3,
>> +            scmd_printk(KERN_INFO, scmd,
>> +                    "eh timeout, not aborting\n"));
>
> Command address should be also printed for debugging conveniently:
> +"eh timeout, not aborting command %p\n", scmd));
>
Hmm. Okay, I could. Will be preparing an updated patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
