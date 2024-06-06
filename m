Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC37196D94
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 15:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717686812; cv=none; b=RPC+xRdxfIBt4xcTOX0e0tLZAasiC6xHWIbXrmTdWNr0zHdYLikBZ3PPqUrAWOJMn/j2/IHNUFASSNCStykSMX42eLMhPi8a4QRb7jxZISHjODTx6Sn1hUHZHz42adBCO+7+WgfhR17oRExeHk2wgMr5RkC/Ej1wMtI5XHifnbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717686812; c=relaxed/simple;
	bh=t1NClZJ9i9gSVf1UhO7/Vu06ESFTeDfS6F4SO8Q3UII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhprKHag747gSd15H1FfUzSiSsuT4WNt2knD2D2vEpquhumYKB5Qt3WkGNZkpmZMGH3Fy4q35+/cyJ2JXvJQnNJ4++a8WGE8wK4nPA1h7BbOtFVSw7uEV+mr7X8ELGbPAv6c7lC9WpTgZkMddSXF8ZVNE1UP4sgaXTp5u1bqJLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xm4/XD74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xm4/XD74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C15C2BD10;
	Thu,  6 Jun 2024 15:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717686811;
	bh=t1NClZJ9i9gSVf1UhO7/Vu06ESFTeDfS6F4SO8Q3UII=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xm4/XD74TjWz6DDRNV0R4ZIY0fgipGFnE7mLH1ncsz+eeb82nx7a9jmNBv+m8FEhH
	 kkqNLyEqUY4VTznk4Pvbv+wXzu7XOqbNR5VyQoCW8Aa+VQ+JwVa4TitVwQZu6rSwgm
	 xLwnpN/KnSa8tdvUirq3xeeQ3KUbgT5pLUauDnBK+TiCde/cbC6XSPKyplFoIqm96V
	 xqE4UcLQe8Q1PLtmKO0TpNSZg0NmJqugoVvIPDEjqxP57wYNVwSLTtO77Dt8aKwFKM
	 wJvjeZ6c3m34xXIzEA3b5V8TPL0oU9x1aRVzsHH6+F0i6+JiAKttqpSEFbkouEcUJB
	 FV7ljQnYTjFqg==
Date: Thu, 6 Jun 2024 17:13:26 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Disabe CDL by default
Message-ID: <ZmHSFucV02L5R3Ni@ryzen.lan>
References: <20240606054606.55624-1-dlemoal@kernel.org>
 <ZmG4XfHEbfhje2Zp@ryzen.lan>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmG4XfHEbfhje2Zp@ryzen.lan>

On Thu, Jun 06, 2024 at 03:23:41PM +0200, Niklas Cassel wrote:
> Hello Damien,
>
> s/Disabe/Disable/
> in $subject
>
> On Thu, Jun 06, 2024 at 02:46:06PM +0900, Damien Le Moal wrote:
> > For scsi devices supporting the Command Duration Limits feature set, the
> > user can enable/disable this feature use through the sysfs device
> > attribute cdl_enable. This attribute modification triggers a call to
> > scsi_cdl_enable() to enable and disable the feature for ATA devices and
> > set the scsi device cdl_enable to the user provided bool value.
> >
> > However, for ATA devices, a drive may spin-up with the CDL feature
> > either enabled or disabled by default, depending on the drive. But the
> > scsi device cdl_enable field is always initialized to false (CDL
> > disabled), regardless of the actual device CDL feature state.
> >
> > Add a call to scsi_cdl_enable() in scsi_cdl_check() to make sure that
> > the device-side state of the CDL feature always matches the scsi device
> > cdl_enable field state, thus avoiding inconsistencies for devices that
> > have CDL enabled when first scanned. This implies that CDL will always
> > be disabled, as it should be, when the system first scans the devices.
> >
> > Reported-by: Scott McCoy <scott.mccoy@wdc.com>
> > Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> > ---
> >  drivers/scsi/scsi.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> > index 3e0c0381277a..9e9576066e8d 100644
> > --- a/drivers/scsi/scsi.c
> > +++ b/drivers/scsi/scsi.c
> > @@ -666,6 +666,13 @@ void scsi_cdl_check(struct scsi_device *sdev)
> >		sdev->use_10_for_rw = 0;
> >
> >		sdev->cdl_supported = 1;
> > +
> > +		/*
> > +		 * If the device supports CDL, make sure that the current drive
> > +		 * feature status is consistent with the user controlled
> > +		 * cdl_enable state.
> > +		 */
> > +		scsi_cdl_enable(sdev, sdev->cdl_enable);
> >	} else {
> >		sdev->cdl_supported = 0;
> >	}
>
> Perhaps I'm missing something here, but since this is only a problem for
> ATA devices, where the device might have CDL enabled on the device,
> but disabled in sysfs, why isn't this code disabling it:
> https://github.com/torvalds/linux/blob/v6.10-rc2/drivers/ata/libata-core.c#L2551-L2572
>
> The whole point of that code is to keep the device in sync with the
> device/sysfs value.
>
> Can't we modify ata_dev_config_cdl() such that we can avoid doing basically
> the same sync (only needed for ATA devices) in two different functions?

So what I don't see right now is, the libata code:

	val = get_unaligned_le64(&ap->sector_buf[8]);
	cdl_enabled = val & BIT_ULL(63) && val & BIT_ULL(21);
	if (dev->flags & ATA_DFLAG_CDL_ENABLED) {
		if (!cdl_enabled) {
			/* Enable CDL on the device */
			err_mask = ata_dev_set_feature(dev, SETFEATURES_CDL, 1);
			if (err_mask) {
				ata_dev_err(dev,
					    "Enable CDL feature failed\n");
				goto not_supported;
			}
		}
	} else {
		if (cdl_enabled) {
			/* Disable CDL on the device */
			err_mask = ata_dev_set_feature(dev, SETFEATURES_CDL, 0);
			if (err_mask) {
				ata_dev_err(dev,
					    "Disable CDL feature failed\n");
				goto not_supported;
			}
		}
	}


cdl_enabled was from a ata_read_log_page(..., ATA_LOG_CURRENT_SETTINGS, ...)
call, so it should get the value directly from the device, which IIUC,
is enabled by default, so it should be enabled.

ATA_DFLAG_CDL_ENABLED
is from ata_mselect_control_ata_feature(), so translated MODE SELECT,
but no one should have called this at scsi probe time, so I would
expect ATA_DFLAG_CDL_ENABLED to not be set.

Is the problem really when at scsi probe time, or is it when the
user writes the sysfs value the first time where things go wrong?

The commit message mentions "thus avoiding inconsistencies for devices
that have CDL enabled when first scanned", but perhaps you could be
explain in more detail why the current code is not working?


Kind regards,
Niklas
