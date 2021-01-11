Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CA0C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 18:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 118722250E
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 18:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389492AbhAKSXi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 13:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbhAKSXi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 13:23:38 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF01C061786;
        Mon, 11 Jan 2021 10:22:58 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id w1so960339ejf.11;
        Mon, 11 Jan 2021 10:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mzN5bz6gja/X5dov9pXQmFrPtsmh4ja4sEQP9VQaaGg=;
        b=alUB7W1UuzhBjLoGcICmod8MSAAajWbpmzGh9T1xUn34JUoLup1I+GSVAm9WzexkbT
         jbk/NKXpHhz9uv9L42ah4gSrf45f4BoesCxCQ4RkGYKRgYnbg6ajQMxwWXkCQ7ZakTCy
         QLIbOrCnOb4FX1q0BfIVqTR1h4mQ5P7PNGJ+WUb0DCSpwnjF2fBQjUucDnxEZBUg+j+U
         W8WWxcO0HYdp1Cxd3ICCpdSnt70MTlRxqF0IWPCExjlxCT6IaaOOpTdtF9cAoKj2+P73
         vS3G/hlIpBS1uJaV1+QqLlNZuuPauJIBdtdD/nwaw1A7ORyONo/z13tXG23Si7seB8ZP
         5aTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mzN5bz6gja/X5dov9pXQmFrPtsmh4ja4sEQP9VQaaGg=;
        b=OOpK1ksfXowoTmvSRAaEFDDDvLBNX46knRK0+VMRKrIC0ObMcGlUzTA4eLCDLd8P3J
         qvuWvJYozjyDWurfxyk+chzZ2M3+nQYDcZ6GomUdMnYqMnq2H8zapCw4B8JYShQxqerW
         wlv99gJD6OX+9+Y53RHICdOTZM7PXPjjmIZ6gTEBEBk5bKFJRhQSwVNGVmeogdBiXfCv
         o0vPd3ROGb6v6FCxwXl1FFKphoSqKkXCrdY4QJqw7ylnpmQVYRnIcvETCbFUgAJJAzCD
         W7yDFeS7vHl1jPM5/ihZ1rmnvYIW21gtJ4xoDbsoWsiNqBJYi40fElx8gRdc3UeE7Rbc
         SHGA==
X-Gm-Message-State: AOAM531G/kwG7ueWcuBCci0zyidfYQa7/D1Yn5MqJltU+VJcWzL0Dmcf
        ZLu6q9umjXW7vbsT15qzdgAURu42Aak=
X-Google-Smtp-Source: ABdhPJys0oBiETIdWww00NhPjU2FTD1xrVV2d/Ip1plB1NG3CmkcIQhbNGaBIGyVYYtNncUCXnCHxA==
X-Received: by 2002:a17:906:4d59:: with SMTP id b25mr559961ejv.8.1610389376719;
        Mon, 11 Jan 2021 10:22:56 -0800 (PST)
Received: from [192.168.178.40] (ipbcc05d1b.dynamic.kabel-deutschland.de. [188.192.93.27])
        by smtp.gmail.com with ESMTPSA id b19sm298460edx.47.2021.01.11.10.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 10:22:56 -0800 (PST)
Subject: Re: [PATCH] scsi: target: tcmu: Fix wrong uio handling causing big
 memory leak
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bostroesser@gmail.com>
References: <20201218141534.9918-1-bostroesser@gmail.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <703e98c0-31e6-7d3d-c818-d1f071eb552c@gmail.com>
Date:   Mon, 11 Jan 2021 19:22:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201218141534.9918-1-bostroesser@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm sending a gentle ping for the below patch.

Especially I'm wondering whether the way how tcmu_destroy_device()
now 'stops' the uio device is ok. Should we better have something
like uio_stop_device() instead?

Thank you,
Bodo


On 18.12.20 15:15, Bodo Stroesser wrote:
> tcmu calls uio_unregister_device from tcmu_destroy_device.
> After that uio will never call tcmu_release for this device.
> If userspace still had the uio device open and / or mmap'ed
> during uio_unregister_device, tcmu_release will not be called and
> udev->kref will never go down to 0.
> 
> So tcmu in this situation will not free:
>   - cmds or tmrs still in the queue or the ring
>   - all pages allocated for mailbox and cmd_ring (vmalloc)
>   - all pages allocated for data space
>   - the udev itself
> 
> The vmalloc'ed area is 8 MB, amount of pages allocated for data
> space depends on previous usage of the tcmu device. Theoretically
> that can be up to 1GB.
> 
> This patch moves the call of uio_unregister_device to the
> beginning of tcmu_dev_kref_release, which is called when
> udev->kref drops down to zero. So we know, that uio device is
> closed and unmap'ed.
> 
> In case tcmu_realease drops the last kref, we would end up doing
> the uio_unregister_device from a function called by uio_release,
> which causes the process to block forever.
> So we now do the kref_put from new worker function
> tcmu_release_work_fn which is scheduled by tcmu_release.
> 
> To make userspace still aware of the device being deleted,
> tcmu_destroy_device instead of uio_unregister_device now does:
>   - sets a bit in udev, so that tcmu_open and tcmu_mmap can check
>     and fail with -EIO
>   - resets udev->uio_info->irq to 0, so uio will fail read() and
>     write() with -EIO
>   - wakes up userspace possibly waiting in read(), so the read
>     fails with -EIO
> 
> Avoid possible races in tcmu_open by replacing kref_get with
> kref_get_unless_zero.
> 
> Signed-off-by: Bodo Stroesser <bostroesser@gmail.com>
> ---
>   drivers/target/target_core_user.c | 54 ++++++++++++++++++++++++++++++++++++---
>   1 file changed, 50 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 0458bfb143f8..080760985ebf 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -21,6 +21,7 @@
>   #include <linux/configfs.h>
>   #include <linux/mutex.h>
>   #include <linux/workqueue.h>
> +#include <linux/delay.h>
>   #include <net/genetlink.h>
>   #include <scsi/scsi_common.h>
>   #include <scsi/scsi_proto.h>
> @@ -109,6 +110,7 @@ struct tcmu_nl_cmd {
>   struct tcmu_dev {
>   	struct list_head node;
>   	struct kref kref;
> +	struct work_struct release_work;
>   
>   	struct se_device se_dev;
>   
> @@ -119,6 +121,7 @@ struct tcmu_dev {
>   #define TCMU_DEV_BIT_BROKEN 1
>   #define TCMU_DEV_BIT_BLOCKED 2
>   #define TCMU_DEV_BIT_TMR_NOTIFY 3
> +#define TCMU_DEV_BIT_GOING_DOWN 4
>   	unsigned long flags;
>   
>   	struct uio_info uio_info;
> @@ -1527,6 +1530,8 @@ static void tcmu_detach_hba(struct se_hba *hba)
>   	hba->hba_ptr = NULL;
>   }
>   
> +static void tcmu_release_work_fn(struct work_struct *work);
> +
>   static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
>   {
>   	struct tcmu_dev *udev;
> @@ -1542,6 +1547,8 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
>   		return NULL;
>   	}
>   
> +	INIT_WORK(&udev->release_work, tcmu_release_work_fn);
> +
>   	udev->hba = hba;
>   	udev->cmd_time_out = TCMU_TIME_OUT;
>   	udev->qfull_time_out = -1;
> @@ -1719,6 +1726,9 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
>   {
>   	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
>   
> +	if (test_bit(TCMU_DEV_BIT_GOING_DOWN, &udev->flags))
> +		return -EIO;
> +
>   	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
>   	vma->vm_ops = &tcmu_vm_ops;
>   
> @@ -1735,12 +1745,17 @@ static int tcmu_open(struct uio_info *info, struct inode *inode)
>   {
>   	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
>   
> +	if (test_bit(TCMU_DEV_BIT_GOING_DOWN, &udev->flags))
> +		return -EIO;
> +
>   	/* O_EXCL not supported for char devs, so fake it? */
>   	if (test_and_set_bit(TCMU_DEV_BIT_OPEN, &udev->flags))
>   		return -EBUSY;
>   
>   	udev->inode = inode;
> -	kref_get(&udev->kref);
> +	if (!kref_get_unless_zero(&udev->kref))
> +		/* Race between open and device going down */
> +		return -EIO;
>   
>   	pr_debug("open\n");
>   
> @@ -1799,6 +1814,8 @@ static void tcmu_dev_kref_release(struct kref *kref)
>   	bool all_expired = true;
>   	int i;
>   
> +	uio_unregister_device(&udev->uio_info);
> +
>   	vfree(udev->mb_addr);
>   	udev->mb_addr = NULL;
>   
> @@ -1827,6 +1844,15 @@ static void tcmu_dev_kref_release(struct kref *kref)
>   	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
>   }
>   
> +static void tcmu_release_work_fn(struct work_struct *work)
> +{
> +	struct tcmu_dev *udev = container_of(work, struct tcmu_dev,
> +					     release_work);
> +
> +	/* release ref from open */
> +	kref_put(&udev->kref, tcmu_dev_kref_release);
> +}
> +
>   static int tcmu_release(struct uio_info *info, struct inode *inode)
>   {
>   	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
> @@ -1834,8 +1860,17 @@ static int tcmu_release(struct uio_info *info, struct inode *inode)
>   	clear_bit(TCMU_DEV_BIT_OPEN, &udev->flags);
>   
>   	pr_debug("close\n");
> -	/* release ref from open */
> -	kref_put(&udev->kref, tcmu_dev_kref_release);
> +
> +	/*
> +	 * We must not put kref directly from here, since dropping down kref to
> +	 * zero would implicitly call tcmu_dev_kref_release, which calls
> +	 * uio_unregister_device --> process hangs forever, since tcmu_release
> +	 * is called from uio.
> +	 * So we leave it to tcmu_release_work_fn to put the kref.
> +	 */
> +	while (!schedule_work(&udev->release_work))
> +		usleep_range(1000, 5000);
> +
>   	return 0;
>   }
>   
> @@ -2166,7 +2201,18 @@ static void tcmu_destroy_device(struct se_device *dev)
>   
>   	tcmu_send_dev_remove_event(udev);
>   
> -	uio_unregister_device(&udev->uio_info);
> +	/*
> +	 * We must not call uio_unregister_device here. If there is a userspace
> +	 * process with open or mmap'ed uio device, uio would not call
> +	 * tcmu_release on later unmap or close.
> +	 */
> +
> +	/* reset uio_info->irq, so uio will reject read() and write() */
> +	udev->uio_info.irq = 0;
> +	/* Set bit, so we can reject later calls to tcmu_open and tcmu_mmap */
> +	set_bit(TCMU_DEV_BIT_GOING_DOWN, &udev->flags);
> +	/* wake up possible sleeper in uio_read(), it will return -EIO */
> +	uio_event_notify(&udev->uio_info);
>   
>   	/* release ref from configure */
>   	kref_put(&udev->kref, tcmu_dev_kref_release);
> 
