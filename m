Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3343911CE;
	Tue, 21 Jul 2026 08:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784623272; cv=none; b=aFW7OJcKrMfXtqbXaQ3UXWpwnHSf336Hce///OjOpKCQIE7tX7E37ycoZLvxI15s6qf7QsD5xJZOrDJVGObIxxxYwHaD1ya0VugauK96erpXSiRk1chqZSfyWfrmJ+q72JeBUJVbXhADT+C04Y5W4eSIvmi8fFz4fyyiL/jXEpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784623272; c=relaxed/simple;
	bh=HO3LRLEeraz7bT5e0nXdWnsg7JxNccxKpSstSX4l3HU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=R8WCHxyeqaXj/TVwxoRr3rEKPe6CyMRF+xH4zqA2HHicowiAnfCdRfPBz3UKsy17tUJ/5wK5p1/ZBpTaVqwXkKaz7BzQm0eOfWTh3hr2YUFpAOyV7cBUZKmH0IjM1rHyc0ADwHuklWMX5I+3zlU5sinx4fGwzy5fjC6VkAIq1VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=d/93n50f; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="d/93n50f"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BGAfLAi9KIIxXseKbKW5YgZPGgtaE2WBk+pXTzavU7o=;
	b=d/93n50fZGPmfwq3HlTe+AgvvV/qbGPq8P5Tjsc0TfBq2mpScu11tDcs0Ose8abjUI6NDxL/k
	tiPRmV/AWthu3PxyoMaK73j6uUV8NM4iTZPIKQ2AIV83bSJA5RNWdfRxml6XN3SM+eObXEbEi3f
	0/kWt3TuEGbu8KdsEsz7EnM=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4h49b56FfRz12LDF;
	Tue, 21 Jul 2026 16:31:29 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id 4BF754058C;
	Tue, 21 Jul 2026 16:41:04 +0800 (CST)
Received: from [10.174.176.240] (10.174.176.240) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 21 Jul 2026 16:41:03 +0800
Message-ID: <a3cafc59-9773-4200-992d-368d4cc0f66b@huawei.com>
Date: Tue, 21 Jul 2026 16:41:03 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] scsi: sg: validate and clean up scatter_elem_sz
 handling
To: <bvanassche@acm.org>, <dgilbert@interlog.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<yukuai@kernel.org>, <hch@lst.de>, <axboe@kernel.dk>
CC: <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>
References: <20260709043234.2447340-1-yangerkun@huawei.com>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <20260709043234.2447340-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf100006.china.huawei.com (7.202.181.220)

gently ping for this series...

在 2026/7/9 12:32, Yang Erkun 写道:
> v1->v2:
> 1. Split into two patches, patch 1 is the minimal bugfix that adds
> validation to the scatter_elem_sz module parameter; patch 2 does the
> refactoring
> 2. Rebased; no functional change versus v1.
> 
> v1:
> https://patchwork.kernel.org/project/linux-scsi/patch/20260708063045.2008478-1-yangerkun@huawei.com/
> 
> Yang Erkun (2):
>    scsi: sg: validate scatter_elem_sz module parameter
>    scsi: sg: clean up scatter_elem_sz handling and module param
>      permissions
> 
>   drivers/scsi/sg.c | 68 +++++++++++++++++++++++------------------------
>   1 file changed, 34 insertions(+), 34 deletions(-)
> 

