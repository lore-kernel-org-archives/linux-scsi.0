Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C36E29A2;
	Sat, 13 Dec 2025 03:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765596323; cv=none; b=ok0gjPylbsXUuku85kFv+U7ukU/bK7wOUJD5iSjU4p9S63NPLCcbFjbJ0gBBCBllzWlbvwkTM0wNEpcFVyRHlyBXubd16Sx3SnALSuKGoRaFr7Aq1IwW3xey3Zr3txnc2JLOpZVUChJ39cFFH3kyfK5xSMmfL9WJS4d1Y8OjuB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765596323; c=relaxed/simple;
	bh=EOdGXtchpdfic+rOBoa4glJU7Oaapp5fmsUf6bOes/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EQMHiW7QXuznj9CdJDZ3Wkl/a6S60i9a696JOhHT02RUlMolVcxwwYAWiuF8s4E0vMyK8Mgis0QRCHeDvPKICwC78LgQe2XS6LX2NyeeYytuHBtgaA50Rmg5NzA/rKXSWmV5oMV/zKbVHAtZLpS0ZtlvLuuzxNTS3BmhHb3XPac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ogjtvWqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogjtvWqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27B1C113D0;
	Sat, 13 Dec 2025 03:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765596323;
	bh=EOdGXtchpdfic+rOBoa4glJU7Oaapp5fmsUf6bOes/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ogjtvWqPiOoVT4zbq9h0NWUFEArsmucvCjZyLh94oLHrzZnPQc/k8qwVeFMba2eBE
	 +kJ6CSQ90rzfHAya+hptEZV27eZwNmMQffqkjZxpN4CzG2gFAo43jypiJXL/Qlzcso
	 EKhkBG3OgmOOZw3IuMram1YEHghswlz3QIP28Djd8XIsjTZR2QuUGgEzqK1CfC2nyz
	 XxHWrvDj+cTdue071mNORuU/n6Y5ua4x92NZV8vWM6eK/tyZYTxsFJ5W6I2o/q6mPF
	 NF6rC5X0EGJCRbV/x3GSgSbs7KiIylF7DJQmTj7tyVXyM+OnRkWyfoF116Ol2JRwke
	 nEePQj3fKuaYg==
Message-ID: <985ae28e-1547-46a5-bff0-5925b6544a6d@kernel.org>
Date: Sat, 13 Dec 2025 12:25:18 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: sd: fix write_same(16/10) to enable sector size
 > PAGE_SIZE
To: Pankaj Raghav <kernel@pankajraghav.com>, sw.prabhu6@gmail.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org,
 stable@vger.kernel.org, Swarna Prabhu <s.prabhu@samsung.com>,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
 <20251210014136.2549405-3-sw.prabhu6@gmail.com>
 <0b3458ab-e419-4ec2-9cba-eb9fd2cd8de9@kernel.org>
 <934c62d1-c800-4b31-9774-1e9dfe661877@pankajraghav.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <934c62d1-c800-4b31-9774-1e9dfe661877@pankajraghav.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/12/12 8:53, Pankaj Raghav wrote:
>>> Cc: stable@vger.kernel.org Signed-off-by: Swarna Prabhu
>>> <s.prabhu@samsung.com> Co-developed-by: Pankaj Raghav
>>> <p.raghav@samsung.com> Signed-off-by: Pankaj Raghav
>>> <p.raghav@samsung.com> --- Note: We are allocating pages of order
>>> aligned to BLK_MAX_BLOCK_SIZE for the mempool page allocator 
>>> 'sd_page_pool' all the time. This is because we only know that a bigger
>>> sector size device is attached at sd_probe and it might be too late to
>>> reallocate mempool with order >0.
>> 
>> That is a lot heavier on the memory for the vast majority of devices which
>> are 512B or 4K block size... It may be better to have the special "large
>> block" mempool attached to the scsi disk struct and keep the default
>> single page mempool for all other regular devices.
>> 
> 
> We had the same feeling as well and we mentioned it in the 1st RFC.
> 
> But when will you initialize the mempool for the large block devices? I
> don't think it makes sense to unconditionally initialize it in init_sd. Do
> we do it during the sd_probe() when we first encounter a large block device?
> That way we may not waste any memory if no large block devices are attached.

That sounds reasonable to me. Any system that has a device with a large sector
size will get this mempool initialized when the first such device is scanned,
and systems with regular disks (the vast majority of cases for scsi) will not.
You may want to be careful with that initialization in sd_probe() though: scsi
device scan is asynchronous and done in parallel for multiple devices, so you
will need some atomicity for checking the mempool existence and initializing it
if needed.

-- 
Damien Le Moal
Western Digital Research
