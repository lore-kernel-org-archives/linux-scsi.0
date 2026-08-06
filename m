Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D721449480B
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 19:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786045484; cv=none; b=hyh0p/RcSd01rTShNbsaoHMTn2ObO2mXb2Fldcj3fnIs38duPkQk0opmgbxw7qKIglToRwAo7EsrXqD2NMmYzeE/FgrMCc8/0r701DnfhdrG7DP8gX0i2ufyYxfBxdm9VvwDexZ6IEt2exZyc/dQmo5VaBXBp4ZwG5AsjKN9npo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786045484; c=relaxed/simple;
	bh=dWXFW6hUQpThHCTEGejsuSa4z99gA7sQP8KdomygV3w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aBQJS/iVvVmbyCPG90axYeoiSsiUYYM5sXm68UpZm1Az+2trxCRDx4WWDO3U/UfaezVDya2W+SuFrkIAe53prpm4qMOaqRJtsjCizdvBVxaikT69HawPEXWyHsiOr75p/yUXfWCCcEQHGuqoqtNWAjnsk0wtNvMWldcNi6r7JA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4l5b+vL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4l5b+vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9F71F00A3A;
	Thu,  6 Aug 2026 19:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786045482;
	bh=gblS9wibMPcvx1HvZxruRWt9zOI4O8mYPKowVI1cg9c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U4l5b+vL8Y/G4tQUQNsac+kviZoNuMl+PLQleeHIYJELnjx1WaevKuNLxn+H+YCUA
	 MhVvdGvYH/4ynkJehcLwbfE6atKQrda+gxiTPbyq1xv5kK7jjHBkSxLV0TwiGKz7in
	 SZzgueWYjCzR7DkpioSLxZIveOL4aT6T923ttWJ3GRDUjXYktzGSlqlH6lCw6JHjdR
	 OzNOhpMN442m5919/VsL1KEc/PGUqpis2TLkkZUDBzEydkR64AXYQs/gjpaRtgRxUA
	 X69PWqFdWDAT3B+0n1V8yW0oaMwZv0nGDnioRRZ2vhmMyCweby3p/vEostGY1Qg+4J
	 ixzHPSRu+mDdg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] scsi: elx: efct: check the HW state before
 allocating an HIO
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ali Ahmet Memis" <ali@iusegentoo.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806192345.328621-2-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
 <20260806192345.328621-2-ali@iusegentoo.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 19:44:41 +0000
Message-Id: <20260806194442.3E9F71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Hardware I/O object (hio) is permanently leaked on WQE submission =
failure.
- [High] Hardware I/O object (HIO) is permanently leaked on successful ELS =
and BLS completions.
--

--- Patch [1]: [PATCH 1/5] scsi: elx: efct: check the HW state before alloc=
ating an HIO ---
commit 9f7986d6f2e47353fa2d9861b16b7f4d623a7b71
Author: Ali Ahmet Memis <ali@iusegentoo.com>

scsi: elx: efct: check the HW state before allocating an HIO

This commit moves the hardware state check in efct_els_hw_srrs_send to
happen before allocating a hardware I/O (HIO) object. This prevents an
HIO object leak that previously occurred when the hardware state was not
active.

> diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct=
_hw.c
> index b79c6a7ea7912..15c37ff1d52e4 100644
> --- a/drivers/scsi/elx/efct/efct_hw.c
> +++ b/drivers/scsi/elx/efct/efct_hw.c
> @@ -2706,18 +2706,18 @@ efct_els_hw_srrs_send(struct efc *efc, struct efc=
_disc_io *io)
>  	u32 sge0_flags;
>  	u32 sge1_flags;
> =20
> -	hio =3D efct_hw_io_alloc(hw);
> -	if (!hio) {
> -		pr_err("HIO alloc failed\n");
> -		return -EIO;
> -	}
> -
>  	if (hw->state !=3D EFCT_HW_STATE_ACTIVE) {
>  		efc_log_debug(hw->os,
>  			      "cannot send SRRS, HW state=3D%d\n", hw->state);
>  		return -EIO;
>  	}
> =20
> +	hio =3D efct_hw_io_alloc(hw);
> +	if (!hio) {
> +		pr_err("HIO alloc failed\n");
> +		return -EIO;
> +	}
> +

[Severity: High]
This isn't a bug introduced by this patch, but does this function leak the
newly allocated hio object if WQE submission fails further down?

If efct_hw_wq_write() fails at the end of efct_els_hw_srrs_send():

	hio->wq->use_count++;
	rc =3D efct_hw_wq_write(hio->wq, &hio->wqe);
	if (rc >=3D 0) {
		/* non-negative return is success */
		rc =3D 0;
	} else {
		/* failed to write wqe, remove from active wqe list */
		efc_log_err(hw->os,
			    "sli_queue_write failed: %d\n", rc);
		hio->xbusy =3D false;
	}

	return rc;

The function returns the error but it doesn't appear to call
efct_hw_io_free(hw, hio), leaving the hio object stranded. Could this
eventually exhaust the adapter's hardware IO pool during transient queue
full conditions?

This same pattern appears to exist in efct_hw_bls_send() when either
sli_xmit_bls_rsp64_wqe() or efct_hw_wq_write() fails.

>  	hio->done =3D efct_els_ssrs_send_cb;

[Severity: High]
This is also a pre-existing issue, but is the hio object leaked on
successful completions as well?

Looking at the callback assigned here:

drivers/scsi/elx/efct/efct_hw.c:efct_els_ssrs_send_cb() {
	struct efc_disc_io *io =3D arg;

	efc_disc_io_complete(io, length, status, ext_status);
	return 0;
}

The callback executes the completion handler but doesn't drop the
reference to the passed hio object.=20

The overarching WQE completion handler efct_hw_wq_process_io() also seems
to drop the WQE and call done(), but leaves the hio pointer allocated.

Are we missing an efct_hw_io_free(hw, hio) call on the success paths
for ELS and BLS completions?

>  	hio->arg  =3D io;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806192345.3286=
21-1-ali@iusegentoo.com?part=3D1
