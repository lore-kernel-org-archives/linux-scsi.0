Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15953487BE;
	Thu, 11 Jun 2026 03:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781146877; cv=none; b=UL8I9uCgYtvx7Yjb0E/7Zg+N3i8Ufdl6OZCSjj6vY+Lt8nDsyBlsBY6nQ7EWxNn7nkUxkiJZWeUV2lepVnlNbK8w6nvljCFtHdqkoWUOa+wKPuMHuUUkn+MwJykHzlCu8F/ey8bSK+3U8gCNVd7GE4dS3NlTS3f9ruy9Sg+7ALg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781146877; c=relaxed/simple;
	bh=s9nKYW69tWH40M0eXj7Lleiik2sM1Epppa1vGyR+8Gs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hbMGruDWrf9I1ab53N7kc+jMGbTaXxVhSwQer4L8tPi5ernqaVH/muDN3FJEYRTn8My59SA3yo2jcjaF1Es77GWpPh6oK9Y+YerP/IdPIBtkapDRa91rLxpQVRtba/Ns2zw+7voj3nRhsvJYZoXmKH/aTk/JeIHK/QKx67o1FEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gi3F19aU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gi3F19aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A1A1F00893;
	Thu, 11 Jun 2026 03:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781146875;
	bh=ksIIfWxITKO+irJWA3W5IuUhP9eX9Y9lfFFHMKOUOZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Gi3F19aUIE1kqCPgatNBxBsPg3S6FKlI1oMYZv6LCDCp/0lIuvbAaunGk5BgwZRcd
	 NJiro5uR0YEyP8/Zi2BfYJYMx1JzOYL54Viub7r74jFjo/T7j09o5Ql2y0redrNqw/
	 PI9W7ZmxABBhYGqVD03qBIjldFtY1yxMC7K+H4x+V7arV8iy08Sd198Yl0Q7aN2MfB
	 15fFS02FvWhpP4HAmFPFqTrNHp7rWH88ESDyv/iBC7IKVl7STDu8jO/zeXgDBzGiHB
	 WJCKhDeZg9SycHBygARjZxn13MU/GBlEZeDckACpqkQ2EBi5ca/ftIBqp/wrpC3mQR
	 aLntpd1NtXeoA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 5/6] ata: libata-scsi: probe additional LUNs for
 multi-LUN ATAPI devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260611024356.2769320-6-philpem@philpem.me.uk>
References: <20260611024356.2769320-6-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Jun 2026 03:01:15 +0000
Message-Id: <20260611030115.77A1A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A Time-of-Check to Time-of-Use (TOCTOU) race condition exists betw=
een checking `dev->sdev[0]` in `ata_scsi_scan_host()` and re-fetching it in=
side `ata_scsi_assign_ofnode()`, potentially leading to a NULL pointer dere=
ference.
--

commit 67ae5925dcb0647224ec016d88000305f0e5c2f2
Author: Phil Pemberton <philpem@philpem.me.uk>

ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices

This commit probes additional LUNs for ATAPI devices with the BLIST_FORCELUN
flag by triggering a sequential LUN scan. Non-responding LUNs are silently
skipped. It also attempts to fix a TOCTOU window by calling
ata_scsi_assign_ofnode() before releasing the scsi_device reference.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2e3b5fd41d05f..64cb2860a67b1 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
[ ... ]
> @@ -4754,13 +4755,27 @@ void ata_scsi_scan_host(struct ata_port *ap, int =
sync)
[ ... ]
> +			if (dev->class =3D=3D ATA_DEV_ATAPI &&
> +			    sdev->sdev_bflags & BLIST_FORCELUN &&
> +			    !WARN_ON_ONCE(ap->scsi_host->max_lun > ATAPI_MAX_LUN))
> +				scsi_scan_target(&ap->scsi_host->shost_gendev,
> +						 channel, id, SCAN_WILD_CARD,
> +						 SCSI_SCAN_RESCAN);
> +			if (dev->sdev[0])
> +				ata_scsi_assign_ofnode(dev, ap);

[Severity: High]
This is a pre-existing issue, but does holding the scsi_device reference
actually prevent the TOCTOU race here?

While this patch holds the scsi_device_put() until after the call to
ata_scsi_assign_ofnode(), a concurrent sysfs hot-unplug can trigger
scsi_remove_device(). This unconditionally calls ata_scsi_sdev_destroy(),
which safely acquires ap->lock and sets dev->sdev[0] =3D NULL, regardless of
the scsi_device refcount.

If dev->sdev[0] is cleared right after the unprotected if (dev->sdev[0])
check, the re-fetch inside ata_scsi_assign_ofnode() will return NULL:

drivers/ata/libata-scsi.c:ata_scsi_assign_ofnode() {
    ...
    struct scsi_device *sdev =3D ata_dev_scsi_device(dev, 0);
    ...
    sdev->sdev_gendev.of_node =3D child;
    ...
}

This would lead to a kernel panic when dereferencing sdev.

Could the local sdev pointer be passed directly to ata_scsi_assign_ofnode()
instead of re-fetching it from dev->sdev[0]?

> +			scsi_device_put(sdev);
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260611024356.2769=
320-1-philpem@philpem.me.uk?part=3D5
