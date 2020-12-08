Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD190C2BB48
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 18:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A5D023BC8
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 18:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbgLHSL4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 13:11:56 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2226 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730456AbgLHSLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 13:11:55 -0500
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Cr7Tf5QqNz67Nc1;
        Wed,  9 Dec 2020 02:08:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 8 Dec 2020 19:11:13 +0100
Received: from [10.210.169.98] (10.210.169.98) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 8 Dec 2020 18:11:12 +0000
Subject: Re: [PATCH 1/1] hisi_sas: Fix possible buffer overflows in
 prep_ssp_v3_hw
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201208164011.13866-1-ruc_zhangxiaohui@163.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <07831891-58ab-1147-e5b0-a62cca243769@huawei.com>
Date:   Tue, 8 Dec 2020 18:10:37 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20201208164011.13866-1-ruc_zhangxiaohui@163.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.169.98]
X-ClientProxiedBy: lhreml719-chm.china.huawei.com (10.201.108.70) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/12/2020 16:40, Xiaohui Zhang wrote:
> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> 
> prep_ssp_v3_hw() calls memcpy() without checking the
> destination size may trigger a buffer overflower, which a
> local user could use to cause denial of service or the
> execution of arbitrary code.
> Fix it by putting the length check before calling memcpy().
> 
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 7133ca859..2664c36d3 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -1267,7 +1267,8 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
>   	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
>   	if (!tmf) {
>   		buf_cmd[9] = ssp_task->task_attr | (ssp_task->task_prio << 3);
> -		memcpy(buf_cmd + 12, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
> +		memcpy(buf_cmd + 12, scsi_cmnd->cmnd,
> +		       min_t(unsigned short, scsi_cmnd->cmd_len, strlen(buf_cmd)-12));

buf_cmd is not a NULL-terminated string, it's actually a pointer to a 
structure.

And you can see that we set buf_cmd[9] previously (which could set as 
0), so how can you possibly rely on a strlen(buf_cmd) - 12 being sane?

Thanks,
john

>   	} else {
>   		buf_cmd[10] = tmf->tmf;
>   		switch (tmf->tmf) {
> 

