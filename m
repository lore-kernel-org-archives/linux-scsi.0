Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0E03DDDCD
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 09:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515230; cv=none; b=ClcniY9hCoKPrKu4n+NIkPoynyaIGDoPeQ2Ey3fz1/yI9t8/XIU17zkXwQMyug59He+Cdbmu66GES7HBmVQF5KKO/rOp2efjnZdPNBHzw2hS7TCxlnB6KURx+OaItTR4oRtiR3/Yy8ZJPj92sBD2LbEsqwYj5To1ROYkOiu7J5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515230; c=relaxed/simple;
	bh=FHDQryq78/9FQ0aMlOnL40CN/4E1Ohwm/s3QCgeMd4Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PKIUowhNpnh4dmfYCj9fbCYDRxV3rp4DnQlGh9qPT1FGM514ieu+8K8U9c7RKiP9qICaLAjexHwDbGyiBnbYkCK3H/KUWzdj8GHtUjBB7xZzTKc3x46h3MZvJoEQoJ66lFrxZsF17a8UqAtCtDcKwpNR4quBuq0z0es8o6KGSYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gAaIJycE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAaIJycE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E34B1F00A3D;
	Fri,  4 Sep 2026 09:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788515228;
	bh=Tslc/fhrwlhTcALBg4ogtTdPPqoSy9N5+4FMe88pW+E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gAaIJycEumID5W/8pdrCd9BI+SScuh1KmJ6mYcmCiasrLhoclsbcaX3C7nay7dtik
	 HEYZ7v1226e9P1m+af1Mc6xjx2zQX8Hn3qDPUnE5h88xqfeGGSiuJVqIqrkJ40zRbw
	 J/o9jL+tFoUKYSwJIZ+GFKbLO2r7IuDow4RNbJ3zb9lDV3fNqy45e6HLGaHyggucYB
	 HMMj1XMAE+/rAJ+vzrV8dC6+kkqUVbZz6w5H6eOFUfbKs9B3VQSMMr4WgUExiEenAI
	 EjcAl6GXZ6xTuH03M6a+G4NUVtscOtJ9zMXunsLPOJsHvrmCGIbsXkbpOEdVbm2EOW
	 KTkskkg8LAClA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: fix hb_host_mem leak on init
 failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260904092740.2612033-1-dayou5941@163.com>
References: <20260904092740.2612033-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 09:47:07 +0000
Message-Id: <20260904094708.5E34B1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [Critical] Moving hb_host_mem deallocation to megasas_free_ctrl_dma_buffe=
rs() introduces a Double Free vulnerability.
- [Critical] Moving hb_host_mem deallocation to megasas_free_ctrl_dma_buffe=
rs() introduces a critical DMA Use-After-Free (memory corruption) in the me=
gasas_resume() error path.

Pre-existing issues:
- [High] Premature scsi_host_put() in the megasas_resume() error path cause=
s an unbalanced refcount and Use-After-Free.
- [High] The background workqueue work_init is never explicitly canceled du=
ring driver teardown, leading to a Use-After-Free.
--

commit f28052d4c7a011d567f9039c9799bb5ecb631dd8
Author: Li Youhong <liyouhong@kylinos.cn>

scsi: megaraid_sas: fix hb_host_mem leak on init failure

hb_host_mem is allocated in megasas_sriov_start_heartbeat() but only
freed in megasas_detach_one(). megasas_init_fw() and megasas_resume()
failure paths clean up through megasas_free_ctrl_dma_buffers(), which
did not free this buffer.

Move the free from megasas_detach_one() into
megasas_free_ctrl_dma_buffers().

> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index 46aebe52c3da9..5ca2908ebfb10 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -7415,6 +7415,12 @@ void megasas_free_ctrl_dma_buffers(struct megasas_=
instance *instance)
>  				  instance->host_device_list_buf,
>  				  instance->host_device_list_buf_h);
> =20
> +	if (instance->hb_host_mem)
> +		dma_free_coherent(&pdev->dev,
> +				  sizeof(struct MR_CTRL_HB_HOST_MEM),
> +				  instance->hb_host_mem,
> +				  instance->hb_host_mem_h);
> +

[Severity: Critical]
Does moving this deallocation here introduce a double free of hb_host_mem?

If megasas_resume() fails, it cleans up by calling
megasas_free_ctrl_dma_buffers(), which frees instance->hb_host_mem but
leaves the pointer dangling because it is not set to NULL.

If the block layer holds a reference preventing immediate freeing of the
instance, subsequent unbinding of the driver will invoke
megasas_detach_one(), which unconditionally calls
megasas_free_ctrl_dma_buffers() again, triggering a double free.

[Severity: Critical]
Could freeing this memory here lead to DMA memory corruption when called
from the megasas_resume() error path?

In megasas_resume(), megasas_sriov_start_heartbeat() tells the active
firmware to continuously DMA to the physical address of hb_host_mem.

If a subsequent initialization step fails, the fail_init_mfi error path
calls megasas_free_ctrl_dma_buffers().=20

Because the error path does not send a shutdown command to the firmware
or clear the PCI Bus Master bit, the active firmware may silently
continue to perform periodic DMA writes to the freed memory, corrupting
whichever subsystem later allocates that physical page.

>  }
> =20
>  /*
[ ... ]
> @@ -8092,11 +8098,6 @@ static void megasas_detach_one(struct pci_dev *pde=
v)
>  				    instance->vf_affiliation_111,
>  				    instance->vf_affiliation_111_h);
> =20
> -	if (instance->hb_host_mem)
> -		dma_free_coherent(&pdev->dev, sizeof(struct MR_CTRL_HB_HOST_MEM),
> -				    instance->hb_host_mem,
> -				    instance->hb_host_mem_h);
> -
>  	megasas_free_ctrl_dma_buffers(instance);
> =20
>  	megasas_free_ctrl_mem(instance);

[Severity: High]
This is a pre-existing issue, but does megasas_detach_one() leave
instance->work_init pending during driver teardown?

During driver teardown, megasas_detach_one() deletes the
sriov_heartbeat_timer via timer_delete_sync(), but it entirely fails to
call cancel_work_sync(&instance->work_init).

If the work is scheduled just before the timer is deleted, it will remain
pending and can execute asynchronously after scsi_host_put() frees the
instance structure, leading to a Use-After-Free.

[Severity: High]
This isn't a bug introduced by this patch, but does the megasas_resume()
error path drop a Scsi_Host reference that was never acquired?

If megasas_resume() encounters an initialization failure, the
fail_init_mfi error path executes scsi_host_put(host):

drivers/scsi/megaraid/megaraid_sas_base.c:megasas_resume() {
    ...
fail_init_mfi:
	megasas_free_ctrl_dma_buffers(instance);
	megasas_free_ctrl_mem(instance);
	scsi_host_put(host);
    ...
}

Because this reference was never taken during resume, dropping it causes
a refcount underflow, leading to the premature freeing of the host and
the embedded megasas_instance structure.

When the device is later unbound, megasas_detach_one() will retrieve the
already-freed instance pointer via pci_get_drvdata() and dereference it,
leading to a system crash.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904092740.2612=
033-1-dayou5941@163.com?part=3D1
