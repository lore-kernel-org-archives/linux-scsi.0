Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89522C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 08:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiKII37 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 03:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKII3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 03:29:42 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E2728B;
        Wed,  9 Nov 2022 00:28:53 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N6dQt37Fvz15MQX;
        Wed,  9 Nov 2022 16:28:38 +0800 (CST)
Received: from [10.169.59.127] (10.169.59.127) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 16:28:50 +0800
Subject: Re: [PATCH 3/3] nvme: Convert NVMe errors to PT_STS errors
To:     Mike Christie <michael.christie@oracle.com>, <kbusch@kernel.org>,
        <axboe@fb.com>, <hch@lst.de>, <sagi@grimberg.me>,
        <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-block@vger.kernel.org>
References: <20221109031106.201324-1-michael.christie@oracle.com>
 <20221109031106.201324-4-michael.christie@oracle.com>
From:   Chao Leng <lengchao@huawei.com>
Message-ID: <9df9d0cf-5583-ccfd-ffd7-54432767fdfb@huawei.com>
Date:   Wed, 9 Nov 2022 16:28:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20221109031106.201324-4-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.169.59.127]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2022/11/9 11:11, Mike Christie wrote:
> This converts the NVMe errors we could see during PR handling to PT_STS
> errors, so pr_ops callers can handle scsi and nvme errors without knowing
> the device types.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/nvme/host/core.c | 42 ++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 40 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index dc4220600585..8f0177045a2f 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -2104,11 +2104,43 @@ static int nvme_send_ns_pr_command(struct nvme_ns *ns, struct nvme_command *c,
>   	return nvme_submit_sync_cmd(ns->queue, c, data, 16);
>   }
>   
> +static enum pr_status nvme_sc_to_pr_status(int nvme_sc)
> +{
> +	enum pr_status sts;
> +
> +	switch (nvme_sc) {
> +	case NVME_SC_SUCCESS:
> +		sts = PR_STS_SUCCESS;
> +		break;
> +	case NVME_SC_RESERVATION_CONFLICT:
> +		sts = PR_STS_RESERVATION_CONFLICT;
> +		break;
> +	case NVME_SC_HOST_PATH_ERROR:
> +		sts = PR_STS_PATH_FAILED;
All path-related errors should be considered.
