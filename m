Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284FF195FC1;
	Thu,  6 Jun 2024 13:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717679187; cv=none; b=Op0LUSVprGAnpTQpk3szsZsqV5oD+TsUH8o+RVQs90VjImOGg40hSJGT0miq3NQFSeQg4iH5GJiLoCOU5v6Z33p594VJ0ld9M2kJF9p311Pm2x7zJ36V5l7FhRsqFLLu+1TuiZiQkQVanOGYlCT3rIx8TN4c1ZwAfEFSdEeC6lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717679187; c=relaxed/simple;
	bh=h+h1nqg2scQsYW0Dp9n4OAUo9gkgkZTsAysItHWVj3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bh1UpmvwpIsW44s+kGQjHeklhzlRTBvkjCNRyzDZS5xLuKDRvXi8LxkYVCaHDZLgx6Gk11xTgoUFYpqd2t6J8KhhjO+njj2X31yE3AqTgaaYWaF5Fx9rU0AIQRirtgxpYg33R2TQtmJKmy3pgFiCtBkgeDZt3xES9k81HqDIjCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWJKTsQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWJKTsQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C5FC2BD10;
	Thu,  6 Jun 2024 13:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717679186;
	bh=h+h1nqg2scQsYW0Dp9n4OAUo9gkgkZTsAysItHWVj3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nWJKTsQi9mSDAthMW+UbM2XFjG8ppjVqDq3otIAhHuRP9atfO4Mv3zzOTbHyBQ3wo
	 j3q6fWRY357H2Q9ZPljLCZu7weo1SfgVbkSohW8umlrXzPm9KIF5ZkMpLFOUAm4dJO
	 zNsk5B/bytaXdbRoII4MfM/H8VK1QVhl8wpeEgMcaX6/aRCB2fs5+ctD+hWm0oGzlZ
	 eASJfLtnny5XEzNhjBNaUpzkUoHDObHGd+cAOxHexT/4yIMGxmi+V1kQkUTgUbsB7T
	 I9aYNCKn7kG6xmzA/NcDUh9cqA6+WoSb9XzauPIZLL11hYsFSC8IlF+JISlt3xwMCQ
	 Ky45/rXUV/dmg==
Date: Thu, 6 Jun 2024 15:06:21 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: martin.petersen@oracle.com, dlemoal@kernel.org, hch@lst.de,
	john.g.garry@oracle.com, linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	regressions@lists.linux.dev, doru.iorgulescu1@gmail.com
Subject: Re: [PATCH] ata: pata_macio: Fix max_segment_size with PAGE_SIZE ==
 64K
Message-ID: <ZmG0TUiw0Nagwroj@ryzen.lan>
References: <20240606111445.400001-1-mpe@ellerman.id.au>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606111445.400001-1-mpe@ellerman.id.au>

On Thu, Jun 06, 2024 at 09:14:45PM +1000, Michael Ellerman wrote:
> The pata_macio driver advertises a max_segment_size of 0xff00, because
> the hardware doesn't cope with requests >= 64K.
> 
> However the SCSI core requires max_segment_size to be at least
> PAGE_SIZE, which is a problem for pata_macio when the kernel is built
> with 64K pages.
> 
> In older kernels the SCSI core would just increase the segment size to
> be equal to PAGE_SIZE, however since the commit tagged below it causes a
> warning and the device fails to probe:
> 
>   WARNING: CPU: 0 PID: 26 at block/blk-settings.c:202 .blk_validate_limits+0x2f8/0x35c
>   CPU: 0 PID: 26 Comm: kworker/u4:1 Not tainted 6.10.0-rc1 #1
>   Hardware name: PowerMac7,2 PPC970 0x390202 PowerMac
>   ...
>   NIP .blk_validate_limits+0x2f8/0x35c
>   LR  .blk_alloc_queue+0xc0/0x2f8
>   Call Trace:
>     .blk_alloc_queue+0xc0/0x2f8
>     .blk_mq_alloc_queue+0x60/0xf8
>     .scsi_alloc_sdev+0x208/0x3c0
>     .scsi_probe_and_add_lun+0x314/0x52c
>     .__scsi_add_device+0x170/0x1a4
>     .ata_scsi_scan_host+0x2bc/0x3e4
>     .async_port_probe+0x6c/0xa0
>     .async_run_entry_fn+0x60/0x1bc
>     .process_one_work+0x228/0x510
>     .worker_thread+0x360/0x530
>     .kthread+0x134/0x13c
>     .start_kernel_thread+0x10/0x14
>   ...
>   scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured
> 
> Although the hardware can't cope with a 64K segment, the driver
> already deals with that internally by splitting large requests in
> pata_macio_qc_prep(). That is how the driver has managed to function
> until now on 64K kernels.
> 
> So fix the driver to advertise a max_segment_size of 64K, which avoids
> the warning and keeps the SCSI core happy.
> 
> Fixes: afd53a3d8528 ("scsi: core: Initialize scsi midlayer limits before allocating the queue")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/all/ce2bf6af-4382-4fe1-b392-cc6829f5ceb2@roeck-us.net/
> Reported-by: Doru Iorgulescu <doru.iorgulescu1@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218858
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Applied to libata/for-6.10-fixes:
https://git.kernel.org/pub/scm/linux/kernel/git/libata/linux.git/log/?h=for-6.10-fixes

With John's Reviewed-by from the other thread:
https://lore.kernel.org/linux-ide/171362345502.571343.9746199181827642774.b4-ty@oracle.com/T/#t


Kind regards,
Niklas
