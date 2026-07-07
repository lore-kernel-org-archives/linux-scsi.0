Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9209E3876A1
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783405631; cv=none; b=gmnSh0ySGWUbuB/yxbzvyEmFGzjvOzZ1KjyGSPXjE9tlMdQeDFnbZdkykBWxf8m6io9YkdkdBUeQlBhvkRybqV5H7zy4jSJB/RKTPEfmIknw+d1eqez4o8L2KeZQ0xVOfww9yD0k7quQpeMFONcY/dfuvjIFlz/EeQS0rPym2pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783405631; c=relaxed/simple;
	bh=3QJIVZ9xjZGgVLaGA5rdQWUU7rPPiq6XnGaHlb2hQxQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VBWXB3x65/1fH/zVhl1KtywiDzMCItD5qzzGBIP5Ku9S4snuQn4le3FrUEmgf0lPD0U1/Qpf4atYKHlzvJp/w+9cxcyzR+KRIDWEfwmDVo30VeN5CQHN7fOFgkXREPO66/tH8e/w3CKif9PYrrIsy1Kybp8BpimFGQucva/qJk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C41GJpZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C41GJpZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CADA1F000E9;
	Tue,  7 Jul 2026 06:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783405630;
	bh=EdlGgI2hWfkLuCd0SY3oxc/R/G4EK4A4NiOiAu6YVxk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C41GJpZ1wclHmg6TH5llp7ISgUSw6LK3VRuCLFv4PQpS+gnzz3TRuTkKggqqdMpIk
	 pi0vwK88hkD2mshslJGvt9P7BVCONOJnZllRtlj5OIvYJbu55lGRWCI8mVJ3/naznk
	 UsPtsHLwNmglnEP8F3QmCfFKWZYIdoUpiyjTi9X8y4pVgcv690UKLaLWoCiRoMUK0F
	 5PtjvMNEnttDmGvUyoSxNIj2+nKF+M2/3czBWQE1/Nz51/49I0A/fDXXxbxMCVAmOK
	 kue6WoxGqJGeKIOMHTwNRucHN7eJXiok7DdhIbpjLBRlhxmZF3GOy2aVfFelDM1q0K
	 OLpHt3xTS1qdQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 22/88] scsi: qla2xxx: Enable qla2x00_shutdown for
 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-23-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-23-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:27:09 +0000
Message-Id: <20260707062710.0CADA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The driver calls `msleep()` from a timer callback, which executes =
in atomic context, leading to a kernel panic.
- [High] Lockless traversal of the `vp_fcports` lists in `qla2x00_abort_isp=
_cleanup()` can race with concurrent list modifications.
--

--- Patch [22]: [PATCH v3 22/88] scsi: qla2xxx: Enable qla2x00_shutdown for=
 29xx ---
commit 4be7d237f6e5d330b03e0072e4dabaec029ba791
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enable qla2x00_shutdown for 29xx

This patch enables the qla2x00_shutdown behavior for QLA29XX adapters. It
adds an IS_QLA29XX check to the shutdown path to perform firmware abort
cleanup.

> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 146701445485f..5450c40259bf9 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3840,7 +3840,7 @@ qla2x00_shutdown(struct pci_dev *pdev)
>  		qla2x00_disable_eft_trace(vha);
> =20
>  	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha) ||
> -	    IS_QLA28XX(ha)) {
> +	    IS_QLA28XX(ha) || IS_QLA29XX(ha)) {
>  		if (ha->flags.fw_started)
>  			qla2x00_abort_isp_cleanup(vha);

[Severity: High]
This is a pre-existing issue, but does qla2x00_abort_isp_cleanup() safely
handle atomic context?

If a hardware error occurs, qla2x00_timer() can execute in softirq context
and eventually trigger a sleep:

qla2x00_timer()
  qla_wind_down_chip()
    qla2x00_abort_isp_cleanup()
      msleep(20);

Could this lead to a scheduling while atomic panic?

[Severity: High]
This isn't a bug introduced by this patch, but does qla2x00_abort_isp_clean=
up()
safely traverse the vp_fcports lists?

The function iterates over vha->vp_fcports locklessly. It also explicitly d=
rops
vport_slock right before iterating over vp->vp_fcports.

If discovery threads or the dpc_thread concurrently modify these lists, suc=
h as
calling list_del() in qla2x00_free_fcport(), could this race and dereference
freed list nodes?

>  	} else {
>  		/* Stop currently executing firmware. */
>  		qla2x00_try_to_stop_firmware(vha);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D22
