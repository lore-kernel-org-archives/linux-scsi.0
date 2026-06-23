Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB9B35F164
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 11:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782215338; cv=none; b=FXIDZAtlf2vSB3uO0d0mwY34RjaImDJ+xnxBvseeExZ8d+xjELF1OPkxEGl2XD3s9W+U05YDkQ243j41r2MO8qEE/RBxajB1wuN83eDwkn0nEXhBEc5Ax52e1e/YZafgd8V886u/udHGTMXqRCeYhnAnwEe/LcEI3X1RxR/bX/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782215338; c=relaxed/simple;
	bh=9Bsy5eJBmNA+DQ+k5WdUBuETXGu4Pbou9OB5siTbnW0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J3pZTcRCvZB/pwe3wO/oNwIW4QFOmjzCGCx0PISavhCp7EyQTwcCGbYHcWqBpw0RBOVmiiOa5amOfie1TpXcQB3X9DSVzd03rzxh2/8mvI4bCNd8AaLwBSbPvZNF2KBOpYuRn5CzhZ6S66+tdGOsrtfFK8K1onFwgomDGop5bU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oybSeRAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oybSeRAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EA41F000E9;
	Tue, 23 Jun 2026 11:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782215336;
	bh=IUMC6VjJ92xhY/mOVTO/P5+ZqyMCoz8dYZmQgu3XfEY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oybSeRAJ+tFEwxyqcHCD4N2DXrnN8XZ/vWoJ8CwZnxyIZ5Kd+MT5uS0aW3zVjzhx+
	 RXHvdBIQxYceWjBj7Z7ZWaRdIW0gB/GpbyATJb9oRMAF68W0DuKz3xrN11ypanku+t
	 5kHA8IlsD5fVCa/H7SSLUSkBwtXGE5kmHdsSnUpnLikIfOD9Z1eBwPnUf1I3bCHnLL
	 8Mofw61BLR++Qkr4LH7iPNULbbuIgSsZkrVfoxqk9HszGxzt2SS1662Fed7p33UFwk
	 3YNCnvFoyW3Uo1DkLR8BUzXXt2e0LNuCXb6A4BUsnxaTcpsRkkwjAI1Xw7ESFgu4QH
	 +qRIcKW669MZw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: libsas: Handle expander discovery allocation
 failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haoxiang Li" <haoxiang_li2024@163.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623112909.2172701-1-haoxiang_li2024@163.com>
References: <20260623112909.2172701-1-haoxiang_li2024@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 11:48:55 +0000
Message-Id: <20260623114856.B9EA41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The return value of `sas_rphy_add()` is ignored in `sas_ex_discove=
r_expander()`, leading to incomplete sysfs registration and kernel warnings=
 during device teardown on error.
--

commit 89b8642b2949851837e884780fd3067fcff48014
Author: Haoxiang Li <haoxiang_li2024@163.com>

scsi: libsas: Handle expander discovery allocation failures

This commit adds error handling for sas_port_alloc(), sas_port_add(), and
sas_expander_alloc() in sas_ex_discover_expander(). It unwinds the
allocated resources to prevent dereferencing uninitialized or NULL pointers.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
> index f471ab464a78b..56c04c4ae8181 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c

[ ... ]

> @@ -926,6 +928,9 @@ static struct domain_device *sas_ex_discover_expander(
>  		rphy =3D NULL;	/* shut gcc up */
>  		BUG();
>  	}
> +	if (!rphy)
> +		goto out_delete_port;
> +

[Severity: High]
This isn't a bug introduced by this patch, but further down in
sas_ex_discover_expander(), the return value of sas_rphy_add() is ignored:

	sas_init_dev(child);
	sas_fill_in_rphy(child, rphy);
	sas_rphy_add(rphy);

If sas_rphy_add() fails (for example, if device_add() fails under memory
pressure), the remote phy is not registered with sysfs.

When the device is eventually removed, or if discovery fails later in this
function, sas_rphy_delete() is unconditionally called:

	res =3D sas_discover_expander(child);
	if (res) {
		sas_rphy_delete(rphy);

Because sas_rphy_delete() calls device_del(), doing this on a device that
failed device_add() violates the driver core API.

Can this trigger a kernel WARN_ON or oops during device teardown? Could we
check the return value of sas_rphy_add() and handle the registration failure
along with these other resource allocation failures?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623112909.2172=
701-1-haoxiang_li2024@163.com?part=3D1
