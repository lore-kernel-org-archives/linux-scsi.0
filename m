Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FE3C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 23:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8856B64FC6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 23:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhCJXBw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Mar 2021 18:01:52 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2683 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhCJXBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Mar 2021 18:01:40 -0500
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DwnVH1wH1z67sKs;
        Thu, 11 Mar 2021 06:55:35 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 11 Mar 2021 00:01:34 +0100
Received: from [10.47.10.26] (10.47.10.26) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 10 Mar
 2021 23:01:33 +0000
Subject: Re: [PATCH V4 01/31] smartpqi: use host wide tagspace
To:     Don Brace <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
References: <161540568064.19430.11157730901022265360.stgit@brunhilda>
 <161540645071.19430.854884194228600277.stgit@brunhilda>
From:   John Garry <john.garry@huawei.com>
Message-ID: <df5ccaba-fb70-e2f8-2cd1-8e3b4e299aa5@huawei.com>
Date:   Wed, 10 Mar 2021 22:59:31 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <161540645071.19430.854884194228600277.stgit@brunhilda>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.10.26]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/03/2021 20:00, Don Brace wrote:
> Correct scsi-mid-layer sending more requests than
> exposed host Q depth causing firmware ASSERT and lockup
> issue by enabling host wide tags and setting nr_hw_queues
> to 1.
> 
> Note: this also results in better performance.
> 
> Suggested-by: Ming Lei <ming.lei@redhat.com>
> Suggested-by: John Gary <john.gary@huawei.com>

misspelled name

> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index c53f456fbd09..c154e4578e55 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6598,7 +6598,8 @@ static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
>   	shost->transportt = pqi_sas_transport_template;
>   	shost->irq = pci_irq_vector(ctrl_info->pci_dev, 0);
>   	shost->unique_id = shost->irq;
> -	shost->nr_hw_queues = ctrl_info->num_queue_groups;
> +	shost->nr_hw_queues = 1;
> +	shost->host_tagset = 1;

If nr_hw_queues = 1, then there is no point in setting host_tagset.

Apart from that, I'm concerned with the issue mentioned here:

https://lore.kernel.org/linux-scsi/4bff6232-6abd-dae8-c240-07a1a40178bf@huawei.com/

Thanks,
John

>   	shost->hostdata[0] = (unsigned long)ctrl_info;
>   
>   	rc = scsi_add_host(shost, &ctrl_info->pci_dev->dev);
> 
> .
> 

