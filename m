Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FC824293C
	for <linux-scsi@vger.kernel.org>; Sun, 30 Aug 2026 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788096688; cv=none; b=WoUZhVZpOBoeGSLe9/JkEm9BMp/+0lKDpRsMRwoO0v0shruNQjbWaO7kBsWqpVU08pW/ed8LPCIDDjyItLPpses2fkUQMbg9gcw7CtjhrBc4lD77IFpVsJbpslvetpy0pyQNvf5Q1l1x9VaqXoNC11QgGbXHq4veI+nQAWROBaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788096688; c=relaxed/simple;
	bh=Cm5B89ICPWUEXvDsaEzxyhSH9PhmnG9PrlPf5DnepXI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C8by20jq1sbtH9gx8oRA9bcZlGK9EPH13rneazanDsMZacdsCmm9P/3UTd+sOdEILkRatWmXfGfmcXipCPIFufmVf/28DpYlxVqQWD2ymbeyFEQzlPGdAIxPt+MGXP+hn1npCJ/zEZzTyWsBEg76+IyIYpGzci60k9gWnQvWzWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kwGcCtLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kwGcCtLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7731F000E9;
	Sun, 30 Aug 2026 13:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788096687;
	bh=gZtQ3qXEaaNG/cl3hhxdG5FKYrbWBOPgF4M0EzoaXhA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kwGcCtLOQia9ClQdmkcSO5mxONRJuzBVR+8IDmOjT4kzTjOo0ovPgrQGIAdOqWygC
	 rdTq4KRokp+nVFYcGKXXHKzMSasMYN9suS7UdVCpFxgI067pHay07+rQ/5VQ70bmh2
	 m2OwU1stoQOEzabpMhS2jBsJwoa/Sp2Zgbc1kbv2WyMdrkSaj5EhohMJgRgHhUfese
	 nVZLhQ5eARuwZMTNLLbNRmPEomgH/2RTIYmaNtjDk37+tS0gZBRCLuEGQfkRfHZzck
	 HkNRTmsveltp81SQ42nmQ+QnIN7fNbYJwVCdkpv0S4mxK7C+iGvuB6y/8ATH3f7/ll
	 u/hrLcyhVnHIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: efct: validate firmware header size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260830132051.4441-1-pengpeng@iscas.ac.cn>
References: <20260830132051.4441-1-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 30 Aug 2026 13:31:26 +0000
Message-Id: <20260830133126.CA7731F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but the firmware wri=
te loop exits on signal interruption without canceling the pending asynchro=
nous hardware operation, leading to DMA use-after-free and stack corruption.
- [High] This problem wasn't introduced by this patch, but missing timer sy=
nchronization before freeing xport leads to Use-After-Free.
- [High] This problem wasn't introduced by this patch, but there is unprote=
cted traversal and modification of the global efct_devices list.
- [Medium] This problem wasn't introduced by this patch, but there is an in=
formation leak via out-of-bounds read due to missing null-termination when =
logging fw_image->revision.
--

commit 96d5d1eba778004d13f602bb0b32a97487f39774
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: efct: validate firmware header size
   =20
This commit adds a size check for the firmware blob before casting it to an
efct_hw_grp_hdr structure. This prevents accessing header fields out of bou=
nds
on undersized firmware images.

> diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/=
efct_driver.c
> index 07c2f453459e1..b0d8ca58daebe 100644
> --- a/drivers/scsi/elx/efct/efct_driver.c
> +++ b/drivers/scsi/elx/efct/efct_driver.c
> @@ -338,6 +338,10 @@ efct_request_firmware_update(struct efct *efct)
>  		efc_log_debug(efct, "Firmware file(%s) not found.\n", file_name);
>  		return rc;
>  	}
> +	if (fw->size < sizeof(*fw_image)) {
> +		rc =3D -EINVAL;
> +		goto exit;
> +	}
> =20
>  	fw_image =3D (struct efct_hw_grp_hdr *)fw->data;
> =20

[Severity: Medium]
This is a pre-existing issue, but since we are validating the firmware
image here, is there a risk of an out-of-bounds read when logging the
revision?

In efct_request_firmware_update(), fw_image->revision is printed using
the %s format specifier:

	efc_log_info(efct, "Firmware update is initiated. %s -> %s\n",
		     efct->hw.sli.fw_name[0], fw_image->revision);

Since fw_image->revision is a 32-byte fixed array from an external file,
it may not be null-terminated. Will vsnprintf read past the array
boundaries into adjacent memory?

[Severity: High]
This isn't a bug introduced by this patch, but does the firmware write
path handled later in this function suffer from a use-after-free if
interrupted?

When efct_request_firmware_update() calls efct_firmware_write(), the
write loop allocates a DMA buffer and completion struct on the stack,
then waits for completion:

	if (wait_for_completion_interruptible(&result.done) !=3D 0) {
		rc =3D -ENXIO;
		break;
	}

If interrupted by a signal, the loop breaks, frees the DMA buffer, and
the function returns, destroying its stack frame.

Could the asynchronous hardware callback efct_fw_write_cb() then execute
and write to the freed stack pointer?

	result->status =3D status;
	result->actual_xfer =3D actual_write_length;
	result->change_status =3D change_status;

	complete(&result->done);

Does the hardware operation need to be canceled before returning?

[Severity: High]
This is a pre-existing issue, but does the firmware reset path invoked
at the end of this function safely clean up timers?

When efct_request_firmware_update() triggers efct_fw_reset(), it deletes
the timer unsafely:

	if (timer_pending(&efct->xport->stats_timer))
		timer_delete(&efct->xport->stats_timer);

A similar pattern exists during general device teardown in
efct_xport_detach():

	if (timer_pending(&xport->stats_timer))
		timer_delete(&xport->stats_timer);

Because timer_delete() is used instead of timer_delete_sync(), could the
timer callback efct_xport_stats_timer_cb() be running concurrently on
another CPU?

If the teardown path then proceeds to free the xport object, could the
concurrently running callback access freed memory or re-arm the timer,
causing memory corruption?

[Severity: High]
This problem wasn't introduced by this patch, but is the global
efct_devices list protected against concurrent access during configfs
operations?

Devices are added and removed from the list during PCI probe and
teardown without holding any locks:

drivers/scsi/elx/efct/efct_driver.c:efct_device_alloc() {
	...
	list_add_tail(&efct->list_entry, &efct_devices);
	...
}

drivers/scsi/elx/efct/efct_driver.c:efct_device_free() {
	...
	list_del(&efct->list_entry);
	...
}

Meanwhile, LIO configfs operations traverse the list unprotected:

drivers/scsi/elx/efct/efct_lio.c:efct_find_wwpn() {
	...
	list_for_each_entry(efct, &efct_devices, list_entry) {
		if (wwpn =3D=3D efct_get_wwpn(&efct->hw))
			return efct;
	}
	...
}

If a device is hot-unplugged or unbound while a configfs operation is
traversing the list, could this result in a data race reading corrupted
list pointers or freed memory?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260830132051.4441=
-1-pengpeng@iscas.ac.cn?part=3D1
