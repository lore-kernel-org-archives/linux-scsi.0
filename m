Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C815CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 10:23:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A97EB20747
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 10:23:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hRZclOtQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgGBKXf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 06:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727860AbgGBKXe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 06:23:34 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9228FC08C5C1
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2020 03:23:34 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h23so20836058qtr.0
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2020 03:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=89FcpnPciL7Gq+aGDoxiVag8If3+LnzHi2dNWlhAwi0=;
        b=hRZclOtQqi2trvksHv14Rg8G5Nep7axCvQFqcElW8E3QUH3TK17nTG5xTd8iELYLw8
         +LWvf2Ze7RB9vi9ip0gA5ywRLXlHhcwfRSWdmFxq6guXNOwswkF169Oi8aAoxlmO8lax
         SzI7YR2Y8H/o1hIi7CokiM6EO3Mu3fPquBq0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=89FcpnPciL7Gq+aGDoxiVag8If3+LnzHi2dNWlhAwi0=;
        b=KYf6OhPHEaclTtkf8KojCGywnEhnmCsiyLDUXxKG6k0cg11lX3XWbLnk6fg0c58xAA
         J/h8DI8LGnF3kq/ppEZkD7Bn9CclHczoFPx4FPxdW57h4Sk9kS/IHRqYsZw9eI4QD6VY
         Q94988qE/WlSmD5XKUKeBUylpE6wO0Xb+2hCy9BrIKKkeKH+LonaUBjEB4xoWOQLqLah
         Eb3OTaaQ4mGuXMkAO0xuBgiu+OQgqaC0tAra6KEQQVzK0vZ7Ve5nsRJNSZTrHNxFkNoZ
         avEwHHUNO0MbdYjm+cznl7x4hKqmwFeMn+jWf8xYxgwvprkFk5Hbl5xNO7lVlnKVgX4z
         Ubgw==
X-Gm-Message-State: AOAM5313xthis4i5yB/Ddcjp6jDOAz3d4NHIVK4ZdpzRUaRK++XHeySw
        DU+bNPQgM0tCq4tG8RM9pk9QG5wVIkyKlik2uDtESw==
X-Google-Smtp-Source: ABdhPJzZpu9uf5JzEPa7tOlg1DGNa6bJhDidBAywu3Ks8V+17TItfifnksWX4AkYFqSDy+hNS/MkdrZjRorpbh9KEsI=
X-Received: by 2002:ac8:4f50:: with SMTP id i16mr14250590qtw.216.1593685413543;
 Thu, 02 Jul 2020 03:23:33 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com> <1591810159-240929-11-git-send-email-john.garry@huawei.com>
In-Reply-To: <1591810159-240929-11-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgFIs823q+pblpA=
Date:   Thu, 2 Jul 2020 15:53:31 +0530
Message-ID: <d55972999b9370f947c20537e41b49bf@mail.gmail.com>
Subject: RE: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        ming.lei@redhat.com, bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>
> From: Hannes Reinecke <hare@suse.com>
>
> Fusion adapters can steer completions to individual queues, and we now
have
> support for shared host-wide tags.
> So we can enable multiqueue support for fusion adapters and drop the
hand-
> crafted interrupt affinity settings.

Shared host tag is primarily introduced for completeness of CPU hotplug as
discussed earlier -
https://lwn.net/Articles/819419/

How shall I test CPU hotplug on megaraid_sas driver ? My understanding is
- This RFC + patch set from above link is required for it. I could not see
above series is committed.
Am I missing anything. ?

We do not want to completely move to shared host tag. It will be shared
host tag support by default, but user should have choice to go back to
legacy path.
We will completely move to shared host tag path once it is stable and no
more field issue observed over a period of time. -

Updated <megaraid_sas> patch will looks like this -

diff --git a/megaraid_sas_base.c b/megaraid_sas_base.c
index 0066833..3b503cb 100644
--- a/megaraid_sas_base.c
+++ b/megaraid_sas_base.c
@@ -37,6 +37,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/irq_poll.h>
+#include <linux/blk-mq-pci.h>

 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -113,6 +114,10 @@ unsigned int enable_sdev_max_qd;
 module_param(enable_sdev_max_qd, int, 0444);
 MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as can_queue.
Default: 0");

+int host_tagset_disabled = 0;
+module_param(host_tagset_disabled, int, 0444);
+MODULE_PARM_DESC(host_tagset_disabled, "Shared host tagset enable/disable
Default: enable(1)");
+
 MODULE_LICENSE("GPL");
 MODULE_VERSION(MEGASAS_VERSION);
 MODULE_AUTHOR("megaraidlinux.pdl@broadcom.com");
@@ -3115,6 +3120,18 @@ megasas_bios_param(struct scsi_device *sdev, struct
block_device *bdev,
        return 0;
 }

+static int megasas_map_queues(struct Scsi_Host *shost)
+{
+       struct megasas_instance *instance;
+       instance = (struct megasas_instance *)shost->hostdata;
+
+       if (instance->host->nr_hw_queues == 1)
+               return 0;
+
+       return
blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
+                       instance->pdev,
instance->low_latency_index_start);
+}
+
 static void megasas_aen_polling(struct work_struct *work);

 /**
@@ -3423,8 +3440,10 @@ static struct scsi_host_template megasas_template =
{
        .eh_timed_out = megasas_reset_timer,
        .shost_attrs = megaraid_host_attrs,
        .bios_param = megasas_bios_param,
+       .map_queues = megasas_map_queues,
        .change_queue_depth = scsi_change_queue_depth,
        .max_segment_size = 0xffffffff,
+       .host_tagset = 1,
 };

 /**
@@ -6793,7 +6812,21 @@ static int megasas_io_attach(struct
megasas_instance *instance)
        host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
        host->max_lun = MEGASAS_MAX_LUN;
        host->max_cmd_len = 16;
+       host->nr_hw_queues = 1;

+       /* Use shared host tagset only for fusion adaptors
+        * if there are more than one managed interrupts.
+        */
+       if ((instance->adapter_type != MFI_SERIES) &&
+               (instance->msix_vectors > 0) &&
+               !host_tagset_disabled &&
+               instance->smp_affinity_enable)
+               host->nr_hw_queues = instance->msix_vectors -
+                       instance->low_latency_index_start;
+
+       dev_info(&instance->pdev->dev, "Max firmware commands: %d"
+               " for nr_hw_queues = %d\n", instance->max_fw_cmds,
+               host->nr_hw_queues);
        /*
         * Notify the mid-layer about the new controller
         */
@@ -8842,6 +8875,7 @@ static int __init megasas_init(void)
                msix_vectors = 1;
                rdpq_enable = 0;
                dual_qdepth_disable = 1;
+               host_tagset_disabled = 1;
        }

        /*
diff --git a/megaraid_sas_fusion.c b/megaraid_sas_fusion.c
index 319f241..14d4f35 100755
--- a/megaraid_sas_fusion.c
+++ b/megaraid_sas_fusion.c
@@ -373,24 +373,28 @@ megasas_get_msix_index(struct megasas_instance
*instance,
 {
        int sdev_busy;

-       /* nr_hw_queue = 1 for MegaRAID */
-       struct blk_mq_hw_ctx *hctx =
-               scmd->device->request_queue->queue_hw_ctx[0];
-
-       sdev_busy = atomic_read(&hctx->nr_active);
+       /* TBD - if sml remove device_busy in future, driver
+        * should track counter in internal structure.
+        */
+       sdev_busy = atomic_read(&scmd->device->device_busy);

        if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
-           sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
+           sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH)) {
                cmd->request_desc->SCSIIO.MSIxIndex =
                        mega_mod64((atomic64_add_return(1,
&instance->high_iops_outstanding) /
                                        MR_HIGH_IOPS_BATCH_COUNT),
instance->low_latency_index_start);
-       else if (instance->msix_load_balance)
+       } else if (instance->msix_load_balance) {
                cmd->request_desc->SCSIIO.MSIxIndex =
                        (mega_mod64(atomic64_add_return(1,
&instance->total_io_count),
                                instance->msix_vectors));
-       else
+       } else if (instance->host->nr_hw_queues > 1) {
+               u32 tag = blk_mq_unique_tag(scmd->request);
+               cmd->request_desc->SCSIIO.MSIxIndex =
blk_mq_unique_tag_to_hwq(tag) +
+                       instance->low_latency_index_start;
+       } else {
                cmd->request_desc->SCSIIO.MSIxIndex =
                        instance->reply_map[raw_smp_processor_id()];
+       }
 }

 /**
@@ -970,9 +974,6 @@ megasas_alloc_cmds_fusion(struct megasas_instance
*instance)
        if (megasas_alloc_cmdlist_fusion(instance))
                goto fail_exit;

-       dev_info(&instance->pdev->dev, "Configured max firmware commands:
%d\n",
-                instance->max_fw_cmds);
-
        /* The first 256 bytes (SMID 0) is not used. Don't add to the cmd
list */
        io_req_base = fusion->io_request_frames +
MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
        io_req_base_phys = fusion->io_request_frames_phys +
MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;

Kashyap

>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  1 -
>  drivers/scsi/megaraid/megaraid_sas_base.c   | 59 +++++++--------------
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 24 +++++----
>  3 files changed, 32 insertions(+), 52 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> b/drivers/scsi/megaraid/megaraid_sas.h
> index af2c7a2a9565..b27a34a5f5de 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2261,7 +2261,6 @@ enum MR_PERF_MODE {
>
>  struct megasas_instance {
>
> -	unsigned int *reply_map;
>  	__le32 *producer;
>  	dma_addr_t producer_h;
>  	__le32 *consumer;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 00668335c2af..e6bb2a64d51c 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -37,6 +37,7 @@
>  #include <linux/poll.h>
>  #include <linux/vmalloc.h>
>  #include <linux/irq_poll.h>
> +#include <linux/blk-mq-pci.h>
>
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -3115,6 +3116,19 @@ megasas_bios_param(struct scsi_device *sdev,
> struct block_device *bdev,
>  	return 0;
>  }
>
> +static int megasas_map_queues(struct Scsi_Host *shost) {
> +	struct megasas_instance *instance;
> +
> +	instance = (struct megasas_instance *)shost->hostdata;
> +
> +	if (!instance->smp_affinity_enable)
> +		return 0;
> +
> +	return blk_mq_pci_map_queues(&shost-
> >tag_set.map[HCTX_TYPE_DEFAULT],
> +			instance->pdev,
instance->low_latency_index_start);
> +}
> +
>  static void megasas_aen_polling(struct work_struct *work);
>
>  /**
> @@ -3423,8 +3437,10 @@ static struct scsi_host_template
> megasas_template = {
>  	.eh_timed_out = megasas_reset_timer,
>  	.shost_attrs = megaraid_host_attrs,
>  	.bios_param = megasas_bios_param,
> +	.map_queues = megasas_map_queues,
>  	.change_queue_depth = scsi_change_queue_depth,
>  	.max_segment_size = 0xffffffff,
> +	.host_tagset = 1,
>  };
>
>  /**
> @@ -5708,34 +5724,6 @@ megasas_setup_jbod_map(struct
> megasas_instance *instance)
>  		instance->use_seqnum_jbod_fp = false;  }
>
> -static void megasas_setup_reply_map(struct megasas_instance *instance)
-{
> -	const struct cpumask *mask;
> -	unsigned int queue, cpu, low_latency_index_start;
> -
> -	low_latency_index_start = instance->low_latency_index_start;
> -
> -	for (queue = low_latency_index_start; queue < instance-
> >msix_vectors; queue++) {
> -		mask = pci_irq_get_affinity(instance->pdev, queue);
> -		if (!mask)
> -			goto fallback;
> -
> -		for_each_cpu(cpu, mask)
> -			instance->reply_map[cpu] = queue;
> -	}
> -	return;
> -
> -fallback:
> -	queue = low_latency_index_start;
> -	for_each_possible_cpu(cpu) {
> -		instance->reply_map[cpu] = queue;
> -		if (queue == (instance->msix_vectors - 1))
> -			queue = low_latency_index_start;
> -		else
> -			queue++;
> -	}
> -}
> -
>  /**
>   * megasas_get_device_list -	Get the PD and LD device list from FW.
>   * @instance:			Adapter soft state
> @@ -6158,8 +6146,6 @@ static int megasas_init_fw(struct megasas_instance
> *instance)
>  			goto fail_init_adapter;
>  	}
>
> -	megasas_setup_reply_map(instance);
> -
>  	dev_info(&instance->pdev->dev,
>  		"current msix/online cpus\t: (%d/%d)\n",
>  		instance->msix_vectors, (unsigned int)num_online_cpus());
> @@ -6793,6 +6779,9 @@ static int megasas_io_attach(struct
> megasas_instance *instance)
>  	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
>  	host->max_lun = MEGASAS_MAX_LUN;
>  	host->max_cmd_len = 16;
> +	if (instance->adapter_type != MFI_SERIES && instance->msix_vectors
> > 0)
> +		host->nr_hw_queues = instance->msix_vectors -
> +			instance->low_latency_index_start;
>
>  	/*
>  	 * Notify the mid-layer about the new controller @@ -6960,11
> +6949,6 @@ static inline int megasas_alloc_mfi_ctrl_mem(struct
> megasas_instance *instance)
>   */
>  static int megasas_alloc_ctrl_mem(struct megasas_instance *instance)  {
> -	instance->reply_map = kcalloc(nr_cpu_ids, sizeof(unsigned int),
> -				      GFP_KERNEL);
> -	if (!instance->reply_map)
> -		return -ENOMEM;
> -
>  	switch (instance->adapter_type) {
>  	case MFI_SERIES:
>  		if (megasas_alloc_mfi_ctrl_mem(instance))
> @@ -6981,8 +6965,6 @@ static int megasas_alloc_ctrl_mem(struct
> megasas_instance *instance)
>
>  	return 0;
>   fail:
> -	kfree(instance->reply_map);
> -	instance->reply_map = NULL;
>  	return -ENOMEM;
>  }
>
> @@ -6995,7 +6977,6 @@ static int megasas_alloc_ctrl_mem(struct
> megasas_instance *instance)
>   */
>  static inline void megasas_free_ctrl_mem(struct megasas_instance
> *instance)  {
> -	kfree(instance->reply_map);
>  	if (instance->adapter_type == MFI_SERIES) {
>  		if (instance->producer)
>  			dma_free_coherent(&instance->pdev->dev,
> sizeof(u32), @@ -7683,8 +7664,6 @@ megasas_resume(struct pci_dev
> *pdev)
>  			goto fail_reenable_msix;
>  	}
>
> -	megasas_setup_reply_map(instance);
> -
>  	if (instance->adapter_type != MFI_SERIES) {
>  		megasas_reset_reply_desc(instance);
>  		if (megasas_ioc_init_fusion(instance)) { diff --git
> a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 319f241da4b6..8e25b700988e 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -373,24 +373,24 @@ megasas_get_msix_index(struct megasas_instance
> *instance,  {
>  	int sdev_busy;
>
> -	/* nr_hw_queue = 1 for MegaRAID */
> -	struct blk_mq_hw_ctx *hctx =
> -		scmd->device->request_queue->queue_hw_ctx[0];
> +	struct blk_mq_hw_ctx *hctx = scmd->request->mq_hctx;
>
>  	sdev_busy = atomic_read(&hctx->nr_active);
>
>  	if (instance->perf_mode == MR_BALANCED_PERF_MODE &&
> -	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH))
> +	    sdev_busy > (data_arms * MR_DEVICE_HIGH_IOPS_DEPTH)) {
>  		cmd->request_desc->SCSIIO.MSIxIndex =
>  			mega_mod64((atomic64_add_return(1, &instance-
> >high_iops_outstanding) /
>  					MR_HIGH_IOPS_BATCH_COUNT),
> instance->low_latency_index_start);
> -	else if (instance->msix_load_balance)
> +	} else if (instance->msix_load_balance) {
>  		cmd->request_desc->SCSIIO.MSIxIndex =
>  			(mega_mod64(atomic64_add_return(1, &instance-
> >total_io_count),
>  				instance->msix_vectors));
> -	else
> -		cmd->request_desc->SCSIIO.MSIxIndex =
> -			instance->reply_map[raw_smp_processor_id()];
> +	} else {
> +		u32 tag = blk_mq_unique_tag(scmd->request);
> +
> +		cmd->request_desc->SCSIIO.MSIxIndex =
> blk_mq_unique_tag_to_hwq(tag) + instance->low_latency_index_start;
> +	}
>  }
>
>  /**
> @@ -3326,7 +3326,7 @@ megasas_build_and_issue_cmd_fusion(struct
> megasas_instance *instance,  {
>  	struct megasas_cmd_fusion *cmd, *r1_cmd = NULL;
>  	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
> -	u32 index;
> +	u32 index, blk_tag, unique_tag;
>
>  	if ((megasas_cmd_type(scmd) == READ_WRITE_LDIO) &&
>  		instance->ldio_threshold &&
> @@ -3342,7 +3342,9 @@ megasas_build_and_issue_cmd_fusion(struct
> megasas_instance *instance,
>  		return SCSI_MLQUEUE_HOST_BUSY;
>  	}
>
> -	cmd = megasas_get_cmd_fusion(instance, scmd->request->tag);
> +	unique_tag = blk_mq_unique_tag(scmd->request);
> +	blk_tag = blk_mq_unique_tag_to_tag(unique_tag);
> +	cmd = megasas_get_cmd_fusion(instance, blk_tag);
>
>  	if (!cmd) {
>  		atomic_dec(&instance->fw_outstanding);
> @@ -3383,7 +3385,7 @@ megasas_build_and_issue_cmd_fusion(struct
> megasas_instance *instance,
>  	 */
>  	if (cmd->r1_alt_dev_handle != MR_DEVHANDLE_INVALID) {
>  		r1_cmd = megasas_get_cmd_fusion(instance,
> -				(scmd->request->tag + instance-
> >max_fw_cmds));
> +				(blk_tag + instance->max_fw_cmds));
>  		megasas_prepare_secondRaid1_IO(instance, cmd, r1_cmd);
>  	}
>
> --
> 2.26.2
