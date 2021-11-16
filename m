Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12098C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 12:04:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF62D61A7D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 12:04:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhKPMHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Nov 2021 07:07:12 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26318 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235938AbhKPMFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2021 07:05:03 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Htl0d64YMzbhrv;
        Tue, 16 Nov 2021 19:57:05 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 16 Nov 2021 20:02:00 +0800
Received: from [10.174.179.189] (10.174.179.189) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 16 Nov 2021 20:01:59 +0800
Subject: Re: [PATCH v2] scsi: core: use eh_timeout to timeout start_unit
 command
To:     brookxu <brookxu.cn@gmail.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <hch@infradead.org>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
From:   Wu Bo <wubo40@huawei.com>
Message-ID: <34b23c4f-65b0-4c01-4148-d536732b3aeb@huawei.com>
Date:   Tue, 16 Nov 2021 20:01:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <1636507412-21678-1-git-send-email-brookxu.cn@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.189]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/10 9:23, brookxu wrote:
> From: Chunguang Xu <brookxu@tencent.com>
> 
> In some abnormal scenarios, STU may timeout. The recovery
> time of 30 seconds is relatively large. Now we need to modify
> rq_timeout to adjust STU timeout value, but it will affect the
> actual IO.
> 
> commit 9728c0814ecb ("[SCSI] make scsi_eh_try_stu use block
> timeout") use rq_timeout to timeout the STU command, but after
> commit 0816c9251a71 ("[SCSI] Allow error handling timeout to
> be specified") eh_timeout will init to SCSI_DEFAULT_EH_TIMEOUT,
> so it is more reasonable to use eh_timeout as the timeout value
> of STU command. In this way, we can uniformly control recovery
> time through eh_timeout.
> 
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>
> ---
> v2: Update commit log and fix some format issues.
> 
>   drivers/scsi/scsi_error.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index a531336..a665318 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1404,7 +1404,8 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
>   		enum scsi_disposition rtn = NEEDS_RETRY;
>   
>   		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
> -			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6, scmd->device->request_queue->rq_timeout, 0);
> +			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
> +						scmd->device->eh_timeout, 0);
>   
>   		if (rtn == SUCCESS)
>   			return 0;
> 

Reviewed-by: Wu Bo <wubo40@huawei.com>

-- 
Wu Bo
