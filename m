Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE705C54E4A
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 08:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B906F20A8B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 08:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729174AbgELIYo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 04:24:44 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2191 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725987AbgELIYo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 04:24:44 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 010C748A63C88A72CE11;
        Tue, 12 May 2020 09:24:43 +0100 (IST)
Received: from [127.0.0.1] (10.210.169.134) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 12 May
 2020 09:24:42 +0100
Subject: Re: [PATCH] scsi: hisi_sas: display correct proc_name in sysfs
To:     Jason Yan <yanaijie@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Xiang Chen <chenxiang66@hisilicon.com>
References: <20200512063318.13825-1-yanaijie@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <66c3318d-e8fa-9ff4-c7f4-ebe23925b807@huawei.com>
Date:   Tue, 12 May 2020 09:23:51 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200512063318.13825-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.169.134]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/05/2020 07:33, Jason Yan wrote:
> The 'proc_name' entry in sysfs for hisi_sas is 'null' now becuase it is
> not initialized in scsi_host_template. It looks like:
> 
> [root@localhost ~]# cat /sys/class/scsi_host/host2/proc_name
> (null)
> 

hmmm.. it would be good to tell us what this buys us, apart from the 
proc_name file.

I mean, if we had the sht show_info method implemented, then it could be 
useful (which is even marked as obsolete now).

Thanks,
John

> While the other driver's entry looks like:
> 
> linux-vnMQMU:~ # cat /sys/class/scsi_host/host0/proc_name
> megaraid_sas
> 
> Cc: John Garry <john.garry@huawei.com>
> Cc: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 1 +
>   drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 1 +
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
>   3 files changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> index fa25766502a2..c205bff20943 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
> @@ -1757,6 +1757,7 @@ static struct device_attribute *host_attrs_v1_hw[] = {
>   
>   static struct scsi_host_template sht_v1_hw = {
>   	.name			= DRV_NAME,
> +	.proc_name		= DRV_NAME,
>   	.module			= THIS_MODULE,
>   	.queuecommand		= sas_queuecommand,
>   	.target_alloc		= sas_target_alloc,
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> index e05faf315dcd..c725cffe141e 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
> @@ -3533,6 +3533,7 @@ static struct device_attribute *host_attrs_v2_hw[] = {
>   
>   static struct scsi_host_template sht_v2_hw = {
>   	.name			= DRV_NAME,
> +	.proc_name		= DRV_NAME,
>   	.module			= THIS_MODULE,
>   	.queuecommand		= sas_queuecommand,
>   	.target_alloc		= sas_target_alloc,
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 374885aa8d77..59b1421607dd 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -3071,6 +3071,7 @@ static int debugfs_set_bist_v3_hw(struct hisi_hba *hisi_hba, bool enable)
>   
>   static struct scsi_host_template sht_v3_hw = {
>   	.name			= DRV_NAME,
> +	.proc_name		= DRV_NAME,
>   	.module			= THIS_MODULE,
>   	.queuecommand		= sas_queuecommand,
>   	.target_alloc		= sas_target_alloc,
> 

