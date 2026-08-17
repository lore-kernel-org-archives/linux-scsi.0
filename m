Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D959275AFD
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 20:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786999314; cv=none; b=dPncPEEc5Pyydvl1vxhY3wF2IhZIY8pJ/dsQyW3Emn5Z/VnjFDcMhfrA4laCoFUjtPEX9bQBMq+x9eN3j6/KI574zC2Lq3JCS3ps8z5XreFS7jU64AEr5ji1hZCTe+tTCwZcrDmaD8GOCy5zrQhTD3q6OvUNgbuOUrt1unCoP+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786999314; c=relaxed/simple;
	bh=BskA2h/X2Fe16tQETHieEvRP37XUQDc/PCXNE4ZNOaA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A59tPDoPoSFsbo0clLK3YcvMUsIWltmix3sE3us0ZqX5cCIYEv/rSS/2F/LKs78XDV3gOGR0iM3DuypYkO38bVBjljQ1E9OdnYrSWh0Gt7cVezirnbNLlRekJWeMDnVBFVBjjJ/QDNSQ90N1QOuIvgIQX6135oNLhl9kf8g687c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D7LRe13f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D7LRe13f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384DC1F000E9;
	Mon, 17 Aug 2026 20:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786999313;
	bh=w059AldXqMGDCRS1BIPMYsZ/8VYHzY0i3drYF9H+PB4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=D7LRe13fXhZGR5dx8orlRwy/uQB2TrO2pEustdBNtVJ2WvTFp5y8Fng22wP3eNfHj
	 NNVFUZUnHeeQ/KKmnTVaEfPsQpgB+Ad9Kgjz6quamiyCrf7h3pNS0mb0Thwpk+jBTP
	 B1ONQzQxQAm/cKrNqijPn1Hu7SvjBSufolWtL4r0ngxPZSCNQsu2+i2WDoi+E8Co9P
	 KlhV8JEJv31l/PAjZszcNPOmXSZdcIBwUmIYyLtA16g3ClidD5vJXSBrbKx4zv/5/g
	 uStM7SwxLpuWOvce8YYSnX7PmsuQD5SOoTsVYZgJdTZ0fIndev+Psx9jf6I4+Kf8oH
	 r0jXNh63ntOBQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 8/8] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260817-ibmvfc-fpin-support-v6-8-62a2d525e70d@linux.ibm.com>
References: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
 <20260817-ibmvfc-fpin-support-v6-8-62a2d525e70d@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 17 Aug 2026 20:41:52 +0000
Message-Id: <20260817204153.384DC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Extended FPIN events are incorrectly discarded because a structure=
 union overlap corrupts the `node_name` search key.
- [High] A race condition during driver removal triggers a NULL pointer der=
eference in the interrupt handler due to premature teardown of `fpin_workq`.
- [Medium] The `ibmvfc_extended_fpin_test` suite lacks KUnit assertions to =
verify statistic updates and relies on flaky `msleep()` synchronization.
--

--- Patch [8]: [PATCH v6 8/8] scsi: ibmvfc: handle extended FPIN events ---
commit 3ae60b854350b472f08abc0cb2cc22c2f6e12865
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: handle extended FPIN events

Implement support for extended FPIN messages received via the asynchronous
sub-queue. This converts extended FPIN messages from async sub-queue format
to fc_els_fpin structures and updates capabilities and tests.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 0368fb1763c3a..e36c3c0a81fbf 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3504,6 +3540,7 @@ static struct ibmvfc_target *ibmvfc_find_target(str=
uct list_head *target_list,
>  static void ibmvfc_process_async_work(struct work_struct *work)
>  {
>  	struct ibmvfc_async_sub_crq *subq =3D NULL;
> +	struct ibmvfc_async_subq_fpin *sqfpin;
>  	struct ibmvfc_async_work *aw;
>  	struct ibmvfc_async_crq *crq =3D NULL;

[Severity: High]
Will extended FPIN events be incorrectly discarded here because of how the
target lookup is performed?

In the earlier part of ibmvfc_process_async_work(), node_name is read from
the subq structure:

ibmvfc_process_async_work() {
        ...
        if (is_subq) {
                subq =3D &aw->crq.subq;
                scsi_id =3D 0;
                wwpn =3D subq->wwpn;
                node_name =3D (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) ?=
 0 : subq->id.node_name;
        }
        ...
        tgt =3D ibmvfc_find_target(&vhost->scsi_scrqs.targets, scsi_id, wwp=
n, node_name);
        ...

Because the ibmvfc_async_subq_fpin structure overlaps with the id union in
ibmvfc_async_sub_crq, reading subq->id.node_name for extended FPINs will
extract garbage bytes from the fpin_data.event_threshold and event_data
fields.

Does this cause ibmvfc_find_target() to fail and drop valid events?

[ ... ]
>  	if (crq)
>  		fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> -	else
> -		fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +	else {
> +		sqfpin =3D (struct ibmvfc_async_subq_fpin *)subq;
> +		if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) =3D=3D 0) {

[Severity: High]
Can this lead to a NULL pointer dereference during driver removal?

When ibmvfc_remove() is called, the fpin_workq is destroyed:

ibmvfc_remove() {
        ...
        destroy_workqueue(vhost->fpin_workq);
        vhost->fpin_workq =3D NULL;
        ...
}

If an FPIN interrupt arrives before the CRQ queues are disabled, the
interrupt handler unconditionally queues work to it:

ibmvfc_handle_async() {
        ...
        case IBMVFC_AE_FPIN:
                aw =3D kzalloc(sizeof(struct ibmvfc_async_work), GFP_ATOMIC=
);
                if (aw) {
                        ...
                        queue_work(vhost->fpin_workq, &aw->async_work_s);
                ...
}

Should the interrupts be disabled prior to tearing down the workqueue, or
should we check if fpin_workq is NULL before queuing work?

> +			fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +		} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
[ ... ]
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index 444e6e6e1c390..ce938b93ecb45 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
[ ... ]
> @@ -225,9 +226,118 @@ static void ibmvfc_full_fpin_test(struct kunit *tes=
t)
>  			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
>  }
> =20
> +#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat, crq) {		\
> +	crq.valid =3D 0x80;					\
> +	crq.flags =3D IBMVFC_ASYNC_IS_FPIN_EXT;			\
> +	crq.link_state =3D IBMVFC_AE_LS_LINK_UP;			\
> +	crq.fpin_status =3D (fs);					\
> +	crq.event =3D cpu_to_be16(IBMVFC_AE_FPIN);		\
> +	crq.wwpn =3D cpu_to_be64(tgt->wwpn);			\
> +	crq.fpin_data.flags =3D IBMVFC_FPIN_EVENT_TYPE_VALID;	\
> +	crq.fpin_data.event_type =3D cpu_to_be16((ev));		\
> +	pre =3D READ_ONCE(tgt->rport->fpin_stats.stat);		\
> +	ibmvfc_handle_async((struct ibmvfc_crq *)&crq, vhost, true);	\
> +	msleep(1U);							\
> +	post =3D READ_ONCE(tgt->rport->fpin_stats.stat);		\
> +}

[Severity: Medium]
Is it expected that this macro only reads the pre and post statistics witho=
ut
asserting any changes? The KUNIT_EXPECT_* macros seem to be missing here
to validate the update.

Additionally, could relying on msleep(1U) for synchronization lead to flaky
test results when running under heavy load?

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
[ ... ]
> +	for (fs =3D IBMVFC_AE_FPIN_LINK_CONGESTED; fs <=3D IBMVFC_AE_FPIN_CONGE=
STION_CLEARED; fs++) {
> +		switch (fs) {
> +		case IBMVFC_AE_FPIN_PORT_CLEARED:
> +		case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
> +			crq[fs].valid =3D 0x80;
> +			crq[fs].flags =3D IBMVFC_ASYNC_IS_FPIN_EXT;
> +			crq[fs].link_state =3D IBMVFC_AE_LS_LINK_UP;
> +			crq[fs].fpin_status =3D fs;
> +			crq[fs].event =3D cpu_to_be16(IBMVFC_AE_FPIN);
> +			crq[fs].wwpn =3D cpu_to_be64(tgt->wwpn);
> +			crq[fs].fpin_data.flags =3D IBMVFC_FPIN_EVENT_TYPE_VALID;
> +			crq[fs].fpin_data.event_type =3D cpu_to_be16(FPIN_CONGN_CLEAR);
> +			pre =3D READ_ONCE(tgt->rport->fpin_stats.cn_clear);
> +			ibmvfc_handle_async((struct ibmvfc_crq *)&crq[fs], vhost, true);
> +			msleep(1U);
> +			post =3D READ_ONCE(tgt->rport->fpin_stats.cn_clear);
> +			break;

[Severity: Medium]
Similar to the macro above, this inline manual test logic is missing
assertions to verify the stats actually changed. Does it need a KUNIT_EXPEC=
T_*
call here?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260817-ibmvfc-fpi=
n-support-v6-0-62a2d525e70d@linux.ibm.com?part=3D8
