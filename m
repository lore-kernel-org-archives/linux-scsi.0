Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A3DAC28D13
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Aug 2022 11:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbiHYL0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Aug 2022 07:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238494AbiHYL0M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Aug 2022 07:26:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89D0402D5;
        Thu, 25 Aug 2022 04:26:10 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MD0v00BwXzlWX4;
        Thu, 25 Aug 2022 19:22:52 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 25 Aug 2022 19:26:07 +0800
Subject: Re: [PATCH -next] scsi: be2iscsi: fix null-ptr-deref in
 beiscsi_alloc_mem
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20220727072132.3906922-1-yebin10@huawei.com>
From:   yebin <yebin10@huawei.com>
Message-ID: <63075C4F.3010506@huawei.com>
Date:   Thu, 25 Aug 2022 19:26:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20220727072132.3906922-1-yebin10@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ping...

On 2022/7/27 15:21, Ye Bin wrote:
> Coccicheck report follow issue:
> ./drivers/scsi/be2iscsi/be_main.c:2561:37-41: ERROR: mem_descr -> mem_array is NULL but dereferenced.
> ./drivers/scsi/be2iscsi/be_main.c:2563:9-24: ERROR: mem_descr -> mem_array is NULL but dereferenced.
> ./drivers/scsi/be2iscsi/be_main.c:2566:9-20: ERROR: mem_descr -> mem_array is NULL but dereferenced.
>
> If goto free_mem, that's mean last "mem_descr->mem_array" is NULL. However,
> to avoid resource there will set "mem_descr->num_elements" with "j" which
> maybe non-zero. Then will lead to null-ptr-deref when free dma resource.
>
> To solved above issue set "mem_descr->mem_array" with "mem_arr_orig"
> when free memory.
>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 50a577ac3bb4..08f856447b4a 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2540,13 +2540,13 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
>   				mem_arr++;
>   			}
>   		} while (alloc_size);
> -		mem_descr->num_elements = j;
> -		mem_descr->size_in_bytes = phba->mem_req[i];
>   		mem_descr->mem_array = kmalloc_array(j, sizeof(*mem_arr),
>   						     GFP_KERNEL);
>   		if (!mem_descr->mem_array)
>   			goto free_mem;
>   
> +		mem_descr->num_elements = j;
> +		mem_descr->size_in_bytes = phba->mem_req[i];
>   		memcpy(mem_descr->mem_array, mem_arr_orig,
>   		       sizeof(struct mem_array) * j);
>   		mem_descr++;
> @@ -2554,7 +2554,11 @@ static int beiscsi_alloc_mem(struct beiscsi_hba *phba)
>   	kfree(mem_arr_orig);
>   	return 0;
>   free_mem:
> -	mem_descr->num_elements = j;
> +	if (j) {
> +		mem_descr->num_elements = j;
> +		mem_descr->mem_array = mem_arr_orig;
> +		mem_arr_orig = NULL;
> +	}
>   	while ((i) || (j)) {
>   		for (j = mem_descr->num_elements; j > 0; j--) {
>   			dma_free_coherent(&phba->pcidev->dev,

