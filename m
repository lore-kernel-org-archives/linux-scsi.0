From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 21/23] scsi_dh_alua: update all port states
Date: Tue, 22 Sep 2015 22:20:08 +0200
Message-ID: <5601B7F8.2060105@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-22-git-send-email-hare@suse.de>
 <1442952246.4132.75.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759465AbbIVUUN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 16:20:13 -0400
In-Reply-To: <1442952246.4132.75.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 10:04 PM, Ewan Milne wrote:
> On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
>> When we read in the target port group state we should be
>> updating all affected port groups, otherwise we risk
>> running out of sync.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 21 +++++++++++++++++--=
--
>>  1 file changed, 17 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 8717fd3..2fa985e 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -477,11 +477,13 @@ static int alua_check_sense(struct scsi_device=
 *sdev,
>>  static int alua_rtpg(struct scsi_device *sdev, struct alua_port_gro=
up *pg)
>>  {
>>  	struct scsi_sense_hdr sense_hdr;
>> +	struct alua_port_group *tmp_pg;
>>  	int len, k, off, valid_states =3D 0, bufflen =3D ALUA_RTPG_SIZE;
>>  	unsigned char *ucp, *buff;
>>  	unsigned err, retval;
>>  	unsigned int tpg_desc_tbl_off;
>>  	unsigned char orig_transition_tmo;
>> +	unsigned long flags;
>> =20
>>  	if (!pg->expiry) {
>>  		if (!pg->transition_tmo)
>> @@ -584,17 +586,28 @@ static int alua_rtpg(struct scsi_device *sdev,=
 struct alua_port_group *pg)
>>  	else
>>  		tpg_desc_tbl_off =3D 4;
>> =20
>> +	spin_lock_irqsave(&port_group_lock, flags);
>>  	for (k =3D tpg_desc_tbl_off, ucp =3D buff + tpg_desc_tbl_off;
>>  	     k < len;
>>  	     k +=3D off, ucp +=3D off) {
>=20
> "ucp" is not really a good variable name, it matches nothing in the T=
10
> spec.  The structure is a "Target Port Group Descriptor".  I realize =
it
> was already there, but maybe this is a good opportunity to change it?
>=20
Doug Gilbert is to blame; I've copied this section over from sg3_utils =
:-)
But yeah, I can set it to eg 'desc'.

>> =20
>> -		if (pg->group_id =3D=3D get_unaligned_be16(&ucp[2])) {
>> -			pg->state =3D ucp[0] & 0x0f;
>> -			pg->pref =3D ucp[0] >> 7;
>> -			valid_states =3D ucp[1];
>> +		list_for_each_entry(tmp_pg, &port_group_list, node) {
>> +			u16 group_id =3D get_unaligned_be16(&ucp[2]);
>=20
> This is invariant and should be outside the loop.
>=20
True.

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
