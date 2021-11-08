Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7D05C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 01:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CED6B6137F
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 01:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhKHBxs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Nov 2021 20:53:48 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26295 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbhKHBxr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Nov 2021 20:53:47 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HnYqT11b9zbhjw;
        Mon,  8 Nov 2021 09:46:13 +0800 (CST)
Received: from dggpeml500019.china.huawei.com (7.185.36.137) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 09:51:00 +0800
Received: from [10.174.179.189] (10.174.179.189) by
 dggpeml500019.china.huawei.com (7.185.36.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 8 Nov 2021 09:51:00 +0800
Subject: Re: [PATCH 2/2] scsi: Fix hang when device state is set via sysfs
To:     Mike Christie <michael.christie@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>
CC:     Bart Van Assche <bvanassche@acm.org>,
        lijinlin <lijinlin3@huawei.com>
References: <20211105221048.6541-1-michael.christie@oracle.com>
 <20211105221048.6541-3-michael.christie@oracle.com>
From:   Wu Bo <wubo40@huawei.com>
Message-ID: <dbc41361-3370-e51d-6fb4-e8059fdc918d@huawei.com>
Date:   Mon, 8 Nov 2021 09:50:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20211105221048.6541-3-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.189]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500019.china.huawei.com (7.185.36.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/6 6:10, Mike Christie wrote:
> This fixes a regression added with:
> 
> commit f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> offlinining device")
> 
> The problem is that after iSCSI recovery, iscsid will call into the kernel
> to set the dev's state to running, and with that patch we now call
> scsi_rescan_device with the state_mutex held. If the scsi error handler
> thread is just starting to test the device in scsi_send_eh_cmnd then it's
> going to try to grab the state_mutex.
> 
> We are then stuck, because when scsi_rescan_device tries to send its IO
> scsi_queue_rq calls -> scsi_host_queue_ready -> scsi_host_in_recovery
> which will return true (the host state is still in recovery) and IO will
> just be requeued. scsi_send_eh_cmnd will then never be able to grab the
> state_mutex to finish error handling.
> 
> To prevent the deadlock this moves the rescan related code to after we
> drop the state_mutex.
> 
> This also adds a check for if we are already in the running state. This
> prevents extra scans and helps the iscsid case where if the transport
> class has already onlined the device during it's recovery process then we
> don't need userspace to do it again plus possibly block that daemon.
> 
> Fixes: f0f82e2476f6 ("scsi: core: Fix capacity set to zero after
> offlinining device")
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: lijinlin <lijinlin3@huawei.com>
> Cc: Wu Bo <wubo40@huawei.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/scsi_sysfs.c | 30 +++++++++++++++++++-----------
>   1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index a35841b34bfd..53e23a7bc0d3 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -797,6 +797,7 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>   	int i, ret;
>   	struct scsi_device *sdev = to_scsi_device(dev);
>   	enum scsi_device_state state = 0;
> +	bool rescan_dev = false;
>   
>   	for (i = 0; i < ARRAY_SIZE(sdev_states); i++) {
>   		const int len = strlen(sdev_states[i].name);
> @@ -815,20 +816,27 @@ store_state_field(struct device *dev, struct device_attribute *attr,
>   	}
>   
>   	mutex_lock(&sdev->state_mutex);
> -	ret = scsi_device_set_state(sdev, state);
> -	/*
> -	 * If the device state changes to SDEV_RUNNING, we need to
> -	 * run the queue to avoid I/O hang, and rescan the device
> -	 * to revalidate it. Running the queue first is necessary
> -	 * because another thread may be waiting inside
> -	 * blk_mq_freeze_queue_wait() and because that call may be
> -	 * waiting for pending I/O to finish.
> -	 */
> -	if (ret == 0 && state == SDEV_RUNNING) {
> +	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
> +		ret = count;
> +	} else {
> +		ret = scsi_device_set_state(sdev, state);
> +		if (ret == 0 && state == SDEV_RUNNING)
> +			rescan_dev = true;
> +	}
> +	mutex_unlock(&sdev->state_mutex);
> +
> +	if (rescan_dev) {
> +		/*
> +		 * If the device state changes to SDEV_RUNNING, we need to
> +		 * run the queue to avoid I/O hang, and rescan the device
> +		 * to revalidate it. Running the queue first is necessary
> +		 * because another thread may be waiting inside
> +		 * blk_mq_freeze_queue_wait() and because that call may be
> +		 * waiting for pending I/O to finish.
> +		 */
>   		blk_mq_run_hw_queues(sdev->request_queue, true);
>   		scsi_rescan_device(dev);
>   	}
> -	mutex_unlock(&sdev->state_mutex);
>   
>   	return ret == 0 ? count : -EINVAL;
>   }
> 

Reviewed-by: Wu Bo <wubo40@huawei.com>

-- 
Wu Bo
