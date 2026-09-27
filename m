Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AED6274FE3
	for <linux-scsi@vger.kernel.org>; Sun, 27 Sep 2026 05:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790487641; cv=none; b=UiVxC7bXWgP0xUjHDiCCY5GuOJLd2aPBisvFF7WrzAvxsJ3YdFZy4OikAbKL5HNhq7M2E1LJZ+v1215uzXuGnBzhIMyWHATdc+qvS1JdCZTSw21tVY+o/JPmXYXr6ju01Vg/rHINeTwz8er/jDasAlXf5u6YeIgWtM4Meo/Gug0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790487641; c=relaxed/simple;
	bh=23hOcav9bhHwPH/VbDtK/qoWVdSXFD1Fjje2eG/i0kI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=W4/M3Lsk+SfFSvuUENdAlQSuWU9bgqhCga3FoD8hfg6eCmtxD4oDOilPseOQadAVEaFfkUtqNdOS7MTw5EYTrtcVIuZOp1cr3G9u53MKXJL28b7lw9tblDwfobEebW3E0nGn+8wR0hGup3behE7VbRqodBAhgSu2htMx9gAgGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KPKmdPNj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KPKmdPNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B7D1F000FF;
	Sun, 27 Sep 2026 05:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790487640;
	bh=BaqNj0171Ey8cR/aUk8Fh/DgTlArRUy1ti4N1vCi720=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KPKmdPNjyofhRWd+i1QLltgRoVakb9grya3qaeeP6ojAH4DdeumpHNwzws7CfQQer
	 rQC3OqkGB7LuUmoToaH5EB6F6iQ4PfMZAhctthH1nBZYIuT3SfwUQ9CzBEZnvy0r7b
	 y8yZXM/A0elJOfM6k7cHWPklpwruwg5BtkoKOC5208j4E7Ne8386SJQjXK0S2GaEjO
	 AZPtw2ewRGFbgcZ/P3wkCOnSiu7z5GQG+PQdS13SiFvZvsvjlzjUW5ZQ/+flulC9KK
	 DfkQ2md3ekxSa9JleMuSlGbhRm1bMYZrioIvtaCVhbvnilVCmDwDqqORbldXoSCkTh
	 5mOrzhhrzjhYA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 05/11] scsi: scsi_debug: Report the residual of a
 write
Reply-To: sashiko-reviews@lists.linux.dev
To: "Niklas Cassel" <cassel@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260927052650.567035-18-cassel@kernel.org>
References: <20260927052650.567035-13-cassel@kernel.org>
 <20260927052650.567035-18-cassel@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 27 Sep 2026 05:40:39 +0000
Message-Id: <20260927054039.E7B7D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: scsi_debug: incorrect residual for WRITE SCATTERED due to =
32-bit overflow
--

commit 8bc6d8e408815c5b6d6afe8b3e8dbdaabb79d3d5
Author: Niklas Cassel <cassel@kernel.org>
scsi: scsi_debug: Report the residual of a write

This commit adds residual reporting for writes in scsi_debug, ensuring
that writes with data buffers larger than their transfer length report
the residual correctly, similar to reads. It updates resp_write_dt0(),
resp_write_scat(), and resp_atomic_write() to calculate and set the
residual based on what the command consumed.

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index b64ae3ad300d8..0c66a3118ee89 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c

[ ... ]

> @@ -5352,6 +5358,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,
>  	}
>  	ret =3D 0;
>  err_out_unlock:
> +	/*
> +	 * sg_off counts what the command asked for, which can exceed the
> +	 * buffer: lbdof is not validated against it, and a range is counted
> +	 * in full even if do_device_access() copied less.
> +	 */
> +	if (scsi_bufflen(scp) > sg_off)
> +		scsi_set_resid(scp, scsi_bufflen(scp) - sg_off);

[Severity: Medium]
Will this calculation produce an incorrect residual if the command includes
a very large LBA range?

In resp_write_scat(), the variables num_by, num, and lb_size are all 32-bit
integers, and num_by is calculated as:

    num_by =3D num * lb_size;

If num is sufficiently large (e.g., > 8.38M blocks), does this 32-bit
multiplication overflow and wrap around to a small value?

If num_by wraps, it appears the sg_off accumulator will also wrap below the
actual buffer length, causing this new guard if (scsi_bufflen(scp) > sg_off)
to erroneously evaluate to true. Could this result in a bogus residual being
set for a write that actually fully consumed the buffer, potentially
confusing the initiator or midlayer into failing or retrying completed I/Os?

>  	sdeb_meta_write_unlock(sip);
>  err_out:
>  	kfree(lrdp);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927052650.5670=
35-13-cassel@kernel.org?part=3D5
