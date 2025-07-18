Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F63642AA5;
	Fri, 18 Jul 2025 01:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752800861; cv=none; b=Xb9pITKjiy9z3xhtD9VOxg8f0B2Pm16gSD1CuWDTZdn0qvJ/MFmRKqhnEY5+cmblVk6trQepruFCwXNNlYO2vR9BKnr/VrbGg3fHAMjPOKnLLnWnQl6/ppbA05F6LEQkUvYVU+iGxujiTSPJdJ/4h3eFVkv3cUjCku8gR3ugJdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752800861; c=relaxed/simple;
	bh=d6brpMB7zVP5G+DY+siduqdBys93HjdpZE3GGE7sLmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SwmgMpKzyEr1wVk9DZ9XLLcgUDhN1QjW9H8PlBv1Kuy8B1owOdILKZbYROhqlLPgEcKJveN9mb74gsHCYlhSdEUsemaF3kTeOv7tOp4Yey+ryIysPetCdG4HgbeorusICo6nChr/xhJLw3uU4SkjPIdaXljNg1teVHQYf9JkZkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bjs3Y4QJqzXdxJ;
	Fri, 18 Jul 2025 09:03:05 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id 46450180B66;
	Fri, 18 Jul 2025 09:07:35 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemg500017.china.huawei.com (7.202.181.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 18 Jul 2025 09:07:34 +0800
Message-ID: <c4be23d1-7d8c-4944-b530-b8f92ac1adf0@huawei.com>
Date: Fri, 18 Jul 2025 09:07:29 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH] Revert "scsi: iscsi: Fix HW conn removal use after free"
To: Mike Christie <michael.christie@oracle.com>, <lduncan@suse.com>,
	<cleech@redhat.com>, <njavali@marvell.com>, <mrangankar@marvell.com>,
	<GR-QLogic-Storage-Upstream@marvell.com>, <martin.petersen@oracle.com>,
	<jejb@linux.ibm.com>, <James.Bottomley@HansenPartnership.com>
CC: <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <yukuai1@huaweicloud.com>,
	<houtao1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>,
	<chengzhihao1@huawei.com>, <lilingfeng@huaweicloud.com>
References: <20250715073926.3529456-1-lilingfeng3@huawei.com>
 <653eaa6f-4e85-43af-a13b-906e34a2e517@oracle.com>
From: Li Lingfeng <lilingfeng3@huawei.com>
In-Reply-To: <653eaa6f-4e85-43af-a13b-906e34a2e517@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemg500017.china.huawei.com (7.202.181.81)

Hi, Mike

在 2025/7/18 4:01, Mike Christie 写道:
> On 7/15/25 2:39 AM, Li Lingfeng wrote:
>> This reverts commit c577ab7ba5f3bf9062db8a58b6e89d4fe370447e.
>>
>> The invocation of iscsi_put_conn() in iscsi_iter_destory_conn_fn() is used
>> to free the initial reference counter of iscsi_cls_conn.
>> For non-qla4xxx cases, the ->destroy_conn() callback (e.g.,
>> iscsi_conn_teardown) will call iscsi_remove_conn() and iscsi_put_conn() to
>> remove the connection from the children list of session and free the
>> connection at last.
>> However for qla4xxx, it is not the case. The ->destroy_conn() callback
>> of qla4xxx will keep the connection in the session conn_list and doesn't
>> use iscsi_put_conn() to free the initial reference counter. Therefore,
>> it seems necessary to keep the iscsi_put_conn() in the
>> iscsi_iter_destroy_conn_fn(), otherwise, there will be memory leak
>> problem.
>>
> I must have thought we did a unregister instead of remove for
> some reason. Thanks for catching this.
Just wanted to check – do you still have the original diagnostic
information/data from the UAF issue? Since we're reverting the patch,
perhaps we should revisit the root cause to determine the most
appropriate fix approach.

Thanks,

Lingfeng

>
> Reviewed-by: Mike Christie <michael.christie@oracle.com>
>
