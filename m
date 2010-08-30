From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_alua: add missing transitioning state support
Date: Mon, 30 Aug 2010 11:36:30 +0200
Message-ID: <4C7B7B9E.3020002@suse.de>
References: <1282071956-391-1-git-send-email-snitzer@redhat.com> <1282073039.30453.37.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab0H3Jgb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2010 05:36:31 -0400
In-Reply-To: <1282073039.30453.37.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Mike Snitzer <snitzer@redhat.com>, James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Nicholas A. Bellinger wrote:
> On Tue, 2010-08-17 at 15:05 -0400, Mike Snitzer wrote:
>> Handle transitioning in the prep_fn.
>> Handle transitioning in alua_rtpg's implicit alua code too.
>>
>> These gaps were identified during controller failover testing of an
>> ALUA array.
>>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c |   10 +++++++---
>>  1 files changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index 1a970a7..c1eedc5 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -616,6 +616,9 @@ static int alua_rtpg(struct scsi_device *sdev, s=
truct alua_dh_data *h)
>>  		    h->state =3D=3D TPGS_STATE_STANDBY)
>>  			/* Useable path if active */
>>  			err =3D SCSI_DH_OK;
>> +		else if (h->state =3D=3D TPGS_STATE_TRANSITIONING)
>> +			/* State transition, retry */
>> +			goto retry;
>>  		else
>>  			/* Path unuseable for unavailable/offline */
>>  			err =3D SCSI_DH_DEV_OFFLINED;
>> @@ -698,13 +701,14 @@ static int alua_prep_fn(struct scsi_device *sd=
ev, struct request *req)
>>  	struct alua_dh_data *h =3D get_alua_data(sdev);
>>  	int ret =3D BLKPREP_OK;
>> =20
>> -	if (h->state !=3D TPGS_STATE_OPTIMIZED &&
>> -	    h->state !=3D TPGS_STATE_NONOPTIMIZED) {
>> +	if (h->state =3D=3D TPGS_STATE_TRANSITIONING)
>> +		ret =3D BLKPREP_DEFER;
>> +	else if (h->state !=3D TPGS_STATE_OPTIMIZED &&
>> +		 h->state !=3D TPGS_STATE_NONOPTIMIZED) {
>>  		ret =3D BLKPREP_KILL;
>>  		req->cmd_flags |=3D REQ_QUIET;
>>  	}
>>  	return ret;
>> -
>>  }
>> =20
>=20
> Makes sense to me..
>=20
> Acked-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
>=20
Not so fast. There are two problems with this approach:

The path is retried indefinitely. Arrays are _supposed_ to be in 'trans=
itioning'
only temporary; however, if the array is stuck due to a fw error we're =
stuck in 'defer',
too.

Secondly this path fails with 'directio' multipath checker. Remember th=
at 'directio'
is using 'fs' requests, not block-pc ones. Hence for all I/O the prep_f=
n() callback
is evaluated, which will return 'DEFER' here once the path is in transi=
tioning.
And the state is never updated as RTPG is never called.

I'm currently preparing a patch which addressed these situations, too.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
