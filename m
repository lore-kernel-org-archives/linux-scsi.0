Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB1133122A
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499969; cv=none; b=XgjSPRyftjVu4q1Dq2GmUBUGvAe0D7KuP3lcyq6XYkkVRhiqHTjHSX0XcRukTxBuAnHKlDz1sgIjorOj6095GMFZd2RvZZsjq/oVGLDtJd9VdODQOddPIBALKnKLNbZ/4Uj0e1c+Wvc9PGEf7EWEl3BQ6fhq4QD/hMtrBqSxXGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499969; c=relaxed/simple;
	bh=O4NP3IswViPI57f0Zg64mpm+5VtdtSsTH9Vng0WbPuI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=myZCsDwZS1tL5/DEZmHhnVcte3saXf3LoWI4hvK9jcw/9mwHJVhYuD+W+0+nrTDTGP9iWQF1mT9YGsup738J9j3yDl/Z4KRNr4cgns5uGaXvp+P/reXg617mPZZCIiO3IOpfRBEjkp9kzcXdLEOY8FyPrLJYn8IRUYG0ax+mjJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKE4zglA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKE4zglA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2CC1F000FF;
	Thu,  8 Oct 2026 22:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791499967;
	bh=G0gZviXcqjF6uKDGUNx5jLluxq298JvNUCylCp6e9g0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DKE4zglAYSwkbwqpSPQ3wApbLFFSqo26ElXtQR5oNMklPKIwY8V4gh7pfQrjCtPTT
	 DEx7o3Du6dGFx7RC7aSy9A1Jvsw34Zl20wJ6/p14oY8L9TKd8ovQKJSnvEfG/jVYbc
	 ZSUGMF74J4Ls6lt5m+5hWWL2o7R/bNXSMAR11lo1CrdR+f4gQzgScweQdG7zWTRiK7
	 IQzNkB+DBZ5Bj4b4VlbB1DJ6os4Q0MYexYU7caOwnCismEY/Os5f/xn+U1v5jbp97y
	 4Qr1DvShPJY9juG+mEXFaze/0YeRxbNfSWWGWs/0qciHmG64g6hUpQ+Mz+ZsuOXw8T
	 adVAWh9xLMMiQ==
Message-ID: <sashiko-outbox-164650@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/8] scsi: scsi_debug: Split resp_write_same()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <1127ce1be450f0c4503845b41eaa24c27aba373a.1791499174.git.bvanassche@acm.org>
References: <cover.1791499174.git.bvanassche@acm.org>
 <1127ce1be450f0c4503845b41eaa24c27aba373a.1791499174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 22:52:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi_debug: data race on sip->storep between unmap_region() and =
do_device_access()
--

commit b0d6230062e0df8cfca0c47695724e008bd7da04
Author: Bart Van Assche <bvanassche@acm.org>

scsi: scsi_debug: Split resp_write_same()

This commit splits resp_write_same() into two functions to ensure all locki=
ng
statements end up in the same branch of an if-statement. This change is
intended to support the Clang thread-safety analyzer.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 44b4587b53c66..cadd94e17109a 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
[ ... ]
> -static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
> -			   u32 ei_lba, bool unmap, bool ndob)
> +static int __resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
> +			     u32 ei_lba, bool unmap, bool ndob, bool lbp)
>  {
>  	struct scsi_device *sdp =3D scp->device;
[ ... ]
>  	ret =3D check_device_access_params(scp, lba, num, true);
>  	if (ret)
> -		goto out;
> +		return ret;
> =20
>  	if (unmap && lbp) {
>  		unmap_region(sip, lba, num);
> -		goto out;
> +		return ret;

[Severity: Medium]
Does this early return result in a data race on the sip->storep buffer?

When a SCSI UNMAP command (or WRITE SAME with the unmap bit set) and a READ
command execute concurrently on the same LBA range of an LBP-enabled device,
unmap_region() modifies the data store via memset().

By returning early here, __resp_write_same() only holds the
sdeb_meta_write_lock (acquired in the resp_write_same() caller) and bypasses
acquiring the sdeb_data_write_lock.

Concurrently, read operations like resp_read_dt0() -> do_device_access()
acquire only the sdeb_data_read_lock and skip the sdeb_meta_read_lock entir=
ely
when running on non-zoned/non-DIX devices.=20

Could this concurrent access to sip->storep result in torn or mixed reads?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791499174.gi=
t.bvanassche@acm.org?part=3D2
