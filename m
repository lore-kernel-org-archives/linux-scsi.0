Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3938218FDDE;
	Fri, 28 Nov 2025 03:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764301765; cv=none; b=MjW3VRuwOwkX0neuL68bCX3pudOReTyRgNnSYaaEuITr4r2L+M0FUFN3YYEwtQ9Z1aILCnnjlpBf4C6w5jpopzI8luSPozEVu1fNW68U08wVWMfC3qtdAPNBSCN1xthxz/6QRoBUyZ31JZCnx2WK6M19DSmyNY2SxWf2M4yeDuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764301765; c=relaxed/simple;
	bh=mzclW6QgqNXAUv3/IuGX+bQLzEOCpZhxB1N6HdEljuA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocodFHo3DbeVX9Em51XGiZdEI/ZzxTIKz1MQ71cIHSh+XcBnRwV5MGk5x9UtJvuh02o7fnwikGiGbXfNs+5/KQOdxY//T10LSGl045Q64YI3D46wi7GfUSb+xfjnLBfNk/tDecxvl2qCoUXq9Ns993ofZOHVtNnGWWIpjvO8gSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mi+9VsmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mi+9VsmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7915EC4CEF1;
	Fri, 28 Nov 2025 03:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764301764;
	bh=mzclW6QgqNXAUv3/IuGX+bQLzEOCpZhxB1N6HdEljuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mi+9VsmMdU6cnXwIXV2H5ynZIyZ9s2qXeCheih4iEUWB0oEsI80ZWypNk6RyiF5N7
	 O/MSXnujK8BV2m0tsLKG/nZtXf8EFtrMekQy6QytOJyfZ8UHrCA6xlTTu1fDbRLqBe
	 07p6qICc+4WGICMYGiCCKmBa/dgad9hrDv4GbAGOF82xfgXmHb6I6FjR12BFNqdSmh
	 +okHHgiY7hTOuay2zOCNrCBV1kBvzBG+a7IIdnMah60eY79GzqaTHb1zzJhzHHz/YV
	 q9JUd+0WM7ulaNPl7QswqY/9ALA5yQeRfT7VaJzO9WxxHr53x98Gd3/6BwUUGKp7Fn
	 lp55TEMQB4MBQ==
Date: Thu, 27 Nov 2025 19:47:36 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "zheng.gong" <zheng.gong@samsung.com>
Cc: linux-scsi@vger.kernel.org, avri.altman@wdc.com, bvanassche@acm.org,
	quic_cang@quicinc.com, alim.akhtar@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/1] scsi: ufs: Add crypto_keyslot_remap variant op
Message-ID: <20251128034736.GA18644@sol>
References: <20251112031035.GA2832160@google.com>
 <CGME20251128033713epcas5p450da60155377b3ae43af4d38edb935b2@epcas5p4.samsung.com>
 <20251128033709.1342579-1-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128033709.1342579-1-zheng.gong@samsung.com>

On Fri, Nov 28, 2025 at 11:37:08AM +0800, zheng.gong wrote:
> Thank you very much for your feedback, Eric. I truly appreciate your review and the time you've taken to point out that a real user is required.
> You're right. Adding a new variant op without a clear use case would not be acceptable. Let me clarify the context behind this patch.

To clarify, there has to be an in-tree user.

> This hook is not theoretical. It is designed to replace an existing out-of-tree variant op (`crypto_keyslot_cfg`) used in Samsung's ExynosAuto UFS driver for multi-VM inline encryption.
> In production, each VM has its own keyslot range per hardware allocation, and the keyslot is remapped at request time:
> 
>     lrbp->crypto_key_slot += vm_id * UFS_KEYSLOTS;
> 
> This was already in use on automotive platforms.
> 
> But the reason this usage isn't visible in mainline is due to ExynosAuto's kernel architecture:
> 
> Starting from kernel 6.1, we adopt the dual-repository model (similar to Android Common Kernel):
> - `kernel.git`: Mainline-based, minimal patches
> - `exynosauto-modules.git`: Hosts platform-specific drivers (as .ko or built-in)
> 
> Our UFS driver, including FMP and IOV support, resides in `exynosauto-modules/drivers/ufs/*`. It couldnot be upstreamed due to:
> - Hardware-specific SMC calls
> - Security-specific key management
> - Non-public register interfaces

The upstream driver is drivers/ufs/host/ufs-exynos.c, so you'll need to
focus on adding this functionality to there, if it's actually needed.
What's happening downstream is irrelevant.

- Eric
