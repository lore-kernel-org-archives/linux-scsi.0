Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088822D9EDB
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 06:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789106820; cv=none; b=Zyrf6Ynflb4wgHL+0Idgqh3DOVFz8V98mas8Z9LqMkQ/bADsSR2V8N3/gpl60cc38ry2fuZODtiemwXGQQs2VmSrRTkXL/p2L6Z3wpCtqVpkTeUshPFhNxllg+YBlJqXgAm30D0izvuSxBB3E4f7ndolonZ0K7zYOOqaY0rVqhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789106820; c=relaxed/simple;
	bh=f1tTgldxYU0H8sGZCt1Wo1p5HU6eCwTjw6b9erNINaU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CA/uVa8rTOXgXSlEL3Coil1Ea5mrDjZuzM/WNXNt5q+8e9pg77eSLhcQDUeM1ReAZuHxLCUmV8iaa5zahYCwrgu6V0pdLM5/Q5Gd2/jei8f0gC4B5W18Yd+bRuU+pfbmQRDFOgC5KI8NWRjUSnKwLIZhtzcNdXkH+3xug9uWhok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q7XyAPa8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q7XyAPa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FDC1F000FF;
	Fri, 11 Sep 2026 06:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789106818;
	bh=uz9R0kYXX4RBu6vgv8RzA9gIIVYywEpQOhH8ZnYhIyg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q7XyAPa8J0eNwsSr2Z2UmmYjCBbZtC/05gTudVhp38o0EpmuKTqf/paPRduo/YhlO
	 HolbT+YcugRu8UTMUPhASiCCMzZ9NTH6QgGZQ9bhkMD6AQYeIUBPq4rIwkq9Auo4xH
	 cuhuyvmltmFEAyDITET7STW+RCPnmxEivHiX57g2QeXjqJN2I4n3Ux73Alvcvv/Vfe
	 BxdBXx0uU3CnvdWF3yUKCBylDJTUeaHDb0jGUwlxUnRREUAj6ZNqlcgRLhZPgQobRC
	 OGyAIAEEZjMNKU8ixOfHc0KIn2YGTCT+2l3L2P1OCNl3XtXkAqyrsEFWTzgoeAc/TV
	 fTT70hpAg7BfQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 1/9] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911054832.1311668-2-tyreld@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
 <20260911054832.1311668-2-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 06:06:57 +0000
Message-Id: <20260911060658.68FDC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The KUnit test `ibmvfc_async_fpin_test` leaks references to the =
`Scsi_Host` and the `fc_rport` device on its successful completion path.
- [Medium] Unordered workqueue allows FPIN events to be processed concurren=
tly, causing data races in FC transport statistics and FPIN event reorderin=
g.
--

commit 79377784bc96c798354f5b0f5ce5007a8d857d16
Author: Dave Marquardt <davemarq@linux.ibm.com>
   =20
scsi: ibmvfc: add basic FPIN support
   =20
This commit implements support for a basic level of Fabric Performance Impa=
ct
Notifications (FPIN) in the ibmvfc driver. It adds an async event handler t=
hat
offloads FPIN processing to a dedicated workqueue and passes the converted
messages to the FC transport layer. A KUnit test module is also introduced =
to
validate the FPIN event handling and statistics updates.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -3547,6 +3547,56 @@ static void ibmvfc_process_async_work(struct work_=
struct *work)
[ ... ]
> +	if (fpin) {
> +		fc_host_fpin_rcv(tgt->vhost->host,
> +				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
> +				 (char *)fpin, 0);
> +		kfree(fpin);
> +	} else
   =20
[Severity: Medium]
Can the lockless modifications to fpin_stats in the FC transport layer here
cause data races and lost statistic counts?
   =20
Multiple FPIN events arriving rapidly from the adapter are queued to the
fpin_workq. Because the workqueue is created below as WQ_UNBOUND with
max_active=3D0, these events can be processed concurrently.
   =20
Furthermore, since FPIN events are stateful (e.g., congestion detected vs
cleared), could concurrent processing deliver events out of order to the
midlayer and userspace, leaving the system reflecting an incorrect state?

[ ... ]
> @@ -7135,6 +7135,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, cons=
t struct vio_device_id *id)
[ ... ]
> +	vhost->fpin_workq =3D alloc_workqueue("%s-fpin-workq-%u", WQ_UNBOUND, 0,
> +						 IBMVFC_NAME, shost->host_no);
   =20
[Severity: Medium]
By setting the max_active parameter to 0, which defaults to 256 concurrent
execution threads, does this allow the unordered processing that triggers
the data races mentioned above?
   =20
[ ... ]
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -0,0 +1,148 @@
[ ... ]
> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{
[ ... ]
> +	vhost =3D ibmvfc_get_first_vhost();
> +	if (!vhost)
[ ... ]
> +	rport =3D tgt->rport;
> +	get_device(&rport->dev);
[ ... ]
> +	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
> +			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
> +
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +}
   =20
[Severity: Medium]
Does this code leak the references to the Scsi_Host and the fc_rport device
on the successful completion path?
   =20
The setup code earlier in this test acquires references via
ibmvfc_get_first_vhost (which takes the host reference) and get_device, but
this success path fails to drop them before returning. This could potential=
ly
prevent the driver from unloading after running the KUnit test module.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911054832.1311=
668-1-tyreld@linux.ibm.com?part=3D1
