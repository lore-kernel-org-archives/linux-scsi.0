Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E397EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Jan 2022 10:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiADKCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Jan 2022 05:02:43 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4331 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiADKCn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2022 05:02:43 -0500
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JSp2P2qdDz67t3s;
        Tue,  4 Jan 2022 17:57:49 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.20; Tue, 4 Jan 2022 11:02:40 +0100
Received: from [10.47.27.56] (10.47.27.56) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Tue, 4 Jan
 2022 10:02:39 +0000
Subject: Re: [PATCH v2 05/15] scsi: hisi_sas: Fix some issues related to
 asd_sas_port->phy_list
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "colin.i.king@gmail.com" <colin.i.king@gmail.com>
References: <1639999298-244569-1-git-send-email-chenxiang66@hisilicon.com>
 <1639999298-244569-6-git-send-email-chenxiang66@hisilicon.com>
 <Ycn3FoW9eOZNFMiL@archlinux-ax161>
 <3d20171c-f5ac-d01e-9f0e-ba51835d68f0@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <1aae302f-08d9-87e8-6e0f-4b146de8d9c9@huawei.com>
Date:   Tue, 4 Jan 2022 10:02:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <3d20171c-f5ac-d01e-9f0e-ba51835d68f0@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.27.56]
X-ClientProxiedBy: lhreml736-chm.china.huawei.com (10.201.108.87) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> 
> @Martin and @John Garry, could you have a review and consider to merge
> following patch ?

This series has not made it to Martin's 5.17 queue, but I suggest that 
you send it as a patch in case it does.

> 
> From: Xiang Chen <chenxiang66@hisilicon.com>
> Date: Tue, 28 Dec 2021 09:40:01 +0800
> Subject: [PATCH] scsi: libsas: Remove unused variable and check in function
>    hisi_sas_send_ata_reset_each_phy()

please try to condense these subjects, like just "Remove broken legacy 
code in hisi_sas_send_ata_reset_each_phy()"

Or at least remove "function", as this is obvious

> 
> In commit 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to
> asd_sas_port->phy_list"), we use asd_sas_port->phy_mask instead of
> accessing asd_sas_port->phy_list, and it is enough to use
> asd_sas_port->phy_mask to check the state of phy, so removing the

/s/removing/remove/

> old and unused check.
> 
> Fixes: 29e2bac87421 ("scsi: hisi_sas: Fix some issues related to
> asd_sas_port->phy_list")
> Reported-by: Nathan Chancellor <nathan@kernel.org>

Colin King also reported this, so please add him.

> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>    drivers/scsi/hisi_sas/hisi_sas_main.c | 5 -----
>    1 file changed, 5 deletions(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c
> b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index f46f679fe825..a05ec7aece5a 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -1525,16 +1525,11 @@ static void
> hisi_sas_send_ata_reset_each_phy(struct hisi_hba *hisi_hba,
>           struct device *dev = hisi_hba->dev;
>           int s = sizeof(struct host_to_dev_fis);
>           int rc = TMF_RESP_FUNC_FAILED;
> -       struct asd_sas_phy *sas_phy;
>           struct ata_link *link;
>           u8 fis[20] = {0};
> -       u32 state;
>           int i;
> 
> -       state = hisi_hba->hw->get_phys_state(hisi_hba);
>           for (i = 0; i < hisi_hba->n_phy; i++) {
> -               if (!(state & BIT(sas_phy->id)))
> -                       continue;
>                   if (!(sas_port->phy_mask & BIT(i)))
>                           continue;
> 
> --
> 2.33.0
> 
> 
> 

