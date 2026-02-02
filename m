Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49802D321B;
	Mon,  2 Feb 2026 09:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770023005; cv=none; b=h03g4EUvZxjZqkuJepkDNpVNs9nWkLMYihHl6XIag+/JfPrSdJtslAJE/lQuSH03COQx4W0a14ECMpYCc/5ljSDNKsG1EINN0/MnctXgkT+e9AaXkoIKSKoXDhcOghKN6ts/u616JtMUN2O3NiolBXFg7spIuhTNxCEhl7hP2D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770023005; c=relaxed/simple;
	bh=4GjmCsWRr+FETVngAPDsZlV30UJp2mvu9EZKuW7hXZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IMmG2e4kF4FuvdSYmM6ZVAwDiqDMemcKt4NpWvZvIpioqv8NlsmsgUJnppiLVf5b/DQs2Wn479A3juiQdhA0fyNSCwp/g+vq4gR1dyMzb2tCxQsXOkUAczDVeQwRadu7fNNe0q9W0J0dzAHNH/Kc2sUa0txvrL3ApWJxRkrvVYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=rTR6x9aV; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="rTR6x9aV"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Wy6N6Xreznc+LxDgLsfoWLcCzePyHaaaTDYPRY6YNk8=;
	b=rTR6x9aVfuynDla2TSnyjdNFW4o86aZ+5XgrDR+e+7jgYDDAEPjjhDMXM4mQK/hArE/UCyPgR
	lLgv2IC/khe4gQM/WO1/A9wzMNb7Z84cvZ8dONhGVjxjCmLKJFAh9Bvj+aPIlH4+0pAr1vJ58wM
	/TyzAAfbknzsV32Evm1jiIM=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4f4LC363x1zpSvZ;
	Mon,  2 Feb 2026 16:59:11 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id E4A624036C;
	Mon,  2 Feb 2026 17:03:18 +0800 (CST)
Received: from [10.174.176.253] (10.174.176.253) by
 dggpemf500002.china.huawei.com (7.185.36.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 2 Feb 2026 17:03:17 +0800
Message-ID: <df7c11fd-f0f0-45aa-8c2b-0e286cd1f9d9@huawei.com>
Date: Mon, 2 Feb 2026 17:03:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix dev_list race conditions with proper
 locking
To: Chaohai Chen <wdhh6@aliyun.com>, Damien Le Moal <dlemoal@kernel.org>
CC: <john.g.garry@oracle.com>, <James.Bottomley@hansenpartnership.com>,
	<martin.petersen@oracle.com>, <johannes.thumshirn@wdc.com>,
	<mingo@kernel.org>, <cassel@kernel.org>, <tglx@kernel.org>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20260129093859.1418749-1-wdhh6@aliyun.com>
 <aa5ca682-ea38-49f6-81a1-6b154f00239d@kernel.org>
 <aX3lV4erBYL068PT@LAPTOP-RK2E6KJ3.localdomain>
 <b4f3b1d7-45f7-49c4-ad16-e085d71e2d9b@kernel.org>
 <aYBT9ASycq4hA5U7@VM-209-93-tencentos>
From: Jason Yan <yanaijie@huawei.com>
In-Reply-To: <aYBT9ASycq4hA5U7@VM-209-93-tencentos>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500002.china.huawei.com (7.185.36.57)

在 2026/2/2 15:36, Chaohai Chen 写道:
> On Mon, Feb 02, 2026 at 10:21:43AM +0900, Damien Le Moal wrote:
>> On 1/31/26 20:19, Chaohai Chen wrote:
>>>>> +	 * We need to unlock before calling sas_unregister_dev() as it
>>>>> +	 * may sleep, but we hold a reference to prevent device removal.
>>>>
>>>> And why is that necessary ?
>>>>
>>> Because when unlocked, it is possible that the device has already been
>>> released by another thread. If there is no reference count, it will lead
>>> to used after free.
>>
>> Please clearly explain the problem path. Your statements about "another thread"
>> is too vague.
>>
> 1.
> CPU 1: disco_q                          CPU 2: event_q
> ==============================          ==============================
> sas_discover_domain()                   sas_phye_loss_of_signal()
> 
> sas_ex_level_discovery()                sas_deform_port(phy, true)
> 
> list_for_each_entry(dev,                sas_unregister_domain_devices()
>    &port->dev_list, ...)
> 
> NOP                                     list_for_each_entry_safe_reverse(
>                                          dev, n, &port->dev_list, ...)
> 
> NOP                                     sas_unregister_dev(port, dev)
> 
> NOP                                     kfree(dev)
> 
> if (dev_is_expander(dev->dev_type))(UAF)
> ...

DISCE_DISCOVER_DOMAIN(sas_discover_domain) event is queued and executed 
in sas_form_port() synchronously, and sas_form_port() is executed in 
event_q. So I don't think the race condition above will happen.

> 
> 2.
> CPU 1: disco_q                          CPU 2: event_q
> ==============================          ==============================
> sas_resume_devices()                    sas_porte_link_reset_err()
> 
> sas_resume_port()                       sas_deform_port(phy, true)
> 
> list_for_each_entry_safe(dev,           sas_unregister_domain_devices()
>    &port->dev_list, ...)
> 
> NOP                                     free dev
> 
> visit dev->ex_dev(UAF)

This may happen in theory.

Thanks,
祝一切顺利
