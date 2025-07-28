Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A72C111A8;
	Mon, 28 Jul 2025 02:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753670642; cv=none; b=RdNv2nzwx8PQQv8I+y75YAEZsdBAPKGDgqzN0rz2a+2EbcE8tLqIwP+4A0wePAjjNxrlyilyogN9oVI/xi23PpXIKlxDluZkm1E18fVoKwOpwpp+o31g42vGC+fzeDEUoLWZKosaQg+F1n7oMQsjwgVyi4Q4lGUzhhhmJ0vRGDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753670642; c=relaxed/simple;
	bh=OzhEEhp+0eNPIsR67GztFCL7HtfGeotXjZN/FsaCYZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F8JkuT7gCWRgswEW2XYbEGDiFZn0b+yfzzJeS8Tn4TDPgFt15eKlZoafx8bVzMQbEELpC2QhDqlXHjrPDo4WV0kfes1WjJAB4B4t5GW3atI8QNsYLdNteMfg9J+22HsS0gS1/Ihx1TawhC8BSpr3N19YrBY3OoQssP81+S/UvrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RcwkT0XS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RcwkT0XS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D53C4CEEB;
	Mon, 28 Jul 2025 02:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753670641;
	bh=OzhEEhp+0eNPIsR67GztFCL7HtfGeotXjZN/FsaCYZg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RcwkT0XSF3ji6feUVLv5TJSxAMGI9TiTnPcUsJQLa8JDAG03gfqnSbJTNRD5mWvkY
	 slXKTOJ/1ajBEAvoQ39XoPRUWll+xajFGqfyrQTDilipLZb6d5zTM9aT87HKR7zlRC
	 14O2zeTB/0hqzFURz/TkpQObNP6/WLJRS43Er6MoxajGw/SeZK6NfRr1aKPa+L07cT
	 f6o+P6vsMHAX9AhMXiJej3ueBLZCRaVpiAn097lj7wxJa0Rs8Fgwq9J2QMiG4AZUy7
	 /XcKSijkVQOd/gfVd4CXuAdkn5AZ1e27FTagyidWupLZsezWfK8mrwdGX6LKMWXGOL
	 x9JzEoCVtRSiw==
Message-ID: <655cb7e6-897a-4fab-a8ce-8832f2bc7274@kernel.org>
Date: Mon, 28 Jul 2025 11:41:30 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Improper io_opt setting for md raid5
To: Yu Kuai <yukuai1@huaweicloud.com>, =?UTF-8?Q?Csord=C3=A1s_Hunor?=
 <csordas.hunor@gmail.com>, Coly Li <colyli@kernel.org>, hch@lst.de
Cc: linux-block@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <ywsfp3lqnijgig6yrlv2ztxram6ohf5z4yfeebswjkvp2dzisd@f5ikoyo3sfq5>
 <bdf20964-e1ee-45a9-bf24-3396e957ff67@gmail.com>
 <2b22f745-bbd5-4071-be9b-de9e4536f2d5@kernel.org>
 <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <6ab1be6e-380b-d4aa-dd71-f53373a66e29@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/28/25 9:55 AM, Yu Kuai wrote:
> Hi,
> 
> 在 2025/07/28 8:39, Damien Le Moal 写道:
>> md setting its io_opt to 64K*number of drives in the array is strange... It
>> does not have to be that large since io_opt is an upper bound and not a "issue
>> that IO size for optimal performance". io_opt is simply a limit saying: if you
>> exceed that IO size, performance may suffer.
>>
> 
> At least from Documentation, for raid arrays, multiple of io_opt is the
> prefereed io size to the optimal io performance, and for raid5, this is
> chunksize * data disks.
> 
>> So a default of stride size x number of drives for the io_opt may be OK, but
>> that should be bound to some reasonable value. Furthermore, this is likely
>> suboptimal. I woulld think that setting the md array io_opt initially to
>> min(all drives io_opt) x number of drives would be a better default.
> 
> For raid5, this is not ok, the value have to be chunksize * data disks,
> regardless of io_opt from member disks, otherwise raid5 have to issue
> additional IO from other disks to build xor data.
> 
> For example:
> 
>  - write aligned chunksize to one disk, actually means read chunksize
> old xor data,then write chunksize data and chunksize new xor data.
>  - write aligned chunksize * data disks, new xor data can be build
> directly without reading old xor data.

I understand all of that. But you missed my point: io_opt simply indicates an
upper bound for an IO size. If exceeded, performance may be degraded. This has
*nothing* to do with the io granularity, which for a RAID array should ideally
be equal to stride size x number of data disks.

This is the confusion here. md setting io_opt to stride x number of disks in
the array is simply not what io_opt is supposed to indicate.

-- 
Damien Le Moal
Western Digital Research
