Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998E418A6A8;
	Wed, 29 Apr 2026 01:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777424799; cv=none; b=uRlEpuzO8Y1na9CN3ALdAIqXjI2Ru9t7YtpcdC1DlAaI9jn/brmkHNBJUJB178+3C60Hq+LaZVHyBkh1Uy87wNuRsz87cb87jo0W8akW3GGAm599oSG++aAZLJTjqrZIQ6VjQMqFuShJ3l0H8vOwYdxRP06ojZpKZHngfeRUg78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777424799; c=relaxed/simple;
	bh=L0CaUZ7yEW8bFfP/8Ry4qbbxN1lb4PII9Ftd1sYG6+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=VNcI0QIPO8Xep7QOEV/jGlNPCOUjmhI4KzTojGE2r3QL0NqDgX6sWm7WqOf+IrlARJI9G/dR/Hf8BnK6xd2QZNEgJFC4NDxJHkIv22dR3bnJy5atpd/j4H60QJxyPw+6r0KqA5bxIw0uRpTU1fLQ8JYUCDpXxzSzzR28JlbHh6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=PpowSpgW; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="PpowSpgW"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fccwyR4MWD91zYllOCpjjJSG6CqTlvYp+lxYLhsn5bc=;
	b=PpowSpgWv0ynswT8Hsx82WfJWrhBvrPNzOnWngZqjRk1LSTfyN4dOUFIax0cgPfIUaGGzgBVi
	dkBZNmvGlEfXBMW29NM/lvv48EKlh1b76JCOSXoNU9HPYWMuSiv9GB7BykVttqPnt0ushyiQMEi
	BgOYr12JPsPiihFZDCidHsU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4g4zVb0BK2zLlYX;
	Wed, 29 Apr 2026 09:00:07 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id EAFFA4056C;
	Wed, 29 Apr 2026 09:06:32 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 29 Apr 2026 09:06:32 +0800
Message-ID: <d59bcc52-e77c-7f00-f7cd-480258296b4d@huawei.com>
Date: Wed, 29 Apr 2026 09:06:32 +0800
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
To: Niklas Cassel <cassel@kernel.org>
CC: <dlemoal@kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260425060447.1312763-1-yangxingui@huawei.com>
 <ae9h1PD38ydo_Dp4@ryzen>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <ae9h1PD38ydo_Dp4@ryzen>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh200017.china.huawei.com (7.202.181.126) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/4/27 21:17, Niklas Cassel wrote:
> On Sat, Apr 25, 2026 at 02:04:47PM +0800, Xingui Yang wrote:
>> When sata_link_hardreset() detects that the link is offline, it currently
>> returns immediately without distinguishing the reason. According to SATA
>> specification, the SStatus register's det filed (bits 0-3) indicates:
>>    - 0x0: No device detected, PHY not communicating
>>    - 0x1: Device detected but PHY communication not established
>>    - 0x3: Device detected and PHY communication established
>>
>> This patch helps improve device detection reliability and adds a check
>> when the link is offline but det filed shows 0x1, return -EAGAIN to
>> trigger retry, rather than giving up immediately.
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>>   drivers/ata/libata-sata.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
>> index b9d635088f5f..e5bb92c38e38 100644
>> --- a/drivers/ata/libata-sata.c
>> +++ b/drivers/ata/libata-sata.c
>> @@ -667,8 +667,18 @@ int sata_link_hardreset(struct ata_link *link, const unsigned int *timing,
>>   	if (rc)
>>   		goto out;
>>   	/* if link is offline nothing more to do */
>> -	if (ata_phys_link_offline(link))
>> +	if (ata_phys_link_offline(link)) {
>> +		u32 sstatus;
>> +
>> +		if (sata_scr_read(link, SCR_STATUS, &sstatus) == 0 &&
>> +		    (sstatus & 0xf) == 0x1) {
>> +			ata_link_warn(link, "device detected but PHY not ready (SStatus %X), retrying\n",
>> +				      sstatus);
>> +			rc = -EAGAIN;
>> +		}
>> +
> 
> This looks like you are more or less duplicating the function
> ata_eh_link_established(), untrouced in commit 4371fe1ba400 ("ata:
> libata-eh: Avoid unnecessary resets when revalidating devices").
> 
> Could you perhaps try to reuse this function?
> 
> (It is currently private, so you would need to make it public.)

This looks like a pretty good suggestion, but according to the log 
print, when an exception occurs, the ipm field is 0, indicating that the 
communication has not been established. It might not be suitable to use 
this interface yet.

[   25.242373][ T1286] ata1: SATA link down (SStatus 1 SControl 300)

Thanks,
Xingui
