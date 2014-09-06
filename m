From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/4] libata: consolidate ata_dev_classify()
Date: Sat, 06 Sep 2014 10:21:51 +0200
Message-ID: <540AC41F.8020506@suse.de>
References: <1406706911-79510-1-git-send-email-hare@suse.de> <1406706911-79510-2-git-send-email-hare@suse.de> <20140905234241.GH15723@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbaIFIV7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2014 04:21:59 -0400
In-Reply-To: <20140905234241.GH15723@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On 09/06/2014 01:42 AM, Tejun Heo wrote:
> Hello, Hannes.
>
> Sorry about the delay.
>
> On Wed, Jul 30, 2014 at 09:55:08AM +0200, Hannes Reinecke wrote:
>> ata_dev_classify() just uses the 'lbah' and 'lbam'
>> fields from the taskfile, so we can as well use those
>> as arguments and rip out the custom code from sas_ata.
>
> I wonder whether it'd easier to just make sas code pass in
> ata_taskfile instead?  The interface which takes three consecutive
> u8's is kinda error-prone.
>
Well, yes, in principle. I was looking into that, too.
But then I figured that moving to ata_taskfile would be a major overhau=
l=20
for libsas, which would be quite beyond scope here.
And all for a puny little patch.


>> --- a/drivers/scsi/aic94xx/aic94xx_task.c
>> +++ b/drivers/scsi/aic94xx/aic94xx_task.c
>> @@ -373,10 +373,10 @@ static int asd_build_ata_ascb(struct asd_ascb =
*ascb, struct sas_task *task,
>>
>>   	if (unlikely(task->ata_task.device_control_reg_update))
>>   		scb->header.opcode =3D CONTROL_ATA_DEV;
>> -	else if (dev->sata_dev.command_set =3D=3D ATA_COMMAND_SET)
>> -		scb->header.opcode =3D INITIATE_ATA_TASK;
>> -	else
>> +	else if (dev->sata_dev.class =3D=3D ATA_DEV_ATAPI)
>>   		scb->header.opcode =3D INITIATE_ATAPI_TASK;
>> +	else
>> +		scb->header.opcode =3D INITIATE_ATA_TASK;
>
> Are these changes covered by the patch description?  Looks like the
> patch is mixing two separate logical changes.
>
Okay, I'll be splitting them up.

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
