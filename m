Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DA4489865;
	Fri, 31 Jul 2026 22:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535829; cv=none; b=T/IOnciZyJrG6+ZouwJxPiYWW2A8b0/8XzBEosxe4y03dA+zboOTG8MZ07HGDQQpb9yPrcvmZ2ezQRoxO5sIgAZ/PBQTWwxI3Yw43F8FORrEoaXoOrXw7qR+8bjukkh4hPlolVfpEN8JIRRoOc3riqQy/8jHLF6LLhXXt3e7aUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535829; c=relaxed/simple;
	bh=mV+qY/hoUwGksHRC7f/gFd/AUJA1NtcagLUrzJ3cBSU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ATBsOFHZXDTIN41LvcYZWJNmlpP0UFDPJ70pA1thTf/O/BHLN2M6C/TfDgOLNSZwv9CqANtyOyFoPiXDTqQxWToOSIMfEUo7lUlgDRdtbnS6TuIeO9SuTsX+/lhra6BUaUPRXK7eoT3z2hmQzNWtUIq/IEOlxpaSaC4Y0SEDzJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0eLV0oq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0eLV0oq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79171F00AC4;
	Fri, 31 Jul 2026 22:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785535828;
	bh=AktDJI4TgrD5LFArb6n0tV9OlLJi/kcb+NPBOGbRZQ4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S0eLV0oq9BSB+Ij3oLQsptn3ZifYt4LRoLe8jOzNpFA2L2X6eJ+vMnBByVL+e32yt
	 TZKkKN4/M7lOBDYX6GiksQAfGpI5dkRTuKVLBPrAcMRjQIUlBvUhfzwWPBcNlLGS5d
	 CzBB9XhcD2L2/yDBa0D3jtEy8++/9xha4aKBAm+zW2BL2SaUfetVIB1h5rCT9ZpwZh
	 5Ml2ijXADqXFyq86qM4qPq3JI7wxPgwhXezdGojiBb4yVaHyJ1+UmvbiSRSKK/l0OF
	 ct7rlZGOUX6yp/BetccDI1kBC9ZP6fkFNCW1IjX118NhtxJ26elE1wmLG0jzt1rOAq
	 Yw8HkbxQ/GKqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/6] ata: libata-scsi: probe additional LUNs for
 multi-LUN ATAPI devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: dlemoal@kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260731213503.2379771-6-philpem@philpem.me.uk>
References: <20260731213503.2379771-1-philpem@philpem.me.uk>
 <20260731213503.2379771-6-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 22:10:27 +0000
Message-Id: <20260731221027.B79171F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A Time-of-Check to Time-of-Use (TOCTOU) race condition exists betw=
een checking `dev->sdev[0]` and dereferencing it inside `ata_scsi_assign_of=
node()`, potentially leading to a NULL pointer dereference.
--

--- Patch [5]: [PATCH v8 5/6] ata: libata-scsi: probe additional LUNs for m=
ulti-LUN ATAPI devices ---
commit 26698e8a692fea36d598b32f39fd7513b22c4cf9
Author: Phil Pemberton <philpem@philpem.me.uk>

ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices

This commit checks the BLIST_FORCELUN flag after LUN 0 is added for an ATAPI
device. If set, it triggers a sequential LUN scan for that target using
scsi_scan_target() to probe additional LUNs. It also moves the call to
ata_scsi_assign_ofnode() before scsi_device_put() to hold the device refere=
nce.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 0b1e4842860c1..5bbb3169bea70 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c

[ ... ]

> @@ -5281,13 +5282,27 @@ void ata_scsi_scan_host(struct ata_port *ap, int =
sync)
> =20
>  			sdev =3D __scsi_add_device(ap->scsi_host, channel, id, 0,
>  						 NULL);
> -			if (!IS_ERR(sdev)) {
> -				dev->sdev[0] =3D sdev;
> -				ata_scsi_assign_ofnode(dev, ap);
> -				scsi_device_put(sdev);
> -			} else {
> +			if (IS_ERR(sdev)) {
>  				dev->sdev[0] =3D NULL;
> +				continue;
>  			}
> +
> +			/*
> +			 * For multi-LUN ATAPI (BLIST_FORCELUN), trigger a
> +			 * sequential scan for this target.  pdt_1f_for_no_lun,
> +			 * set during LUN 0 configure, ensures non-responding
> +			 * LUNs are silently skipped; dev->sdev[] is populated
> +			 * by ata_scsi_dev_config() during the scan.
> +			 */
> +			if (dev->class =3D=3D ATA_DEV_ATAPI &&
> +			    sdev->sdev_bflags & BLIST_FORCELUN &&
> +			    !WARN_ON_ONCE(ap->scsi_host->max_lun > ATAPI_MAX_LUN))
> +				scsi_scan_target(&ap->scsi_host->shost_gendev,
> +						 channel, id, SCAN_WILD_CARD,
> +						 SCSI_SCAN_RESCAN);
> +			if (dev->sdev[0])
> +				ata_scsi_assign_ofnode(dev, ap);

[Severity: High]
This is a pre-existing issue, but does this check leave a race condition wh=
ere
concurrent device removals can cause a NULL pointer dereference?

In ata_scsi_scan_host(), the lockless if (dev->sdev[0]) check is evaluated
after releasing shost->scan_mutex (which was temporarily held by the preced=
ing
scsi_scan_target and __scsi_add_device calls).

Concurrently, a hot-unplug event can trigger ata_scsi_remove_dev() on a
workqueue, which takes the scan_mutex and sets dev->sdev[0] =3D NULL.

If this concurrent removal occurs exactly after the check but before
ata_scsi_assign_ofnode() re-reads dev->sdev[0]:

drivers/ata/libata-scsi.c:ata_scsi_assign_ofnode() {
	struct scsi_device *sdev =3D ata_dev_scsi_device(dev, 0);
	...
			sdev->sdev_gendev.of_node =3D child;
}

Can sdev be NULL when it is unconditionally dereferenced? Would it be safer
to pass the safely refcounted local sdev directly to ata_scsi_assign_ofnode=
()?

> +			scsi_device_put(sdev);
>  		}
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731213503.2379=
771-1-philpem@philpem.me.uk?part=3D5
