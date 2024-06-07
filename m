Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1F315698B
	for <linux-scsi@vger.kernel.org>; Fri,  7 Jun 2024 08:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717747257; cv=none; b=KlRR9O0VQS/lmzNRKnCXhy64eD1JEV6Vujy/uwIHWrNACuFo62eyo2a7UcrGSfMMabRIrJlSGBvl1iNvikZnM0xo33ozPkq3k3/nOtJN2sUCHC1u2reiTEVoWc795yvOElh0Zm8EGOGy6kj3ydMn3HUFfhUYtVLJpk23oOI6TSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717747257; c=relaxed/simple;
	bh=diFnyy4ca719FS/AhJLlD5iFb324tKUE7jgEhmVNWIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBME6vkOCM9CHR38MrF4YIHOF3rm09+uPmdxKltkAh/vnkRkqtQ9cpey+oOPeP8BglW14RRok4/slS6ye0BJQbyzHUxlRQoT4Di+fQRSr6wCIhwHGr2gnbZwtsugP+9AlzF3499Z+J9tCwxvGAtPWljlrQ/nFwPIL/D4dX1lvJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AfdLC3mX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AfdLC3mX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7B0C2BBFC;
	Fri,  7 Jun 2024 08:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717747256;
	bh=diFnyy4ca719FS/AhJLlD5iFb324tKUE7jgEhmVNWIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AfdLC3mXzjnJg+XxeEZTPo0b5yxreGNrItTuUwW5UXSZTysps4zM8Fqk61DvIZmDS
	 KBK5oD3ASVZqTCFbLF0MXFZ+ZYv3lWqOghNjZbk5gum3NEcFwMfDB9b1tgmUyHHvyV
	 gjtXK4kfMkceZMEWvGggfkEAeb2x787D1oSm3060FObf1lFL7fvN4m3XUCg524HRyj
	 655WDoc/zJmPwgxlxNp1x3hstnYX+Zv4n0jx05hz3wYHkK2of70J2eDei753Hi2hy8
	 /ULhbedR4hPclTw3BlwflLyq4oR53gdSraEVFJylpDPq6ixTBl25HKe26f2UlcqJ1o
	 mG0UAhopwmc4Q==
Date: Fri, 7 Jun 2024 10:00:52 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH v2] scsi: core: Disable CDL by default
Message-ID: <ZmK-NIE9bWolH_Fz@ryzen.lan>
References: <20240607012507.111488-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607012507.111488-1-dlemoal@kernel.org>

On Fri, Jun 07, 2024 at 10:25:07AM +0900, Damien Le Moal wrote:
> For scsi devices supporting the Command Duration Limits feature set, the
> user can enable/disable this feature use through the sysfs device
> attribute cdl_enable. This attribute modification triggers a call to
> scsi_cdl_enable() to enable and disable the feature for ATA devices and
> set the scsi device cdl_enable field to the user provided bool value.
> For SCSI devices supporting CDL, the feature set is always enabled and
> scsi_cdl_enable() is reduced to setting the cdl_enable field.
> 
> However, for ATA devices, a drive may spin-up with the CDL feature
> enabled by default. But the scsi device cdl_enable field is always
> initialized to false (CDL disabled), regardless of the actual device
> CDL feature state. For ATA devices managed by libata (or libsas),
> libata-core always disables the CDL feature set when the device is
> attached, thus syncing the state of the CDL feature on the device and of
> the scsi device cdl_enable field. However, for ATA devices connected to
> a SAS HBA, the CDL feature is not disabled on scan for ATA devices that
> have this feature enabled by default, leading to an inconsistent state
> of the feature on the device with the scsi device cdl_enable field.
> 
> Avoid this inconsistency by adding a call to scsi_cdl_enable() in
> scsi_cdl_check() to make sure that the device-side state of the CDL
> feature set always matches the scsi device cdl_enable field state.
> This implies that CDL will always be disabled for ATA devices connected
> to SAS HBAs, which is consistent with libata/libsas initialization of
> the device.
> 
> Reported-by: Scott McCoy <scott.mccoy@wdc.com>
> Fixes: 1b22cfb14142 ("scsi: core: Allow enabling and disabling command duration limits")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
