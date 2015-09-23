From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/23] scsi_dh_alua: Recheck state on unit attention
Date: Wed, 23 Sep 2015 15:01:22 +0200
Message-ID: <5602A2A2.7000105@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-21-git-send-email-hare@suse.de>
 <1442951860.4132.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51317 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368AbbIWNBf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Sep 2015 09:01:35 -0400
In-Reply-To: <1442951860.4132.70.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 09:57 PM, Ewan Milne wrote:
> On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
>> When we receive a unit attention code of 'ALUA state changed'
>> we should recheck the state, as it might be due to an implicit
>> ALUA state transition.
>> At the same time a workqueue item might already be queued, which
>> should be started immediately to avoid any delays.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 48 +++++++++++++++----=
-----------
>>  1 file changed, 24 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 85fd597..8717fd3 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -118,7 +118,7 @@ static char print_alua_state(int);
>>  static void alua_rtpg_work(struct work_struct *work);
>>  static void alua_stpg_work(struct work_struct *work);
>>  static void alua_qdata_work(struct work_struct *work);
>> -static void alua_check(struct scsi_device *sdev);
>> +static void alua_check(struct scsi_device *sdev, bool force);
>> =20
>>  static void release_port_group(struct kref *kref)
>>  {
>> @@ -423,7 +423,7 @@ static char print_alua_state(int state)
>>  }
>> =20
>>  static int alua_check_sense(struct scsi_device *sdev,
>> -			    struct scsi_sense_hdr *sense_hdr)
>> +			     struct scsi_sense_hdr *sense_hdr)
>>  {
>>  	switch (sense_hdr->sense_key) {
>>  	case NOT_READY:
>> @@ -432,36 +432,34 @@ static int alua_check_sense(struct scsi_device=
 *sdev,
>>  			 * LUN Not Accessible - ALUA state transition
>>  			 * Kickoff worker to update internal state.
>>  			 */
>> -			alua_check(sdev);
>> -			return ADD_TO_MLQUEUE;
>> +			alua_check(sdev, false);
>> +			return NEEDS_RETRY;
>>  		}
>>  		break;
>>  	case UNIT_ATTENTION:
>> -		if (sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D 0x00)
>> -			/*
>> -			 * Power On, Reset, or Bus Device Reset, just retry.
>> -			 */
>> -			return ADD_TO_MLQUEUE;
>> -		if (sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D 0x04)
>> -			/*
>> -			 * Device internal reset
>> -			 */
>> -			return ADD_TO_MLQUEUE;
>> -		if (sense_hdr->asc =3D=3D 0x2a && sense_hdr->ascq =3D=3D 0x01)
>> +		if (sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D 0x00) {
>>  			/*
>> -			 * Mode Parameter Changed
>> +			 * Power On, Reset, or Bus Device Reset.
>> +			 * Might have obscured a state transition,
>> +			 * so schedule a recheck.
>>  			 */
>> +			alua_check(sdev, true);
>>  			return ADD_TO_MLQUEUE;
>> -		if (sense_hdr->asc =3D=3D 0x2a && sense_hdr->ascq =3D=3D 0x06)
>> +		}
>> +		if (sense_hdr->asc =3D=3D 0x2a && sense_hdr->ascq =3D=3D 0x06) {
>>  			/*
>>  			 * ALUA state changed
>>  			 */
>> +			alua_check(sdev, true);
>>  			return ADD_TO_MLQUEUE;
>> -		if (sense_hdr->asc =3D=3D 0x2a && sense_hdr->ascq =3D=3D 0x07)
>> +		}
>> +		if (sense_hdr->asc =3D=3D 0x2a && sense_hdr->ascq =3D=3D 0x07) {
>>  			/*
>>  			 * Implicit ALUA state transition failed
>>  			 */
>> +			alua_check(sdev, true);
>>  			return ADD_TO_MLQUEUE;
>> +		}
>>  		break;
>>  	}
>> =20
>> @@ -811,7 +809,7 @@ static void alua_qdata_work(struct work_struct *=
work)
>> =20
>>  static void alua_rtpg_queue(struct alua_port_group *pg,
>>  			    struct scsi_device *sdev,
>> -			    struct alua_queue_data *qdata)
>> +			    struct alua_queue_data *qdata, bool force)
>>  {
>>  	int start_queue =3D 0;
>>  	unsigned long flags;
>> @@ -832,7 +830,9 @@ static void alua_rtpg_queue(struct alua_port_gro=
up *pg,
>>  		pg->rtpg_sdev =3D sdev;
>>  		scsi_device_get(sdev);
>>  		start_queue =3D 1;
>> -	}
>> +	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force)
>> +		start_queue =3D 1;
>> +
>>  	spin_unlock_irqrestore(&pg->rtpg_lock, flags);
>> =20
>>  	if (start_queue)
>> @@ -873,7 +873,7 @@ static int alua_initialize(struct scsi_device *s=
dev, struct alua_dh_data *h)
>>  	mutex_unlock(&h->init_mutex);
>>  	if (pg) {
>>  		pg->expiry =3D 0;
>> -		alua_rtpg_queue(pg, sdev, NULL);
>> +		alua_rtpg_queue(pg, sdev, NULL, true);
>>  		kref_put(&pg->kref, release_port_group);
>>  	}
>>  	return error;
>> @@ -982,7 +982,7 @@ static int alua_activate(struct scsi_device *sde=
v,
>>  		pg->flags |=3D ALUA_OPTIMIZE_STPG;
>>  		spin_unlock_irqrestore(&pg->rtpg_lock, flags);
>>  	}
>> -	alua_rtpg_queue(pg, sdev, qdata);
>> +	alua_rtpg_queue(pg, sdev, qdata, true);
>>  	kref_put(&pg->kref, release_port_group);
>>  out:
>>  	if (fn)
>> @@ -996,7 +996,7 @@ out:
>>   *
>>   * Check the device status
>>   */
>> -static void alua_check(struct scsi_device *sdev)
>> +static void alua_check(struct scsi_device *sdev, bool force)
>>  {
>>  	struct alua_dh_data *h =3D sdev->handler_data;
>>  	struct alua_port_group *pg;
>> @@ -1009,7 +1009,7 @@ static void alua_check(struct scsi_device *sde=
v)
>>  	}
>>  	kref_get(&pg->kref);
>>  	rcu_read_unlock();
>> -	alua_rtpg_queue(pg, sdev, NULL);
>> +	alua_rtpg_queue(pg, sdev, NULL, force);
>>  	kref_put(&pg->kref, release_port_group);
>>  	rcu_read_unlock();
>>  }
>=20
> I think this change goes along with the previous patch in terms of th=
e
> design, so we'll have to see how that turns out.  Fundamentally, thou=
gh,
> this changes the handling for LUN Not Accessible - ALUA state transit=
ion
> to be NEEDS_RETRY instead of ADD_TO_MLQUEUE, so what is the effect of=
 that?
>=20
ADD_TO_MLQUEUE will always be retried, NEEDS_RETRY is bounded by the
number of retries.
Originally we had to return ADD_TO_MLQUEUE so to be sure to retry until
the transition is done, causing quite some retries.
As now we're polling the device from a workqueue we can terminate
the number of retries by returning NEEDS_RETRY, knowing that the pollin=
g
(and/or sense code evaluation) will tell us when the transition is fini=
shed.

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
