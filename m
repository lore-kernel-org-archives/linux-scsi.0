From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v1 10/13] IB/iser: Support T10-PI operations
Date: Mon, 03 Mar 2014 10:23:44 +0200
Message-ID: <53143C10.3020905@dev.mellanox.co.il>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com> <1393499589-15633-11-git-send-email-sagig@mellanox.com> <531408C8.10107@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:56724 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbaCCIXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 03:23:49 -0500
Received: by mail-ea0-f174.google.com with SMTP id f15so1390639eak.19
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2014 00:23:48 -0800 (PST)
In-Reply-To: <531408C8.10107@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Sagi Grimberg <sagig@mellanox.com>
Cc: roland@kernel.org, nab@linux-iscsi.org, oren@mellanox.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

On 3/3/2014 6:44 AM, Mike Christie wrote:
> On 02/27/2014 05:13 AM, Sagi Grimberg wrote:
>> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
>> index 58e14c7..7fd95fe 100644
>> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
>> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
>> @@ -62,6 +62,17 @@ static int iser_prepare_read_cmd(struct iscsi_task *task,
>>   	if (err)
>>   		return err;
>>   
>> +	if (scsi_prot_sg_count(iser_task->sc)) {
>> +		struct iser_data_buf *pbuf_in = &iser_task->prot[ISER_DIR_IN];
>> +
>> +		err = iser_dma_map_task_data(iser_task,
>> +					     pbuf_in,
>> +					     ISER_DIR_IN,
>> +					     DMA_FROM_DEVICE);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>>   	if (edtl > iser_task->data[ISER_DIR_IN].data_len) {
>>   		iser_err("Total data length: %ld, less than EDTL: "
>>   			 "%d, in READ cmd BHS itt: %d, conn: 0x%p\n",
>> @@ -113,6 +124,17 @@ iser_prepare_write_cmd(struct iscsi_task *task,
>>   	if (err)
>>   		return err;
>>   
>> +	if (scsi_prot_sg_count(iser_task->sc)) {
>> +		struct iser_data_buf *pbuf_out = &iser_task->prot[ISER_DIR_OUT];
>> +
>> +		err = iser_dma_map_task_data(iser_task,
>> +					     pbuf_out,
>> +					     ISER_DIR_OUT,
>> +					     DMA_TO_DEVICE);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>
> The xmit_task callout does handle failures like EINVAL. If the above map
> calls fail then you would get infinite retries. You would currently want
> to do the mapping in the init_task callout instead.

Same applies to the data dma_mapping that already exist in xmit_task today.
I can move it to init_task, but to me, dma_mapping is not really an init 
operation
but part of xmit stage.

> If it makes it easier on the driver implementation then it is ok to
> modify the xmit_task callers so that they handle multiple error codes
> for drivers like iser that have the xmit_task callout called from
> iscsi_queuecommand.

This sounds somewhat better to me.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

