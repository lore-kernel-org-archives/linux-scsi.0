Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E386842086A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 03:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783395060; cv=none; b=NLd4YmSAEpRq6kzJrcDe+fqDkmHdUE9BXqYCKOlm9azred+Odc4+Cwtx/IXQabB0WBNE4OKCE3rAq/SM4j8zwYiA8p+/+o5sA1iO29HVixNPflOxxOBeSgheoc71keJYTMWyN2eP5goB8tycjxbJE7QCfyIbaJYcAgJQH6467Xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783395060; c=relaxed/simple;
	bh=sSzu4MaQSbxHZ47pA6WF3bM4irBMsFnCh4u3WlfGTh8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Xm9X6CeiaUN1T6T3J0fnYEh7wvRLOih3bK4PX4YyoIzFjn4TtKtb2QP99RPakE6rVif/iURzr5ggla7UhnixHtZ8RxFRSKGWjRSXt5A3NI2GtK9/wINe6PF3Syizl2cOBvWZbQWVvi4rEPPPr97VT9/Lyg0LtzZqNgwTvspfOF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TUYwtWsN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TUYwtWsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D2D1F000E9;
	Tue,  7 Jul 2026 03:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783395058;
	bh=Ye674k9K7yv14oG4q105ChA+30gh+cWjsFhQa+clgTM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TUYwtWsNCtubA1ojNiYlU37A60krad61H2Rif3aIeFV5+LHLaPRK9E3zWpmgyVSis
	 q6nQzJ5VVi55xlFPfM2jJr4bz76ChfZIUHRGNbcKQz8LfQNIg8bV0JxJAW2Plo1SfE
	 vBGV+bXS5lQ4JV7ZoJSK5w17tjMG7SgIf4vO1WjbiBu6UrVUo5pp4gBO3EM8HzU4GQ
	 w3RVd4rRKO2Pjj+2hOvdTxpBo4NCpZqYDCO6dZCPxRkX1wLTc3/44WN8lO21mi3Nm/
	 bhWd0JtdaHpSM1iXKP5K+0e6CHHKkN6AYLm2wf8ZNhNwU6lvaQa1gLzwd2cO6fSPvf
	 /c1B4ec8jVdzA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] scsi: sd: fix error handling in sd_probe() after
 large pool creation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yang Xiuwei" <yangxiuwei@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707030333.22245-2-yangxiuwei@kylinos.cn>
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
 <20260707030333.22245-2-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 03:30:58 +0000
Message-Id: <20260707033058.A8D2D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Calling device_unregister() before put_disk() in the error pat=
h creates a use-after-free vulnerability during SCSI Error Handling.
--

--- Patch [1]: [PATCH v2 1/3] scsi: sd: fix error handling in sd_probe() af=
ter large pool creation failure ---
commit f2e6ec332a4785be7451dad3afaf04d9cb43c90c
Author: Yang Xiuwei <yangxiuwei@kylinos.cn>
scsi: sd: fix error handling in sd_probe() after large pool creation failure

This commit modifies the error handling path in sd_probe() when
sd_large_pool_create() fails. It replaces a goto with direct calls to
device_unregister() and put_disk() to prevent leaking sysfs entries and
freeing an already registered device.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 599e75f333343..d18693d390b2f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4089,7 +4089,9 @@ static int sd_probe(struct scsi_device *sdp)
>  	if (sdp->sector_size > PAGE_SIZE) {
>  		if (sd_large_pool_create()) {
>  			error =3D -ENOMEM;
> -			goto out_free_index;
> +			device_unregister(&sdkp->disk_dev);
> +			put_disk(gd);

[Severity: Critical]
Does this ordering create a use-after-free window?

By calling device_unregister() before put_disk(), the sdkp structure is
synchronously freed, but the request queue disk pointer remains set until
put_disk() runs.

If an asynchronous SCSI command times out precisely in this window, could
the SCSI error handler dereference the freed pointer?

drivers/scsi/sd.c:sd_eh_reset() {
        struct scsi_disk *sdkp =3D scsi_disk(scsi_cmd_to_rq(scmd)->q->disk);

        /* New SCSI EH run, reset gate variable */
        sdkp->ignore_medium_access_errors =3D false;
        ...
}

Would it be safer to call put_disk() before device_unregister() to clear
the queue disk pointer and prevent this concurrent access?

> +			goto out;
>  		}
>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707030333.2224=
5-1-yangxiuwei@kylinos.cn?part=3D1
