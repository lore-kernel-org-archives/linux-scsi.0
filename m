Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651823DEFFE
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094432; cv=none; b=keaH2sUN/+2B0SjpVJ3cvKwC4WU0Z4PbqhY1W9A4Lnbn2txvJ3BM+mdMg0umNPADhohAUvf7Yt7T/Fzyl+MSuwmxevE4wVN+S3b7N7HtdNEtoXGJjqTp7kz3zwtrVk2BxUFJtd+u9s03GQ6JSYcPe29eKomG8gfJdsNw4NRqn0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094432; c=relaxed/simple;
	bh=56C3/T5WCbGmqhfcTu8vLAf+JtfAKmQ+otgt9sv89PY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MPyPLZ4dwYGLh6D+ySsrD+no7z1RkZz5iaPNPUUMXmHSwWc3DIJIIiciB2KfgTRmkKEPt8LRaIWn1FCe8aEZZHvyL/DZhpSeymaZdU9EGzZNF/EvNucrlQvwIrXuMOsLs7GD5d/zXoFeho+Psz3lNV75KoX3wbMaQ90rVolSHr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTAB0TC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTAB0TC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03621F00893;
	Fri, 11 Sep 2026 02:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789094431;
	bh=CxLwiXo3D7m+/GWHsuRch604PJqS+Hzo6Y0tL3H+yZY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WTAB0TC9WbEkT1RPc+US6bro8rXgqyVoBQCz5Dsk+e7KFZYb0+cvJMbstsImj64yY
	 pB4NWg6GSujuyBd8d5d6+pVkepMqeji16gtuMoL99OVhRaI6uQTIVUlfQ24S3d4zWz
	 xkTbUhwL6l0eNva+lZw89TR2bOYxhHfU7DkDbqIoy4Zv0zKYgF6q9sjrBEY1gAcf8U
	 N8n8hOgUoF0a+VqQPa4ecXqjC+oNcxoOLg8lNG5N2h9aYiLhZRl43vCX8a2xWNSY3M
	 cGocBbwV+taQVhdLisDu1o8pIQ0jOws076s6YO4s1umNxJk5POTc77DenCrB8ySTIG
	 0QLj27H1A1rjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 9/9] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911021910.1038128-10-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-10-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:40:30 +0000
Message-Id: <20260911024030.D03621F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Unused list head and assigned but unused local variables in kunit t=
est function.
--

commit e69daead7ba4a1176ce3e9bde4970bed18450907
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: handle extended FPIN events

Implement support for extended FPIN messages received via the
asynchronous sub-queue, completing full FPIN functionality.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index 7aaed4f64f26b..80e7f8e0fd700 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> @@ -256,9 +257,143 @@ static void ibmvfc_full_fpin_test(struct kunit *tes=
t)
>  	scsi_host_put(vhost->host);
>  }
> =20
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
> +
> +/**
> + * ibmvfc_extended_fpin_test - unit test for extended FPIN events
> + * @test: pointer to kunit structure
> + *
> + * Note: This test exercises extended FPIN code paths but does not check
> + * that statistics are correctly updated.
> + *
> + * Return: void
> + */
> +static void ibmvfc_extended_fpin_test(struct kunit *test)
> +{
> +	enum ibmvfc_ae_fpin_status fs;
> +	struct ibmvfc_async_subq_fpin crq[IBMVFC_AE_FPIN_CONGESTION_CLEARED+1] =
=3D {};
> +	struct ibmvfc_async_subq_fpin
> +		crqcn[IBMVFC_AE_FPIN_PORT_CONGESTED][FPIN_CONGN_DEVICE_SPEC+1] =3D {};
> +	struct ibmvfc_async_subq_fpin crqportdg[FPIN_LI_DEVICE_SPEC+1] =3D {};
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_rport *rport;
> +	LIST_HEAD(evt_doneq);
> +	unsigned long flags;
> +	u64 pre, post;

[Severity: Low]
Are evt_doneq, pre, and post unused in ibmvfc_extended_fpin_test()?

The function declares LIST_HEAD(evt_doneq) which is never used. It also
declares and assigns pre and post variables (via the IBMVFC_TEST_FPIN_EXT
macro and manually later in the function) but never evaluates them. Could t=
his
leave dead code and potentially trigger compiler warnings for unused variab=
les?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911021910.1038=
128-1-tyreld@linux.ibm.com?part=3D9
