Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FF6C47097
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D632221E2
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgHFGyA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 02:54:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57122 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728064AbgHFGx7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Aug 2020 02:53:59 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0C51E3CCD050DB735DEF;
        Thu,  6 Aug 2020 14:53:57 +0800 (CST)
Received: from [10.174.179.105] (10.174.179.105) by smtp.huawei.com
 (10.3.19.213) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 6 Aug 2020
 14:53:54 +0800
Subject: Re: [PATCH] scsi: ufs: ti-j721e-ufs: Fix error return in
 ti_j721e_ufs_probe()
To:     <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <vigneshr@ti.com>
References: <20200806064416.64462-1-jingxiangfeng@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
Message-ID: <5F2BA901.3060206@huawei.com>
Date:   Thu, 6 Aug 2020 14:53:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20200806064416.64462-1-jingxiangfeng@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.105]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please ignore this patch.
	Thanks

On 2020/8/6 14:44, Jing Xiangfeng wrote:
> Fix to return error code IS_ERR() from the error handling case instead
> of 0.
>
> Fixes: 22617e216331 ("scsi: ufs: ti-j721e-ufs: Fix unwinding of pm_runtime changes")
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
> ---
>   drivers/scsi/ufs/ti-j721e-ufs.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/ufs/ti-j721e-ufs.c b/drivers/scsi/ufs/ti-j721e-ufs.c
> index 46bb905b4d6a..eafe7c08b0c8 100644
> --- a/drivers/scsi/ufs/ti-j721e-ufs.c
> +++ b/drivers/scsi/ufs/ti-j721e-ufs.c
> @@ -38,6 +38,7 @@ static int ti_j721e_ufs_probe(struct platform_device *pdev)
>   	/* Select MPHY refclk frequency */
>   	clk = devm_clk_get(dev, NULL);
>   	if (IS_ERR(clk)) {
> +		ret = IS_ERR(clk);
>   		dev_err(dev, "Cannot claim MPHY clock.\n");
>   		goto clk_err;
>   	}
>
