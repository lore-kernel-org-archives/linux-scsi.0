Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DATE_IN_PAST_06_12,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,SPF_HELO_NONE,SPF_PASS,
	T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026CAC433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 13:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1AE864E7A
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 13:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbhBANRO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 08:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbhBANQx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 08:16:53 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706F6C0613ED
        for <linux-scsi@vger.kernel.org>; Mon,  1 Feb 2021 05:16:13 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id m6so11569184pfk.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Feb 2021 05:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WvSvFfn+iIQbV5OSnzw6I2hJqr+ne/XrDw2b+/gJUxY=;
        b=L5IaaaCR3RsTPMj14665I0V6MpPNcMl+HfPUAwSCFkAWk//Zyw7J4S54zPbCzpk9mW
         1eubA9cFtjdxbX8NimS8iaqKCwJmZIAoHAFbvD92YibhTuYcXDYxTnZpuNbpFaXXy+7n
         1NOxPM861uSilmuY+hO3Xr8i9cQNkpbXv5afY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WvSvFfn+iIQbV5OSnzw6I2hJqr+ne/XrDw2b+/gJUxY=;
        b=HWcZw4xOE0IOWMAh3kAVyyX8+CFLuxB8iFpgqVX0lxed0vXN9cK40JdfBDgC0Jvcwk
         C0CPtEAhS4aNH8nnV4D4I2jmVFYIlv8kYkbYnchs0LwTs26azsLcZjz1Bctgw3viZ90x
         EZmBjHiu6fY0HUptc8/oPjSRxWkssnesnLGJSLRGz67nLfkSXCwGgWJhEk33fyuyzrAr
         6XNZZ9xgJDhNfLuX+wct4DQLzolSyO2uThxwfEMiB2WTo90il4h38h39cmASKaL2Sp/j
         KSm4Y7XQyTeSK8lHOGHyp/rLD3vaB+Mdd14bYjNS9RGq2YaE6DyFM1Fhg8v/q9en/RcN
         TJYA==
X-Gm-Message-State: AOAM533+AL0diSRF26bPv61IwV1hKrMDUnTwoZPGQQLVhkPYOTvSih1E
        qEQtFDjouzPUZlukNFgrkJJ/1TpN/rkvdgWUkDiIIJ0jvrro9gMfpz3zeYRPIOrBaNUI9+8dC9T
        9E1ozbxV9AJekjAlDMDax2s9oFWdmrz2WsLxGIn/qBeHTF72JjMmQ22YeylTmDzWNEJQlLDIBVu
        vfZBxroO7j
X-Google-Smtp-Source: ABdhPJyQ4raLGRUZcjvdRx9m5KoYDkz6AdIHoQeJTfhDPsZA2Po9lt6LZqpCoiMpUA0YaVgtne7RLw==
X-Received: by 2002:a62:7541:0:b029:1b9:c47e:7c14 with SMTP id q62-20020a6275410000b02901b9c47e7c14mr17084844pfc.30.1612185372527;
        Mon, 01 Feb 2021 05:16:12 -0800 (PST)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h2sm18573898pfk.4.2021.02.01.05.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 05:16:11 -0800 (PST)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        linux-block@vger.kernel.org
Subject: [PATCH v3 2/4] megaraid_sas: iouring iopoll support
Date:   Mon,  1 Feb 2021 10:46:17 +0530
Message-Id: <20210201051619.19909-3-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210201051619.19909-1-kashyap.desai@broadcom.com>
References: <20210201051619.19909-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007832c705ba46281a"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000007832c705ba46281a

Add support of iouring iopoll interface. This feature requires shared
hosttag support in kernel and driver.

Driver will work in non-IRQ mode = There will not be any msix vector
associated for poll_queues and h/w can still work in this mode.
MegaRaid h/w is single submission queue and multiple reply queue, but
using shared host tagset support it will enable simulated multiple hw queue.

Driver allocates some extra reply queues and it will be marked as poll_queue.
These poll_queues will not have associated msix vectors. All the IO
completion on this queue will be done from IOPOLL interface.

megaraid_sas driver having 8 poll_queues and using io_uring hiprio=1 settings,
It can reach 3.2M IOPs and there is zero interrupt generated by h/w.

This feature can be enabled using module parameter poll_queues.

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: sumit.saxena@broadcom.com
Cc: chandrakanth.patil@broadcom.com
Cc: linux-block@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas.h        |  3 +
 drivers/scsi/megaraid/megaraid_sas_base.c   | 87 ++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 42 +++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 +
 4 files changed, 123 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 0f808d63580e..d8b1797e2768 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -2212,6 +2212,7 @@ struct megasas_irq_context {
 	struct irq_poll irqpoll;
 	bool irq_poll_scheduled;
 	bool irq_line_enable;
+	atomic_t   in_used;
 };
 
 struct MR_DRV_SYSTEM_INFO {
@@ -2446,6 +2447,7 @@ struct megasas_instance {
 	bool support_pci_lane_margining;
 	u8  low_latency_index_start;
 	int perf_mode;
+	int iopoll_q_count;
 };
 
 struct MR_LD_VF_MAP {
@@ -2726,5 +2728,6 @@ void megasas_init_debugfs(void);
 void megasas_exit_debugfs(void);
 void megasas_setup_debugfs(struct megasas_instance *instance);
 void megasas_destroy_debugfs(struct megasas_instance *instance);
+int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
 
 #endif				/*LSI_MEGARAID_SAS_H */
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 63a4f48bdc75..25673d0ee524 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -114,6 +114,15 @@ unsigned int enable_sdev_max_qd;
 module_param(enable_sdev_max_qd, int, 0444);
 MODULE_PARM_DESC(enable_sdev_max_qd, "Enable sdev max qd as can_queue. Default: 0");
 
+int poll_queues;
+module_param(poll_queues, int, 0444);
+MODULE_PARM_DESC(poll_queues, "Number of queues to be use for io_uring poll mode.\n\t\t"
+		"This parameter is effective only if host_tagset_enable=1 &\n\t\t"
+		"It is not applicable for MFI_SERIES. &\n\t\t"
+		"Driver will work in latency mode. &\n\t\t"
+		"High iops queues are not allocated &\n\t\t"
+		);
+
 int host_tagset_enable = 1;
 module_param(host_tagset_enable, int, 0444);
 MODULE_PARM_DESC(host_tagset_enable, "Shared host tagset enable/disable Default: enable(1)");
@@ -207,6 +216,7 @@ static bool support_pci_lane_margining;
 static spinlock_t poll_aen_lock;
 
 extern struct dentry *megasas_debugfs_root;
+extern int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
 
 void
 megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
@@ -3127,14 +3137,37 @@ megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 static int megasas_map_queues(struct Scsi_Host *shost)
 {
 	struct megasas_instance *instance;
+	int qoff = 0, offset;
+	struct blk_mq_queue_map *map;
 
 	instance = (struct megasas_instance *)shost->hostdata;
 
 	if (shost->nr_hw_queues == 1)
 		return 0;
 
-	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-			instance->pdev, instance->low_latency_index_start);
+	offset = instance->low_latency_index_start;
+
+	/* Setup Default hctx */
+	map = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
+	map->nr_queues = instance->msix_vectors - offset;
+	map->queue_offset = 0;
+	blk_mq_pci_map_queues(map, instance->pdev, offset);
+	qoff += map->nr_queues;
+	offset += map->nr_queues;
+
+	/* Setup Poll hctx */
+	map = &shost->tag_set.map[HCTX_TYPE_POLL];
+	map->nr_queues = instance->iopoll_q_count;
+	if (map->nr_queues) {
+		/*
+		 * The poll queue(s) doesn't have an IRQ (and hence IRQ
+		 * affinity), so use the regular blk-mq cpu mapping
+		 */
+		map->queue_offset = qoff;
+		blk_mq_map_queues(map);
+	}
+
+	return 0;
 }
 
 static void megasas_aen_polling(struct work_struct *work);
@@ -3446,6 +3479,7 @@ static struct scsi_host_template megasas_template = {
 	.shost_attrs = megaraid_host_attrs,
 	.bios_param = megasas_bios_param,
 	.map_queues = megasas_map_queues,
+	.mq_poll = megasas_blk_mq_poll,
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
 };
@@ -5834,13 +5868,16 @@ __megasas_alloc_irq_vectors(struct megasas_instance *instance)
 	irq_flags = PCI_IRQ_MSIX;
 
 	if (instance->smp_affinity_enable)
-		irq_flags |= PCI_IRQ_AFFINITY;
+		irq_flags |= PCI_IRQ_AFFINITY | PCI_IRQ_ALL_TYPES;
 	else
 		descp = NULL;
 
+	/* Do not allocate msix vectors for poll_queues.
+	 * msix_vectors is always within a range of FW supported reply queue.
+	 */
 	i = pci_alloc_irq_vectors_affinity(instance->pdev,
 		instance->low_latency_index_start,
-		instance->msix_vectors, irq_flags, descp);
+		instance->msix_vectors - instance->iopoll_q_count, irq_flags, descp);
 
 	return i;
 }
@@ -5856,10 +5893,30 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
 	int i;
 	unsigned int num_msix_req;
 
+	instance->iopoll_q_count = 0;
+	if ((instance->adapter_type != MFI_SERIES) &&
+		poll_queues) {
+
+		instance->perf_mode = MR_LATENCY_PERF_MODE;
+		instance->low_latency_index_start = 1;
+
+		/* reserve for default and non-mananged pre-vector. */
+		if (instance->msix_vectors > (poll_queues + 2))
+			instance->iopoll_q_count = poll_queues;
+		else
+			instance->iopoll_q_count = 0;
+
+		num_msix_req = num_online_cpus() + instance->low_latency_index_start;
+		instance->msix_vectors = min(num_msix_req,
+				instance->msix_vectors);
+
+	}
+
 	i = __megasas_alloc_irq_vectors(instance);
 
-	if ((instance->perf_mode == MR_BALANCED_PERF_MODE) &&
-	    (i != instance->msix_vectors)) {
+	if (((instance->perf_mode == MR_BALANCED_PERF_MODE)
+		|| instance->iopoll_q_count) &&
+	    (i != (instance->msix_vectors - instance->iopoll_q_count))) {
 		if (instance->msix_vectors)
 			pci_free_irq_vectors(instance->pdev);
 		/* Disable Balanced IOPS mode and try realloc vectors */
@@ -5870,12 +5927,15 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
 		instance->msix_vectors = min(num_msix_req,
 				instance->msix_vectors);
 
+		instance->iopoll_q_count = 0;
 		i = __megasas_alloc_irq_vectors(instance);
 
 	}
 
 	dev_info(&instance->pdev->dev,
-		"requested/available msix %d/%d\n", instance->msix_vectors, i);
+		"requested/available msix %d/%d poll_queue %d\n",
+			instance->msix_vectors - instance->iopoll_q_count,
+			i, instance->iopoll_q_count);
 
 	if (i > 0)
 		instance->msix_vectors = i;
@@ -6841,12 +6901,18 @@ static int megasas_io_attach(struct megasas_instance *instance)
 		instance->smp_affinity_enable) {
 		host->host_tagset = 1;
 		host->nr_hw_queues = instance->msix_vectors -
-			instance->low_latency_index_start;
+			instance->low_latency_index_start + instance->iopoll_q_count;
+		if (instance->iopoll_q_count)
+			host->nr_maps = 3;
+	} else {
+		instance->iopoll_q_count = 0;
 	}
 
 	dev_info(&instance->pdev->dev,
-		"Max firmware commands: %d shared with nr_hw_queues = %d\n",
-		instance->max_fw_cmds, host->nr_hw_queues);
+		"Max firmware commands: %d shared with default "
+		"hw_queues = %d poll_queues %d\n", instance->max_fw_cmds,
+		host->nr_hw_queues - instance->iopoll_q_count,
+		instance->iopoll_q_count);
 	/*
 	 * Notify the mid-layer about the new controller
 	 */
@@ -8859,6 +8925,7 @@ static int __init megasas_init(void)
 		msix_vectors = 1;
 		rdpq_enable = 0;
 		dual_qdepth_disable = 1;
+		poll_queues = 0;
 	}
 
 	/*
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 38fc9467c625..10b8157044bb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -685,6 +685,8 @@ megasas_alloc_reply_fusion(struct megasas_instance *instance)
 	fusion = instance->ctrl_context;
 
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
+	count += instance->iopoll_q_count;
+
 	fusion->reply_frames_desc_pool =
 			dma_pool_create("mr_reply", &instance->pdev->dev,
 				fusion->reply_alloc_sz * count, 16, 0);
@@ -779,6 +781,7 @@ megasas_alloc_rdpq_fusion(struct megasas_instance *instance)
 	}
 
 	msix_count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
+	msix_count += instance->iopoll_q_count;
 
 	fusion->reply_frames_desc_pool = dma_pool_create("mr_rdpq",
 							 &instance->pdev->dev,
@@ -1129,7 +1132,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			MPI2_IOCINIT_MSGFLAG_RDPQ_ARRAY_MODE : 0;
 	IOCInitMessage->SystemRequestFrameBaseAddress = cpu_to_le64(fusion->io_request_frames_phys);
 	IOCInitMessage->SenseBufferAddressHigh = cpu_to_le32(upper_32_bits(fusion->sense_phys_addr));
-	IOCInitMessage->HostMSIxVectors = instance->msix_vectors;
+	IOCInitMessage->HostMSIxVectors = instance->msix_vectors + instance->iopoll_q_count;
 	IOCInitMessage->HostPageSize = MR_DEFAULT_NVME_PAGE_SHIFT;
 
 	time = ktime_get_real();
@@ -1823,6 +1826,8 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 		 sizeof(union MPI2_SGE_IO_UNION))/16;
 
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
+	count += instance->iopoll_q_count;
+
 	for (i = 0 ; i < count; i++)
 		fusion->last_reply_idx[i] = 0;
 
@@ -1835,6 +1840,9 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 				MEGASAS_FUSION_IOCTL_CMDS);
 	sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
 
+	for (i = 0; i < MAX_MSIX_QUEUES_FUSION; i++)
+		atomic_set(&fusion->busy_mq_poll[i], 0);
+
 	if (megasas_alloc_ioc_init_frame(instance))
 		return 1;
 
@@ -3500,6 +3508,9 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
 		return IRQ_NONE;
 
+	if (irq_context && !atomic_add_unless(&irq_context->in_used, 1, 1))
+		return 0;
+
 	num_completed = 0;
 
 	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
@@ -3613,6 +3624,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 					irq_context->irq_line_enable = true;
 					irq_poll_sched(&irq_context->irqpoll);
 				}
+				atomic_dec(&irq_context->in_used);
 				return num_completed;
 			}
 		}
@@ -3630,9 +3642,35 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
 				instance->reply_post_host_index_addr[0]);
 		megasas_check_and_restore_queue_depth(instance);
 	}
+
+	if (irq_context)
+		atomic_dec(&irq_context->in_used);
+
 	return num_completed;
 }
 
+int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
+{
+
+	struct megasas_instance *instance;
+	int num_entries = 0;
+	struct fusion_context *fusion;
+
+	instance = (struct megasas_instance *)shost->hostdata;
+
+	fusion = instance->ctrl_context;
+
+	queue_num = queue_num + instance->low_latency_index_start;
+
+	if (!atomic_add_unless(&fusion->busy_mq_poll[queue_num], 1, 1))
+		return 0;
+
+	num_entries = complete_cmd_fusion(instance, queue_num, NULL);
+	atomic_dec(&fusion->busy_mq_poll[queue_num]);
+
+	return num_entries;
+}
+
 /**
  * megasas_enable_irq_poll() - enable irqpoll
  * @instance:			Adapter soft state
@@ -4163,6 +4201,8 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 
 	fusion = instance->ctrl_context;
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
+	count += instance->iopoll_q_count;
+
 	for (i = 0 ; i < count ; i++) {
 		fusion->last_reply_idx[i] = 0;
 		reply_desc = fusion->reply_frames_desc[i];
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 30de4b01f703..ce84f811e5e1 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1303,6 +1303,8 @@ struct fusion_context {
 	u8 *sense;
 	dma_addr_t sense_phys_addr;
 
+	atomic_t   busy_mq_poll[MAX_MSIX_QUEUES_FUSION];
+
 	dma_addr_t reply_frames_desc_phys[MAX_MSIX_QUEUES_FUSION];
 	union MPI2_REPLY_DESCRIPTORS_UNION *reply_frames_desc[MAX_MSIX_QUEUES_FUSION];
 	struct rdpq_alloc_detail rdpq_tracker[RDPQ_MAX_CHUNK_COUNT];
-- 
2.18.1


--0000000000007832c705ba46281a
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
yfWKfxJx8FcWmsjkSlrwDu+oVuDUa2wqeKBU12HQ4JAVd+LOb5edsbbFQxgGHu+MPuc/1hl9kTkC
AwEAAaOCAdEwggHNMA4GA1UdDwEB/wQEAwIFoDCBngYIKwYBBQUHAQEEgZEwgY4wTQYIKwYBBQUH
MAKGQWh0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzcGVyc29uYWxzaWduMnNo
YTJnM29jc3AuY3J0MD0GCCsGAQUFBzABhjFodHRwOi8vb2NzcDIuZ2xvYmFsc2lnbi5jb20vZ3Nw
ZXJzb25hbHNpZ24yc2hhMmczME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIB
FiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEQGA1Ud
HwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NwZXJzb25hbHNpZ24yc2hh
MmczLmNybDAlBgNVHREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAK
BggrBgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQU4dX1
Yg4eoWXbqyPW/N1ZD/LPIWcwDQYJKoZIhvcNAQELBQADggEBABBuHYKGUwHIhCjd3LieJwKVuJNr
YohEnZzCoNaOj33/j5thiA4cZehCh6SgrIlFBIktLD7jW9Dwl88Gfcy+RrVa7XK5Hyqwr1JlCVsW
pNj4hlSJMNNqxNSqrKaD1cR4/oZVPFVnJJYlB01cLVjGMzta9x27e6XEtseo2s7aoPS2l82koMr7
8S/v9LyyP4X2aRTWOg9RG8D/13rLxFAApfYvCrf0quIUBWw2BXlq3+e3r7pU7j40d6P04VV3Zxws
M+LbYxcXFT2gXvoYd2Ms8zsLrhO2M6pMzeNGWk2HWTof9s7EEHDjis/MRlbYSNaohV23IUzNlBw7
1FmvvW5GKK0xggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWdu
IG52LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0g
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQg0i5yY1fJ
TcT6U7xeDzSjieOafLhV/4INItuUcOwxrNUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjEwMjAxMTMxNjEyWjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAD2B1wc91DVLbnYxKjh7prttbOqw
cB3TOPLc16zJqE5JWPiInQDPjsXfZuCBgMBWQjbfXvpk8SzDm310281jmagG5HOYWGyOMX1vgJB1
u8TvjllibEUfiwiRZFEsI8vJuoZc+G+REbtxvfqdVYHP9JyE84KsptFHqLhDuCEAHXzbqzANEQFJ
zs+MTz+Or2k9/fdYFw2e2iM00XJyt7kifm5sf29vrVuuMsT5b2diieJqgLpA36YX888ZyVRLf+2l
Y8RmIUiHqgaWYM7ApJCk04uOwGPt4XOCbdUT8uAkc5gCPt/yx7dmkRuixH7lUKsxwf4Tmb7W0Th/
79J/dNyJd0c=
--0000000000007832c705ba46281a--
