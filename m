From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] block: Introduce BLKPREP_DONE
Date: Thu, 21 Jul 2016 08:01:43 +0200
Message-ID: <e69ec3c4-a6ee-714b-6c5e-af1463a8214a@suse.de>
References: <1468934439-93579-1-git-send-email-hare@suse.de>
 <1468934439-93579-6-git-send-email-hare@suse.de>
 <20160721055857.GC14568@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbcGUGBp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2016 02:01:45 -0400
In-Reply-To: <20160721055857.GC14568@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@hgst.com>

On 07/21/2016 07:58 AM, Christoph Hellwig wrote:
>> +++ b/block/blk-core.c
>> @@ -2462,9 +2462,13 @@ struct request *blk_peek_request(struct reque=
st_queue *q)
>> =20
>>  			rq =3D NULL;
>>  			break;
>> -		} else if (ret =3D=3D BLKPREP_KILL || ret =3D=3D BLKPREP_INVALID)=
 {
>> +		} else if (ret =3D=3D BLKPREP_KILL || ret =3D=3D BLKPREP_INVALID =
||
>> +			   ret =3D=3D BLKPREP_DONE) {
>>  			int err =3D (ret =3D=3D BLKPREP_INVALID) ? -EREMOTEIO : -EIO;
>> =20
>> +			if (ret =3D=3D BLKPREP_DONE)
>> +				err =3D 0;
>> +
>=20
> Please just use a proper switch statement for the return values.
>=20
Ok.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
