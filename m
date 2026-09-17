Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84D34CDDD9
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 15:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658848; cv=none; b=kep1QnFS6TBujWFuzW1k/0XL4kta61KrUBe9zVOulmFrk3m24FI63GjqXvJ3wX/l4V+j0XcRhwgy7KNrJZT2xRx3QhIi9DfJZqDEe57WqtqS90FNT6/6S8O3Kehfcp6QJfA+aN5huw4c0v7c4jeB9w37Wginmbt5PFj44kcphQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658848; c=relaxed/simple;
	bh=R5xHxU8xpdCtAcCOWVdb7e7O4/8pJ1ZDe3EOOf7NkqQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Pjl84QM64sUNdC00PUiFiAwOZazMyB2V3WLfUZplyGIk81TXvYDpVsSJygA7ajiUfxsqX+iWb87KNTS07swqCqdzrqszXqPxHUvbeexgKZkv2+xnNnCs5q3NEhvnAZfzTfubYOlrCPXqrUr1CE+kfeCB/fVd5XkhsHL14CIdD0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iIYbVizx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIYbVizx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821021F00899;
	Thu, 17 Sep 2026 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789658829;
	bh=rXrRX9T7OxwE8FXYxc+xgotccwXYY/uTNIf7zeBXiNo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iIYbVizxmXM3N3AlnZ/W7EgznBBk/twXYCRsCS/l8GYKi+H7shU3aBmOkL8K1q18p
	 Vch3E6KiU4R0sz74nhRG7ue8VFu7cQDSEROwV1rAF0lK/ByrHRb9v9D9cr7aMRX+Hp
	 h/D0QDydkBbd8qAL+/g/O34BLQ/VneBOnIqTRZUycgbJMxqzhLjtK75+w2Ny0L0dTk
	 lDAN2gS5TmdrirgF9W2W75k7twRCm9Dq46o4TwgI2OQ5Xxetnp/Ujp1e+JwS+xf+4x
	 TfdBjUnVboZYqiqOC4vaMhiXsUdPa1uQeC8CUP6c9V2Iri/+dWUvEXxjy5ekm625aa
	 j+rzOetgDayMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpt3sas: Fix sas_device reference leak in
 mpt3sas_transport_port_add()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917151720.2158664-1-vulab@iscas.ac.cn>
References: <20260917151720.2158664-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 15:27:09 +0000
Message-Id: <20260917152709.821021F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Low] mpt3sas: build failure due to undeclared sas_device_put()
- [Low] mpt3sas: dead code in out_fail path as sas_device is always NULL
--

commit 488cd1fc5aeb3fa9ed5496cf3747de1d6edef41f
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: mpt3sas: Fix sas_device reference leak in mpt3sas_transport_port_add()

This patch attempts to fix a reference leak in the error path of
mpt3sas_transport_port_add() by dropping the reference to sas_device. It
adds a check and a call to sas_device_put() in the out_fail label.

Cc: stable@vger.kernel.org

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3=
sas/mpt3sas_transport.c
> --- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
> @@ -777,6 +777,8 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *io=
c, u16 handle,
>  	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
>  	    port_siblings)
>  		list_del(&mpt3sas_phy->port_siblings);
> +	if (sas_device)
> +		sas_device_put(sas_device);

[Severity: Low]
Does this compile against the current mpt3sas driver? It appears
sas_device_put() is not declared for mpt3sas in this kernel baseline, and
the mpt3sas version of struct _sas_device lacks a reference count. Is this
perhaps a flawed backport or ported from a different driver version?

[Severity: Low]
Can this cleanup branch ever execute? Looking at
mpt3sas_transport_port_add(), when the code jumps to out_fail before
sas_device is assigned, it is NULL.

The only assignment to sas_device is immediately followed by a check that
jumps to out_fail only if sas_device is already NULL:

	sas_device =3D mpt3sas_scsih_sas_device_find_by_sas_address(ioc,
			    mpt3sas_port->remote_identify.sas_address);
	if (!sas_device) {
		dfailprintk(ioc, printk(MPT3SAS_FMT
			"failure at %s:%d/%s()!\n",
			ioc->name, __FILE__, __LINE__, __func__));
		goto out_fail;
	}

Subsequent code, including the sas_rphy_add() call, does not jump to
out_fail on error. This makes the if (sas_device) check mathematically
guaranteed to be false whenever out_fail is executed.

>  	kfree(mpt3sas_port);
>  	return NULL;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917151720.2158=
664-1-vulab@iscas.ac.cn?part=3D1
