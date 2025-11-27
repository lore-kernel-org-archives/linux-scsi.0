Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7121F31579B;
	Thu, 27 Nov 2025 22:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282378; cv=none; b=q/+xXS7uan+UmNkedc2p6OSiExxNfERQU6dEyY9V5DqMDqKXceppDHvyz+IdgfBT3k3fTXEOQu9/8bHBlsje92XOJdGmtk3SQwNIdLHNlPA9zm64p4QujM2G4NfKpzdEFwG+zMBKOGLrP5vhLypbl9990hICkACOUuy2fzvGPp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282378; c=relaxed/simple;
	bh=g0XvXIax35mpN/IDkvr6y74PtJNO/TtVbIyLTvwGzVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VCr/udTxf8SuxiYaLh7Z30/hoXnt/6Wl/K7WnRo2SRFg8TA7/nDbKe3gRcse/Y7LCPkTP/f3X61NH1dOIrpWI3ZQawE43Sy5rU5ftGhYkTzEpODrT2hjUlxOsvRS8AvGZ/bjGBw9ra/lC31EFitst18xyjYZ8PRRtZDaynSsOMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U7TIPYni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U7TIPYni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF282C113D0;
	Thu, 27 Nov 2025 22:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764282378;
	bh=g0XvXIax35mpN/IDkvr6y74PtJNO/TtVbIyLTvwGzVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U7TIPYni2AKQrvpJHX6zXMS/9DTS2Gn6XrEcFd/ayvMs/YHSwO0mJuKiZ3MVdVtjx
	 nZGOvdx4hNJyqWg6NeVCapWBA0VDpMxu1GoP570H5GdW7oFXn/WwjSYEzXF21cqPa2
	 HeeZPM7Vsl1lfxJ7PifgcjeRm6T0CPvmi4XqLcWisc2leaWZornGQATfE5apY7rHZa
	 rMqTcOU83PSstcalKEOJPlPOk2sUuzmcKlPlsV5c9bO8vdoxRGKSea0OmE8KGxqobt
	 0UNFN0TrPV788t4H/JQDMu4wMQGEnX5NgwXw2UuVZLe7zWj7hYwYqIDjcalnLUL6wq
	 MEjFKy/F7wF7A==
Date: Thu, 27 Nov 2025 14:24:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "zheng.gong" <zheng.gong@samsung.com>
Cc: linux-scsi@vger.kernel.org, avri.altman@wdc.com, bvanassche@acm.org,
	quic_cang@quicinc.com, alim.akhtar@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] scsi: ufs: Add crypto_keyslot_remap support
Message-ID: <20251127222429.GB2977@sol>
References: <20251112031035.GA2832160@google.com>
 <CGME20251127070712epcas5p4113a2d14bd4be7eaef6be6164b1f8cec@epcas5p4.samsung.com>
 <20251127070704.2935390-1-zheng.gong@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251127070704.2935390-1-zheng.gong@samsung.com>

On Thu, Nov 27, 2025 at 03:06:57PM +0800, zheng.gong wrote:
> This patch series adds support for platform-specific crypto keyslot remapping
> in the UFS host driver, enabling secure inline encryption in multi-domain
> environments (e.g., VMs).
> 
> The first patch introduces a new variant operation:
>   ufs_hba_variant_ops::crypto_keyslot_remap
> which allows platforms to adjust the keyslot index at request submission time.
> 
> The second patch adds a test module (CONFIG_SCSI_UFS_CRYPTO_TEST) to
> demonstrate how the new hook is used — by applying a fixed offset to simulate
> domain-specific keyslot layout. This patch series is in response to feedback from Eric on the v1 submission,
> where he noted that the new callback needed to be used to make sense. Just a demonstration
> of the new callback is included in this patch series.

There has to be a real user, not just a useless example module.

Perhaps you intend for this functionality to be used in ufs-exynos.c?
But you haven't sent any corresponding patch.

- Eric
