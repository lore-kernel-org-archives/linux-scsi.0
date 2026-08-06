Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F253DDAFE
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 20:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786049574; cv=none; b=d+Dn6as/uhk9Vrqa9xPF1PiE8KZbkEqF5l3m/1yMHSKJjc3H6X5s2AOb6AWuNhXHECc87wl0ENdrGyiyMo5ySvow92hvtjEQGj0D+AvcFvUXVKytmP8DCaAozJQjGBNYCvO/gkZd66mL+eam9P7CrBesFBb4MHf8qQNmlPgE6I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786049574; c=relaxed/simple;
	bh=n/wIy2nxnMqzYLnpNq8JK9g48YIjTJqWNz0JmJ97P8g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W14kwnnMLLhA0ScAN8XcsJqcG8oAlWGHpGNOrY+wrUpQeBGI21p7MeX+5Csh9P/5cNn2r19KznqANfQ3E6QwgRIf/8jErbTbaB6gZcljlvzMpwKJWG+k7NkzZNTwYvTUtTPlGQtzohU8Kh81UK8w6n68bP9g2LYl4CyFzDuqqic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2dorQO8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2dorQO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560CE1F000E9;
	Thu,  6 Aug 2026 20:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786049573;
	bh=+2GJvPExFJ/4U/ahgLG3ud8wRYZ4xphAOoEXA0YrnyA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O2dorQO8UTKTvb7rXy7osA8D6DtBRHBV4zPLa2E2E7AyKfLFOTmAXWMEBy3DUWt01
	 Y0kY5kRJjDih4CJE+wb2yXJ2fyS9AjSa32SmhEkW/ROAqJSj98G+Saj1oj1oeJZe4b
	 Y5epRRRoDV/uSDo1G5C9crqs5ml09xKBYX4I1xUg/rGeEOReopLtB+vepRZoeZclqZ
	 pKcWCD1n8tRsq0yKTDr/+8sMVbQlWXqSMVqKLqSX51t4N7wWSmIVwVLniEV6uy0P18
	 poQTeSFOUIUfZLxGybAmVP/JTmS5QMVID4ZV+gDQg/rXDUUROtQognakbleIIheNt1
	 1HWWETxUyvEQQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/5] scsi: elx: efct: free the HIO when the WQE
 cannot be built
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806202205.345326-3-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806202205.345326-3-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 20:52:52 +0000
Message-Id: <20260806205253.560CE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The Hardware I/O context (hio) is leaked on every successful compl=
etion of ELS, CT, and BLS commands.
--

--- Patch [2]: [PATCH v2 2/5] scsi: elx: efct: free the HIO when the WQE ca=
nnot be built ---
commit d739587d3893fac37f827b9d5a082304c53cf476
Author: Ali Ahmet Memis <ali@iusegentoo.com>
Date:   Thu Aug 6 20:22:02 2026 +0000

    scsi: elx: efct: free the HIO when the WQE cannot be built
   =20
    efct_els_hw_srrs_send() and efct_hw_bls_send() allocate an HIO, ask sli4
    to build a WQE into it, and give up when that fails without putting the
    HIO back:

[ ... ]

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index 15c37ff1d52e4..6cc48fa3e656a 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -2609,6 +2609,7 @@ efct_hw_bls_send(struct efct *efct, u32 type, struc=
t sli_bls_params *bls_params,
>  	if (sli_xmit_bls_rsp64_wqe(&hw->sli, hio->wqe.wqebuf,
>  				   &bls, bls_params)) {
>  		efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE error\n");
> +		efct_hw_io_free(hw, hio);
>  		return -EIO;
>  	}
> =20

[Severity: High]
This is a pre-existing issue, but does this code also leak the hio on the
success path?

Looking at the completion callback for BLS commands, efct_bls_send_rjt_cb()
receives the hio but completely ignores it:

drivers/scsi/elx/efct/efct_scsi.c:efct_bls_send_rjt_cb() {
    struct efct_io *io =3D app;

    efct_scsi_io_free(io);
    return 0;
}

Because the generic hardware completion handler efct_hw_wq_process_io() doe=
sn't
free the hio either, doesn't this result in the hio being leaked on every
successful completion?

If the pool of hardware IO contexts exhausts, won't efct_hw_io_alloc() fail=
 for
all subsequent requests, breaking Fibre Channel discovery, ELS, and BLS
operations?

> @@ -2820,24 +2821,27 @@ efct_els_hw_srrs_send(struct efc *efc, struct efc=
_disc_io *io)
>  		rc =3D -EIO;
>  	}
> =20
> -	if (rc =3D=3D 0) {
> -		hio->xbusy =3D true;
> +	if (rc) {
> +		efct_hw_io_free(hw, hio);
> +		return rc;
> +	}

[Severity: High]
This is a pre-existing issue, but does this function suffer from the same l=
eak
on the success path?

The ELS completion callback receives the hio but also ignores it:

drivers/scsi/elx/efct/efct_hw.c:efct_els_ssrs_send_cb() {
    struct efc_disc_io *io =3D arg;

    efc_disc_io_complete(io, length, status, ext_status);
    return 0;
}

Should the completion callbacks be responsible for calling efct_hw_io_free(=
), or
should that be handled by the generic caller?

> -		/*
> -		 * Add IO to active io wqe list before submitting, in case the
> -		 * wcqe processing preempts this thread.
> -		 */
> -		hio->wq->use_count++;
> -		rc =3D efct_hw_wq_write(hio->wq, &hio->wqe);
> -		if (rc >=3D 0) {
> -			/* non-negative return is success */
> -			rc =3D 0;
> -		} else {
> -			/* failed to write wqe, remove from active wqe list */
> -			efc_log_err(hw->os,
> -				    "sli_queue_write failed: %d\n", rc);
> -			hio->xbusy =3D false;
> -		}
> +	hio->xbusy =3D true;
> +
> +	/*
> +	 * Add IO to active io wqe list before submitting, in case the
> +	 * wcqe processing preempts this thread.
> +	 */
> +	hio->wq->use_count++;
> +	rc =3D efct_hw_wq_write(hio->wq, &hio->wqe);
> +	if (rc >=3D 0) {
> +		/* non-negative return is success */
> +		rc =3D 0;
> +	} else {
> +		/* failed to write wqe, remove from active wqe list */
> +		efc_log_err(hw->os,
> +			    "sli_queue_write failed: %d\n", rc);
> +		hio->xbusy =3D false;
>  	}
> =20
>  	return rc;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D2
