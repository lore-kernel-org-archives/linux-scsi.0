Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3086339714
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783080518; cv=none; b=OLko7AcM+L8pCCWeT1uHmtGgq540udFxy615p8ijbEOytx1yrscMgGf2wHLBy+N81yMSC6iSgKKV+x96KMfiOPRQkFBrUtw/d3YsNz1CnyodheZ1JCfFhZt0JSmxUaLw6uXQvXk0FNNvjG5u0aScEYI26i3iFDzhgVPzq0OiVcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783080518; c=relaxed/simple;
	bh=mxP+GBUDCMkwBUfPSpm7jnV60S0d8IQyuNWYWHj/fEQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uC4XzImcpmoLqDqrgNSCwsxtk8g3Nphf0fwHbISv/+U4OFn/3pW8M9ZhfnshsD4QLXUYQTeLAZgSDrHfqw9Cjbsy8OtIXUfAb7FiYSGnDCdZESNdtwI64dP7bncwwFu6oOxUHPr7Jj5RV3ITTfa6E65zV19Ymqdp5GQNR1+Q8Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pd+jKcmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pd+jKcmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6661F000E9;
	Fri,  3 Jul 2026 12:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783080517;
	bh=ON7QXCPMa1W/r1OHUc6vK8JSRaISh1zfqTOiNx2nRog=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Pd+jKcmIT3NjrVr3Y6fFsaeaTBXacStG8eOQ3GtjdnkHkkc28uLS3PLQjml1ebvu/
	 gYDmEHYitb/wiVWuBOM4nmXU/QVcGiBaMjeic3qEq+5s9zDEZwbQ8SuJjSg08jcWFz
	 n71bfWHXG7fgcrUzphcvTbBz2uH8VmGaKJB/rwR6e/PQRLZQgXQLKKW0jhSt4InsVM
	 PdLoy1M8YfVC0NV1U4yWJ/ALTBSuaVVASJfuXBmZ1hCfP5J90BugxbNQBmYrVlHVUg
	 7pDwm80H1dGaw7sOgp2Yy2wwGsGVzAQWDST8+qCJdxY/BsyoLlmt5jIvQc47Q5/G5H
	 LsSSH9bMEknPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 11/17] scsi-multipath: add delayed disk removal
 support
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-12-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-12-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 12:08:36 +0000
Message-Id: <20260703120837.6C6661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Memory leak during module unload due to flawed bus driver broadcas=
t for delayed removal.
- [Medium] Use-After-Free (UAF) hazard during SCSI driver iteration because=
 the iterator continues after the structure is freed.
--

commit b2a49437af44776426456e634c1ad321526ae49c
Author: John Garry <john.g.garry@oracle.com>
scsi-multipath: add delayed disk removal support

This commit adds core support for delayed disk removal in SCSI multipath.=20
It introduces a new scsi_driver callback to handle the removal work,=20
ensuring that the driver maintains a reference to the multipath device while
active.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

> @@ -355,7 +355,25 @@ static bool scsi_mpath_available_path(struct mpath_d=
evice *mpath_device)
> +static int scsi_mpath_remove_head_drv(struct device_driver *drv, void *d=
ata)
> +{
> +	struct scsi_mpath_head *scsi_mpath_head =3D data;
> +	struct scsi_driver *scsi_driver =3D to_scsi_driver(drv);
> +
> +	if (scsi_driver->mpath_remove_head)
> +		scsi_driver->mpath_remove_head(scsi_mpath_head);
> +
> +	return 0;

[Severity: Medium]
Is there a potential use-after-free hazard during the bus iteration here?

When a device hot-unplug triggers delayed head removal, the sd driver will
process it and drop the final reference to the scsi_mpath_head structure,
freeing it.

Because this iterator callback unconditionally returns 0, bus_for_each_drv()
will continue iterating through other registered SCSI drivers (like sr).

Could this result in passing a freed scsi_mpath_head pointer to subsequent
drivers in the iteration? Should the iteration abort once the target driver
successfully handles the removal?

> +}
> +
> +static void scsi_mpath_remove_head_work(struct mpath_head *mpath_head)
> +{
> +	bus_for_each_drv(&scsi_bus_type, NULL, to_scsi_mpath_head(mpath_head),
> +		scsi_mpath_remove_head_drv);

[Severity: High]
Can this leak memory during module unload?

When the sd module is unloaded, driver_unregister() calls bus_remove_driver=
(),
which removes the driver from the bus's klist_drivers list before calling
driver_detach() to unbind devices.

If detaching the devices triggers a delayed removal of the multipath head,
this workqueue executes and attempts to find the responsible driver by
broadcasting to all drivers on scsi_bus_type. Since the sd driver was alrea=
dy
removed from the bus list, the iterator fails to find it.

Does this cause the targeted mpath_remove_head callback to be missed,
permanently leaking the scsi_mpath_head and sd_mpath_disk structures?

> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D11
