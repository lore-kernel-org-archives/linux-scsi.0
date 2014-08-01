From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH -next] scsi: fix u14-34f printk format warnings
Date: Fri, 01 Aug 2014 11:24:44 +0200
Message-ID: <53DB5CDC.1060405@suse.de>
References: <53D14B7E.7000602@infradead.org> <53DA6E25.4090409@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHAJYq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2014 05:24:46 -0400
In-Reply-To: <53DA6E25.4090409@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@infradead.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Dario Ballabio <ballabio_dario@emc.com>

On 07/31/2014 06:26 PM, Randy Dunlap wrote:
> any comments?
>
> Thanks.
>
> On 07/24/14 11:07, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix printk format warnings (seen on i386 builds):
>>
>> ../drivers/scsi/u14-34f.c: In function 'port_detect':
>> ../drivers/scsi/u14-34f.c:630:28: warning: format '%u' expects argum=
ent of type 'unsigned int', but argument 4 has type 'u64' [-Wformat=3D]
>> ../drivers/scsi/u14-34f.c: In function 'u14_34f_queuecommand_lck':
>> ../drivers/scsi/u14-34f.c:1290:25: warning: format '%llu' expects ar=
gument of type 'long long unsigned int', but argument 6 has type 'int' =
[-Wformat=3D]
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> ---
>>   drivers/scsi/u14-34f.c |    4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: linux-next-20140724/drivers/scsi/u14-34f.c
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> --- linux-next-20140724.orig/drivers/scsi/u14-34f.c
>> +++ linux-next-20140724/drivers/scsi/u14-34f.c
>> @@ -1006,7 +1006,7 @@ static int port_detect \
>>             sh[j]->irq, dma_name, sh[j]->sg_tablesize, sh[j]->can_qu=
eue);
>>
>>      if (sh[j]->max_id > 8 || sh[j]->max_lun > 8)
>> -      printk("%s: wide SCSI support enabled, max_id %u, max_lun %u.=
\n",
>> +      printk("%s: wide SCSI support enabled, max_id %u, max_lun %ll=
u.\n",
>>                BN(j), sh[j]->max_id, sh[j]->max_lun);
>>
>>      for (i =3D 0; i <=3D sh[j]->max_channel; i++)
>> @@ -1285,7 +1285,7 @@ static int u14_34f_queuecommand_lck(stru
>>      cpp->cpp_index =3D i;
>>      SCpnt->host_scribble =3D (unsigned char *) &cpp->cpp_index;
>>
>> -   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%llu.\n",
>> +   if (do_trace) printk("%s: qcomm, mbox %d, target %d.%d:%u.\n",
>>                           BN(j), i, SCpnt->device->channel, SCpnt->d=
evice->id,
>>                           (u8)SCpnt->device->lun);
>>
>> --
>
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
