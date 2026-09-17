Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E4C4FECD5
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650265; cv=none; b=vFgXa9/+Sw9ijjpwESuq8C4LodZGfG0s0/ASsVkF9UscKa1Th5jPp64ODSoSbHUfcLUrXPEMc6iCeBy4utBuY7Ub7LYIJV+o/TYjYjqqeXgBapvLqEx/ellHIivJIZYTRmP5sSmzz8AQbLSErPwbCXnkB22fKVWszf31wW17KSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650265; c=relaxed/simple;
	bh=bscUQyMuiS2iF9PFyE4V4XDtjt5hZc/DtTlLl9RtgoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RQA+hbzNkpuSeVk1hPRuTvP1je4fSP6jWTmNzqDkPD/LNLGV325wtClWu5IyTIIVQzZoVe7QYT4KSkBlWTIsngyifmK7IUXXxdUVERe2A6/wBsZ8X9JUf7UzufZl/xHkbhk9cwiYdQ+7TTCzEjixlNE5JdgODVhX2n57CMRhvZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FReWbnqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FReWbnqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1411F00893;
	Thu, 17 Sep 2026 13:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650258;
	bh=vMjqbqs5JAQvWI7qTmiaXL3fFfpjEWGoTtSTHzrVtOc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FReWbnqzu1ugDtNgF6s4kS9T9uPmiB5o+4NzLDN4iD/AKMjmFyc8D6mi37ITMiEOk
	 f4mPjfCra6UMcB9LCKT7CdeGVM+wzTf6P+t17Boij0bUOg/TOuiC826yrk11VLKd8R
	 sB8ixNlFfRPrrsKaWbbkn7whGfiXADywshdFTfPMH8Eojejq/kHbQBvFkLkvOIlAq9
	 XyHQJ/TaJ6lp7M4uJY6YvYijDtwzpu/GXnek5rXnXforIBCghG2j7Ts5gBVyI+hW44
	 P20rAjjoL/KvjyoouDF+ZSJX7Zrhq1qs3F+BjDBKZAzS8A4WapV/Qiun1ZrtjRiPm1
	 W4+zjeMtrHd7g==
Message-ID: <1345da61-5f5b-4c69-b376-ed8e25df436f@kernel.org>
Date: Thu, 17 Sep 2026 20:04:14 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] scsi: scsi_debug: Map the region written by WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917110316.1104863-6-cassel@kernel.org>
 <20260917110316.1104863-9-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917110316.1104863-9-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 18:03, Niklas Cassel wrote:
> When logical block provisioning is enabled, a command that writes user
> data marks the region that it wrote in the provisioning map, so that
> GET LBA STATUS reports the region as mapped. resp_write_dt0(),
> resp_write_scat() and resp_write_same() all call map_region() for that.
> 
> resp_atomic_write() does not, so a WRITE ATOMIC (16) leaves the
> provisioning map untouched, and GET LBA STATUS keeps reporting the
> region as deallocated after it has been written. map_state(), which
> GET LBA STATUS uses, is the only reader of the map, so that is the whole
> of the effect.
> 
> Call map_region() the way resp_write_dt0() does.
> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
