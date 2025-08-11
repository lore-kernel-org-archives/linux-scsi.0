Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B43429408;
	Mon, 11 Aug 2025 00:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754872755; cv=none; b=bv0xvMT7oCGVBdHjpj/ZoXU52ekZo7CpDO1j8ISLTengSMC6YKYbqmU2A4zRI3dZEoYlWi8Q4d+tonpuPSBoxHiXZaASm3fa3Asv+QJ/R+vGzdk6we3utIsWp1nYfYsCkKoEWQ6rYkdoQ9yU64/7H1hLqv35ZY2dlXvif6MzgUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754872755; c=relaxed/simple;
	bh=kPeMuCB6QJFDshLklF3UYJhha1x4oPLphCzKTQrOa4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fndiEU5Asr1hgIz6F8coeikEj2vMi5kHloyI1HRVV0XI4S4EZXYpvE9Jcb8HD37EHBbaHAF1EyxbVP07hJzYmgmylkApV5gE+sSmmafuIquvsLQ5b6YF8BmQjK166rKXb+9lY4Z4WfAefrpmsh8iS5JLk9zfUWrJ4uXSbTLaxbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YuPUK9hD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YuPUK9hD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A8FC4CEEB;
	Mon, 11 Aug 2025 00:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754872754;
	bh=kPeMuCB6QJFDshLklF3UYJhha1x4oPLphCzKTQrOa4Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YuPUK9hDPxCpKa66dyL/UiyJ+wbhsRiD0E3lieYtSfuDRaGydSxm92u/E5o6ywhF6
	 tCFlfBifJyVrfJgHUw174xlEz0VYi2INOXZUCqpEKdiP9ntHgSJhCwd3z9cFguMMwy
	 wTUbUuFTX2YrjPY0U7F+E3TWgammprGWK+7cqFmlsS3MCEyH9vAoMq78XQrQN6AYPS
	 I0XdGSsIum1u1wgocGgcNwroaWNV9YJovFMpUFdhHa2tAQmw2aySTovEkMPdTRoYSF
	 Ih1EBAVGdVIyT5j6lapdHz8KkLsbw0++f9g8cn8rgEzOX0ra4He2qbVKCMLyfLY9bw
	 ddhfo/4cRm1sw==
Message-ID: <0ea8a29e-550e-4d3e-9e25-e3b6e64e05a0@kernel.org>
Date: Mon, 11 Aug 2025 09:39:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/2] scsi: sd: Fix build warning in
 sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, bvanassche@acm.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, kernel test robot <lkp@intel.com>
References: <20250809093507.372430-1-abinashsinghlalotra@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250809093507.372430-1-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/9/25 18:35, Abinash Singh wrote:
> This v6 series follows up on v5 of the "scsi: sd: Fix build warning in
> sd_revalidate_disk()" patches.
> In v5, the change was split into two
> patches: the first patch refactors sd_revalidate_disk() to return void,
> and the second patch addresses excessive stack usage by allocating
> certain structures dynamically.
> 
> Apologies for the oversight in v5 — although I built and tested the
> kernel locally with the correct changes, I mistakenly sent an older
> version of patch 2/2 that still had `size(*lim)` instead of
> `sizeof(*lim)`. This caused a build error reported by the kernel test
> robot when building with clang.
> 
> Changes in v6:
>  - Replace `size(*lim)` with `sizeof(*lim)` in patch 2/2
> 
> 
> Now there are no build errors.
> I am very sorry for that .
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202508091640.gvFPjI6O-lkp@intel.com/
> 
> 
> Abinash Singh (2):
>   scsi: sd: make sd_revalidate_disk() return void
>   scsi: sd: Fix build warning in sd_revalidate_disk()

The order of the patches must be reversed because the fix build warning patch
must be CC-ed to stable with a Fixes tag. The cleanup making
sd_revalidate_disk() a void function must come after the fix. That will avoid
the weird placeholder comment and also will allow a more extensive cleanup to
replace several "goto out" with a simple return.

> 
>  drivers/scsi/sd.c | 54 +++++++++++++++++++++++++++--------------------
>  1 file changed, 31 insertions(+), 23 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
