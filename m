Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BCEF2528E1;
	Tue, 15 Jul 2025 15:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752593766; cv=none; b=lg9j0zRp/j568PiyOshkAnFIpHVeq2rRWOvBGXKQ+ZeXfpTloW9usVSaMWi8TjJY3is5s2AV5c4/0X24bv6RpV7LJjhkJ8TUoNZCaHqWykECuFP2RlMKLMH/59tx3b22xQw8atrhLbdHZl5EVARMsaUuR9JktEfsqqCQcDrW6ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752593766; c=relaxed/simple;
	bh=FwX8r1C83KUbUoEsMnL3iiygadYHdm27+h1VeRvuG1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fN1a9wRKwM++rsEUwkgAsD+ncfzZQi3/PET5pAuScLZBtePxOPLMB+3iv8Yub8lrEf6qvTYMK2+kKvIiwTQbAjGv9MB9DyHeBzjYjydrGOGtRAiKVH1sLsvf8OxW8yIErMMfVvNi1dgH6oJBvRflwf3vRLj6zJA1vJ3pr4PS+Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxjjBWGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxjjBWGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC55C4CEF1;
	Tue, 15 Jul 2025 15:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752593765;
	bh=FwX8r1C83KUbUoEsMnL3iiygadYHdm27+h1VeRvuG1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AxjjBWGwWR2VzG4n+5ODd0cSkJJl9s6jTUn61yQfhouvsqTDMURDLt/jhiuOQAtlI
	 8fKNv+6ZuTtfQl3pEUf6/dKGAcWBsVPwc/GX0O07t6u9kYYb6/ysVGjYklSjcMt5+t
	 xrNJFTHptUO3qIrfdN2gpxQfqCLN0/3VM8FgKJUC63gAQrx4fAn4XPH2lBsPsmeDGd
	 22RnnetioLXG0Lvg75TknM7knjbxjCW4dFT6Bq89cOOW+Kd37BigNf+nn/V1xh/UZ8
	 MfvZl2uajr2hZFNvcgomgDlISee0ywIPqZEjeSp1mnNhTHM9VFzK2RJMELDcA9869U
	 kRgU6n17UR4zw==
Message-ID: <8aa33d58-c46f-46d3-b10c-f6b9998cb8a8@kernel.org>
Date: Tue, 15 Jul 2025 17:36:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: fix out of bounds error in /drivers/scsi
To: Bart Van Assche <bvanassche@acm.org>, jackysliu <1972843537@qq.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <07c4c84d-0c52-4843-b32d-6806e58892fe@acm.org>
 <tencent_ADA5210D1317EEB6CD7F3DE9FE9DA4591D05@qq.com>
 <bf166912-80ef-435e-885d-affce237afe7@acm.org>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 a/A=
In-Reply-To: <bf166912-80ef-435e-885d-affce237afe7@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/07/2025 15:00, Bart Van Assche wrote:
> On 6/18/25 9:03 PM, jackysliu wrote:
>> 6.15-stable review patch, vulnerability exists since v6.9
>>
>> Out-of-bounds vulnerability found in ./drivers/scsi/sd.c
>> The vulnerability is found by  is found by Wukong-Agent
>>   (formerly Tencent Woodpecker), a code security AI agent,
>>   through static code analysis.
>>
>> sd_read_block_limits_ext Function Due to Unreasonable boundary checks.
>> Out-of-bounds read vulnerability exists in the
>> Linux kernel's SCSI disk driver (./drivers/scsi/sd.c).
>> The flaw occurs in the sd_read_block_limits_ext function
>>   when processing Vital Product Data (VPD) page B7 (Block Limits Extension)
>>   responses from storage devices
>>
>> A maliciously crafted 4-byte VPD page (0xB7) would cause Out-of-Bounds
>> Memory Read, leading to potential system Instability
>> and Driver State Corruption.
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Just checking - are you sure? Please be careful with this work, that's
AI generated stuff which in some cases did not even compile or did not
actually follow C code.

Best regards,
Krzysztof
