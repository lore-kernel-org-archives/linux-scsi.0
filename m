From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/4] scsi: improved eh timeout handler
Date: Fri, 07 Jun 2013 08:42:52 +0200
Message-ID: <51B180EC.4050107@suse.de>
References: <1370511835-50072-1-git-send-email-hare@suse.de> <1370511835-50072-4-git-send-email-hare@suse.de> <20130606162320.GC16616@logfs.org> <51B0F372.6040702@suse.de> <20130606202826.GB17707@logfs.org> <51B17CD8.3030009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3FGGm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Jun 2013 02:42:57 -0400
In-Reply-To: <51B17CD8.3030009@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On 06/07/2013 08:25 AM, Ren Mingxin wrote:
> Hi, Hannes:
>=20
> On 06/07/2013 04:28 AM, J=C3=B6rn Engel wrote:
>> On Thu, 6 June 2013 22:39:14 +0200, Hannes Reinecke wrote:
>>>>> +        spin_unlock_irqrestore(&sdev->list_lock, flags);
>>>>> +        SCSI_LOG_ERROR_RECOVERY(3,
>>>>> +            scmd_printk(KERN_INFO, scmd,
>>>>> +                    "aborting command %p\n", scmd));
>>>>> +        rtn =3D scsi_try_to_abort_cmd(shost->hostt, scmd);
>>>>> +        if (rtn =3D=3D SUCCESS || rtn =3D=3D FAST_IO_FAIL) {
>>>>> +            if (((scmd->request->cmd_flags&  REQ_FAILFAST_DEV) |=
|
>>>>
>>>> Am I being stupid again or should this be negated?
>>>>
>>> Knowing you I would think the former; where do you see the negation=
?
>>
>> If REQ_FAILFAST_DEV is set, this runs scsi_queue_insert(), which I
>> would expect it should run scsi_finish_command().
>=20
> I also think (scmd->request->cmd_flags & REQ_FAILFAST_DEV) and
> (scmd->request->cmd_type =3D=3D REQ_TYPE_BLOCK_PC) should be negated.
Bummer. You are correct.

So far I've only encountered the 'BLOCK_PC' condition, which worked.

> I'm confused why not use !scsi_noretry_cmd(scmd) directly as your
> former patch here?
>=20
Hehe. I've fallen into the trap myself.
scsi_noretry_cmd() only works if you have a status for the command,
and will only evaluate REQ_FAILFAST_DEV or BLOCK_PC if the command
has a CHECK CONDITION status.
As this is the timeout handler we do _not_ have any status, so
scsi_noretry_cmd() will always tell us that the command should be
retried.

>>>>> +                 (scmd->request->cmd_type =3D=3D
>>>>> REQ_TYPE_BLOCK_PC))&&
>>>>> +                (++scmd->retries<=3D scmd->allowed)) {
>>>>> +                SCSI_LOG_ERROR_RECOVERY(3,
>>>>> +                    scmd_printk(KERN_WARNING, scmd,
>>>>> +                            "retry aborted command\n"));
>>>>> +
>>>>> +                scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
>>>>> +            } else {
>>>>> +                SCSI_LOG_ERROR_RECOVERY(3,
>>>>> +                    scmd_printk(KERN_WARNING, scmd,
>>>>> +                            "fast fail aborted command\n"));
>>>>> +                scmd->result |=3D DID_TRANSPORT_FAILFAST<<  16;
>>>>> +                scsi_finish_command(scmd);
>>>>> +            }
>>>>> +        } else {
>>>>> +            if (!scsi_eh_scmd_add(scmd, 0)) {
>>>>> +                SCSI_LOG_ERROR_RECOVERY(3,
>>>>> +                    scmd_printk(KERN_WARNING, scmd,
>>>>> +                            "terminate aborted command\n"));
>>>>> +                scmd->result |=3D DID_TIME_OUT<<  16;
>>>>> +                scsi_finish_command(scmd);
>>>>> +            }
>>>>> +        }
>>>>> +        spin_lock_irqsave(&sdev->list_lock, flags);
>>>>> +    }
>>>>> +    spin_unlock_irqrestore(&sdev->list_lock, flags);
>> ...
>>>>> +/**
>>>>> + * scsi_abort_command - schedule a command abort
>>>>> + * @scmd:    scmd to abort.
>>>>> + *
>>>>> + * We only need to abort commands after a command timeout
>>>>> + */
>>>>> +void
>>>>> +scsi_abort_command(struct scsi_cmnd *scmd)
>>>>> +{
>>>>> +    unsigned long flags;
>>>>> +    int kick_worker =3D 0;
>>>>> +    struct scsi_device *sdev =3D scmd->device;
>>>>> +
>>>>> +    spin_lock_irqsave(&sdev->list_lock, flags);
>>>>> +    if (list_empty(&sdev->eh_abort_list))
>>>>> +        kick_worker =3D 1;
>>>>> +    list_add(&scmd->eh_entry,&sdev->eh_abort_list);
>>>>> +    SCSI_LOG_ERROR_RECOVERY(3,
>>>>> +        scmd_printk(KERN_INFO, scmd, "adding to
>>>>> eh_abort_list\n"));
>>>>> +    spin_unlock_irqrestore(&sdev->list_lock, flags);
>>>>> +    if (kick_worker)
>>>>> +        schedule_work(&sdev->abort_work);
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(scsi_abort_command);
>=20
> Should the name of function above be more ideographic/understandable?
> For example, scsi_abort_scmd_add? I was bewildered among functions
> named scsi_abort_eh_cmnd, scsi_eh_abort_cmds...
>=20
scsi_abort_scmd_add()? That's even more confusing.

scsi_abort_command() does exactly this, it aborts a command.
Yeah, the individual wrapper/callback function naming might be
improved, but this is the one function which actually does what it
advertises ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
