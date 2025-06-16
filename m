Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A111311AC
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 06:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750055166; cv=none; b=G/cJuwBJGg26PRXaQLnvFfWQap8Do1bbLySPPmsaaoBw5JxV5Cbb4HkkD4VHuccH9Kc/WZhvdWP0JhAyjeQY3XbfjIY0/5K9IlHLc+5XWMb45QRFM8TVrYyjWPDOUuk+GjA24WNmoBrVrfU9O72UjUHLkcbDaK6lQtBYyBvGZWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750055166; c=relaxed/simple;
	bh=0a6FITpv9fPhysVGkT5kl7Ebf4NzUFva2sD1Pb8pE3g=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=nPIDVraMo3chYwNXaqwPBVFjPBT5Lgo4ZxXXfIL0iCAbre2vuVpaqCCwebgH2bsDV5xVPNf6MdGXg3Dix3bLwqgn+wN+lMlNfGdxTGAR7NABjAwC262ZCip0daFsHqPNWBfCy1sRrGbHPz8QtlOIQfLDm1gEuXk35r7usjp8/qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5wg+pmU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5wg+pmU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B52C4CEEA;
	Mon, 16 Jun 2025 06:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750055165;
	bh=0a6FITpv9fPhysVGkT5kl7Ebf4NzUFva2sD1Pb8pE3g=;
	h=Date:Subject:From:To:References:In-Reply-To:From;
	b=k5wg+pmU9nj2MD0vW5yYHLVRVaodq7zPvXNPwTaN6UVW+0AonTshZcf+OWR5OuCDe
	 ywVjkAhb/aLALJvTPDno4MVy+FYFJLbXxTDqm+DQ48U9E0busj+Z8G0ODaZwN06Zr7
	 gfTBAxKKNzMplAMfpRuwrJOce1o1WGtKwvcK0yvWjssezX9hdaXjqpRXBuksO8q6Y2
	 dBF125ZJBHJOW1tWuDJAJqyUQyoKFI7mKyb7YFH+a99tYel3K65xhrnKE1JnCFNUrv
	 gjtxE1cCfk6CfdBQtge1n2IMVvws7WDsAF7vLtIn1d7odA0Cq1F5OH5mKfi98LbScE
	 +HD9fR+h0ei8Q==
Message-ID: <d9190582-c304-45a5-a0a2-90e1e2eb3400@kernel.org>
Date: Mon, 16 Jun 2025 15:26:04 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: sd: Set a default optimal IO size if one is
 not defined
From: Damien Le Moal <dlemoal@kernel.org>
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250613062909.2505759-1-dlemoal@kernel.org>
 <20250613062909.2505759-3-dlemoal@kernel.org>
 <b20bde78-5f11-4700-9f99-e9bf4bc31e85@oracle.com>
 <690b0726-f183-4ec7-91fa-ad3c706ba2bc@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <690b0726-f183-4ec7-91fa-ad3c706ba2bc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/16/25 14:34, Damien Le Moal wrote:
> On 6/13/25 23:31, John Garry wrote:
>> On 13/06/2025 07:29, Damien Le Moal wrote:
>>> Introduce the helper function sd_set_io_opt() to set a disk io_opt
>>> limit. This new way of setting this limit falls back to using the
>>> max_sectors limit if the host does not define an optimal sector limit
>>> and the device did not indicate an optimal transfer size (e.g. as is
>>> the case for ATA devices). io_opt calculation is done using a local
>>> 64-bits variable to avoid overflows. The final value is clamped to
>>> UINT_MAX aligned down to the device physical block size.
>>>
>>> This fallback io_opt limit avoids setting up the disk with a zero
>>> io_opt limit, which result in the rather small 128 KB read_ahead_kb
>>> attribute. The larger read_ahead_kb value set with the default non-zero
>>> io_opt limit significantly improves buffered read performance with file
>>> systems without any intervention from the user.
>>
>> Out of curiosity, why do this just for sd.c and not always set up the 
>> default like this in blk_validate_limits()?
> 
> Good point. Though I think we do not want to have a large io_opt for slow
> devices like MMC/SD Cards. So something like this, which is indeed simpler than
> hacking lim->io_opt in sd.c.
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index a000daafbfb4..d3ec6f4100f4 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -58,16 +58,24 @@ EXPORT_SYMBOL(blk_set_stacking_limits);
>  void blk_apply_bdi_limits(struct backing_dev_info *bdi,
>                 struct queue_limits *lim)
>  {
> +       u64 io_opt = lim->io_opt;
> +
>         /*
>          * For read-ahead of large files to be effective, we need to read ahead
> -        * at least twice the optimal I/O size.
> +        * at least twice the optimal I/O size. For rotational devices that do
> +        * not report an optimal I/O size (e.g. ATA HDDs), use the maximum I/O
> +        * size to avoid falling back to the (rather inefficient) small default
> +        * read-ahead size.
>          *
>          * There is no hardware limitation for the read-ahead size and the user
>          * might have increased the read-ahead size through sysfs, so don't ever
>          * decrease it.
>          */
> +       if (!io_opt && (lim->features & BLK_FEAT_ROTATIONAL))
> +               io_opt = lim->max_sectors;

Oops... This should of course be:

		io_opt = (u64)lim->max_sectors << SECTOR_SHIFT;

> +
>         bdi->ra_pages = max3(bdi->ra_pages,
> -                               lim->io_opt * 2 / PAGE_SIZE,
> +                               io_opt * 2 >> PAGE_SHIFT,
>                                 VM_READAHEAD_PAGES);
>         bdi->io_pages = lim->max_sectors >> PAGE_SECTORS_SHIFT;
>  }
> 
> I will make a proper patch of this and send it out as a replacement.
> 


-- 
Damien Le Moal
Western Digital Research
