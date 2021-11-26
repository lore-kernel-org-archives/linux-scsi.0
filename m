Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AB6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 02:49:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359316AbhKZCwV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 21:52:21 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:15872 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358571AbhKZCuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Nov 2021 21:50:19 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J0fJq1krVz91Fy;
        Fri, 26 Nov 2021 10:46:35 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Fri, 26
 Nov 2021 10:47:03 +0800
Subject: Re: [PATCH 01/15] scsi: allocate host device
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-2-hare@suse.de>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <3e3eb96b-ad89-41a3-f915-4855695f1b77@hisilicon.com>
Date:   Fri, 26 Nov 2021 10:47:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20211125151048.103910-2-hare@suse.de>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,


ÔÚ 2021/11/25 23:10, Hannes Reinecke Ð´µÀ:
> Add a flag 'alloc_host_dev' to the SCSI host template and allocate
> a virtual scsi device if the flag is set.
> This device has the SCSI id <max_id + 1>:0, so won't clash with any
> devices the HBA might allocate. It's also excluded from scanning and
> will not show up in sysfs.
> Intention is to use this device to send internal commands to the HBA.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/hosts.c       |  8 +++++
>   drivers/scsi/scsi_scan.c   | 67 +++++++++++++++++++++++++++++++++++++-
>   drivers/scsi/scsi_sysfs.c  |  3 +-
>   include/scsi/scsi_device.h |  2 +-
>   include/scsi/scsi_host.h   | 21 ++++++++++++
>   5 files changed, 98 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index f69b77cbf538..a539fa2fb221 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -290,6 +290,14 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	if (error)
>   		goto out_del_dev;
>   
> +	if (sht->alloc_host_sdev) {
> +		shost->shost_sdev = scsi_get_host_dev(shost);
> +		if (!shost->shost_sdev) {
> +			error = -ENOMEM;
> +			goto out_del_dev;
> +		}
> +	}
> +
>   	scsi_proc_host_add(shost);
>   	scsi_autopm_put_host(shost);
>   	return error;
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 328c0e79dfe7..e2910aa02a65 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1139,6 +1139,12 @@ static int scsi_probe_and_add_lun(struct scsi_target *starget,
>   	if (!sdev)
>   		goto out;
>   
> +	if (scsi_device_is_host_dev(sdev)) {
> +		if (bflagsp)
> +			*bflagsp = BLIST_NOLUN;
> +		return SCSI_SCAN_LUN_PRESENT;
> +	}
> +
>   	result = kmalloc(result_len, GFP_KERNEL);
>   	if (!result)
>   		goto out_free_sdev;
> @@ -1755,6 +1761,9 @@ static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>   		/* If device is already visible, skip adding it to sysfs */
>   		if (sdev->is_visible)
>   			continue;
> +		/* Host devices should never be visible in sysfs */
> +		if (scsi_device_is_host_dev(sdev))
> +			continue;
>   		if (!scsi_host_scan_allowed(shost) ||
>   		    scsi_sysfs_add_sdev(sdev) != 0)
>   			__scsi_remove_device(sdev);
> @@ -1919,12 +1928,16 @@ EXPORT_SYMBOL(scsi_scan_host);
>   
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
> +			continue;
> +		}
>   		if (sdev->sdev_state == SDEV_DEL)
>   			continue;
>   		spin_unlock_irqrestore(shost->host_lock, flags);
> @@ -1932,5 +1945,57 @@ void scsi_forget_host(struct Scsi_Host *shost)
>   		goto restart;
>   	}
>   	spin_unlock_irqrestore(shost->host_lock, flags);
> +	/* Remove host device last, might be needed to send commands */
> +	if (host_sdev)
> +		__scsi_remove_device(host_sdev);
>   }
>   
> +/**
> + * scsi_get_host_dev - Create a virtual scsi_device to the host adapter
> + * @shost: Host that needs a scsi_device
> + *
> + * Lock status: None assumed.
> + *
> + * Returns:     The scsi_device or NULL
> + *
> + * Notes:
> + *	Attach a single scsi_device to the Scsi_Host. The primary aim
> + *	for this device is to serve as a container from which valid
> + *	scsi commands can be allocated from. Each scsi command will carry
> + *	an unused/free command tag, which then can be used by the LLDD to
> + *	send internal or passthrough commands without having to find a
> + *	valid command tag internally.
> + */
> +struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
> +{
> +	struct scsi_device *sdev = NULL;
> +	struct scsi_target *starget;
> +
> +	mutex_lock(&shost->scan_mutex);
> +	if (!scsi_host_scan_allowed(shost))
> +		goto out;
> +	starget = scsi_alloc_target(&shost->shost_gendev, 0,
> +				    shost->max_id);
> +	if (!starget)
> +		goto out;
> +
> +	sdev = scsi_alloc_sdev(starget, 0, NULL);
> +	if (sdev)
> +		sdev->borken = 0;
> +	else
> +		scsi_target_reap(starget);

Currently many scsi drivers fill some interfaces such as 
target_alloc()/slave_alloc() for real disks.
When allocating scsi target and scsi device for host dev, it will also 
call those interfaces, and not sure whether it breaks those drivers.
 From function sas_target_alloc() (common interface in libsas layer), it 
seems break it as there is no sas_rphy for host dev.



