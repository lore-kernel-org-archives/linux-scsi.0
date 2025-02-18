Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80F71B4F14
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739877829; cv=none; b=pTieb7ANkcPyRv/xg6Iyx9miUfyQLXQugUb+RNrHhZfmV65KF3v1BZFXsu7ycX5QGUE0Zd0W52QWtLAQOGc9rfGPz15QoPEaLoKtoEZrCx7Vk/TiLNCg0AGkLjFIj6O0hG5KiMkRKPmyLOVsGSD3YDUvwGLB+ef+I0NCQ+hslyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739877829; c=relaxed/simple;
	bh=hC5LG9UYeBd4rtzD2FmZzjh93lXlU5YiZ5Rt4vpwodA=;
	h=Subject:To:References:Cc:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=oiduEDFahReg6fkcbWvQ0zXEMzxWZkkGSVWwQiE6orTV24iX1JBW3RRnX4UsM8Nr1VydJeJFsafcgdDlHqCvizxEiJFZyp476kgS+PQZJFJzGQlQSUIeEUphwqw6+UDvBfUjCWHkE77Ijj8P0u5SjzVs/+C7yH90W9i4kMUh61g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YxxwZ4Vy6z4f3jqZ
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 19:23:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DE7E31A06DC
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2025 19:23:42 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP4 (Coremail) with SMTP id gCh0CgDHKl+9bbRnIOPIEA--.21472S3;
	Tue, 18 Feb 2025 19:23:42 +0800 (CST)
Subject: Re: [PATCH v3] scsi: core: clear driver private data when retry
 request
To: John Garry <john.g.garry@oracle.com>, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20250217021628.2929248-1-yebin@huaweicloud.com>
 <4fe6b94e-41ae-48b4-aa9d-a0712a4ef16e@oracle.com>
Cc: zhangxiaoxu5@huawei.com
From: yebin <yebin@huaweicloud.com>
Message-ID: <67B46DBD.7060805@huaweicloud.com>
Date: Tue, 18 Feb 2025 19:23:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4fe6b94e-41ae-48b4-aa9d-a0712a4ef16e@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgDHKl+9bbRnIOPIEA--.21472S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXw1fXw4kZF4fXF1DJFy3CFg_yoW5Ar1UpF
	W5Xa4jkr95KFW8C393XryYvFy3t393JryUG3WagwnxW3ZIkrZ29FyUtF98WFZ3ZF1Iyw17
	JF4qqr98WF9IvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU80fO7
	UUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/



On 2025/2/17 17:44, John Garry wrote:
> On 17/02/2025 02:16, Ye Bin wrote:
>> From: Ye Bin <yebin10@huawei.com>
>>
>> After commit 1bad6c4a57ef
>> ("scsi: zero per-cmd private driver data for each MQ I/O"),
>> xen-scsifront/virtio_scsi/snic driver remove code that zeroes
>> driver-private command data. If request do retry will lead to
>> driver-private command data remains. Before commit 464a00c9e0ad
>> ("scsi: core: Kill DRIVER_SENSE") if virtio_scsi do capacity
>> expansion, first request may return UA then request will do retry,
>> as driver-private command data remains, request will return UA
>> again.
>
> So are there any drivers which expect this sort of behavior, i.e. keep
> private data between retries?

No driver that depends on the last state is found. If yes, the driver
should provide the init_cmd_priv function to manage private data. In
this way, the SCSI middle layer ignores the private data of the driver.

>
>> As a result, the request keeps retrying, and the request
>> times out and fails.
>> So zeroes driver-private command data when request do retry.
>>
>> Fixes: f7de50da1479 ("scsi: xen-scsifront: Remove code that zeroes
>> driver-private command data")
>> Fixes: c2bb87318baa ("scsi: virtio_scsi: Remove code that zeroes
>> driver-private command data")
>> Fixes: c3006a926468 ("scsi: snic: Remove code that zeroes
>> driver-private command data")
>> Signed-off-by: Ye Bin <yebin10@huawei.com>
>
>> ---
>
> Ps: in future, please list the changes per version here
>
Thanks for the heads-up.
>>   drivers/scsi/scsi_lib.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index be0890e4e706..f1cfe0bb89b2 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1669,13 +1669,6 @@ static blk_status_t scsi_prepare_cmd(struct
>> request *req)
>>       if (in_flight)
>>           __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>> -    /*
>> -     * Only clear the driver-private command data if the LLD does not
>> supply
>> -     * a function to initialize that data.
>> -     */
>> -    if (!shost->hostt->init_cmd_priv)
>> -        memset(cmd + 1, 0, shost->hostt->cmd_size);
>> -
>>       cmd->prot_op = SCSI_PROT_NORMAL;
>>       if (blk_rq_bytes(req))
>>           cmd->sc_data_direction = rq_dma_dir(req);
>> @@ -1842,6 +1835,13 @@ static blk_status_t scsi_queue_rq(struct
>> blk_mq_hw_ctx *hctx,
>>       if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>>           goto out_dec_target_busy;
>> +    /*
>> +     * Only clear the driver-private command data if the LLD does not
>> supply
>> +     * a function to initialize that data.
>> +     */
>> +    if (shost->hostt->cmd_size && !shost->hostt->init_cmd_priv)
>> +        memset(cmd + 1, 0, shost->hostt->cmd_size);
>> +
>>       if (!(req->rq_flags & RQF_DONTPREP)) {
>>           ret = scsi_prepare_cmd(req);
>>           if (ret != BLK_STS_OK)
>

