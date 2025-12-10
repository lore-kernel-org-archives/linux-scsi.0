Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818EB21ABB9;
	Wed, 10 Dec 2025 01:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331767; cv=none; b=WxEwafavJbOzSbhCzBKuFc/dDGJNMwq8KzYZjqYeZJHBeD1PURBRMd1W3JT619hCjHZ9JBj08x5dg3KpBPpG2yJJ2AAc3T6TkaW4J6WTPQIzGCxaqM4LGLJbuM1E+rnL8S7DYGaQ8r08xyOHlKr32RtB69IuiYES7jRia7FsCHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331767; c=relaxed/simple;
	bh=9KmTMHTQrfwLg3LoCVEmxM8RP0CV7S+9Mc4HQ/iLy2E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VJWka5CJuU+rvMizKeG6b7tM83RSeNinNFLd8oQlmcYbYFTaK2msKyRSujAzGijO6lURbTPsai25oXcZB8PLTAZ8yB64ZJ6YJy589ZYPG6iUfUgaAnGZJsOXdn1r+5qcyq3eTZxzjZAcMpU+oYGYSEKxi4BYlgp+eXt4LXNJqsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdexdfMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdexdfMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7E6C4CEF5;
	Wed, 10 Dec 2025 01:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765331766;
	bh=9KmTMHTQrfwLg3LoCVEmxM8RP0CV7S+9Mc4HQ/iLy2E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BdexdfMCe9pskb+WsP7gomJRMulR1Tv87GnTDaHmyIpiYmiB14+xKBKAdgZZ10ABk
	 ykejCuO+GDA9nXd15krNHjVTYHxCM6dzeVd64SqEtzQUmGRY3x+eYUFmTiO0NgNvLO
	 ybs3EJPr//EFHDnInOfZNRQg/qNpwwTtucjjwk0yY8y8PkcABbCpsk+KPM23fQWW7H
	 ni31hNAfJqAh3esrovdxmPk4xCowfD0YSCGB7Telbz0BRh8CbXW8sXFwCnfIPTmfkG
	 3xgH/RgCwSW0ZZ2pAzbPZq1N7TiMNac8ORl7LEJ/SNewe1qrnbvawUPBYRQb5jU3uE
	 eyHhOusFbELmA==
Message-ID: <ec5f42bd-a26a-4416-b967-f67090e9a423@kernel.org>
Date: Tue, 9 Dec 2025 17:56:05 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v1 0/2] enable sector size > PAGE_SIZE for scsi
To: sw.prabhu6@gmail.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org,
 kernel@pankajraghav.com
References: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/12/09 17:41, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <sw.prabhu6@gmail.com>
> 
> Hi All,
> 
> This is non RFC v1 series sent based on the feedback received on RFC
> v2 [1] and RFC v1 [2]. This patchset enables sector sizes > PAGE_SIZE for
> sd driver and scsi_debug driver since block layer can support block
> size > PAGE_SIZE. There was one issue with write_same16 and write_same10
> command, which is fixed as a part of the series.
> 
> Motivation:
>  - While enabling LBS on ZoneFS, zonefs-tools tests were being skipped
>    for conventional zones when tested on nvme block device emulated using
>    QEMU. Hence there was a need to enable scsi with higher sector sizes
>    to run zonefs tests for conventional zones as well.

This is super confusing: there are no conventional zones with NVMe. And why
would a problem with NVMe require scsi patches ?

> Changes since RFC v2:
>  - Replaced open coded check for enabling sdebug_sector_size > PAGE_SIZE
>    with blk_validate_block_size() in scsi_debug.
>  - Replaced open coded check for enabling sector_size > PAGE_SIZE
>    with blk_validate_block_size() in sd driver.
>  - Replaced 'struct request *rq' argument in  'sd_set_special_bvec()' to
>    'struct scsi_cmnd *cmnd' and used that to get SCSI device pointer
>    'struct scsi_device *sdp'.
>  - Slightly modified the commit title for scsi sd driver fix patch.
>  - Added "Cc: stable@vger.kernel.org" tag to scsi sd driver fix patch.
> 
> Changes since RFC v1:
>  - Re organized the patch series into one patch for scsi_debug driver
>    and one patch for sd driver.
>  - Updated commit title and description to accommodate the above
>    re organization on commit titled - scsi: sd: fix write_same(16/10)
>    to enable sector size > PAGE_SIZE.
>  - Updated commit title and description to reflect the re organization
>    on commit titled - scsi: scsi_debug: enable sdebug_sector_size
>    > PAGE_SIZE.
> 
> Thanks to Bart for feedback on the RFC v1 and v2 series.
> 
> Testing:
>  -Test suite: xfs and generic from fstest + QEMU emulated block
>     device(scsi and nvme)
>   - fstest Config for patched xfs 16k block size [xfs_reflink_16k_scsi]
>     TEST_DEV=/dev/sda
>     SCRATCH_DEV_POOL="/dev/sdb"
>     MKFS_OPTIONS='-f -m reflink=1,rmapbt=1, -i sparse=1, -b size=16384,
>     -s size=16384'
>   - Generic test results
>     Baseline: 6.18.0-rc7 kernel + nvme 16k logical block size
>     Patched: 6.18 kernel + scsi 16k logical block size
>     5 failures seen on generic tests and the same seen on baseline
>     No regressions introduced by the patch.
>   - XFS tests results
>     Baseline: 6.18.0-rc7 kernel + nvme16k logical block size
>     Patched: 6.18 kernel + sci 16k logical block size
>     30 failures seen on patched and baseline
>     No regressions introduced by the patch
>   - Blktests results
>     scis and block layer tests with 16k and 32k logical block size.
>     config used:
>     TEST_DEVS=(/dev/sda)
>     EXCLUDE=(block/010 block/011) # these didn't run on baseline(nvme 16k)
>     All tests passed.
> 
> Link to RFC v2: https://lore.kernel.org/all/20251203230546.1275683-2-sw.prabhu6@gmail.com/ [1]
> Link to RFC v1: https://lore.kernel.org/all/20251202021522.188419-1-sw.prabhu6@gmail.com/ [2]
> 
> Swarna Prabhu (2):
>   scsi: sd: fix write_same(16/10) to enable sector size > PAGE_SIZE
>   scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE
> 
>  drivers/scsi/scsi_debug.c |  8 +-------
>  drivers/scsi/sd.c         | 27 +++++++++++++++++----------
>  2 files changed, 18 insertions(+), 17 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
