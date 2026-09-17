Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF8B4A2A49
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 09:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789635960; cv=none; b=F9KFWh2tKQBNBbYghjf4J6WwwpOkEmjLWcu2sX6kR4PGHNPE88gppsmjuw8CjuVGhroNdQO39SXT/NLUP/su74EF6kF0fUW67ygN6j+Kt8wHaGwgJdj+5J7+en37gtDqhG2cNiRyxqtFB18/nFbKgbLIYQzT+njb/yVE8n5BfvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789635960; c=relaxed/simple;
	bh=5cX/oP65MoFW6rYDIRopXd6PUJncbKPDV2nopHzEj7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=paXI5/ymBToXUdaKSQ1DInLLzeMue6505lbzl6RStyu0w+b/CaRtFanqOJdzcsY74qpGArLGnAopjQdN3YJZe33JVL9dtvpR6eM+oQOU39gPo+e9xHUhx6gLMrgkUL/HC3tuORlybH6HIoPng/ohdsOP7yR1e/fNpv/nyh36+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJGhrwg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJGhrwg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBBF1F00898;
	Thu, 17 Sep 2026 09:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789635959;
	bh=VH4tGbTlmwmW4LTvEvgYFww7EvqEKi+iRzZZjq4qfsM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SJGhrwg/4GIGRufyGeckzV2XLOb1CyFKg/VVd7mv+gMfMGVRsnPCpPfTnowxc5w//
	 I1RHZawIlUf9OQuI7Zh3102kz60m58IQxO0W0KGEDBFhV/sL5CFoILJJxY2SI9gR62
	 8TQRrYx4HfAy0Jcngg/XhBXHyEMlSxkeJPQw7lv6uLEWDHr6VeH/lQiL40LF3dPqmI
	 mHMTZZA7yKrnKBMxpfCNpn+rfXaN3f/xPfMdYMZG/7qDmE2ufSQGrLhmT67gGO/tlt
	 6DqXT3MbAiDcaP1P3tpm681OBAlMHKUSYL2sw7xC5I6FOn7PJs2J+FQ0F2c2tsQ00d
	 kkeNpVkyekLzA==
Message-ID: <b7472e4a-cf81-4e3d-b44a-94b06214ca5f@kernel.org>
Date: Thu, 17 Sep 2026 16:05:54 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: scsi_debug: Enforce physical block alignment of
 zoned writes
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-5-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917084553.559765-5-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 15:45, Niklas Cassel wrote:
> ZBC-3 r06 (T10/BSR INCITS 579), 4.5.3.3.2 Write access pattern
> requirements for sequential write required zones, states:
> 
>   The device server terminates with CHECK CONDITION status, with the
>   sense key set to ILLEGAL REQUEST, and the additional sense code set
>   to UNALIGNED WRITE COMMAND a write command, other than an entire
>   medium write same command, that specifies:
>     a) the starting LBA in a sequential write required zone set to a
>        value that is not equal to the write pointer for that sequential
>        write required zone; or
>     b) an ending LBA that is not equal to the last logical block within
>        a physical block (see SBC-5).
> 
> That is why sd_zbc_read_zones() sets the zone_write_granularity queue
> limit to the physical block size of a host-managed device, exposing the
> constraint to user space.
> 
> check_zbc_access_params() implements condition a) but not condition b):
> it verifies that a write to a sequential write required zone starts at
> the write pointer of the zone, but never validates the ending LBA. As a
> consequence, when scsi_debug emulates a host-managed device whose
> physical block size is larger than its logical block size, for instance
> with zbc=managed sector_size=512 physblk_exp=3, a write of a single
> logical block at the write pointer of a sequential zone is accepted and
> advances the write pointer by one logical block. The write pointer is
> then no longer a multiple of the zone_write_granularity reported for the
> device, so nothing can write at it at the granularity that was
> advertised, and the zone can only be used again after being reset.
> 
> Implement condition b) as well, with the same sense data as the write
> pointer check, as the standard gives both conditions the same sense key
> and additional sense code. The exclusion of an entire medium write same
> command needs no special case: such a command spans the whole medium, so
> it is already terminated with WRITE BOUNDARY VIOLATION by the preceding
> check.
> 
> The check is placed in check_zbc_access_params(), which every command
> that advances a zone write pointer reaches first: WRITE, WRITE SCATTERED
> and WRITE SAME. Reads return earlier in the function and are unaffected.
> 
> Sequential write preferred zones, which are emulated for host-aware
> devices with zbc=aware, are left alone: writes to them are not required
> to be sequential, and Linux does not restrict the write granularity of
> host-aware devices.
> 
> With the default physblk_exp=0, the physical block size equals the
> logical block size and the new check is a no-op.
> 
> Assisted-by: LLM
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good, but that will be another conflict with linux-next...
May be rebase the fix on scsi-staging and let's push it to 7.4 instead?

Either way,

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
