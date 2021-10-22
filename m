Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 747CEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 10:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5193761163
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 10:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232606AbhJVKva (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Oct 2021 06:51:30 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:4021 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbhJVKv3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2021 06:51:29 -0400
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HbLbG36lSz67mY7;
        Fri, 22 Oct 2021 18:45:14 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 22 Oct 2021 12:49:09 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 22 Oct 2021 11:49:08 +0100
Subject: Re: [PATCH] scsi: bnx2fc: Make use of the helper macro kthread_run()
To:     Cai Huoqing <caihuoqing@baidu.com>
CC:     Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20211021084221.2342-1-caihuoqing@baidu.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <834fa2cc-8a4a-b632-93bb-43d2dfdc4713@huawei.com>
Date:   Fri, 22 Oct 2021 11:49:08 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20211021084221.2342-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml731-chm.china.huawei.com (10.201.108.82) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/10/2021 09:42, Cai Huoqing wrote:
> Repalce kthread_create/wake_up_process() with kthread_run()

Replace

> to simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> index 71fa62bd3083..975512511a60 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -2723,9 +2723,8 @@ static int __init bnx2fc_mod_init(void)
>   
>   	bg = &bnx2fc_global;
>   	skb_queue_head_init(&bg->fcoe_rx_list);
> -	l2_thread = kthread_create(bnx2fc_l2_rcv_thread,
> -				   (void *)bg,
> -				   "bnx2fc_l2_thread");
> +	l2_thread = kthread_run(bnx2fc_l2_rcv_thread,
> +				(void *)bg, "bnx2fc_l2_thread");
>   	if (IS_ERR(l2_thread)) {
>   		rc = PTR_ERR(l2_thread);
>   		goto free_wq;

Are you then supposed to remove the wake_up_process() call also (not shown)?

> 

