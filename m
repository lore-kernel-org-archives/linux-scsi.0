Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0963603EE
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 09:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723888; cv=none; b=PeunSmZC3XFwQlpGAR2owqJFO2isuwvAhv9I2Hh5p3EM7ABlWMt3/Htq+znV2Fwo77JHoZo9KaKV7htSmkDML6jfLVjZN7cuy3SrBpT6sY6V7IgQjSKPEgzgL05MA3ObqxOMEO/nQW8fEDC4S1CkhWMON/hzcM9Gi4RFt9LRXI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723888; c=relaxed/simple;
	bh=0iBwTV6L4uWWxmFKqRrXBF7p/mtFV/zkggMOy+zQE6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BJmpy3s473B8LKc+W0/EGaxlP46scuNR4H1Jhx1aic0ukf4g+wgXZQpdgn0+oGQmrGvVJlIlBZaqHAPJ8zGD4VagSp4iOChJzyHt3+dx+t8v39Gjen6uJKZ0F4zuY+Ubcr4nYvQqP10wnGw7rHH7ixL7LImZTFTL8KZC2lcxWW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHPOiIS5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHPOiIS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F353E1F000FF;
	Fri, 18 Sep 2026 09:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723887;
	bh=QlbhBq7oOcb1E01iyJI/v0xQecPWthHcUL+wF8OuhGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SHPOiIS5oiwfyHoyx7/6upz4kWpt3EKKJidgwInvzJWIslcZQI5FVjMC96se3j9/f
	 3UKZ+pB2l6GG05j2FGphtETkwSmFjJgydPJZqfrxFxDLo68Vr5u4oClAqrGuU5qWHJ
	 yiUtYQOg6KWpKbACZc+xQ6GEp3OebKFyuFtcn/6FYFJJ2/tFTVewG1MObDJfVlfr2G
	 Ax8xg8AnqR2/czcDK9UjEnCSAFDuSk5wJHufTwFALVScCSRdiJzEadSl6Wa8sqIfYk
	 iRxk30mvSIwquGOb4BK5TInWNIY97hrmFdUgYUghlbIGPRXTdVsFNBUXuW/MBa9pZ9
	 SMD895k0/9cow==
Message-ID: <cbae6ecb-21da-4fac-8a44-ba9072009159@kernel.org>
Date: Fri, 18 Sep 2026 16:31:23 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/10] scsi: scsi_debug: Do not write a partial
 physical block to a zoned device
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-19-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260918062910.1709791-19-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/18 13:29, Niklas Cassel wrote:
> do_device_access() copies one logical block at a time and stops at the
> first short copy, so when the data-out buffer is smaller than the
> transfer length of the command it can write part of a physical block.
> An initiator can arrange that with SG_IO.
> 
> A write that does not end on a physical block boundary is perfectly
> acceptable to a device that is not zoned, and to a conventional zone,
> where the device reads, modifies and writes the physical block that the
> write falls in. ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2, does require
> a write to a sequential write required zone to end on a physical block
> boundary, though, so a partly written physical block is not a state that
> such a zone can be left in.
> 
> Stop at the last whole physical block that the buffer holds, for a
> sequential write required zone only. The bytes that are left over are
> not written, and are reported to the initiator as part of the residual.
> 
> With the default physblk_exp=0 the physical block size equals the
> logical block size and this changes nothing. Nothing changes either when
> the buffer holds all of the data that the command asks for, so a command
> that transfers fewer logical blocks than a physical block is unaffected
> wherever it is legal.
> 
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

A bit shift would be nicer than a division... But nevertheless, looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
