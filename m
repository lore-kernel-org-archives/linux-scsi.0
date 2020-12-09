Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29444C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC70122BF3
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732844AbgLIRj0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:39:26 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2236 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732053AbgLIRjZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:39:25 -0500
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4CrkkC2Gbfz67Mb9;
        Thu, 10 Dec 2020 01:36:35 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 9 Dec 2020 18:38:41 +0100
Received: from [10.210.171.175] (10.210.171.175) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 9 Dec 2020 17:38:40 +0000
Subject: Re: [PATCH v2 1/1] hisi_sas: Fix possible buffer overflows in
 prep_ssp_v3_hw
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20201209124818.25122-1-ruc_zhangxiaohui@163.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <87979504-6540-6b38-88df-938390ae5d3c@huawei.com>
Date:   Wed, 9 Dec 2020 17:38:05 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20201209124818.25122-1-ruc_zhangxiaohui@163.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.175]
X-ClientProxiedBy: lhreml738-chm.china.huawei.com (10.201.108.188) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2020 12:48, Xiaohui Zhang wrote:
> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> 
> prep_ssp_v3_hw() calls memcpy() without checking the destination
> size may trigger a buffer overflower.
> 
> buf_cmd should be a ssp_tmf_iu struct through the analysis of

hmmm... but you change the !tmf path.

> the command below:
> buf_cmd = hisi_sas_cmd_hdr_addr_mem(slot) +
>          sizeof(struct ssp_frame_hdr);
> 
> Then buf_cmd + 12 should point to tag, so the length parameter
> of memcpy() should not exceed sizeof(__be16)+sizeof(u8)*14):
> struct ssp_tmf_iu {
>      u8     lun[8];
>      u16    _r_a;
>      u8     tmf;
>      u8     _r_b;
>      __be16 tag;
>      u8     _r_c[14];
> } __attribute__ ((packed));
> 
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 7133ca859..d02831c17 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -1267,7 +1267,9 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
>   	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
>   	if (!tmf) {
>   		buf_cmd[9] = ssp_task->task_attr | (ssp_task->task_prio << 3);
> -		memcpy(buf_cmd + 12, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
> +		memcpy(buf_cmd + 12, scsi_cmnd->cmnd,
> +		       min_t(unsigned short, scsi_cmnd->cmd_len,
> +			     sizeof(__be16) + sizeof(u8) * 14));

Again, this is not the right thing to do, and I don't think that this 
code needs fixing at all.

There should be a contract already that the driver is not sent cdb len > 
16, and this is sizeof(ssp_command_iu.cdb).

And, if we were sent too much data, then we would/should error.

Thanks,
John
