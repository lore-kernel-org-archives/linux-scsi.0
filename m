Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB5F18787A
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789094560; cv=none; b=cn08NvYqIJx6G+VGVK+QbaqYOZyhnwoFBmIQ+/ndHxcDtuwszLu6ov/hjkFc2rxLTsUl3UcHLvOD6NG7bVWhVHgG5drJ7VG1jua7cm3P3v647n5WvhriN/fu2v9Rx5hI049OcJuTL/Km3uP6uyCLDeE/CniXDMos1EP5lJ0fD50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789094560; c=relaxed/simple;
	bh=y2fQZdkoqKuB7cmr3mRdqsTGDdu0Zx56l4kmhvLRN2o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=apQp+bU5kJszDQctyZV1NwfHJuu42ChSLK+nsF0S5ls3EjQmNmAk3dtgDZ4I14S/AfVXeWPFQB9l4utkumVO3XULzw5TImC/NSc21ScKC6MIQsvrPXhpEI3XvI1jIqbxBtc2bbeyB2nkh+o0uskJtU8MzRxWLSjeqo9max6InpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d0tAz7fp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d0tAz7fp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355391F000FF;
	Fri, 11 Sep 2026 02:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789094558;
	bh=tgTRPirYgZv1vBYbuTwmt8nlpPRUvlt9NRmUog9bvuY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d0tAz7fpiYhkvL3EIoEytT0jsK2H//zC2J681PZ0cha4W+ymL3XA0v0sNoTI+DVLv
	 Xj1zfezk9xbui/AWPSyPsS80dB1vMkpqd7f7ie58AwdRU6SzdSr/NtSR9ESY1DH1Rk
	 h3yRUxaA24hGaA2FAQd6Qu8dUn3nTw13P32/n1my6roPbTopT9F8gVfUqE0ocUhF0j
	 HWwC6u8WvUqbMKl6mYPi2GBHbDbMyliho05nUut8Mo4erywNImWZUPGpyvpXhMPJA3
	 7dxJxtL3NkW8bICInQRoXJvwNqGBJmnEitD5J1LaHEuKoqgyRJzYLuE95SO6qgEZT2
	 q8iQFidu3hV8Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 1/9] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911020817.1033789-1-tyreld@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260911020817.1033789-1-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:42:37 +0000
Message-Id: <20260911024238.355391F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] The target search function `ibmvfc_find_target` incorrectly uses a=
 logical OR (`||`) when checking if a target has a remote port, causing it =
to return NULL for all valid single-protocol targets and dropping all FPIN =
events.
- [Medium] The `ibmvfc_async_fpin_test` KUnit test leaks references to the =
`rport` device and the SCSI host upon successful completion.
- [Low] The KUnit tests rely on undeclared structures (`ibmvfc_async_crq_ev=
ent` and `ibmvfc_async_subq_fpin`), leading to immediate compilation failur=
e. This regression is fixed later in the patch series.
- [Low] Missing address-of operator '&' when passing 'vhost->host->host_loc=
k' to spinlock macros in `ibmvfc_process_async_work`, causing a compilation=
 error.
--

commit b979f5e231a6dc184c5b0656442cb752c9aa4313
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

Implement support for a basic level of Fabric Performance Impact
Notifications (FPIN) in the ibmvfc driver to enable monitoring of
fabric congestion and link integrity events.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -3522,6 +3526,23 @@ static struct fc_els_fpin *
>  static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target=
_list,
>  						__be64 scsi_id, __be64 wwpn,
>  						__be64 node_name)
>  {
>  	struct ibmvfc_target *tgt;
> =20
>  	list_for_each_entry(tgt, target_list, queue) {
>  		if (scsi_id && cpu_to_be64(tgt->scsi_id) !=3D scsi_id)
>  			continue;
>  		if (wwpn && cpu_to_be64(tgt->ids.port_name) !=3D wwpn)
>  			continue;
>  		if (node_name && cpu_to_be64(tgt->ids.node_name) !=3D node_name)
>  			continue;
>  		if (!tgt->rport || !tgt->nvme_remote_port)
>  			continue;

[Severity: High]
Does this skip all valid targets? A target is typically either a SCSI or NV=
Me
target, but not both simultaneously. Checking with a logical OR means we
continue the loop whenever either one is NULL, causing ibmvfc_find_target()
to always return NULL and subsequently drop all FPIN events.

>  		return tgt;
>  	}
> =20
>  	return NULL;
>  }
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
Can this compile successfully? The spinlock macros expect a pointer, but
vhost->host->host_lock is passed by value here, which will result in an
incompatible type compilation error. Should this use the address-of operator
(&vhost->host->host_lock)?

> +	tgt =3D ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
> +				 crq->wwpn, crq->node_name);
> +	if (!tgt) {
> +		/* Target not found in scsi_scrqs, search nvme_scrqs */
> +		tgt =3D ibmvfc_find_target(&vhost->nvme_scrqs.targets,
> +					 crq->scsi_id, crq->wwpn,
> +					 crq->node_name);
> +	}
> +
> +	if (tgt) {
> +		kref_get(&tgt->kref);
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);

[Severity: Low]
This is also missing the address-of operator and will cause a compilation
error.

> +	} else {
> +		spin_unlock_irqrestore(vhost->host->host_lock, flags);

[Severity: Low]
This is also missing the address-of operator.

> +		dev_err_ratelimited(vhost->dev, "Invalid target for FPIN\n");
> +		goto free;
> +	}
> +
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
Does this test rely on an undeclared structure? The struct
ibmvfc_async_crq_event doesn't appear to be declared yet in this patch,
which breaks the build if KUnit tests are enabled. I noticed this gets
resolved in a subsequent commit, but it breaks the build here.

> +	enum ibmvfc_ae_fpin_status fs;
> +	struct fc_host_attrs *fc_host;
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_rport *rport;
> +	unsigned long flags;
[ ... ]
> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
> +
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +}

[Severity: Medium]
Does this test leak device references? Early in ibmvfc_async_fpin_test(),
scsi_host_get() and get_device(&rport->dev) are called to acquire reference=
s,
but they don't seem to have corresponding scsi_host_put(vhost->host) and
put_device(&rport->dev) cleanup calls at the end of the test function.

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
Similar to the ibmvfc_async_crq_event array above, this instantiates an arr=
ay
of struct ibmvfc_async_subq_fpin which is currently undeclared in this
patchset, causing a build failure.

> +	struct ibmvfc_async_subq_fpin
> +		crqcn[IBMVFC_AE_FPIN_PORT_CONGESTED][FPIN_CONGN_DEVICE_SPEC+1] =3D {};

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D1
