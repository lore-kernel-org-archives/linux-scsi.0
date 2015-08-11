From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Tue, 11 Aug 2015 16:40:02 -0500
Message-ID: <F4621B1F-AE69-415E-A2D7-4B6FEF9CCB09@linux.vnet.ibm.com>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439258736.5081.41.camel@neuling.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:49860 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbHKVkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 17:40:07 -0400
Received: from /spool/local
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 11 Aug 2015 15:40:06 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 6671419D8042
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:31:01 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7BLe4Go46989366
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 14:40:04 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7BLe2fO025338
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:40:04 -0600
In-Reply-To: <1439258736.5081.41.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Mikey,

Thanks for reviewing. Responses to your comments inline below.


-matt

> On Aug 10, 2015, at 9:05 PM, Michael Neuling <mikey@neuling.org> wrot=
e:
>=20
> On Mon, 2015-08-10 at 12:09 -0500, Matthew R. Ochs wrote:
>> Introduce support for enhanced I/O error handling.
>=20
> This needs more description of what you're doing.  What's the overall
> approach? There seems to be a new limbo queue thats created stall thi=
ngs
> while the device is in error state.  That should be described here.

Sure, will do that in v5.

>> struct afu_cmd {
>> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/ma=
in.c
>> index 76a7286..18359d4 100644
>> --- a/drivers/scsi/cxlflash/main.c
>> +++ b/drivers/scsi/cxlflash/main.c
>> @@ -380,6 +380,18 @@ static int cxlflash_queuecommand(struct Scsi_Ho=
st *host, struct scsi_cmnd *scp)
>> 	}
>> 	spin_unlock_irqrestore(&cfg->tmf_waitq.lock, lock_flags);
>>=20
>> +	switch (cfg->state) {
>> +	case STATE_LIMBO:
>> +		pr_debug_ratelimited("%s: device in limbo!\n", __func__);
>> +		rc =3D SCSI_MLQUEUE_HOST_BUSY;
>=20
> So if the client gets BUSY, it should retry until it suceeds or gets =
a terminal
> failure?

Correct, although this situation won=E2=80=99t hit often because as par=
t of transitioning
to limbo, we tell the host to stop handing down new requests.

>=20
>> +		goto out;
>> +	case STATE_FAILTERM:
>> +		pr_debug_ratelimited("%s: device has failed!\n", __func__);
>> +		goto error;
>=20
> error is only used here, so there is no need for a goto.

This was a holdover from when we did have a need for a common error exi=
t. Will
remove in v5.

>> 	cmd =3D cxlflash_cmd_checkout(afu);
>> 	if (unlikely(!cmd)) {
>> 		pr_err("%s: could not get a free command\n", __func__);
>> @@ -428,6 +440,10 @@ static int cxlflash_queuecommand(struct Scsi_Ho=
st *host, struct scsi_cmnd *scp)
>>=20
>> out:
>> 	return rc;
>> +error:
>> +	scp->result =3D (DID_NO_CONNECT << 16);
>> +	scp->scsi_done(scp);
>> +	return 0;
>=20
> 0 is success.  That doesn=E2=80=99t seem right for an error.

This is simply how this interface works.

It does seem a bit silly but what we=E2=80=99re doing here is telling t=
he stack =E2=80=9Cyes we
accept your request=E2=80=9D and then pushing the request back via done=
() with an error
due to the host being unable to satisfy the request.

>=20
>> }
>>=20
>> /**
>> @@ -455,9 +471,21 @@ static int cxlflash_eh_device_reset_handler(str=
uct scsi_cmnd *scp)
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>>=20
>> -	rcr =3D send_tmf(afu, scp, TMF_LUN_RESET);
>> -	if (unlikely(rcr))
>> +	switch (cfg->state) {
>> +	case STATE_NORMAL:
>> +		rcr =3D send_tmf(afu, scp, TMF_LUN_RESET);
>> +		if (unlikely(rcr))
>> +			rc =3D FAILED;
>> +		break;
>> +	case STATE_LIMBO:
>> +		wait_event(cfg->limbo_waitq, cfg->state !=3D STATE_LIMBO);
>=20
> So we wait here till we are our of limbo?

Correct, the idea here is that we only go into limbo when a host-wide
reset action has occurred. In such a scenario, it doesn=E2=80=99t make =
sense
to send a device specific reset as a host-wide reset is a bigger hammer=
=2E
So we wait here until the reset has completed and then (assuming it was
successful) we return success.

>=20
>> +		if (cfg->state =3D=3D STATE_NORMAL)
>> +			break;
>> +		/* fall through */
>> +	default:
>> 		rc =3D FAILED;
>> +		break;
>> +	}
>>=20
>> 	pr_debug("%s: returning rc=3D%d\n", __func__, rc);
>> 	return rc;
>> @@ -487,11 +515,27 @@ static int cxlflash_eh_host_reset_handler(stru=
ct scsi_cmnd *scp)
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[2]),
>> 		 get_unaligned_be32(&((u32 *)scp->cmnd)[3]));
>>=20
>> -	rcr =3D cxlflash_afu_reset(cfg);
>> -	if (rcr =3D=3D 0)
>> -		rc =3D SUCCESS;
>> -	else
>> +	switch (cfg->state) {
>> +	case STATE_NORMAL:
>> +		cfg->state =3D STATE_LIMBO;
>> +		scsi_block_requests(cfg->host);
>> +
>> +		rcr =3D cxlflash_afu_reset(cfg);
>> +		if (!rcr)
>> +			rc =3D FAILED;
>=20
> This is some sort of recovery once we get back into normal state?  Ca=
n you
> comment what you=E2=80=99re doing here?

What=E2=80=99s occurring here is that we=E2=80=99ve been asked to reset=
 the host and have
determined that another reset is not already taking place. To perform t=
he
reset, we need to transition to the limbo state so that other running t=
hreads
and new threads will wait while the reset takes place. Note that we=E2=80=
=99re also
putting user contexts in an error state so that they are notified and w=
ill have
to be recovered before they can resume operation (the reset is catastro=
phic
to them).
>=20
>> +		cfg->state =3D STATE_NORMAL;
>> +		wake_up_all(&cfg->limbo_waitq);
>> +		scsi_unblock_requests(cfg->host);
>=20
> Now we actually go to normal?

Correct, assuming the reset completes successfully then we=E2=80=99re n=
o longer
in limbo and have returned to a good, working state (normal). Note that
Daniel Axtens pointed out that we need to transition to a failed state =
when
the reset does not complete successfully. That will be changed in v5.

>=20
>> +		break;
>> +	case STATE_LIMBO:
>> +		wait_event(cfg->limbo_waitq, cfg->state !=3D STATE_LIMBO);
>=20
> Wait here till we are out of limbo?  What happens if that never occur=
s?

This case would be hit if there was already a reset action taking place
(state of device in limbo). These events should not take long. A transi=
tion
out of limbo never occurring would be a bug on the driver=E2=80=99s par=
t.

>> 	rc =3D init_mc(cfg);
>> 	if (rc) {
>> 		dev_err(dev, "%s: call to init_mc failed, rc=3D%d!\n",
>> @@ -2021,6 +2069,12 @@ void cxlflash_wait_resp(struct afu *afu, stru=
ct afu_cmd *cmd)
>>  * the sync. This design point requires calling threads to not be on=
 interrupt
>>  * context due to the possibility of sleeping during concurrent sync=
 operations.
>>  *
>> + * AFU sync operations are only necessary and allowed when the devi=
ce is
>> + * operating normally. When not operating normally, sync requests c=
an occur as
>> + * part of cleaning up resources associated with an adapter prior t=
o removal.
>> + * In this scenario, these requests are simply ignored (safe due to=
 the AFU
>> + * going away).
>> + *
>=20
> What about if we are in limbo state and it comes back?

Limbo state indicates that the device is being reset. When the device
is being reset, a sync does not matter as it=E2=80=99s state (the devic=
e=E2=80=99s) is being
lost during the reset. The device will be reloaded with the proper stat=
e as
part of the reset and recovery [of user contexts].

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
