Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF1930E0EE
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 05:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790312587; cv=none; b=sDgLr33Nke8vUqzuC9o99BXWNW6c3Phw/ElHa51wx9VKnEQXWgIk232uEIz7lFLgNP4vxZsZ2vU8FGCXtPFM8It8vjW51AxsxyxlgbTvhPZTdQwGyKkc5ib9B/2x9g3Rwnwb5ofGoDUuNwq9OAoF/kw3ohguFy3d7K21d7AVS18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790312587; c=relaxed/simple;
	bh=U+ossEQ7+QdN36XUPxhjOaee2wSM6W+PPD/RxqHjrQA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ex2Cb8VESGNfm8QHV6G6sr8mm6nGgBk4c5JDSodOB+Vj7vwXGdZ3pe4wR6zdnh9yGbR6jhvGaKgHjumEN1J5Usb4mp2NRK91xUthNgedEjyPeIqllt7OI4LjVI3mclVIVxv2r9/MWwkZvJi/wRXU2uRvgqDgtALlLJOK15kBR6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMlWKdIn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMlWKdIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F20E1F000FF;
	Fri, 25 Sep 2026 05:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790312585;
	bh=LvplY4Y0eXNaaeXRGy2smURAMDSpOBBZY8VgD2BzJAA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AMlWKdIncJfJI7Ka01OQLC/dY+4s6lTcDSQLuerNOBzuTzUK+thjeR8AziD1d8HSn
	 z0r0mZ8yUQ5B4CfpKH3+dw6bmkOR7LKI7l6s4cRwKrrru529Lx5IspR/mdkVYDPJ1I
	 Zn2Wh+qOBYEVQ/d3s6dnHaCHO77GuhKFQiA+boanSB6Vtqr7Uyx8N8eX8wlq6EE9kv
	 exLMOxhZAFxd4AD7CnZCfbPxI3uq2TJSdSpm/6dZF4Ars/JETUuSj8V9UQ5DUztx4/
	 dFk0UX5HCtkoaL9NKjFYWb/QX5POPCJK+lHfC2t4OQGIDkl8yRZFqNJNF/IZkDlC1M
	 b51B5pHDbGZwQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 04/11] scsi: ibmvfc: add basic FPIN support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260925044900.414340-5-tyreld@linux.ibm.com>
References: <20260925044900.414340-1-tyreld@linux.ibm.com>
 <20260925044900.414340-5-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 25 Sep 2026 05:03:04 +0000
Message-Id: <20260925050305.6F20E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] scsi: ibmvfc: missing scsi_host_put() in test success path
- [Medium] scsi: ibmvfc: missing host_lock around ibmvfc_handle_async() in =
KUnit test
--

commit 29ab8a9a78c94679b8187ae357d2978336830599
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: add basic FPIN support

Implement support for a basic level of Fabric Performance Impact
Notifications (FPIN) in the ibmvfc driver to enable monitoring of
fabric congestion and link integrity events. This includes async event
handling and KUnit test infrastructure.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi=
/ibmvfc_kunit.c
> new file mode 100644
> index 0000000000000..ec52285b0aa22
> --- /dev/null
> +++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
> @@ -0,0 +1,149 @@
[ ... ]
> +static void ibmvfc_async_fpin_test(struct kunit *test)
> +{
[ ... ]
> +	vhost =3D ibmvfc_get_first_vhost();
> +	if (!vhost)
> +		kunit_skip(test, "No ibmvfc devices available");
[ ... ]
> +	for (fs =3D IBMVFC_AE_FPIN_LINK_CONGESTED; fs <=3D IBMVFC_AE_FPIN_CONGE=
STION_CLEARED; fs++) {
> +		ae[fs].valid =3D 0x80;
> +		ae[fs].link_state =3D IBMVFC_AE_LS_LINK_UP;
> +		ae[fs].fpin_status =3D fs;
> +		ae[fs].event =3D cpu_to_be64(IBMVFC_AE_FPIN);
> +		ae[fs].scsi_id =3D cpu_to_be64(tgt->scsi_id);
> +		ae[fs].wwpn =3D cpu_to_be64(tgt->wwpn);
> +		ae[fs].node_name =3D cpu_to_be64(tgt->ids.node_name);
> +		ibmvfc_handle_async(&ae[fs], vhost);

[Severity: Medium]
Does this invocation of ibmvfc_handle_async() need to be protected by
the host_lock?

If a concurrent device removal via ibmvfc_remove() sets vhost->state to
IBMVFC_HOST_OFFLINE and destroys fpin_workq just before this handles the
async event, could queue_work() be called on a freed workqueue?

> +		ae[fs].valid =3D 0;
> +		wmb(); /* ensure valid bit clear is visible before checking stats */
> +	}
> +	flush_workqueue(vhost->fpin_workq);
[ ... ]
> +	ae[0].valid =3D 0x80;
> +	ae[0].link_state =3D IBMVFC_AE_LS_LINK_UP;
> +	ae[0].fpin_status =3D 0; /* bad value */
> +	ae[0].event =3D cpu_to_be64(IBMVFC_AE_FPIN);
> +	ae[0].scsi_id =3D cpu_to_be64(tgt->scsi_id);
> +	ae[0].wwpn =3D cpu_to_be64(tgt->wwpn);
> +	ae[0].node_name =3D cpu_to_be64(tgt->ids.node_name);
> +	ibmvfc_handle_async(&ae[0], vhost);

[Severity: Medium]
Is the host_lock similarly required around this call to
ibmvfc_handle_async() to prevent a use-after-free if the device is
concurrently unbound?

> +	ae[0].valid =3D 0;
> +	wmb(); /* ensure valid bit clear is visible before checking stats */
> +	flush_workqueue(vhost->fpin_workq);
[ ... ]
> +	kref_put(&tgt->kref, ibmvfc_release_tgt);
> +	put_device(&rport->dev);
> +}

[Severity: Medium]
Does this successful exit path leak the Scsi_Host reference?

The call to ibmvfc_get_first_vhost() at the beginning of the test acquires
a reference via scsi_host_get(), but unlike the error return paths, there
doesn't appear to be a corresponding scsi_host_put() call here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925044900.4143=
40-1-tyreld@linux.ibm.com?part=3D4
