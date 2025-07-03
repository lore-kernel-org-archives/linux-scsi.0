Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C38189F3B
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 01:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751506531; cv=none; b=mOjwhM+DRZdlGsbjCPwAx7Lio3SXWn9MrVwc3mICeXkOokvun1kgSfYZBtU6WoabmgkbmtY1jshmxGRH1ZvukSEhcFGgO/pd6E07IUfLQW/cXnxaPbqwhHvpYyS0duO3BuuIz1oaqNTxkHoSEqrDZP9GT4I3PmwNrgMe0A2TAyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751506531; c=relaxed/simple;
	bh=h0qSCTVtt0nzjkdaQ36vWS24qUpeYKTigYStDo0XgPk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=YxWy/nAJXyKyX9YHV/gqlmPll/JwQtL0t+ryo4bZvQQtqcHE7Ab9q82jpECeusIE3qDpANLa2nFI9SbhoCCwU5NFGbznWG0gLrbEbvmXmk8uv8ApFe8NeGAgLA8p/n9FzLpaTNvdhMMFHxBrsa5enNPrzgXaxegwSFcIXNgfSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bXfPB52Nsz2CfjF;
	Thu,  3 Jul 2025 09:31:26 +0800 (CST)
Received: from kwepemg500017.china.huawei.com (unknown [7.202.181.81])
	by mail.maildlp.com (Postfix) with ESMTPS id AC186140159;
	Thu,  3 Jul 2025 09:35:27 +0800 (CST)
Received: from [10.174.179.155] (10.174.179.155) by
 kwepemg500017.china.huawei.com (7.202.181.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 3 Jul 2025 09:35:26 +0800
Message-ID: <bb21e728-ae5d-4328-8076-78c2f984ee05@huawei.com>
Date: Thu, 3 Jul 2025 09:35:26 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: =?UTF-8?B?TW96aWxsYSBUaHVuZGVyYmlyZCDmtYvor5XniYg=?=
Subject: Re: [PATCH 1/6] scsi: iscsi: Fix HW conn removal use after free
From: Li Lingfeng <lilingfeng3@huawei.com>
To: Mike Christie <michael.christie@oracle.com>
CC: <lduncan@suse.com>, <cleech@redhat.com>, <njavali@marvell.com>,
	<mrangankar@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<jejb@linux.ibm.com>, yangerkun <yangerkun@huawei.com>, "yukuai (C)"
	<yukuai3@huawei.com>, Hou Tao <houtao1@huawei.com>, "zhangyi (F)"
	<yi.zhang@huawei.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
 <20220616222738.5722-2-michael.christie@oracle.com>
 <93484c2e-528e-46a1-83d6-c420e0d2a1ef@huawei.com>
In-Reply-To: <93484c2e-528e-46a1-83d6-c420e0d2a1ef@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemg500017.china.huawei.com (7.202.181.81)

Friendly ping...

Thanks

在 2025/6/19 20:57, Li Lingfeng 写道:
> Hi Mike,
>
> Thanks for this patch addressing the UAF issue. I have some questions 
> when
> analyzing this patch.
>
> You mention that iscsi_remove_conn() frees the connection, making the 
> extra
> iscsi_put_conn() cause UAF. However, looking at iscsi_remove_conn():
>
> iscsi_remove_conn
>  device_del(&conn->dev)
>   put_device(parent) // Only parent gets put_device
>
> This doesn't appear to free conn directly - only device_del() + parent
> reference drop. Typically, conn is freed via put_device() on 
> &conn->dev when
> its refcount reaches zero.
>
> Could you briefly clarify how iscsi_remove_conn() ultimately triggers the
> freeing, and in what scenario the subsequent iscsi_put_conn() leads to 
> UAF?
>
> Thanks again for the fix.
>
> Lingfeng
>
> 在 2022/6/17 6:27, Mike Christie 写道:
>> If qla4xxx doesn't remove the connection before the session, the iSCSI
>> class tries to remove the connection for it. We were doing a
>> iscsi_put_conn() in the iter function which is not needed and will 
>> result
>> in a use after free because iscsi_remove_conn() will free the 
>> connection.
>>
>> Reviewed-by: Lee Duncan <lduncan@suse.com>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/scsi/scsi_transport_iscsi.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_iscsi.c 
>> b/drivers/scsi/scsi_transport_iscsi.c
>> index 2c0dd64159b0..e6084e158cc0 100644
>> --- a/drivers/scsi/scsi_transport_iscsi.c
>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>> @@ -2138,8 +2138,6 @@ static int iscsi_iter_destroy_conn_fn(struct 
>> device *dev, void *data)
>>           return 0;
>>         iscsi_remove_conn(iscsi_dev_to_conn(dev));
>> -    iscsi_put_conn(iscsi_dev_to_conn(dev));
>> -
>>       return 0;
>>   }
