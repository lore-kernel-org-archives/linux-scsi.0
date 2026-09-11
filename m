Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2983E0220
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094335; cv=none; b=l85xlTe6m8ntjX+FhwAVAemUfNVaHE+Y+6QVFscIjiaN1CA9OKMbHPPzBfDEiqd7Gesb8UWbNlHlEoWSZlEjXI9UMYy6zEvk23dZ3pc9gPqnhFlmByA0NcgRIzn5K7w2wQVxLaLiObYqIygh/SGDf86Y42QqLEn9ahpGxEj+sxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094335; c=relaxed/simple;
	bh=7Qpfdcw/7q6aRcnfw6Eq3RWB6z+VUEyCq5/CmnVRhdg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LgQoAnyTt0oSPbWzSVCD7a3S2DF5wcIr3AfJTcarFxXm6LdKTuDqzVqqXwvSvmRYWM7zm4v1r4+c5mwy5PhaFJe8xwyxaPj85HZCG7hLV2c3FVGhHd9UFl6g2fR/QNDBsKFhVhBDToluiqNQM/56XD2Mu/mGkwDyq1mL3Dio6Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Exi1ttTP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Exi1ttTP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C190D1F000FF;
	Fri, 11 Sep 2026 02:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789094333;
	bh=09YAb03qwADuII5PVtYruKDEKZqCaM9DEbUnqsr2A/k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Exi1ttTPD/eLXNSFYyq5vgZaDH7iUOMCh2hWBGfhkwDxmEmeF56HO8FdB9JDZviMc
	 IBHw+jZ0pvGd+FniyEqHciR8vQL4n+bbYyraIQICDLN3X67rM9IHHLSkWrnaMKhiVO
	 +VMYc4jObfm+V8BRkqxHY66YVva0EL+FGmbhnFkdnxoZYYKA8fyXHQfVX+Q485gc6L
	 akVS6p84tYUbSkxremcH7b5b7ZGI6yIrIUsguS97ym9UPTSBx6WTe9ErfrFCK/iAQu
	 EJVVRzCH+h2qAqckcLinC4o3+/JgkJE0t+lC3+MnLEeJhSv5v6nWzCkNU6lNHaxRax
	 0AwtTcC1YwG3Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 1/9] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911021910.1038128-2-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
 <20260911021910.1038128-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:38:53 +0000
Message-Id: <20260911023853.C190D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] ibmvfc_find_target incorrectly uses a logical OR condition, causin=
g it to skip all valid targets and unconditionally return NULL.
- [Medium] Reference count leak of the SCSI host and remote port devices in=
 the `ibmvfc_async_fpin_test` KUnit test.
- [Low] KUnit tests use undefined structures, macros, and incompatible func=
tion signatures from a future patch, breaking the build.
- [Low] Missing '&' operator when acquiring/releasing the host_lock, causin=
g compilation to fail.
--

commit e20d55240604f534a630e6df915a24fb9e9b543b
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

Implement support for a basic level of Fabric Performance Impact
Notifications (FPIN) in the ibmvfc driver to enable monitoring of
fabric congestion and link integrity events.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index aa7ae81df41b1..5259a80958ce1 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -3411,6 +3450,25 @@ static struct fc_els_fpin *
> +static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target=
_list,
> +						__be64 scsi_id, __be64 wwpn,
> +						__be64 node_name)
> +{
> +	struct ibmvfc_target *tgt;
> +
> +	list_for_each_entry(tgt, target_list, queue) {
> +		if (scsi_id && cpu_to_be64(tgt->scsi_id) !=3D scsi_id)
> +			continue;
> +		if (wwpn && cpu_to_be64(tgt->ids.port_name) !=3D wwpn)
> +			continue;
> +		if (node_name && cpu_to_be64(tgt->ids.node_name) !=3D node_name)
> +			continue;
> +		if (!tgt->rport || !tgt->nvme_remote_port)
> +			continue;

[Severity: High]
Should this check use a logical AND (&&) instead of a logical OR (||)?

Since the target lists are separated into SCSI and NVMe, it seems every
target will have either rport or nvme_remote_port set to NULL. Using
a logical OR here evaluates to true for every target, causing the loop
to unconditionally skip all valid targets and return NULL.

> +		return tgt;
> +	}
> +
> +	return NULL;
> +}

[ ... ]

> +static void ibmvfc_process_async_work(struct work_struct *work)
> +{
> +	struct ibmvfc_async_work *aw;
> +	struct ibmvfc_async_crq *crq;
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_els_fpin *fpin;
> +	unsigned long flags;
> +
> +	aw =3D container_of_const(work, struct ibmvfc_async_work, async_work_s);
> +	vhost =3D aw->vhost;
> +	crq =3D &aw->crq;
> +
> +	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
> +		goto free;
> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);

[Severity: Low]
Does this line cause a build failure due to a missing '&' operator?

In struct Scsi_Host, host_lock is an inline spinlock_t rather than a
pointer. Passing it by value to spin_lock_irqsave() causes the compiler
to fail with an incompatible type error.

Should this be written as:
	spin_lock_irqsave(&vhost->host->host_lock, flags);

> +	tgt =3D ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
> +				 crq->wwpn, crq->node_name);

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..80e7f8e0fd700
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -0,0 +1,408 @@

[ ... ]

> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{
> +	u64 post[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
> +	u64 pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
> +	struct ibmvfc_async_crq_event ae[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1]=
 =3D {
> +		[0 ... IBMVFC_AE_FPIN_CONGESTION_CLEARED] =3D { .type =3D IBMVFC_ASYNC=
_CRQ_MAIN },
> +	};

[Severity: Low]
Do these undefined types and macros break the build when compiling with
CONFIG_SCSI_IBMVFC_KUNIT_TEST=3Dy?

struct ibmvfc_async_crq_event and IBMVFC_ASYNC_CRQ_MAIN are not defined
in this commit, which prevents the tests from compiling. It appears they
might have leaked from a subsequent patch in the series.

> +	enum ibmvfc_ae_fpin_status fs;
> +	struct fc_host_attrs *fc_host;
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_rport *rport;
> +	unsigned long flags;
> +
> +	vhost =3D ibmvfc_get_first_vhost();
> +	if (!vhost)
> +		kunit_skip(test, "No ibmvfc devices available");
> +
> +	spin_lock_irqsave(vhost->host->host_lock, flags);

[Severity: Low]
This also seems to be missing the '&' operator before vhost->host->host_loc=
k,
resulting in the same build failure mentioned above.

> +	if (vhost->scsi_scrqs.num_targets < 1) {

[ ... ]

> +		ae[fs].async_crq.node_name =3D cpu_to_be64(tgt->ids.node_name);
> +		ibmvfc_handle_async(&ae[fs], vhost);

[Severity: Low]
Is there a signature mismatch here?

ibmvfc_handle_async() is defined to take a struct ibmvfc_async_crq pointer
as its first argument, but the test passes a struct ibmvfc_async_crq_event
pointer instead.

> +		ae[fs].async_crq.valid =3D 0;
> +		wmb(); /* ensure valid bit clear is visible before checking stats */
> +	}

[ ... ]

> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
> +
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +}

[Severity: Medium]
Are we leaking device and host references in the successful exit path?

The test acquires references via ibmvfc_get_first_vhost() and
get_device(&rport->dev) during setup, but unlike the other tests in this
file (e.g., ibmvfc_full_fpin_test), it does not call put_device(&rport->dev)
and scsi_host_put(vhost->host) before returning. Leaking these references
can prevent module unloading and device cleanup.

> +
> +/**
> + * ibmvfc_full_fpin_test - unit test for IBMVFC_AE_FPIN parts of ibmvfc_=
handle_async

[ ... ]

> +static void ibmvfc_extended_fpin_test(struct kunit *test)
> +{
> +	enum ibmvfc_ae_fpin_status fs;
> +	struct ibmvfc_async_subq_fpin crq[IBMVFC_AE_FPIN_CONGESTION_CLEARED+1] =
=3D {};

[Severity: Low]
Does this undefined structure break the build?

struct ibmvfc_async_subq_fpin is not defined in this commit, causing a
compilation error.

> +	struct ibmvfc_async_subq_fpin
> +		crqcn[IBMVFC_AE_FPIN_PORT_CONGESTED][FPIN_CONGN_DEVICE_SPEC+1] =3D {};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911021910.1038=
128-1-tyreld@linux.ibm.com?part=3D1
