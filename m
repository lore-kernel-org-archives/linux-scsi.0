From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/23] scsi_dh_alua: use standard logging functions
Date: Tue, 1 Sep 2015 14:39:43 +0200
Message-ID: <55E59C8F.7000005@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-5-git-send-email-hare@suse.de>
 <20150901094821.GC9485@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbbIAMjq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 08:39:46 -0400
In-Reply-To: <20150901094821.GC9485@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/01/2015 11:48 AM, Christoph Hellwig wrote:
> On Thu, Aug 27, 2015 at 02:41:02PM +0200, Hannes Reinecke wrote:
>>  		}
>> =20
>>  		err =3D alua_check_sense(sdev, &sense_hdr);
>> -		if (err =3D=3D ADD_TO_MLQUEUE && time_before(jiffies, expiry))
>> +		if (err =3D=3D ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
>> +			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
>> +				    ALUA_DH_NAME);
>> +			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>>  			goto retry;
>> -		sdev_printk(KERN_INFO, sdev,
>> -			    "%s: rtpg sense code %02x/%02x/%02x\n",
>> -			    ALUA_DH_NAME, sense_hdr.sense_key,
>> -			    sense_hdr.asc, sense_hdr.ascq);
>> -		err =3D SCSI_DH_IO;
>> +		}
>> +		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
>> +			    ALUA_DH_NAME);
>> +		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>> +		return SCSI_DH_IO;
>>  	}
>> -	if (err !=3D SCSI_DH_OK)
>> -		return err;
>=20
> I think you need to keep this if, given that submit_rtpg can return
> others error than SCSI_DH_IO as well.
>=20
> While you're at it you might remove the h->senselen check, and
> kill the assignment of the scsi_normalize_sense bool return value
> to the err variable similar to how you did in stpg_endio.=20
>=20
Okay, will be doing so.

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
