From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/16] scsi_dh_alua: multipath failover fails with error
 15
Date: Mon, 30 Mar 2015 14:32:48 +0200
Message-ID: <55194270.2010806@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-12-git-send-email-hare@suse.de> <551941CC.8010908@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56541 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbbC3Mcu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2015 08:32:50 -0400
In-Reply-To: <551941CC.8010908@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 03/30/2015 02:30 PM, Bart Van Assche wrote:
> On 01/31/14 10:29, Hannes Reinecke wrote:
>> When a path is already optimized multipath failover will fail
>> with the message
>> Could not failover device X:Y: Handler scsi_dh_alua Error 15
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/scsi/device_handler/scsi_dh_alua.c | 7 +++++--
>>  1 file changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/sc=
si/device_handler/scsi_dh_alua.c
>> index a1c69bb..8ea35a9 100644
>> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
>> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
>> @@ -851,6 +851,8 @@ static unsigned alua_stpg(struct scsi_device *sd=
ev, struct alua_port_group *pg)
>>  		return SCSI_DH_RETRY;
>>  	}
>>  	switch (pg->state) {
>> +	case TPGS_STATE_OPTIMIZED:
>> +		return SCSI_DH_OK;
>>  	case TPGS_STATE_NONOPTIMIZED:
>>  		if ((pg->flags & ALUA_OPTIMIZE_STPG) &&
>>  		    (!pg->pref) &&
>> @@ -865,10 +867,11 @@ static unsigned alua_stpg(struct scsi_device *=
sdev, struct alua_port_group *pg)
>>  		break;
>>  	case TPGS_STATE_TRANSITIONING:
>>  		return SCSI_DH_RETRY;
>> -		break;
>>  	default:
>> +		sdev_printk(KERN_INFO, sdev,
>> +			    "%s: stpg failed, unhandled TPGS state %d",
>> +			    ALUA_DH_NAME, pg->state);
>>  		return SCSI_DH_NOSYS;
>> -		break;
>>  	}
>>  	/* Set state to transitioning */
>>  	pg->state =3D TPGS_STATE_TRANSITIONING;
>=20
> (replying to an e-mail of last year)
>=20
> Hello Hannes,
>=20
> Our Q.A. team started to run into the issue that is fixed by this pat=
ch.
> Do you have the time to resend this patch series or would you rather
> prefer that I split out this patch, test it and post it with a "Cc:
> stable" tag ?
>=20
Well, I'll have to repost the patch-series anyway; unfortunately
it's being held off by some unresolved issues.
Best I'll split if off into 'real' bugfixes and the actual
scsi_dh_alua updates.

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
