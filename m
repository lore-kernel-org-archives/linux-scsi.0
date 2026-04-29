Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3767C40DFDE;
	Wed, 29 Apr 2026 01:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777425257; cv=none; b=jyfvA5BGpdCivlsv8hjdyNuX8ZYspc7Oas2Qm94MKyDiUmO8oaFcFxVLuBSbHu/2HQryibeXfYu2MONtiT+VS4bfZwXXz5yM/GNEwqxP76pji2KnfmytJtPoSWEWwBu1jc+vDVET4zA9rmyxZ5J3HHCC0OXhLuahVx0t5DsMq30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777425257; c=relaxed/simple;
	bh=tGLRul+n/05j0X/idmpWj+JDsqBrnBcFFKd1mC6/GKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=KQ6yoYnTeOnSvFN/Z9nyZr7c2zh+zmgqFR0A3iGItOmVR0+2H2ors67BM9jZNRpLrXYQ6T6QiK3e8pfnhmVGUOueHknwoEruc3reRwHYgQRV0x+SjkXFSftt2mrriDqscQGZv5Euf+3ODcAyOkZzybJUfcjl8WSC4PCJ9sozRIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=YRzHkjTB; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="YRzHkjTB"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=J5Q31ArUG7F0Y1eBmQwYOHqZ3ariZGTpP0o91tdnCjs=;
	b=YRzHkjTB+WKuptxZnxRGTJgvbpmb8KGjeeZz5qicAe8iYfJ7y9kHdkMGfWkB46xl5okMZvfet
	BSpUpozxdM37veHmYPofhqvGtC8NCnC9ogB6rIk5AduzoxJpacTqJ2KPeIYtiO1kpQoo6tHFmJN
	cly9KklxjeM2JTjpDG7EE1M=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4g4zfp4Rv2zcZxk;
	Wed, 29 Apr 2026 09:07:14 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E5614056E;
	Wed, 29 Apr 2026 09:14:09 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 29 Apr 2026 09:14:09 +0800
Message-ID: <0539efac-d9b5-4f95-eecd-b88cb3cb8724@huawei.com>
Date: Wed, 29 Apr 2026 09:14:08 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] ata: libata-sata: retry hardreset when device detected
 but PHY not established
Content-Language: en-CA
To: Damien Le Moal <dlemoal@kernel.org>, <cassel@kernel.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<linux-ide@vger.kernel.org>
References: <20260425060447.1312763-1-yangxingui@huawei.com>
 <e8d237bc-7191-4881-924b-86a34ff0f3b9@kernel.org>
 <a118114e-9828-06d6-d38b-2b426c92bb14@huawei.com>
 <33299d0d-d863-4e00-951e-4728ddc823e2@kernel.org>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <33299d0d-d863-4e00-951e-4728ddc823e2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh200017.china.huawei.com (7.202.181.126) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/4/27 12:45, Damien Le Moal wrote:
> On 4/27/26 10:51 AM, yangxingui wrote:
>>
>>
>> On 2026/4/26 6:53, Damien Le Moal wrote:
>>> On 4/25/26 15:04, Xingui Yang wrote:
>>>> When sata_link_hardreset() detects that the link is offline, it currently
>>>> returns immediately without distinguishing the reason. According to SATA
>>>> specification, the SStatus register's det filed (bits 0-3) indicates:
>>>>     - 0x0: No device detected, PHY not communicating
>>>>     - 0x1: Device detected but PHY communication not established
>>>>     - 0x3: Device detected and PHY communication established
>>>>
>>>> This patch helps improve device detection reliability and adds a check
>>>> when the link is offline but det filed shows 0x1, return -EAGAIN to
>>>> trigger retry, rather than giving up immediately.
>>>>
>>>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>>>
>>> This is a pure ATA patch so please CC the linux-ide list, not the linux-scsi
>>> list.
>>
>> Ok.
>>>
>>> Also, please check your mail setup: your email was in my Junk folder.
>>
>> Well, patche was sent using the git send command.
> 
> Not git send-email, your smtp server. It probably has something wrong with
> DMARC. All your emails endup in my junk folder.

Alright, it might be related to the company's SMTP server, but this 
configuration is fixed, and I'm not quite sure how to fix it yet.

> 
>>> This is preceeded by a call to sata_link_resume(), which calls
>>> sata_link_debounce() and that function makes sure that DET is stable. So if
>>> after that DET still shows that their is no PHY, there is likely a big problem
>>> with it and it is super slow to be established.
>>>
>>> In this case, I do not think that doing another hardreset is the right thing to
>>> do. Have you tried increasing the deadline for hardreset ? That deadline is used
>>> as the limit for the link debounce too.
>>>
>>> Do you have a specific controller/device where you see this issue ? What exactly
>>> is the hardware setup where you see this issue ?
>>
>> Our customer imports and verifies a new disk, there is an occasional failure in
>> performing a hard reset on the disk and no exception log is generated for
>> resume and debounce.
> 
> Does this hold for all disks or for only one or some models ?

It may be some models, It is not found on other disks.

Thanks,
Xingui
.



