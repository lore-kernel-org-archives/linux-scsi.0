From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Wed, 02 Oct 2013 18:24:12 +0200
Message-ID: <524C48AC.2010901@suse.de>
References: <1378123118-111972-1-git-send-email-hare@suse.de> <1378123118-111972-3-git-send-email-hare@suse.de> <523C0054.9010908@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51650 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab3JBPW0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Oct 2013 11:22:26 -0400
In-Reply-To: <523C0054.9010908@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ren Mingxin <renmx@cn.fujitsu.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

On 09/20/2013 09:59 AM, Ren Mingxin wrote:
> Hi, Hannes:
>
> On 09/02/2013 07:58 PM, Hannes Reinecke wrote:
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
>> +            scmd->result |=3D DID_TIME_OUT<<  16;
>> +            if (!scsi_noretry_cmd(scmd)&&
>> +                (++scmd->retries<=3D scmd->allowed)) {
>
> I think scsi_host_eh_past_deadline() should be checked here like:
>
> -            if (!scsi_noretry_cmd(scmd)&&
> +            if (!scsi_host_eh_past_deadline(sdev->host)&&
> +                !scsi_noretry_cmd(scmd)&&
>
> According to my test, once retry requires 30 seconds. If eh_deadline
> is reached, we can stop EH here without waiting for long term
> retrying.
>

Hmm. We could. Providing the eh_deadline patches are going in.

James, should I resend the patchset?
Does it even have a chance of getting in?

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
