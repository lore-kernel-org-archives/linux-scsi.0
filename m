Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D102D0292
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jun 2025 22:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749767580; cv=none; b=sEZ2n6UPRZNhDyjfj69o1KJW8zpmMHomn7kg8+G9bMGcGP6Fy/2sRvckplJuMDxdz1JUZJGNA4LrtaUG6FnDAUuc/vOJGSd6phgxho0ZcjiB5HmkfF9YqxZO7ji1/yQWkZLhiJtxsz+Dpviv8LJdoWTplQ867lV8fGk9denkYIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749767580; c=relaxed/simple;
	bh=oIItWzyFXLI3vt56ZPO7VcEqlmpezWUXAt/uZPzlzKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oejHkNgx7w5kfiKZCg/mD4PclE1pe6AwsztLvyoV1s04DG7HqD/iXbRlfonsj3KsEl5lr516gZJY4nMfNoypraedtKb/vlAQsS8wLarR2bRfysfQ5+AoLyh8kLRKAsMFxz++YfdberoMCO5A/foQM6p1C5CvPcZ/EISPoFw+Gmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UhYNVce1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UhYNVce1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E6EC4CEEA;
	Thu, 12 Jun 2025 22:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749767579;
	bh=oIItWzyFXLI3vt56ZPO7VcEqlmpezWUXAt/uZPzlzKs=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=UhYNVce1dYz7hFH5hoDfla5AgUU4jU9dA5iD2d/hKB26I8q39/NKrx5Fpf3MS09RK
	 TQrhqL87nFdeyAQA8IhJ0mHBQOqNg0081QtODuv0aAV+e5CU6vV4UkKj1o+yHzu5lU
	 uOoKzC9IhaPE71E5TAz9pO1spCI1f8y8L8R6N3E4NCGLXQIagooB2zWMil6ZAV+0eQ
	 e4XwItGXxF8l2aRDebe08P/f90sPSrBvKJlafu428LshET1ZUi1Y3l8TVs6heICk08
	 XFj1c4COSgu6WPMBjN5JNP45agWpqGIVXS+gL/5JftIjuoj1U49b7sF0iMKU3Z2HP5
	 p9HlU4uVhQ4ig==
Message-ID: <c02d01dc-aa40-40dc-9b64-1805580f99cf@kernel.org>
Date: Fri, 13 Jun 2025 07:32:58 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: Remember if a device is an ATA device
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250611093421.2901633-1-dlemoal@kernel.org>
 <aca75eab-45b4-4afd-8319-e2662fd9d9e8@acm.org>
 <c8cf3ee1-3d65-4241-850c-4539b39f1f5c@kernel.org>
 <5cf544f9-202d-4018-8ed1-0733d48bace1@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5cf544f9-202d-4018-8ed1-0733d48bace1@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/13/25 01:13, Bart Van Assche wrote:
> On 6/11/25 4:14 PM, Damien Le Moal wrote:
>> And no, we cannot avoid trying to detect if we are dealing with an ATA/SAT
>> device or a real SCSI device in all 3 places where this "if" is done.
>> 2 of these used VPD page dereference under rcu lock before, which is rather
>> heavy handed. The point of this patch is to simplify that.
> 
> Hi Damien,
> 
> The code under "if (is_ata)" in scsi_cdl_enable() seems very 
> ATA-specific to me. Shouldn't that code be moved under drivers/ata/?

You seem to be forgetting that when ATA devices are attached to a SAS HBA (one
that does not use libsas), then the code in drivers/ata is irrelevant as it is
not used at all.

All these "if (is_ata)" cases are addressing shortcomings of the SAT
specifications regarding incompatibilities between SPC/SBC and ACS
specifications. E.g., for CDL, the CDL feature has an enable/disable action
defined in ACS but not in SPC (CDL is always enabled if it is supported).

> 
> Regarding the following code in scsi_add_lun():
> 
>   	if (strncmp(sdev->vendor, "ATA     ", 8) == 0)
> 		sdev->allow_restart = 1;
> 
> Other SCSI LLDs set the 'allow_restart' flag in their sdev_configure
> callback. Can this be done for ATA disks too?
> 
> Regarding the code that sets the no_write_same flag:
> 
> 	if (sdev->is_ata)
> 		sdev->no_write_same = 1;
> 
> Why is the RCU reader lock held around that code, a lock that protects
> reading from the VPD pages while the above code does not access the
> contents of any VPD page?
> 
> Other SCSI LLDs set the 'no_write_same' flag in their sdev_configure
> callback. Can this be done for ATA disks too?

See above. If this is moved to ATA code, then it will never be done for ATA
drives connected to SAS HBAs.

-- 
Damien Le Moal
Western Digital Research
