Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14B4ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 09:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbiINJyc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 05:54:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiINJyF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 05:54:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EE0696F2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 02:53:21 -0700 (PDT)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MSFwS0y0lz67y6K;
        Wed, 14 Sep 2022 17:51:36 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 14 Sep 2022 11:52:58 +0200
Received: from [10.48.151.55] (10.48.151.55) by lhrpeml500003.china.huawei.com
 (7.191.162.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 14 Sep
 2022 10:52:57 +0100
Message-ID: <011da034-b67a-c232-ebe0-d6d7d802247f@huawei.com>
Date:   Wed, 14 Sep 2022 10:52:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 4/4] scsi: core: Rework the code for dropping the LLD
 module reference
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220913195716.3966875-1-bvanassche@acm.org>
 <20220913195716.3966875-5-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220913195716.3966875-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.151.55]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 13/09/2022 20:57, Bart Van Assche wrote:
> Instead of clearing the host template module pointer if the LLD kernel
> module is being unloaded, set the 'drop_module_ref' SCSI device member.
> This patch prepares for constifying the SCSI host template.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_sysfs.c  | 7 +++----
>   include/scsi/scsi_device.h | 1 +
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 5d61f58399dc..822ae60a64b9 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -454,7 +454,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>   
>   	sdev = container_of(work, struct scsi_device, ew.work);
>   
> -	mod = sdev->host->hostt->module;
> +	mod = sdev->drop_module_ref ? sdev->host->hostt->module : NULL;

I suppose that this works.

My reservation is that there were some concerns of current module 
referencing solution, so may not be better to build directly on it:

https://lore.kernel.org/linux-scsi/Ynt0aFMX+z%2FUhGJ2@infradead.org/

Thanks,
John

>   
>   	scsi_dh_release_device(sdev);
>   
> @@ -525,9 +525,8 @@ static void scsi_device_dev_release(struct device *dev)
>   {
>   	struct scsi_device *sdp = to_scsi_device(dev);
>   
> -	/* Set module pointer as NULL in case of module unloading */
> -	if (!try_module_get(sdp->host->hostt->module))
> -		sdp->host->hostt->module = NULL;
> +	if (try_module_get(sdp->host->hostt->module))
> +		sdp->drop_module_ref = true;
>   
>   	execute_in_process_context(scsi_device_dev_release_usercontext,
>   				   &sdp->ew);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index 2493bd65351a..b03176b69056 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -214,6 +214,7 @@ struct scsi_device {
>   					 * creation time */
>   	unsigned ignore_media_change:1; /* Ignore MEDIA CHANGE on resume */
>   	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
> +	unsigned drop_module_ref:1;
>   
>   	unsigned int queue_stopped;	/* request queue is quiesced */
>   	bool offline_already;		/* Device offline message logged */
> 
> .

