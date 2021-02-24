Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC3BC433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 14:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 132B664F14
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 14:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbhBXOcc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 09:32:32 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2602 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbhBXNO5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 08:14:57 -0500
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Dlx7b0N1dz67rLs;
        Wed, 24 Feb 2021 21:08:43 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Feb 2021 14:14:10 +0100
Received: from [10.47.6.193] (10.47.6.193) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 24 Feb
 2021 13:14:09 +0000
Subject: Re: [PATCH 08/31] scsi: revamp host device handling
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-9-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <f612cac5-6dce-45af-1a9e-da32ddbeaa54@huawei.com>
Date:   Wed, 24 Feb 2021 13:12:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210222132405.91369-9-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.6.193]
X-ClientProxiedBy: lhreml723-chm.china.huawei.com (10.201.108.74) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2021 13:23, Hannes Reinecke wrote:
>   void scsi_forget_host(struct Scsi_Host *shost)
>   {
> -	struct scsi_device *sdev;
> +	struct scsi_device *sdev, *host_sdev = NULL;
>   	unsigned long flags;
>   
>    restart:
>   	spin_lock_irqsave(shost->host_lock, flags);
>   	list_for_each_entry(sdev, &shost->__devices, siblings) {
> +		if (scsi_device_is_host_dev(sdev)) {
> +			host_sdev = sdev;

Is there actually a limit of 1x host_sdev always?

> +			continue;
> +		}
>   		if (sdev->sdev_state == SDEV_DEL)
>   			continue;
>   		spin_unlock_irqrestore(shost->host_lock, flags);
> @@ -1889,10 +1905,13 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   		goto restart;
>   	}
>   	spin_unlock_irqrestore(shost->host_lock, flags);
> +	/* Remove host device last, might be needed to send commands */
> +	if (host_sdev)
> +		__scsi_remove_device(host_sdev);
>   }

