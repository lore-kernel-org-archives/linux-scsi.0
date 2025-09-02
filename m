Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8942E1FDE31;
	Tue,  2 Sep 2025 05:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756791219; cv=none; b=Adj/sXNZVnkO6mRWmLsMvOhT6jdaft5kZjKMF1z1lTLGBrthnvV0L49ZHaTmxVWFRUXzunr0i2wCdzeigAo8uCea1QNF5GZoB0wYzXZ1a1DI9clPVxfNfnLMKaaTzK85TvWaD5o/zg0cIZyj4ACB46ED5ZVX00yXMPzU9qf8S/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756791219; c=relaxed/simple;
	bh=Az7focMic3m2IVB9oqE5Qxwz8hSRHo+y7t4e9NNY+yY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q5+zOQFIytNqidskM11JVweyoSs+7jEfZtU9XWFKcGxrbbdwUMGlCWIU1kWolTXOg+5aOndWfrpsrBISfvMDH7MpydwBsJweaVNCUr+RPxTox9AYT+UdACexK6BsTGEJrukaBZHLbLKAE4MM9e+0AgwggkLXJyeH7xVFEdjPIsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mm64E0Nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mm64E0Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3A4C4CEED;
	Tue,  2 Sep 2025 05:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756791219;
	bh=Az7focMic3m2IVB9oqE5Qxwz8hSRHo+y7t4e9NNY+yY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mm64E0NrJB1bFPpAuFUgRo5ci69NWp/GH7x8Y3ufvIe1+RfClyV6TuWtKmmYfnSLo
	 1XJiI+GmlfRYHsL3jXo6hD+Lw2aqohfp+TfjOZyNY5ugJTGHlKPRchuOsIRL3GmY+m
	 ZSl0E5abwXWXl1A6Th97jlg3IMHFwju4ZpOkVevghY7kdm3W8kR0E/AS9PYjZPIS1/
	 SoC5mItuE3mKPIvhrt7DaEreHucvigMa7NTELLwJXvj6k5s92Pv7l5kXAa5M9M5GrO
	 9ZAvbl/1GMtzQkn29rCRMRtCu1+uAOgp4hvSqDyFuQLkXRc6xQQqGXd5Muwn+rTLkw
	 1meVugRRdFgVA==
Message-ID: <c09657ab-95a4-4ffb-bddd-26babd1c803e@kernel.org>
Date: Tue, 2 Sep 2025 14:30:44 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] scsi: scsi_error: Introduce new error handle
 mechanism
To: JiangJianJun <jiangjianjun3@huawei.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hewenliang4@huawei.com,
 yangyun50@huawei.com, wuyifeng10@huawei.com, yangxingui@h-partners.com
References: <04ca315e-e375-40ab-8596-613f8d453008@kernel.org>
 <20250902060313.2536037-1-jiangjianjun3@huawei.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250902060313.2536037-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/2/25 3:03 PM, JiangJianJun wrote:
>> Use write long command to "destroy" sectors. Then try to read them. That will
>> generate uncorrectable read errors.
> 
> There is a misunderstanding here, the condition that triggers this error
> handler is when the device is slow or unresponsive, or fails to start;
> bad blocks refer to data errors rather than faults.

You probably easilly can simulate an unresponsive device using either qemu or
tcmu-runner.


-- 
Damien Le Moal
Western Digital Research
