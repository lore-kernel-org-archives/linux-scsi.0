From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Wed, 12 Aug 2015 12:00:23 -0500
Message-ID: <1A60E57B-2272-47D5-BD34-4E8517C4C99B@linux.vnet.ibm.com>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com> <20150812001556.Horde.B0DQAWPuWIGynBAYlIejmg1@ltc.linux.ibm.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:55740 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187AbbHLRAe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 13:00:34 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 12 Aug 2015 13:00:33 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id B0688C90043
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 12:51:34 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7CH0TOC58786028
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 17:00:29 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7CH0RCp007963
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2015 13:00:29 -0400
In-Reply-To: <20150812001556.Horde.B0DQAWPuWIGynBAYlIejmg1@ltc.linux.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wenxiong@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

Hi Wendy,

Thanks for reviewing. Comments inline below.


-matt

> On Aug 11, 2015, at 11:15 PM, wenxiong@linux.vnet.ibm.com wrote:
>=20
>=20
> Quoting "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>:
>=20
>> Introduce support for enhanced I/O error handling.
>>=20
>> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
>> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
>> ---
>> drivers/scsi/cxlflash/Kconfig  |   2 +-
>> drivers/scsi/cxlflash/common.h |  11 ++-
>> drivers/scsi/cxlflash/main.c   | 166 +++++++++++++++++++++++++++++++=
+++++++---
>> drivers/scsi/cxlflash/main.h   |   4 +
>> 4 files changed, 170 insertions(+), 13 deletions(-)
>>=20
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
>=20
> remove =E2=80=9Cgoto out", return SCSI_MLQUEUE_HOST_BUSY;

I=E2=80=99d like to keep this as goto out as we have a common exit poin=
t strategy
already in place for this routine (and pretty much everywhere else in t=
he
driver for that matter). It would seem odd to just have this one place =
perform
a direct return.

Additionally, not included in this patch but one of the bug fixes/enhan=
cements
(to be sent out as a separate patch series) we=E2=80=99ve made to this =
routine is to add
a =E2=80=98devel=E2=80=99 trace point in the common exit to help with d=
ebug.
=20
>=20
>> +	case STATE_FAILTERM:
>> +		pr_debug_ratelimited("%s: device has failed!\n", __func__);
>> +		goto error;
>> +	default:
>> +		break;
>> +	}
>> +
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
> I have reviewed most of part in v2.

Thanks again for your previous comments.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
