From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Silencing 'killing requests for dead queue'
Date: Wed, 09 Nov 2011 13:24:09 +0100
Message-ID: <4EBA70E9.8070704@suse.de>
References: <1320824364-8510-1-git-send-email-hare@suse.de> <CAO+b5-r148yneG_h3PyfP9D8BGf5x7e7XKuY73BVtPTTRPkFuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab1KIMYL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Nov 2011 07:24:11 -0500
In-Reply-To: <CAO+b5-r148yneG_h3PyfP9D8BGf5x7e7XKuY73BVtPTTRPkFuQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On 11/09/2011 12:53 PM, Bart Van Assche wrote:
> On Wed, Nov 9, 2011 at 8:39 AM, Hannes Reinecke<hare@suse.de>  wrote:
>> When we tear down a device we try to flush all outstanding
>> commands in scsi_free_queue(). However the check in
>> scsi_request_fn() is imperfect as it only signals that
>> we _might start_ aborting commands, not that we've actually
>> aborted some.
>> So move the printk inside the scsi_kill_request function,
>> this will also give us a hint about which commands are aborted.
>>
>> Signed-off-by: Hannes Reinecke<hare@suse.de>
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 06bc265..f85cfa6 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1409,6 +1409,8 @@ static void scsi_kill_request(struct request *=
req, struct request_queue *q)
>>
>>         blk_start_request(req);
>>
>> +       scmd_printk(KERN_INFO, cmd, "killing request\n");
>> +
>>         sdev =3D cmd->device;
>>         starget =3D scsi_target(sdev);
>>         shost =3D sdev->host;
>> @@ -1490,7 +1492,6 @@ static void scsi_request_fn(struct request_que=
ue *q)
>>         struct request *req;
>>
>>         if (!sdev) {
>> -               printk("scsi: killing requests for dead queue\n");
>>                 while ((req =3D blk_peek_request(q)) !=3D NULL)
>>                         scsi_kill_request(req, q);
>>                 return;
>
> Can this message appear during LUN scanning and hence confuse users ?
>
Precisely.

Which incidentally also tells us that none of the maintainer tested=20
the original patch on SCSI parallel machines :-)

> Also, patch 3308511 is already present in several stable trees so
> shouldn't a patch like the above CC stable@vger.kernel.org too ?
>
Oh. Of course.

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
