Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAA0CA6F;
	Mon, 25 Aug 2025 01:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756086166; cv=none; b=gI+CJTXrMde15Q3hlzXd2b+32Wxm9uiADaNIOL2LAushtIHkNC17OoYu5BEF8LMQ9oph2XWjy9SF6QbEBiZS8ZhQIZ3oNt/UGiKDCYFVPdFwz0zOhzg/RhBB6oE4Lf4lPQ5r6mfUodSgBq69jwORFxGEFnI41PWyvukH6qC2Ais=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756086166; c=relaxed/simple;
	bh=cV/AGyl5DgDOuNkUqkhvjHqP2OA+S+ziWi6EL5cmydQ=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RN612y1kID0Dc4tphZLsD1gsPIzX8oVis9tixwgDkbiYgY3rGUR7kN63clQAWEo3tCgYIL1lN3vr+hJCptg8Qq3BECSQ6dJMWG/CpQx70LqiaKcI+25BlPti7HD9JTA9eScBwtlqJBJQYUn4VlC0slAlT2yXuKSN5zFbCmJc2OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c9D2T0Wqrz2Cftt;
	Mon, 25 Aug 2025 09:38:09 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id DB98D1401F2;
	Mon, 25 Aug 2025 09:42:33 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 Aug 2025 09:42:33 +0800
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded
 irq handling
To: Bart Van Assche <bvanassche@acm.org>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
 <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<prime.zeng@hisilicon.com>
From: Yihang Li <liyihang9@h-partners.com>
Message-ID: <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
Date: Mon, 25 Aug 2025 09:42:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh200005.china.huawei.com (7.202.181.112)

Hi Bart,

On 2025/8/22 23:17, Bart Van Assche wrote:
> On 8/22/25 12:59 AM, Yihang Li wrote:
>> We found that when the CPU handling the interrupt thread is occupied by
>> other high-priority processes, the interrupt thread will not be scheduled.
>> So there is a change to switch the driver to use tasklet over threaded
>> interrupt handling.
> Tasklets have severe disadvantages and hence their removal has been
> proposed several times. See e.g. https://lwn.net/Articles/960041/.
> There must be a better solution than switching to tasklets.
> 

Thanks you for your reply. I will consider some other solution.
Additionally, do you have any good suggestions?

> Bart.
> .
> 
