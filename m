Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B3EC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 01:56:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B301964FFB
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 01:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhCJBzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 20:55:31 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13899 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhCJBzJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 20:55:09 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DwFVB5hMlzjVT7;
        Wed, 10 Mar 2021 09:53:38 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.131) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Wed, 10 Mar 2021
 09:54:55 +0800
Subject: Re: [PATCH 29/31] hisi_sas: use task tag to reference the slot
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>,
        <linux-scsi@vger.kernel.org>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-30-hare@suse.de>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <2202707d-a1de-f1d1-3484-92989ff5c4f4@huawei.com>
Date:   Wed, 10 Mar 2021 09:54:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20210222132405.91369-30-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.40.192.131]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2021/2/22 21:24, Hannes Reinecke wrote:
> Use the task task to reference the command slot and drop the
> internal slot bitmap.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/hisi_sas/hisi_sas.h      |  1 -
>   drivers/scsi/hisi_sas/hisi_sas_main.c | 78 ++-------------------------
>   2 files changed, 5 insertions(+), 74 deletions(-)
>
> diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
> index 2401a9575215..6efe980789ee 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas.h
> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
> @@ -419,7 +419,6 @@ struct hisi_hba {
>   	struct workqueue_struct *wq;
>   
>   	int slot_index_count;
> -	int last_slot_index;
>   	int last_dev_id;
>   	unsigned long *slot_index_tags;
>   	unsigned long reject_stp_links_msk;
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index af653f4393ea..6402c4e4befa 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -155,62 +155,6 @@ void hisi_sas_stop_phys(struct hisi_hba *hisi_hba)
>   }
>   EXPORT_SYMBOL_GPL(hisi_sas_stop_phys);
>   
> -static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
> -{
> -	void *bitmap = hisi_hba->slot_index_tags;
> -
> -	clear_bit(slot_idx, bitmap);
> -}
> -
> -static void hisi_sas_slot_index_free(struct hisi_hba *hisi_hba, int slot_idx)
> -{
> -	if (hisi_hba->hw->slot_index_alloc ||
> -	    slot_idx >= HISI_SAS_UNRESERVED_IPTT) {
> -		spin_lock(&hisi_hba->lock);
> -		hisi_sas_slot_index_clear(hisi_hba, slot_idx);
> -		spin_unlock(&hisi_hba->lock);
> -	}
> -}
> -
> -static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
> -{
> -	void *bitmap = hisi_hba->slot_index_tags;
> -
> -	set_bit(slot_idx, bitmap);
> -}
> -
> -static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba)
> -{
> -	int index;
> -	void *bitmap = hisi_hba->slot_index_tags;
> -
> -	spin_lock(&hisi_hba->lock);
> -	index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
> -				   hisi_hba->last_slot_index + 1);
> -	if (index >= hisi_hba->slot_index_count) {
> -		index = find_next_zero_bit(bitmap,
> -				hisi_hba->slot_index_count,
> -				HISI_SAS_UNRESERVED_IPTT);
> -		if (index >= hisi_hba->slot_index_count) {
> -			spin_unlock(&hisi_hba->lock);
> -			return -SAS_QUEUE_FULL;
> -		}
> -	}
> -	hisi_sas_slot_index_set(hisi_hba, index);
> -	hisi_hba->last_slot_index = index;
> -	spin_unlock(&hisi_hba->lock);
> -
> -	return index;
> -}
> -
> -static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
> -{
> -	int i;
> -
> -	for (i = 0; i < hisi_hba->slot_index_count; ++i)
> -		hisi_sas_slot_index_clear(hisi_hba, i);
> -}
> -
>   void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
>   			     struct hisi_sas_slot *slot)
>   {
> @@ -246,8 +190,6 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
>   	spin_unlock(&sas_dev->lock);
>   
>   	memset(slot, 0, offsetof(struct hisi_sas_slot, buf));
> -
> -	hisi_sas_slot_index_free(hisi_hba, slot->idx);
>   }
>   EXPORT_SYMBOL_GPL(hisi_sas_slot_task_free);
>   
> @@ -482,10 +424,8 @@ static int hisi_sas_task_prep(struct sas_task *task,
>   
>   	if (hisi_hba->hw->slot_index_alloc)
>   		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
> -	else if (scmd)
> -		rc = scmd->request->tag;
>   	else
> -		rc = hisi_sas_slot_index_alloc(hisi_hba);
> +		rc = scmd->request->tag;
>   
>   	if (rc < 0)
>   		goto err_out_dif_dma_unmap;
> @@ -1975,9 +1915,10 @@ hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
>   	port = to_hisi_sas_port(sas_port);
>   
>   	/* simply get a slot and send abort command */
> -	rc = = task->tag;
> -	if (rc < 0)
> -		rc = hisi_sas_slot_index_alloc(hisi_hba);
> +	if (hisi_hha->hw->slot_index_alloc)


hisi_hha is wrong , it should be hisi_hba


> +		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
> +	else
> +		rc = = task->tag;


Delete unnecessary "="


>   	if (rc < 0)
>   		goto err_out;
>   
> @@ -2440,12 +2381,6 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
>   	if (!hisi_hba->breakpoint)
>   		goto err_out;
>   
> -	hisi_hba->slot_index_count = max_command_entries;
> -	s = hisi_hba->slot_index_count / BITS_PER_BYTE;
> -	hisi_hba->slot_index_tags = devm_kzalloc(dev, s, GFP_KERNEL);
> -	if (!hisi_hba->slot_index_tags)
> -		goto err_out;
> -
>   	s = sizeof(struct hisi_sas_initial_fis) * HISI_SAS_MAX_PHYS;
>   	hisi_hba->initial_fis = dmam_alloc_coherent(dev, s,
>   						    &hisi_hba->initial_fis_dma,
> @@ -2460,9 +2395,6 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba)
>   	if (!hisi_hba->sata_breakpoint)
>   		goto err_out;
>   
> -	hisi_sas_slot_index_init(hisi_hba);
> -	hisi_hba->last_slot_index = HISI_SAS_UNRESERVED_IPTT;
> -
>   	hisi_hba->wq = create_singlethread_workqueue(dev_name(dev));
>   	if (!hisi_hba->wq) {
>   		dev_err(dev, "sas_alloc: failed to create workqueue\n");

