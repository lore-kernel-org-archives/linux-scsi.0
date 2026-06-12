Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029CF34403D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 22:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781302552; cv=none; b=Vvu7lmk37hgSVsUesP4ZA5zuc0DRl5agBkav8YII4emXYlAx975vTg6Tej+/p7jXtsnDCTW00ooFq5Na5TqChqFAC+0rwlUgXq2T0R3+7NwsfVUN7uMFcZE1PS0utVCSQa7kuW4DXFWtaaYmP1KFjQQ4BCobu5XjButBLAhw95o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781302552; c=relaxed/simple;
	bh=cc/W/TAFOea3m/I2B2RJDRrHevHuhDXVMRt721r1Kx0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=llGZSW5K2LWSULF7kk0MGglR8D7IF51C6ORQq71iRjHNpNyu+tyjnZfnDhMhSsuLu1KEe+IPmR6kk8dIJI1I8v4b0CfbAX/lx5CNz270lPxmtpy0hor+GdSgsEuwLPF929We1kZBYU9KuMLDyg471GfLzxmfWJ90vt5onmSNHAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjBTJ0pQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjBTJ0pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A961F000E9;
	Fri, 12 Jun 2026 22:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781302550;
	bh=xuUpg/Hgmh88vsupxvuva7AsQP697zY/w4zjoSheeTo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PjBTJ0pQnYKZ7pf5CfN6CXWaSRaNG/JzvZaEWixs+N0lg59TBRJ5Cfb5FRmsy5Kqx
	 yz+SspJapn0UxCFwvgi6zU13H3/TR6Bx5gEmWqxl2LVmreIgD+qNcD3c7bY3yt/wAU
	 Uazqe4i2F5XE8FYNejK1qq7ScZTzpdahg9GwJSjOawynvGcs8SHAP7sPx7VVGv7iRS
	 JA0Vo0KAqeNB2QGiSfZBD4iDheDmLt1S+YpBnYobkjq3RMlvAs1VThTZ/ffcQR8gnj
	 Da8ksfYJVTccB+mykqyfx1aS0Fdn07PFzM4By30hDI8zYdidImcblYcW0Lk7UO+4jw
	 +vkwVOeCbOsvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/13] scsi: fnic: Route completions and resets by
 initiator role
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612180918.8554-8-kartilak@cisco.com>
References: <20260612180918.8554-8-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 22:15:50 +0000
Message-Id: <20260612221550.B8A961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Skipping WQ copy cleanup for initiator roles causes memory leaks a=
nd module unload hangs when the firmware reset times out or fails.
- [High] Unconditional processing of `FCPIO_NVME_ERSP_HW_CMPL` causes a NUL=
L pointer dereference when the driver is configured as an FC initiator.

Pre-existing issues:
- [High] Calling `schedule_timeout()` inside a hard IRQ handler causes a 'B=
UG: scheduling while atomic' kernel panic.
--

commit 23c7cf5a299e9835a32a14602537f5791c94b14b
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Route completions and resets by initiator role

Dispatch FCPIO command, response, and ITMF completions to the FCP or NVMe
handlers based on the configured role. Read the NVMe queue-depth and timeout
retry fields from firmware config, clean up NVMe I/O on firmware reset, and
skip SCSI-only cleanup for initiator roles that already reset firmware-owned
requests.

> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 04ab384033b19..5ad4bb7144283 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -734,6 +735,8 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fn=
ic *fnic,
>  	/* Clean up all outstanding io requests */
>  	if (IS_FNIC_FCP_INITIATOR(fnic))
>  		fnic_cleanup_io(fnic, SCSI_NO_TAG);
> +	else if (IS_FNIC_NVME_INITIATOR(fnic))
> +		nvfnic_cleanup_all_nvme_ios(fnic);

[Severity: High]
This is a pre-existing issue, but does calling fnic_cleanup_io() here cause=
 a
'BUG: scheduling while atomic' kernel panic?

The completion handler is called in an atomic context:
fnic_isr_msix_wq_copy() -> vnic_cq_copy_service() ->
fnic_fcpio_cmpl_handler() -> fnic_fcpio_fw_reset_cmpl_handler() ->
fnic_cleanup_io()

Inside fnic_cleanup_io(), the thread yields:

drivers/scsi/fnic/fnic_scsi.c:fnic_cleanup_io() {
    ...
	while ((io_count =3D fnic_count_all_ioreqs(fnic))) {
		FNIC_SCSI_DBG(KERN_DEBUG, fnic, ...);

		schedule_timeout(msecs_to_jiffies(100));
	}
    ...
}

[ ... ]
> @@ -1457,11 +1460,21 @@ static int fnic_fcpio_cmpl_handler(struct vnic_de=
v *vdev,
>  		break;
> =20
>  	case FCPIO_ICMND_CMPL: /* fw completed a command */
> -		fnic_fcpio_icmnd_cmpl_handler(fnic, cq_index, desc);
> +		if (IS_FNIC_FCP_INITIATOR(fnic))
> +			fnic_fcpio_icmnd_cmpl_handler(fnic, cq_index, desc);
> +		else if (IS_FNIC_NVME_INITIATOR(fnic))
> +			nvfnic_fcpio_nvme_fast_cmpl_handler(fnic, desc);
> +		break;
> +
> +	case FCPIO_NVME_ERSP_HW_CMPL: /* fw completed NVMe ERSP */
> +		nvfnic_fcpio_ersp_cmpl_handler(fnic, desc, 1);
>  		break;

[Severity: High]
Does unconditional processing of FCPIO_NVME_ERSP_HW_CMPL cause a NULL point=
er
dereference when the driver is configured as an FC initiator?

Unlike the FCPIO_ICMND_CMPL and FCPIO_ITMF_CMPL cases which check the
initiator role, nvfnic_fcpio_ersp_cmpl_handler() is called unconditionally.

This function relies on nvfnic_find_io_req_by_tag(), which tests a bit in t=
he
nvfnic_tag_map bitmap:

drivers/scsi/fnic/fnic_nvme.c:nvfnic_find_io_req_by_tag() {
    if (tag =3D=3D FNIC_NVME_NO_FREE_TAG ||
        !sbitmap_test_bit(&fnic->nvfnic_tag_map, tag))
        return NULL;
}

However, fnic->nvfnic_tag_map is initialized exclusively in
fnic_nvme_drv_init(), which is only executed if the driver role is
FNIC_ROLE_NVME_INITIATOR. If firmware sends this event to a host operating =
as
an FC initiator, sbitmap_test_bit() will dereference the uninitialized sbit=
map
struct.

[ ... ]
> @@ -1650,6 +1663,15 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_c=
opy *wq,
>  	unsigned long start_time =3D 0;
>  	uint16_t hwq;
> =20
> +	/*
> +	 * Clean up all outstanding io requests. For FC initiator or NVME
> +	 * initiator we issue firmware reset before this and all I/Os are
> +	 * already freed
> +	 */
> +	if (IS_FNIC_FCP_INITIATOR(fnic) ||
> +	    IS_FNIC_NVME_INITIATOR(fnic))
> +		return;
> +

[Severity: High]
Does this early return cause memory leaks and module unload hangs if the
firmware reset times out or fails?

If fnic_fcpio_reset() times out while waiting for completion, the
fnic_fcpio_fw_reset_cmpl_handler() is never invoked, and the IO cleanup
functions are skipped.

Because fnic_wq_copy_cleanup_handler() now unconditionally returns early
instead of acting as a fallback to complete pending descriptors with
DID_NO_CONNECT, it seems all outstanding IOs would be leaked. Their
completion callbacks are never triggered, which permanently blocks
scsi_remove_host() during teardown.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612180918.8554=
-1-kartilak@cisco.com?part=3D7
