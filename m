Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448968;
	b=rCnrE3xuts+IlCXF8X/QQHS7MkmaIp5LshgiTqA1RVEA5LklNBM2S2KCu/yfZA/UMgP8
	 9Wf1YR6kGBgvSHsiMA7hXZ42IYBrM/RHjlOCsI4fIgG877SRVCsKPopNERWElFfB1aLxx
	 Wy+EOLKXFOiEP5K1uSwKiqXHYq3bK8ippubpR5Ds4KwoGF6FQMfDJ45JqgSsxOF8ABbxz
	 UUWIg5fDx0nBJEznqJgB/7meVbi7ilsXlbf9IkR6/62Nk31xpl57LuzcUbmw3PH7fswN9
	 UQquuQYR3bffQ2omdtzGKEA4afR7xIJGGSwQ650E59qNH4ejGhvR40D9W/BzRlGtDvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448968;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=xV2UVHfXlx/HRVoAphySgJRys3jdO5J+/U4pzUx99+w=;
	b=p1mQ5bkN/TJJ45ZUqjsRMpsLlulkWhqk8HlMFjpTt0sSw2HU16Nxqn8tkzLpBLuVwWHR
	 6cw9h9KhXjSNj7BIIRN2+fzbdTrOhgFJ5E/lj2i/Erbmabmtg43vylHjGErkR1tcajpkA
	 5DuMgzFV4poRa9Ocda+bQM1Jkrxzyg3HRfHhAZSocEdicmFWc/ln7rd3muR4CN+eo5g2x
	 Ys3nXhP0XaIuJ4972a+WXo61U1+qYeEpN/FLs3H2LZ+Sl7fsofSXKS/t9LxfJHiuo/hkO
	 f+MBphr2Uup++7530n5TudhDGS8ONHa6VcQchrOH+Aei09NJ59zPjbj9xad5D8elZkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mun318D9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60575606A319
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mun318D9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99C41F000C4;
	Mon, 19 Oct 2026 22:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792448968;
	bh=xV2UVHfXlx/HRVoAphySgJRys3jdO5J+/U4pzUx99+w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mun318D9+5G3R7F3ry98iOEUuO5h3FLX7HdHlaHYzLQ8cZPKwuHkfr8iY195PIhDM
	 8OCSFWqBCqULS7bufTyVfDrtY6PPe7SG161H72PJA+ZbcM+3Cyviz6gw4s+5wocO23
	 QxZrkUWBItKeFSet9n01SKBLh8tb+ZCfZWP8Eg1Q1wY3cCMt25P/gLWNAPj6AdFUvy
	 D+WQBmt4vfCAdzbsV6+XA8ZyFu6qfVrJ+nPiJc5cETBbJDPN1rqR9gyAbAFnTR0nv+
	 Z2cGrWg/vHKoXjYCBd1Xjd2260jjiPmkHGgX2KLmwI0rgiDj4lx5QTzQ6PXGkcKltH
	 IDGRnup7SBGDA==
Message-ID: <sashiko-outbox-178320@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 03/11] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261019-ibmvfc-fpin-support-v15-3-a858726e178a@linux.ibm.com>
References: <20261019-ibmvfc-fpin-support-v15-0-a858726e178a@linux.ibm.com>
 <20261019-ibmvfc-fpin-support-v15-3-a858726e178a@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 22:29:27 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: scrq->cookie not cleared on H_REG_SUB_CRQ failure =
in ibmvfc_register_channel()
--

commit 09a8086d40f44887491493f172cd7dd44285d18d
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix potential NULL pointer dereference on failed queue alloca=
tion

This commit guards ibmvfc_deregister_channel() against calling H_FREE_SUB_C=
RQ
on an unregistered sub-CRQ queue and against zeroing an unallocated message
buffer. It also adds a KUnit test suite to verify the deregistration guards.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 145d559041f12..0fe6b6f4260ba 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6449,12 +6449,24 @@ static int ibmvfc_register_channel(struct ibmvfc_=
host *vhost,
>  	do {
>  		hcall_rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, sc=
rq->cookie);
>  	} while (hcall_rc =3D=3D H_BUSY || H_IS_LONG_BUSY(hcall_rc));
> +	scrq->cookie =3D 0;
>  reg_failed:
>  	LEAVE;
>  	return rc;
>  }

[Severity: Medium]
Should scrq->cookie =3D 0 be placed after the reg_failed label (or should
h_reg_sub_crq() avoid writing *cookie on error)?

Looking at h_reg_sub_crq() in drivers/scsi/ibmvscsi/ibmvfc-core.c, it
unconditionally writes retbuf[0] into *cookie regardless of the return code:

static long h_reg_sub_crq(unsigned long unit_address, unsigned long ioba,
			  unsigned long length, unsigned long *cookie,
			  unsigned long *irq)
{
	unsigned long retbuf[PLPAR_HCALL_BUFSIZE];
	long rc;

	rc =3D plpar_hcall(H_REG_SUB_CRQ, retbuf, unit_address, ioba, length);
	*cookie =3D retbuf[0];
	*irq =3D retbuf[1];

	return rc;
}

In plpar_hcall() (arch/powerpc/platforms/pseries/hvCall.S), r5 (unit_addres=
s)
is moved into r4 before HVSC and r4 is unconditionally stored into retbuf[0]
after HVSC, even when HVSC returns an error such as H_PARAMETER or H_RESOUR=
CE.

When h_reg_sub_crq() fails in ibmvfc_register_channel():

	rc =3D h_reg_sub_crq(vdev->unit_address, scrq->msg_token, PAGE_SIZE,
			   &scrq->cookie, &scrq->hw_irq);

	/* H_CLOSED indicates successful register, but no CRQ partner */
	if (rc && rc !=3D H_CLOSED) {
		dev_warn(dev, "Error registering sub-crq: %d\n", rc);
		if (rc =3D=3D H_PARAMETER)
			dev_warn_once(dev, "Firmware may not support MQ\n");
		goto reg_failed;
	}

jumping to reg_failed skips scrq->cookie =3D 0, leaving a non-zero value in
scrq->cookie. If ibmvfc_deregister_channel() is later called on this queue
during reset or teardown (via ibmvfc_dereg_sub_crqs()), won't the new
if (scrq->cookie) check evaluate to true and issue H_FREE_SUB_CRQ on a queue
that failed registration?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-ibmvfc-fpi=
n-support-v15-0-a858726e178a@linux.ibm.com?part=3D3
