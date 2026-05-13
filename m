Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FF23D902E;
	Wed, 13 May 2026 08:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778660055; cv=none; b=izmfgNidjBPe5dyaJtRdHBAwAUbPnIZAi0DAqcgSCATZsMWSaZWxh+vok5EEo0NsDVx0Y1yoY6z09REE6066AitQQNuUZ6O5KayP+zHnUfBtOs6w2+52kRqcQiM9p68ZODfGpTekLyw+aE9DMBdQHoKSN0uU9/BjqUjZpxlwbVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778660055; c=relaxed/simple;
	bh=qhVYtW4Sr3jGQSiCe2aRpoLoVDBJjtouCdy5eNEnJWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IZKBBzQj+6VrJzofPQcSMUgmzcrX9xesOUhJlLFRwQg8Bj/Iwe71s/i13T37XN47SBaux704F0yJldN1JsO3x34q/4u97fjcwstedz7E1lcqiYm14pg3wzODolmK+kmZFVOk1jKwwgSbKHfzsLKpXk0vlel4qgg0KPdQ7zuePs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=jObJYYBW; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="jObJYYBW"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9ZXk4DHgzQQT2aqoKHvXQoJ0cHDNym9baHy2jiWpL+c=;
	b=jObJYYBWngmMTqKE9pa/TMUkT8LO0CBtmynUma489TVGvYksslycpI332s3XecRhTMP6qExj8
	Ypz0xRH2xUrUYyyKWZir/+qp+qHGFUMDaqJBvlU54mnX1TsT3PTRDzpxBB2ReXCmkfHyOZ5zyXL
	CwyxW7MtlysV2GcpxQCmfuw=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gFmJ24bgdzKm4x;
	Wed, 13 May 2026 16:06:26 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 1BA3940575;
	Wed, 13 May 2026 16:14:06 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Wed, 13 May 2026 16:14:05 +0800
Message-ID: <391ec8d3-3bf7-16fc-774a-96c917c67d56@huawei.com>
Date: Wed, 13 May 2026 16:14:04 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2 0/3] scsi: libsas: handle linkrate change in
 sas_rediscover_dev
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260513021603.3023329-1-yangxingui@huawei.com>
 <11d3560e-d956-4f0d-abc6-2ed897e0ce45@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <11d3560e-d956-4f0d-abc6-2ed897e0ce45@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh200004.china.huawei.com (7.202.181.111) To
 kwepemj100018.china.huawei.com (7.202.194.12)




On 2026/5/13 15:29, John Garry wrote:
> On 13/05/2026 03:16, Xingui Yang wrote:
>> When a device attached to an expander phy experiences a linkrate change
>> (e.g., due to cable reconnection or negotiation), the current code in
>> sas_rediscover_dev() treats it as "broadcast flutter" and takes no action
>> if the SAS address and device type remain unchanged.
> 
> Can sas_rediscover_dev() check the linkrate (vs expected) to understand 
> that this flutter has renegotiated the linkrate and then consider it not 
> just a flutter?

Hi, John
Theoretically, it is possible. As early as 2019, Jason attempted to 
propose the solution you mentioned. He conducted a relatively 
comprehensive assessment for flutter, including scenarios where the SAS 
address changes or the ATA ID changes. However, in actual use, such 
situations almost never occur unless there is an extremely short time 
window during which the drive is swapped or a new SATA drive is 
replaced. Because this solution is associated with other modifications 
and may have significant impacts, it has not been adopted.

https://lore.kernel.org/linux-scsi/20190130082412.9357-6-yanaijie@huawei.com/

Currently, scenarios involving changes in linkrate are relatively more 
common, and such situations can be easily reproduced by manually 
adjusting the linkrate by sysfs. Therefore, a less impactful synchronous 
update solution was adopted.

Thanks.
Xingui
