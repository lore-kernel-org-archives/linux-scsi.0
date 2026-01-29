Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5D835B654;
	Thu, 29 Jan 2026 03:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769657512; cv=none; b=rVqF5hCEmN6kk+wJ8IVCL9XOcT1ufiMlhUDVaB3S+PNdEh/4hs0Y0PF7HYx7lUKLhC6akfSDV1bFRcRz4QO+ZStu+AcqYgpiaDBBqgO1gyYn/KgMuNDTk7sI8kkFL8sjysVVFUldg200RddyHczhK5LIQFDSdTM4Yyh4jtc7SWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769657512; c=relaxed/simple;
	bh=L3CYYnxH7rMmNN6PUUb3m9dtTAhsGVfencgw6kW6wXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLlwrp3usbXlFPmpoRKN1B/CVjAdeAsKvi8v6YgqFHh2DEwcI2pxpt2d/avv3IKmo2ehI70Ri9x+zH3sJC9FilhEsvHLfaalYCryNTO/0PF8/WDn36Vt8xQR2ubI8e6vMt1OEql+dt7rJy5XRgmTxH/dS8CnjDhov8pDl642pUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cX5LrfTt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cX5LrfTt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0DCC116D0;
	Thu, 29 Jan 2026 03:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769657510;
	bh=L3CYYnxH7rMmNN6PUUb3m9dtTAhsGVfencgw6kW6wXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cX5LrfTtA1ZFfO2h8kHxSV1HJbpy/tmPjbH4KwGozekQMHo2s6Jqo6uRPgcZlkPBb
	 GfOKx+c2SEfPmyvuL7DJjJws3qI1U5JRg67rYOVxmmXTNp8rroHuMrDLfAkJeofKaF
	 vqVooz52aU8jad/39pYkGLAde3eUPbI0G9VqCF7Duajusi4QUuHlw1G9EVc70iEe/W
	 Gnxv1xHsR2uA6RpdEspnARUi1THsoFMr8Fx4KGzWcdqxcBXIkMkDo35pakJDx63ij0
	 kcPAsGcgclbyc+u6vswnllmGFfbd8ceF1q1n8MVQBMtnsseEZtBI8JS5O/nZbo6ZHD
	 Y1rBbj9ZI6a0Q==
Date: Wed, 28 Jan 2026 19:31:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "zheng.gong" <zheng.gong@samsung.com>
Cc: linux-scsi@vger.kernel.org, avri.altman@wdc.com, bvanassche@acm.org,
	quic_cang@quicinc.com, alim.akhtar@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] scsi: ufs: Add crypto_keyslot_remap support
Message-ID: <20260129033116.GA68575@sol>
References: <20251112031035.GA2832160@google.com>
 <CGME20260129031038epcas5p3975b1f66414a7393b85c362523ebe1b8@epcas5p3.samsung.com>
 <20260129031033.3428295-1-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129031033.3428295-1-zheng.gong@samsung.com>

On Thu, Jan 29, 2026 at 11:10:30AM +0800, zheng.gong wrote:
> Hello Eric,
> 
> Sorry for late due to other affairs.
> 
> Readjuest the patchset adds support for platform-specific crypto keyslot
> remapping in the exynos UFS host driver.
> 
> The 1st patch raise a new variant op:
>   ufs_hba_variant_ops::crypto_keyslot_remap
> which allows platforms to adjust the keyslot index at io request period.
> 
> The 2nd patch adds a real, upstream user in ufs-exynos.c that supports
> remapping via device tree. This makes the hook justifiable for mainline
> inclusion.
> 
> The 3rd patch adds DT binding description for the new property
> 'ufs-keyslot-offset'.

I don't think it's plausible that this actually works, considering that
ufs-exynos.c installs a custom blk_crypto_profile that doesn't have any
keyslots.  (It does that because the Exynos UFS host controller takes
the raw key directly in the PRDT on a per-block basis.)  With no
keyslots, the concept of remapping them is meaningless.

Could you clarify what exactly this patchset is meant to do, and how you
tested it?

Do you perhaps have additional patches that this depends on?  Perhaps
patches that add support for a version of the Exynos UFS host controller
that does have keyslots?

- Eric
