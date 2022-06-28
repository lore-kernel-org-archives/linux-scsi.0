Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D38AC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 15:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347664AbiF1PCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347631AbiF1PCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 11:02:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60B033E38
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 08:02:41 -0700 (PDT)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXSQk4JTRz6H77H;
        Tue, 28 Jun 2022 22:58:38 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 17:02:39 +0200
Received: from [10.126.170.25] (10.126.170.25) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 16:02:39 +0100
Message-ID: <11cc137e-2b3e-2f0d-4aa8-b54ac49ad8e3@huawei.com>
Date:   Tue, 28 Jun 2022 16:02:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 1/2] mpi3mr: Enable shared host tagset
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        <linux-scsi@vger.kernel.org>
CC:     <martin.petersen@oracle.com>
References: <20220628074848.5036-1-sreekanth.reddy@broadcom.com>
 <20220628074848.5036-2-sreekanth.reddy@broadcom.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220628074848.5036-2-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.170.25]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/06/2022 08:48, Sreekanth Reddy wrote:
> Enable shared host tagset to make sure that total outstanding
> IOs count won't cross controller's can_queue.
> 
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
>   drivers/scsi/mpi3mr/mpi3mr_os.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index d8c195b..da85eda 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4321,6 +4321,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	shost->max_channel = 0;
>   	shost->max_id = 0xFFFFFFFF;
>   
> +	shost->host_tagset = 1;
> +

nit: any reason not to set the flag in the scsi_host_template instead?

>   	if (prot_mask >= 0)
>   		scsi_host_set_prot(shost, prot_mask);
>   	else {

