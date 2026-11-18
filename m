Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044187;
	b=QS3EXlru+2Fc3IyNWm/llLfyWeHgSaXfppgwC/rdhc38QmTt1sMN52dWj8lV58up1sJs
	 oO1+ktolCANwYqOUYh86lh/fE3E/GBiB2E2QOYXjbJ4sBV4OGwc3rx6qmXaQNCDV0/syk
	 MmWavYA29BLC0JsJA4B0exewm7B6KncRhmPKzDP2/01aL5Tfyfi6G/rJETFUxMNT4ZdpK
	 m022xfJjl0xDz3yYoxSXGu9OQpf06tooOnU2TK0HLqEvZbGLWI6r2iBVF9m+7Dbw6mziD
	 FFfI0xvOtN3t79Rgtbo6AdUR2oCnVqrMY8SwVQF8bCx5SbVGlOp5FApYvE4QGvcBVHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044187;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HKxZ+sdQLSqLa/KMvMZBPYoLBr83fDvJK4q0ZkX9UCg=;
	b=xZ0is19YyPa3xTfC7aAb56bM9yr30M8Ugtb8dMeC2agOqhbczJnCoESny+SrYdb+urEl
	 GDEzGUVma3XJoCxfcz/TyThx/iJSPGHNNIcJQZWeJoz6u7DzwYNROMXx3sCNZFM11IkGX
	 jQpww3GRLRymIxR70ulmC661yOb+HaZM0L8j/RCKHjJ/Yy7kNlGeXAouvzVVtKVopMK78
	 NANpX6ow2NPMKwbHzsxHTqc9YoItBuCnIM4l0mrbvb5FQbFyuaFJnVeVTIqE0a0PKf2FT
	 NUiS6tAsFWMk/+bOqjX7R9+XbNM2oYiN9a+ph2Aj0056X4CGU1bevYbk28AVhG8fEfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="evOTZ1/q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F88A606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 23:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=evOTZ1/q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0931F000C4;
	Wed, 18 Nov 2026 23:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795044187;
	bh=HKxZ+sdQLSqLa/KMvMZBPYoLBr83fDvJK4q0ZkX9UCg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=evOTZ1/qmtfRisNW7jho1rFsw4SCWQBqynLjwlhkNS9bz+emt3NXcPb0zSgi1whxm
	 CDGPEg/qNIE3gYwZH+D3ThAE2pB2E1qjkwOjOC6jLvxBplVZLjWCQtgnHaa/8ZWAtC
	 OT//BAFsK5uw5rJOkUrL3t0NiP9vqExWbMEtel9bv5d2Ld+RZP82ZNltyEy6QaPzSL
	 J0kCZlgbuHDkj/5fS4vOrN+IxGQ3VXYi8fEEdfk4yIT3UFO2Ojhxe8KXWJtbinNwpf
	 7z7gFGBMwKMY2x+d3vZL9VEV+Ap4rqwAFXRDMcLoZz4M/JXo4od0tmtAnCc+lhTATp
	 ELQiN5fOxycwA==
Message-ID: <sashiko-outbox-222174@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/11] scsi: mpt3sas: Don't use freed hostdata while
 polling devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jeff Layton" <jlayton@kernel.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261118-sas-abba-v3-10-5562d690cf61@kernel.org>
References: <20261118-sas-abba-v3-0-5562d690cf61@kernel.org>
 <20261118-sas-abba-v3-10-5562d690cf61@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 23:23:06 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] scsi: mpt3sas: unlocked hostdata dereference in device unblock
  loops
--

commit a3557f5a5117e28396670a7dd01d7199c96743db
Author: Jeff Layton <jlayton@kernel.org>

scsi: mpt3sas: Don't use freed hostdata while polling devices

This commit serializes device polling and unblocking against sdev hostdata
teardown using ioc->block_lock so that polling loops stop when hostdata is
freed.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/=
mpt3sas_scsih.c
> index 09dfa3124ebf9..814c18289cf1c 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
[ ... ]
> @@ -4098,10 +4191,11 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTE=
R *ioc, u8 no_turs)
>  	enum device_responsive_state rc;
>  	struct _sas_device *sas_device =3D NULL;
>  	struct _pcie_device *pcie_device =3D NULL;
> +	struct _scsih_target_ids ids;
>  	int count;
>  	u8 tr_method =3D 0;
>  	u8 tr_timeout =3D 30;
> -
> +	unsigned long flags;
> =20
>  	shost_for_each_device(sdev, ioc->shost) {
>  		sas_device_priv_data =3D sdev->hostdata;
> @@ -4116,23 +4210,40 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTE=
R *ioc, u8 no_turs)
>  			continue;
> =20
>  		if ((no_turs) || (!issue_scsi_cmd_to_bringup_drive)) {
> -			sdev_printk(KERN_WARNING, sdev, "device_unblocked handle(0x%04x)\n",
> -				sas_device_priv_data->sas_target->handle);
> -			_scsih_internal_device_unblock(sdev, sas_device_priv_data);
> +			spin_lock_irqsave(&ioc->block_lock, flags);
> +			if (sdev->hostdata !=3D sas_device_priv_data)
> +				goto next;
> +			if (sas_device_priv_data->block) {
> +				sdev_printk(KERN_WARNING, sdev,
> +				    "device_unblocked handle(0x%04x)\n",
> +				    sas_target->handle);
> +				_scsih_internal_device_unblock(sdev,
> +				    sas_device_priv_data);
> +			}
> +next:
> +			spin_unlock_irqrestore(&ioc->block_lock, flags);
>  			continue;
>  		}
[ ... ]
> @@ -4207,27 +4315,32 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPT=
ER *ioc, u64 sas_address,
[ ... ]
>  	/* moving devices from SDEV_BLOCK to SDEV_RUNNING state */
>  	shost_for_each_device(sdev, ioc->shost) {
>  		sas_device_priv_data =3D sdev->hostdata;
>  		if (!sas_device_priv_data)
>  			continue;
>  		sas_target =3D sas_device_priv_data->sas_target;
>  		if (!sas_target)
>  			continue;
>  		if (sas_target->sas_address !=3D sas_address ||
>  		    sas_target->port !=3D port)
>  			continue;
>  		if (!sas_device_priv_data->block)
>  			continue;
> =20
> +		/*
> +		 * Polling can take minutes, and sdev_destroy() and
> +		 * scsi_target_reap() can free the hostdata meanwhile.
> +		 */
> +		rc =3D DEVICE_ERROR;
>  		count =3D 0;
>  		do {
>  			host_reset_completion_count =3D 0;
> -			pcie_device =3D mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
> +			if (!_scsih_get_target_ids(ioc, sdev,
> +			    sas_device_priv_data, &ids))
> +				break;

[Severity: High]
Can the initial checks at the top of _scsih_ublock_io_all_device() and the
second loop of _scsih_ublock_io_device_wait() still read freed
sas_device_priv_data and sas_target before ioc->block_lock is taken?

Unlike the first loop in _scsih_ublock_io_device_wait(), both of these
loops read sdev->hostdata and dereference sas_device_priv_data->sas_target,
sas_target->deleted (or sas_address and port), and
sas_device_priv_data->block without holding ioc->block_lock:

CPU0                                    CPU1
_scsih_ublock_io_all_device()
  sas_device_priv_data =3D sdev->hostdata
                                        __scsi_remove_device(sdev)
                                          scsih_sdev_destroy(sdev)
                                            spin_lock(&ioc->block_lock)
                                            sdev->hostdata =3D NULL
                                            spin_unlock(&ioc->block_lock)
                                            kfree(sas_device_priv_data)
                                          scsi_target_reap()
                                            ...
                                              kfree(sas_target)
  sas_target =3D
    sas_device_priv_data->sas_target    <-- use-after-free
  if (sas_target->deleted)              <-- use-after-free

Taking ioc->block_lock at the start of each iteration to validate
sdev->hostdata, sas_target, and sas_device_priv_data->block before deciding
whether to unblock or poll the device would close this window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118-sas-abba-v=
3-0-5562d690cf61@kernel.org?part=3D10
