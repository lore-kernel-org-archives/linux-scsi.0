Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B58AC4332D
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 12:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6617064E60
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 12:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbhBWMed (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 07:34:33 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2597 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbhBWMe0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 07:34:26 -0500
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DlJJj3G20z67n9B;
        Tue, 23 Feb 2021 20:29:25 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Feb 2021 13:33:25 +0100
Received: from [10.47.0.222] (10.47.0.222) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 23 Feb
 2021 12:33:24 +0000
Subject: Re: [PATCH 31/31] pm8001: use block-layer tags for ccb allocation
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>,
        "Viswas.G@microchip.com" <Viswas.G@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-32-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <7cb567c8-4ba4-6d77-aa73-c0fdf993223a@huawei.com>
Date:   Tue, 23 Feb 2021 12:31:38 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210222132405.91369-32-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.222]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2021 13:24, Hannes Reinecke wrote:
> @ -4398,9 +4397,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>   	circularQ = &pm8001_ha->inbnd_q_tbl[0];
>   
>   	memset(&payload, 0, sizeof(payload));
> -	rc = pm8001_tag_alloc(pm8001_ha, &tag);
> -	if (rc)
> -		return rc;
> +	tag = pm8001_tag_alloc(pm8001_ha, dev);
> +	if (tag == -1)
> +		return -SAS_QUEUE_FULL;
>   	ccb = &pm8001_ha->ccb_info[tag];
>   	ccb->device = pm8001_dev;
>   	ccb->ccb_tag = tag;
> @@ -4434,6 +4433,8 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
>   		SAS_ADDR_SIZE);
>   	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
>   			sizeof(payload), 0);

So this above code means that we send on queue #0 always.

However, since we hope to use managed interrupt in the future, the 
interrupt for queue may be offline.

That's why I don't like storing a tag in sas_task structure. We already 
can get it elsewhere in the structure.

I would rather get it from sas_task.slow_task in this case, which saves 
the request/scsi_cmd pointer, and we can use blk_mq_unique_tag_to_hwq() 
here to get the tag and queue index.

Thanks,
John

> +	if (rc)
> +		pm8001_tag_free(pm8001_ha, tag);
>   	return rc;
>   }

