Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3F3DC4CC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 19:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788981809; cv=none; b=bFc7EzNiI2JrwJBq6n2r9IOq/y2v8XKMqlZNnAqNcJhk/3mT7LEzhPC4fdX4lt5f4RVCq1tJ1r0p/Y+1/Q+67xaC1NpUT5DOlKwTQhHLKBNjqZf83rLhnM0QbB0DFWZQZEaE979qEqvJapFYmd/EXOcpKl8AUCmHLF9omCqtK5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788981809; c=relaxed/simple;
	bh=OVFLYpkPDUlVrpHg9S9ZslItTD/A0R3uijslmVQY4hI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fM1hPOXQpvsWdiD4QbIQAMPvmPAWHq/UB5WlGPsy9ORbEanwJ8B8Tw6wdij8A09nvaTZ7pIQDeaNvJRN9MGEFzzx1w6aOkeiorHcwE7IvCNwkBQ+2heeBKaznHyw1ZtxHsr5h7GnASMY9k+LO9ac1nAFovCLXOmN2VNUMG517zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I9TKL1so; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I9TKL1so"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5891C1F000FF;
	Wed,  9 Sep 2026 19:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788981807;
	bh=HmFSJCDmZZVzVXkJo7is39Uo1tL5BTsXV8vggXt+vnU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I9TKL1soAyHDnwsJsjer5m5a+Kb1MmHwI14D5yLiW9dfVPO1jPMg4US5Tg67GTuFq
	 Ve8CCw4SMte2PWFuwuJGrfboMuJYM9yfWu41L8CuLsIDePnyoLoPXVcgV0l2iBFryD
	 CbMsjEc4acFjToXH8IB+HtKm7UFGJao4Zr34PBUyujS2DZ5Q4KCNXr6FnOCq7JWNRc
	 dNRoy6d8aA370unsNgQJXEPcFv0k50sxbOxPzS2u4WZVkfdDrJsJe5utJbQGlq6Xgi
	 tsPELpz7Em+n9YQz1QFBOVXuRjrPAUt9FMfRupWS9Fy8oMjm3vMGHYchFg0TuFgp/z
	 DPrGV+0XQymeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 4/9] scsi: ibmvfc: extend async event handlers for
 async sub-CRQ events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-4-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
 <20260909-ibmvfc-fpin-support-v8-4-b27183b055af@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 19:23:26 +0000
Message-Id: <20260909192327.5891C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The commit message describes replacing a bare union and boolean =
flag that do not exist in the code being patched.
--

commit c9246c7ca28755d85919ddcd76858ac31cbc3ab8
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend async event handlers for async sub-CRQ events

This commit refactors async event handling to support both traditional async
CRQs and new asynchronous sub-queue CRQs. It introduces a new tagged union,
struct ibmvfc_async_crq_event, and updates handlers to process events based
on the new type discriminator.

> Replace the ibmvfc_async_work bare union and is_subq bool with a
> single event field of this type.

[Severity: Medium]
Does this description match the baseline code?=20

The commit message mentions replacing a bare union and an is_subq bool, but
looking at the baseline struct ibmvfc_async_work, it only contained a stand=
ard
crq field without any union or boolean flag.=20

Could this portion of the commit message be referring to an intermediate,
unsubmitted version of the code rather than the actual baseline being patch=
ed?

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index a8a063d99564d..6fce7a4922bb9 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h

[ ... ]

> @@ -786,9 +786,22 @@ struct ibmvfc_async_sub_crq {
>  	} id;
>  } __packed __aligned(8);
> =20
> +enum ibmvfc_async_crq_type {
> +	IBMVFC_ASYNC_CRQ_MAIN =3D 0,
> +	IBMVFC_ASYNC_CRQ_SUB,
> +};
> +
> +struct ibmvfc_async_crq_event {
> +	enum ibmvfc_async_crq_type type;
> +	union {
> +		struct ibmvfc_async_crq async_crq;
> +		struct ibmvfc_async_sub_crq subq;
> +	};
> +};
> +
>  struct ibmvfc_async_work {
>  	struct ibmvfc_host *vhost;
> -	struct ibmvfc_async_crq crq;
> +	struct ibmvfc_async_crq_event event;
>  	struct work_struct async_work_s;
>  };
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-ibmvfc-fpi=
n-support-v8-0-b27183b055af@linux.ibm.com?part=3D4
