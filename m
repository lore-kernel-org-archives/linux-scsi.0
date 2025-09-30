Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E89E72617
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759224294; cv=none; b=eesCFFgo+L3T+wJfbpI4XwSGtrGxWEq4cQ9QknZzmFWIkdGQ0J6M8U58J4N84SfqxNgqf9qvGMI9WWN7PeI88Xy0H1g76iwLAKKYE6Oa86y//YZdQVdyLEeyulZ4AOYkNlfgQqU7zXAp/1JExb+v1zrE3P3oPSsSxL4cbjqnosw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759224294; c=relaxed/simple;
	bh=ygTu+mP0PWrjZqHe5O9K2a2tdN2nspxwrBOtP67KxsQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SaxpyrRTbuWbjU3+yheKpcxDGvujTmduuWNEgBWSnoPrqvSrDNU8Oe/i+Q26WBKtZ98swn8rNI7Tjb0xq6OOR1WXdVTvVoZhakkfXeQLc2ysxMtEHNB8Pk2Zm0AhozPUiyZyySFcC38IwRNhPxB7AJlCtv+bmi24q6QYLNgkDJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BHJ9ZzUh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BHJ9ZzUh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759224291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSUEKP67FC5DAupUJyz6Go74oVjDL9D3iqjJHWQVdCU=;
	b=BHJ9ZzUh4mtpY8pnYXx5IK3jv5/miBsKkkxpXRbP7roHa9XNr8W5gEzxqcRUCVSPDCuN5M
	miYFBhTlkJAuiC7nuK5zhGwNYoqq6RmawMxzUIK6aXKnZCsSGhiJ6t3m+f+z99Dhw75OQ9
	lxX1q1qFZW4PYKzlFeaH4ArbQxIy8JI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-637-GRN8vizfN3u8bkU9c2021Q-1; Tue,
 30 Sep 2025 05:24:48 -0400
X-MC-Unique: GRN8vizfN3u8bkU9c2021Q-1
X-Mimecast-MFC-AGG-ID: GRN8vizfN3u8bkU9c2021Q_1759224286
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31D79180029A;
	Tue, 30 Sep 2025 09:24:45 +0000 (UTC)
Received: from [10.44.33.194] (unknown [10.44.33.194])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0638119560B4;
	Tue, 30 Sep 2025 09:24:38 +0000 (UTC)
Message-ID: <7029d26e-2311-4c15-908f-32a3608c2004@redhat.com>
Date: Tue, 30 Sep 2025 05:24:37 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 11/11] scsi: qla2xxx: Fix 2 memcpy field-spanning
 write issue
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, hare@suse.de,
 kbusch@kernel.org, martin.petersen@oracle.com,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: bgurney@redhat.com, axboe@kernel.dk, emilne@redhat.com,
 gustavoars@kernel.org, hch@lst.de, james.smart@broadcom.com,
 kees@kernel.org, linux-hardening@vger.kernel.org, njavali@marvell.com,
 sagi@grimberg.me
References: <20250926000200.837025-1-jmeneghi@redhat.com>
 <20250926000200.837025-12-jmeneghi@redhat.com>
 <0af9cbc4-a410-44f3-affc-a09e5c41ccd4@embeddedor.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <0af9cbc4-a410-44f3-affc-a09e5c41ccd4@embeddedor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi Gustavo.

Sorry for my late reply.

Yes, I will remove this patch and replaces it with your proposed patch[1] from the V9 patch email thread.

I see that Bryan has already tested your new patch and it works.  I agree the new patch is a much simpler/better version.

[1] https://lore.kernel.org/linux-nvme/97526d45-ec7d-48a0-bdc6-659f75839f53@embeddedor.com/#t

I will add this to my V11 patch series.

/John

On 9/26/25 5:00 AM, Gustavo A. R. Silva wrote:
> Hi,
> 
> Shouldn't this patch be removed from this series, since it's going to be
> reverted anyways?
> 
> Thanks
> -Gustavo
> 
> On 9/26/25 02:02, John Meneghini wrote:
>> From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
>>
>> purex_item.iocb is defined as a 64-element u8 array, but 64 is the
>> minimum size and it can be allocated larger. This makes it a standard
>> empty flex array.
>>
>> This was motivated by field-spanning write warnings during FPIN testing.
>>
>>    >  kernel: memcpy: detected field-spanning write (size 60) of single
>>    >  field "((uint8_t *)fpin_pkt + buffer_copy_offset)"
>>    >  at drivers/scsi/qla2xxx/qla_isr.c:1221 (size 44)
>>
>> I removed the outer wrapper from the iocb flex array, so that it can be
>> linked to `purex_item.size` with `__counted_by`.
>>
>> These changes remove the default minimum 64-byte allocation, requiring
>> further changes.
>>
>>    In `struct scsi_qla_host` the embedded `default_item` is now followed
>>    by `__default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE]` to reserve space
>>    that will be used as `default_item.iocb`. This is wrapped using the
>>    `TRAILING_OVERLAP()` macro helper, which effectively creates a union
>>    between flexible-array member `default_item.iocb` and
>>    `__default_item_iocb`.
>>
>>    Since `struct pure_item` now contains a flexible-array member, the
>>    helper must be placed at the end of `struct scsi_qla_host` to prevent
>>    a `-Wflex-array-member-not-at-end` warning.
>>
>>    `qla24xx_alloc_purex_item()` is adjusted to no longer expect the
>>    default minimum size to be part of `sizeof(struct purex_item)`,
>>    the entire flexible array size is added to the structure size for
>>    allocation.
>>
>> This also slightly changes the layout of the purex_item struct, as
>> 2-bytes of padding are added between `size` and `iocb`. The resulting
>> size is the same, but iocb is shifted 2-bytes (the original `purex_item`
>> structure was padded at the end, after the 64-byte defined array size).
>> I don't think this is a problem.
>>
>> In qla_os.c:qla24xx_process_purex_rdp()
>>
>> To avoid a null pointer dereference the vha->default_item should be set
>> to 0 last if the item pointer passed to the function matches.  Also use
>> a local variable to avoid multiple de-referencing of the item.
>>
>> Tested-by: Bryan Gurney <bgurney@redhat.com>
>> Co-developed-by: Chris Leech <cleech@redhat.com>
>> Signed-off-by: Chris Leech <cleech@redhat.com>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>   drivers/scsi/qla2xxx/qla_def.h  | 10 ++++++----
>>   drivers/scsi/qla2xxx/qla_isr.c  | 17 ++++++++---------
>>   drivers/scsi/qla2xxx/qla_nvme.c |  2 +-
>>   drivers/scsi/qla2xxx/qla_os.c   |  9 ++++++---
>>   4 files changed, 21 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
>> index cb95b7b12051..604e66bead1e 100644
>> --- a/drivers/scsi/qla2xxx/qla_def.h
>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>> @@ -4890,9 +4890,7 @@ struct purex_item {
>>                    struct purex_item *pkt);
>>       atomic_t in_use;
>>       uint16_t size;
>> -    struct {
>> -        uint8_t iocb[64];
>> -    } iocb;
>> +    uint8_t iocb[] __counted_by(size);
>>   };
>>   #include "qla_edif.h"
>> @@ -5101,7 +5099,6 @@ typedef struct scsi_qla_host {
>>           struct list_head head;
>>           spinlock_t lock;
>>       } purex_list;
>> -    struct purex_item default_item;
>>       struct name_list_extended gnl;
>>       /* Count of active session/fcport */
>> @@ -5130,6 +5127,11 @@ typedef struct scsi_qla_host {
>>   #define DPORT_DIAG_IN_PROGRESS                 BIT_0
>>   #define DPORT_DIAG_CHIP_RESET_IN_PROGRESS      BIT_1
>>       uint16_t dport_status;
>> +
>> +    /* Must be last --ends in a flexible-array member. */
>> +    TRAILING_OVERLAP(struct purex_item, default_item, iocb,
>> +        uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
>> +    );
>>   } scsi_qla_host_t;
>>   struct qla27xx_image_status {
>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
>> index 8ff8781dae47..ccb044693dcb 100644
>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>> @@ -1078,17 +1078,17 @@ static struct purex_item *
>>   qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
>>   {
>>       struct purex_item *item = NULL;
>> -    uint8_t item_hdr_size = sizeof(*item);
>>       if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
>> -        item = kzalloc(item_hdr_size +
>> -            (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
>> +        item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
>>       } else {
>>           if (atomic_inc_return(&vha->default_item.in_use) == 1) {
>>               item = &vha->default_item;
>>               goto initialize_purex_header;
>>           } else {
>> -            item = kzalloc(item_hdr_size, GFP_ATOMIC);
>> +            item = kzalloc(
>> +                struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
>> +                GFP_ATOMIC);
>>           }
>>       }
>>       if (!item) {
>> @@ -1128,17 +1128,16 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
>>    * @vha: SCSI driver HA context
>>    * @pkt: ELS packet
>>    */
>> -static struct purex_item
>> -*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
>> +static struct purex_item *
>> +qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
>>   {
>>       struct purex_item *item;
>> -    item = qla24xx_alloc_purex_item(vha,
>> -                    QLA_DEFAULT_PAYLOAD_SIZE);
>> +    item = qla24xx_alloc_purex_item(vha, QLA_DEFAULT_PAYLOAD_SIZE);
>>       if (!item)
>>           return item;
>> -    memcpy(&item->iocb, pkt, sizeof(item->iocb));
>> +    memcpy(&item->iocb, pkt, QLA_DEFAULT_PAYLOAD_SIZE);
>>       return item;
>>   }
>> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
>> index 8ee2e337c9e1..92488890bc04 100644
>> --- a/drivers/scsi/qla2xxx/qla_nvme.c
>> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
>> @@ -1308,7 +1308,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
>>       ql_dbg(ql_dbg_unsol, vha, 0x2121,
>>              "PURLS OP[%01x] size %d xchg addr 0x%x portid %06x\n",
>> -           item->iocb.iocb[3], item->size, uctx->exchange_address,
>> +           item->iocb[3], item->size, uctx->exchange_address,
>>              fcport->d_id.b24);
>>       /* +48    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
>>        * ----- -----------------------------------------------
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>> index d4b484c0fd9d..32437bae1a30 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -6459,9 +6459,12 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
>>   void
>>   qla24xx_free_purex_item(struct purex_item *item)
>>   {
>> -    if (item == &item->vha->default_item)
>> -        memset(&item->vha->default_item, 0, sizeof(struct purex_item));
>> -    else
>> +    scsi_qla_host_t *base_vha = item->vha;
>> +
>> +    if (item == &base_vha->default_item) {
>> +        memset(&base_vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
>> +        memset(&base_vha->default_item, 0, sizeof(struct purex_item));
>> +    } else
>>           kfree(item);
>>   }
> 

