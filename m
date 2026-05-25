Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAEF76026;
	Mon, 25 May 2026 02:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779675966; cv=none; b=o1C0Ko8kGyWPLKsTcvMqPulgftJHRYoPcwleEoo2kWtYVUVXO/whDqvf6h8bzGqMwlt3M4vehKHeK6rrfLGDk0ghzk2PF8Sbqur5q0mARe0dSPEDZQFeo+ARHDI6LJqGZe15m8fN7VrHWYLMjsGofVWrej46iewJn/aoxhtzyV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779675966; c=relaxed/simple;
	bh=CR5Bmvc7i/4vjJ5PWnUgO0MSqWcLIDUJYL1YeNNSjB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=doyKVR8wrVHrqDUUwWFn67d71ZQWxC737bB69wbYbemrmAbUpQ7F5rXQb4azvOEvIfgP3XcOGmJnieBXl/64TW1fPrQheTkkv9CvydsnNc/k/4iCyQAIARYFEjIHEnsrJXpU72IWWmi58dZWz0GcNbKTdtYVrD3/4KckT0bi8es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Rjgb4TmT; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Rjgb4TmT"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=36f3VNRGliU+Pl9RRq/G+QGCcFV7Vf0J5fDvh4V8DgM=;
	b=Rjgb4TmT/juu53XEVb5T7LOrxc8VvjkTnmikFyF7eh+kLlAEmzVxI1yjxbiFk0fx6JBcQtNPa
	D/jTacq7WCiL0Xlx+msS2vBJAorme9Yyz5RvGzROOBElH1NWTzo9DVSD/wwTH23a4jgwawfuGMj
	4HXtRFEq8gsnEBD+dnVSh2E=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gP00g3zMzz1cyPd;
	Mon, 25 May 2026 10:18:11 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 957F14056E;
	Mon, 25 May 2026 10:25:54 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 25 May 2026 10:25:53 +0800
Message-ID: <be627116-acd2-c9c5-a665-b86e4f6392c5@huawei.com>
Date: Mon, 25 May 2026 10:25:53 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260515084531.866259-1-yangxingui@huawei.com>
 <20260515084531.866259-3-yangxingui@huawei.com>
 <b18e1085-1d77-4b54-ae4d-8ae5a50a79b9@oracle.com>
 <5600f8fa-489a-9b81-9966-dc5d436c462e@huawei.com>
 <b99cd59f-b986-432e-aaf1-3b757e1c4c34@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <b99cd59f-b986-432e-aaf1-3b757e1c4c34@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh100012.china.huawei.com (7.202.181.97) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/5/22 17:16, John Garry wrote:
> On 21/05/2026 10:04, yangxingui wrote:
>>>
>>> Can this be reused (to lose and find the device with updated info)? 
>>> Or why not good enough?
>>>
>>> I don't know why you need full revalidation.
>>
>> Hi, John
>> As the commit log. The existing pattern (unregister + 
>> sas_discover_new) handles the "replace" case where the SAS address 
>> changes completely, implying a different device.
>> For the flutter case where we detect linkrate/sas_addr changes,
> 
> Can you please clarify this: you say that the existing pattern handles 
> "replace" case where the SAS address changes completely, and then 
> flutter case covers sas_addr changes.
> 
> What is the difference in the SAS address changes between the two cases?
> 
Hi, John

The difference is in when the SAS address change is detected:
Replace case:
- Detected immediately by the initial SMP DISCOVER response
- New SAS address differs from stored phy->attached_sas_addr

Flutter case:
- Initial SMP DISCOVER shows SAS address matching stored 
phy->attached_sas_addr
- Linkrate may change
- After sas_ex_phy_discover() refreshes phy info, child device address 
and linkrate may mismatched with refreshed phy info

Additional issue with Replace flow:
The existing replace code path also suffers from the same sysfs_warn_dup 
issue I mentioned earlier. sas_unregister_devs_sas_addr() only marks the 
device as gone and adds it to destroy_list. The actual sysfs cleanup 
happens later in sas_destruct_devices(). Calling sas_discover_new() 
immediately after unregister causes sysfs duplicate directory errors.

We need to optimize the replace process.

Thanks,
Xingui
