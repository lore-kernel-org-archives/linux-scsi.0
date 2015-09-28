From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/23] scsi_dh_alua: simplify sense code handling
Date: Mon, 28 Sep 2015 08:41:23 +0200
Message-ID: <5608E113.9080609@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>	 <1440679281-13234-16-git-send-email-hare@suse.de> <1442949030.4132.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35892 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbbI1Gl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Sep 2015 02:41:26 -0400
In-Reply-To: <1442949030.4132.36.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 09:10 PM, Ewan Milne wrote:
> On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
>> Most sense code is already handled in the generic
>> code, so we shouldn't be adding special cases here.
>> However, when doing so we need to check for
>> unit attention whenever we're sending an internal
>> command.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 50 +++++++------------=
-----------
>>  1 file changed, 11 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 4157fe2..dbe9ff2 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -91,7 +91,6 @@ struct alua_dh_data {
>>  #define ALUA_POLICY_SWITCH_ALL		1
>> =20
>>  static char print_alua_state(int);
>> -static int alua_check_sense(struct scsi_device *, struct scsi_sense=
_hdr *);
>> =20
>>  static void release_port_group(struct kref *kref)
>>  {
>> @@ -323,28 +322,6 @@ static int alua_check_sense(struct scsi_device =
*sdev,
>>  			 * LUN Not Accessible - ALUA state transition
>>  			 */
>>  			return ADD_TO_MLQUEUE;
>> -		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x0b)
>> -			/*
>> -			 * LUN Not Accessible -- Target port in standby state
>> -			 */
>> -			return SUCCESS;
>> -		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x0c)
>> -			/*
>> -			 * LUN Not Accessible -- Target port in unavailable state
>> -			 */
>> -			return SUCCESS;
>> -		if (sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x12)
>> -			/*
>> -			 * LUN Not Ready -- Offline
>> -			 */
>> -			return SUCCESS;
>> -		if (sdev->allow_restart &&
>> -		    sense_hdr->asc =3D=3D 0x04 && sense_hdr->ascq =3D=3D 0x02)
>> -			/*
>> -			 * if the device is not started, we need to wake
>> -			 * the error handler to start the motor
>> -			 */
>> -			return FAILED;
>>  		break;
>>  	case UNIT_ATTENTION:
>>  		if (sense_hdr->asc =3D=3D 0x29 && sense_hdr->ascq =3D=3D 0x00)
>> @@ -359,7 +336,7 @@ static int alua_check_sense(struct scsi_device *=
sdev,
>>  			return ADD_TO_MLQUEUE;
>>  		if (sense_hdr->asc =3D=3D 0x2a && sense_hdr->ascq =3D=3D 0x01)
>>  			/*
>> -			 * Mode Parameters Changed
>> +			 * Mode Parameter Changed
>=20
> See below.
>=20
>>  			 */
>>  			return ADD_TO_MLQUEUE;
>>  		if (sense_hdr->asc =3D=3D 0x2a && sense_hdr->ascq =3D=3D 0x06)
>> @@ -372,18 +349,6 @@ static int alua_check_sense(struct scsi_device =
*sdev,
>>  			 * Implicit ALUA state transition failed
>>  			 */
>>  			return ADD_TO_MLQUEUE;
>> -		if (sense_hdr->asc =3D=3D 0x3f && sense_hdr->ascq =3D=3D 0x03)
>> -			/*
>> -			 * Inquiry data has changed
>> -			 */
>> -			return ADD_TO_MLQUEUE;
>=20
> ??? See below.
>=20
>> -		if (sense_hdr->asc =3D=3D 0x3f && sense_hdr->ascq =3D=3D 0x0e)
>> -			/*
>> -			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
>> -			 * when switching controllers on targets like
>> -			 * Intel Multi-Flex. We can just retry.
>> -			 */
>> -			return ADD_TO_MLQUEUE;
>=20
> ??? See below.
>=20
>>  		break;
>>  	}
>> =20
>> @@ -448,9 +413,16 @@ static int alua_rtpg(struct scsi_device *sdev, =
struct alua_port_group *pg, int w
>>  			pg->flags |=3D ALUA_RTPG_EXT_HDR_UNSUPP;
>>  			goto retry;
>>  		}
>> -
>> -		err =3D alua_check_sense(sdev, &sense_hdr);
>> -		if (err =3D=3D ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
>> +		/*
>> +		 * Retry on ALUA state transition or if any
>> +		 * UNIT ATTENTION occurred.
>> +		 */
>> +		if (sense_hdr.sense_key =3D=3D NOT_READY &&
>> +		    sense_hdr.asc =3D=3D 0x04 && sense_hdr.ascq =3D=3D 0x0a)
>> +			err =3D SCSI_DH_RETRY;
>> +		else if (sense_hdr.sense_key =3D=3D UNIT_ATTENTION)
>> +			err =3D SCSI_DH_RETRY;
>> +		if (err =3D=3D SCSI_DH_RETRY && time_before(jiffies, expiry)) {
>>  			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
>>  				    ALUA_DH_NAME);
>>  			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
>=20
> "Mode Parameters Changed" comment should not have been changed to "Mo=
de Parameter Changed".
> The actual T10 text is "Mode Parameters Changed", so leave it the way=
 it is.
>=20
Okay.

> The sense code handling in the UA case for ASC/ASCQ 3F 03 is changed =
by this patch to
> return SUCCESS from scsi_check_sense() instead of ADD_TO_MLQUEUE from=
 alua_check_sense(),
> and the sense code handling in the UA case for ASC/ASCQ 3F 0E is chan=
ged by this patch to
> return NEEDS_RETRY from scsi_check_sense() instead of ADD_TO_MLQUEUE =
from alua_check_sense().
> So we will not reissue the command on INQUIRY DATA HAS CHANGED and wi=
ll have different
> flow of control on REPORTED LUNS DATA HAS CHANGED.  What is the reaso=
n for this?
>=20
'INQUIRY DATA HAS CHANGED' will be handled with a later patch, so I
had it removed from here. But indeed, these hunks shouldn't be
removed. I'll be reverting that.

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
