Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B524ADD91
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785334054; cv=none; b=W5CuqIoiPy4TX5XPj47ZIzGfu00lradcmx7CUVLmXcGwoTIwadWdfZkk4tGhbcoWgwvi1SUziSMBmmd4q93fhkp4Sk46En0m5towmPh3EqwSpHaw0EMQWgk/hOoj6DCPTrvzGA58kuy2H/956RXd0cX52cBSrj98/FaoMxwsg5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785334054; c=relaxed/simple;
	bh=4e+7G7rIzaNc/MfrjzqgTVXu4LG39PHUojZyfUPKZto=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IS6VM/0CsYV67fX8N24sGBFJPfDjcqVgrabv+WAUAGAUnFj15QkP6UAf8/K7xFtkJ77LBUnoXwsEwY/PEmOYewYEIJIJkgJPVwx/94RsUgcDGR+aQusomZmqi/nlcm0XlviIJdo3x3UZf2pgAgLCa99NYK0Xct/cQPWYk5eb4a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jK+IpEBY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jK+IpEBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162A61F00A3D;
	Wed, 29 Jul 2026 14:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785334053;
	bh=/2SDS2IC7OQnOOFAeCH6EIS1iR1W8skUlcs0m/W7oBo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jK+IpEBYTtodQ4RDSTvYnucaivH2rz7RYu0/09BYZX+NIiMyQ7BWz2f2WV2kKudGL
	 Wh38XhzvY1lyWwm9Z8vQ0mZ3xy7tK/lMNl+TfCqWZB3HYepmBKSHlNNOzXT/1G7lyl
	 Uw9cpj3LjjyU1Soik/k8EY5nQV+MSw3dUYMWUpPQRTqltRw7TN+OUulQFuMx3Ut0q5
	 lgJeUtKn4XhEamKFlJ8sob7g18yc1RmLq2KaS9V0A1qb5FVHqNaldu3ujVBIlDuikR
	 JviUXE7lj3nwWyOtQTX5FKavoxqaIEPcTN9S4d6MQdnDYU880mlgcUYm/QfxHonIlt
	 VEqm3x73dsCiw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 14/27] scsi-multipath: support iopolicy
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260729105107.255712-15-john.g.garry@oracle.com>
References: <20260729105107.255712-1-john.g.garry@oracle.com>
 <20260729105107.255712-15-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 29 Jul 2026 14:07:32 +0000
Message-Id: <20260729140733.162A61F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] The struct mpath_head_template 'smpdt' is entirely empty, lack=
ing implementations for logically required callbacks, leading to NULL point=
er dereferences.
- [Low] Missing READ_ONCE() when reading the global `iopolicy` variable, le=
ading to a data race.
--

--- Patch [14]: [PATCH v6 14/27] scsi-multipath: support iopolicy ---
commit f1795dc3e5eb8bb57ed7783aab4a6563ae5c3b62
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: support iopolicy

Add support to set the multipath iopolicy. The iopolicy member is per
scsi_mpath_head structure, and a module param is added so that the default
iopolicy may be set.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 1ec7bf1835de0..593f94aac70e9 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c
> @@ -61,6 +61,23 @@ static const struct kernel_param_ops multipath_param_o=
ps =3D {
>  module_param_cb(multipath, &multipath_param_ops, &scsi_multipath, 0444);
>  MODULE_PARM_DESC(multipath, "turn on native multipath support, options: =
on, off, always");
> =20
> +static enum mpath_iopolicy_e iopolicy =3D MPATH_IOPOLICY_NUMA;
> +
> +static int scsi_mpath_set_iopolicy_param(const char *val, const struct k=
ernel_param *kp)
> +{
> +	return mpath_set_iopolicy(val, &iopolicy);
> +}
> +
> +static int scsi_mpath_get_iopolicy_param(char *buf, const struct kernel_=
param *kp)
> +{
> +	return mpath_get_iopolicy(buf, iopolicy);

[Severity: Low]
Is a READ_ONCE() missing here when reading the global iopolicy variable?

mpath_set_iopolicy() updates the variable using WRITE_ONCE(). Concurrent
reads here could lead to a data race and trigger KCSAN warnings.

> +}
> +
> +module_param_call(multipath_iopolicy, scsi_mpath_set_iopolicy_param,
> +		scsi_mpath_get_iopolicy_param, &iopolicy, 0644);
> +MODULE_PARM_DESC(multipath_iopolicy,
> +	"Default multipath I/O policy; 'numa' (default), 'round-robin' or 'queu=
e-depth'");
> +

[ ... ]

> @@ -204,6 +254,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(=
char *vpd_id)
>  	if (mpath_head_init(&scsi_mpath_head->mpath_head))
>  		goto out_free;
>  	scsi_mpath_head->mpath_head.mpdt =3D &smpdt;

[Severity: Critical]
Since the scsi_mpath_head is initialized with smpdt here, and smpdt appears
to be an empty template, could this lead to NULL pointer dereferences in the
core multipath library?

drivers/scsi/scsi_multipath.c:
static struct mpath_head_template smpdt =3D {
};

The core code unconditionally dereferences these callbacks. For example, du=
ring
path validation:

lib/multipath.c:mpath_path_is_disabled() {
    ...
    return mpath_head->mpdt->is_disabled(mpath_device);
}

> +	scsi_mpath_head->iopolicy =3D iopolicy;

[Severity: Low]
Would it be better to also use READ_ONCE() here when reading the global
iopolicy variable during initialization?

> +	scsi_mpath_head->mpath_head.iopolicy =3D &scsi_mpath_head->iopolicy;
> =20
>  	strscpy(scsi_mpath_head->vpd_id, vpd_id,
>  		SCSI_MPATH_DEVICE_ID_LEN);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729105107.2557=
12-1-john.g.garry@oracle.com?part=3D14
