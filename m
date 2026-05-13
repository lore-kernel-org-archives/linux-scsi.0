Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5304A367296;
	Wed, 13 May 2026 02:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778638003; cv=none; b=dVz3evTStFiOtwpAWnnJCkvO1hXtrnyExrkzeVBkdu1J72lXlA4MbxzmnpTKfjBwOwB9TVj8k17n/h2b8NBXOaNDKsmZ2tJajIuq2A7o8GLeEKG0G9VuoTmynILaOLzFa7MF9Mp92niY5zgmxQNUTbXflR4e0J4zhlPvGl/oQz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778638003; c=relaxed/simple;
	bh=FonOUlgp0LgS5Z6+5Y9FKLYdwh4YT/Ju7E6bO/xx7HU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Xj/u8IgKWa1gBOdxGV9IWFgdz5iD18dSihmaBoyi3DZ5cBFTi7OApRbxLpU5rO9GHAb1vMPpPDTKUuQwk2PlDJ1zrhvzqXGYGAuIqh5jy79ulR4g/RY8RBvFN/dGf+xzuYBEOKgpfMxoVth1yEiy3rNL8J7mReqPHRVkRhuhvuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=d7Kz8Cc/; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="d7Kz8Cc/"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xA9LEfH9vf6RTu+6D+ncFXjz2GUiXdpPnb4vOvqKRAo=;
	b=d7Kz8Cc/OJmrfzdZXTJEry89nZViRR/AAXCtKGtFl3LgUCTZvwKCT2RgV35Xa73HuIDuj3e01
	4LTaZE9R8lJQ2uLB2faFTQRTWIgHryAF3ddvTKKAzKxz4+CT0Pt1qeDznSxDbeBbo6UZD7KrTh/
	CTR17RD3W/ErQUF0jL6R0wA=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gFc7x288Vz1prKK;
	Wed, 13 May 2026 09:58:53 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id B3E9A4056D;
	Wed, 13 May 2026 10:06:32 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 13 May 2026 10:06:32 +0800
Message-ID: <2cdcb1aa-1e63-f507-629d-53a9037ce4f9@huawei.com>
Date: Wed, 13 May 2026 10:06:31 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] scsi: libsas: handle linkrate change in
 sas_rediscover_dev
Content-Language: en-CA
To: Jason Yan <yanaijie@huawei.com>, <john.g.garry@oracle.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260512071226.2299741-1-yangxingui@huawei.com>
 <9c4a1438-bd8f-4107-a519-a222e20f5da6@huawei.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <9c4a1438-bd8f-4107-a519-a222e20f5da6@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh100017.china.huawei.com (7.202.181.103) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/5/12 21:18, Jason Yan wrote:
> 在 2026/5/12 15:12, Xingui Yang 写道:
>> When a device attached to an expander phy experiences a linkrate change
>> (e.g., due to cable reconnection or negotiation), the current code in
>> sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
>> if the SAS address and device type remain unchanged.
>>
>> However, for drivers like hisi_sas, the ITCT entry needs to be updated to
>> reflect the new linkrate. Without this update, the hardware continues
>> using stale linkrate information, which can cause performance issues or
>> protocol errors.
>>
>> This patch introduces a new LLDD callback lldd_dev_info_update() to 
>> notify
>> the low-level driver when a device's linkrate changes, allowing the 
>> driver
>> to update its hardware structures accordingly.
>>
>> Additionally, refactor sas_ex_to_ata() to use a new helper function
>> sas_ex_to_dev() which returns any device type attached to an expander 
>> phy,
>> improving code reuse.
> 
> Could you split this refactor to another patch? This makes it easier to 
> review.

Okay, for ease of review, I will split it and resend the new version.

Thanks.
Xingui
