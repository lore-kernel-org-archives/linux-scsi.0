Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7C3188937
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724423050; cv=none; b=a6L1o92Qf4zRl9hX2IO3PzmgaJbW4VH+1+AISNDzAsxvs04PN/vOpT4WeXozv888H79PQqVgyqA1d+a1fbvfCPwGpeP9aTPoPZfBirnlwmoxbSGWOVk4AEz4mujQ1Bgc/aYL7E+wUNrtvbAXOrAx++0kZvuI+ydFsPqPtWQLmJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724423050; c=relaxed/simple;
	bh=3yxEyV888rE/sqlX0ijlRHuqm0WruDTbURWK6N1f91E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZXsng8GvKdFF++ZMUynQHkrEjExjY9kbok4L+vs/qXndcn/pb1IIBTxSozSHWjIc3Lb39nBlqrPkLwUyCjq5g80qtlE+ZlN+HSSqJWH4UqafXhyCx5O1/xpW6LjxoH6xYzrqHAf7g5cBZTfS9rCtc1s7MnpP0DGpaCqo45PSGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=omrJ8sEF; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="omrJ8sEF"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wr2Ph1Lmsz6ClY9R;
	Fri, 23 Aug 2024 14:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724423042; x=1727015043; bh=vJCxYFKQGvZBum24/7M2ZBhn
	nbDBLKc6J+Lv2Z2rSfw=; b=omrJ8sEFNrLG3lWtir2oaLBbQ2Gs0RIGpTkJXHto
	TxszOtRkjgOSopU0+f8WSh6t0RspscRF1bRe3E7G6GoqYWEGbt7GuJsxdtPHM+gA
	MuHWz0UHLpKDyg6IYxfnLOkPZw8ykOSq2glAHwA5oRKgDKZdqzvxmcdzvyEvNTpH
	0HLW1Y/so9GeNGFeIYEPUceKC+kJUmQIqMhwoI97F4BWvfj0I4EjavJ0YObN0gVL
	djHtI+dj6HPbN5Bp4I8+LPdjo2o8iCd2CmXHU023qPfDE8d0JrCQHX4eMU26gBi1
	X3YnZEht5g92GA6gf1pvuXqQ9Y9pGZO4kVdPZVkuJ4FkGQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id k61EdFIPYz17; Fri, 23 Aug 2024 14:24:02 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wr2PX3ZB7z6ClY9Q;
	Fri, 23 Aug 2024 14:24:00 +0000 (UTC)
Message-ID: <5b3057e7-0d0f-4601-bf96-5d2111af2362@acm.org>
Date: Fri, 23 Aug 2024 07:23:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: ufs: core: Fix the code for entering
 hibernation
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>
References: <20240821182923.145631-1-bvanassche@acm.org>
 <20240821182923.145631-3-bvanassche@acm.org>
 <41e5ed21-8ea6-3a4c-2f25-922458593f38@quicinc.com>
 <6e8df17b-320e-4bfc-a0be-c7918b0263d4@acm.org>
 <6fceba57-e1f6-e76b-94f3-1684c1fe6e98@quicinc.com>
 <85481ed2-a911-41a4-8fd4-80e4d20dbf04@acm.org>
 <3a455ddb-7dad-cb2c-7b80-ec355221fb0a@quicinc.com>
 <7d5c2cf5-24a3-4a1c-810f-f80ba367237e@acm.org>
 <20240823120104.siy54o6qja75lpwh@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240823120104.siy54o6qja75lpwh@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/23/24 5:01 AM, Manivannan Sadhasivam wrote:
> Unfortunately you never mentioned which UFS controller this behavior applies to.

Does your employer allow you to publish detailed information about
unreleased SoCs?

>> - The workaround results in a simplification of the UFS driver core
>>    code. More lines are removed from the UFS driver than added.
> 
> This doesn't justify the modification of the UFS code driver for an errantic
> behavior of a UFS controller.

Patch 2/2 deletes more code than it adds and hence helps to make the UFS
driver core easier to maintain. Adding yet another quirk would make the
UFS driver core more complicated and hence harder to maintain.

>> Although it would be possible to select whether the old or the new
>> behavior is selected by introducing yet another host controller quirk, I
>> prefer not to do that because it would make the UFSHCI driver even more
>> complex.
> 
> I strongly believe that using the quirk is the way forward to address this
> issue. Because this is not a documented behavior to be handled in the core
> driver and also defeats the purpose of having the quirks in first place.

Adding a quirk is not an option in this case because adding a new quirk
without code that uses the quirk is not allowed. It may take another
year before the code that uses that new quirk is sent upstream because
the team that sends Pixel SoC drivers upstream only does this after
devices with that SoC are publicly available.

Thanks,

Bart.
