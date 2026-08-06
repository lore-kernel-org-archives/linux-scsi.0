Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E823815FB;
	Thu,  6 Aug 2026 01:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785980758; cv=none; b=UnA2F2Qnprk5GUHQWQRcRFhWEG32opKjgOsBBAgbimcJkJ3XvMTV0vHlfl6MMZyXybwxwBRDgLLimIlJGVvtUslMP5vgB6nYfCSYwgcpFxqp4rzNKPu3ihqOplFgKLP+ZJ3YhRUD7G3nHcbf+WPvBzyz7uqdPJj5tC9SllhboEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785980758; c=relaxed/simple;
	bh=v12f+tZ0tWo+7MW5D74zf8MKa226/VP8WyBnEeJNW7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=n3hDV3CioJmIlCnwm0fa707cMolFzB78pGlW+8ntBOV0DXLS+qjbAq3coDbOJ15fAEPkbx9bJNy1cDHjJy2ZnLGGVvCeg6b8d7lmmVYR0TdaZeXQCkuXYsUyBs41OjNi4oEg0P5zGSH/QFICGa0txZLz+GT3BZHUnU5BGeGR2HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Vj4FJPll; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Vj4FJPll"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VEj+yz8fzKEGLtc8a0c7NCPlSiA7wsitCPOltnz6azQ=;
	b=Vj4FJPlleyOw+ubEyQk1UXr6LHd7BSYi1GYeKaSLOusBdmJQSst04p1lo1OGueXysnHEC85MV
	qiyRkp8IY3uUepYGh+A+fpx3Gg0DEmzXqF8sezEpdEGVV6bsEChKrP6ZaxkZ4S1UKBGMohwgg/9
	o/q1MHQy4eMWLClg3H+xNb8=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hFqch0wWbzpSvB;
	Thu,  6 Aug 2026 09:36:20 +0800 (CST)
Received: from kwepemp500009.china.huawei.com (unknown [7.202.195.64])
	by mail.maildlp.com (Postfix) with ESMTPS id 08A204057F;
	Thu,  6 Aug 2026 09:45:51 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500009.china.huawei.com (7.202.195.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 09:45:50 +0800
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 09:45:50 +0800
Message-ID: <eebb9aec-0a77-b609-ff87-9e8be88cf4e5@huawei.com>
Date: Thu, 6 Aug 2026 09:45:49 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 0/2] scsi: libsas: Support spinup notification for SAS
 devices
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
References: <20260803020536.546544-1-yangxingui@huawei.com>
 <e34a40de-474c-4a3c-8013-726d473bc79c@oracle.com>
 <28879664-7e0f-60d5-caf7-60a1e2442d77@huawei.com>
 <9e4c4aab-81d2-4f5b-bbcf-087eb92feb6d@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <9e4c4aab-81d2-4f5b-bbcf-087eb92feb6d@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500002.china.huawei.com (7.202.181.131) To
 kwepemp500015.china.huawei.com (7.202.195.9)



On 2026/8/5 19:43, John Garry wrote:
> On 04/08/2026 10:30, yangxingui wrote:
>>>
>>> How would other SAS HBAs which use libsas handle this scenario? Since 
>>> they have FW, would the FW automatically issue this NOTIFY(ENABLE 
>>> SPINUP)?
>>>
>>> I just wonder why hisi_sas seems to be only driver which would need 
>>> this.
>>
>> Thanks for the question. This affects only SAS HDDs. I checked pm8001, 
>> isci, and aic94xx — all handle NOTIFY(ENABLE SPINUP) at the driver level:
>>
>> - pm8001: sends once at phy-up, then mdelay(200) — comment: "delay a 
>> moment to wait disk to spinup" — before notifying libsas.
>>
>> - isci: enables hardware periodic insertion during link idle (ENABLE 
>> bit in notify_enable_spinup_control), cleared at phy stop.
>>
>> - aic94xx: enables microcode periodic insertion during link idle 
>> (NOTIFY_TIMER_TIMEOUT = 500ms interval), stops at phy down.
>>
>> hisi_sas also calls sl_notify_ssp() at phy-up, but the NOTIFY_EN bit 
>> is held for only 1ms — msleep(1) between setting and clearing — before 
>> immediately notifying libsas.
>>
>> The root cause appears to be that 1ms is insufficient compared to 
>> pm8001's 200ms. An alternative to hisi_sas would be to simply increase 
>> the hold time in sl_notify_ssp() to match pm8001's approach, keeping 
>> the fix within hisi_sas.
>>
>> Would you prefer this simpler approach, or do you still see value in 
>> the libsas-level sense detection and callback from hisi_sas? ^-^
> 
> I think that if you can resolve this in the LL driver then that would be 
> better.

Okay, thanks a lot.

Xingui

