Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDE0C47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 15:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C6C613F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 15:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhFCPWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 11:22:03 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3415 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhFCPWD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 11:22:03 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FwqJC3V2lz6twv;
        Thu,  3 Jun 2021 23:17:15 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 23:20:14 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 23:20:14 +0800
Subject: Re: [PATCH -next] scsi: mpi3mr: Fix error return code in
 mpi3mr_init_ioc()
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
References: <20210603151246.709016-1-yangyingliang@huawei.com>
Message-ID: <772c0760-3d51-14fd-183f-a3ed1fd43db4@huawei.com>
Date:   Thu, 3 Jun 2021 23:20:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20210603151246.709016-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Pls ignore this patch, I missed a branch to change.

On 2021/6/3 23:12, Yang Yingliang wrote:
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/scsi/mpi3mr/mpi3mr_fw.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index acb2be62080a..b8ecbdf08b3c 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -3295,6 +3295,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re_init)
>   	}
>   	ioc_state = mpi3mr_get_iocstate(mrioc);
>   	if (ioc_state != MRIOC_STATE_RESET) {
> +		retval = -1;
>   		ioc_err(mrioc, "Cannot bring IOC to reset state\n");
>   		goto out_failed;
>   	}
