Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE2937AA88;
	Thu, 29 Jan 2026 07:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769672602; cv=none; b=Tnh54XEXxJyqhABAeb00PDkBdaRwwUkQHubrCbxvnrARoPmyJvebVCwwBDNDAwWDstdM7EKsms8Y3UKwxtYW3EP6cJkfTYFJ68Y5ivj1HiwuN/nOQWc/XLl/u+LKHFMAfCnz7PZQ9hfxFQE1Sq/UkJcR8MSvskN3gc9+pY95HAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769672602; c=relaxed/simple;
	bh=ZFs7OGDbmS5FyiEN523QKQTdc6AXpNFz0yxljzzIQOI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edlkdPYjMvUvBSjdhT0qbrSKLqpLUrm3mIlx+58rpHeV54Uiq3Dt9c8hXCjRfPFKNSWVOAW5SlEIatxF1CN6bpkExPT08Ex+bDjekiWufwlfKa5qL9WB9YU65OqJK7YTIRMUcpa0t0Ae1bPYQ3ms42AL/bTVF254Kld3dW9IwOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XElYphxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XElYphxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889A2C4CEF7;
	Thu, 29 Jan 2026 07:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769672601;
	bh=ZFs7OGDbmS5FyiEN523QKQTdc6AXpNFz0yxljzzIQOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XElYphxoNW2dXv2oZ+Fx1abJPRPh24CK9kwaeyVACC1i2koEIVqAQZKlmj3om0aK2
	 YYvJKM4zjdsdB4miQnkAsaWPxVza11Gn9b75xp3LzeaPBJgXKywxj/ciFDMxIJMNvL
	 PHC7sxhziwUqHaEO0kIU6emUzhL8Z4JmqsEhRH20CAHpWo/Bahfrrsy6fpgC1Z2BUc
	 6Kgkd+sGiiL/hYraw+DCNC1kNVLKUol/fBE7bFVtogEiMse0h3og2peVHCnQSM+65C
	 +SDwqK+XFIxtOoSJoCPo71xWV6KFrHgUeok6mvELhUMElVko4FwkV6PNrDtssDx8ba
	 iF0IRxhaSiC+w==
Date: Wed, 28 Jan 2026 23:42:47 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "zheng.gong" <zheng.gong@samsung.com>
Cc: linux-scsi@vger.kernel.org, avri.altman@wdc.com, bvanassche@acm.org,
	quic_cang@quicinc.com, alim.akhtar@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v4 0/3] scsi: ufs: Add crypto_keyslot_remap support
Message-ID: <20260129074247.GA89457@sol>
References: <20251112031035.GA2832160@google.com>
 <CGME20260129061800epcas5p27ea107df6d3b296e4a63d948a8d6af17@epcas5p2.samsung.com>
 <20260129061758.329806-1-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129061758.329806-1-zheng.gong@samsung.com>

On Thu, Jan 29, 2026 at 02:17:58PM +0800, zheng.gong wrote:
> Hi Eric,
> 
> Thank you for ur kind question. I understand your concern.
> the confusion arises from the coexistence of two different UFS drivers on Exynos platforms.
> 
> There are two distinct UFS host controller implementations on Samsung Exynos:
> - ufs-exynos.c
> - ufs-exynosautovX.c
> 
> But ufs-exynosautovX is not mainlined, which:
> - Uses a hardware crypto engine that does support keyslots
> - Assigns keyslots to VMs (e.g., QNX, Linux, Android)
> - Needs to remap logical keyslot + VM-specific offset at request time
> 
> We added a minimal, DT-based remap in ufs-exynos.c not because mobile uses it, but to:
> - Prove that the hook has a real, upstream-mergeable use pattern
> - Show that the mechanism can be used by actual platform
> 
> It is a generic, not tied to one usecase.
> 
> As for how we use it in our platform.
> 
> In our driver, we implement as like:
> 
> void exynos_ufs_fmp_crypto_keyslot_remap(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
> {
>     struct exynosauto_ufs *ufs = to_exynosauto_ufs(hba);
>     u32 vm_id = ufs->iov->vm_id;
>     u32 offset = vm_id * UFS_KEYSLOTS;
> 
>     if (lrbp->crypto_key_slot >= 0)
>         lrbp->crypto_key_slot += offset;
> }
> 
> We have tested this on ExynosAuto V920 platform with:
> 4 virtual machines: QNX, Linux, Linux, Android.
> Each VM has its own UFS VH and keyslot range as per allocation.
> Inline encryption is enabled for all VMs. offset is configured in dt for each VH node.
> 
> Despite driver resides in our out-of-tree exynosauto-modules and cannot be upstreamed easily,
> but the use case is real and actively used in production platform.
> 
> To help move this forward, could you please let us know what additional 
> information or changes would be needed to make this patch acceptable?
> 
> If it is not plausible for mainline, do u have any suggestion in terms of this kind of case?

Well, you should start working on upstreaming support for the platform
that needs this feature.

Until that is done, this patch series won't go anywhere.

- Eric
