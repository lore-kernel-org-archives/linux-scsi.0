Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D076B242D95
	for <linux-scsi@vger.kernel.org>; Tue, 27 Jan 2026 01:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769477304; cv=none; b=WUDvAQ/JRleLTZgjsQp8ZGhrZogYYkbqSALHYpVRXW9YDzmEafctDXHZwyEntkSS2l1xI3Y9dQqwajJAMJHVQdNoI9XM2rtBwSFCTL//7+wZ/6Qqmsf++sYVUo/fh6Zt0RqsDlXa4w/byJBfFO1KCShCsV4FzPp2DArN+j8NhQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769477304; c=relaxed/simple;
	bh=kV1ouKrGgN0Nws59Szu9Iuwqf0dmCVo7j2vAMed0VSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=crz6X2n50f+7/K2Oh3hreY1aa9KEkeXuSKplTG8BZ7vkqlXyP4Lq+V46fznGfKsNt1RbvfjjsbD2BxqGDGsn6q2AfEGhY1jVIPOrT2KjcnCCDH9MWu7vSFT2910vg6MoKKTMSVAZvb/nwXm4tISBkbpTclCJPkXQcbvdSi8rXmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=eMXvxAH7; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="eMXvxAH7"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UWsAF1m8O2HmowHSefxy2QegEGgnsXUF75vuLsUbrU0=;
	b=eMXvxAH7gwy9qSH9NJLtt6EBsCEjxiDnSapOnNGXMuQ58HLIdt4UpgghJEiUpND52ihXnLBQ8
	Ryx098lhuTe0+WUCXMJ4/ooljCctxsRGTX8b4wBfnQCGuVzUYQ9qwE4Sag/wjSkuj5GdKND33eT
	PSsg1mR25UDkkmpcJewl/5A=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4f0SNp4f1Vzcb0H;
	Tue, 27 Jan 2026 09:24:10 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E8E240537;
	Tue, 27 Jan 2026 09:28:18 +0800 (CST)
Received: from [10.174.179.194] (10.174.179.194) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 27 Jan 2026 09:28:17 +0800
Message-ID: <bba1750d-075f-f72b-8765-bcd1cee0a513@huawei.com>
Date: Tue, 27 Jan 2026 09:28:17 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/3] scsi: sg: Resolve soft lockup issue when opening
 /dev/sgX
To: Bart Van Assche <bvanassche@acm.org>, <dgilbert@interlog.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <yangerkun@huaweicloud.com>
References: <20260126132745.1830629-1-yangerkun@huawei.com>
 <20260126132745.1830629-3-yangerkun@huawei.com>
 <1f5708a2-b00a-4be1-a005-c5137ce5863b@acm.org>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <1f5708a2-b00a-4be1-a005-c5137ce5863b@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100006.china.huawei.com (7.202.181.220)



在 2026/1/27 1:04, Bart Van Assche 写道:
> On 1/26/26 5:27 AM, Yang Erkun wrote:
>> +    /* limit "big buff" to 1 MB */
>> +    if (size < 0 || size > 1048576)
>> +        return -ERANGE;
> 
> Why 1 MB? Please explain this in the patch description.

Hi,

Thank you very much for your review! I obtained this limit from the
function sg_proc_write_dressz, which states to "limit 'big buff' to 1
MB." Additionally, https://tldp.org/HOWTO/SCSI-Generic-HOWTO/proc.html
also mentions that "values between 0 and 1,048,576 (which is 2 ** 20)
are accepted."

Thanks again for your feedback! All your suggestions will be update in
the next version.

Thanks,
Erkun.

> 
> Thanks,
> 
> Bart.
