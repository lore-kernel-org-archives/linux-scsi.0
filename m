Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002ED4D9558
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650265; cv=none; b=cMWAgs4xoCExMzNeOvr+VoUMuGcee2MvgbAyX9RgRkh+ESljYQduf/aKEFNA4UiGq2WYP5XfYGfj7YWSVHip01GJLN0fvIz+qisJwCMHavLY92iCtRclkdmAdW2UcWLkS+3LlNBpuU1e8h0anTNUN9sRF8Mc41OxrVWpjFj83No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650265; c=relaxed/simple;
	bh=Y4CaYitlu2OBlu6SnGzpjcA+hsdhfyE4WVabg98D0LM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gThsL+FMWZgQ3BsmD/6SgU5HB4V9jjuoFDwgF0cSp95SewtVMb9l8xFcf5uY+/90BIWvGyycUL3TR5hAWUyVBVooI6ZP748co1SeU8AcTPHMCFuzGgkadGKbEMA1WZHNXWAD6kxcFQAmOhLgkEnORSS34fBWJjGkHVIPKpXz4S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GPV9nId1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GPV9nId1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2A21F000FF;
	Thu, 17 Sep 2026 13:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650255;
	bh=nk6SOr9lCwzhgD4s8Xv7lr2F87oIrD0zG9eZnan71hc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GPV9nId1Z1lOFp5Hz0Fc355wsviBg1KuN7LnovQxjBnVcjysBd+r2S3jxK32xDtKe
	 z+gE/cyKBzOvnwUc/cayV7YDlux3TrsOEEbc1yr0p8CfJQxo4sUuwWyiZxqRhXitpM
	 VpoTLnYSAhbFX2PlCJmoXaRxkxGaXDbIgRoXwZLUS5n3Nx4MV0KK5Ugs8PeCbp2P/K
	 blSCWgKtQsR9+Ciew4/JUp5WmpUk3Eep8E6sRE23v9ipLC1Btz3VIGx5TVGjXDeeC3
	 0z8R3zXyQGZgwNLv25NPKEVfNg/mwqUOM5HjamR1VTqYT3hVqBm5rUZDOYKtHDJAEW
	 dj1X0MSHbdyEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/6] scsi: scsi_debug: Report the residual of a write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917125445.1376493-9-cassel@kernel.org>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-9-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 13:04:15 +0000
Message-Id: <20260917130415.9A2A21F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi_debug: unsigned underflow in resp_write_scat() residual calcu=
lation
--

commit a487bfccdf1b47222ab79a838751982d68882fc7
Author: Niklas Cassel <cassel@kernel.org>
Subject: scsi: scsi_debug: Report the residual of a write

This patch updates the write paths in scsi_debug to report residual
bytes when a buffer provided by the initiator is larger than the logical
blocks consumed. The residual is now reported in resp_write_dt0(),
resp_write_scat(), and resp_atomic_write().

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 6941809dfdb75..641dd6f937912 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> @@ -5352,6 +5354,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  		sg_off +=3D num_by;
>  		cum_lb +=3D num;
>  	}
> +	scsi_set_resid(scp, scsi_bufflen(scp) - sg_off);

[Severity: High]
Can this calculation result in an unsigned underflow if the initiator
provides a buffer shorter than what the CDB descriptors request?

In resp_write_scat(), sg_off tracks the data offset. For each LBA range
descriptor, sg_off is unconditionally incremented by num_by, which is the
size requested by the descriptor. This happens even if do_device_access()
copied less data due to hitting the end of the data-out buffer.

If the initiator provides a shorter buffer (scsi_bufflen) than what the
CDB descriptors request, sg_off will eventually exceed the buffer length.
The subtraction here would then underflow to a massive positive number.

The SCSI midlayer uses this residual to compute good_bytes in
scsi_io_completion(). Subtracting a massive residual from the expected
transfer length could cause good_bytes to wrap and become negative, which
might severely confuse the block layer I/O completion logic.

>  	ret =3D 0;
>  err_out_unlock:
>  	sdeb_meta_write_unlock(sip);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917125445.1376=
493-8-cassel@kernel.org?part=3D1
