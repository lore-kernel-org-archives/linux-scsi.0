Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F69A3C3F6A
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788216965; cv=none; b=TD0E8ovv7lrY3p9QX7a2TJMN++S4P+WsL0McalWHrM2Dp8xsGy3l30Zib137KQXbD+VuzuSdjWBCuXd1wflnXtu3m6oS9DeRwg+J24mFduZxOeqzGapMFLbb8VDsYtmsZ4jLz4Hbv59v5pmB7ZQ4QaM3a6R7CN8CRr0z/pFCfDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788216965; c=relaxed/simple;
	bh=wY1pphrIdgXI829jqs4uV2vS12taVC6zU4UXZ9Rnixw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PViDF5plZJLDxCf6E1tlPjZB+AuW1xnIsA8/id04KhsC771EpRKNsM32fD3xfH1XlwC9Tuzt/64dQFFGFChqpRTRZ9sUAePoKWXjM+BWUNa4zFDPTpnG0QwHbdOuGoe+fs5ZPjFxINmlQaCf1bsOSwUMiM49f8TbPIi6mKNRezs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bCTqEeuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bCTqEeuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007591F000E9;
	Mon, 31 Aug 2026 22:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788216964;
	bh=iyFt0BjChBFLwIurTqKUX41wzmQxfe5b/5A0EediKZ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bCTqEeuh9VEZN69VP4lR1K/3JEFiiwQWgQArX6oUnR4FOdrc/e5Mfxra9eaSdSshF
	 rIhrI2I5yi4BL0/6gEvOCxvNigb9lVe7+DNN0Yeqe2K4v2Di8fEX8I85hVSX1U7Odu
	 ypjmV6PBdSMNR0+aw8PP4YbnLAXYzIyGgrM/8EFrjn++0exoq5+ivxCeOeGTHL4YJT
	 TXDcnueJYCgB4qHvJI2piOUh9rHVReAic3SQGiMsjx4coqYi4bUMfOCWaVeuxjBliA
	 QERlzhq/iIFcF3ZuMwPAuQf2p16s/w4/PATYJUSzhMEJjFsXqnr5gEhx4EOMDUu85f
	 PZjWHUDAqcGvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 8/8] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260831-ibmvfc-fpin-support-v7-8-77d0b9809080@linux.ibm.com>
References: <20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com>
 <20260831-ibmvfc-fpin-support-v7-8-77d0b9809080@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 22:56:03 +0000
Message-Id: <20260831225604.007591F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `ibmvfc_extended_fpin_test` test suite is entirely invalid d=
ue to missing KUnit assertions and incorrect statistics targeting.
--

commit 7f2470a8cbfd29182f9253c971ce356e69e43c8e
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: handle extended FPIN events

Implement support for extended FPIN messages received via the asynchronous=
=20
sub-queue. Add parsing and processing logic to convert these into=20
fc_els_fpin structures. Include comprehensive KUnit tests to validate the=20
extended FPIN event handling.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index 47f7c4e79cd81..b016c7da24cd6 100644
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
> +	pre =3D READ_ONCE(tgt->rport->fpin_stats.stat);				\
> +	ibmvfc_handle_async(&ae, vhost);					\
> +	flush_workqueue(vhost->fpin_workq);					\
> +	post =3D READ_ONCE(tgt->rport->fpin_stats.stat);				\
> +}

[Severity: Medium]
Does this macro actually verify the statistics have changed? It captures the
pre and post state, but doesn't appear to perform any KUnit assertions
(like KUNIT_EXPECT_GE) to validate the test results.

Additionally, this macro always queries tgt->rport->fpin_stats for all even=
ts.
Is this correct for host-level link congestion events which might update
fc_host->fpin_stats instead?

> +
> +/**
> + * ibmvfc_extended_fpin_test - unit test for extended FPIN events
> + * @test: pointer to kunit structure
> + *
> + * Tests
> + *
> + * Return: void
> + */
> +static void ibmvfc_extended_fpin_test(struct kunit *test)
> +{
> +	enum ibmvfc_ae_fpin_status fs;

[ ... ]

> +	for (fs =3D IBMVFC_AE_FPIN_LINK_CONGESTED; fs <=3D IBMVFC_AE_FPIN_CONGE=
STION_CLEARED; fs++) {
> +		switch (fs) {
> +		case IBMVFC_AE_FPIN_PORT_CLEARED:
> +		case IBMVFC_AE_FPIN_CONGESTION_CLEARED: {
> +			struct ibmvfc_async_crq_event ae =3D { .type =3D IBMVFC_ASYNC_CRQ_SUB=
 };
> +
> +			crq[fs].valid =3D 0x80;
> +			crq[fs].flags =3D IBMVFC_ASYNC_IS_FPIN_EXT;
> +			crq[fs].link_state =3D IBMVFC_AE_LS_LINK_UP;
> +			crq[fs].fpin_status =3D fs;
> +			crq[fs].event =3D cpu_to_be16(IBMVFC_AE_FPIN);
> +			crq[fs].wwpn =3D cpu_to_be64(tgt->wwpn);
> +			crq[fs].fpin_data.flags =3D IBMVFC_FPIN_EVENT_TYPE_VALID;
> +			crq[fs].fpin_data.event_type =3D cpu_to_be16(FPIN_CONGN_CLEAR);
> +			ae.subq =3D *(struct ibmvfc_async_sub_crq *)&crq[fs];
> +			pre =3D READ_ONCE(tgt->rport->fpin_stats.cn_clear);
> +			ibmvfc_handle_async(&ae, vhost);
> +			flush_workqueue(vhost->fpin_workq);
> +			post =3D READ_ONCE(tgt->rport->fpin_stats.cn_clear);
> +			break;
> +		}

[Severity: Medium]
Similar to the macro above, is there a missing KUnit assertion here in
ibmvfc_extended_fpin_test() to validate that the statistics were properly
updated?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831-ibmvfc-fpi=
n-support-v7-0-77d0b9809080@linux.ibm.com?part=3D8
