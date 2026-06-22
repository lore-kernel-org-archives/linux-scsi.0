Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D089394470;
	Mon, 22 Jun 2026 11:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127733; cv=none; b=FLzEbJ1DuOBFKyneriYouBclfSFpm7PDZ1g3urccjGSY4JNYw3i1c2JOWsRHS5dYhAT691SdteCclBqyZc9EFNJ9rBQJmgb//YEP4y0di7muyxRZ1fWRiJNMCliYpv2Ta8XTCIQ3xrDrPSs8Ym2Sz/heNYIu1FrP+d6OwJT/8uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127733; c=relaxed/simple;
	bh=XdRECqXYe1KnAXTmQNoylQzwWrdmt8+Trs2xvLpbfOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2x8Ks91PaEud6HBCKY2gkZu0FHFkrX/oH0/UmEyefb30jpF11+d+qMZT3Vy6HRIfXj1R5HQYumKYrm0mG7JpaO1BS/5Mm+5mrTjtZN/VUttyZU9DH1TsH2h2Y52GBO0vsIDFlzGp/zxl90W1R+sJ+Dy513jSrC4lg7g/fyHPO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fq1T3j98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fq1T3j98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890221F00A3D;
	Mon, 22 Jun 2026 11:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782127732;
	bh=1UmqeA66hgQjEdJc0aXUNf18qsRkBUPy8ynDN+0JXTs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fq1T3j98XDY5XoiSAyoshL6vNPp50fCyXvNzemRvmsKmAPPObbo67lVnilF0mwHii
	 mysYM9l1abYwbepPWZ6YOKN1G6tKgBp2vNgY5Ma7SQ5TLcdfHQRu2m396t6jL07kWb
	 gT6Rslk/itIHY+nBUCxwfypphWclFZHcMGfWRs6KjlRzdRV/sYm03lt4A2ngDUzmHQ
	 yxj8C9IQA9lIo9VQeiNqPEnRxAPDXMZMg1l1TUIvC6GdFSJKS19KAeCOPz9GztbNgK
	 Bxb5i5+HGcOdvLBBcjye5nWp7Ex6tJ7AewyuDHNppFb0IUtwulx+0uXMOjZp9+4inK
	 srz0mr6kX0Fyw==
Message-ID: <841e8ff7-12db-4ca4-aaa5-fb8accfc9df0@kernel.org>
Date: Mon, 22 Jun 2026 20:28:48 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND 2/2] scsi: mpt3sas: add hwmon support
To: Louis Sautier <sautier.louis@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Guenter Roeck <linux@roeck-us.net>, MPT-FusionLinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-3-sautier.louis@gmail.com>
 <93542109-2101-4d62-aae4-bbf058029663@kernel.org>
 <airk3Os03wPV0rvW@localhost>
 <fdea1a8b-d631-43d8-bcf0-1c79e635782c@kernel.org>
 <ajkaf0aa0TWXdRZW@localhost>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ajkaf0aa0TWXdRZW@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/22/26 20:20, Louis Sautier wrote:
> On Fri, 12 Jun 2026 08:34:13 +0900, Damien Le Moal wrote:
>>> If I dropped SCSI_MPT3SAS_HWMON, I would use
>>> "#if IS_REACHABLE(CONFIG_HWMON)" to match what i915_hwmon.h and
>>> xe_hwmon.h do and properly handle the SCSI_MPT3SAS=y and HWMON=m case.
>>> What do you think?
>>
>> That seems appropriate. If there is a clean way to avoid adding the new config
>> option, we should use that method.
> 
> Hi Damien,
> 
> I did this in v4. Could you please review it?

I saw only patch 1/2... I was waiting for the new version of the full series.

> 
> https://lore.kernel.org/linux-hwmon/20260613023833.3163507-1-sautier.louis@gmail.com/


-- 
Damien Le Moal
Western Digital Research
