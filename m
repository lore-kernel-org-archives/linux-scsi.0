Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994D5390CBF
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723961; cv=none; b=sym16xB/acMRbtuJ+VwIef12fiLfzrpB6R9+NFau2Yje1Esp5Gjvm9ev2YRiR2q/42jyzIpylNwHx+PyDDs9h3CpS1yXF73HqJmnFfDcC6pzOdzIC9k7waklcBc5gN2eyL3LI5KbrETDP0zpwZkYQDC1RnR52dggpzIF759+GrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723961; c=relaxed/simple;
	bh=Z8senjw/V0b88kMjZnf1MRC1MqLpJs5u9EeU/bsFoAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNhwS/PrZZPjulGVNWsgqR7ZS0XcEYZxgO1vsGA6L4P/YZSbQdmNcn9j4r436jxwoe6U78ICYb0F3e5xK/McGVGGzxSH+WExNrd6iN5nbxEvlGnqykGCjqnAhPhAyh4FwBlF32IK9vNeGDkKaOjmslqA7WpA1DsPx014ieTNums=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MigwwM1v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MigwwM1v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1A51F000FF;
	Fri, 18 Sep 2026 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723958;
	bh=cHu++a1KbVVGLvhwReAqaZNTXdv3h4apWLDNwzmQNtY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MigwwM1vX/SG1MVkLQnkkVQvopaxcoYr/r4lf7uKeVn+GI1DXWACQzn+8QgtxqVWk
	 nWltp/GoGvIO0Fr7n6Y+I6cPJ9AFp+D3P6YkUPBW8ZryTRYxYdLy8PF+8mJpbHdZqJ
	 APicQru1rx1nlX1phomu4Fj+6NvEqWXn5mByRe/nePFsLAvwxJHp4csjEBtLDOLuQp
	 ini9TNKtF2PHZUVxhq4OJZtkdCOTnVzSTlQO9HjtAsRogPTdXj7j82UiXKwKFg/qKo
	 bbQeDtRz6k7G7/V23QnCDnNVRH9WW/v3pS3/WrvYvFLLNnA2dhjwCYaoTxI4Gfisel
	 udRwJcE3tj17w==
Message-ID: <39f04d92-df87-4e36-ac8f-0f0925c7e729@kernel.org>
Date: Fri, 18 Sep 2026 16:32:35 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/10] scsi: scsi_debug: Validate the access parameters
 of WRITE ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-22-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260918062910.1709791-22-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/18 13:29, Niklas Cassel wrote:
> resp_atomic_write() validates the fields that are specific to an atomic
> write, the alignment and granularity of the transfer, the atomic
> boundary and the maximum transfer length, but it never validates the
> range that the command addresses. Every other command that writes user
> data calls check_device_access_params() first, which rejects a transfer
> that ends beyond the capacity of the device, one whose length exceeds
> the size of the store, and any write to a write protected device.
> 
> As a consequence a WRITE ATOMIC (16) past the end of the device is not
> terminated with LOGICAL BLOCK ADDRESS OUT OF RANGE. do_device_access()
> reduces the LBA modulo the size of the store, so the command writes
> somewhere else on the medium instead. A WRITE ATOMIC (16) also writes to
> a device whose wp module parameter is set, which every other write
> refuses with DATA PROTECT.
> 
> Call check_device_access_params(). The zone checks that it ends with are
> unreachable, as atomic writes and ZBC emulation are mutually exclusive.
> 
> Assisted-by: LLM
> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
