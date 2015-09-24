From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/23] scsi_dh_alua: Make stpg synchronous
Date: Thu, 24 Sep 2015 18:47:05 +0200
Message-ID: <56042909.8060705@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-12-git-send-email-hare@suse.de>
 <1442947845.4132.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35190 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbbIXQrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2015 12:47:11 -0400
In-Reply-To: <1442947845.4132.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 08:50 PM, Ewan Milne wrote:
> On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
>> We should be issuing STPG synchronously as we need to
>> evaluate the return code on failure.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 179 +++++++++++++-----=
-----------
>>  1 file changed, 83 insertions(+), 96 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 9e2b3af..fd0385e 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -172,76 +172,28 @@ done:
>>  }
>> =20
>>  /*
>> - * stpg_endio - Evaluate SET TARGET GROUP STATES
>> - * @sdev: the device to be evaluated
>> - * @state: the new target group state
>> - *
>> - * Evaluate a SET TARGET GROUP STATES command response.
>> - */
>> -static void stpg_endio(struct request *req, int error)
>> -{
>> -	struct alua_dh_data *h =3D req->end_io_data;
>> -	struct scsi_sense_hdr sense_hdr;
>> -	unsigned err =3D SCSI_DH_OK;
>> -
>> -	if (host_byte(req->errors) !=3D DID_OK ||
>> -	    msg_byte(req->errors) !=3D COMMAND_COMPLETE) {
>> -		err =3D SCSI_DH_IO;
>> -		goto done;
>> -	}
>> -
>> -	if (scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
>> -				 &sense_hdr)) {
>> -		err =3D alua_check_sense(h->sdev, &sense_hdr);
>> -		if (err =3D=3D ADD_TO_MLQUEUE) {
>> -			err =3D SCSI_DH_RETRY;
>> -			goto done;
>> -		}
>> -		sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
>> -			    ALUA_DH_NAME);
>> -		scsi_print_sense_hdr(h->sdev, ALUA_DH_NAME, &sense_hdr);
>> -		err =3D SCSI_DH_IO;
>> -	} else if (error)
>> -		err =3D SCSI_DH_IO;
>> -
>> -	if (err =3D=3D SCSI_DH_OK) {
>> -		h->state =3D TPGS_STATE_OPTIMIZED;
>> -		sdev_printk(KERN_INFO, h->sdev,
>> -			    "%s: port group %02x switched to state %c\n",
>> -			    ALUA_DH_NAME, h->group_id,
>> -			    print_alua_state(h->state));
>> -	}
>> -done:
>> -	req->end_io_data =3D NULL;
>> -	__blk_put_request(req->q, req);
>> -	if (h->callback_fn) {
>> -		h->callback_fn(h->callback_data, err);
>> -		h->callback_fn =3D h->callback_data =3D NULL;
>> -	}
>> -	return;
>> -}
>> -
>> -/*
>>   * submit_stpg - Issue a SET TARGET GROUP STATES command
>>   *
>>   * Currently we're only setting the current target port group state
>>   * to 'active/optimized' and let the array firmware figure out
>>   * the states of the remaining groups.
>>   */
>> -static unsigned submit_stpg(struct alua_dh_data *h)
>> +static unsigned submit_stpg(struct scsi_device *sdev, int group_id,
>> +			    unsigned char *sense)
>>  {
>>  	struct request *rq;
>> +	unsigned char stpg_data[8];
>>  	int stpg_len =3D 8;
>> -	struct scsi_device *sdev =3D h->sdev;
>> +	int err =3D 0;
>> =20
>>  	/* Prepare the data buffer */
>> -	memset(h->buff, 0, stpg_len);
>> -	h->buff[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
>> -	put_unaligned_be16(h->group_id, &h->buff[6]);
>> +	memset(stpg_data, 0, stpg_len);
>> +	stpg_data[4] =3D TPGS_STATE_OPTIMIZED & 0x0f;
>> +	put_unaligned_be16(group_id, &stpg_data[6]);
>> =20
>> -	rq =3D get_alua_req(sdev, h->buff, stpg_len, WRITE);
>> +	rq =3D get_alua_req(sdev, stpg_data, stpg_len, WRITE);
>>  	if (!rq)
>> -		return SCSI_DH_RES_TEMP_UNAVAIL;
>> +		return DRIVER_BUSY << 24;
>> =20
>>  	/* Prepare the command. */
>>  	rq->cmd[0] =3D MAINTENANCE_OUT;
>> @@ -249,13 +201,17 @@ static unsigned submit_stpg(struct alua_dh_dat=
a *h)
>>  	put_unaligned_be32(stpg_len, &rq->cmd[6]);
>>  	rq->cmd_len =3D COMMAND_SIZE(MAINTENANCE_OUT);
>> =20
>> -	rq->sense =3D h->sense;
>> +	rq->sense =3D sense;
>>  	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
>> -	rq->sense_len =3D h->senselen =3D 0;
>> -	rq->end_io_data =3D h;
>> +	rq->sense_len =3D 0;
>> +
>> +	blk_execute_rq(rq->q, NULL, rq, 1);
>> +	if (rq->errors)
>> +		err =3D rq->errors;
>> +
>> +	blk_put_request(rq);
>> =20
>> -	blk_execute_rq_nowait(rq->q, NULL, rq, 1, stpg_endio);
>> -	return SCSI_DH_OK;
>> +	return err;
>>  }
>> =20
>>  /*
>> @@ -619,6 +575,68 @@ static int alua_rtpg(struct scsi_device *sdev, =
struct alua_dh_data *h, int wait_
>>  }
>> =20
>>  /*
>> + * alua_stpg - Issue a SET TARGET GROUP STATES command
>> + *
>> + * Issue a SET TARGET GROUP STATES command and evaluate the
>> + * response. Returns SCSI_DH_RETRY per default to trigger
>> + * a re-evaluation of the target group state.
>> + */
>> +static unsigned alua_stpg(struct scsi_device *sdev, struct alua_dh_=
data *h)
>> +{
>> +	int retval;
>> +	struct scsi_sense_hdr sense_hdr;
>> +
>> +	if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
>> +		/* Only implicit ALUA supported, retry */
>> +		return SCSI_DH_RETRY;
>> +	}
>> +	switch (h->state) {
>> +	case TPGS_STATE_OPTIMIZED:
>> +		return SCSI_DH_OK;
>> +	case TPGS_STATE_NONOPTIMIZED:
>> +		if ((h->flags & ALUA_OPTIMIZE_STPG) &&
>> +		    !h->pref &&
>> +		    (h->tpgs & TPGS_MODE_IMPLICIT))
>> +			return SCSI_DH_OK;
>> +		break;
>> +	case TPGS_STATE_STANDBY:
>> +	case TPGS_STATE_UNAVAILABLE:
>> +		break;
>> +	case TPGS_STATE_OFFLINE:
>> +		return SCSI_DH_IO;
>> +		break;
>> +	case TPGS_STATE_TRANSITIONING:
>> +		break;
>> +	default:
>> +		sdev_printk(KERN_INFO, sdev,
>> +			    "%s: stpg failed, unhandled TPGS state %d",
>> +			    ALUA_DH_NAME, h->state);
>> +		return SCSI_DH_NOSYS;
>> +		break;
>> +	}
>> +	/* Set state to transitioning */
>> +	h->state =3D TPGS_STATE_TRANSITIONING;
>> +	retval =3D submit_stpg(sdev, h->group_id, h->sense);
>> +
>> +	if (retval) {
>> +		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
>> +					  &sense_hdr)) {
>> +			sdev_printk(KERN_INFO, sdev,
>> +				    "%s: stpg failed, result %d",
>> +				    ALUA_DH_NAME, retval);
>> +			if (driver_byte(retval) =3D=3D DRIVER_BUSY)
>> +				return SCSI_DH_DEV_TEMP_BUSY;
>> +		} else {
>> +			sdev_printk(KERN_INFO, h->sdev, "%s: stpg failed\n",
>> +				    ALUA_DH_NAME);
>> +			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>> +		}
>> +	}
>> +	/* Retry RTPG */
>> +	return SCSI_DH_RETRY;
>> +}
>> +
>> +/*
>>   * alua_initialize - Initialize ALUA state
>>   * @sdev: the device to be initialized
>>   *
>> @@ -695,7 +713,6 @@ static int alua_activate(struct scsi_device *sde=
v,
>>  {
>>  	struct alua_dh_data *h =3D sdev->handler_data;
>>  	int err =3D SCSI_DH_OK;
>> -	int stpg =3D 0;
>> =20
>>  	err =3D alua_rtpg(sdev, h, 1);
>>  	if (err !=3D SCSI_DH_OK)
>> @@ -704,39 +721,9 @@ static int alua_activate(struct scsi_device *sd=
ev,
>>  	if (optimize_stpg)
>>  		h->flags |=3D ALUA_OPTIMIZE_STPG;
>> =20
>> -	if (h->tpgs & TPGS_MODE_EXPLICIT) {
>> -		switch (h->state) {
>> -		case TPGS_STATE_NONOPTIMIZED:
>> -			stpg =3D 1;
>> -			if ((h->flags & ALUA_OPTIMIZE_STPG) &&
>> -			    (!h->pref) &&
>> -			    (h->tpgs & TPGS_MODE_IMPLICIT))
>> -				stpg =3D 0;
>> -			break;
>> -		case TPGS_STATE_STANDBY:
>> -		case TPGS_STATE_UNAVAILABLE:
>> -			stpg =3D 1;
>> -			break;
>> -		case TPGS_STATE_OFFLINE:
>> -			err =3D SCSI_DH_IO;
>> -			break;
>> -		case TPGS_STATE_TRANSITIONING:
>> -			err =3D SCSI_DH_RETRY;
>> -			break;
>> -		default:
>> -			break;
>> -		}
>> -	}
>> -
>> -	if (stpg) {
>> -		h->callback_fn =3D fn;
>> -		h->callback_data =3D data;
>> -		err =3D submit_stpg(h);
>> -		if (err =3D=3D SCSI_DH_OK)
>> -			return 0;
>> -		h->callback_fn =3D h->callback_data =3D NULL;
>> -	}
>> -
>> +	err =3D alua_stpg(sdev, h);
>> +	if (err =3D=3D SCSI_DH_RETRY)
>> +		err =3D alua_rtpg(sdev, h, 1);
>>  out:
>>  	if (fn)
>>  		fn(data, err);
>=20
> submit_stpg() now returns DRIVER_BUSY << 24 instead of SCSI_DH_RES_TE=
MP_UNAVAIL,
> so you are changing the return code semantics here as in patch 5/23. =
 That's
> fine, but probably should be mentioned in the patch description.
>=20
> The removed stpg_endio() code *did* evaluate the SCSI error code, and=
 the code
> that has replaced it doesn't exactly do the same thing, so what diffe=
rence in
> behavior are we going to get here?
>=20
Correct. Is fixed up with the next version of the patchset.

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
