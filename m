Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EFC35DA61
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 19:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791486293; cv=none; b=FO4gYRHdJjH7LTT2AAI4Pgp+usWxftevAalq4pwM8mIB2NGy4mECM/9FYEMI6xRHVdJFlFrTQM9Hc9LnIGSEkFX3ba4G/xIFsv8Lnz7MyBK4ZL1952q9kPgdFZlAt3jxXuCH38IFGfoDW5Oi3dbnUh9Of8U29Gbq4Xm0QHjnK0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791486293; c=relaxed/simple;
	bh=QXG0ltwhYbZ62+DupqzdvBVMjrNfPh3k4Z+aEncDiJA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=I+tI3wfs1XVRdtiDYTh3IRS5u5VtSOp9ig0bTJL/s2Dk+BJdxO96kF5tlVq1MMtPk78h6b7JUBsr8rN1DUCQeR1oKHmGKgZ3LZCedzGtjzZvgZaaXOJ++R8whgObiUEj+x/53ugH4bWMMGAljDbMW0Brzhq3izTZbU9QgfCeePI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fx2v/Jt3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fx2v/Jt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E900E1F000FF;
	Thu,  8 Oct 2026 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791486292;
	bh=GCwtj/cGIcROIy21iFLaG3elHen0tHklnkMZRyxEwCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fx2v/Jt32f9yXUMk0Od11HK9MlRMeaUD+NeuQOab1/tmlT+YsqFZ1NyEFzV+FyuD3
	 XzlDz5KNpa4I5HWf8Q+o510NqIv7k7u1G6/IoTezGqjYcLo1lul2k7rzVtbBkT+13E
	 Wa+KljYVX3urgU7c+RKB+omcQ0/gRvINPyuaT8gTMOepLUBInMZ9WejkhuVmLu+ZOk
	 KvCGIzmXqnLU2Nr522C8g0J4HO9hS+RzwNH0167yuT64yaV2CpbL8VgXmcMV0TKwLE
	 pYqt3F7mEB/aKwihdA5UA8QaEGry0CIUKhs2QpO2vActjmATBduviOsMfUT+SGwV0C
	 gAC7/S/ry9vzA==
Message-ID: <sashiko-outbox-164488@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: elx: libefc: fix resources leak in efcport_init()
 error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haotian Zhang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261008185403.2791781-1-vulab@iscas.ac.cn>
References: <20261008185403.2791781-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 19:04:51 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: elx: memory leak of efc struct in efct_efclib_config() err=
or path
--

commit f7137ee0f9986ee6fc40d031e1433afbe8aa395a
Author: Haotian Zhang <vulab@iscas.ac.cn>

scsi: elx: libefc: fix resources leak in efcport_init() error path
   =20
efcport_init() creates efc->node_pool and efc->node_dma_pool before
allocating efc->els_io_pool. When the latter allocation fails it returns
-ENOMEM without releasing the node dma pool or the node pool, leaking
both.

> diff --git a/drivers/scsi/elx/libefc/efclib.c b/drivers/scsi/elx/libefc/e=
fclib.c
> index dd3e3d0a47614..ceec0e2a0266a 100644
> --- a/drivers/scsi/elx/libefc/efclib.c
> +++ b/drivers/scsi/elx/libefc/efclib.c
> @@ -50,6 +50,8 @@ int efcport_init(struct efc *efc)
>  						sizeof(struct efc_els_io_req));
>  	if (!efc->els_io_pool) {
>  		efc_log_err(efc, "Can't allocate els io pool\n");
> +		dma_pool_destroy(efc->node_dma_pool);
> +		mempool_destroy(efc->node_pool);
>  		return -ENOMEM;

[Severity: Medium]
Does returning an error here result in leaking the efc struct itself?

In drivers/scsi/elx/efct/efct_driver.c:efct_efclib_config(), the efc struct
is dynamically allocated and attached to efct->efcport:

	efc =3D kzalloc_obj(*efc);
	if (!efc)
		return -ENOMEM;

	efct->efcport =3D efc;

When efcport_init() fails, it returns the error without freeing the efc
struct:

	rc =3D efcport_init(efc);
	if (rc)
		efc_log_err(efc, "efcport_init failed\n");

	return rc;

The error handler in efct_device_attach() also skips freeing efct->efcport
or calling efcport_destroy():

efclib_out:
	efct_xport_detach(efct->xport);
xport_out:
	efct_xport_free(efct->xport);
	efct->xport =3D NULL;
out:
	return rc;

Does this leave the efc struct permanently leaked?

>  	}
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008185403.2791=
781-1-vulab@iscas.ac.cn?part=3D1
