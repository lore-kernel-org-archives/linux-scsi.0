Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9615C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 08:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiGMIRJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 04:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbiGMIQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 04:16:43 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2719A9FE1D
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 01:13:55 -0700 (PDT)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LjVdd2kVfz67ZTx;
        Wed, 13 Jul 2022 16:09:25 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 10:13:47 +0200
Received: from [10.195.32.223] (10.195.32.223) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 13 Jul 2022 09:13:46 +0100
Message-ID: <3c0f352a-0be6-7322-3556-8ce0d66ba8f3@huawei.com>
Date:   Wed, 13 Jul 2022 09:13:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v4 4/4] scsi: core: Call blk_mq_free_tag_set() earlier
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        "Christoph Hellwig" <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Li Zhijian <lizhijian@fujitsu.com>
References: <20220712221936.1199196-1-bvanassche@acm.org>
 <20220712221936.1199196-5-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220712221936.1199196-5-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.32.223]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/07/2022 23:19, Bart Van Assche wrote:
> There are two .exit_cmd_priv implementations. Both implementations use
> resources associated with the SCSI host. Make sure that these resources are
> still available when .exit_cmd_priv is called by moving the .exit_cmd_priv
> calls from scsi_host_dev_release() to scsi_forget_host(). Moving
> blk_mq_free_tag_set() from scsi_host_dev_release() to scsi_forget_host() is
> safe because scsi_forget_host() waits until all SCSI devices associated

It seems to me that blk_mq_free_tag_set() is called from 
scsi_remove_host() now, right?

> with the host have been removed.
> 
> This patch fixes the following use-after-free:
> 
> ==================================================================
> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
> Read of size 8 at addr ffff888100337000 by task multipathd/16727
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x34/0x44
>   print_report.cold+0x5e/0x5db
>   kasan_report+0xab/0x120
>   srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>   scsi_mq_exit_request+0x4d/0x70
>   blk_mq_free_rqs+0x143/0x410
>   __blk_mq_free_map_and_rqs+0x6e/0x100
>   blk_mq_free_tag_set+0x2b/0x160
>   scsi_host_dev_release+0xf3/0x1a0
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   scsi_device_dev_release_usercontext+0x4c1/0x4e0
>   execute_in_process_context+0x23/0x90
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   scsi_disk_release+0x3f/0x50
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   disk_release+0x17f/0x1b0
>   device_release+0x54/0xe0
>   kobject_put+0xa5/0x120
>   dm_put_table_device+0xa3/0x160 [dm_mod]
>   dm_put_device+0xd0/0x140 [dm_mod]
>   free_priority_group+0xd8/0x110 [dm_multipath]
>   free_multipath+0x94/0xe0 [dm_multipath]
>   dm_table_destroy+0xa2/0x1e0 [dm_mod]
>   __dm_destroy+0x196/0x350 [dm_mod]
>   dev_remove+0x10c/0x160 [dm_mod]
>   ctl_ioctl+0x2c2/0x590 [dm_mod]
>   dm_ctl_ioctl+0x5/0x10 [dm_mod]
>   __x64_sys_ioctl+0xb4/0xf0
>   dm_ctl_ioctl+0x5/0x10 [dm_mod]
>   __x64_sys_ioctl+0xb4/0xf0
>   do_syscall_64+0x3b/0x90
>   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Li Zhijian <lizhijian@fujitsu.com>
> Reported-by: Li Zhijian <lizhijian@fujitsu.com>
> Tested-by: Li Zhijian <lizhijian@fujitsu.com>
> Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/hosts.c    | 10 +++++-----
>   drivers/scsi/scsi_lib.c |  3 +++
>   2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8fa98c8d0ee0..6c63672971f1 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -197,6 +197,8 @@ void scsi_remove_host(struct Scsi_Host *shost)
>   	 * the dependent SCSI targets and devices are gone before returning.
>   	 */
>   	wait_event(shost->targets_wq, atomic_read(&shost->target_count) == 0);
> +
> +	scsi_mq_destroy_tags(shost);
>   }
>   EXPORT_SYMBOL(scsi_remove_host);
>   
> @@ -302,8 +304,8 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	return error;
>   
>   	/*
> -	 * Any host allocation in this function will be freed in
> -	 * scsi_host_dev_release().
> +	 * Any resources associated with the SCSI host in this function except
> +	 * the tag set will be freed by scsi_host_dev_release().
>   	 */
>    out_del_dev:
>   	device_del(&shost->shost_dev);
> @@ -319,6 +321,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   	pm_runtime_disable(&shost->shost_gendev);
>   	pm_runtime_set_suspended(&shost->shost_gendev);
>   	pm_runtime_put_noidle(&shost->shost_gendev);
> +	scsi_mq_destroy_tags(shost);
>    fail:
>   	return error;
>   }
> @@ -352,9 +355,6 @@ static void scsi_host_dev_release(struct device *dev)
>   		kfree(dev_name(&shost->shost_dev));
>   	}
>   
> -	if (shost->tag_set.tags)
> -		scsi_mq_destroy_tags(shost);
> -
>   	kfree(shost->shost_data);
>   
>   	ida_free(&host_index_ida, shost->host_no);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 2aca0a838ca5..295c48fdb650 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1990,7 +1990,10 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>   
>   void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>   {
> +	if (!shost->tag_set.tags)
> +		return;
>   	blk_mq_free_tag_set(&shost->tag_set);
> +	WARN_ON_ONCE(shost->tag_set.tags);

blk_mq_free_tag_set() clears the tagset tags pointer, so I don't know 
why you don't trust the semantics of that API - this seems like paranoia.

>   }
>   
>   /**
> .


Thanks,
john
