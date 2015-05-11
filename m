From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/17] scsi_dh_alua: Use vpd_pg83 information
Date: Mon, 11 May 2015 12:11:55 +0200
Message-ID: <5550806B.6070005@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de> <1430743343-47174-4-git-send-email-hare@suse.de> <20150511064848.GC30516@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbbEKKL5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2015 06:11:57 -0400
In-Reply-To: <20150511064848.GC30516@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 05/11/2015 08:48 AM, Christoph Hellwig wrote:
>> @@ -352,55 +315,42 @@ static int alua_check_tpgs(struct scsi_device =
*sdev, struct alua_dh_data *h)
>>  		sdev_printk(KERN_INFO, sdev, "%s: supports implicit TPGS\n",
>>  			    ALUA_DH_NAME);
>>  		break;
>> -	default:
>> -		h->tpgs =3D TPGS_MODE_NONE;
>> +	case TPGS_MODE_NONE:
>>  		sdev_printk(KERN_INFO, sdev, "%s: not supported\n",
>>  			    ALUA_DH_NAME);
>>  		err =3D SCSI_DH_DEV_UNSUPP;
>>  		break;
>> +	default:
>> +		sdev_printk(KERN_INFO, sdev,
>> +			    "%s: unsupported TPGS setting %d\n",
>> +			    ALUA_DH_NAME, h->tpgs);
>> +		h->tpgs =3D TPGS_MODE_NONE;
>> +		err =3D SCSI_DH_DEV_UNSUPP;
>> +		break;
>=20
> Can you split this into a separate patch, please?
>=20
> Otherwise looks fine, so:
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>=20
> for both resulting patches.
>=20
Okay, will do.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
