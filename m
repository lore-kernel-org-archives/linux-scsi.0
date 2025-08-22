Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592CE22DA1F;
	Fri, 22 Aug 2025 07:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755848398; cv=none; b=aPjhz5B2azH+9P7jUMrPtM+bZq7S2cb+F7vm0yZ/9W8eV5rltC9N5H3NNYZxJdLFl0pNUEIALuA7glUxIIZEhWAACU92lP3qL5OxXOdqSqskI3niXJNuB6HTFlGS+C0eFJwO0SIB5Gm/dakH+0JS4PW5lloHymbWhIukqQ7TeQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755848398; c=relaxed/simple;
	bh=UKWp4AA0CoI5oo1H9FVbI9d5QTPf9qUqjpMKzipa+cY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b6KMG7H8vD7KcRaD8lExBTfVfrtxnVuYQuN6xmvm3a2Zsps0+HTVUIa1u/Bu2T1mUuXlcg7g9BvlUUluqgwjc9loCX+1GcEc+Nim8gG9QsJPp7Tqict5FC3cPpTqydTW17UD/OcTiNH0klDezDIkw+F3Jgeh+nooZGp7DWgN9DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kmc7cpXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kmc7cpXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742A4C4CEF1;
	Fri, 22 Aug 2025 07:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755848398;
	bh=UKWp4AA0CoI5oo1H9FVbI9d5QTPf9qUqjpMKzipa+cY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kmc7cpXdlCmXsn6v5t5fPB5KmIiQaQrgamHPSwPctLWmQgRqmmFOHy+XUQG5fnwLE
	 vTJhCNHTYVK9sqU1rRvXK9mSYswd88i5Kp1/KeOpP7f5EbpKK6K0TTK8RG7RqSQNDc
	 BSiLLjRoAo0J6wjE+PXgTaHNja/Gli6RX1oMg3HrDBxMAd4KFwAkepqVi5jFUlCgil
	 T70omHybsgWbkF5r6gEHewPN6JYwAPT8EAh/H66v6adUCLdErli/KExhxpn3Ye3oFe
	 FO3uri/xvxc/NDLde2F0Qes4FBMgm2bXdauyut0vQtB+WM1LnQAt/9PII8FJwFYNLz
	 twzMeiqt+FKbA==
Message-ID: <f02f049f-efa3-481b-b681-cf75308bfbc4@kernel.org>
Date: Fri, 22 Aug 2025 16:39:53 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] scsi: scsi_error: Introduce new error handle
 mechanism
To: JiangJianJun <jiangjianjun3@huawei.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hare@suse.de, bvanassche@acm.org,
 michael.christie@oracle.com, hch@infradead.org, haowenchao22@gmail.com,
 john.g.garry@oracle.com, hewenliang4@huawei.com, yangyun50@huawei.com,
 wuyifeng10@huawei.com, wubo40@huawei.com, yangxingui@h-partners.com
References: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/16/25 20:24, JiangJianJun wrote:
> It's unbearable for systems with large scale scsi devices share HBAs to
> block all devices' IOs when handle error commands, we need a new error
> handle mechanism to address this issue.
> 
> I consulted about this issue a year ago, the discuss link can be found in
> refenence. Hannes replied about why we have to block the SCSI host
> then perform error recovery kindly. I think it's unnecessary to block
> SCSI host for all drivers and can try a small level recovery(LUN based for
> example) first to avoid block the SCSI host.
> 
> The new error handle mechanism introduced in this patchset has been
> developed and tested with out self developed hardware since one year
> ago, now we want this mechanism can be used by more drivers.
> 
> Drivers can decide if using the new error handle mechanism and how to
> handle error commands when scsi_device are scanned,the new mechanism
> makes SCSI error handle more flexible.

Barely half of your emails have made it through for me and they landed in my
spam folder. So please check your email setup.

Also, was this all tested with libata and libsas attached devices as well ?
They all depend on scsi EH.


-- 
Damien Le Moal
Western Digital Research
