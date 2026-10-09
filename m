Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8016E4EF151;
	Fri,  9 Oct 2026 16:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564248; cv=none; b=UavXi46hbhTdGKyytJc/rv21HrrKyI6DBgAEXUVr7bF0Wzb0e1yFSUH4ZSSjPhDBXAyz1t1HPJmzX3OKcB7ue9KQfJAJqOMxB+LmhHTWgk6tfWzkiWslk8iumbtaXXX4AqW4IbIwU2TVrdX1Jv8Gzuw5tasdy17BhEgKHgGjylU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564248; c=relaxed/simple;
	bh=q+Y9Tf6oxZrkVnvATG12uwCD4DDMZUbjEUzwpOu9x94=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=XC8Bdhijdezc3FqHFZ5g32dQ08oksnlCfCqE760fGwLPhuQpBcGaFDLBTdbWbOOYeLYMNeRJDWg8Bkt19x5GdyHIpEDuy3o2OkCc91wcjcXwzeUQVMjED/29gO+6/+6VWTftgH5nIWAvXya08UUJDOtbo57U05T1JhewUAvZDuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDeSepMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDeSepMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15FF1F000FF;
	Fri,  9 Oct 2026 16:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791564243;
	bh=fcDVZiC6ZyYVP5xLSgurkSuH2ZvsSoVZ5pKPRoyYqcs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nDeSepMpu5M9TvRq5R5oxrq9jXfBMjJG/MRbIpsAacGjiF4Ps2Lc4LS8ch+mUstN9
	 rv9KHIuJDSCMNetJecf/6ozCOiak98hU5xomUPa7kZTWHIi5WHKnu0HbSvTzY25JU2
	 z+zCYCghxpOqKEdg7y/dfjfmiTPTqy+NhXOiMshSxVCIBFwTOArN7tAu7wms88Sh04
	 IxaVQUhhjM+Qncze70820yOSihP8B/TYsDZqtFg2gbTUtWAetc63rVwcw067yqhtEg
	 S79mzL6Vnu2vvjCu08H2E3vXxlETPRbZjLoX3C8G+O9jxHTXUTUlez4pyHy9PFrjZg
	 KgwAvIwMJOt7A==
Message-ID: <sashiko-outbox-165843@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 14/15] ata: libata-scsi: probe additional LUNs for
 multi-LUN ATAPI devices
Reply-To: sashiko-reviews@lists.linux.dev
To: "Phil Pemberton" <philpem@philpem.me.uk>
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, dlemoal@kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <20261009155522.593045-15-philpem@philpem.me.uk>
References: <20261009155522.593045-1-philpem@philpem.me.uk>
 <20261009155522.593045-15-philpem@philpem.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 16:44:03 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ata: libata-scsi: manual scan of ATAPI targets bypasses OF node as=
signment
--

commit 8bad316476ffbbf5d3a2fdb9796c051181202764
Author: Phil Pemberton <philpem@philpem.me.uk>

ata: libata-scsi: probe additional LUNs for multi-LUN ATAPI devices
   =20
After adding LUN 0 of an ATAPI device marked BLIST_FORCELUN, scan the
target's remaining LUNs using scsi_scan_target(). The scan is bounded by
shost->max_lun, set through atapi_max_lun.

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index faf408acf65ec..bba2db2f84284 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c

[ ... ]

> @@ -5647,6 +5662,37 @@ int ata_scsi_user_scan(struct Scsi_Host *shost, un=
signed int channel,
>  	} else
>  		spin_unlock_irqrestore(ap->lock, flags);
> =20
> +	if (!rc) {
> +		struct ata_link *link;
> +		struct ata_device *dev;
> +
> +		/* EH does not scan missing LUNs on an already attached target. */
> +		mutex_lock(&ap->scsi_scan_mutex);
> +		ata_for_each_link(link, ap, EDGE) {
> +			ata_for_each_dev(dev, link, ENABLED) {

[ ... ]

> +				scsi_scan_target(&shost->shost_gendev,
> +						 scan_channel, scan_id, lun,
> +						 SCSI_SCAN_MANUAL);
> +				ata_scsi_publish_sdevs(dev);
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this manual scan bypass OF node assignment and multi-LUN scanning for
newly attached ATAPI targets?

If a user initiates a manual scan via sysfs (for example, using
echo "- - -" > /sys/class/scsi_host/hostX/scan), ata_scsi_user_scan()
schedules and waits for EH. EH configures the device and queues
hotplug_task (a delayed work).

Because ata_scsi_user_scan() continues immediately, it usually beats the
deferred hotplug_task and populates dev->sdev[0] here via
ata_scsi_publish_sdevs().

When hotplug_task subsequently runs ata_scsi_scan_host(), it skips the
remaining initialization due to the guard check in ata_scsi_scan_host():

drivers/ata/libata-scsi.c:ata_scsi_scan_host() {
    ...
			if (dev->sdev[0])
				continue;
    ...
}

Will this entirely bypass ata_scsi_assign_ofnode() and the new BLIST_FORCEL=
UN
multi-LUN scan logic for the target, potentially affecting device tree
bindings and leaving secondary LUNs inaccessible?

> +			}
> +		}
> +		mutex_unlock(&ap->scsi_scan_mutex);
> +	}
> +
>  	return rc;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009155522.5930=
45-1-philpem@philpem.me.uk?part=3D14
