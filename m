Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB96D2BF3E2
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 18:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781290636; cv=none; b=IuMwoeNJKRdlCpguSSrK5tiNZZpHlkhEBRqMc48GmF5R/jTKzYz4TZ2oSiyB0k6ktsu6Mn/Z0WwYZiU3TQ+IVK3JCSVQoFlLcW7HdPHPrxaPXLZCpBHVrfhK0SWUn76zqAf7Fj5myZILmQ4X0anxfnbFMrwJFG+0KoipuPu27+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781290636; c=relaxed/simple;
	bh=d7YIvbm63YwsgIdXzA1lSWQylbgt0ZgxShPracUwAZo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nhnqJma46SC4oeQqn2pJzv8odTww8skuN8LITUJtcCY1/kH7hsytBwQXqPqFMc1vQRizdvufbUmd/J5OyTJnXDqZWtrJf93LSCe18timXk+BLq5IBxg0pLE3K4XDjFqSqiOS7ieydorwFNoOwtZQS8dA5W7lSb23854GusIL9ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6Tujmx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6Tujmx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174651F000E9;
	Fri, 12 Jun 2026 18:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781290634;
	bh=wHgkO9VgCVj0Vjxfx6Ep084nMc5aRN1UaCDt4tt1pgs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X6Tujmx6+XF7Ie2CTOkeKm61zW0xCxdfEX2U/86pLxGk3FoZemOjdc8s3JZs7dfRG
	 iQBYiIfQTnfjBFLfcWXBmPKE3OQXy6AzTySxv1vWzprIvF3ofQyoNgNviCf9Z7NO4I
	 bRndUKTC1YDnrU73U9uYCwRFQSnkazV0F8yG7peZHBXB+rhozXrurq3L5RQh/qBWDJ
	 2i2DPAxPM0VXGAVaKD0Sxn9rMKzmgyZ0zAA7yGSRDktcD8u0O6d71sQdTO0MZK3TFH
	 FyIeI3ZTN/vuQxKD1QRiRFDmHkFc6HhV+2zC0+iD+LdJXMgXz1AdP8ds8OmhSbEOsv
	 tSqKz0NayNLpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/13] scsi: fnic: Use fnic_num for non-SCSI
 identifiers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-3-kartilak@cisco.com>
References: <20260612180918.8554-3-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 18:57:13 +0000
Message-Id: <20260612185714.174651F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Unconditionally using `fnic->fnic_num` instead of `host_no` in `fni=
c_fcpio_ack_handler` fractures trace continuity for FCP initiators.
--

commit b27e55a05c332cb8bdf0c9ddf7ffd360abf37856
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Use fnic_num for non-SCSI identifiers

This commit updates the fnic driver to use the driver instance number
for non-SCSI identifiers when dealing with NVMe initiators. It updates
NVMe-facing FDMI and debugfs entries with fnic_num, and records trace
events with the driver instance number.

> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 0759540f66753..b92260583c67b 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -894,7 +894,7 @@ static inline void fnic_fcpio_ack_handler(struct fnic=
 *fnic,
> =20
>  	spin_unlock_irqrestore(&fnic->wq_copy_lock[wq_index], flags);
>  	FNIC_TRACE(fnic_fcpio_ack_handler,
> -		  fnic->host->host_no, 0, 0, ox_id_tag[2], ox_id_tag[3],
> +		  fnic->fnic_num, 0, 0, ox_id_tag[2], ox_id_tag[3],

[Severity: Low]
Is it intentional to unconditionally use fnic->fnic_num here instead of
conditionally switching based on the initiator type?

Other FCP-specific trace events continue to log the host_no. Because host_no
and fnic_num can differ depending on driver load order, logging FCP ACKs un=
der
a different identifier might split the trace stream and break tools that
filter traces by host number.

Would it be better to conditionally use host_no for FCP initiators and
fnic_num for NVMe initiators, similar to how the FDMI and debugfs entries
were updated?

>  		  ox_id_tag[4], ox_id_tag[5]);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D2
