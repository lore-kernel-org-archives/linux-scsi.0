Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4A23CD8A9
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2026 09:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786611753; cv=none; b=kXpkaVcH6tughKLz7tAHoZy9+PTV0r7dK77wEd4/CUt/t1X80YJm0Js6LSfg90cyMUcX/HL/3CWUeltYZOQhturivXfdQ37uJegVUwkWZxvizuaOH5m+P/AX6mIJD/7EzJAIfMfHO/x2or9LoWRHP+YDd1eKPyQi5Fylv76oIC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786611753; c=relaxed/simple;
	bh=CQUALL2zL8/MiG5C+D/ZM0G7Om+YVHo6q67xBdXGV0Y=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KBoblolJxPMSptNDqnLXaNTYh2tUKFOKpNqKdcHh/TXbc495xz09pMmf/7nZntuiVoByXekhCRIzIq4YaU/eIic8vIzZ8+MC1tbRSb4ZAILo9PJpLhHemafq8DaDS8+Bcj6K8TtfB1eNJPybU8xolkhfTzz5P/bK5LAcHs3pqWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0qTuM6q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0qTuM6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1BF1F000E9;
	Thu, 13 Aug 2026 09:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611751;
	bh=zrxIs7XfAjZdYN0qjFiqgZlv72eOd7fi7MP0eKPoQuc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a0qTuM6qCallJAzEEt4CH4S+ZhGumjBOCUnlHyBJuHMhrZb86U/OHZJo0uXFPW9RA
	 fhpr3ipJJYQAmEdqIpDEfkG5hf+DuEdkdUFw1yQ/j+EIu50zIkC5V0xMjIn70AYxKQ
	 sH6vi9icAKgo4R3aGp7sFKUahdqyS/p6MPFh6mo9RQUVSy2nk04k+dn6fy6LC9/L7S
	 4DL+u44jGo5zDhKKNDV/H7o0JiA0+Pf8RzP97RCH4Tc3UzD7ImL86/ffvwm/y1KNCP
	 R9qzkdx6ohz+LjutfyGb2Bz8FqXw4U9zxbhk9pv8JQLKsAkKLB9cd5o01hVWQ9eRhV
	 uFfrmXtaL4pcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: virtio_scsi: set DRIVER_OK before registering the
 SCSI host
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jasper Wise" <jaspwise@amazon.co.uk>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260813084405.610322-1-jaspwise@amazon.co.uk>
References: <20260813084405.610322-1-jaspwise@amazon.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 13 Aug 2026 09:02:31 +0000
Message-Id: <20260813090231.AF1BF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Preexisting Use-After-Free in the SCSI error handler or block laye=
r when `scsi_add_host()` fails after a concurrent sysfs scan.
--

--- Patch [1]: [PATCH] scsi: virtio_scsi: set DRIVER_OK before registering =
the SCSI host ---
commit 58209fcc60c7b4a593d3a3456eb44d5ff9a7db6b
Author: Jasper Wise <jaspwise@amazon.co.uk>

scsi: virtio_scsi: set DRIVER_OK before registering the SCSI host

This commit alters the virtio-scsi device initialization to set DRIVER_OK
prior to calling scsi_add_host(). It also updates the probe error handling
to ensure the device is correctly reset if host registration fails.

> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
[ ... ]
> @@ -991,7 +991,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	return 0;
> =20
>  scsi_add_host_failed:
> -	vdev->config->del_vqs(vdev);
> +	virtscsi_remove_vqs(vdev);

[Severity: High]
This is a pre-existing issue, but could this error path trigger a
use-after-free if scsi_add_host() fails?

When scsi_add_host() runs, it calls scsi_add_host_with_dma(), which exposes
the scan sysfs attribute via device_add():

drivers/scsi/hosts.c:scsi_add_host_with_dma() {
    ...
    error =3D device_add(&shost->shost_dev);
    if (error)
        goto out_del_gendev;
    ...
}

If a subsequent initialization step inside device_add() fails,
scsi_add_host() will unwind and return an error.

If a concurrent write to the scan attribute happens before the unwind,
scsi_scan_host_selected() can create child SCSI targets. Because
scsi_add_host() does not reap these concurrently created children on its
error path, they remain orphaned.

If we proceed to free the virtqueues here via virtscsi_remove_vqs(),
could a later SCSI error handler invocation such as virtscsi_abort()
dereference the freed virtqueues?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260813084405.6103=
22-1-jaspwise@amazon.co.uk?part=3D1
