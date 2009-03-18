From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] Add 'tpgs' sysfs attribute for SCSI devices
Date: Wed, 18 Mar 2009 15:02:30 +0100
Message-ID: <49C0FEF6.6050507@suse.de>
References: <20090318120206.0BB1418C79D@pentland.suse.de> <1237384735.3350.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZCROCf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 10:02:35 -0400
In-Reply-To: <1237384735.3350.0.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sekharan@us.ibm.com, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-03-18 at 13:02 +0100, Hannes Reinecke wrote:
>> We need to export the 'TGPS' setting of the
>> inquiry data to properly support ALUA.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/scsi_scan.c   |    1 +
>>  drivers/scsi/scsi_sysfs.c  |    2 ++
>>  include/scsi/scsi_device.h |    3 ++-
>>  3 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index a14d245..d1619ed 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -836,6 +836,7 @@ static int scsi_add_lun(struct scsi_device *sdev=
, unsigned char *inq_result,
>>  	sdev->inq_periph_qual =3D (inq_result[0] >> 5) & 7;
>>  	sdev->lockable =3D sdev->removable;
>>  	sdev->soft_reset =3D (inq_result[7] & 1) && ((inq_result[3] & 7) =3D=
=3D 2);
>> +	sdev->tpgs =3D (inq_result[5] >> 4) & 3;
>=20
> As far as I can tell, this is a read only parameter, isn't it?
>=20
> In that case, why not just do what we do for the SPI inquiry data and
> have a wrapper pulling it out of sdev->inquiry instead of a new flag =
in
> sdev?
>=20
Because we're evaluating it later on from the device_handler.
But honestly I didn't inquire in that direction.
I'll be checking.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
