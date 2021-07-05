Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE75C07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 07:43:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71B38613AE
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 07:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhGEHpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 03:45:46 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3352 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbhGEHpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 03:45:45 -0400
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GJHXB27Bwz6G7y4;
        Mon,  5 Jul 2021 15:35:06 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 5 Jul 2021 09:43:07 +0200
Received: from [10.47.90.223] (10.47.90.223) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 5 Jul 2021
 08:43:06 +0100
Subject: Re: [PATCH V2 4/6] scsi: set shost->use_managed_irq if driver uses
 managed irq
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-block@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <linux-scsi@vger.kernel.org>
CC:     Sagi Grimberg <sagi@grimberg.me>, Daniel Wagner <dwagner@suse.de>,
        "Wen Xiong" <wenxiong@us.ibm.com>, Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        "Adaptec OEM Raid Solutions" <aacraid@microsemi.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Don Brace <don.brace@microchip.com>,
        "James Smart" <james.smart@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-5-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0dda0d19-8f6d-b231-08f3-6cf594b83352@huawei.com>
Date:   Mon, 5 Jul 2021 08:35:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210702150555.2401722-5-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.90.223]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 02/07/2021 16:05, Ming Lei wrote:
> Set shost->use_managed_irq if irq vectors are allocated via
> pci_alloc_irq_vectors_affinity(PCI_IRQ_AFFINITY) or
> pci_alloc_irq_vectors(PCI_IRQ_AFFINITY).
> 
> The rule is that driver has to tell scsi core if managed irq is used.
> 
> Cc: Adaptec OEM Raid Solutions<aacraid@microsemi.com>
> Cc: Subbu Seetharaman<subbu.seetharaman@broadcom.com>
> Cc: John Garry<john.garry@huawei.com>
> Cc: Don Brace<don.brace@microchip.com>
> Cc: James Smart<james.smart@broadcom.com>
> Cc: Kashyap Desai<kashyap.desai@broadcom.com>
> Cc: Sathya Prakash<sathya.prakash@broadcom.com>
> Cc: Nilesh Javali<njavali@marvell.com>
> Signed-off-by: Ming Lei<ming.lei@redhat.com>
> ---
>   drivers/scsi/aacraid/linit.c              | 3 +++
>   drivers/scsi/be2iscsi/be_main.c           | 3 +++
>   drivers/scsi/csiostor/csio_init.c         | 3 +++
>   drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    | 1 +
>   drivers/scsi/hpsa.c                       | 3 +++
>   drivers/scsi/lpfc/lpfc.h                  | 1 +
>   drivers/scsi/lpfc/lpfc_init.c             | 4 ++++
>   drivers/scsi/megaraid/megaraid_sas_base.c | 3 +++
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c      | 3 +++
>   drivers/scsi/qla2xxx/qla_isr.c            | 5 ++++-
>   drivers/scsi/smartpqi/smartpqi_init.c     | 3 +++
>   11 files changed, 31 insertions(+), 1 deletion(-)

Hi Ming,

hisi sas v2 hw is missed - it supports managed interrupt as a platform 
device. Setting that flag in hisi_sas_v2_interrupt_preinit() might be best.

Thanks,
John
