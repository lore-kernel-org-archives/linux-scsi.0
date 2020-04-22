Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625E7C38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:15:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47A3620706
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgDVGPe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:15:34 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:43150 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbgDVGPd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Apr 2020 02:15:33 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E781E1AACA7F1342070A;
        Wed, 22 Apr 2020 14:15:28 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.100) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Wed, 22 Apr 2020
 14:15:18 +0800
Subject: Re: [PATCH] scsi:pmcraid:Replace dma_pool_malloc with dma_pool_zalloc
From:   Wu Bo <wubo40@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>
References: <1587197241-274646-1-git-send-email-wubo40@huawei.com>
Message-ID: <df2fe575-61a4-22a8-3870-6106218ec6cf@huawei.com>
Date:   Wed, 22 Apr 2020 14:15:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1587197241-274646-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.100]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

friendly ping...

On 2020/4/18 16:07, Wu Bo wrote:
> Replace dma_pool_malloc with dma_pool_zalloc to make the code more concise
> in pmcraid_allocate_control_blocks() function.
> 
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>   drivers/scsi/pmcraid.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 7eb88fe..aa9ae2a 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4652,7 +4652,7 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
>   
>   	for (i = 0; i < PMCRAID_MAX_CMD; i++) {
>   		pinstance->cmd_list[i]->ioa_cb =
> -			dma_pool_alloc(
> +			dma_pool_zalloc(
>   				pinstance->control_pool,
>   				GFP_KERNEL,
>   				&(pinstance->cmd_list[i]->ioa_cb_bus_addr));
> @@ -4661,8 +4661,6 @@ static int pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
>   			pmcraid_release_control_blocks(pinstance, i);
>   			return -ENOMEM;
>   		}
> -		memset(pinstance->cmd_list[i]->ioa_cb, 0,
> -			sizeof(struct pmcraid_control_block));
>   	}
>   	return 0;
>   }
> 


