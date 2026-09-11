Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C5C3D9530
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093318; cv=none; b=JVVVj9vqlP2UJgp3KBQ48xecI/ezLo7WLDgZxK6QxrS7E0PnC89VRPezRhxUYtZE6LIH4AXElxoYhHut0ADrp56TD2QAKbopPrMChk67iVsSq4/RdqemJp+6X+X2cD44nscXMR+h6ZO8eVj/6YNc4m3R3Z3Y97g/Gn9JCrrrO5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093318; c=relaxed/simple;
	bh=soov/4oma6DNTH/9lCnZ+zjtwx8ZMboQEKwQ92QHoZc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jxY5ZkPlZWYZ+ZCkxoLSVQPjYgS3YCevY5gLxyywEAVq6rGnFs7JHPsL8ozbPg3n9MVBwLshkdp1vzB9UJXe0h/4+Se6Gk1vUni6p1ENHT9cxx0Sf6BizfjY/JQB2SrCICniX1KlWyUCZsKwRqEPXNRGq9WdOmps08t53EJrSyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2XwNHXO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2XwNHXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5B71F000FF;
	Fri, 11 Sep 2026 02:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789093316;
	bh=T/XYdWEKjh/PF5su3cCCMU887EF3s0RWLUzJ1n7gUDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g2XwNHXOGtkIbzWobo4aqP/8neFuQn2KncxFPChXV292//C6gK5o3fkYyLOZKKUWc
	 a0UxYZ/KtwSsjv/yfykMO51KJWB0frvZDjspLsynK5dcL3KjB8R8pECG/zP4JsnfSC
	 IL96EkEWoy92NpYejmRV+LnKPMaeG52jdQRR2mK0apmljrtrOb94SNfU0dvzxyTvgY
	 KLuenTh9zlUAwmadvbivJ5YvCW4L7qfxftNBEkWblZqiDRko+g8SJ6mO3o1JBsoxMG
	 jNkj4LRezuYXzz5nD+m1Z80w9d94oTF1kQu55CoSCpVemC11yg3jGl+clptyGCtidv
	 C+N8YWMv9mytw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: dc395x: sync the waiting_timer before freeing
 the host
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fan Wu" <fanwu01@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260911020544.42966-1-fanwu01@zju.edu.cn>
References: <20260911020544.42966-1-fanwu01@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 02:21:55 +0000
Message-Id: <20260911022155.DF5B71F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] DeviceCtlBlk fields 'init_tcq_flag' and 'dev_type' are left uninit=
ialized in device_alloc() due to kmalloc usage.
- [High] Flawed list_size check in adapter_remove_and_free_device causes ei=
ther a Use-After-Free or a Memory Leak.
- [High] The reset_scsi_bus() function polls a hardware register without an=
y timeout. If the hardware is unresponsive or returns 0, the driver will ha=
ng the CPU by spinning infinitely.
--

commit 9eeaccf553daafad4a08c01c06f5487a6aed8afe
Author: Fan Wu <fanwu01@zju.edu.cn>

scsi: dc395x: sync the waiting_timer before freeing the host
   =20
The waiting_timer callback re-arms itself and takes the host lock.
adapter_uninit() currently stops it with timer_delete(), which does not
wait for a callback already running on another CPU.

> diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
> index 10e2078f4a0fd..5a4f2713dcfa0 100644
> --- a/drivers/scsi/dc395x.c
> +++ b/drivers/scsi/dc395x.c
> @@ -3808,13 +3808,11 @@ static void adapter_uninit_chip(struct AdapterCtl=
Blk *acb)
>  static void adapter_uninit(struct AdapterCtlBlk *acb)
>  {
>  	unsigned long flags;
> -	DC395x_LOCK_IO(acb->scsi_host, flags);
> =20
> -	/* remove timers */
> -	if (timer_pending(&acb->waiting_timer))
> -		timer_delete(&acb->waiting_timer);
> -	if (timer_pending(&acb->selto_timer))
> -		timer_delete(&acb->selto_timer);
> +	/* Drain the self-rearming timer; must not run under host_lock. */
> +	timer_shutdown_sync(&acb->waiting_timer);
> +
> +	DC395x_LOCK_IO(acb->scsi_host, flags);
> =20
>  	adapter_uninit_chip(acb);

[Severity: High]
This is a pre-existing issue, but does this code spin infinitely if the
hardware is unresponsive?

Looking at reset_scsi_bus() which is called by adapter_uninit_chip(), it
polls without a timeout or cpu_relax():

drivers/scsi/dc395x.c:reset_scsi_bus() {
    ...
	while (!(DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS) & INT_SCSIRESET))
		/* nothing */;
}

If the hardware fails to assert the reset interrupt, wouldn't this while lo=
op
spin indefinitely and cause a hard CPU lockup since it is called under
host_lock?

>  	adapter_remove_and_free_all_devices(acb);

[Severity: High]
This isn't a bug introduced by this patch, but does the logic here cause
either a use-after-free or a memory leak depending on the list size?

When adapter_remove_and_free_all_devices() calls
adapter_remove_and_free_device():

drivers/scsi/dc395x.c:adapter_remove_and_free_device() {
	if (list_size(&dcb->srb_going_list) > 1) {
		return;
	}
	adapter_remove_device(acb, dcb);
	kfree(dcb);
}

If there is exactly 1 active command in the list, list_size evaluates to 1,
causing the condition to be false and dcb to be freed. When the active
command completes later, wouldn't it attempt to access this freed memory?

Conversely, if list_size > 1, the function returns early without removing or
freeing the dcb. Does this permanently leak the dcb?

>  	DC395x_UNLOCK_IO(acb->scsi_host, flags);

[ ... ]

[Severity: High]
This is a pre-existing issue, but does device_alloc() leave fields
uninitialized due to kmalloc usage?

drivers/scsi/dc395x.c:device_alloc() {
    ...
	dcb =3D kmalloc_obj(struct DeviceCtlBlk, GFP_ATOMIC);
	if (!dcb)
		return NULL;
	dcb->acb =3D NULL;
    ...
}

Several fields are explicitly initialized, but init_tcq_flag and dev_type
are omitted and kmalloc does not zero the memory. Later checks like
if (!dcb->init_tcq_flag) could evaluate incorrectly if init_tcq_flag
contains garbage. Should this explicitly initialize these remaining fields?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911020544.4296=
6-1-fanwu01@zju.edu.cn?part=3D1
