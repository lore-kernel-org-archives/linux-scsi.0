Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7D149CF3E;
	Fri,  9 Oct 2026 09:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791538501; cv=none; b=aZqXsRJDjWLsUNuSweh0uhibtYL1OXiLfmHRnCHuZQqy1KFHE8ux6z2O63tCe+r+h6aYdjizxemoRiefEuzo5brtDttwILaLtyG91xQvFt19DDqmSk7XwKZ77swDgH0+H9UDR0M1GEttse9MdUb3BE4VLrhkzEvfEPzQpCs7KWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791538501; c=relaxed/simple;
	bh=zfJEEs7Jq74piTrENgb/IDsjEXNu2LCR36B/5XZnKN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uuvv3SkVIOLrgeTEXtPNFGBGKm/YXp4PtWUQHQBlQNFCrkll+BV6acwpZUoEE5aB9UY0AkrO7VfigeqoJAAmniVm82Zkx1mQL3DKNkQ0g59Gde69WRphBt1g6WbYyOsHWQKlCX/wPq/ZAD/vpvX0GReZ7AsZZkFO1IevpOte1sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5Ti7XYf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5Ti7XYf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554FA1F000FF;
	Fri,  9 Oct 2026 09:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791538495;
	bh=lP7jMZ9E1S5Zw2lSz0ohcXUprpggvlJXd1XUkACl8xM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k5Ti7XYfG45I/GNCp5KdXcFqHd3xL6Y9lV8EEjBQbKlmNihz9BJFpKRAKPmCCjvU7
	 6aAMuSHgMRX1blHag1E3JWmvD6JruV7YW3fsL9n44nQLAsXytE/T379d3/RnZPbUPL
	 2hpIcIQivVdCFs/rsWO6/TXBkBz0TdjPjnZh02NORDsan39Q6Dmjoy1/PH0T/N/CNt
	 ZNYkgVao7vOnebC55xLrk9Wm4UhLr4ORbQWm9+9u+JC+iUIqaMp05fQAwUt7bu4RE/
	 3lr+G/ye2w0y/lFSbnHzdVOQx/obwjg0JT/3uNq7uXLikHvbzULrb5v6rGvMNUjUv8
	 kVmrGeO8gpx8w==
Message-ID: <01883533-837b-47bd-93df-aba3fbda997e@kernel.org>
Date: Fri, 9 Oct 2026 11:34:53 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 8/9] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20261009090945.1504194-1-dlemoal@kernel.org>
 <20261009090945.1504194-9-dlemoal@kernel.org>
 <sashiko-outbox-165171@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <sashiko-outbox-165171@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/09 11:32, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] scsi: sd: data race on struct scsi_disk bitfields can clobber WCE or modify_zones_supported
> --
> 
> commit a445da75935ac3ec4cee9fc525679769cf828446
> Author: Damien Le Moal <dlemoal@kernel.org>
> 
> scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
> 
> This commit introduces a new check for ZBC devices that support data preserving
> head depopulation to ensure zone conditions are properly revalidated. It adds
> a new modify_zones_supported bitfield to struct scsi_disk and sets it during
> sd_zbc_read_zones(). The flag is then used to skip or perform zone revalidation
> depending on the disk's support for this feature.
> 
>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
>> index 574af82430169..6a72371fee786 100644
>> --- a/drivers/scsi/sd.h
>> +++ b/drivers/scsi/sd.h
>> @@ -156,6 +156,7 @@ struct scsi_disk {
>>  	unsigned	ignore_medium_access_errors : 1;
>>  	unsigned	rscs : 1; /* reduced stream control support */
>>  	unsigned	use_atomic_write_boundary : 1;
>> +	unsigned	modify_zones_supported : 1;
>>  };
>>  #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
> 
> [ ... ]
> 
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>> index 8cbf171e6fabf..1bf5f7ea0d9c5 100644
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
> [ ... ]
>> @@ -620,6 +641,9 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
>>  	if (ret != 0)
>>  		goto err;
>>  
>> +	/* Check if REMOVE ELEMENT AND MODIFY ZONES is supported. */
>> +	sdkp->modify_zones_supported = sd_zbc_check_modify_zones(sdkp, buf);
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> [Severity: High]
> Does this bitfield assignment introduce a data race that can silently corrupt
> neighboring bitfields like WCE?

Maybe... But this is not a new issue. All "flags" of a SCSI disks are defined as
"unsigned int :1" bits. Everything should be rewritten to use a proper unsigne
long bitfield with bit manipulation functions. So I am not going to fix that here.


-- 
Damien Le Moal
Western Digital Research
