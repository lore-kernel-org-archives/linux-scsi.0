From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/5] scsi: rescan VPD attributes
Date: Fri, 24 Jul 2015 16:40:42 +0200
Message-ID: <55B24E6A.6030904@suse.de>
References: <1436353788-104911-1-git-send-email-hare@suse.de> <1436353788-104911-2-git-send-email-hare@suse.de> <20150724143834.GA28970@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770AbbGXOko (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jul 2015 10:40:44 -0400
In-Reply-To: <20150724143834.GA28970@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 07/24/2015 04:38 PM, Christoph Hellwig wrote:
> On Wed, Jul 08, 2015 at 01:09:44PM +0200, Hannes Reinecke wrote:
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -264,8 +264,11 @@ static int alua_check_vpd(struct scsi_device *s=
dev, struct alua_dh_data *h)
>>  	int device_id_size, device_id_type =3D 0;
>>  	struct alua_port_group *tmp_pg, *pg =3D NULL;
>> =20
>> -	if (!sdev->vpd_pg83)
>> +	rcu_read_lock();
>> +	if (!rcu_dereference(sdev->vpd_pg83)) {
>> +		rcu_read_unlock();
>>  		return SCSI_DH_DEV_UNSUPP;
>> +	}
>> =20
>>  	/*
>>  	 * Look for the correct descriptor.
>> @@ -281,8 +284,8 @@ static int alua_check_vpd(struct scsi_device *sd=
ev, struct alua_dh_data *h)
>>  	 */
>>  	memset(device_id_str, 0, 256);
>>  	device_id_size =3D 0;
>> -	d =3D sdev->vpd_pg83 + 4;
>> -	while (d < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
>> +	d =3D rcu_dereference(sdev->vpd_pg83) + 4;
>> +	while (d < rcu_dereference(sdev->vpd_pg83) + sdev->vpd_pg83_len) {
>=20
> Seem like this code would benefit from a local variable in favor of t=
he
> repeated rcu_dereference() calls.
>=20
Yeah, possibly. After all, the variable isn't expected to change
under rcu_read_lock().

>> @@ -803,7 +803,7 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>=20
> I think this function could use a new name, e.g. scsi_read_vpd_pages?
>=20
>> @@ -563,8 +563,9 @@ static void ses_match_to_enclosure(struct enclos=
ure_device *edev,
>>  	if (!sdev->vpd_pg83_len)
>>  		return;
>> =20
>> -	desc =3D sdev->vpd_pg83 + 4;
>> -	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
>> +	rcu_read_lock();
>> +	desc =3D rcu_dereference(sdev->vpd_pg83) + 4;
>> +	while (desc < rcu_dereference(sdev->vpd_pg83) + sdev->vpd_pg83_len=
) {
>=20
> A local variable or two would help here as well.
>=20
Okay.

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
