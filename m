Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC70822F74D;
	Wed, 27 Aug 2025 02:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756260727; cv=none; b=AWm+8bV3gChRDyQaf94tSch6Kr/w/wUbLmuUlbKr0Gj/NgzNohiTXdBhQK9PIPOJbfjUtjjEH26p/RBfLeDYIsrnOb/dxBbzA2xXZXCAW9wJzDBWJxpxPrwjAK6D2xn9v0FT2ACWiQATOR347682CUHmBSk9zuftncm/WadaejQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756260727; c=relaxed/simple;
	bh=BgRBxygMrWWHPZEAEAr7odqjXiH3/rx2mPLVr1kJGoE=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AV1hi82I+MrAC4AFKnPuruHjgIFJD0a3sNwepTxK3Yk0lONavj1tpLYcZ+OcVo5NuM+O5aHVPYwAfeSYrBUfulQG8xegS1WOhzJDgbJjBj0ymHgFm5dPYlHEgFtWkbC+kJCfTXvX5yb5toee8JAOPxMBWoG0fYfH0MmFVuRNLMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cBShT6lzHz14MSw;
	Wed, 27 Aug 2025 10:11:53 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id B3F7014011F;
	Wed, 27 Aug 2025 10:12:00 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 27 Aug 2025 10:12:00 +0800
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Switch to use tasklet over threaded
 irq handling
To: Bart Van Assche <bvanassche@acm.org>, <martin.petersen@oracle.com>,
	<James.Bottomley@HansenPartnership.com>
References: <20250822075951.2051639-1-liyihang9@h-partners.com>
 <f02e9bb8-3477-4fa7-8b20-72bd518407ed@acm.org>
 <2f2e5534-a368-547d-dedf-78f8ca2fc999@h-partners.com>
 <62a58038-75da-4976-aec7-016491437735@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>,
	Yihang Li <liyihang9@h-partners.com>
From: Yihang Li <liyihang9@h-partners.com>
Message-ID: <f996d9cd-7be8-876e-680a-acf842afed5b@h-partners.com>
Date: Wed, 27 Aug 2025 10:11:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <62a58038-75da-4976-aec7-016491437735@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemh200005.china.huawei.com (7.202.181.112)

Hi Bart,

On 2025/8/26 0:12, Bart Van Assche wrote:
> 
> Other drivers process a small number of completions in interrupt context
> before switching to the threaded interrupt context. Has this approach
> been considered for the hisi_sas kernel driver?
> 

In the hisi_sas driver, no processing is done in the interrupt context.
In the interrupt thread context, the main tasks are handling abnormal I/O
and calling.task_done()->scsi_done(). I believe these tasks are not
suitable for execution in the interrupt context.

Based on the (https://lwn.net/Articles/960041/) you mentioned,
I'm trying to use WQ_BH instead.

Thanks,

Yihang.
