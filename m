From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Fix SATA ATAPI error handling
Date: Fri, 27 May 2005 08:52:38 +0200
Message-ID: <4296C3B6.3060806@suse.de>
References: <42418B10.6090009@suse.de> <42969AC8.6070904@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:19859 "EHLO mx2.suse.de")
	by vger.kernel.org with ESMTP id S261900AbVE0Gwj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 02:52:39 -0400
In-Reply-To: <42969AC8.6070904@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, Jens Axboe <axboe@suse.de>, Kurt Garloff <garloff@suse.de>

Jeff Garzik wrote:
> Hannes Reinecke wrote:
>> +static void scsi_invoke_strategy_handler(struct Scsi_Host *shost)
>> +{
>> +    int rtn;
>> +    struct list_head *lh, *lh_sf;
>> +    struct scsi_cmnd *scmd;
>> +    unsigned long flags;
>> +    LIST_HEAD(eh_work_q);
>> +    LIST_HEAD(eh_done_q);
>> +
>> +    rtn =3D shost->hostt->eh_strategy_handler(shost);
>> +
>> +    spin_lock_irqsave(shost->host_lock, flags);
>> +    list_splice_init(&shost->eh_cmd_q, &eh_work_q);
>> +    spin_unlock_irqrestore(shost->host_lock, flags);
>> +
>> +    SCSI_LOG_ERROR_RECOVERY(1, scsi_eh_prt_fail_stats(shost,
>> &eh_work_q));
>> +
>> +    list_for_each_safe(lh, lh_sf, &eh_work_q) {
>> +        scmd =3D list_entry(lh, struct scsi_cmnd, eh_entry);
>> +
>> +        if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD) ||
>> +            !SCSI_SENSE_VALID(scmd))
>> +            continue;
>> +        scmd->retries =3D scmd->allowed;
>> +        scsi_eh_finish_cmd(scmd, &eh_done_q);
>> +    }
>> +
>> +    if (!list_empty(&eh_work_q))
>> +        if (!scsi_eh_abort_cmds(&eh_work_q, &eh_done_q))
>> +            scsi_eh_ready_devs(shost, &eh_work_q, &eh_done_q);
>=20
>=20
> The scsi_eh_abort_cmds() call doesn't do much, since all calls to
> scsi_try_to_abort_cmd() will fail due to libata's lack of EH abort ha=
ndler.
>=20
Yeah, noticed that one, too. Sometimes after I did the patch.
The main point of the patch is that the eh_work_q _has_ to be emptied,
regardless whether we can do something with the command. Otherwise it
will always kick in and try to abort the command.

> The latter code will print "aborting cmd failed" for the command, and
> not much else.
>=20
You are correct; the correct way of doing things would be to abort the
SATA commands or, failing that, reset the device/bus/adapter.

Only from reading the source I got the impression that the only reset
method is a full bus reset. And the spec only added to the confusion.
So I left it there, as this point was never reached anyway.

After sorting out issue with ATAPI commands not having a proper sense
code (patch by Albert Lee regarding completing a command twice) the
error handler could actually _do_ something with the failed command.
Afterwards all cmds would be removed all command from the queue and
everyone was happy.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux AG				S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
