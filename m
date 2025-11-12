Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F668199949;
	Wed, 12 Nov 2025 03:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762917038; cv=none; b=DhCuMaki1judnl9vm/+60Fbz8dz0Gy/qM2YmhsML77ovNXndf91dCwjnSb5Jl8UsuXNbwL6wxufOhfgMxZzEZ9A2sx6QjwUW7qTvD4SOnabbcQD5NwFhOA/5cEn1FhTsVs4uQdYC1AbLSguEr5hcpdc/GCov/q0QVqK2e32K5/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762917038; c=relaxed/simple;
	bh=N3KSb+W4BMHQsqL6Gb6zXADLRuxiZ8OaftWSTA8WceI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eq5zyWxEkaIVDzw/u90hezOyPqaYy7oW7jNDfwAz1S4a7qHlalhrOibdQUBbPwqSqm5Mq4tGW3ud7r/x+3uZCV2p29TqB3Yd7weVjpDtAoW6xj6LLsliDZ1YBQUyHPncr+cVIsPavqprFRxtrLXVUN/ogqJSgCOel8fi/A6kgVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YYfPslGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYfPslGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF03C116D0;
	Wed, 12 Nov 2025 03:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762917037;
	bh=N3KSb+W4BMHQsqL6Gb6zXADLRuxiZ8OaftWSTA8WceI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YYfPslGNGuGgeqql9OInZ5SO/8HW5rhNnd7gS67S6DxfBYQURDtwsrzE3C7ZFfZgy
	 UCKe2N2Zp3pTR9hnsG6QdXQk2ek+KBUFlgcbdRQTbnQMXGNJ2L1tv554OULllCXRH2
	 LjfTn8cZQA7hyd1pdvd48g5zZqvCXbRaYWidJT8vO02GM6LF2NTHuOKReGCjeDUep7
	 y2PUok9Y0JV1sUp6/xWWt/Z9N7VzJV6V0FgzcszZAznRyc9cypL+/zs/4dHAJiTufJ
	 MQohgeZnu/fKa2WcB66iTLUzOhfiFmjDCeTNHMR0BrFY1nxKqfvLICiSU8itivxRmI
	 pJhDk63gyYsow==
Date: Wed, 12 Nov 2025 03:10:35 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: "zheng.gong" <zheng.gong@samsung.com>
Cc: linux-scsi@vger.kernel.org, avri.altman@wdc.com, bvanassche@acm.org,
	quic_cang@quicinc.com, alim.akhtar@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: ufs: crypto: Add
 ufs_hba_variant_ops::crypto_keyslot_remap
Message-ID: <20251112031035.GA2832160@google.com>
References: <20251112030524.3545394-1-zheng.gong@samsung.com>
 <CGME20251112030559epcas5p13358e7b05ca6b39688530b9c8178527e@epcas5p1.samsung.com>
 <20251112030524.3545394-2-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112030524.3545394-2-zheng.gong@samsung.com>

On Wed, Nov 12, 2025 at 11:05:24AM +0800, zheng.gong wrote:
> Add a new variant operation crypto_keyslot_remap to allow platform-specific
> remapping of crypto keyslot indices before sending requests to the UFS
> controller. This is required on platforms that partition the UFS crypto
> engine's keyslots among multiple domains (e.g.virtual machines),
> where each domain has a keyslot offset.
> 
> To support this, pass the UFS HBA pointer to ufshcd_prepare_lrbp_crypto(),
> so the callback can access platform context.
> 
> This functionality is used on Samsung ExynosAuto UFS platforms, where
> keyslot allocation is per-VM and a runtime offset is applied based on
> the VM ID.
> 
> Signed-off-by: zheng.gong <zheng.gong@samsung.com>
> ---
>  drivers/ufs/core/ufshcd-crypto.h | 10 ++++++++--
>  drivers/ufs/core/ufshcd.c        |  9 +++++----
>  include/ufs/ufshcd.h             |  6 ++++++
>  3 files changed, 19 insertions(+), 6 deletions(-)

This doesn't make sense by itself.  The patch that uses this new method
needs to be submitted alongside it.

- Eric
