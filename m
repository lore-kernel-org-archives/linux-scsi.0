Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1F047668A
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790120238; cv=none; b=l9VoS50RQEsXEa6VglKgks/G6bMcJYLyC7mwTPXyvQ6tYJQNYqW9WKukTELpdAkCHxY1aFgmV/JA3sAnzEcy3GvQPvxviUraxjmBoWB/MR0yXUn8JzQf+8yENn1eEA4+GeSJYJF/04GLuS9R4FrQbBSQVgSENOfEdehlajNFtWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790120238; c=relaxed/simple;
	bh=igqsapnhL/N4oKq3hWJ8cvdQ0bqcB+W8IPOk0p0s38o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BKAAyTt4M5emooDcD10XDGOL8palg8TytzndRSasJ7In36DC+dPT7QsI3oJpy5TDEaj+54xsnjEYiaQ9eRGI/9vlUZgrh06PUD9eQNHYUjsfj6yeqbcth8vIFZeGrzPe6+NRr2SXBrBkvRIeAf2oz4jTFG6+SmiDq5O/us5vhms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y8zgi9bv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y8zgi9bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE7B1F000FF;
	Tue, 22 Sep 2026 23:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790120225;
	bh=fQTZIMe0zA4MqzsWtSXEH9Z1ehjWL6yvOEt84KkXvRs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y8zgi9bvkr+t5TNEUcMqyTbyOnWuH96iwPUntuD/snfDZKlslqfXgv1nVU4/giXwT
	 WAdao3vdRxIwqW46WOF1dSV4h+4WBAD4A06gRJ5hihimH7vZmCSyyYhJwDyMKWKbMF
	 N61UKXvGqDoJphDLB81WYDXtDCFKNezArnLYIGjcCjCz+DGvugDatL7bO6cqD7LJ+F
	 rJT1A2Pt8cBDI2t7vZMPWsIewP/1anKRT/KGkfAbSGjV7vklF6UoH8C7NYUHoNsC1D
	 vqw1AYgpUHeOOr6Pr+to4WHL+SLdAWX4VHJ4rq4AUxIG6PGvzHBLqrdApHAF19vENT
	 2p1Mbmf7A8HwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/7] scsi: scsi_debug: Split resp_read_dt0()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <bcc45fcd315feaec1b033496444573723a5f081b.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
 <bcc45fcd315feaec1b033496444573723a5f081b.1790119506.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 23:37:04 +0000
Message-Id: <20260922233705.4DE7B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi_debug: early return of byte count in resp_read_dt0 fails IO
--

commit 17ea9421189072b59343f9ec94fa5ff956adb17f
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Split resp_read_dt0()

This commit splits the `resp_read_dt0()` function to eliminate conditional
locking and prepare the code for context analysis.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index fcfb49df9ee17..ac3b9bfa7e634 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4577,6 +4577,42 @@ static int resp_read_tape(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
>  	return 0;
>  }
> =20
> +static int __resp_read_dt0(struct scsi_cmnd *scp, struct sdeb_store_info=
 *sip,
> +			   u64 lba, u32 num, u32 ei_lba)
> +{
> +	u8 *cmd =3D scp->cmnd;
> +
> +	/* DIX + T10 DIF */
> +	if (unlikely(sdebug_dix && scsi_prot_sg_count(scp))) {
> +		switch (prot_verify_read(scp, lba, num, ei_lba)) {

[ ... ]

> +		}
> +	}
> +
> +	return do_device_access(sip, scp, 0, lba, num, 0, false, false);
> +}

[Severity: High]
Does returning the output of do_device_access() here cause successful reads
to return their byte count instead of zero?

Looking at do_device_access(), it returns the positive number of bytes copi=
ed
on success. Before this patch, the positive byte count was returned into
'ret', but it was ignored for successful reads.

>  static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *=
devip)
>  {
>  	bool check_prot;
> @@ -4668,46 +4703,17 @@ static int resp_read_dt0(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)
>  	}
> =20
>  	if (sdebug_dev_is_zoned(devip) ||
> -	    (sdebug_dix && scsi_prot_sg_count(scp)))  {
> +	    (sdebug_dix && scsi_prot_sg_count(scp))) {
>  		sdeb_meta_read_lock(sip);
> -		meta_data_locked =3D true;
> +		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba);
> +		sdeb_meta_read_unlock(sip);
> +	} else {
> +		ret =3D __resp_read_dt0(scp, sip, lba, num, ei_lba);
>  	}
> =20
> +	if (ret > 0)
> +		return ret;

[Severity: High]
Could this new check inadvertently cause successful IOs to fail?

Since __resp_read_dt0() returns the positive byte count on success
(e.g., 65536 bytes), this condition will evaluate to true. The function
will then return 65536 (0x10000) directly to the caller, bypassing
scsi_set_resid().

The SCSI midlayer appears to interpret a positive return value like 0x10000
as a SCSI result where the host byte is DID_NO_CONNECT (1), leading to a
complete failure of the IO operation.

(I verified that this issue remains present in the final commit of the seri=
es,
and the subsequent patch for writes also introduces the identical behavior =
in
resp_write_dt0().)

> =20
> -	ret =3D do_device_access(sip, scp, 0, lba, num, 0, false, false);
> -	if (meta_data_locked)
> -		sdeb_meta_read_unlock(sip);
>  	if (unlikely(ret =3D=3D -1))
>  		return DID_ERROR << 16;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1790119506.gi=
t.bvanassche@acm.org?part=3D4
