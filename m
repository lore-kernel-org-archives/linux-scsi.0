Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C4A2773CA
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2026 19:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783712455; cv=none; b=qeJQLoiiVoUTlEWvkek6HaCugIHcbDU8FjboiB/bbApz5tKuNoW4inr3/hPtrbhnE4UqXGPA19njUUlJPJC6pJByQ0R4aqROYJki0gYO2Y4Z2PzE+Qtvq2Wf/Co8HQ3N9hxF/v3+pjrMKEKEMgyKIXTR6my7MCk+V7iC9djfG14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783712455; c=relaxed/simple;
	bh=0ya36IiGpDgzFkLKeghVQ3KkjrlCKPfUfNT1Xq5gWAc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZgvqPOGnEIQrq+Ge2hS4nP2/Kv547cTENDMIvFhpVpo+MN0JRwSTJWhvxnnc8bAMdkw4cv9vdpTojireJ9dkwYsgj8BZqVje7robXKwi3z0PN9DXkBhQ10tCEWq1egtBA/K2LuK/iJVFt4q0I9iLUX48bv+q9kKUHgQoUpVsbug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RNGCG6xL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RNGCG6xL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A501F000E9;
	Fri, 10 Jul 2026 19:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783712454;
	bh=TA1tneF3XpG5FQYaisAz7Thvxxr1G1qJs5xwVYBJacU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RNGCG6xLolZk3bJWeCpqfntz/t6nlpKYZelK2U39vDBAQS5uF6yz/HrtP1ulViuVV
	 eTl28RdkwRUNil+81HTFM41fIKKkyVma9spDgzGHOt+1OcMPQdmAz6Vg8DVM8n51M+
	 ovgEDP0e8cIXuVJQVBEr0Tox1zX/OV0UKHJzG5Af5lhZcJPY10wu70f+epwRuZFwvp
	 ZHHbvljwMrD6riui11tMFJM98hFu6aMBbgnGSQfmlKxK1FNgcJPEe4HkB8CfzazSDD
	 FoH54CMlOSlMzJKejxV2SzT86izvT1C1lPmiAsfZ+Ysl7/KoCuzrs9FY0EaW+uuhVE
	 7kptrzetJCXEQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 8/8] ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260710-ibmvfc-fpin-support-v4-8-ef031ac19520@linux.ibm.com>
References: <20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com>
 <20260710-ibmvfc-fpin-support-v4-8-ef031ac19520@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 19:40:53 +0000
Message-Id: <20260710194054.22A501F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Extended FPIN events are incorrectly dropped because `node_name` i=
s populated with garbage data from overlapping `fpin_data` union fields, ca=
using target lookup to fail.
- [High] The async workqueue `fpin_workq` is not properly flushed or destro=
yed before the `vhost` memory is freed during driver removal, leading to a =
Use-After-Free.
- [Medium] The newly added KUnit tests for extended FPIN events omit assert=
ions and use zero-initialized data that masks the `node_name` extraction bu=
g.
- [Medium] KUnit tests use an arbitrary 1ms sleep to wait for asynchronous =
work queues to complete, causing test flakiness.
--

--- Patch [8]: [PATCH v4 8/8] ibmvfc: handle extended FPIN events ---
commit a18cc405b1579697dec2f0dfe75048a6e10f4167
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: handle extended FPIN events

Implement support for extended FPIN messages via the asynchronous sub-queue.
This adds parsing for detailed fabric events, updates capability
advertisement, and includes KUnit validation for the new functionality.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index eb786ac242745..b131a4a3041b7 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -3372,12 +3373,48 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_subq=
 *ibmvfc_fpin)
>  					  cpu_to_be32(1));
>  }
> =20
> +/**
> + * ibmvfc_ext_fpin_to_desc(): allocate and populate a struct fc_els_fpin=
 struct

[ ... ]

>  /**
>   * ibmvfc_process_async_work - Process IBMVFC_AE_FPIN async CRQ from wor=
k queue
>   * @work: pointer to work_struct
>   */
>  static void ibmvfc_process_async_work(struct work_struct *work)
>  {
> +	struct ibmvfc_async_subq_fpin *sqfpin;
>  	struct ibmvfc_target *tgt, *next;

[Severity: High]
Does this leave the work queue active during driver removal?

In ibmvfc_remove(), the driver drops the last reference to the SCSI host via
scsi_host_put(vhost->host), which frees the shost and the embedded vhost
structure. However, fpin_workq is allocated via devm_alloc_workqueue(). The
devres cleanup runs after ibmvfc_remove() returns.

If destroy_workqueue() drains pending work during devm teardown, it could
execute ibmvfc_process_async_work(), which accesses the freed vhost memory
when taking the host lock: spin_lock_irqsave(vhost->host->host_lock, flags).

Could we flush or destroy the work queue explicitly in ibmvfc_remove() befo=
re
releasing the SCSI host?

[ ... ]

> @@ -3439,8 +3476,20 @@ static void ibmvfc_process_async_work(struct work_=
struct *work)
> =20
>  	if (crq)
>  		fpin =3D ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
> -	else
> -		fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +	else {
> +		sqfpin =3D (struct ibmvfc_async_subq_fpin *)subq;

[Severity: High]
Does this drop extended FPIN events by matching on garbage data?

For an extended FPIN event, struct ibmvfc_async_subq and
struct ibmvfc_async_subq_fpin share memory layout. Earlier in
ibmvfc_process_async_work(), the code extracts:

    wwpn =3D subq->wwpn;
    node_name =3D subq->id.node_name;

The subq->id.node_name overlaps with fpin_data.event_threshold and
fpin_data.event_data.event_count. Since these data values are typically
non-zero, node_name is populated with garbage. This causes the target
lookup to fail because it attempts to match the garbage value:

    if (node_name && cpu_to_be64(tgt->ids.node_name) !=3D node_name)
        continue;

Could this skip valid targets and unintentionally discard the events?

> +		if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) =3D=3D 0) {
> +			fpin =3D ibmvfc_full_fpin_to_desc(subq);
> +		} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
> +			dev_err_ratelimited(vhost->dev,

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index 86c1f6daca586..2f43916b43a5a 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> @@ -62,8 +63,6 @@ static void ibmvfc_async_fpin_test(struct kunit *test)
>  		msleep(1U);
>  	}
> =20
> -	msleep(500U);

[Severity: Medium]
Is a 1ms delay sufficient to prevent racy tests?

The test calls ibmvfc_handle_async(), which queues work on vhost->fpin_work=
q.
Relying on msleep(1U) to wait for the worker thread to finish before reading
updated statistics is inherently racy. If the work is not scheduled within =
1ms
under heavy load, the test may read stale values and fail.

Should this deterministically synchronize by calling flush_workqueue() inst=
ead?

>  	post[IBMVFC_AE_FPIN_LINK_CONGESTED] =3D READ_ONCE(fc_host->fpin_stats.c=
n_device_specific);
>  	post[IBMVFC_AE_FPIN_PORT_CONGESTED] =3D READ_ONCE(tgt->rport->fpin_stat=
s.cn);
>  	post[IBMVFC_AE_FPIN_PORT_CLEARED] =3D READ_ONCE(tgt->rport->fpin_stats.=
cn_clear);

[ ... ]

> @@ -116,8 +115,117 @@ static void ibmvfc_async_fpin_test(struct kunit *te=
st)
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
Are there missing test assertions here?

The IBMVFC_TEST_FPIN_EXT macro assigns pre and post statistic values but la=
cks
any KUNIT_EXPECT_* assertions to actually verify the outcomes.

Additionally, because the dummy crq structures are zero-initialized in
ibmvfc_extended_fpin_test(), event_threshold and event_count are 0. This
coincidentally masks the overlapping node_name extraction bug mentioned
earlier because node_name evaluates to 0, which bypasses the broken target
lookup check and allows the test to artificially succeed.

Could assertions be added, and non-zero dummy data be used to thoroughly te=
st
this path?

Also, similar to ibmvfc_async_fpin_test(), the msleep(1U) used here might
lead to flaky test failures if the workqueue runs slower than expected.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710-ibmvfc-fpi=
n-support-v4-0-ef031ac19520@linux.ibm.com?part=3D8
