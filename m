Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482962DF15F;
	Tue,  2 Sep 2025 05:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756789896; cv=none; b=J9wJHAV+oBzxlg85VG5G8Rvoy3OwplxVy58y6pxqzh66Wri/lGkV2FeExJHK76W/n9X2KJSjeBOX1BsB+FtA/WDUA9iFnIlLtFfR9gdHHp6dgkSD5vIctCkxMZKiflzotqbT5/HFtIEG8UqluLu1RHCt9hno5VWckVvv5yNPVOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756789896; c=relaxed/simple;
	bh=nPVyH9G9lI1Km2IUyFQw8xE1zC3zi2xNgVGYJNHZqbU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D3ieN7e4G48XzJkGxNSnlLxbXiU9TwxhaNQ/PVaz3i4hP7tYd+G40MjUJ4Nx3/z4C2HuzQPadJV0RKdzGtvn/Xc5EZ2wCTR5/v4vJbCRP0uW4eZ+vFr1e9QLkmT//Rc3wUMDIeTEicHrHAR6pTchYrcdbHoDduNbj7IA/1uzn0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjSvL828; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjSvL828"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA721C4CEED;
	Tue,  2 Sep 2025 05:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756789895;
	bh=nPVyH9G9lI1Km2IUyFQw8xE1zC3zi2xNgVGYJNHZqbU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LjSvL828CIbAl0U97ocjMgI6rbpyQvR4Xa9hlBR0gkwI1h0oRbH1dXf1ZHqLxE4BZ
	 XgFQTuGufApZrPE5k5RN7dNqm0oaIiSJJpXhpZP9Rgo0m66rklXDXAqwbCtYeShOa1
	 ihf6d96GHlurSFR5owb8uQWjfqa2iyykdUDJ4i52PiCj49pPIDG8Hj75meDvtPerOv
	 cYQNqDBE+lJA4AB/T+GVWHlA5FB4ru/f5pPQWfHnqSctN00tNZIv+L9Jn/4Jubxsil
	 ceauTeNAxAae4r26afYYezKrUB5581loje4hrrkS2KcitxH46jIrgxCv5wbkszRTI6
	 SipCcM5hvr7Pw==
Message-ID: <04ca315e-e375-40ab-8596-613f8d453008@kernel.org>
Date: Tue, 2 Sep 2025 14:08:41 +0900
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
References: <f02f049f-efa3-481b-b681-cf75308bfbc4@kernel.org>
 <20250902053035.2486666-1-jiangjianjun3@huawei.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250902053035.2486666-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/2/25 2:30 PM, JiangJianJun wrote:
>> Barely half of your emails have made it through for me and they landed in my
>> spam folder. So please check your email setup.
> 
> I also find it strange, but my colleague can receive it. Maybe i reset email
> and send again? 
> 
>> Also, was this all tested with libata and libsas attached devices as well ?
>> They all depend on scsi EH.
> 
> There is currently no tool available for injecting faults into hard drives,
> but we have implemented this solution in our company's products. So i just
> test with scsi_debug.

Use write long command to "destroy" sectors. Then try to read them. That will
generate uncorrectable read errors.

See sg_write_long (sg3utils).


-- 
Damien Le Moal
Western Digital Research
