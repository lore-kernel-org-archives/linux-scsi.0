From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/20] scsi_dh_alua: Make stpg synchronous
Date: Sat, 25 Jul 2015 17:44:11 +0200
Message-ID: <55B3AECB.60508@suse.de>
References: <1436346378-96518-1-git-send-email-hare@suse.de> <1436346378-96518-9-git-send-email-hare@suse.de> <20150724145103.GC29096@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880AbbGYPoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jul 2015 11:44:13 -0400
In-Reply-To: <20150724145103.GC29096@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>

On 07/24/2015 04:51 PM, Christoph Hellwig wrote:
>> -	memset(h->buff, 0, stpg_len);
>> -	h->buff[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
>> -	h->buff[6] =3D (h->group_id >> 8) & 0xff;
>> -	h->buff[7] =3D h->group_id & 0xff;
>> +	memset(stpg_data, 0, stpg_len);
>> +	stpg_data[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
>> +	put_unaligned_be16(group_id, &stpg_data[6]);
>=20
> Unrelated get/put_unaligned changes again.
>=20
>=20
>> -		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
>> +		if (!(driver_byte(retval) & DRIVER_SENSE) ||
>> +		    !scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
>=20
> Where does this come from?
>=20
Hmm. Probably slipped in during patch rework. I'll be removing it.

>> +		    (!h->pref) &&
>=20
>=20
> no need for braces here.
>=20
OK.

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
