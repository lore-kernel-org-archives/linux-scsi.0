Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549C2415F06
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 10:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786531416; cv=none; b=ZowZvexL6el4BLsCjfPxeC5empERab+2iEwxuSjwkmMzrRGNE/eK3vgouotKRzhcF9H4LgXFKZlRVdV76yHxpk7si72NYWkcSEqfFJSywICNuPGSeB7WjUAs0nsRH9ipFmRJnjYCYUJclwf3J0cEFis/IkJlYwIjkLu9ctIKFbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786531416; c=relaxed/simple;
	bh=310z6p17UsOYkiuWsFb7TRoWScwLDa8AnZMY7Tlda1s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vDCx/xkVXIL6hG+Ub48+Ir+SkOPTzB+hqe2LoUoFGXPt5gCTGTZMFypxCgLl2I+hNOkklt3r08CPU7diqQaQO0Nt4hEVGMRtWXJj8ltqPQq6zEzVm7456mn5IISOouc1pckLZ8Y0Wjv5Y7WKH7SqkD5u3wMfKUbp64On97axw1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsEQbq51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsEQbq51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC5E1F000E9;
	Wed, 12 Aug 2026 10:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786531415;
	bh=WZbfH97hMiQW3oqoZ/Wrr+aEDVFSwl5gT5O8AWae5Bw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MsEQbq51C1gjL64wAn/A8g0BfNVHNKScMetI5OoOhcYBBlJ3j0QnJinc5FoT53dIa
	 0EzpRSF+iTwMVKrT0qvvl3/Hfp1p5zxHssEVCmo4lJiEbXXB/VunrOeRse47PFIQLR
	 gpyS+HZfylvKNvhtnjaD7Lgbm7GGjdM5tZSnQ5Mp2M5ue3ypxNuzeg5Z6ciQP3TxVt
	 rWRpZLNC8/VDoU8B3jbKPG483BreCyyuHMoeuIcEfjYfbz6+d6+L5I8Y9tnYnWAJLt
	 LqqjpjLl+zvn6KhFy+u9juUN9kbHfNnyMBWAJsMRvWbdRARiioLyd8QZlSJM7rK72j
	 p/UQmVwuGJx3A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: mpi3mr: Fix NULL pointer dereference in
 mpi3mr_sas_port_add()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Milan P. Gandhi" <mgandhi@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812103344.174247-2-mgandhi@redhat.com>
References: <20260812103344.174247-1-mgandhi@redhat.com>
 <20260812103344.174247-2-mgandhi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 10:43:34 +0000
Message-Id: <20260812104334.CDC5E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing NULL check for the return values of sas_end_device_alloc()=
 and sas_expander_alloc().
- [High] Ignored return value of sas_rphy_add() leads to a resource leak an=
d invalid system state.
--

--- Patch [1]: [PATCH 1/2] scsi: mpi3mr: Fix NULL pointer dereference in mp=
i3mr_sas_port_add() ---
commit 52d7de23ae9ec8ed8dec5b684daecf405f00a60e
Author: Milan P. Gandhi <mgandhi@redhat.com>

scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()

sas_port_alloc_num() can return NULL on memory allocation failure, which
causes a NULL pointer dereference when passed to sas_port_add().
Additionally, if sas_port_add() fails, the allocated port is leaked.
This patch adds a NULL check and calls sas_port_free() on failure.

> diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr=
/mpi3mr_transport.c
> index 240f67a8e2e3b..ea2c04384a0e1 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
> @@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add=
(struct mpi3mr_ioc *mrioc,
>  	}
> =20
>  	port =3D sas_port_alloc_num(mr_sas_node->parent_dev);
> +	if (!port) {
> +		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
> +		    __FILE__, __LINE__, __func__);
> +		goto out_fail;
> +	}
>  	if ((sas_port_add(port))) {
>  		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
>  		    __FILE__, __LINE__, __func__);
> +		sas_port_free(port);
>  		goto out_fail;
>  	}
> =20

Further down in drivers/scsi/mpi3mr/mpi3mr_transport.c:mpi3mr_sas_port_add(=
):

	if (mr_sas_port->remote_identify.device_type =3D=3D SAS_END_DEVICE) {
		rphy =3D sas_end_device_alloc(port);
		tgtdev->dev_spec.sas_sata_inf.rphy =3D rphy;
	} else {
		rphy =3D sas_expander_alloc(port,
		    mr_sas_port->remote_identify.device_type);
	}
	rphy->identify =3D mr_sas_port->remote_identify;

[Severity: High]
This isn't a bug introduced by this patch, but does this code lead to a NULL
pointer dereference if memory allocation fails? If sas_end_device_alloc() or
sas_expander_alloc() returns NULL, it appears we dereference rphy directly =
on
the following line without checking it.

	if ((sas_rphy_add(rphy))) {
		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
		    __FILE__, __LINE__, __func__);
	}

[Severity: High]
This is a pre-existing issue, but does ignoring the return value of
sas_rphy_add() here lead to resource leaks and invalid system state?

The failure is only logged, and execution continues without aborting or
cleaning up the rphy. If we leave an unregistered device in the state
structures, could it cause an oops during teardown?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812103344.1742=
47-1-mgandhi@redhat.com?part=3D1
