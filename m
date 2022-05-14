Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F275C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 14 May 2022 18:32:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbiENScj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 May 2022 14:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiENSc2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 May 2022 14:32:28 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E25911A10;
        Sat, 14 May 2022 11:32:23 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id g23so13518652edy.13;
        Sat, 14 May 2022 11:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Yt7FB0zHxfhLvTb7PVPDtvVbQoY8E+Re5/wSi3Zsh1w=;
        b=IimC7FsCXqOJ+c2sXD8zdL60yq56V/f0QFLgoTkrxM37RzkuTsMVjYtEtDhXSR1/er
         3dQzYy9u9ruLd6oY8pSjFTQxnsOck8Zu319IbGxNEmbjpkOvElvoZOzw+5Gxmw1yNQ7A
         sqE3HR/7vbKyixOSupBbPzaiiD0RY2XAlBSIqdF/rg+R72KsQYLyXr5IBJBCPA9858Rd
         pVREu3hpL1fuV7vEGuHOhy+uTl0DIMk94letyV5g/qHmXUnM6Ml3DIZeAUtXsO9FBgvk
         W5w3qP0Gq+KZFdrNsMXJztxomuEK/cmn2nPQuonsIUhAUjaYyzHoaD3gBHcQ6guK2cup
         lgbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Yt7FB0zHxfhLvTb7PVPDtvVbQoY8E+Re5/wSi3Zsh1w=;
        b=7S3xf+bg/WtZaISW30FOcdZcL1epv6HcsY/TkCIlwpnoH+PpQqwbIumGt4LSio0I4a
         yb4fpP3IHAx9LPWf7EJKAcsYl7pv1npt7sOSHLUcBRTYq1yNsReW2+82MADxJIzCeJcA
         xN93u89vHVSQdHTepgiwezPzfBL5cYGiVYe1xgDIwIfZuwlm/yY2Q7+wZ7XH9EkD7+zq
         t6wTlbb9iQMES3qvHfoipP8P4Aa18nPaQIsXV5TWxxginz6gVHq+M7N0Bu23D4vfBMOH
         X/TcZLD5yIZBjrUkhJArI71DadNOec6ujDEXgdqHQQx+6m85ZHQ0fju7Yi8VEpDBoHBi
         buCg==
X-Gm-Message-State: AOAM533pJ1VeU08MZUd0BqDSjSMWk6Fd1S6tYbZZ6bu9oNY75ktudVsZ
        VaSWhGNzIj8C0iKvkrbZ+FA=
X-Google-Smtp-Source: ABdhPJxIlFUWtzgdAsAWmYBFbDvz6fMipk5ZWAkWZLKVL6Zho5Qm+COVEBngW/n+ImC7/YG4MkTyXg==
X-Received: by 2002:a05:6402:1941:b0:413:2555:53e3 with SMTP id f1-20020a056402194100b00413255553e3mr5064276edz.164.1652553142045;
        Sat, 14 May 2022 11:32:22 -0700 (PDT)
Received: from [192.168.178.40] ([188.193.207.173])
        by smtp.gmail.com with ESMTPSA id hv6-20020a17090760c600b006f3ef214e3asm1903625ejc.160.2022.05.14.11.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 May 2022 11:32:21 -0700 (PDT)
Message-ID: <fe702260-2aaa-1543-b461-05218683d60e@gmail.com>
Date:   Sat, 14 May 2022 20:32:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3] scsi:tcmu: switch tcmu completion path to work queue
 context
Content-Language: en-US
To:     Guixin Liu <kanie@linux.alibaba.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <1652234931-33290-1-git-send-email-kanie@linux.alibaba.com>
From:   Bodo Stroesser <bostroesser@gmail.com>
In-Reply-To: <1652234931-33290-1-git-send-email-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Liu,

thank you for the patch.

To be honest I'm not sure this is the right way to boost performance.
Since tcmu still uses the cmdr_lock to serialize all work in kernel,
the only effect AFAICS is that userspace returns faster from the
uio_write(). This probably just speeds up userspace if it runs as one
thread only.
Do you also have measurement results for small IOs?

I'd prefer to first finalize and send my patch series that makes tcmu
release cmdr_lock while copying data - in READ direction as well as in
WRITE direction. Using LIO core's completion wq allows to do multiple
data copies in both direction in parallel, if the fabric allows to
handle multiple incoming WRITES in parallel.

With that series in place it would be good to have another try with
your change. I)f it still can boost throughput, I'll be happy to
accept it.

Bodo


On 11.05.22 04:08, Guixin Liu wrote:
> Currently, tcmu do completion in uio_write context, the userspace
> will wait tcmu complete synchronously, switch completion path to
> work queue context for better performance.
> 
> Use tcmu + file to evaluate performance,
> fio job: fio -filename=/dev/sdb  -direct=1 -size=2G -name=1 -thread
> -runtime=60 -time_based  -rw=randwrite -numjobs=16 -iodepth=16 -bs=128k
> 
> Without this patch:
> 	READ: bw=2775MiB/s (2910MB/s), 173MiB/s-174MiB/s
> (181MB/s-183MB/s), io=163GiB (175GB), run=60001-60001msec
> 
> With this patch:
> 	READ: bw=3333MiB/s (3495MB/s), 208MiB/s-209MiB/s
> (218MB/s-219MB/s), io=195GiB (210GB), run=60001-60001msec
> 
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
> ---
>   drivers/target/target_core_user.c | 155 +++++++++++++++++++++-----------------
>   1 file changed, 87 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index fd7267b..6fd514d99 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -168,6 +168,8 @@ struct tcmu_dev {
>   	char dev_config[TCMU_CONFIG_LEN];
>   
>   	int nl_reply_supported;
> +
> +	struct work_struct complete_work;
>   };
>   
>   #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
> @@ -223,6 +225,7 @@ struct tcmu_tmr {
>   
>   static atomic_t global_page_count = ATOMIC_INIT(0);
>   static struct delayed_work tcmu_unmap_work;
> +static struct workqueue_struct *tcmu_comp_wq;
>   static int tcmu_global_max_pages = TCMU_GLOBAL_MAX_PAGES_DEF;
>   
>   static int tcmu_set_global_max_data_area(const char *str,
> @@ -1596,6 +1599,76 @@ static void tcmu_detach_hba(struct se_hba *hba)
>   	hba->hba_ptr = NULL;
>   }
>   
> +static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
> +{
> +	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
> +	LIST_HEAD(cmds);
> +	sense_reason_t scsi_ret;
> +	int ret;
> +
> +	if (list_empty(&udev->qfull_queue))
> +		return;
> +
> +	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
> +
> +	list_splice_init(&udev->qfull_queue, &cmds);
> +
> +	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, queue_entry) {
> +		list_del_init(&tcmu_cmd->queue_entry);
> +
> +		pr_debug("removing cmd %p on dev %s from queue\n",
> +			 tcmu_cmd, udev->name);
> +
> +		if (fail) {
> +			/*
> +			 * We were not able to even start the command, so
> +			 * fail with busy to allow a retry in case runner
> +			 * was only temporarily down. If the device is being
> +			 * removed then LIO core will do the right thing and
> +			 * fail the retry.
> +			 */
> +			tcmu_cmd->se_cmd->priv = NULL;
> +			target_complete_cmd(tcmu_cmd->se_cmd, SAM_STAT_BUSY);
> +			tcmu_free_cmd(tcmu_cmd);
> +			continue;
> +		}
> +
> +		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
> +		if (ret < 0) {
> +			pr_debug("cmd %p on dev %s failed with %u\n",
> +				 tcmu_cmd, udev->name, scsi_ret);
> +			/*
> +			 * Ignore scsi_ret for now. target_complete_cmd
> +			 * drops it.
> +			 */
> +			tcmu_cmd->se_cmd->priv = NULL;
> +			target_complete_cmd(tcmu_cmd->se_cmd,
> +					    SAM_STAT_CHECK_CONDITION);
> +			tcmu_free_cmd(tcmu_cmd);
> +		} else if (ret > 0) {
> +			pr_debug("ran out of space during cmdr queue run\n");
> +			/*
> +			 * cmd was requeued, so just put all cmds back in
> +			 * the queue
> +			 */
> +			list_splice_tail(&cmds, &udev->qfull_queue);
> +			break;
> +		}
> +	}
> +
> +	tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
> +}
> +
> +static void tcmu_complete_work(struct work_struct *work)
> +{
> +	struct tcmu_dev *udev = container_of(work, struct tcmu_dev, complete_work);
> +
> +	mutex_lock(&udev->cmdr_lock);
> +	if (tcmu_handle_completions(udev))
> +		run_qfull_queue(udev, false);
> +	mutex_unlock(&udev->cmdr_lock);
> +}
> +
>   static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
>   {
>   	struct tcmu_dev *udev;
> @@ -1634,6 +1707,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
>   
>   	xa_init(&udev->data_pages);
>   
> +	INIT_WORK(&udev->complete_work, tcmu_complete_work);
>   	return &udev->se_dev;
>   }
>   
> @@ -1725,75 +1799,10 @@ static void tcmu_dev_kref_release(struct kref *kref)
>   	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
>   }
>   
> -static void run_qfull_queue(struct tcmu_dev *udev, bool fail)
> -{
> -	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
> -	LIST_HEAD(cmds);
> -	sense_reason_t scsi_ret;
> -	int ret;
> -
> -	if (list_empty(&udev->qfull_queue))
> -		return;
> -
> -	pr_debug("running %s's cmdr queue forcefail %d\n", udev->name, fail);
> -
> -	list_splice_init(&udev->qfull_queue, &cmds);
> -
> -	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, queue_entry) {
> -		list_del_init(&tcmu_cmd->queue_entry);
> -
> -		pr_debug("removing cmd %p on dev %s from queue\n",
> -			 tcmu_cmd, udev->name);
> -
> -		if (fail) {
> -			/*
> -			 * We were not able to even start the command, so
> -			 * fail with busy to allow a retry in case runner
> -			 * was only temporarily down. If the device is being
> -			 * removed then LIO core will do the right thing and
> -			 * fail the retry.
> -			 */
> -			tcmu_cmd->se_cmd->priv = NULL;
> -			target_complete_cmd(tcmu_cmd->se_cmd, SAM_STAT_BUSY);
> -			tcmu_free_cmd(tcmu_cmd);
> -			continue;
> -		}
> -
> -		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
> -		if (ret < 0) {
> -			pr_debug("cmd %p on dev %s failed with %u\n",
> -				 tcmu_cmd, udev->name, scsi_ret);
> -			/*
> -			 * Ignore scsi_ret for now. target_complete_cmd
> -			 * drops it.
> -			 */
> -			tcmu_cmd->se_cmd->priv = NULL;
> -			target_complete_cmd(tcmu_cmd->se_cmd,
> -					    SAM_STAT_CHECK_CONDITION);
> -			tcmu_free_cmd(tcmu_cmd);
> -		} else if (ret > 0) {
> -			pr_debug("ran out of space during cmdr queue run\n");
> -			/*
> -			 * cmd was requeued, so just put all cmds back in
> -			 * the queue
> -			 */
> -			list_splice_tail(&cmds, &udev->qfull_queue);
> -			break;
> -		}
> -	}
> -
> -	tcmu_set_next_deadline(&udev->qfull_queue, &udev->qfull_timer);
> -}
> -
>   static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
>   {
>   	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
> -
> -	mutex_lock(&udev->cmdr_lock);
> -	if (tcmu_handle_completions(udev))
> -		run_qfull_queue(udev, false);
> -	mutex_unlock(&udev->cmdr_lock);
> -
> +	queue_work(tcmu_comp_wq, &udev->complete_work);
>   	return 0;
>   }
>   
> @@ -3281,12 +3290,19 @@ static int __init tcmu_module_init(void)
>   
>   	INIT_DELAYED_WORK(&tcmu_unmap_work, tcmu_unmap_work_fn);
>   
> +	tcmu_comp_wq = alloc_workqueue("tcmu-comp-wq",
> +			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);
> +	if (!tcmu_comp_wq)
> +		return -ENOMEM;
> +
>   	tcmu_cmd_cache = kmem_cache_create("tcmu_cmd_cache",
>   				sizeof(struct tcmu_cmd),
>   				__alignof__(struct tcmu_cmd),
>   				0, NULL);
> -	if (!tcmu_cmd_cache)
> -		return -ENOMEM;
> +	if (!tcmu_cmd_cache) {
> +		ret = -ENOMEM;
> +		goto out_free_comp_wq;
> +	}
>   
>   	tcmu_root_device = root_device_register("tcm_user");
>   	if (IS_ERR(tcmu_root_device)) {
> @@ -3335,6 +3351,8 @@ static int __init tcmu_module_init(void)
>   	root_device_unregister(tcmu_root_device);
>   out_free_cache:
>   	kmem_cache_destroy(tcmu_cmd_cache);
> +out_free_comp_wq:
> +	destroy_workqueue(tcmu_comp_wq);
>   
>   	return ret;
>   }
> @@ -3347,6 +3365,7 @@ static void __exit tcmu_module_exit(void)
>   	genl_unregister_family(&tcmu_genl_family);
>   	root_device_unregister(tcmu_root_device);
>   	kmem_cache_destroy(tcmu_cmd_cache);
> +	destroy_workqueue(tcmu_comp_wq);
>   }
>   
>   MODULE_DESCRIPTION("TCM USER subsystem plugin");
