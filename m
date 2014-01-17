From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/16] scsi_dh_alua: use local buffer for VPD inquiry
Date: Fri, 17 Jan 2014 10:38:03 +0100
Message-ID: <52D8F9FB.50603@suse.de>
References: <1387541621-54967-1-git-send-email-hare@suse.de> <1387541621-54967-7-git-send-email-hare@suse.de> <52D8F201.80409@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60254 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbaAQJiF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 04:38:05 -0500
In-Reply-To: <52D8F201.80409@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>

On 01/17/2014 10:04 AM, Mike Christie wrote:
> On 12/20/2013 06:13 AM, Hannes Reinecke wrote:
>> VPD inquiry need to be done only once, so we can be using
>> a local buffer here.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 45 ++++++++++++++++++-=
-----------
>>  1 file changed, 27 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index adc77ef..49952f4 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -322,16 +322,27 @@ static int alua_check_tpgs(struct scsi_device =
*sdev, struct alua_dh_data *h)
>>   */
>>  static int alua_vpd_inquiry(struct scsi_device *sdev, struct alua_d=
h_data *h)
>>  {
>> +	unsigned char *buff;
>> +	unsigned char bufflen =3D 36;
>>  	int len, timeout =3D ALUA_FAILOVER_TIMEOUT;
>>  	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
>>  	struct scsi_sense_hdr sense_hdr;
>>  	unsigned retval;
>>  	unsigned char *d;
>>  	unsigned long expiry;
>> +	int err;
>> =20
>>  	expiry =3D round_jiffies_up(jiffies + timeout);
>>   retry:
>> -	retval =3D submit_vpd_inquiry(sdev, h->buff, h->bufflen, sense);
>> +	buff =3D kmalloc(bufflen, GFP_ATOMIC);
>> +	if (!buff) {
>>
>=20
> Why GFP_ATOMIC? I think it can be less restrictive in this path. If y=
ou
> need GFP_ATOMIC here, then there are places in this code path you wou=
ld
> want to change from GFP_KERNEL to GFP_ATOMIC.
>=20
Yeah, all right. This is by no means time-critical.

I'll be fixing up the patch.

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
