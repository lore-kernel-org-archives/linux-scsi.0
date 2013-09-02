From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Mon, 02 Sep 2013 15:11:08 +0200
Message-ID: <52248E6C.2060105@suse.de>
References: <1378105985-79686-1-git-send-email-hare@suse.de> <1378105985-79686-4-git-send-email-hare@suse.de> <52248882.7060109@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756349Ab3IBNLJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Sep 2013 09:11:09 -0400
In-Reply-To: <52248882.7060109@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>

On 09/02/2013 02:45 PM, Bart Van Assche wrote:
> On 09/02/13 09:12, Hannes Reinecke wrote:
>> @@ -353,6 +354,8 @@ void scsi_put_command(struct scsi_cmnd *cmd)
>>       list_del_init(&cmd->list);
>>       spin_unlock_irqrestore(&cmd->device->list_lock, flags);
>>
>> +    cancel_delayed_work(&cmd->abort_work);
>> +
>>       __scsi_put_command(cmd->device->host, cmd, &sdev->sdev_gendev)=
;
>>   }
>>   EXPORT_SYMBOL(scsi_put_command);
>=20
> Is this approach safe ? Is it e.g. possible that the abort work
> starts just before the cancel_delayed_work() call and continues to
> run after scsi_put_command() has finished ? In
> drivers/scsi/libfc/fc_exch.c a similar issue is solved by holding an
> additional reference as long as delayed work (fc_exch.timeout_work)
> is queued.
>=20
I have been thinking of this, and in fact my original approach had
'cancel_delayed_work_sync' here. However, this didn't work as
scsi_put_command() might end up being called from an softirq context.

=46rom my understanding the workqueue stuff guarantees that either
a) the workqueue item is still queued
   -> cancel_delayed_work will be in fact synchronous, as it'll
      cancel queue item from the queue
b) the workqueue item is running
   -> cancel_delayed_work is essentially a no-op, as the function
      is running and will be terminated anyway.

IE from the API perspective the transition between 'queued' and
'running' is atomic, and no in-between states are visible.

So case a) is obviously safe, and for case b) the abort function is
already running. But then the abort function has been called from
the block timeout handler, which did a blk_mark_rq_complete() prior
to calling the handler. So any completion coming in after that will
be ignored, and scsi_put_command() won't be called.

Hence we should be safe here.

>> +void
>> +scmd_eh_abort_handler(struct work_struct *work)
>> +{
>> +    struct scsi_cmnd *scmd =3D
>> +        container_of(work, struct scsi_cmnd, abort_work.work);
>> +    struct scsi_device *sdev =3D scmd->device;
>> +    unsigned long flags;
>> +    int rtn;
>> +
>> +    spin_lock_irqsave(sdev->host->host_lock, flags);
>> +    if (scsi_host_eh_past_deadline(sdev->host)) {
>> +        spin_unlock_irqrestore(sdev->host->host_lock, flags);
>> +        SCSI_LOG_ERROR_RECOVERY(3,
>> +            scmd_printk(KERN_INFO, scmd,
>> +                    "scmd %p eh timeout, not aborting\n", scmd));
>> +    } else {
>> +        spin_unlock_irqrestore(sdev->host->host_lock, flags);
>> +        SCSI_LOG_ERROR_RECOVERY(3,
>> +            scmd_printk(KERN_INFO, scmd,
>> +                    "aborting command %p\n", scmd));
>> +        rtn =3D scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
>> +        if (rtn =3D=3D SUCCESS) {
>> +            scmd->result |=3D DID_TIME_OUT << 16;
>> +            if (!scsi_noretry_cmd(scmd) &&
>> +                (++scmd->retries <=3D scmd->allowed)) {
>> +                SCSI_LOG_ERROR_RECOVERY(3,
>> +                    scmd_printk(KERN_WARNING, scmd,
>> +                            "scmd %p retry "
>> +                            "aborted command\n", scmd));
>> +                scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
>> +            } else {
>> +                SCSI_LOG_ERROR_RECOVERY(3,
>> +                    scmd_printk(KERN_WARNING, scmd,
>> +                            "scmd %p finish "
>> +                            "aborted command\n", scmd));
>> +                scsi_finish_command(scmd);
>> +            }
>> +            return;
>> +        }
>> +        SCSI_LOG_ERROR_RECOVERY(3,
>> +            scmd_printk(KERN_INFO, scmd,
>> +                    "scmd %p abort failed, rtn %d\n",
>> +                    scmd, rtn));
>> +    }
>> +
>> +    if (scsi_eh_scmd_add(scmd, 0)) {
>> +        SCSI_LOG_ERROR_RECOVERY(3,
>> +            scmd_printk(KERN_WARNING, scmd,
>> +                    "scmd %p terminate "
>> +                    "aborted command\n", scmd));
>> +        scmd->result |=3D DID_TIME_OUT << 16;
>> +        scsi_finish_command(scmd);
>> +    }
>> +}
>=20
> This patch adds several new calls to LLD EH handlers. Is it
> guaranteed that these will only be invoked before scsi_remove_host()
> has finished ? For more background information, see also "[PATCH]
> Make scsi_remove_host() wait until error handling finished"
> (http://thread.gmane.org/gmane.linux.scsi/82572/focus=3D82779).
>=20
Well, that depends how scsi_remove_host() handles outstanding
commands. What happens if you call scsi_remove_host() and there is
still I/O in flight? I would assume that any HBA would have to kill
any outstanding I/O prior to calling scsi_remove_host() (FC most
certainly does this).
Which would mean that it'll have to wait for scsi_put_command() to
be called for all outstanding commands. And as scsi_put_command()
will be called only _after_ our routine runs (see the reasoning
above) we should be safe.

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
