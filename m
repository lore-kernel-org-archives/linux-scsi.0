Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674C2C43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 09:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D3C20650
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 09:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKLJgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 04:36:16 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2084 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725834AbfKLJgQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 04:36:16 -0500
Received: from LHREML710-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id DF8CDE109FAE75250132;
        Tue, 12 Nov 2019 09:36:14 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML710-CAH.china.huawei.com (10.201.108.33) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 12 Nov 2019 09:36:14 +0000
Received: from [127.0.0.1] (10.202.226.46) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 12 Nov
 2019 09:36:14 +0000
Subject: Re: [PATCH 2/4] scsi: hisi_sas: Return directly if init hardware
 failed
From:   John Garry <john.garry@huawei.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <1573551059-107873-1-git-send-email-john.garry@huawei.com>
 <1573551059-107873-3-git-send-email-john.garry@huawei.com>
Message-ID: <fc7c92a8-fd18-ae61-2ec5-0ad79f4e4fac@huawei.com>
Date:   Tue, 12 Nov 2019 09:36:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1573551059-107873-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.46]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/11/2019 09:30, John Garry wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> Need to return directly if init hardware failed.
> 
> Fixes: 73a4925d154c ("scsi: hisi_sas: Update all the registers after suspend and resume")
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>

I missed my tag here:
Signed-off-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index 2ae7070db41a..b7836406debe 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -3432,6 +3432,7 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
>   	if (rc) {
>   		scsi_remove_host(shost);
>   		pci_disable_device(pdev);
> +		return rc;
>   	}
>   	hisi_hba->hw->phys_init(hisi_hba);
>   	sas_resume_ha(sha);
> 

