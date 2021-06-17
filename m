Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55CCAC2B9F4
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 11:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E5BE61419
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 11:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhFQLxD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Jun 2021 07:53:03 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5026 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhFQLxC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jun 2021 07:53:02 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G5Kxp00R6zXfW5;
        Thu, 17 Jun 2021 19:45:49 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 17
 Jun 2021 19:50:52 +0800
Subject: Re: remove ->revalidate_disk (resend)
To:     Christoph Hellwig <hch@lst.de>
References: <20210308074550.422714-1-hch@lst.de>
 <96011dbd-084f-8a07-3506-fc7717122866@hisilicon.com>
 <20210616135015.GA30671@lst.de>
 <709468de-c8fd-0eeb-a3f9-5eb40650034b@hisilicon.com>
 <20210617102936.GA12756@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>, Tim Waugh <tim@cyberelk.net>,
        <martin.petersen@oracle.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <0317ad8f-58e6-012f-e206-fdb5a2503c42@hisilicon.com>
Date:   Thu, 17 Jun 2021 19:50:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20210617102936.GA12756@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,


在 2021/6/17 18:29, Christoph Hellwig 写道:
> Can you try the patch below?

I have tested the patch, and it fixes the issue i reported, and so 
please feel free to add:
Tested-by: Xiang Chen <chenxiang66@hisilicon.com>

>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 5c8b5c5356a3..6d2d63629a90 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1387,6 +1387,22 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
>   	}
>   }
>   
> +static bool sd_need_revalidate(struct block_device *bdev,
> +		struct scsi_disk *sdkp)
> +{
> +	if (sdkp->device->removable || sdkp->write_prot) {
> +		if (bdev_check_media_change(bdev))
> +			return true;
> +	}
> +
> +	/*
> +	 * Force a full rescan after ioctl(BLKRRPART).  While the disk state has
> +	 * nothing to do with partitions, BLKRRPART is used to force a full
> +	 * revalidate after things like a format for historical reasons.
> +	 */
> +	return test_bit(GD_NEED_PART_SCAN, &bdev->bd_disk->state);
> +}
> +
>   /**
>    *	sd_open - open a scsi disk device
>    *	@bdev: Block device of the scsi disk to open
> @@ -1423,10 +1439,8 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
>   	if (!scsi_block_when_processing_errors(sdev))
>   		goto error_out;
>   
> -	if (sdev->removable || sdkp->write_prot) {
> -		if (bdev_check_media_change(bdev))
> -			sd_revalidate_disk(bdev->bd_disk);
> -	}
> +	if (sd_need_revalidate(bdev, sdkp))
> +		sd_revalidate_disk(bdev->bd_disk);
>   
>   	/*
>   	 * If the drive is empty, just let the open fail.
>
> .
>


