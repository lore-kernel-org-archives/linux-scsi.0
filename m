From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/23] scsi_dh_alua: allocate RTPG buffer separately
Date: Thu, 24 Sep 2015 19:19:54 +0200
Message-ID: <560430BA.50402@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-15-git-send-email-hare@suse.de>
 <1442948676.4132.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757202AbbIXRUA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2015 13:20:00 -0400
In-Reply-To: <1442948676.4132.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 09:04 PM, Ewan Milne wrote:
> On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
>> The RTPG buffer will only evaluated within alua_rtpg(),
>> so we can allocate it locally there and avoid having to
>> put it into the global structure.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 56 +++++++++++--------=
-----------
>>  1 file changed, 21 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index d1010dd..4157fe2 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -56,7 +56,7 @@
>>  #define TPGS_MODE_IMPLICIT		0x1
>>  #define TPGS_MODE_EXPLICIT		0x2
>> =20
>> -#define ALUA_INQUIRY_SIZE		36
>> +#define ALUA_RTPG_SIZE			128
>>  #define ALUA_FAILOVER_TIMEOUT		60
>>  #define ALUA_FAILOVER_RETRIES		5
>> =20
>> @@ -75,9 +75,6 @@ struct alua_port_group {
>>  	int			state;
>>  	int			pref;
>>  	unsigned		flags; /* used for optimizing STPG */
>> -	unsigned char		inq[ALUA_INQUIRY_SIZE];
>> -	unsigned char		*buff;
>> -	int			bufflen;
>>  	unsigned char		transition_tmo;
>>  };
>> =20
>> @@ -96,21 +93,6 @@ struct alua_dh_data {
>>  static char print_alua_state(int);
>>  static int alua_check_sense(struct scsi_device *, struct scsi_sense=
_hdr *);
>> =20
>> -static int realloc_buffer(struct alua_port_group *pg, unsigned len)
>> -{
>> -	if (pg->buff && pg->buff !=3D pg->inq)
>> -		kfree(pg->buff);
>> -
>> -	pg->buff =3D kmalloc(len, GFP_NOIO);
>> -	if (!pg->buff) {
>> -		pg->buff =3D pg->inq;
>> -		pg->bufflen =3D ALUA_INQUIRY_SIZE;
>> -		return 1;
>> -	}
>> -	pg->bufflen =3D len;
>> -	return 0;
>> -}
>> -
>>  static void release_port_group(struct kref *kref)
>>  {
>>  	struct alua_port_group *pg;
>> @@ -120,8 +102,6 @@ static void release_port_group(struct kref *kref=
)
>>  	spin_lock(&port_group_lock);
>>  	list_del(&pg->node);
>>  	spin_unlock(&port_group_lock);
>> -	if (pg->buff && pg->inq !=3D pg->buff)
>> -		kfree(pg->buff);
>>  	kfree(pg);
>>  }
>> =20
>> @@ -300,8 +280,6 @@ static int alua_check_vpd(struct scsi_device *sd=
ev, struct alua_dh_data *h)
>>  		return SCSI_DH_DEV_TEMP_BUSY;
>>  	}
>>  	pg->group_id =3D group_id;
>> -	pg->buff =3D pg->inq;
>> -	pg->bufflen =3D ALUA_INQUIRY_SIZE;
>>  	pg->tpgs =3D h->tpgs;
>>  	pg->state =3D TPGS_STATE_OPTIMIZED;
>>  	kref_init(&pg->kref);
>> @@ -424,8 +402,8 @@ static int alua_check_sense(struct scsi_device *=
sdev,
>>  static int alua_rtpg(struct scsi_device *sdev, struct alua_port_gro=
up *pg, int wait_for_transition)
>>  {
>>  	struct scsi_sense_hdr sense_hdr;
>> -	int len, k, off, valid_states =3D 0;
>> -	unsigned char *ucp;
>> +	int len, k, off, valid_states =3D 0, bufflen =3D ALUA_RTPG_SIZE;
>> +	unsigned char *ucp, *buff;
>>  	unsigned err, retval;
>>  	unsigned long expiry, interval =3D 0;
>>  	unsigned int tpg_desc_tbl_off;
>> @@ -436,9 +414,12 @@ static int alua_rtpg(struct scsi_device *sdev, =
struct alua_port_group *pg, int w
>>  	else
>>  		expiry =3D round_jiffies_up(jiffies + pg->transition_tmo * HZ);
>> =20
>> +	buff =3D kzalloc(bufflen, GFP_KERNEL);
>> +	if (!buff)
>> +		return SCSI_DH_DEV_TEMP_BUSY;
>> +
>>   retry:
>> -	retval =3D submit_rtpg(sdev, pg->buff, pg->bufflen,
>> -			     &sense_hdr, pg->flags);
>> +	retval =3D submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags)=
;
>> =20
>>  	if (retval) {
>>  		if (!scsi_sense_valid(&sense_hdr)) {
>> @@ -449,6 +430,7 @@ static int alua_rtpg(struct scsi_device *sdev, s=
truct alua_port_group *pg, int w
>>  				err =3D SCSI_DH_DEV_TEMP_BUSY;
>>  			else
>>  				err =3D SCSI_DH_IO;
>> +			kfree(buff);
>>  			return err;
>>  		}
>> =20
>> @@ -477,14 +459,18 @@ static int alua_rtpg(struct scsi_device *sdev,=
 struct alua_port_group *pg, int w
>>  		sdev_printk(KERN_ERR, sdev, "%s: rtpg failed\n",
>>  			    ALUA_DH_NAME);
>>  		scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>> +		kfree(buff);
>>  		return SCSI_DH_IO;
>>  	}
>> =20
>> -	len =3D get_unaligned_be32(&pg->buff[0]) + 4;
>> +	len =3D get_unaligned_be32(&buff[0]) + 4;
>> =20
>> -	if (len > pg->bufflen) {
>> +	if (len > bufflen) {
>>  		/* Resubmit with the correct length */
>> -		if (realloc_buffer(pg, len)) {
>> +		kfree(buff);
>> +		bufflen =3D len;
>> +		buff =3D kmalloc(bufflen, GFP_KERNEL);
>> +		if (!buff) {
>>  			sdev_printk(KERN_WARNING, sdev,
>>  				    "%s: kmalloc buffer failed\n",__func__);
>>  			/* Temporary failure, bypass */
>> @@ -494,9 +480,8 @@ static int alua_rtpg(struct scsi_device *sdev, s=
truct alua_port_group *pg, int w
>>  	}
>> =20
>>  	orig_transition_tmo =3D pg->transition_tmo;
>> -	if ((pg->buff[4] & RTPG_FMT_MASK) =3D=3D RTPG_FMT_EXT_HDR &&
>> -	    pg->buff[5] !=3D 0)
>> -		pg->transition_tmo =3D pg->buff[5];
>> +	if ((buff[4] & RTPG_FMT_MASK) =3D=3D RTPG_FMT_EXT_HDR && buff[5] !=
=3D 0)
>> +		pg->transition_tmo =3D buff[5];
>>  	else
>>  		pg->transition_tmo =3D ALUA_FAILOVER_TIMEOUT;
>> =20
>> @@ -508,12 +493,12 @@ static int alua_rtpg(struct scsi_device *sdev,=
 struct alua_port_group *pg, int w
>>  		expiry =3D jiffies + pg->transition_tmo * HZ;
>>  	}
>> =20
>> -	if ((pg->buff[4] & RTPG_FMT_MASK) =3D=3D RTPG_FMT_EXT_HDR)
>> +	if ((buff[4] & RTPG_FMT_MASK) =3D=3D RTPG_FMT_EXT_HDR)
>>  		tpg_desc_tbl_off =3D 8;
>>  	else
>>  		tpg_desc_tbl_off =3D 4;
>> =20
>> -	for (k =3D tpg_desc_tbl_off, ucp =3D pg->buff + tpg_desc_tbl_off;
>> +	for (k =3D tpg_desc_tbl_off, ucp =3D buff + tpg_desc_tbl_off;
>>  	     k < len;
>>  	     k +=3D off, ucp +=3D off) {
>> =20
>> @@ -563,6 +548,7 @@ static int alua_rtpg(struct scsi_device *sdev, s=
truct alua_port_group *pg, int w
>>  		err =3D SCSI_DH_OK;
>>  		break;
>>  	}
>> +	kfree(buff);
>>  	return err;
>>  }
>> =20
>=20
> I guess.  Are these buffers so big that we don't want to make it part=
 of
> a structure that just stays allocated?
>=20
The point is that the buffer scales with the size of the installation,
so we cannot allocate it statically.

> We should have some validation on the length of the data returned by =
RTPG in
> the case where the buffer is re-kmalloc'ed, we can't kmalloc 4GB - 1 =
+ 4 bytes.
> And if the length is too big, it is not a "temporary" failure.
Well, it's hard to distinguish between ENOMEM because of a (temporary)
memory shortage and ENOMEM because kmalloc cannot allocate that much
memory in general. Mind you, FC-AL can only have up to 128M bytes worth
of data here (64k possible loop IDs with 8 bytes port IDs each).

However, during every testing I've done (and this particular code is
running in SLES for some years now) I've never ever seen an issue with
kmalloc failing to allocate memory.

> We should maybe only retry once with a larger buffer, rather than pot=
entially
> loop forever if the device keeps returning different information.
>=20
> (I suppose we have the same potential issue with REPORT LUNS as well.=
)
>=20
Well, the size shouldn't really change (unless someone does an array
reconfiguration). So at most we'll be retrying once (plus any sense cod=
e
retries, of course).

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
