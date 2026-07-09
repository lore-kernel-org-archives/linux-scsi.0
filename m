Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA506391853;
	Thu,  9 Jul 2026 00:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558795; cv=none; b=O58OzIFglZ+ftpzyFcczK1dJvica+/1BjGFq5xoVovO1+g2lDE4Y3ZlGtAo5OXxinKWsThSheSJut66g7hHZVmANnAWpe5rJ7tPNquqg2jPEGt4x5vXwCgz63BMEWOg4vWtQHfcbr1pgwGFE67maRppRZRFg9BquYaMitA+jyqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558795; c=relaxed/simple;
	bh=LIHV+HE+Ks7r+PALIKh2TcbyskdwnmlliHjZbAEgX64=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=DvoLOcCvqtIiNkYl8eOOQDJpm2bof9DLccVitk3zgiqstBd51wSVbB8+wIlcp4SM9xCahzC8+pXHzC3lCEbb4m9Y55IoXPVoyF888kBr0oX9HVo0cr2RUWqPdn3CFG9NOs0JQi1uw2sm+utDNe+okB8Q2Ja4BpPpGy7PjUUsZUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=h+KpCCJs; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="h+KpCCJs"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FHgY77I+AJCpAnaShfoa2rikXqXoO/GrUtdyxE8eo0I=;
	b=h+KpCCJs3toAEm5JxN0X0N1GYbH0g9567vpOTG9MPJz9++mWosKbm6bQKhs82AwiLB25PzJcF
	LxZQ5lVlUMQ/pgM4+luGfjKohzm0UvmdUeweNCeJEJmeQOulsGDugicdgEiAd1NnMAlyCVjEqcd
	2/XD34ck2EBeQmiyouWaqsw=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gwbwh3mdjzLlVT;
	Thu,  9 Jul 2026 08:50:28 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id EA99D4048B;
	Thu,  9 Jul 2026 08:59:42 +0800 (CST)
Received: from [10.174.176.240] (10.174.176.240) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 9 Jul 2026 08:59:42 +0800
Message-ID: <33474553-c47c-4508-ac77-e0598834bb7c@huawei.com>
Date: Thu, 9 Jul 2026 08:59:41 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: validate and round up scatter_elem_sz module
 parameter
To: Bart Van Assche <bvanassche@acm.org>, <dgilbert@interlog.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<yukuai@kernel.org>, <hch@lst.de>, <axboe@kernel.dk>
CC: <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>
References: <20260708063045.2008478-1-yangerkun@huawei.com>
 <a5fa376d-90d6-4767-a994-2b91fb9cb951@acm.org>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <a5fa376d-90d6-4767-a994-2b91fb9cb951@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemf100006.china.huawei.com (7.202.181.220)

在 2026/7/9 0:10, Bart Van Assche 写道:
> On 7/7/26 11:30 PM, Yang Erkun wrote:
>> Additionally, the code handling scatter_elem_sz is refactored for
>> clarity: [ ... ]
> One change per patch please. The code refactoring and the bug fix should
> be separate patches.

Thanks for your review! Will do it next version.

> 
> Thanks,
> 
> Bart.

