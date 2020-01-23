Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B31C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 09:30:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34EA122522
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 09:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgAWJaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 04:30:12 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2295 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725785AbgAWJaM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 04:30:12 -0500
Received: from lhreml707-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 3EA48F20E0576B0CF424;
        Thu, 23 Jan 2020 09:30:10 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml707-cah.china.huawei.com (10.201.108.48) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 23 Jan 2020 09:30:10 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 23 Jan
 2020 09:30:09 +0000
Subject: Re: [PATCH] hisi_sas: Fix unreasonable exit processing of
 hisi_sas_v3_probe
To:     Ye Bin <yebin10@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, chenxiang <chenxiang66@hisilicon.com>
References: <20200123061249.896-1-yebin10@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <cb63adff-de9e-8c5f-ac48-885835896637@huawei.com>
Date:   Thu, 23 Jan 2020 09:30:08 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200123061249.896-1-yebin10@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/01/2020 06:12, Ye Bin wrote:

subject: scsi: hisi_sas: Fix...

/s/unreasonable/broken/

> In this function, the exception return missed some processing.

This is the same as hisi_sas_probe(), so, if this is wrong, then that is 
wrong also, i.e. needs to be fixed.

> 
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 +++++++++++-----
>   1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> index fa05e612d85a..394e20b8f622 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
> @@ -3166,8 +3166,8 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	struct Scsi_Host *shost;
>   	struct hisi_hba *hisi_hba;
>   	struct device *dev = &pdev->dev;
> -	struct asd_sas_phy **arr_phy;
> -	struct asd_sas_port **arr_port;
> +	struct asd_sas_phy **arr_phy = NULL;
> +	struct asd_sas_port **arr_port = NULL;
>   	struct sas_ha_struct *sha;
>   	int rc, phy_nr, port_nr, i;
>   
> @@ -3213,7 +3213,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
>   	if (!arr_phy || !arr_port) {
>   		rc = -ENOMEM;
> -		goto err_out_ha;
> +		goto err_out_iomap;
>   	}
>   
>   	sha->sas_phy = arr_phy;
> @@ -3254,7 +3254,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   	rc = scsi_add_host(shost, dev);
>   	if (rc)
> -		goto err_out_ha;
> +		goto err_out_iomap;
>   
>   	rc = sas_register_ha(sha);
>   	if (rc)
> @@ -3262,14 +3262,20 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   
>   	rc = hisi_hba->hw->hw_init(hisi_hba);
>   	if (rc)
> -		goto err_out_register_ha;
> +		goto err_out_hw_init;
>   
>   	scsi_scan_host(shost);
>   
>   	return 0;
>   
> +err_out_hw_init:
> +	sas_unregister_ha(sha);
>   err_out_register_ha:
>   	scsi_remove_host(shost);
> +err_out_iomap:
> +	devm_kfree(dev, arr_phy);
> +	devm_kfree(dev, arr_port);

why do you need this? Surely these memories will be freed automatically 
for probe failure.

> +	pcim_iounmap(pdev, hisi_hba->regs);

This seems to be missing from hisi_sas_v3_remove() also.

>   err_out_ha:
>   	hisi_sas_debugfs_exit(hisi_hba);
>   	scsi_host_put(shost);
> 


Thanks,
John

