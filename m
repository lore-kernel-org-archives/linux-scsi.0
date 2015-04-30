From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sd: always retry READ CAPACITY for ALUA state transition
Date: Thu, 30 Apr 2015 14:26:24 +0200
Message-ID: <55421F70.80102@suse.de>
References: <1430127309-90412-1-git-send-email-hare@suse.de> <1430255925.2181.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbbD3M01 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 08:26:27 -0400
In-Reply-To: <1430255925.2181.16.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 04/28/2015 11:18 PM, James Bottomley wrote:
> On Mon, 2015-04-27 at 11:35 +0200, Hannes Reinecke wrote:
>> During ALUA state transitions the device might return
>> a sense code 02/04/0a (Logical unit not accessible, asymmetric
>> access state transition). As this is a transient error
>> we should just retry the READ CAPACITY call until
>> the state transition finishes and the correct
>> capacity can be returned.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/sd.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 79beebf..7178b05 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1987,6 +1987,11 @@ static int read_capacity_16(struct scsi_disk =
*sdkp, struct scsi_device *sdp,
>>  				 * give it one more chance */
>>  				if (--reset_retries > 0)
>>  					continue;
>> +			if (sense_valid &&
>> +			    sshdr.sense_key =3D=3D NOT_READY &&
>> +			    sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x0A)
>> +				/* ALUA state transition; always retry */
>> +				continue;
>>  		}
>>  		retries--;
>> =20
>> @@ -2069,6 +2074,11 @@ static int read_capacity_10(struct scsi_disk =
*sdkp, struct scsi_device *sdp,
>>  				 * give it one more chance */
>>  				if (--reset_retries > 0)
>>  					continue;
>> +			if (sense_valid &&
>> +			    sshdr.sense_key =3D=3D NOT_READY &&
>> +			    sshdr.asc =3D=3D 0x04 && sshdr.ascq =3D=3D 0x0A)
>> +				/* ALUA state transition; always retry */
>> +				continue;
>>  		}
>>  		retries--;
>> =20
>=20
> Got to say I really don't like this infinite retry possibility.  How
> long does the ALUA transition take?  Would increasing retries work (o=
r
> even hijacking reset_retries)?
>=20
Well ... transitioning could be quite long (NetApp FAS has a
transition timeout of 30 _minutes_ ...).
But yeah, I could see to limit this somewhat.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
