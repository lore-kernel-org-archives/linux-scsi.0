Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5948A18651
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 01:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739324031; cv=none; b=A6o5EEWSQ2H4HzBQHwU9Lb+sDK0KPMyRaIPhuMV6Lb2hr89gvF+rV1sBkAcxmL+4kicNjYtK8ZWoHE7YGFdqXf09C3rKPz80qJoeOVBYL9L4ShUjC0EVyHQH1YI9B9eW5b3cR89kHmx2+hCXuOShv6Ab241/AHxSxekoifF0OHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739324031; c=relaxed/simple;
	bh=fsAD/BTXKtRIaY6yjwlAuR2KI2tidt3ot6/iUTWW64A=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V6x2hwTpbPgkWbsCnivrmuPovfnjpXP0vC6ldYkscsI+bUVlnoVSbU/8DXQSFyixDnfl0/oAbhASErysDrd7zFDpZzg1z6b9zEUP0TE6/tSjVmiwlu+8NjRefkUk3IT9m5VEYg5xO9qp4A5/DF+F23l3eRURUNTqx+uUbCx4MX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yt16T6Rp9z4f3kvM
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 09:33:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 989E41A0847
	for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 09:33:44 +0800 (CST)
Received: from [10.174.178.185] (unknown [10.174.178.185])
	by APP3 (Coremail) with SMTP id _Ch0CgB3ysR3+qtn6eYuDg--.29886S3;
	Wed, 12 Feb 2025 09:33:44 +0800 (CST)
Subject: Re: [PATCH] scsi: core: clear driver private data when retry request
To: Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20250210140333.3899021-1-yebin@huaweicloud.com>
 <ee7f80e5-6024-4ab0-97c8-b7817e2e2e0c@acm.org>
From: yebin <yebin@huaweicloud.com>
Message-ID: <67ABFA76.6060701@huaweicloud.com>
Date: Wed, 12 Feb 2025 09:33:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ee7f80e5-6024-4ab0-97c8-b7817e2e2e0c@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgB3ysR3+qtn6eYuDg--.29886S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXr43Zw18Cw17WFy7uw47twb_yoWrZrW5pF
	W5Xa4jkr4UJFW8C393Xry5XFy5t3s2yry7Wa43WwnxXFn0krWvyF1UGFy5WF93Ar18Ar13
	tF4qqr9xWFZ8ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0E
	wIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E74
	80Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0
	I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04
	k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/



On 2025/2/12 1:24, Bart Van Assche wrote:
> On 2/10/25 6:03 AM, Ye Bin wrote:
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
>> again. As a result, the request keeps retrying, and the request
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
>> ---
>>   drivers/scsi/scsi_lib.c | 19 +++++++++++++------
>>   1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index be0890e4e706..5b0c109c89bb 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1645,6 +1645,17 @@ static unsigned int
>> scsi_mq_inline_sgl_size(struct Scsi_Host *shost)
>>           sizeof(struct scatterlist);
>>   }
>> +static inline void scsi_clear_lld_private_data(struct scsi_cmnd *cmd,
>> +                           struct Scsi_Host *shost)
>> +{
>> +    /*
>> +     * Only clear the driver-private command data if the LLD does not
>> supply
>> +     * a function to initialize that data.
>> +     */
>> +    if (!shost->hostt->init_cmd_priv && shost->hostt->cmd_size)
>> +        memset(cmd + 1, 0, shost->hostt->cmd_size);
>> +}
>> +
>>   static blk_status_t scsi_prepare_cmd(struct request *req)
>>   {
>>       struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>> @@ -1669,12 +1680,7 @@ static blk_status_t scsi_prepare_cmd(struct
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
>> +    scsi_clear_lld_private_data(cmd, shost);
>>       cmd->prot_op = SCSI_PROT_NORMAL;
>>       if (blk_rq_bytes(req))
>> @@ -1848,6 +1854,7 @@ static blk_status_t scsi_queue_rq(struct
>> blk_mq_hw_ctx *hctx,
>>               goto out_dec_host_busy;
>>           req->rq_flags |= RQF_DONTPREP;
>>       } else {
>> +        scsi_clear_lld_private_data(cmd, shost);
>>           clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
>>       }
>
> Thanks for the detailed analysis. Has the following (untested) simpler
> alternative been considered?
>
Thank you for your reply.
I've considered your modification plan, but I think it's a little hard 
to understand and the code feels a little loose. Of course, it's just my 
own idea.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index d776f13cd160..6ee2903b4adb 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1664,13 +1664,6 @@ static blk_status_t scsi_prepare_cmd(struct
> request *req)
>       if (in_flight)
>           __set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>
> -    /*
> -     * Only clear the driver-private command data if the LLD does not
> supply
> -     * a function to initialize that data.
> -     */
> -    if (!shost->hostt->init_cmd_priv)
> -        memset(cmd + 1, 0, shost->hostt->cmd_size);
> -
>       cmd->prot_op = SCSI_PROT_NORMAL;
>       if (blk_rq_bytes(req))
>           cmd->sc_data_direction = rq_dma_dir(req);
> @@ -1837,6 +1830,13 @@ static blk_status_t scsi_queue_rq(struct
> blk_mq_hw_ctx *hctx,
>       if (!scsi_host_queue_ready(q, shost, sdev, cmd))
>           goto out_dec_target_busy;
>
> +    /*
> +     * Only clear the driver-private command data if the LLD does not
> supply
> +     * a function to initialize that data.
> +     */
> +    if (!shost->hostt->init_cmd_priv && shost->hostt->cmd_size)
> +        memset(scsi_cmd_priv(cmd), 0, shost->hostt->cmd_size);
> +
>       if (!(req->rq_flags & RQF_DONTPREP)) {
>           ret = scsi_prepare_cmd(req);
>           if (ret != BLK_STS_OK)
>
>

