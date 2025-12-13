Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEBBF1DA62E;
	Sat, 13 Dec 2025 03:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765596128; cv=none; b=uY8YiJgxZ2sFDlEdig3N9f/2Sw1ITbo5ssOj6vKIJORi4D7saDDhmIasCooTOhuqzPhwmUmcPDYO41EvIyuaiDv2+bc6NxgSsE+nl4WjBZ5yzAHlJyDH1Nl6JhMo7qKilI5dgsuZNpzESjIdbQwCqGv6tUsLUia/x8tnCIdeXTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765596128; c=relaxed/simple;
	bh=L7FjBtsu/BACLmDZZlXXlkdfPTX7MJnwlvXisvxNnsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E1gJjdevP0b1WW+i+0oQrVszWz+WM1tJTHicjOqugWJxMDYS78wB0sw98kX/MnV2er9JJ19o4xQmRC55KkJLAbwrW8dXgk7MufJJLnIuAWzA7c2EqpkqFEoxIxLu+0/gFO4GWerh624VF9TIOB5blq2UjM/zWxgxZQae4ID2cGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qcLOA+Em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qcLOA+Em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AECC4CEF7;
	Sat, 13 Dec 2025 03:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765596126;
	bh=L7FjBtsu/BACLmDZZlXXlkdfPTX7MJnwlvXisvxNnsA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qcLOA+EmQCqNlMROt6F27MBAMXEsaHbt6E+K6b5RsF6hmN/X/qkJebMM5JGiLLKOm
	 1tkTsRnPwh5YMFklCSrvIQ9AtoiePkp2Q2vzT70jxbnwsABKWLn+XPUK703L5E+S+G
	 xKw1IzWynF4rRo6zk/kOuOA5czUcQnXIzNo1wCVUj3cEqTZp8J6O3QEMwFytIo7h8j
	 PU7z1kR+b0MSYSHpwcJK0LDGCz7LUDprd0oS9a3uD3wQP4ACx3iL9WqVTjsitZ6jZR
	 ekZY8jGWNgDdoTzJ/VOp8mVNzLEdND3yUZrtoVqauSYvchCWATBIV6r8mohoCfsMeX
	 lHfGkaYCUhB2Q==
Message-ID: <8b2c4fac-81be-4937-9619-c32813ab2650@kernel.org>
Date: Sat, 13 Dec 2025 12:22:02 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v1 0/2] enable sector size > PAGE_SIZE for scsi
To: Swarna Prabhu <sw.prabhu6@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, bvanassche@acm.org,
 linux-kernel@vger.kernel.org, mcgrof@kernel.org, kernel@pankajraghav.com
References: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
 <ec5f42bd-a26a-4416-b967-f67090e9a423@kernel.org>
 <aTtfWdFUARToPhD3@deb-101020-bm01.eng.stellus.in>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aTtfWdFUARToPhD3@deb-101020-bm01.eng.stellus.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/12/12 9:18, Swarna Prabhu wrote:
> On Tue, Dec 09, 2025 at 05:56:05PM -0800, Damien Le Moal wrote:
>> On 2025/12/09 17:41, sw.prabhu6@gmail.com wrote:
>>> From: Swarna Prabhu <sw.prabhu6@gmail.com>
>>>
>>> Hi All,
>>>
>>> This is non RFC v1 series sent based on the feedback received on RFC
>>> v2 [1] and RFC v1 [2]. This patchset enables sector sizes > PAGE_SIZE for
>>> sd driver and scsi_debug driver since block layer can support block
>>> size > PAGE_SIZE. There was one issue with write_same16 and write_same10
>>> command, which is fixed as a part of the series.
>>>
>>> Motivation:
>>>  - While enabling LBS on ZoneFS, zonefs-tools tests were being skipped
>>>    for conventional zones when tested on nvme block device emulated using
>>>    QEMU. Hence there was a need to enable scsi with higher sector sizes
>>>    to run zonefs tests for conventional zones as well.
>>
>> This is super confusing: there are no conventional zones with NVMe. And why
>> would a problem with NVMe require scsi patches ?
>>
> Agree with you. NVME Zoned Namespace require sequential writes.
> 
> Our initial goal was to enable LBS on Zonefs. Running zonefs tests
> on a scsi device covered both conventional and sequential zone based
> tests. So we had to enable higher sector sizes on scsi device and while
> doing so fix the issue seen with WRITE SAME commands with higher sector
> sizes.

OK. Understood. But since this is in the end a scsi fix that is not directly
related to zonefs (zonefs does not use write same), I think you can drop any
mention of zonefs to avoid any confusion.


-- 
Damien Le Moal
Western Digital Research
