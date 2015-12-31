From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/20] scsi_dh_alua: Use separate alua_port_group
 structure
Date: Thu, 31 Dec 2015 13:47:55 +0100
Message-ID: <568523FB.1090802@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
 <1449560260-53407-7-git-send-email-hare@suse.de>
 <20151230111751.GA14156@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbbLaMr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Dec 2015 07:47:57 -0500
In-Reply-To: <20151230111751.GA14156@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 12/30/2015 12:17 PM, Christoph Hellwig wrote:
>> +struct alua_dh_data {
>> +	struct alua_port_group	*pg;
>> +	int			group_id;
>
> Keeping the group id here seem odd.  It gets cleaned up later
> in the series, so this is just a nitpick.
>
>> -static int realloc_buffer(struct alua_dh_data *h, unsigned len)
>> +static int realloc_buffer(struct alua_port_group *pg, unsigned len)
>>   {
>> -	if (h->buff && h->buff !=3D h->inq)
>> -		kfree(h->buff);
>> +	if (pg->buff && pg->buff !=3D pg->inq)
>> +		kfree(pg->buff);
>>
>> -	h->buff =3D kmalloc(len, GFP_NOIO);
>> -	if (!h->buff) {
>> -		h->buff =3D h->inq;
>> -		h->bufflen =3D ALUA_INQUIRY_SIZE;
>> +	pg->buff =3D kmalloc(len, GFP_NOIO);
>> +	if (!pg->buff) {
>> +		pg->buff =3D pg->inq;
>> +		pg->bufflen =3D ALUA_INQUIRY_SIZE;
>>   		return 1;
>>   	}
>> -	h->bufflen =3D len;
>> +	pg->bufflen =3D len;
>>   	return 0;
>>   }
>
> All this disappears in the next patch, wouldn't it have been smarted
> to move the next one before this one?
>
Could've. Will be doing so when posting the next round,

>>   /*
>> + * alua_get_pg - Allocate a new port_group structure
>> + * @sdev: scsi device
>> + * @h: alua device_handler data
>> + * @group_id: port group id
>> + *
>> + * Allocate a new port_group structure for a given
>> + * device.
>> + */
>> +struct alua_port_group *alua_get_pg(struct scsi_device *sdev,
>> +				    int group_id, int tpgs)
>
> Can you call this alua_alloc_pg, please?
>
Sure.

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
