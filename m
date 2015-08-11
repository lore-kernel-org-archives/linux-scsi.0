From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 1/3] cxlflash: Base error recovery support
Date: Tue, 11 Aug 2015 09:17:10 -0500
Message-ID: <CCF4EE20-6211-4CA6-96F1-311BF0A294B4@linux.vnet.ibm.com>
References: <1439226574-7766-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439250778.24419.5.camel@axtens.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:35341 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025AbbHKORO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 10:17:14 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 11 Aug 2015 08:17:14 -0600
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 140F63E40041
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 08:17:12 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7BEGH0P35717368
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 07:16:17 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7BEHAU8007199
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 08:17:11 -0600
In-Reply-To: <1439250778.24419.5.camel@axtens.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

> On Aug 10, 2015, at 6:52 PM, Daniel Axtens <dja@axtens.net> wrote:
>=20
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
> I think you want:
>=20
> 	if (rcr) {
> 		rc =3D FAILED;
> 		break;
> 	}
>=20
> cxlflash_afu_reset returns 0 on success, so I think you want to drop =
the
> negation, and also I think if it fails you want to break out and not =
set
> STATE_NORMAL. Is that right?

Good catch!

Both of these were an oversight on my part and are now fixed. They=E2=80=
=99ll be
included with v5.

>=20
> Once you fix that, or explain to me why I'm wrong:
> Reviewed-by: Daniel Axtens <dja@axtens.net>

Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
