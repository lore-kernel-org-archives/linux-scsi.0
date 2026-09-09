Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E35456E05F
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 19:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788982132; cv=none; b=qafzMlvlSQlrQqaznmIccU4dTTAkSz3RNc/bLLhM3QLaI8kZ3GE4AL2YavhMfRwNRl6YdreL3pduneWZ3B3D9wLbIygzL1PeJ3B9Qh4y3Cq8ZKNGgJM0J0G94DLZ7MEApiIRsSIWovOVEZO1JyvOH2ZKifgnpL3H5tUy9DfrR28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788982132; c=relaxed/simple;
	bh=dDw17/u4PntmOlZn6k7Xvnmvhg072MpFrXnu1UMUL8A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KHf2J21sslhcXFx1Zqpx0NnCn6k8FDqsy7Papj+6aJZVOl7QxFSMQNrY0qazyEf7VGVUxunQ4aahbiobp0K2F24jLXx296V/gUHin4MmewkNQ9dRbAq+SRtVpiPrpgERvnOMZa68cJX+0lH+NigMdPSaRzQK33BcFaomHPt2WCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkONyQCJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkONyQCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F5A1F000FF;
	Wed,  9 Sep 2026 19:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788982130;
	bh=4YFIr90BnEGZzbLLDxovh6xuWlfx2ARGaCM/7N6KisE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PkONyQCJPuz7+uLDCb2KmvvQmDWYh2PCj4DdCRTOxwpxXg6ntv/2Cw2KwSxBwf4QS
	 g7w9ssTeNQMv4MlT4lR35BD7P/6MHnQ3wH/B5TfLXZUiXpYRw8VnKy4r0MajzJNy/w
	 j0jE8CMXR3v1V44jY6j3KYzwVMDD41w9DdLDg5AHVRBfK2kcOljXxznCKHJamkaTi3
	 29Z6wDxTM9QkPgDN93kga/sG80OS7luvqgAJuaVVGLC5yCNFZ2zGS41SgGaOMxkfoU
	 VKo6KEECAZubgnKw7COLIo+DIYl7ak4kyic583TXv4lN5OfV/O4cqHxJaTWIi8a1nF
	 AWyLa96k8Jx4w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 9/9] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-9-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-9-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 19:28:50 +0000
Message-Id: <20260909192850.C7F5A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Extended FPIN severity information provided by the hardware is i=
gnored and always downgraded to a warning.
- [Low] Unused variables `pre` and `post` in `ibmvfc_extended_fpin_test` ca=
use a `-Wunused-but-set-variable` compiler warning.
--

commit 6820bc74ced043fe70cb0c57ff71b54e4764889c
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: handle extended FPIN events

Implement support for extended FPIN messages received via the asynchronous
sub-queue. Add functions to convert extended FPIN messages to fc_els_fpin
structures, set capability bits during login, and add KUnit tests.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> +static struct fc_els_fpin *
> +ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin)
> +{
> +	u8 flags =3D ibmvfc_fpin->fpin_data.flags;
> +	__be32 threshold =3D cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD);
> +	__be16 modifier =3D 0;
> +	__be32 count =3D cpu_to_be32(1);
> +	__be16 type =3D 0;
> +
> +	if (flags & IBMVFC_FPIN_EVENT_TYPE_VALID)
> +		type =3D ibmvfc_fpin->fpin_data.event_type;
> +	if (flags & IBMVFC_FPIN_MODIFIER_VALID)
> +		modifier =3D ibmvfc_fpin->fpin_data.event_type_modifier;
> +	if (flags & IBMVFC_FPIN_THRESHOLD_VALID)
> +		threshold =3D ibmvfc_fpin->fpin_data.event_threshold;
> +	if (flags & IBMVFC_FPIN_EVENT_COUNT_VALID)
> +		count =3D ibmvfc_fpin->fpin_data.event_data.event_count;
> +
> +	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status,
> +					  ibmvfc_fpin->wwpn, type,
> +					  modifier, threshold, count);
> +}

[Severity: Medium]
Does this code accidentally ignore the hardware-provided FPIN severity?=20

When an extended FPIN event with the IBMVFC_FPIN_SEVERITY_VALID flag is
received, the payload parsing seems to ignore the severity field. Because
ibmvfc_common_fpin_to_desc() unconditionally hardcodes the severity to
FPIN_CONGN_SEVERITY_WARNING, does this lead to losing critical fabric
congestion event severity information (such as Error or Fatal statuses)
from the hardware?

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> +#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat, crq) {				\
> +	struct ibmvfc_async_crq_event ae =3D { .type =3D IBMVFC_ASYNC_CRQ_SUB }=
;	\
> +	(crq).valid =3D 0x80;							\
> +	(crq).flags =3D IBMVFC_ASYNC_IS_FPIN_EXT;					\
> +	(crq).link_state =3D IBMVFC_AE_LS_LINK_UP;				\
> +	(crq).fpin_status =3D (fs);						\
> +	(crq).event =3D cpu_to_be16(IBMVFC_AE_FPIN);				\
> +	(crq).wwpn =3D cpu_to_be64(tgt->wwpn);					\
> +	(crq).fpin_data.flags =3D IBMVFC_FPIN_EVENT_TYPE_VALID;			\
> +	(crq).fpin_data.event_type =3D cpu_to_be16((ev));				\
> +	ae.subq =3D *(struct ibmvfc_async_sub_crq *)&(crq);			\
> +	pre =3D READ_ONCE(rport->fpin_stats.stat);				\
> +	ibmvfc_handle_async(&ae, vhost);					\
> +	flush_workqueue(vhost->fpin_workq);					\
> +	post =3D READ_ONCE(rport->fpin_stats.stat);				\
> +}

[Severity: Low]
Are the pre and post variables missing evaluation in the test assertions?

They are assigned via READ_ONCE() but never used subsequently in the macro =
or
calling functions, which triggers a -Wunused-but-set-variable compiler
warning when KUnit is enabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D9
