Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311A413E048
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717680227; cv=none; b=g2Z6vxmtDJxinpWMhwnJSA2p5aKErqeEf+hJ8ilwUPzAA/FZY6NpyGUqvSCyTquQKQEdahH3eVi/U1kzso7W1NxdHWDBCsPUUyz5YU3q7Hy/6bu23y0t2W8oFsLd5kfBUMQXLBR6AC/bHL6MSCynnMt5Yr2O0wzoGeA6+yyeqwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717680227; c=relaxed/simple;
	bh=+lKSskOUjcTzHyXK9KpiW59DpTi2riiwElJMAeZSET0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nKtg1MajjltzyRxvXgMNqnapoN6x8YeHJzCaHgTm6wOGCfnluxV8QZ12ZScI6L+g6xZqvOtsarOP4eQYddjtkjW8cSJiwOzryJ46obfNSNwZgS7wK7ZOXEJyGB79US7oKugtadg1Vfhcbawof7lqAQcNOZ9JzVxZhLBNQmywCmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DufYK76R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DufYK76R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C23C4AF08;
	Thu,  6 Jun 2024 13:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717680225;
	bh=+lKSskOUjcTzHyXK9KpiW59DpTi2riiwElJMAeZSET0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DufYK76R0r/1w1HvScXBTInlNygHmeEvE2VeQR/c4IssVWw3fvUL+m6Ts2Y5qL5vr
	 ymzYEyYIQn0Rsvv4g5FVD/O/bVSbdIQVxG+/FAVRDiTwciD1tUqBkSVas47RmICb5a
	 HCcQFSy1HAahVygHOGjfiJnkKcmniiD521lqJeEYVf2dnDTn4bhBbwsSRsB4H4/HT0
	 agb2shlJHgv+GT3S2vur4YRUuLXrOq6RH7DtSKqWJtc4BH893gyaMBSNr/ijcb5aP9
	 Nt1wTqm2cI5nB7XgVAj1kQ4T2yI/erPIRGELqURZ/LdL2xwL3OpnQGKVCYHMspfUHn
	 NEZyJZ35g4rqQ==
Date: Thu, 6 Jun 2024 15:23:41 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Disabe CDL by default
Message-ID: <ZmG4XfHEbfhje2Zp@ryzen.lan>
References: <20240606054606.55624-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606054606.55624-1-dlemoal@kernel.org>

Hello Damien,

s/Disabe/Disable/
in $subject

On Thu, Jun 06, 2024 at 02:46:06PM +0900, Damien Le Moal wrote:
> For scsi devices supporting the Command Duration Limits feature set, the
> user can enable/disable this feature use through the sysfs device
> attribute cdl_enable. This attribute modification triggers a call to
> scsi_cdl_enable() to enable and disable the feature for ATA devices and
> set the scsi device cdl_enable to the user provided bool value.
> 
> However, for ATA devices, a drive may spin-up with the CDL feature
> either enabled or disabled by default, depending on the drive. But the
> scsi device cdl_enable field is always initialized to false (CDL
> disabled), regardless of the actual device CDL feature state.
> 
> Add a call to scsi_cdl_enable() in scsi_cdl_check() to make sure that
> the device-side state of the CDL feature always matches the scsi device
> cdl_enable field state, thus avoiding inconsistencies for devices that
> have CDL enabled when first scanned. This implies that CDL will always
> be disabled, as it should be, when the system first scans the devices.
> 
> Reported-by: Scott McCoy <scott.mccoy@wdc.com>
> Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/scsi/scsi.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 3e0c0381277a..9e9576066e8d 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -666,6 +666,13 @@ void scsi_cdl_check(struct scsi_device *sdev)
>  		sdev->use_10_for_rw = 0;
>  
>  		sdev->cdl_supported = 1;
> +
> +		/*
> +		 * If the device supports CDL, make sure that the current drive
> +		 * feature status is consistent with the user controlled
> +		 * cdl_enable state.
> +		 */
> +		scsi_cdl_enable(sdev, sdev->cdl_enable);
>  	} else {
>  		sdev->cdl_supported = 0;
>  	}

Perhaps I'm missing something here, but since this is only a problem for
ATA devices, where the device might have CDL enabled on the device,
but disabled in sysfs, why isn't this code disabling it:
https://github.com/torvalds/linux/blob/v6.10-rc2/drivers/ata/libata-core.c#L2551-L2572

The whole point of that code is to keep the device in sync with the
device/sysfs value.

Can't we modify ata_dev_config_cdl() such that we can avoid doing basically
the same sync (only needed for ATA devices) in two different functions?


Kind regards,
Niklas
