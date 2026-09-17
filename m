Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFCD511E7C
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650313; cv=none; b=qdXXCqHfUirzNPgDGVvD2gFhuKQ9xjCCGoTND63778OYATaRMTlfYWYJNnduDRbPBxfvuwu2AtHuzRb68P2j8x+qfvsrmJl7AdYS6zWLky0n2iN8N8sBc9gDPEq/v+ImMHfBF+dGLTJ0f6VzK9ZrslOdeIkiXq5FjGMMLYoR07Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650313; c=relaxed/simple;
	bh=HHsU542siJC/GQYL4WPQZjIRJJfIUAL7xLSMyJNiqcw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qakgD+kQejXfIirf5N4BAowMEQ8W+nq/WkDu03BulZm8efJbX55vvo2WI7uvUkZhJbweHGCQIoiU8UGOmvNqfZY7tyMcNNWp6q46OWmITxSL3ydvj35CutNeL8VDV0HmRV6VurACCoRD4vbKhH9Hs94t7WYDVWDdj+uqfon1Vdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxoiiHcw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxoiiHcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5659A1F00893;
	Thu, 17 Sep 2026 13:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650305;
	bh=DYM3UAxCoTSLEVDuhraRzdpHcEZIkMXdjKWl/9dScxs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AxoiiHcwdd4EIq/2A/h9s6RO8N4AfRXlftnsdKdcKzdVepo7oSKk2Tox+iLatug7P
	 pms7sUi4sbz0w0MV6yKjBxjl0q+LeKEulQAOITQdSp6bjzHhflxi8VRj7Whig3Ak/z
	 35782HveKUlFJ/J8q0KAhZYLhgJEDR2cCW7O1VOnqOJhf/LCk7x533n9YJhPQctbZy
	 f43DKlckdhN/d903jcsUz8yNVXR2U467hJMzRPO/T8QwLRxD4w9CivGu1LYI8I97vN
	 xTMbjeFSYJpJ4mF11w3jmADT+8mMzDrLfagLPyRj51r/a4sygSPX1fK2DQ1Oy63mBS
	 CY/uvzj+q2JfA==
Message-ID: <5b585814-4a4c-4f95-9a42-db414bff40d4@kernel.org>
Date: Thu, 17 Sep 2026 20:05:02 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] scsi: scsi_debug: fix zoned write validation
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917125445.1376493-8-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917125445.1376493-8-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 19:54, Niklas Cassel wrote:
> This series fixes scsi_debug with regards to writes to a ZBC drive.
> 
> The series is based on 7.4/scsi-staging rather than 7.3/scsi-fixes (as
> Damien suggested on v1) to avoid a build warning that would have happened
> if this series was simply merged with linux-next (7.4/scsi-staging):
> 
>   error: too many arguments to function 'mk_sense_buffer'
> 
> Tested on a zoned scsi_debug device with 512 byte logical blocks and a
> 4096 byte physical block.
> 
> Changes since v2:

Slow down please. I was still replying to v2...

> - Added patch 1, to that write paths correctly report the residual.
> - Added patch 2, so that do_device_access() will always write a
>   multiple of physical block size. (Reads are unchanged.)
> - Patch 3 changed to advance the WP by how much that was actually written
>   (rather than leaving the WP alone when not all blocks were written).
> - Patch 5 changed to take the meta write lock if scsi_debug_lbp() is set.
> 
> Niklas Cassel (6):
>   scsi: scsi_debug: Report the residual of a write
>   scsi: scsi_debug: Do not write a partial physical block
>   scsi: scsi_debug: Advance the write pointer over the data written
>   scsi: scsi_debug: Enforce physical block alignment of zoned writes
>   scsi: scsi_debug: Map the region written by WRITE ATOMIC (16)
>   scsi: scsi_debug: Validate zone access for WRITE ATOMIC (16)
> 
>  drivers/scsi/scsi_debug.c | 66 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 60 insertions(+), 6 deletions(-)
> 
> 
> base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae


-- 
Damien Le Moal
Western Digital Research
