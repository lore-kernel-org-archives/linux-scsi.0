Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EE839CCFE
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 19:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791401636; cv=none; b=Ub83oTB8c6X5gUumCVKOt4pmeBguAagGFgEnXxdiRzS62TC417g62/9pL/fq6vjrZjpnm6CE/Aw48ivYAlcgRTc3QpsTfygfMvW+qQOGGgnlh7i0g7v7VKiJbTQZqACrPiVlmFCfoa2jI1JVwj6DVJDcJ9xym2//JYGVHnOni24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791401636; c=relaxed/simple;
	bh=7fjPBluK2fl/520unOzT5QFsyGcJxNmJZftBq4gi3xM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=n9W6AHeJMdmEi2CF8UH5iXyinY31Pf1xdNEV2RFk+cGoOnKj2VSnuswOJI14plINZPA8HEPlfMP6tV/22H0Py+t/XfQa3npDCnGARRNmU+/FGd6Z6m3+yLQmNVDawKICMkfV2kWUq3sJ+/H2l6s9MNJ90GQXcxr9qkBdCyExFpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Avgz9kh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Avgz9kh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B221F000FF;
	Wed,  7 Oct 2026 19:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791401635;
	bh=UY5R7lNlfq2RX0KUAzjPHnpA21y/UOzB28mNmeUO5pI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Avgz9kh3+dDfrtABWGchAEtL8LYH/0bpM4P4seIMcwM6ehU6+QpuA8+tT14/mn6Y1
	 +k3uPhuPouGVCXAotiyGN7GQ/muGcWLOJT10X4kmMtcgaBd1b25ZXrTp676vBjfG+X
	 bj9NUn/0JofQB/rCdkuU7m1bMfFaTKYxdGC/sZownjl92q3DOrbMslMa2CRqYxrYvU
	 GXrX94BT4ryhpnaXSV9+F2Bpvsly6uDP3KDDISbAam3rUJEmtAv5AD3qw/XkOHEs7+
	 zAknmXiIMiNDDv+wj3+6AMlR9kp4P5wAqRMc0G9rbfH65bw9qoNn3gnFgiWo3PuUqV
	 9E6i3TUY2eQbg==
Message-ID: <sashiko-outbox-163310@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v13 11/11] scsi: ibmvfc: handle extended FPIN events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261007-ibmvfc-fpin-support-v13-11-b816abfa4fcc@linux.ibm.com>
References: <20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com>
 <20261007-ibmvfc-fpin-support-v13-11-b816abfa4fcc@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 19:33:54 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: ibmvscsi: unused list head variable `evt_doneq` in test
--

commit 7276d45825dded3ce9d906eb91c3d06e314dc430
Author: Dave Marquardt <davemarq@linux.ibm.com>

    scsi: ibmvfc: handle extended FPIN events

This commit implements support for extended FPIN messages via the
asynchronous sub-queue. It introduces new capabilities and unit tests for
extended FPIN event handling.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index d2ef35e928eae..cc6e6d0b5f963 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> +/**
> + * ibmvfc_extended_fpin_test - unit test for extended FPIN events
> + * @test: pointer to kunit structure
> + *
> + * Return: void
> + */
> +static void ibmvfc_extended_fpin_test(struct kunit *test)
> +{
> +	enum ibmvfc_ae_fpin_status fs;
> +	struct ibmvfc_async_subq_fpin crq;
> +	struct ibmvfc_target *tgt;
> +	struct ibmvfc_host *vhost;
> +	struct fc_host_attrs *fc_host;
> +	struct fc_rport *rport;
> +	LIST_HEAD(evt_doneq);

[Severity: Low]
Is the evt_doneq list head needed? The variable is declared and initialized
at the beginning of ibmvfc_extended_fpin_test(), but it doesn't appear to be
used anywhere else in the test function body.

> +	unsigned long flags;
> +	u64 pre, post;
> +
> +	vhost =3D ibmvfc_get_first_vhost();

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-ibmvfc-fpi=
n-support-v13-0-b816abfa4fcc@linux.ibm.com?part=3D11
