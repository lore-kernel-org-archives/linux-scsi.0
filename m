Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEAC5AEC6D
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 15:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658285; cv=none; b=C0dGvCJ0h9hykN3RYijliu0ZUR0IB5/lDRaO40Mw1FiM4c06t0vdA/9t3vgt0P+VgQmu2wLuIijl4kaCfVNk5pQwAHX4wX841gREL/dNDpczdvtCBArmVvohibgagApLS1YZneaL4VXzNif69ZgvUqu2R6uta3GzBB4MmDY8iIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658285; c=relaxed/simple;
	bh=23nCL/aH9E8GT4s5ym6LqZfPoiFIfT0b7vJkTXm+DLc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SOP9TkmMacWTbX+ONSZP/Eb6G356hg0Xy6kD3kqU0yXazX/S5Z3Gho8RfEvw6CVIRROZLK+EAIx6mD6xIFXqnoT4S+imk5yhhgIP9BsOqH5Y4QZvNBOSpxEqq+FOtC9dLnWEkKrHULT+gffH0cX+6DN5DGtBSlE+ZTU9UseV6q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EiNS6ypJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EiNS6ypJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C636C1F000FF;
	Thu, 17 Sep 2026 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789658275;
	bh=p3aA7B/dzdVYbu9OOyXWEFSb2j9UK8IAq8AvhYuiEYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EiNS6ypJBBl5yBgSQd9+sIyE+DU+s5ZcrraBziNLIxsC9dccPrjYfkol/+eadrvT+
	 WgNko6Hh4dljvG+/cIzqEXfJpQ5IhS30Lx1HkMtlrK43dGcJOC2fh/PUDoRgzMBVhx
	 xb24mRxqttR90B0ddEKIp79etbmZZNbRd5d69CaMSnBga/iFycFz+QqezHAZBjXF/m
	 SZi6hXaqyEtsF54dcsg58LD9j8pFRfO/kM1pSgcRO1UwTcgCFNfFHzoTCJ1WyVUnTD
	 C6chqDDGAfrtiO/RK73U5CIorekg7ECuJZUE18kv45Za9Pog4d+5zNfkfHIAsNIDd9
	 BCuGzqUQtbtug==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: Fix tgtdev reference count in
 mpi3mr_sastopochg_evt_bh()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Liang" <vulab@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260917150436.2158151-1-vulab@iscas.ac.cn>
References: <20260917150436.2158151-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 15:17:54 +0000
Message-Id: <20260917151754.C636C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: mpi3mr: memory leak in mpi3mr_sastopochg_evt_bh()
--

commit cf5778c62c15425d51079879286e5084420ef1e2
Author: Wentao Liang <vulab@iscas.ac.cn>

scsi: mpi3mr: Fix tgtdev reference count in mpi3mr_sastopochg_evt_bh()

This commit removes an allegedly redundant mpi3mr_tgtdev_put() in
mpi3mr_sastopochg_evt_bh() during SAS topology changes. The patch assumes
that the mpi3mr_tgtdev_put() at the end of the loop is sufficient to release
the reference taken by mpi3mr_get_tgtdev_by_handle().

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 991e29a8d382f..651e5364a7abd 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1895,7 +1895,6 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_=
ioc *mrioc,
>  			if (tgtdev->host_exposed)
>  				mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
>  			mpi3mr_tgtdev_del_from_list(mrioc, tgtdev, false);
> -			mpi3mr_tgtdev_put(tgtdev);
>  			break;

[Severity: Medium]
Will removing this mpi3mr_tgtdev_put() introduce a memory leak of the struct
mpi3mr_tgt_dev?

When a new device is added, the baseline refcount appears to be 2, with one
reference from creation in mpi3mr_alloc_tgtdev(), and one from the list in
mpi3mr_tgtdev_add_to_list():

drivers/scsi/mpi3mr/mpi3mr_os.c:mpi3mr_update_device_info() {
    ...
            mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, true);
            mpi3mr_tgtdev_add_to_list(mrioc, tgtdev);
    ...
}

In mpi3mr_sastopochg_evt_bh(), mpi3mr_get_tgtdev_by_handle() takes a
temporary lookup reference, so the refcount becomes 3.

The call to mpi3mr_tgtdev_del_from_list() will drop the list reference, so
the refcount drops back to 2.

Without the explicit mpi3mr_tgtdev_put() that was removed here, the remaini=
ng
mpi3mr_tgtdev_put() at the bottom of the loop only drops the lookup referen=
ce
taken by mpi3mr_get_tgtdev_by_handle().

Doesn't this leave the initial creation reference permanently held, leading
to a leak of the mpi3mr_tgt_dev structure whenever a SAS target device is
removed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917150436.2158=
151-1-vulab@iscas.ac.cn?part=3D1
