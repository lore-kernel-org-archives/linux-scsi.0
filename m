Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D734F30216D
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650392; cv=none; b=r+pwTQPcVQ3ThUxQ63DyiynjHWB7vB4QOEhEmFabsNkmfy+NJrtPZTGEiGqMYtzYUNLfEDKTul0nmhP6wmfoJaFvZPul3hlJDHVD5LyLk12z5znkHNIiTBvxRfzLlP1yFWFZxRuEQfteVGdnt0CNBnLsCDpTzjZHSc83eFF4ybc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650392; c=relaxed/simple;
	bh=vgBdzLL/ZfcUw/fDiS1+ZEKxmUoaNTEpE0+G4YMpDwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ABKvRGj1V7bUOKWuMn7qB9cYK9vp+jrL665HJSDwFgm5NWC/bspM8+I2kdqL6CX4dGDCnpWfzyCd9/H40X66NC5BZA6PSHyL8S8ckevSdQbCr0om0qvadQXj5xnYIGqGM5/v/SJdNGHcdbV7OHA5QTO0nceWZRj4x8THhiP0jL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M3A+afEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M3A+afEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFCA1F00893;
	Thu, 17 Sep 2026 13:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650385;
	bh=6SRwejQl7W/4EfNno9evF4ZGvzo9FdukuLyqRkrwaOw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=M3A+afEiRI+q05ObsVzGn9TGIrrQWmeITimckL5w5W+d7nbkZ3q8poavwU0mhsqKU
	 V5OPk0yfQ6Rs964+C00EkueQXYu1bYWh0p14fKEMRBad1L35xcBkkrJ7PLHI7ihkNV
	 TFcpWCI43kHACwqla1Rxaxes5H553n5wcTkNyn2h9HaLR/D06SkXIwVASqxPy8jpxU
	 e10QnIJoJBhaS4kgsSYciiHImfbhrZIx3PAOSSEorOVEE89g2s4PGAD5jXV4yOMU9O
	 TQhWnTmXHR7kFX2PQMRBoNesDmEa+tSqxKUb6I5Af5FrcuQ3wZ1rRvx5gikFnWpt/i
	 NrxEfpOOm4jgA==
Message-ID: <44588dbd-8940-4fad-8ea3-407ac182515b@kernel.org>
Date: Thu, 17 Sep 2026 20:06:21 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] scsi: scsi_debug: Report the residual of a write
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-9-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917125445.1376493-9-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 19:54, Niklas Cassel wrote:
> A command transfers the number of logical blocks that it asks for,
> bounded by the data buffer that the initiator provided. When the buffer
> is larger than that, the bytes beyond are not transferred, and the
> difference is a residual that the initiator is entitled to be told
> about.
> 
> resp_read_dt0() reports it, as does resp_write_tape(), but the write
> paths for a disk do not: scsi_get_resid() keeps the zero that
> scsi_debug_queuecommand() initialised it with, so a write with an
> oversized buffer completes with GOOD status and a residual of zero, as
> though the whole buffer had been consumed. A READ of the same length
> into the same buffer reports the residual correctly, so the two
> directions disagree.
> 
> Report it in resp_write_dt0(), resp_write_scat() and
> resp_atomic_write().
> 
> resp_write_scat() needs a different expression from the other two. Its
> data-out buffer holds the parameter list header and the LBA range
> descriptors as well as the data, and sg_off walks over all of it, from
> the offset at which the data begins to the end of the last range that
> was written, so what the command consumed is sg_off and not the number
> of bytes that the last range transferred.
> 
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Yes. That goes with my comment about partial writes on v2.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
