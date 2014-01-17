From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_error: disable eh_deadline if no host_reset_handler
 is set
Date: Fri, 17 Jan 2014 16:04:25 +0100
Message-ID: <52D94679.4010408@suse.de>
References: <1386846513-122051-1-git-send-email-hare@suse.de> <1389101625.3817.1042.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38356 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbaAQPE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 10:04:27 -0500
In-Reply-To: <1389101625.3817.1042.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 01/07/2014 02:33 PM, Ewan Milne wrote:
> On Thu, 2013-12-12 at 12:08 +0100, Hannes Reinecke wrote:
>> When the host template doesn't declare an eh_host_reset_handler
>> the eh_deadline mechanism is pointless and will set the
>> device to offline. So disable eh_deadline if no
>> eh_host_reset_handler is present.
>>
>> Cc: Ewan Milne <emilne@redhat.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/hosts.c      | 2 +-
>>  drivers/scsi/scsi_sysfs.c | 4 +++-
>>  2 files changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index 6966def..351afa4 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -396,7 +396,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_ho=
st_template *sht, int privsize)
>>  	shost->unchecked_isa_dma =3D sht->unchecked_isa_dma;
>>  	shost->use_clustering =3D sht->use_clustering;
>>  	shost->ordered_tag =3D sht->ordered_tag;
>> -	if (shost_eh_deadline =3D=3D -1)
>> +	if (shost_eh_deadline =3D=3D -1 || !sht->eh_host_reset_handler)
>>  		shost->eh_deadline =3D -1;
>>  	else if ((ulong) shost_eh_deadline * HZ > INT_MAX) {
>>  		shost_printk(KERN_WARNING, shost,
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 9117d0b..7434e26 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -300,7 +300,9 @@ store_shost_eh_deadline(struct device *dev, stru=
ct device_attribute *attr,
>>  	int ret =3D -EINVAL;
>>  	unsigned long deadline, flags;
>> =20
>> -	if (shost->transportt && shost->transportt->eh_strategy_handler)
>> +	if (shost->transportt &&
>> +	    (shost->transportt->eh_strategy_handler ||
>> +	     !shost->transportt->eh_host_reset_handler))
>=20
> I think this bit is supposed to be:
>=20
>         if ((shost->transportt &&
>              shost->transportt->eh_strategy_handler) ||
>             !shost->hostt->eh_host_reset_handler)
>                 return ret;
>=20
> because the field is in the scsi_host_template structure, right?
>=20
Right. Obviously.

I'll be sending an updated patch.

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
