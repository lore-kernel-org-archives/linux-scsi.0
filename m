Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CCC4C10F4
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658364; cv=none; b=Oa7gFD7QlwP0TVBBHTRwvUmAATEcP9Q8ScofsDmJdik7RSrvMLcnMUmT7uZPdEGIcRyOhlotfWfJ6TFoRJqCXd/4q/ul5RGJGA/VNXI3NEUM4hWP8cuqWxDDQSBegQtl+pRiroWAN5FRHmLfhmToE5Yaofaw7H/08i+7CiuO+/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658364; c=relaxed/simple;
	bh=noUVGUQYTaUwGyCJJ0YumK6UHA1In2urpk1i2ug3dTY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FCKg7KBYo81YWSDJJ2clwUacRcOrO4Fhz1kW3ovgSVnqAG59dcqwFml6AEWGjHNJylLEK2Qna1uSqAvtNKlN21ru0BopNyCOJljWpW0VmK9CBMYR0pGTwMN5so0eEQA/xDqc/Uxequx+xj32PepO9FRKll0j+9AUtx/XZY9TS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ncA69vZ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ncA69vZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCBE1F000FF;
	Thu, 17 Sep 2026 15:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789658351;
	bh=s3Zz7EARhGbeAQ0sw7v7lzOikIwzlmv4cBBoAu1qIIM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ncA69vZ4ZKzCrybyaoTKLfnlg5CnwKIH2ywRAgULFV10IWKnMSjb1Fvx3QhEFHHT/
	 WlZgZVLuKQqvsDEneYEAO5nIoZDSPddF6fzDciUTEKrhj7hNFvqyTs5etB+3oq9CwN
	 xi0TanLKIlmGZuQiCFK7Bubv0VPDIMRDjyIfk8F/5R/yVRrn4BtHf5OjyNjlXjEnFz
	 QtDTaCei7PFe9JWXhzFq11rvDCk4nlhU3yUNBQZh0viOrubTwpXwlDfZ1oLm80BaNG
	 3N9OnsyFv+VlXDydczpDPT0/Fv+nSWw/iz/v0KnJo3gsRwmK011vjDDRBBXQ/R3zHH
	 OuA0UnEMA/Y6Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: Fix tgtdev reference count in
 mpi3mr_pcietopochg_evt_bh()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917150301.2158080-1-vulab@iscas.ac.cn>
References: <20260917150301.2158080-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 15:19:10 +0000
Message-Id: <20260917151910.DBCBE1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: mpi3mr: memory leak of tgtdev on PCIe removal due to removed=
 kref put
- [High] scsi: mpi3mr: incomplete fix leaves double-put UAF vulnerability i=
n SAS and status handlers
--

commit a438077929efbcec320166774a755489ffa128b2
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: mpi3mr: Fix tgtdev reference count in mpi3mr_pcietopochg_evt_bh()

This patch drops an extra put in the PCIe topology change event handler
that previously dropped the reference twice. This is intended to fix a
premature release of the target device kref.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 991e29a8d382f..d6414d0186183 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2053,7 +2053,6 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr=
_ioc *mrioc,
>  			if (tgtdev->host_exposed)
>  				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
>  			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
> -			mpi3mr_tgtdev_put(tgtdev);

[Severity: High]
Does removing this explicit put leak the tgtdev structure?

The device structure tgtdev is initialized with a refcount of 1 upon
allocation, and a second reference is taken when it is added to the internal
list. In mpi3mr_pcietopochg_evt_bh(), mpi3mr_tgtdev_del_from_list() drops t=
he
list reference.

By removing this explicit put, doesn't the object end up with a stranded
refcount of 1 after the event handler drops its loop-local handle reference
at the end of the iteration? This appears to result in a permanent memory
leak on standard hardware hotplug paths.

>  			break;
>  		default:
>  			break;

[Severity: High]
Does this fix leave the same double-put vulnerability in the SAS and status
handlers?

The patch aims to fix a premature reference release by removing the explicit
put in the PCIe topology handler. However, looking at the source, the exact
same reference-dropping sequence remains in mpi3mr_sastopochg_evt_bh() and
mpi3mr_devstatuschg_evt_bh(). For example:

mpi3mr_devstatuschg_evt_bh() {
    ...
    if (cleanup) {
        mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
        mpi3mr_tgtdev_put(tgtdev);
    }
    ...
}

If a device fails to be removed from the list (e.g., state is not
MPI3MR_DEV_REMOVE_HS_STARTED), these handlers unconditionally drop the base
reference while the object remains in the list.

Later, when the device is actually removed from the list (such as during
mpi3mr_refresh_tgtdevs()), wouldn't the refcount drop to 0 prematurely,
causing a use-after-free during the subsequent put? Should these other
equivalent handlers be updated to properly address this sequence as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917150301.2158=
080-1-vulab@iscas.ac.cn?part=3D1
