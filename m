Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B441C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 14:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242915AbiBJO2J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:28:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242909AbiBJO2E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 09:28:04 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F3421C
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 06:28:03 -0800 (PST)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JvfGD2f3Pz67P7p;
        Thu, 10 Feb 2022 22:27:16 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 15:28:01 +0100
Received: from [10.202.227.197] (10.202.227.197) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 14:28:00 +0000
Message-ID: <f3606f3e-43ea-8c98-58f7-3572bbbf816c@huawei.com>
Date:   Thu, 10 Feb 2022 14:28:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 20/20] scsi: pm8001: fix abort all task initialization
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
 <20220210114218.632725-21-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220210114218.632725-21-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.197]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2022 11:42, Damien Le Moal wrote:
> In pm80xx_send_abort_all(), the n_elem field of the ccb used is not
> initialized to 0. This missing initialization sometimes lead to the
> task completion path seeing the ccb with a non-zero n_elem resulting in
> the execution of invalid dma_unmap_sg() calls in pm8001_ccb_task_free(),
> causing a crash such as:
> 
> [  197.676341] RIP: 0010:iommu_dma_unmap_sg+0x6d/0x280
> [  197.700204] RSP: 0018:ffff889bbcf89c88 EFLAGS: 00010012
> [  197.705485] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff83d0bda0
> [  197.712687] RDX: 0000000000000002 RSI: 0000000000000000 RDI: ffff88810dffc0d0
> [  197.719887] RBP: 0000000000000000 R08: 0000000000000000 R09: ffff8881c790098b
> [  197.727089] R10: ffffed1038f20131 R11: 0000000000000001 R12: 0000000000000000
> [  197.734296] R13: ffff88810dffc0d0 R14: 0000000000000010 R15: 0000000000000000
> [  197.741493] FS:  0000000000000000(0000) GS:ffff889bbcf80000(0000) knlGS:0000000000000000
> [  197.749659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  197.755459] CR2: 00007f16c1b42734 CR3: 0000000004814000 CR4: 0000000000350ee0
> [  197.762656] Call Trace:
> [  197.765127]  <IRQ>
> [  197.767162]  pm8001_ccb_task_free+0x5f1/0x820 [pm80xx]
> [  197.772364]  ? do_raw_spin_unlock+0x54/0x220
> [  197.776680]  pm8001_mpi_task_abort_resp+0x2ce/0x4f0 [pm80xx]
> [  197.782406]  process_oq+0xe85/0x7890 [pm80xx]
> [  197.786817]  ? lock_acquire+0x194/0x490
> [  197.790697]  ? handle_irq_event+0x10e/0x1b0
> [  197.794920]  ? mpi_sata_completion+0x2d70/0x2d70 [pm80xx]
> [  197.800378]  ? __wake_up_bit+0x100/0x100
> [  197.804340]  ? lock_is_held_type+0x98/0x110
> [  197.808565]  pm80xx_chip_isr+0x94/0x130 [pm80xx]
> [  197.813243]  tasklet_action_common.constprop.0+0x24b/0x2f0
> [  197.818785]  __do_softirq+0x1b5/0x82d
> [  197.822485]  ? do_raw_spin_unlock+0x54/0x220
> [  197.826799]  __irq_exit_rcu+0x17e/0x1e0
> [  197.830678]  irq_exit_rcu+0xa/0x20
> [  197.834114]  common_interrupt+0x78/0x90
> [  197.840051]  </IRQ>
> [  197.844236]  <TASK>
> [  197.848397]  asm_common_interrupt+0x1e/0x40
> 

That's nasty.

> Avoid this issue by always initializing the ccb n_elem field to 0 in
> pm8001_send_abort_all(), pm8001_send_read_log() and
> pm80xx_send_abort_all().
> 
> Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>   drivers/scsi/pm8001/pm8001_hwi.c | 2 ++
>   drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
>   2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 8095eb0b04f7..d853e8d0195a 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1788,6 +1788,7 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>   	ccb->device = pm8001_ha_dev;
>   	ccb->ccb_tag = ccb_tag;
>   	ccb->task = task;
> +	ccb->n_elem = 0;

Do you think that it would be better to clear this field when we free 
the tag/ccb in pm8001_ccb_task_free()? I will note that there are error 
paths whch only free the tag (not ccb), so need to be careful there.

BTW, I see that this never landed:
https://lore.kernel.org/lkml/20211214090337.29156-1-niejianglei2021@163.com/

Though alloc'ing a domain_device in pm8001_send_read_log() is questionable.

Thanks,
John

>   
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   
> @@ -1849,6 +1850,7 @@ static void pm8001_send_read_log(struct pm8001_hba_info *pm8001_ha,
>   	ccb->device = pm8001_ha_dev;
>   	ccb->ccb_tag = ccb_tag;
>   	ccb->task = task;
> +	ccb->n_elem = 0;
>   	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
>   	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
>   
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 4d88c0dbcefc..902af4eefa26 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -1801,6 +1801,7 @@ static void pm80xx_send_abort_all(struct pm8001_hba_info *pm8001_ha,
>   	ccb->device = pm8001_ha_dev;
>   	ccb->ccb_tag = ccb_tag;
>   	ccb->task = task;
> +	ccb->n_elem = 0;
>   
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   

