From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/7] scsi_dh: Update RDAC device handler
Date: Thu, 15 May 2008 11:02:25 +0200
Message-ID: <482BFC21.8070600@suse.de>
References: <20080514144334.09AA610B5DF@craiglockhart-ipmi.suse.de>
	<1210819830.21974.268.camel@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1210819830.21974.268.camel@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Chandra,

Chandra Seetharaman wrote:
> On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
>> This patch updates the RDAC device handler to
>> refuse to attach to devices not supporting the
>> RDAC vpd pages.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_rdac.c |   84 +++++++++++++++++--=
--------
>>  1 files changed, 53 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi=
/device_handler/scsi_dh_rdac.c
>> index e61cde6..dd9f515 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
[ .. ]
>>  		/*
>>  		 * If in AVT mode or if the path already owns the LUN,
>>  		 * return RDAC_OWNED;
>>  		 */
>=20
> With the code change below the comment above is incorrect, please
> remove.
OK.

>> @@ -478,24 +491,9 @@ static int rdac_activate(struct scsi_device *sdev=
)
>>  	struct rdac_dh_data *h =3D get_rdac_data(sdev);
>>  	int err =3D SCSI_DH_OK;
>>
>> -	if (h->lun =3D=3D UNINITIALIZED_LUN) {
>> -		err =3D get_lun(sdev);
>> -		if (err !=3D SCSI_DH_OK)
>> -			goto done;
>> -	}
>> -
>>  	err =3D check_ownership(sdev);
>> -	switch (err) {
>> -	case RDAC_UNOWNED:
>> -		break;
>> -	case RDAC_OWNED:
>> -		err =3D SCSI_DH_OK;
>> -		goto done;
>> -	case RDAC_FAILED:
>> -	default:
>> -		err =3D SCSI_DH_IO;
>=20
> What does this change yield ? (under check_ownership)
>=20
We're now setting the lun state explicitly, so there's
no need to return different error codes.

>> +	if (err !=3D SCSI_DH_OK)
>>  		goto done;
>> -	}
>>
>>  	if (!h->ctlr) {
>>  		err =3D initialize_controller(sdev);
>> @@ -508,8 +506,9 @@ static int rdac_activate(struct scsi_device *sdev)
>>  		if (err !=3D SCSI_DH_OK)
>>  			goto done;
>>  	}
>> -
>> -	err =3D send_mode_select(sdev);
>> +	if (h->lun_state !=3D RDAC_LUN_AVT &&
>> +	    !(h->lun_state & RDAC_LUN_OWNED))
>=20
> This can be simplified by (h->lun_state =3D=3D RDAC_LUN_UNOWNED) ?

Indeed,

>> +		err =3D send_mode_select(sdev);
>>  done:
>>  	return err;
>>  }
>> @@ -606,6 +605,7 @@ static int rdac_bus_attach(struct scsi_device *sde=
v)
>>  	struct scsi_dh_data *scsi_dh_data;
>>  	struct rdac_dh_data *h;
>>  	unsigned long flags;
>> +	int err;
>>
>>  	scsi_dh_data =3D kzalloc(sizeof(struct scsi_device_handler *)
>>  			       + sizeof(*h) , GFP_KERNEL);
>> @@ -622,11 +622,33 @@ static int rdac_bus_attach(struct scsi_device *s=
dev)
>>  	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>>  	sdev->scsi_dh_data =3D scsi_dh_data;
>>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>=20
> need an initialization for lun_state.
>=20
No. lun_state is initialized to '0', ie RDAC_LUN_UNOWNED.
I don't think we need a separate 'uninitialized' state here.

>> +
>> +	err =3D get_lun(sdev);
>> +	if (err !=3D SCSI_DH_OK)
>> +		goto failed;
>> +
>> +	err =3D check_ownership(sdev);
>> +	if (err !=3D SCSI_DH_OK)
>> +		goto failed;
>> +
>> +	sdev_printk(KERN_NOTICE, sdev,
>> +		    "%s: LUN %d (state %d)\n",
>> +		    RDAC_NAME, h->lun, h->lun_state);
>=20
> instead of printing lun_state as %d it would be more readable it is a
> string.
>=20
Ok.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
