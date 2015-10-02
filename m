From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/36] scsi_dh_alua: separate out alua_stpg()
Date: Fri, 02 Oct 2015 08:06:30 +0200
Message-ID: <560E1EE6.7090609@suse.de>
References: <1443523658-87622-1-git-send-email-hare@suse.de> <1443523658-87622-15-git-send-email-hare@suse.de> <560DCAA6.1020404@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbbJBGGc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Oct 2015 02:06:32 -0400
In-Reply-To: <560DCAA6.1020404@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 10/02/2015 02:07 AM, Bart Van Assche wrote:
> On 09/29/2015 03:47 AM, Hannes Reinecke wrote:
>> Seperate out SET TARGET PORT GROUP functionality into a separate
>   ^ Separate ?
>> function alua_stpg().
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/device_handler/scsi_dh_alua.c | 86
>> ++++++++++++++++++------------
>>   1 file changed, 52 insertions(+), 34 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
>> b/drivers/scsi/device_handler/scsi_dh_alua.c
>> index 63423b2..59fe3e9 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -614,6 +614,56 @@ static int alua_rtpg(struct scsi_device
>> *sdev, struct alua_dh_data *h, int wait_
>>   }
>>
>>   /*
>> + * alua_stpg - Issue a SET TARGET GROUP STATES command
>> + *
>> + * Issue a SET TARGET GROUP STATES command and evaluate the
>> + * response. Returns SCSI_DH_RETRY per default to trigger
>> + * a re-evaluation of the target group state.
>> + */
>=20
> In SPC-4 I found the following description next to the STPG command:
> "SET TARGET PORT GROUPS". How about using the official SPC-4
> description ?
>=20
>> +static unsigned alua_stpg(struct scsi_device *sdev, struct
>> alua_dh_data *h,
>> +              activate_complete fn, void *data)
>> +{
>> +    int err =3D SCSI_DH_OK;
>> +    int stpg =3D 0;
>> +
>> +    if (!(h->tpgs & TPGS_MODE_EXPLICIT)) {
>> +        /* Only implicit ALUA supported */
>> +        return err;
>> +    }
>> +
>> +    switch (h->state) {
>> +    case TPGS_STATE_NONOPTIMIZED:
>> +        stpg =3D 1;
>> +        if ((h->flags & ALUA_OPTIMIZE_STPG) &&
>> +            !h->pref &&
>> +            (h->tpgs & TPGS_MODE_IMPLICIT))
>> +            stpg =3D 0;
>> +        break;
>> +    case TPGS_STATE_STANDBY:
>> +    case TPGS_STATE_UNAVAILABLE:
>> +        stpg =3D 1;
>> +        break;
>> +    case TPGS_STATE_OFFLINE:
>> +        err =3D SCSI_DH_IO;
>> +        break;
>> +    case TPGS_STATE_TRANSITIONING:
>> +        err =3D SCSI_DH_RETRY;
>> +        break;
>> +    default:
>> +        break;
>> +    }
>> +
>> +    if (stpg) {
>> +        h->callback_fn =3D fn;
>> +        h->callback_data =3D data;
>> +        err =3D submit_stpg(h);
>> +        if (err !=3D SCSI_DH_OK)
>> +            h->callback_fn =3D h->callback_data =3D NULL;
>> +    }
>> +    return err;
>> +}
>> +
>> +/*
>>    * alua_initialize - Initialize ALUA state
>>    * @sdev: the device to be initialized
>>    *
>> @@ -690,7 +740,6 @@ static int alua_activate(struct scsi_device
>> *sdev,
>>   {
>>       struct alua_dh_data *h =3D sdev->handler_data;
>>       int err =3D SCSI_DH_OK;
>> -    int stpg =3D 0;
>>
>>       err =3D alua_rtpg(sdev, h, 1);
>>       if (err !=3D SCSI_DH_OK)
>> @@ -699,41 +748,10 @@ static int alua_activate(struct scsi_device
>> *sdev,
>>       if (optimize_stpg)
>>           h->flags |=3D ALUA_OPTIMIZE_STPG;
>>
>> -    if (h->tpgs & TPGS_MODE_EXPLICIT) {
>> -        switch (h->state) {
>> -        case TPGS_STATE_NONOPTIMIZED:
>> -            stpg =3D 1;
>> -            if ((h->flags & ALUA_OPTIMIZE_STPG) &&
>> -                (!h->pref) &&
>> -                (h->tpgs & TPGS_MODE_IMPLICIT))
>> -                stpg =3D 0;
>> -            break;
>> -        case TPGS_STATE_STANDBY:
>> -        case TPGS_STATE_UNAVAILABLE:
>> -            stpg =3D 1;
>> -            break;
>> -        case TPGS_STATE_OFFLINE:
>> -            err =3D SCSI_DH_IO;
>> -            break;
>> -        case TPGS_STATE_TRANSITIONING:
>> -            err =3D SCSI_DH_RETRY;
>> -            break;
>> -        default:
>> -            break;
>> -        }
>> -    }
>> -
>> -    if (stpg) {
>> -        h->callback_fn =3D fn;
>> -        h->callback_data =3D data;
>> -        err =3D submit_stpg(h);
>> -        if (err =3D=3D SCSI_DH_OK)
>> -            return 0;
>> -        h->callback_fn =3D h->callback_data =3D NULL;
>> -    }
>> +    err =3D alua_stpg(sdev, h, fn, data);
>>
>>   out:
>> -    if (fn)
>> +    if (err !=3D SCSI_DH_OK && fn)
>>           fn(data, err);
>>       return 0;
>>   }
>>
>=20
> The old implementation calls the callback function 'fn' if the flag
> TPGS_MODE_EXPLICIT has not been set but the new implementation not.
> Please mention this in the patch description if this behavior change
> is intentional.
>=20
Actually, this looks more like an error with the old implementation.
'fn' is the callback signalling that the failover command has been
completed, and the caller (in most case dm-multipath) relies on 'fn'
to be executed for further processing.
So 'fn' should be executed, irrespective of the TPGS_MODE_EXPLICIT flag=
=2E

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
