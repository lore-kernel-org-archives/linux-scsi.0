From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 10/23] scsi_dh_alua: Pass buffer as function argument
Date: Thu, 24 Sep 2015 18:37:37 +0200
Message-ID: <560426D0.8070406@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
 <1440679281-13234-11-git-send-email-hare@suse.de>
 <1442947380.4132.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320AbbIXQiO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2015 12:38:14 -0400
In-Reply-To: <1442947380.4132.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 09/22/2015 08:43 PM, Ewan Milne wrote:
> On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
>> Pass in the buffer as a function argument for submit_rtpg().
>>
>> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 20 ++++++++++---------=
-
>>  1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 0636721..9e2b3af 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -137,12 +137,13 @@ static struct request *get_alua_req(struct scs=
i_device *sdev,
>>   * submit_rtpg - Issue a REPORT TARGET GROUP STATES command
>>   * @sdev: sdev the command should be sent to
>>   */
>> -static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_d=
h_data *h)
>> +static unsigned submit_rtpg(struct scsi_device *sdev, unsigned char=
 *buff,
>> +			    int bufflen, unsigned char *sense, int flags)
>>  {
>>  	struct request *rq;
>>  	int err =3D 0;
>> =20
>> -	rq =3D get_alua_req(sdev, h->buff, h->bufflen, READ);
>> +	rq =3D get_alua_req(sdev, buff, bufflen, READ);
>>  	if (!rq) {
>>  		err =3D DRIVER_BUSY << 24;
>>  		goto done;
>> @@ -150,22 +151,21 @@ static unsigned submit_rtpg(struct scsi_device=
 *sdev, struct alua_dh_data *h)
>> =20
>>  	/* Prepare the command. */
>>  	rq->cmd[0] =3D MAINTENANCE_IN;
>> -	if (!(h->flags & ALUA_RTPG_EXT_HDR_UNSUPP))
>> +	if (!(flags & ALUA_RTPG_EXT_HDR_UNSUPP))
>>  		rq->cmd[1] =3D MI_REPORT_TARGET_PGS | MI_EXT_HDR_PARAM_FMT;
>>  	else
>>  		rq->cmd[1] =3D MI_REPORT_TARGET_PGS;
>> -	put_unaligned_be32(h->bufflen, &rq->cmd[6]);
>> +	put_unaligned_be32(bufflen, &rq->cmd[6]);
>>  	rq->cmd_len =3D COMMAND_SIZE(MAINTENANCE_IN);
>> =20
>> -	rq->sense =3D h->sense;
>> +	rq->sense =3D sense;
>>  	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
>> -	rq->sense_len =3D h->senselen =3D 0;
>> +	rq->sense_len =3D 0;
>> =20
>>  	blk_execute_rq(rq->q, NULL, rq, 1);
>> -	if (rq->errors) {
>> +	if (rq->errors)
>>  		err =3D rq->errors;
>> -		h->senselen =3D rq->sense_len;
>> -	}
>> +
>>  	blk_put_request(rq);
>>  done:
>>  	return err;
>> @@ -491,7 +491,7 @@ static int alua_rtpg(struct scsi_device *sdev, s=
truct alua_dh_data *h, int wait_
>>  		expiry =3D round_jiffies_up(jiffies + h->transition_tmo * HZ);
>> =20
>>   retry:
>> -	retval =3D submit_rtpg(sdev, h);
>> +	retval =3D submit_rtpg(sdev, h->buff, h->bufflen, h->sense, h->fla=
gs);
>> =20
>>  	if (retval) {
>>  		if (!scsi_normalize_sense(h->sense, SCSI_SENSE_BUFFERSIZE,
>=20
> This patch also removes the setting of h->senselen, you should mentio=
n
> that in the patch description.  Or, perhaps the removal of h->sensele=
n
> should have been done as part of patch 12/23, which removed the sense=
len
> field (and the sense buffer field) from the alua_dh_data structure.

Is already done with the next version of the patchset.

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
