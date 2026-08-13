Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F10B3E7150
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 23:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786665380; cv=none; b=jKvCQQXDO2l4IKeGij5Hmwwhkuy6iRNnQ1PrvHOEKN35YzRs65TOL4flXkU/2WY9RAgN9Lli6DNwwbJxXiVyZ1kDiSKcq8SmbSVWVIVZfunWahzERsW9y++P6U78/YhKaNV7r/aUc28xGxJYDM1swk+Ul1icfTf4ijA2pNObgb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786665380; c=relaxed/simple;
	bh=1zzJ8dr9DJ+mgXnUGX7z0l/lUyHMf6dlgs2HP6sjOoA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d7YgfABEmJxwRXZR34nwy8/c4UOPCMLfInx4MnWCfI23wvYiAblUJb4U+oJBE82+9V4sDxn9BFFpAoo6JY2RrmUc2YhVLCZ6JCaNXEiZCXe55aeD81MRLRbS3yObCWyQgQc+PeZDROnT8KsQGCy7cQpkw8We+Cq5YQqP+o/N10I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IPq2eF7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IPq2eF7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856231F000E9;
	Thu, 13 Aug 2026 23:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786665378;
	bh=XDp6j5gESO84iIYLuBdEUj4hgKcOAK/VkhllQTop9UQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IPq2eF7Wrt8owWoM1UKuT5Is6BsmrJdW4vpnX/r3GvyrkTJ1mK3N1Yez1YvualFyi
	 6lP5rFORaUvoZJ1e3zLXG+B2L5h4Pu0UPQG2hCOLRR6PE4YwreiTsvRpXagy2sxyUH
	 +VXbA3SgaYXiLCBtPj0n9OXX/gWpYefZMTqQjrxQVUmBVVay1w5IeA6QVIL0y67MGq
	 vViB2paEJmggeaSXpuM5RY5xYZtjVMDWgUj5J4FP4WNbjJ84hzW1H/aGPRNv6sLeLc
	 5M/pBbij5dN4tlUd0tNRsFUEHFHXCCg1gv/uhz6Wa881V+sVyacVBvDfpyriGy+A/6
	 2cDlx4XRvl6EA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] ibmvfc: Add NOOP command support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt via B4 Relay" <devnull+davemarq.linux.ibm.com@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260408-ibmvfc-fpin-support-v1-2-52b06c464e03@linux.ibm.com>
References: <20260408-ibmvfc-fpin-support-v1-2-52b06c464e03@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 23:56:17 +0000
Message-Id: <20260813235618.856231F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing empty list check in `ibmvfc_noop_test` causes a kernel pan=
ic if no VFC hardware is present.
- [Medium] The KUnit test spuriously fails if the physical adapter or VIOS =
does not support the NOOP capability.
- [Low] Passing `NULL` to `cpu_to_be64()` triggers an incompatible integer-=
to-pointer conversion warning.
--

--- Patch [2]: [PATCH 2/5] ibmvfc: Add NOOP command support ---
commit e47751d42fb9d0e5cf4c7d82f8f6ec6ab8f6405c
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: Add NOOP command support

This commit adds support for the VFC_NOOP command to the ibmvfc driver. It
updates the capabilities sent during login to include NOOP support and
handles NOOP CRQs. It also adds a KUnit test for the new command.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> index 1c238896049f8..3359e4ebebe29 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c

[ ... ]

> @@ -79,8 +79,35 @@ static void ibmvfc_handle_fpin_event_test(struct kunit=
 *test)
>  	}
>  }
> =20
> +/**
> + * ibmvfc_noop_test - unit test for VFC_NOOP command
> + * @test: pointer to kunit structure
> + *
> + * Return: void
> + */
> +static void ibmvfc_noop_test(struct kunit *test)
> +{
> +	struct ibmvfc_host *vhost;
> +	struct list_head *queue;
> +	struct ibmvfc_crq crq;
> +	struct list_head *headp;
> +	LIST_HEAD(evtq);
> +
> +	headp =3D ibmvfc_get_headp();
> +	queue =3D headp->next;
> +	vhost =3D container_of(queue, struct ibmvfc_host, queue);

[Severity: High]
Does this code dereference a wild pointer if no VFC hardware is present?

Unlike the previous test which safely aborts using
KUNIT_ASSERT_PTR_NE(test, queue, headp), it looks like this test accesses
headp->next unconditionally. If the list is empty, such as when running in
a CI environment without physical or virtual IBMVFC adapters, could calcula=
ting
the vhost pointer and subsequently dereferencing it crash the test runner?

> +
> +	KUNIT_EXPECT_TRUE(test, ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_NOOP_CM=
D));

[Severity: Medium]
Will this test spuriously fail if the physical adapter or VIOS firmware is
older and does not support the NOOP capability? Should the test gracefully
skip instead of failing in environments without IBMVFC_SUPPORT_NOOP_CMD
support?

> +
> +	crq.valid =3D 0x80;
> +	crq.format =3D IBMVFC_VFC_NOOP;
> +	crq.ioba =3D cpu_to_be64(NULL);

[Severity: Low]
Does passing NULL to cpu_to_be64() trigger an incompatible integer-to-point=
er
conversion warning? NULL is a pointer type, but the byte-swapping macro exp=
ects
a 64-bit integer, which might break the build if CONFIG_WERROR is enabled.

> +	ibmvfc_handle_crq(&crq, vhost, &evtq);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260408-ibmvfc-fpi=
n-support-v1-0-52b06c464e03@linux.ibm.com?part=3D2
