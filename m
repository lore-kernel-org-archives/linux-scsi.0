Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793032020;
	b=hX5Otbx6JiPK3A5B2oj4tbtyS0+o46Z8EnpHKnACvoHO0oQjnI9wHSxJWIDXZ3F2Nr5I
	 RG+GQw7uAEKzBQaAhMn0ChMfDcP0WpGH57R5XAr9pyeDGcrG1W5HrFNw72+sLuk3OgSzi
	 Vz98UCqevRNIgMA8VzG/ZiFpCCji4KWGoX5pl9lR0eYgZBE4F0noHycGv8/06vHIpYgu7
	 PIlGLQZfgf3u7EeI26wx5oThgwzYaqtW13dTtFJ/r1eQkbvlljatkQ0ygqxhV5g7+6Vp1
	 InJHro/vWE96YfYpsclo4BtyYOS0WAV2GqNeaZIFr0C394a5U0/pUvdm3X19lrxXNMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793032020;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=NYTi6c6OP7XdCnbtAK2aZteembyS8mE23/N2ueqon9Y=;
	b=qEIalb+UNnbG4x/qh9WEi0K+Z3dZu33RkxXkaCBrFaY4jp3KDWHyPSMVhRgLRmIaEc7x
	 ic9dSG0GLdLf+tvTCWIzOBbEHOBF5E+Fgp5eJSGWKN2od09ED8bjr2cBzoEs18Hjgrnp4
	 OfoS61xuXy7AqCsRANU/CK6z5fv5P9v5gwwuz+JxA8yAV/rJEWXh49oBjDHPQ0YjFEMCK
	 ZSqK1AlW4EbcJn+51yb6tKqJ4bo3zBUW5TFTSCwyrgP9ppuuI4DUGbnZ37ohZCugRBNYM
	 mkRglHyFOIiXVn+wWs29dhIC2eNyvE/AqWJOaRhSDjxNY6u1082QFphA5bG7OeNe7nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhlDVDm2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A7F606A331
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VhlDVDm2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A151F01825;
	Mon, 26 Oct 2026 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793032019;
	bh=NYTi6c6OP7XdCnbtAK2aZteembyS8mE23/N2ueqon9Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VhlDVDm2bHngkm+ifyRyKbvZneFyzUiopynzQ2RkzABO6QL7Dp8yTHy99sTRsoMsN
	 hu0ULHMtE1/7IrhN4o9yOXZuxJqO2B/Rz0XZH1aDxI1ys1UgNuFLzQeTGNT1m1saKu
	 8ZHbmwHclRBg3RNsseSfmlpKfKcbUyiV9eWw9ZjHjLmKUCzdC/sM+jKUPoEknqVwTa
	 uWzIH+Rf3lrLzdgTLSbob6errUMHKTLjVCPIkO+Tu5B2/sbAt4ajSMZErTd9jEXRD0
	 hor0HTtGqKX4bRctMxZ8l71e2Mx8p+LrZM8ApuCUPGYNhLcMlS1IT4ogMGbBjW/iVX
	 9wgRM1s7t/Cbg==
Message-ID: <sashiko-outbox-185517@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 03/12] scsi: ibmvfc: fix potential NULL pointer
 dereference on failed queue allocation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261026-ibmvfc-fpin-support-v16-3-a900aa657ed5@linux.ibm.com>
References: <20261026-ibmvfc-fpin-support-v16-0-a900aa657ed5@linux.ibm.com>
 <20261026-ibmvfc-fpin-support-v16-3-a900aa657ed5@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 16:26:58 +0000
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
- [Low] scsi: ibmvfc: build failure when CONFIG_KUNIT is disabled
--

commit e6767e190b474e7d3a6e33d2ed96de8dbb05ff1a
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: fix potential NULL pointer dereference on failed queue alloca=
tion

This commit guards ibmvfc_deregister_channel() against freeing an
unregistered sub-CRQ or clearing an unallocated message buffer, and adds a
KUnit test suite to verify the guard conditions.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 145d559041f12..f0502d7482105 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6450,11 +6450,23 @@ static int ibmvfc_register_channel(struct ibmvfc_=
host *vhost,
>  		hcall_rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address, sc=
rq->cookie);
>  	} while (hcall_rc =3D=3D H_BUSY || H_IS_LONG_BUSY(hcall_rc));
>  reg_failed:
> +	scrq->cookie =3D 0;
>  	LEAVE;
>  	return rc;
>  }
> =20
> -static void ibmvfc_deregister_channel(struct ibmvfc_host *vhost,
> +/**
> + * ibmvfc_deregister_channel - Deregister a sub-CRQ channel with the hyp=
ervisor
> + * @vhost:	ibmvfc host struct
> + * @channels:	ibmvfc channels struct containing the sub-CRQ array
> + * @index:	index into the sub-CRQ array
> + *
> + * Frees the IRQ, disposes of the IRQ mapping, and calls H_FREE_SUB_CRQ =
to
> + * release the sub-CRQ with the hypervisor. On success the queue message
> + * buffer is zeroed and the current index is reset. If H_FREE_SUB_CRQ fa=
ils,
> + * an error is logged but the channel resources are cleaned up regardles=
s.
> + */
> +VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhos=
t,
>  				      struct ibmvfc_channels *channels,
>  				      int index)
>  {
> @@ -6471,20 +6483,28 @@ static void ibmvfc_deregister_channel(struct ibmv=
fc_host *vhost,
>  		scrq->irq =3D 0;
>  	}
> =20
> -	do {
> -		rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
> -					scrq->cookie);
> -	} while (rc =3D=3D H_BUSY || H_IS_LONG_BUSY(rc));
> +	if (scrq->cookie) {
> +		do {
> +			rc =3D plpar_hcall_norets(H_FREE_SUB_CRQ, vdev->unit_address,
> +						scrq->cookie);
> +		} while (rc =3D=3D H_BUSY || H_IS_LONG_BUSY(rc));
> =20
> -	if (rc)
> -		dev_err(dev, "Failed to free sub-crq[%d]: rc=3D%ld\n", index, rc);
> +		if (rc)
> +			dev_err(dev, "Failed to free protocol (%d) sub-crq[%d]: rc=3D%ld\n",
> +				channels->protocol, index, rc);
> +		else
> +			scrq->cookie =3D 0;
> +	}
> =20
>  	/* Clean out the queue */
> -	memset(scrq->msgs.crq, 0, PAGE_SIZE);
> -	scrq->cur =3D 0;
> +	if (scrq->msgs.handle) {
> +		memset(scrq->msgs.crq, 0, PAGE_SIZE);
> +		scrq->cur =3D 0;
> +	}
> =20
>  	LEAVE;
>  }
> +EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel);

[ ... ]

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index ca80ceffe53a5..421ce8bc3ea33 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h
> @@ -1088,4 +1088,12 @@ static inline struct ibmvfc_host *ibmvfc_channels_=
to_vhost(struct ibmvfc_channel
>  #define ibmvfc_remove_trace_file(kobj, attr) do { } while (0)
>  #endif
> =20
> +#if IS_ENABLED(CONFIG_KUNIT)
> +#include <kunit/visibility.h>
> +VISIBLE_IF_KUNIT void ibmvfc_deregister_channel(struct ibmvfc_host *vhos=
t,
> +						struct ibmvfc_channels *channels,
> +						int index);
> +VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void);
> +#endif

[Severity: Low]
Does this break the build when CONFIG_SCSI_IBMVFC is enabled and CONFIG_KUN=
IT
is disabled?

In drivers/scsi/ibmvscsi/ibmvfc-core.c, ibmvfc_deregister_channel() uses
VISIBLE_IF_KUNIT and EXPORT_SYMBOL_IF_KUNIT(ibmvfc_deregister_channel)
outside of any CONFIG_KUNIT guard.

However, drivers/scsi/ibmvscsi/ibmvfc.h only includes <kunit/visibility.h>
when CONFIG_KUNIT is enabled, so the fallback definitions in
include/kunit/visibility.h:

#else
    #define VISIBLE_IF_KUNIT static
    #define EXPORT_SYMBOL_IF_KUNIT(symbol)
#endif

are never pulled in when CONFIG_KUNIT is disabled, causing compilation of
drivers/scsi/ibmvscsi/ibmvfc-core.c to fail due to unknown macros.

A later commit in the series, commit 1bc41de0e60f ("scsi: ibmvfc: add basic
FPIN support"), adds an unconditional #include <kunit/visibility.h> to
drivers/scsi/ibmvscsi/ibmvfc-core.c, though leaving this commit and commit
1b37c48a1902 ("scsi: ibmvfc: add link state to host struct") unbuildable wi=
th
CONFIG_KUNIT=3Dn during bisection.

Should <kunit/visibility.h> be included unconditionally in
drivers/scsi/ibmvscsi/ibmvfc.h (or drivers/scsi/ibmvscsi/ibmvfc-core.c) in
this commit?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026-ibmvfc-fpi=
n-support-v16-0-a900aa657ed5@linux.ibm.com?part=3D3
