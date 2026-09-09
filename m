Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2473D6CDF
	for <linux-scsi@vger.kernel.org>; Wed,  9 Sep 2026 09:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945938; cv=none; b=Ktl0dxXb8rrdgUvYI+mqKdnDrVfhtpoxhJcZxzlIO1kzbap+ymxq3ETlCGWf2Xc/43dBtI6vSCAS7imHLgtXdu2PorzDBb6umT2nzIdxMyilSe5/Z67Fjf7uCeyaCoS7BtqU9AuB1HbuNknaNNYH/eRuIQF8qz17bolH6rFRSHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945938; c=relaxed/simple;
	bh=2dKRtMRby/OWV4v+p56gfsmwPhTN1W3MHP1CA/NlZeU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TSkrWFIZ9PIkk6c9fvv+bQW+k6T4Hjh7aMdHkEN05Qpf0PGhC50fWM9wfNxj7RlGXPiHVbia9b1ie3+E6YdOONLxmLPhOwRC6xL1hTOcaQI1JeADy2qSEnnXON+Sf+zD0D+rbrlS1fDLWk72CaN2RkhGyfaThx1U1tiryRy6UuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bt9Pezte; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bt9Pezte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78571F00A3D;
	Wed,  9 Sep 2026 09:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945936;
	bh=ntktzkCZD/zA62ovSbQdwWln3gpTQ1TAAbmlD+KiHiY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bt9Pezte1GLk6rZ89B4qOfYnIIuyHvVUnYz2mC4jqpNtfYGgIsEHmca0CWtnWfWqF
	 uKrXs/DS8ymAwU5foMES82q/C2Sa9BZ2luf6zgof2Tfi+b0hJzCp8sIc9QVzGQ/pRr
	 l+fY0yYC3FdZjM15rx3etuc8ZelSZZlR9idaV3OVF2JC+SzTvoTJfxTMqyxT8rLhQf
	 JobZciJ4a+Fs+RcPAgdpSlG12+w/9JtoAJg2rdy+ecZILELcNDA7lcOOySApseOCds
	 /YfdDlUdqQXPg+idVk6EP6RTVhZQje/jD/bdyfMEjfPG51ZslWcsURbTprYg6iN+SL
	 NnzMbd4PC0bQQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] scsi: ufs: core: Hold a clock reference across the
 probe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Naomi Chu" <naomi.chu@mediatek.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260909091045.1134956-1-naomi.chu@mediatek.com>
References: <20260909091045.1134956-1-naomi.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:25:36 +0000
Message-Id: <20260909092536.B78571F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing scsi_remove_host() on the ufshcd_init() error path lea=
ves dangling sysfs references leading to use-after-free.
--

commit a971113b5d6d58a777d3955df4f8947756e7eb86
Author: Naomi Chu <naomi.chu@mediatek.com>

scsi: ufs: core: Hold a clock reference across the probe

This patch modifies the UFS core to take a clock reference as soon as clock
gating is initialized and holds it until the probe finishes or fails. This
ensures register accesses during the probe do not depend on the host state
and prevents them from occurring without a held clock reference.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index ee21388e74f5f..7d63287b5ca94 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -11322,7 +11326,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
> =20
>  	err =3D ufshcd_add_scsi_host(hba);
>  	if (err)
> -		goto out_disable;
> +		goto out_release;
> =20
>  	/* Hold auto suspend until async scan completes */
>  	pm_runtime_get_sync(dev);

[ ... ]

> @@ -11386,6 +11390,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
>  	ufshcd_pm_qos_init(hba);
>  	return 0;
> =20
> +out_release:
> +	ufshcd_release(hba);
>  out_disable:
>  	hba->is_irq_enabled =3D false;
>  	ufshcd_hba_exit(hba);

[Severity: Critical]
This is a pre-existing issue, but does this error path leave the SCSI host
registered in sysfs if a failure occurs later in the initialization?

If ufshcd_init() fails after successfully calling ufshcd_add_scsi_host()
(for example, if ufshcd_link_startup() or ufshcd_verify_dev_init() fails
and jumps to out_release), the function returns an error without calling
scsi_remove_host().

Since the driver probe fails, devres will free managed resources such as
the MMIO region mappings and IRQs. However, the SCSI host would remain
registered in sysfs.

Could a subsequent interaction with these orphaned sysfs nodes invoke SCSI
callbacks that attempt to access the unmapped MMIO base and freed memory,
potentially leading to a use-after-free and system crash?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909091045.1134=
956-1-naomi.chu@mediatek.com?part=3D1
