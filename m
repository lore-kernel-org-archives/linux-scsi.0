Received: from mail.mainlining.org (mail.mainlining.org [5.75.144.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0F03A8FE6;
	Wed, 12 Aug 2026 20:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.75.144.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786568120; cv=none; b=SyqR4+pD39f+ruMhE6SfYX8N4v/uUQVLvwRI+HWwOCRD6i4UxP/eNaHthUMJjbHCJ66qBZAakmM1S5CJK0QJDU84QQatqWyhu01Wa3Zg9heBVohroxax9xBIsxta6+0UrcUleG75Oesdf4hkVpkMDV6gaMfoncOyigL6VZxF6Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786568120; c=relaxed/simple;
	bh=FrdqQ6kXNnNKfJVjZwswwcKEQOtgoDeMVrYYyQrDqpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G2RQoc+vbOnhCIa3WaSsCZSuZsb58bPHCs8WyB4Mdb9lg9RZ8irj5fEiOrSvMsHE/l7T8asZOYiHHgGhrsKHt1P4OGA3NMcD9keZPtQL54OVgxXn+UNqlteDRzf3U0Dkutx6yKGZ8r2PdkMIgvmygDKuYNdvEwdiSEfNPKm8Vx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org; spf=pass smtp.helo=mail.mainlining.org; arc=none smtp.client-ip=5.75.144.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mainlining.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.helo=mail.mainlining.org
Message-ID: <b15b2687-0c2e-43b2-ac9e-78e04e77e065@mainlining.org>
Date: Wed, 12 Aug 2026 23:54:41 +0300
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/33] Add support for Qualcomm Snapdragon SM7150 SoC and
 Google Pixel 4a
To: David Heidelberg <david@ixit.cz>, Jens Reidel <adrian@mainlining.org>,
 Danila Tikhonov <danila@jiaxyga.com>, Miro Mraz <mraz.miro@seznam.cz>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-watchdog@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-mmc@vger.kernel.org,
 netdev@vger.kernel.org, linux-scsi@vger.kernel.org,
 dmaengine@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-remoteproc@vger.kernel.org, dri-devel@lists.freedesktop.org,
 neil.armstrong@linaro.org, linux-hardening@vger.kernel.org,
 linux@mainlining.org, Connor Mitchell <c.dog29@hotmail.com>
References: <20250422-sm7150-upstream-v1-0-bf9a9081631d@jiaxyga.com>
 <2ca2b774-fd7f-4612-b38d-f60e32ff6f9a@mainlining.org>
 <283096ad-ae1b-42b8-8312-b192f735fc80@linaro.org>
 <cce3fe36-322e-49ed-8928-3aef813faad7@ixit.cz>
Content-Language: en-US
From: Danila Tikhonov <danila@mainlining.org>
In-Reply-To: <cce3fe36-322e-49ed-8928-3aef813faad7@ixit.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi David,

Thank you for your comment.

On 12/08/2026 14:40, David Heidelberg wrote:
>
>
> On 23/04/2025 09:26, Neil Armstrong wrote:
>> Hi,
>>
>> On 23/04/2025 00:07, Jens Reidel wrote:
>>> Hi everyone,
>>>
>>> apologies for the mess this created. Danila's mail provider 
>>> ratelimited him halfway through sending the series and the attempt 
>>> to re-try sending the second half an hour later ended up with a new 
>>> message ID (I think due to not using --in-reply-to).
>>> He asked me to let you know that this will be resolved later and the 
>>> whole series will be re-sent once the problems are resolved.
>>
>> The b4 web submission is a great alternative when the mail provider 
>> is rate limited:
>> https://b4.docs.kernel.org/en/latest/contributor/send.html#web-endpoint
>>
>
> I see people interested in moving Pixel 4a forward, but it seems this 
> was never upstreamed? I looked at sm7150 repository [1] where I see 
> FROMLIST, but these patches never arrived to the list and this series 
> is from 2025.
>
> Should we expect v2 (re)based on recent tree?
>

I'd definitely like to get back to upstreaming SM7150 and the devices
based on it, but I don't think there's much value in continuing with
this particular series as-is. A lot has changed in the kernel over the
past year, which would require substantial changes throughout the series
and would effectively force the maintainers to review it from scratch
anyway.

I'd also like to split the series up to avoid targeting such a large
number of maintainers in a single submission. Hopefully, I'll be able to
find some time to work on this in the near future.


> Thanks
> David
>
> [1] 
> https://github.com/sm7150-mainline/linux/commit/7ea41523c678e94a7c048936052b5b1b1b109cdd
>
>> Neil
>>
>>>
>>> Best regards,
>>> Jens
>>
>>
---
Best regards,
Danila

