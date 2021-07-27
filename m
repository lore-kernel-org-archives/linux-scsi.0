Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EAD8C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 08:48:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ED606124D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 08:48:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235992AbhG0Isq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 04:48:46 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3497 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235923AbhG0Isp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 04:48:45 -0400
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GYqnd4nCDz6GDBf;
        Tue, 27 Jul 2021 16:33:41 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 10:48:44 +0200
Received: from [10.47.80.220] (10.47.80.220) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 27 Jul
 2021 09:48:43 +0100
Subject: Re: [PATCH v2] scsi: Fix the issue that the disk capacity set to zero
To:     <lijinlin3@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <bvanassche@acm.org>, <yanaijie@huawei.com>,
        <linfeilong@huawei.com>, <wubo40@huawei.com>
References: <20210727034455.1494960-1-lijinlin3@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <21370ef0-88c0-e0b7-6099-4e3ee7af502f@huawei.com>
Date:   Tue, 27 Jul 2021 09:48:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210727034455.1494960-1-lijinlin3@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.220]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/07/2021 04:44, lijinlin3@huawei.com wrote:
> From: lijinlin <lijinlin3@huawei.com>
> 
> After add physical volumes to a volume group through vgextend, kernel
> will rescan partitions, which will read the capacity of the device.
> If the device status is set to offline through sysfs at this time,
> read capacity command will return a result which the host byte is
> DID_NO_CONNECT, the capacity of the device will be set to zero in
> read_capacity_error(). However, the capacity of the device can't be
> reread after reset the device status to running, is still zero.
> 
> Fix this issue by rescan device when the device state changes to
> SDEV_RUNNING.
> 
> Signed-off-by: lijinlin <lijinlin3@huawei.com>
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>   drivers/scsi/scsi_sysfs.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 32489d25158f..ae9bfc658203 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -807,11 +807,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>   	mutex_lock(&sdev->state_mutex);
>   	ret = scsi_device_set_state(sdev, state);
>   	/*
> -	 * If the device state changes to SDEV_RUNNING, we need to run
> -	 * the queue to avoid I/O hang.
> +	 * If the device state changes to SDEV_RUNNING, we need to
> +	 * rescan the device to revalidate it, and run the queue to
> +	 * avoid I/O hang.
>   	 */
> -	if (ret == 0 && state == SDEV_RUNNING)
> +	if (ret == 0 && state == SDEV_RUNNING) {
> +		scsi_rescan_device(dev);
>   		blk_mq_run_hw_queues(sdev->request_queue, true);

I am wondering does any of this need to be done with the device state 
mutex held?

Thanks,
John

> +	}
>   	mutex_unlock(&sdev->state_mutex);
>   
>   	return ret == 0 ? count : -EINVAL;
> 

