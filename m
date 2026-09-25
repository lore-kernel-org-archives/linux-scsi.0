Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA525397930
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 05:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790312734; cv=none; b=faEfv9B2NFsR5RgcbFIFcUZNjYAxoZj+g5uQs2cMmbQ3umZOttVCuxWXacO8LzJdMG5ye4mAqP8OuYog/HLH2tgsq2ftiMaVtYMFO9nVbT9gYCcV3YMMaiNV/qaM/7AYRT3oEUQ8LCx3aUgf/zHxuh01GiWK7SdBecHrnLEOP70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790312734; c=relaxed/simple;
	bh=umDjRv89+lb/7a0fpqwsSUGPZBmgX13QCxatnprwcho=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=q2fNwFnAyKftEq4xD/w/3k3Z8bOWMqVl9hG58qr9qemAv5VGc4aqj7C2HFlbKgR+PapN21EuSHo2Ja220k2LGeanSNQ+QP1QS3HrxL3l/Ys5O4CDNrzChmGIDtqZMruRhu4KzSyP3yqUrEBzyvG4TPT6DMiqs53ugzffo40KpIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiyLLXqQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiyLLXqQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCBC1F000FF;
	Fri, 25 Sep 2026 05:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790312733;
	bh=U6j98hyupmi/Xk4Ph+rjfTRmE55n4kR0pKlpdLava1g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=YiyLLXqQQWmxZHAr0xolbfumEnGNJTZSYQKb7W0g5k5IrpalUUdNkDw7Jbr4Muu+Y
	 JddhiN3ZQ71v4Qfr+L4kWDjH96yYs8P8rEE9Telm8D5AibPGZoDX1nAs4eBfUlcdQ3
	 QDM8W0SpUHBC6Ns2Ux6N+4P6awQYtLKDsKn2HhmCp2DnmcKwlcpVSFkgoJoaTMYal3
	 nY32ArDNjxzvPBTYfX6+IlkL5QbpwFSUbJdab8PV0EdisCENq/mevhHJLHILKA2zeQ
	 lnJaviAX6wxKHXAasrqgaA+fjKq6TuwtpyBN4OEoMdeL6OoO1hxUQlq+bK6phUZi05
	 2mooMk20PFlCw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 09/11] scsi: ibmvfc: extend channel reg/dereg
 helpers for async sub-CRQ
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260925044900.414340-10-tyreld@linux.ibm.com>
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
 <20260925044900.414340-10-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 05:05:32 +0000
Message-Id: <20260925050533.1FCBC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: ibmvfc: kernel-doc incorrectly instructs passing negative ind=
ex
--

commit 6798e7ba7398cb1f91e10a6432ae9b3192653f37
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ

ibmvfc_register_channel() and ibmvfc_deregister_channel() previously only
handled SCSI and NVMe sub-CRQ channels identified by the channel protocol.
The async sub-CRQ had no registration path through these helpers, requiring
separate handling. This commit adds IBMVFC_PROTO_ASYNC to extend both
functions to handle the async sub-CRQ.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b354bfb1a9b67..b967c82e99430 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -6812,6 +6812,21 @@ static int ibmvfc_init_crq(struct ibmvfc_host *vho=
st)
>  	return retrc;
>  }
> =20
> +/**
> + * ibmvfc_register_channel - Register a sub-CRQ channel with the hypervi=
sor
> + * @vhost:	ibmvfc host struct
> + * @channels:	ibmvfc channels struct containing the channel array and pr=
otocol
> + * @index:	index into the channels array for the queue to register, or
> + *		a negative value to register the async sub-CRQ
> + *
> + * Register a sub-CRQ with the hypervisor via h_reg_sub_crq, map its har=
dware
> + * IRQ to a Linux IRQ, and bind an interrupt handler to it. The handler =
is
> + * selected based on the channel protocol (SCSI or NVMe) for normal queu=
es, or
> + * set to the async sub-CRQ handler when @index is negative.
> + *
> + * Return value:
> + *	0 on success / non-zero on failure
> + **/
>  static int ibmvfc_register_channel(struct ibmvfc_host *vhost,
>  				   struct ibmvfc_channels *channels,
>  				   int index)

[Severity: Low]
Does this kernel-doc correctly document the expected index values?

The documentation explicitly directs the caller to pass a negative index for
async sub-CRQs, but ibmvfc_register_channel() begins with an unconditional
array access:

    struct ibmvfc_queue *scrq =3D &channels->scrqs[index];

If a developer follows the documentation and passes a negative index, would=
n't
this result in an immediate out-of-bounds array access? Currently, callers
pass 0 for the async sub-CRQ, so this crash isn't reachable today, but the
comment could mislead future users.

[ ... ]
> @@ -6883,6 +6905,18 @@ static int ibmvfc_register_channel(struct ibmvfc_h=
ost *vhost,
>  	return rc;
>  }
> =20
> +/**
> + * ibmvfc_deregister_channel - Deregister a sub-CRQ channel with the hyp=
ervisor
> + * @vhost:	ibmvfc host struct
> + * @channels:	ibmvfc channels struct containing the sub-CRQ array
> + * @index:	index into the sub-CRQ array, or -1 to deregister the
> + *		asynchronous sub-CRQ
> + *
> + * Frees the IRQ, disposes of the IRQ mapping, and calls H_FREE_SUB_CRQ =
to
> + * release the sub-CRQ with the hypervisor. On success the queue message
> + * buffer is zeroed and the current index is reset. If H_FREE_SUB_CRQ fa=
ils,
> + * an error is logged but the channel resources are cleaned up regardles=
s.
> + */
>  static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
>  				      struct ibmvfc_channels *channels,
>  				      int index)

[Severity: Low]
Is this the same documentation issue as above?

The kernel-doc for ibmvfc_deregister_channel() directs using -1 for the
asynchronous sub-CRQ, but similar to ibmvfc_register_channel(), it accesses
the array unconditionally:

    struct ibmvfc_queue *scrq =3D &channels->scrqs[index];

Could this lead to an out-of-bounds array access if someone passes -1 as
documented?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925044900.4143=
40-1-tyreld@linux.ibm.com?part=3D9
