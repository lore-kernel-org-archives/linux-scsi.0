Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB96392C27;
	Tue, 21 Jul 2026 07:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784617232; cv=none; b=TFY9xQOnf7k7trdtc0tXQoF3uB0+b9DC085VCpBPCjlctJyuBx0V39pt3yhB8RMcBgsK1DOLBsWmFvNBPblqu/w9bS9dQwVs2+3a8sWV02pRD4JhyX4SAUqwoKAgWwqcyoGVgfEei2Xqt/5XztOnYVNpML5OgGmZ0z7jzzBczA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784617232; c=relaxed/simple;
	bh=kBXhWdXw8q9dwSMkHWf5tfvX+EO3BBu+jrAzQyCdhLA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UvgvbPfTUMofrxWjiv3VfaJ/7HPaY8xOtS3jPyBmoyGxTUbc2eM8C/VKIkcQdjf6FH/3PyERkLBNRc/JRN7NS+xAFy0TZ8Jj39TDVVYEnwp9t3iX+GYGwT44JWHur3GtMLvYIbb4iSumf82i6Gfj2gm3nSainHt8xr4r8A0OM3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6yVaE4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6yVaE4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC0F1F000E9;
	Tue, 21 Jul 2026 07:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784617230;
	bh=gy5pe3UqCNYXt4NOpi0/UbsFodI8JIL0IdcKJwKZRUg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g6yVaE4yCatHMRp/v+PoTPkaQLzBgbpwzrL1q8Hj6Ldox5CmwujX2OSLaAqLxoyFg
	 emgtAMN8IdAZDx73Y/vmKyTEUMvc7ZE++faA0LMSB586kGx4ALl/bCsW/iiyTqnvzp
	 jCfKi5dtOePeohHg8ZYyxIRSlGVoZqBkf5p2odyOn8EMJtBJvv793bUTSVZ5GEY8+Q
	 4z+iQnxsnigVLzWr+S5WTW5Yheywqfhnq4WxpJJGZjNAZg2hoRRJzAYgNsLAlNs7Dy
	 MQz3F7ySW6cGbUmGq/KfZ81iYMZgx+5jeD2ux6Op5OMmgvI/fXhgjlcyL6NrK9kutY
	 IWP1R3dNi+q/A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands on
 time out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20260721064027.2081195-2-dlemoal@kernel.org>
References: <20260721064027.2081195-1-dlemoal@kernel.org>
 <20260721064027.2081195-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 07:00:30 +0000
Message-Id: <20260721070030.8AC0F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing call to ata_scsi_schedule_deferred_qc() in atapi_qc_comple=
te() leads to starvation and timeouts of deferred commands.
--

--- Patch [1]: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands=
 on time out ---
commit 3b26adffba8da435c70bdca03b617603f9f9ae76
Author: Damien Le Moal <dlemoal@kernel.org>

ata: libata-scsi: terminate deferred commands on time out

This commit avoids unnecessary SCSI EH task wake-ups by scheduling
a retry of all waiting deferred QCs using the new ata_scsi_eh_timed_out
operation. It also updates ata_scsi_requeue_deferred_qc to terminate
timed-out deferred commands directly and schedule libata EH to prevent
the block layer from re-issuing them immediately.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 5868526301a2b..c2f2f711fd987 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c

[ ... ]

> @@ -2936,7 +3014,15 @@ static void atapi_qc_complete(struct ata_queued_cm=
d *qc)
>  		if (qc->cdb[0] =3D=3D ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
>  			qc->dev->sdev->locked =3D 0;
> =20
> -		ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
> +		if (cmd->result)
> +			ata_scsi_qc_done(qc, false, 0);
> +		else
> +			ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
> +		return;
> +	}
> +
> +	if (cmd->result) {
> +		ata_scsi_qc_done(qc, false, 0);
>  		return;
>  	}
> =20

[Severity: High]
This isn't a bug introduced by this patch, but should atapi_qc_complete()
be calling ata_scsi_schedule_deferred_qc(link) before returning?

Unlike ata_scsi_qc_complete() which kicks deferred commands,
atapi_qc_complete() misses this call on all of its exit paths, including
the ones modified here. If an ATAPI command is executing on a shared PATA
link and a concurrent command is issued to the other device, it gets
deferred by ata_std_qc_defer(). When the ATAPI command finishes, it
appears the deferred command will be trapped in link->deferred_qc and
never issued, eventually failing with DID_TIME_OUT and causing device hangs.

Could this function be missing a call to ata_scsi_schedule_deferred_qc()
to prevent starvation?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721064027.2081=
195-1-dlemoal@kernel.org?part=3D1
