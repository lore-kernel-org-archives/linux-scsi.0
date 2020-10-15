Return-Path: <SRS0=rjNM=DW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,MIME_NO_TEXT,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23064C433E7
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 13:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B934622254
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Oct 2020 13:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X+5oFfXg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729327AbgJONhZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Oct 2020 09:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgJONhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2020 09:37:24 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEA5C061755
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 06:37:24 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id h6so1946056pgk.4
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2020 06:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=szEYQL+UFsoz45EK4EaWZ0ISvKaudio+EZw2y3d93Ts=;
        b=X+5oFfXgy0WaJhyp4Y9Ijur4OVAo53eJOEU5v9XJi9BJR06NO9vco5DCNtBerxsfcb
         UtyN219WyBh5n6Ize6lm9piqh4JedOjQ86swjXNW1081y9VAXIGTkeSnkGc3Qpp/mvnc
         r5+IzT/Fkv+xUGsv7uPJlPJ9gPmEEmbJKyIbc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=szEYQL+UFsoz45EK4EaWZ0ISvKaudio+EZw2y3d93Ts=;
        b=DyvoE9hLVtd7QtshN24Xao5q3hNa8DBlYezTXWWSX/zPjRf0Pujxwe38kruVLU+Puq
         04oSHH6IBakKblqGFhKQIKSwLuGVghUzJibdyXIaRfoi0SOy1iXVQ3V2KY/QwdWKTiN9
         ygk/Gtex9tA7uP33N1WEYEBTlRgiVSuYX6JGos2cnSMd1gJHwQpWOmhO7c5BqYGf7xVB
         NPBwtmJgNbM+ifn1yXgdvG3icFyhEXE6U40rFQLAD1XjIiwGZjO/wBE5y9TuX+hagO5i
         mo6sUU6m0SIxChlUx1BWVDt25A6FCgUXxANj6A/WWuCZn7UsfX0K78KVJ2ZrzGHWeW3z
         zbcA==
X-Gm-Message-State: AOAM5328vNt1L874Pytm+8MB46LP8gtQ61fs5yIUT6ACeC1MCcs0M//x
        H0y7KZkCF8c2p1g2a1UuTADyxLXyL1tBaL3+xbBPXA7P9dR7wQfCUvjYWx95VGZjJojbTOly4Eo
        xtzZk3eAhDWO7NCJDK9uGP593AO6hJz2JRypGLhzqVlVAlaOvnXvYAsXVJqDi3LujxrqJ9ALm52
        J0qEyFr3tk5iA=
X-Google-Smtp-Source: ABdhPJx8r5ts3nXZHrCq7mT+gDNmYO5Ve7J+GEdROeFNsQPGohHn3/k5T8QdKg7TTu72LLXYn/4iDQ==
X-Received: by 2002:a62:5ec5:0:b029:157:c78e:d547 with SMTP id s188-20020a625ec50000b0290157c78ed547mr4093126pfb.33.1602769043714;
        Thu, 15 Oct 2020 06:37:23 -0700 (PDT)
Received: from drv-bst-rhel8.static.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id x23sm3435208pfc.47.2020.10.15.06.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 06:37:22 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        linux-block@vger.kernel.org
Subject: [PATCH v1 2/3] megaraid_sas: iouring iopoll support
Date:   Thu, 15 Oct 2020 19:07:02 +0530
Message-Id: <20201015133702.62879-1-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008bef5305b1b5bf99"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008bef5305b1b5bf99

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
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +
 drivers/scsi/megaraid/megaraid_sas_base.c   | 90 ++++++++++++++++++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 43 +++++++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  3 +
 4 files changed, 127 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 5e4137f10e0e..4bf6fde49565 100644
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
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 020270ce790b..e2c307523a8a 100644
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
@@ -3127,14 +3137,45 @@ megasas_bios_param(struct scsi_device *sdev, struct block_device *bdev,
 static int megasas_map_queues(struct Scsi_Host *shost)
 {
 	struct megasas_instance *instance;
+	int i, qoff, offset;
 
 	instance = (struct megasas_instance *)shost->hostdata;
 
 	if (shost->nr_hw_queues == 1)
 		return 0;
 
-	return blk_mq_pci_map_queues(&shost->tag_set.map[HCTX_TYPE_DEFAULT],
-			instance->pdev, instance->low_latency_index_start);
+	offset = instance->low_latency_index_start;
+
+	for (i = 0, qoff = 0; i < HCTX_MAX_TYPES; i++) {
+		struct blk_mq_queue_map *map = &shost->tag_set.map[i];
+
+		map->nr_queues  = 0;
+
+		if (i == HCTX_TYPE_DEFAULT)
+			map->nr_queues = instance->msix_vectors - offset;
+		else if (i == HCTX_TYPE_POLL)
+			map->nr_queues = instance->iopoll_q_count;
+
+		if (!map->nr_queues) {
+			BUG_ON(i == HCTX_TYPE_DEFAULT);
+			continue;
+		}
+
+		/*
+		 * The poll queue(s) doesn't have an IRQ (and hence IRQ
+		 * affinity), so use the regular blk-mq cpu mapping
+		 */
+		map->queue_offset = qoff;
+		if (i != HCTX_TYPE_POLL)
+			blk_mq_pci_map_queues(map, instance->pdev, offset);
+		else
+			blk_mq_map_queues(map);
+
+		qoff += map->nr_queues;
+		offset += map->nr_queues;
+	}
+
+	return 0;
 }
 
 static void megasas_aen_polling(struct work_struct *work);
@@ -3446,6 +3487,7 @@ static struct scsi_host_template megasas_template = {
 	.shost_attrs = megaraid_host_attrs,
 	.bios_param = megasas_bios_param,
 	.map_queues = megasas_map_queues,
+	.mq_poll = megasas_blk_mq_poll,
 	.change_queue_depth = scsi_change_queue_depth,
 	.max_segment_size = 0xffffffff,
 };
@@ -5834,13 +5876,16 @@ __megasas_alloc_irq_vectors(struct megasas_instance *instance)
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
@@ -5856,10 +5901,25 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
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
+		if (instance->msix_vectors > (instance->iopoll_q_count + 2))
+			instance->iopoll_q_count = poll_queues;
+		else
+			instance->iopoll_q_count = 0;
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
@@ -5870,12 +5930,15 @@ megasas_alloc_irq_vectors(struct megasas_instance *instance)
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
@@ -6841,12 +6904,18 @@ static int megasas_io_attach(struct megasas_instance *instance)
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
@@ -8907,6 +8976,7 @@ static int __init megasas_init(void)
 		msix_vectors = 1;
 		rdpq_enable = 0;
 		dual_qdepth_disable = 1;
+		poll_queues = 0;
 	}
 
 	/*
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index fd607287608e..49c8cc3507e0 100644
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
@@ -3630,9 +3642,36 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
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
+
 /**
  * megasas_enable_irq_poll() - enable irqpoll
  * @instance:			Adapter soft state
@@ -4164,6 +4203,8 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 
 	fusion = instance->ctrl_context;
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
+	count += instance->iopoll_q_count;
+
 	for (i = 0 ; i < count ; i++) {
 		fusion->last_reply_idx[i] = 0;
 		reply_desc = fusion->reply_frames_desc[i];
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 30de4b01f703..242ff58a3404 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1303,6 +1303,9 @@ struct fusion_context {
 	u8 *sense;
 	dma_addr_t sense_phys_addr;
 
+	atomic_t   busy_mq_poll[MAX_MSIX_QUEUES_FUSION];
+
+
 	dma_addr_t reply_frames_desc_phys[MAX_MSIX_QUEUES_FUSION];
 	union MPI2_REPLY_DESCRIPTORS_UNION *reply_frames_desc[MAX_MSIX_QUEUES_FUSION];
 	struct rdpq_alloc_detail rdpq_tracker[RDPQ_MAX_CHUNK_COUNT];
-- 
2.18.1


--0000000000008bef5305b1b5bf99
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
RzMCDDSdoX7GqonhoE7TszANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQgFtOyAWBD
B3dS2HtFhFEKZFQjPWDHaGCBronI3RlwtJ4wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkq
hkiG9w0BCQUxDxcNMjAxMDE1MTMzNzI0WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG
9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAHnjlNEzMs0HIPvmqguXdxSu4j3V
/XDA/ek9JIRs16GoNzbc6Fm/9Eh41li4enIowhyqCAIYnrBJXPzCNEuvCtmjgekHOw+3MKdKsBGe
nRfuPNJ3nWL/TdZF5gvxLSBEgW6EY3qiHUqaHJsHjiTBusDrJnyqdjSYAKL1ocH1jaR8Wu8KdCKA
b6i1XyM1cH8IeGULmxud0Ic8RMedZCM1n9cpJzPEp3Nk0oAfkIj5QvzKZy//jHGNdglaoO3+xRw6
LXIHDSckhRP81IMJpASjQZbsVIRJs8Tpqhb/LmVFWQBnYNLvOa+fIHy7P2POVlYGIDAkFoSDE++X
rmORJBD1j48=
--0000000000008bef5305b1b5bf99--
