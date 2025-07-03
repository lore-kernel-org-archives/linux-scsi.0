Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E3E226CF8
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 09:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751535654; cv=none; b=NgJOpZpI4BLtTMGT3H48SuapoR95as7OFyx33Zn9NFtB/VDjEmvmBvJE7m4+Lq9GQ3Tq1czdiw4NSSDPigbne4ZPZQJshhY8NETWA135BeCP/nEJGFaSS4rjE8LyQvEyhpZGDsy0DE72eh6JwLthY4f2QZ4lcIdMUniewRbN+vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751535654; c=relaxed/simple;
	bh=2DN82k2wcsrnWJyl9oSNE2JHa4x5ETAHLNmapRebD5Y=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fht0jkjAowV0+52to3FygZU6mgJVtCSNklz6L6zsdAyFcIJLBCLbMyK7llJTJx1j9dYIqgtr29RKP1sQU1bWeb9qsPT6t6bF6iARf8bKECgIiihu64BCOsd497OgmWO4fVVRzQJ+excvffr3w63XdnEiCevBkImxEYFJh5BGuGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bXsFt2kRjzKHNP9
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 17:40:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C5D341A14D2
	for <linux-scsi@vger.kernel.org>; Thu,  3 Jul 2025 17:40:48 +0800 (CST)
Received: from [10.174.177.163] (unknown [10.174.177.163])
	by APP2 (Coremail) with SMTP id Syh0CgAnDgwcUGZo_P4NAg--.37996S2;
	Thu, 03 Jul 2025 17:40:48 +0800 (CST)
Subject: Re: [PATCH 1/6] scsi: iscsi: Fix HW conn removal use after free
To: Li Lingfeng <lilingfeng3@huawei.com>,
 Mike Christie <michael.christie@oracle.com>
Cc: lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
 mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
 yangerkun <yangerkun@huawei.com>, "yukuai (C)" <yukuai3@huawei.com>,
 "zhangyi (F)" <yi.zhang@huawei.com>
References: <20220616222738.5722-1-michael.christie@oracle.com>
 <20220616222738.5722-2-michael.christie@oracle.com>
 <93484c2e-528e-46a1-83d6-c420e0d2a1ef@huawei.com>
 <bb21e728-ae5d-4328-8076-78c2f984ee05@huawei.com>
From: Hou Tao <houtao@huaweicloud.com>
Message-ID: <0b0a0bcf-b805-5041-9923-37ad391169c0@huaweicloud.com>
Date: Thu, 3 Jul 2025 17:40:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <bb21e728-ae5d-4328-8076-78c2f984ee05@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:Syh0CgAnDgwcUGZo_P4NAg--.37996S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXry8KFW3Jr4fJF17ZFW5Jrb_yoW5tFWxpa
	18Xa4YkFWDJw1fG3Zaq3Z0gFyYvFs3Ja4UK3W3Ww15Aw4Yyr9FvF4Dtayq9asxGrWkJF1q
	qF4jq3Z5X3Wjy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/

Hi Mike & Lingfeng:

On 7/3/2025 9:35 AM, Li Lingfeng wrote:
> Friendly ping...
>
> Thanks
>
> 在 2025/6/19 20:57, Li Lingfeng 写道:
>> Hi Mike,
>>
>> Thanks for this patch addressing the UAF issue. I have some questions
>> when
>> analyzing this patch.
>>
>> You mention that iscsi_remove_conn() frees the connection, making the
>> extra
>> iscsi_put_conn() cause UAF. However, looking at iscsi_remove_conn():
>>
>> iscsi_remove_conn
>>  device_del(&conn->dev)
>>   put_device(parent) // Only parent gets put_device
>>
>> This doesn't appear to free conn directly - only device_del() + parent
>> reference drop. Typically, conn is freed via put_device() on
>> &conn->dev when
>> its refcount reaches zero.
>>
>> Could you briefly clarify how iscsi_remove_conn() ultimately triggers
>> the
>> freeing, and in what scenario the subsequent iscsi_put_conn() leads
>> to UAF?
>>
>> Thanks again for the fix.
>>
>> Lingfeng
>>
>> 在 2022/6/17 6:27, Mike Christie 写道:
>>> If qla4xxx doesn't remove the connection before the session, the iSCSI
>>> class tries to remove the connection for it. We were doing a
>>> iscsi_put_conn() in the iter function which is not needed and will
>>> result
>>> in a use after free because iscsi_remove_conn() will free the
>>> connection.
>>>
>>> Reviewed-by: Lee Duncan <lduncan@suse.com>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>>   drivers/scsi/scsi_transport_iscsi.c | 2 --
>>>   1 file changed, 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/scsi_transport_iscsi.c
>>> b/drivers/scsi/scsi_transport_iscsi.c
>>> index 2c0dd64159b0..e6084e158cc0 100644
>>> --- a/drivers/scsi/scsi_transport_iscsi.c
>>> +++ b/drivers/scsi/scsi_transport_iscsi.c
>>> @@ -2138,8 +2138,6 @@ static int iscsi_iter_destroy_conn_fn(struct
>>> device *dev, void *data)
>>>           return 0;
>>>         iscsi_remove_conn(iscsi_dev_to_conn(dev));
>>> -    iscsi_put_conn(iscsi_dev_to_conn(dev));
>>> -
>>>       return 0;
>>>   }
> .

I didn't follow the patch either. If I understand correctly, the
invocation of  iscsi_put_conn() in iscsi_iter_destory_conn_fn() is used
to free the initial reference counter of iscsi_cls_conn. For non-qla4xxx
cases, the ->destroy_conn() callback (e.g., iscsi_conn_teardown) will
call iscsi_remove_conn() and iscsi_put_conn() to remove the connection
from the children list of session and free the connection at last.
However for qla4xxx, it is not the case. The ->destroy_conn() callback
of qla4xxx will keep the connection in the session conn_list and doesn't
use iscsi_put_conn() to free the initial reference counter. Therefore,
it seems necessary to keep the iscsi_put_conn() in the
iscsi_iter_destroy_conn_fn(), otherwise, there will be memory leak problem.

For the use-after-free problem, I think it may be due to the concurrent
invocation of iscsi_add_conn() and iscsi_session_teardown().
iscsi_add_conn() has already invoked device_add(), but fails on
transport_register_device() and is trying to invoke device_del(). At the
same time iscsi_session_teardown() invokes iscsi_remove_session() and is
invoking iscsi_iter_destroy_conn_fn for the failed-to-add connection.
The connection will be put twice: one in iscsi_iter_destroy_conn_fn()
and another one in iscsi_conn_setup() and leads to use-after-free problem.

