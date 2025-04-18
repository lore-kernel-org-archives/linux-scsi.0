Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387A81DFFD;
	Fri, 18 Apr 2025 08:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744965663; cv=none; b=a5k8zZ/TVqjaOu3MFMChBrKKYJybJGZdPr3NTTX9jh1CzLbb7LoFDPjtNFa0JY1pYuKwvhtEBS5/k6VsdoG2UP1G4jz9bB2og/eGCxNjsk0uqBdroT2yBlkBnGK2jk6S3TCU4RSXLCswiqwkyaBjl3T4zOUB61hTTvRUoNtMfUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744965663; c=relaxed/simple;
	bh=d6+g4GAT5ehTMOSAAvaDcPlY4x19pqnpD9EVKwlTyh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gdzl1IhtSlwEdaheCqs+ghG7rLtrirv4kwOKY9DOWRKvbef9aADZkDUPyxMpBFpJw6eZa5ALbtaY/dypVRQJNCQTfgtbb3vZpyTCFU5WuMRFKQzCAPdWa7Tb+oAluwoFzI6fZdir2y8TjzGw3M57u15VI2X6esw0i14j7g2t3iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRqiL0Ni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRqiL0Ni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A385AC4CEE2;
	Fri, 18 Apr 2025 08:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744965662;
	bh=d6+g4GAT5ehTMOSAAvaDcPlY4x19pqnpD9EVKwlTyh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aRqiL0NiMtlipI7sz9zQBIBCP/RFeRlWp9YTlPOl7pkjN0NzzhWIZ3rfGhli0s2BC
	 KWIncSy0dxD/n9Qp0tY3VDo5qTgOnu6XhRR8mO6JKDZNnp6I201kIgGVz0uNJsMF+l
	 OpTs+mSdR5qiZvpBeTAVFmycMWZI1/+ysrU4Jh2s+rAY05kZjtu4B5ug5rmofGmDuq
	 qwc+uNCBuBDJxabW7ahcbHtKsxWckE7/nOC+IzqVq1GlUxCruei0Sdf69Pyww6mata
	 Jj/fX6Uk94MD0Kz/Kn1D7QZXlg9XRZPUbRWax0+ae2oj8oWEb83mHXgZdsZCgXUZPc
	 OtHINDLg0uZVA==
Date: Fri, 18 Apr 2025 10:40:59 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/5] ata: libata-scsi: Fail MODE SELECT for
 unsupported mode pages
Message-ID: <aAIQG2PpFMZeRwUx@ryzen>
References: <20250418075517.369098-1-dlemoal@kernel.org>
 <20250418075517.369098-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418075517.369098-3-dlemoal@kernel.org>

On Fri, Apr 18, 2025 at 04:55:14PM +0900, Damien Le Moal wrote:
> For devices that do not support CDL, the subpage F2h of the control mode
> page 0Ah should not be supported. However, the function
> ata_mselect_control_ata_feature() does not fail for a device that does
> not have the ATA_DFLAG_CDL device flag set, which can lead to an invalid
> SET FEATURES command (which will be failed by the device) to be issued.
> 
> Modify ata_mselect_control_ata_feature() to return -EOPNOTSUPP if it is
> executed for a device without CDL support. This error code is checked by
> ata_scsi_mode_select_xlat() (through ata_mselect_control()) to fail the
> MODE SELECT command immediately with an ILLEGAL REQUEST / INVALID FIELD
> IN CDB asc/ascq as mandated by the SPC specifications for unsupported
> mode pages.
> 
> Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-scsi.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 24e662c837e3..15661b05cb48 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3896,6 +3896,15 @@ static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
>  	struct ata_taskfile *tf = &qc->tf;
>  	u8 cdl_action;
>  
> +	/*
> +	 * The sub-page f2h should only be supported for devices that support
> +	 * the T2A and T2B command duration limits mode pages (note here the
> +	 * "should" which is what SAT-6 defines). So fail this command if the
> +	 * device does not support CDL.
> +	 */
> +	if (!(dev->flags & ATA_DFLAG_CDL))
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * The first four bytes of ATA Feature Control mode page are a header,
>  	 * so offsets in mpage are off by 4 compared to buf.  Same for len.
> @@ -4101,6 +4110,8 @@ static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
>  	case CONTROL_MPAGE:
>  		ret = ata_mselect_control(qc, spg, p, pg_len, &fp);
>  		if (ret < 0) {
> +			if (ret == -EOPNOTSUPP)
> +				goto invalid_fld;
>  			fp += hdr_len + bd_len;
>  			goto invalid_param;
>  		}
> -- 

I would prefer if we did not merge this patch, as it is already handled in
higher up in the (only) calling function:
https://github.com/torvalds/linux/blob/v6.15-rc2/drivers/ata/libata-scsi.c#L2582-L2589

We only break if "dev->flags & ATA_DFLAG_CDL && pg == CONTROL_MPAGE"

if this expression is false, we do a fallthrough,
which means fp = 3; goto invalid_fld;


Kind regards,
Niklas
