Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28994C433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF5822220F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388589AbhALJFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:05:12 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2310 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727916AbhALJFI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 04:05:08 -0500
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DFPg63dQ9z67Zyp;
        Tue, 12 Jan 2021 17:00:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 10:04:25 +0100
Received: from [10.210.171.61] (10.210.171.61) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 12 Jan 2021 09:04:24 +0000
Subject: Re: [PATCH v2 1/2] scsi: hisi_sas: Remove unnecessary devm_kfree
To:     Bean Huo <huobean@gmail.com>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ebiggers@google.com>,
        <satyat@google.com>, <shipujin.t@gmail.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bean Huo <beanhuo@micron.com>
References: <20210111231058.14559-1-huobean@gmail.com>
 <20210111231058.14559-2-huobean@gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b34eac20-e194-783b-f29e-83eec8bb127c@huawei.com>
Date:   Tue, 12 Jan 2021 09:03:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210111231058.14559-2-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.61]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/01/2021 23:10, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> The memory allocated with devm_kzalloc() is freed automatically
> no need to explicitly call devm_kfree.
> 

This change is not right - we use devm_kfree() to manually release the 
devm-allocated debugfs memories upon memory allocation failure for 
driver debugfs feature during probe. The reason is that we allow the 
driver probe can still continue (for this failure).

Thanks,
John

> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 28 +-------------------------
>   1 file changed, 1 insertion(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 91a7286e8102..5600411a0820 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -4172,30 +4172,6 @@ static void debugfs_work_handler_v3_hw(struct work_struct *work)
>   	hisi_hba->debugfs_dump_index++;
>   }
>   
> -static void debugfs_release_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
> -{
> -	struct device *dev = hisi_hba->dev;
> -	int i;
> -
> -	devm_kfree(dev, hisi_hba->debugfs_iost_cache[dump_index].cache);
> -	devm_kfree(dev, hisi_hba->debugfs_itct_cache[dump_index].cache);
> -	devm_kfree(dev, hisi_hba->debugfs_iost[dump_index].iost);
> -	devm_kfree(dev, hisi_hba->debugfs_itct[dump_index].itct);
> -
> -	for (i = 0; i < hisi_hba->queue_count; i++)
> -		devm_kfree(dev, hisi_hba->debugfs_dq[dump_index][i].hdr);
> -
> -	for (i = 0; i < hisi_hba->queue_count; i++)
> -		devm_kfree(dev,
> -			   hisi_hba->debugfs_cq[dump_index][i].complete_hdr);
> -
> -	for (i = 0; i < DEBUGFS_REGS_NUM; i++)
> -		devm_kfree(dev, hisi_hba->debugfs_regs[dump_index][i].data);
> -
> -	for (i = 0; i < hisi_hba->n_phy; i++)
> -		devm_kfree(dev, hisi_hba->debugfs_port_reg[dump_index][i].data);
> -}
> -
>   static const struct hisi_sas_debugfs_reg *debugfs_reg_array_v3_hw[DEBUGFS_REGS_NUM] = {
>   	[DEBUGFS_GLOBAL] = &debugfs_global_reg,
>   	[DEBUGFS_AXI] = &debugfs_axi_reg,
> @@ -4206,7 +4182,7 @@ static int debugfs_alloc_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
>   {
>   	const struct hisi_sas_hw *hw = hisi_hba->hw;
>   	struct device *dev = hisi_hba->dev;
> -	int p, c, d, r, i;
> +	int p, c, d, r;
>   	size_t sz;
>   
>   	for (r = 0; r < DEBUGFS_REGS_NUM; r++) {
> @@ -4286,8 +4262,6 @@ static int debugfs_alloc_v3_hw(struct hisi_hba *hisi_hba, int dump_index)
>   
>   	return 0;
>   fail:
> -	for (i = 0; i < hisi_sas_debugfs_dump_count; i++)
> -		debugfs_release_v3_hw(hisi_hba, i);
>   	return -ENOMEM;
>   }
>   
> 

