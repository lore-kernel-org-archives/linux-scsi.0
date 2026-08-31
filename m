Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514BD361974;
	Mon, 31 Aug 2026 02:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788143247; cv=none; b=W+2nr+b/KdawTlwLvun8TkfzKoHf+kkthKxVEiSF2FAk/8/Wkg24rX+LD/7hBuZ646n3Q07qRXkHpi5BmjqFPJUqv33wFPmXCTDs+yrT9QYOJIPu/PONWa/hLP41/YViNrNNZywA5YDd6/A/BX2cm75i/uCdcbOyeEc6NL/+m9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788143247; c=relaxed/simple;
	bh=k5f4ziLn4KVBzJnQJFf3vfJ8uND9hjD9as44oAoQc0U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=JnCnv1b5s8g5b2VBMt6523nUawEC47HH3YbfFfOF+2aIv77NxE80O/JWUt/kfnqKu7jGR20UGrFQTbpnw0665tnCFe0bE3IcS/jSwIfTeX3fLVxoK1IRsocGaIovpjcO/lrgS+HXMmhnsONLKuSGyfeY2ruK/9nM3p1WL4of6fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RFuo4A9G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RFuo4A9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBCB1F000E9;
	Mon, 31 Aug 2026 02:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788143234;
	bh=lLENqZgBBv51B/BvPD9OXyB/355Pzr4YP5E6sepDujg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RFuo4A9G8fwf61gsF8iO001p2lUyGdRo2PrY/cviu2Vf2ZEho18/0Qrser9h4lApy
	 YUOFuNXgFv3blNSZu6AWq1on8wD+tzYz8oJM0yWCiE8FYmOHS8y3ISHwkja0JWp+RP
	 X7S8pCbGoBvXV+7VvV0Iec206bmFQ1VC/a/ku3pjhtFf7Q4d6v5bgx94llhRNgET76
	 HGk7p3ZcVVgdyILBR+geQUpYjveJx5iPwQ5AyGjl4EhMPRPornRERpEPrhxMbPqg6R
	 3jHe/0Q0rI67rHjCYDWOvZcq1EdEYeshPL2eSz+ko1euyBE6ildLInftESy7nQnbrL
	 QSzYQHpKQeBHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 33/37] scsi: storvsc: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260831020451.585944-34-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-34-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 31 Aug 2026 02:27:14 +0000
Message-Id: <20260831022714.ACBCB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Use-After-Free when an asynchronous I/O completion enqueues work o=
nto a destroyed workqueue during device removal.
--

commit d0f50a340823cdbe80b900f5e21694a095dae714
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: storvsc: use 16-bits defined sense codes

This refactors the storvsc driver to use the 16-bits sense_code field of
struct scsi_sense_hdr. It replaces hard-coded additional sense codes with
the enum values defined in include/scsi/scsi_sense.h to improve code
clarity.

> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index ef3cd3bc7390e..625db97d1a03e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
[ ... ]
> @@ -1033,7 +1033,7 @@ static void storvsc_handle_error(struct vmscsi_requ=
est *vm_srb,
>  	case SRB_STATUS_DATA_OVERRUN:
>  		if (vm_srb->srb_status & SRB_STATUS_AUTOSENSE_VALID) {
>  			/* Check for capacity change */
> -			if ((asc =3D=3D 0x2a) && (ascq =3D=3D 0x9)) {
> +			if (sshdr->sense_code =3D=3D CAPACITY_DATA_HAS_CHANGED) {
>  				process_err_fn =3D storvsc_device_scan;
>  				/* Retry the I/O that triggered this. */
>  				set_host_byte(scmnd, DID_REQUEUE);
>  				goto do_work;

[Severity: High]
This isn't a bug introduced by this patch, but can this lead to a
use-after-free during device removal?

In storvsc_remove(), the driver destroys the workqueue before stopping the
VMBus channel and draining outstanding requests:

drivers/scsi/storvsc_drv.c:storvsc_remove() {
    ...
    destroy_workqueue(host_dev->handle_error_wq);
    scsi_remove_host(host);
    storvsc_dev_remove(dev);
    ...
}

If an asynchronous I/O completion indicating a capacity change arrives after
this point, it will call storvsc_handle_error(), take this goto do_work
path, and blindly enqueue work onto the destroyed workqueue:

drivers/scsi/storvsc_drv.c:storvsc_handle_error() {
    ...
do_work:
    ...
    queue_work(host_dev->handle_error_wq, &wrk->work);
}

>  			}
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260831020451.5859=
44-1-dlemoal@kernel.org?part=3D33
