Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E0829B8E1;
	Wed, 14 Oct 2026 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791976176; cv=none; b=COJPnrl7qq0mZA7bwax8CAKK7cRV9WVStMhbgZHDiPy2x38NZ6R58y24np+kUHQsADjmYlw1+M6sEoNdTwEsRRL5Tg6H69nxyoptWRAnGUFBbLntLKM85ra1RIrqYaTsxtsatJTR98KCv37TaeK6NuQFbLEpWNHRI6LQvUVmjrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791976176; c=relaxed/simple;
	bh=0S3g3q/Mg9tOj3Xw44fL5bfqq4XsBJtH96jqCevX4JU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fkDBMsIAli4n4TcheHLg/i+FJoAOYzjTbGvtLGHOqkCAHq1gD/UDoImELj/b5NJssX/6Ad2vacNaZy4kjsO2ULRKCt/QH0Mb+L0hj9Y8IDaHHE7f0ZxovWHfT/AVTK6N3yDYkLI9eTXoOcYWnUG/XXbpXE27I7xuyL2QpcDj7l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3ZP4QCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3ZP4QCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30471F000FF;
	Wed, 14 Oct 2026 11:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791976175;
	bh=7eQyul8MJ1lQVTV1k//ovzXLDeiWRCjY1X6LwVD42Cs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=m3ZP4QCGF/MWVau+3A0Svf4T09ymggeDLISS2074GRFeSBMt+i2+fisUQrUnVMNKm
	 2lFs+EtYokFFaLoCZLZLZDPhS+6x923QU9SI0EPqCWvhIqllv/3uXViZkOHUrF/DCl
	 Gcq8ca1QgGM32nrxmCn2eMzljcmGkk0dqfzGMEYidyWbx9LlcMSjM4a/K809EjWKwK
	 tArIVm7KOk5i+zYD1OnhVCz+jnhdvdqZoUQQLHkDOMaN3Lfus6RCNYxdia8LDkpE8Y
	 32geeSzgL3nx3eCoQOmqCfa/HYTQItVFi0dAv3ndYxFuyLpU6QKD4OH3kfxRZDMfSM
	 xtdSFsM3L23CQ==
Message-ID: <sashiko-outbox-171177@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] usb: uas: validate status URB length before parsing
 the IU
Reply-To: sashiko-reviews@lists.linux.dev
To: "Olivier Kaloudoff" <olivier.kaloudoff@gmail.com>, linux-usb@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014105526.16392-1-olivier.kaloudoff@gmail.com>
References: <20261013221937.41490-1-olivier.kaloudoff@gmail.com>
 <20261014105526.16392-1-olivier.kaloudoff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 11:09:34 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] usb/uas: short STATUS IUs (4-15 bytes) falsely complete as SUCCESS
--

commit 1a208f3daab26d0bf253bfe97e68d1636d90a96c
Author: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>

usb: uas: validate status URB length before parsing the IU

The commit attempts to fix log spam caused by parsing a short or empty stat=
us
URB transfer. It does so by bailing out if actual_length is smaller than
sizeof(struct iu), which is only 4 bytes long.

> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 8655edbd66b16..b5d3071d86c84 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -315,6 +315,13 @@ static void uas_stat_cmplt(struct urb *urb)
>  		goto bail;
>  	}
> =20
> +	if (urb->actual_length < sizeof(struct iu)) {

[Severity: High]
Does this allow 4-15 byte packets to proceed to type-specific processing?

Because sizeof(struct iu) is only 4 bytes, a packet of 4-15 bytes with
iu_id =3D=3D IU_ID_STATUS (3) passes this check.

If that occurs, uas_stat_cmplt() delegates to uas_sense():

drivers/usb/storage/uas.c:uas_sense() {
...
	if (urb->actual_length > 16) {
...
	}

	cmnd->result =3D sense_iu->status;
}

Since the transfer buffer is zero-allocated and not completely overwritten =
by
the short transfer, sense_iu->status at offset 6 reads as 0 (SAM_STAT_GOOD).

Does this result in the command falsely completing as SUCCESS and hiding
device errors from the SCSI block layer?

> +		dev_err_ratelimited(&urb->dev->dev,
> +			"stat urb: short transfer (%u bytes)\n",
> +			urb->actual_length);
> +		goto bail;
> +	}
> +
>  	idx =3D be16_to_cpup(&iu->tag) - 1;
> =20
>  	spin_lock_irqsave(&devinfo->lock, flags);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014105526.1639=
2-1-olivier.kaloudoff@gmail.com?part=3D1
