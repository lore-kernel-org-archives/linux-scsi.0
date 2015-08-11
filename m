From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Tue, 11 Aug 2015 16:45:10 -0500
Message-ID: <36F77925-AEEA-4D5A-BA70-7EC91BFED938@linux.vnet.ibm.com>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439264518.14448.78.camel@kernel.crashing.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:39716 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbbHKVpN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 17:45:13 -0400
Received: from /spool/local
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 11 Aug 2015 15:45:12 -0600
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 360403E40052
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:45:11 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7BLjBu152363396
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 14:45:11 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7BLj9Pp010375
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 15:45:10 -0600
In-Reply-To: <1439264518.14448.78.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Aug 10, 2015, at 10:41 PM, Benjamin Herrenschmidt <benh@kernel.cra=
shing.org> wrote:
>=20
> On Mon, 2015-08-10 at 12:09 -0500, Matthew R. Ochs wrote:
>> Introduce support for enhanced I/O error handling.
>>=20
>> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>> ---
>=20
> So I'm not necessarily very qualified to review SCSI bits as I haven'=
t
> done anything close to the Linux SCSI code for almost a decade but I
> have a couple of questions and nits=E2=80=A6

Thanks for reviewing Ben!

>=20
>> 	wait_queue_head_t tmf_waitq;
>> 	bool tmf_active;
>> -	u8 err_recovery_active:1;
>> +	wait_queue_head_t limbo_waitq;
>> +	enum cxlflash_state state;
>> };
>>=20
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
>> +		goto out;
>> +	case STATE_FAILTERM:
>> +		pr_debug_ratelimited("%s: device has failed!\n", __func__);
>> +		goto error;
>> +	default:
>> +		break;
>> +	}
>=20
> I noticed that you mostly read and write that new state outside of yo=
ur
> tmf_waitq.lock. Is there any other lock or mutex protecting you ? In
> this specific case ?

No there isn=E2=80=99t.

>=20
> I know in the old day queuecommand was called with a host lock, is th=
at
> still the case ?

No, it=E2=80=99s no longer the case.

> Or you just don't care about an occasional spurrious
> SCSI_MLQUEUE_HOST_BUSY ?

This is pretty much true. =3D)

>=20
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
>> +		if (cfg->state =3D=3D STATE_NORMAL)
>> +			break;
>> +		/* fall through */
>> +	default:
>> 		rc =3D FAILED;
>> +		break;
>> +	}
>=20
> Same here, since you are doing wait_event, I assume no lock is held
> (unless it's a mutex) and in subsequent places I am not listing.
>=20
> As I said, it could well be that it all works fine but it would be wo=
rth
> mentioning in this case because it's not obvious from simply reading =
the
> code.

It has been working well, and yes, your assumption is correct. We can l=
ook at
adding more/better serialization as a future enhancement.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
