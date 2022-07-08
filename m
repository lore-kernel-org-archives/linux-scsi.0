Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168B7CCA47B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 19:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239926AbiGHTiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 15:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238702AbiGHTiT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 15:38:19 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46045675BD
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 12:38:18 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id o3-20020a17090a744300b001ef8f7f3dddso2638602pjk.3
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2022 12:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ePw5bM95QauQCLYzkkyv1z82OLK/G2UJ8NxXeLI2Vzs=;
        b=hYX/SXGB9eeTapIJLtGA02kfUdKWOA8M7xvE3ITVTECcYhGhAf2/DLg9BZE3M35NBZ
         ppRn/DXQEHTZFpAvkaBZfi9qW8SChgnh31fzx9GTO+3B/xpi6kykeeXEuuwW0Zv7E0OC
         U9sSbgZXjSFvUqEdcI6rsNqutPC+EYVNr/mkg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ePw5bM95QauQCLYzkkyv1z82OLK/G2UJ8NxXeLI2Vzs=;
        b=fg2DO8Ql+y1SNcOxHPzRDfaX9enAV76gmLfdtxAFcCWfkTMOGaJG2SaGKJtO0AtOed
         nNTe7a8j63vz0M7SqfPsliU9IYKdv96u2ZsAn5kojFd9BJA8XGL4Mu281AY5Rj3fE9rZ
         7bl6sJH+HMazkMKVk/Cs0gvkZQ2SM1jdZ4rDeCg59q2G7OVSxqg8NIyTPO43fnVUfrr8
         KHMsLPG/K2xVbaoVirwOqSZgSxXjDV1UBNmtgFK7YHlg4ywOkEDp6yxqZONfO5PG4h0B
         YdGmmQ2j5Jj+LdOz197vWaRDuOBSUBA9Yk8k4o15ClqUMa6KigIRw3EzB1ul0q8ZQI4D
         sX0A==
X-Gm-Message-State: AJIora+vlyO2SWif36HYyThNANzi6ya+nJTIolurACtf5XKarWEQhvlU
        kZFwBYwmm+pkeeWE8arwKQb4RSww7fvdF3W9XoS0Y+5TWl0anZjN+uQDXBwXvlwkUp6iJ7IBnCv
        Jm9UXVgrS87z8GJQXwLWXwuuJOJ+JNffre4jAZEHLAnvPXZw5a7FBAVa0/Z/UpwjVTjjfyEiI/X
        ay139AMO789wM=
X-Google-Smtp-Source: AGRyM1s1pUHUakpdQsi2MZa6rKjOiN6sOMkOs6bURC4rdmVCl9Wo42gHuRQFPxTB6KRdIRTKPlxi6w==
X-Received: by 2002:a17:902:aa8a:b0:16a:1ea5:d417 with SMTP id d10-20020a170902aa8a00b0016a1ea5d417mr5520171plr.4.1657309097108;
        Fri, 08 Jul 2022 12:38:17 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id i16-20020a170902c95000b0015e8d4eb20dsm14256484pla.87.2022.07.08.12.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 12:38:16 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 1/2] mpi3mr: Resource Based Metering
Date:   Sat,  9 Jul 2022 01:20:19 +0530
Message-Id: <20220708195020.8323-2-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220708195020.8323-1-sreekanth.reddy@broadcom.com>
References: <20220708195020.8323-1-sreekanth.reddy@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000000e820205e35058f5"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000000e820205e35058f5
Content-Transfer-Encoding: 8bit

Updated driver to track cumulative pending large data size
at the controller level and at the throttle group level.
And when one of the value meet or exceeds the controller's firmware
determined high threshold value then the driver will divert
future selective I/O to the firmware. Once both controller level
and at the throttle group level cumulative pending
large data size reach controller's firmware determined
low threshold value then the driver will stop diverting I/Os to
the firmware.

Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  61 +++++++++++-
 drivers/scsi/mpi3mr/mpi3mr_fw.c |  62 ++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c | 167 ++++++++++++++++++++++++++++++--
 3 files changed, 280 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 0557dbf..6bb3311 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -66,6 +66,8 @@ extern atomic64_t event_counter;
 #define MPI3MR_NAME_LENGTH	32
 #define IOCNAME			"%s: "
 
+#define MPI3MR_MAX_SECTORS	2048
+
 /* Definitions for internal SGL and Chain SGL buffers */
 #define MPI3MR_PAGE_SIZE_4K		4096
 #define MPI3MR_SG_DEPTH		(MPI3MR_PAGE_SIZE_4K / sizeof(struct mpi3_sge_common))
@@ -333,6 +335,12 @@ struct mpi3mr_ioc_facts {
 	u8 sge_mod_mask;
 	u8 sge_mod_value;
 	u8 sge_mod_shift;
+	u8 max_dev_per_tg;
+	u16 max_io_throttle_group;
+	u16 io_throttle_data_length;
+	u16 io_throttle_low;
+	u16 io_throttle_high;
+
 };
 
 /**
@@ -424,6 +432,23 @@ struct mpi3mr_intr_info {
 	char name[MPI3MR_NAME_LENGTH];
 };
 
+/**
+ * struct mpi3mr_throttle_group_info - Throttle group info
+ *
+ * @io_divert: Flag indicates io divert is on or off for the TG
+ * @id: Throttle Group ID.
+ * @high: High limit to turn on throttling in 512 byte blocks
+ * @low: Low limit to turn off throttling in 512 byte blocks
+ * @pend_large_data_sz: Counter to track pending large data
+ */
+struct mpi3mr_throttle_group_info {
+	u8 io_divert;
+	u16 id;
+	u32 high;
+	u32 low;
+	atomic_t pend_large_data_sz;
+};
+
 /**
  * struct tgt_dev_sas_sata - SAS/SATA device specific
  * information cached from firmware given data
@@ -457,22 +482,31 @@ struct tgt_dev_pcie {
 };
 
 /**
- * struct tgt_dev_volume - virtual device specific information
+ * struct tgt_dev_vd - virtual device specific information
  * cached from firmware given data
  *
  * @state: State of the VD
+ * @tg_id: VDs throttle group ID
+ * @high: High limit to turn on throttling in 512 byte blocks
+ * @low: Low limit to turn off throttling in 512 byte blocks
+ * @tg: Pointer to throttle group info
  */
-struct tgt_dev_volume {
+struct tgt_dev_vd {
 	u8 state;
+	u16 tg_id;
+	u32 tg_high;
+	u32 tg_low;
+	struct mpi3mr_throttle_group_info *tg;
 };
 
+
 /**
  * union _form_spec_inf - union of device specific information
  */
 union _form_spec_inf {
 	struct tgt_dev_sas_sata sas_sata_inf;
 	struct tgt_dev_pcie pcie_inf;
-	struct tgt_dev_volume vol_inf;
+	struct tgt_dev_vd vd_inf;
 };
 
 
@@ -490,6 +524,7 @@ union _form_spec_inf {
  * @dev_type: SAS/SATA/PCIE device type
  * @is_hidden: Should be exposed to upper layers or not
  * @host_exposed: Already exposed to host or not
+ * @io_throttle_enabled: I/O throttling needed or not
  * @q_depth: Device specific Queue Depth
  * @wwid: World wide ID
  * @dev_spec: Device type specific information
@@ -506,6 +541,7 @@ struct mpi3mr_tgt_dev {
 	u8 dev_type;
 	u8 is_hidden;
 	u8 host_exposed;
+	u8 io_throttle_enabled;
 	u16 q_depth;
 	u64 wwid;
 	union _form_spec_inf dev_spec;
@@ -557,6 +593,9 @@ static inline void mpi3mr_tgtdev_put(struct mpi3mr_tgt_dev *s)
  * @dev_removed: Device removed in the Firmware
  * @dev_removedelay: Device is waiting to be removed in FW
  * @dev_type: Device type
+ * @io_throttle_enabled: I/O throttling needed or not
+ * @io_divert: Flag indicates io divert is on or off for the dev
+ * @throttle_group: Pointer to throttle group info
  * @tgt_dev: Internal target device pointer
  * @pend_count: Counter to track pending I/Os during error
  *		handling
@@ -570,6 +609,9 @@ struct mpi3mr_stgt_priv_data {
 	u8 dev_removed;
 	u8 dev_removedelay;
 	u8 dev_type;
+	u8 io_throttle_enabled;
+	u8 io_divert;
+	struct mpi3mr_throttle_group_info *throttle_group;
 	struct mpi3mr_tgt_dev *tgt_dev;
 	u32 pend_count;
 };
@@ -796,6 +838,12 @@ struct scmd_priv {
  * @logdata_buf: Circular buffer to store log data entries
  * @logdata_buf_idx: Index of entry in buffer to store
  * @logdata_entry_sz: log data entry size
+ * @pend_large_data_sz: Counter to track pending large data
+ * @io_throttle_data_length: I/O size to track in 512b blocks
+ * @io_throttle_high: I/O size to start throttle in 512b blocks
+ * @io_throttle_low: I/O size to stop throttle in 512b blocks
+ * @num_io_throttle_group: Maximum number of throttle groups
+ * @throttle_groups: Pointer to throttle group info structures
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -960,6 +1008,13 @@ struct mpi3mr_ioc {
 	u8 *logdata_buf;
 	u16 logdata_buf_idx;
 	u16 logdata_entry_sz;
+
+	atomic_t pend_large_data_sz;
+	u32 io_throttle_data_length;
+	u32 io_throttle_high;
+	u32 io_throttle_low;
+	u16 num_io_throttle_group;
+	struct mpi3mr_throttle_group_info *throttle_groups;
 };
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f1d4ea8..ab79374 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2785,6 +2785,27 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	mrioc->facts.shutdown_timeout =
 	    le16_to_cpu(facts_data->shutdown_timeout);
 
+	mrioc->facts.max_dev_per_tg =
+	    facts_data->max_devices_per_throttle_group;
+	mrioc->facts.io_throttle_data_length =
+	    le16_to_cpu(facts_data->io_throttle_data_length);
+	mrioc->facts.max_io_throttle_group =
+	    le16_to_cpu(facts_data->max_io_throttle_group);
+	mrioc->facts.io_throttle_low = le16_to_cpu(facts_data->io_throttle_low);
+	mrioc->facts.io_throttle_high =
+	    le16_to_cpu(facts_data->io_throttle_high);
+
+	/* Store in 512b block count */
+	if (mrioc->facts.io_throttle_data_length)
+		mrioc->io_throttle_data_length =
+		    (mrioc->facts.io_throttle_data_length * 2 * 4);
+	else
+		/* set the length to 1MB + 1K to disable throttle */
+		mrioc->io_throttle_data_length = MPI3MR_MAX_SECTORS + 2;
+
+	mrioc->io_throttle_high = (mrioc->facts.io_throttle_high * 2 * 1024);
+	mrioc->io_throttle_low = (mrioc->facts.io_throttle_low * 2 * 1024);
+
 	ioc_info(mrioc, "ioc_num(%d), maxopQ(%d), maxopRepQ(%d), maxdh(%d),",
 	    mrioc->facts.ioc_num, mrioc->facts.max_op_req_q,
 	    mrioc->facts.max_op_reply_q, mrioc->facts.max_devhandle);
@@ -2798,6 +2819,13 @@ static void mpi3mr_process_factsdata(struct mpi3mr_ioc *mrioc,
 	ioc_info(mrioc, "DMA mask %d InitialPE status 0x%x\n",
 	    mrioc->facts.dma_mask, (facts_flags &
 	    MPI3_IOCFACTS_FLAGS_INITIAL_PORT_ENABLE_MASK));
+	ioc_info(mrioc,
+	    "max_dev_per_throttle_group(%d), max_throttle_groups(%d)\n",
+	    mrioc->facts.max_dev_per_tg, mrioc->facts.max_io_throttle_group);
+	ioc_info(mrioc,
+	   "io_throttle_data_len(%dKiB), io_throttle_high(%dMiB), io_throttle_low(%dMiB)\n",
+	   mrioc->facts.io_throttle_data_length * 4,
+	   mrioc->facts.io_throttle_high, mrioc->facts.io_throttle_low);
 }
 
 /**
@@ -3666,6 +3694,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	int retval = 0;
 	u8 retry = 0;
 	struct mpi3_ioc_facts_data facts_data;
+	u32 sz;
 
 retry_init:
 	retval = mpi3mr_bring_ioc_ready(mrioc);
@@ -3691,6 +3720,9 @@ retry_init:
 
 	mrioc->max_host_ios = mrioc->facts.max_reqs - MPI3MR_INTERNAL_CMDS_RESVD;
 
+	mrioc->num_io_throttle_group = mrioc->facts.max_io_throttle_group;
+	atomic_set(&mrioc->pend_large_data_sz, 0);
+
 	if (reset_devices)
 		mrioc->max_host_ios = min_t(int, mrioc->max_host_ios,
 		    MPI3MR_HOST_IOS_KDUMP);
@@ -3760,6 +3792,15 @@ retry_init:
 		}
 	}
 
+	if (!mrioc->throttle_groups && mrioc->num_io_throttle_group) {
+		dprint_init(mrioc, "allocating memory for throttle groups\n");
+		sz = sizeof(struct mpi3mr_throttle_group_info);
+		mrioc->throttle_groups = (struct mpi3mr_throttle_group_info *)
+		    kcalloc(mrioc->num_io_throttle_group, sz, GFP_KERNEL);
+		if (!mrioc->throttle_groups)
+			goto out_failed_noretry;
+	}
+
 	retval = mpi3mr_enable_events(mrioc);
 	if (retval) {
 		ioc_err(mrioc, "failed to enable events %d\n",
@@ -3981,6 +4022,7 @@ static void mpi3mr_memset_op_req_q_buffers(struct mpi3mr_ioc *mrioc, u16 qidx)
 void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 {
 	u16 i;
+	struct mpi3mr_throttle_group_info *tg;
 
 	mrioc->change_count = 0;
 	mrioc->active_poll_qcount = 0;
@@ -4029,6 +4071,18 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		spin_lock_init(&mrioc->req_qinfo[i].q_lock);
 		mpi3mr_memset_op_req_q_buffers(mrioc, i);
 	}
+
+	atomic_set(&mrioc->pend_large_data_sz, 0);
+	if (mrioc->throttle_groups) {
+		tg = mrioc->throttle_groups;
+		for (i = 0; i < mrioc->num_io_throttle_group; i++, tg++) {
+			tg->id = 0;
+			tg->io_divert = 0;
+			tg->high = 0;
+			tg->low = 0;
+			atomic_set(&tg->pend_large_data_sz, 0);
+		}
+	}
 }
 
 /**
@@ -4663,6 +4717,14 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		ioc_err(mrioc, "Failed to issue soft reset to the ioc\n");
 		goto out;
 	}
+	if (mrioc->num_io_throttle_group !=
+	    mrioc->facts.max_io_throttle_group) {
+		ioc_err(mrioc,
+		    "max io throttle group doesn't match old(%d), new(%d)\n",
+		    mrioc->num_io_throttle_group,
+		    mrioc->facts.max_io_throttle_group);
+		return -EPERM;
+	}
 
 	mpi3mr_flush_delayed_cmd_lists(mrioc);
 	mpi3mr_flush_drv_cmds(mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index da85eda..e1ccb5f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -373,6 +373,9 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc)
 		if (tgtdev->starget && tgtdev->starget->hostdata) {
 			tgt_priv = tgtdev->starget->hostdata;
 			tgt_priv->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+			tgt_priv->io_throttle_enabled = 0;
+			tgt_priv->io_divert = 0;
+			tgt_priv->throttle_group = NULL;
 		}
 	}
 }
@@ -717,6 +720,35 @@ static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_from_tgtpriv(
 	return tgtdev;
 }
 
+/**
+ * mpi3mr_set_io_divert_for_all_vd_in_tg -set divert for TG VDs
+ * @mrioc: Adapter instance reference
+ * @tg: Throttle group information pointer
+ * @divert_value: 1 or 0
+ *
+ * Accessor to set io_divert flag for each device associated
+ * with the given throttle group with the given value.
+ *
+ * Return: None.
+ */
+static void mpi3mr_set_io_divert_for_all_vd_in_tg(struct mpi3mr_ioc *mrioc,
+	struct mpi3mr_throttle_group_info *tg, u8 divert_value)
+{
+	unsigned long flags;
+	struct mpi3mr_tgt_dev *tgtdev;
+	struct mpi3mr_stgt_priv_data *tgt_priv;
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
+		if (tgtdev->starget && tgtdev->starget->hostdata) {
+			tgt_priv = tgtdev->starget->hostdata;
+			if (tgt_priv->throttle_group == tg)
+				tgt_priv->io_divert = divert_value;
+		}
+	}
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+}
+
 /**
  * mpi3mr_print_device_event_notice - print notice related to post processing of
  *					device event after controller reset.
@@ -934,6 +966,7 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
  * @mrioc: Adapter instance reference
  * @tgtdev: Target device internal structure
  * @dev_pg0: New device page0
+ * @is_added: Flag to indicate the device is just added
  *
  * Update the information from the device page0 into the driver
  * cached target device structure.
@@ -941,10 +974,11 @@ void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc)
  * Return: Nothing.
  */
 static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
-	struct mpi3mr_tgt_dev *tgtdev, struct mpi3_device_page0 *dev_pg0)
+	struct mpi3mr_tgt_dev *tgtdev, struct mpi3_device_page0 *dev_pg0,
+	bool is_added)
 {
 	u16 flags = 0;
-	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data;
+	struct mpi3mr_stgt_priv_data *scsi_tgt_priv_data = NULL;
 	u8 prot_mask = 0;
 
 	tgtdev->perst_id = le16_to_cpu(dev_pg0->persistent_id);
@@ -959,12 +993,19 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 	flags = le16_to_cpu(dev_pg0->flags);
 	tgtdev->is_hidden = (flags & MPI3_DEVICE0_FLAGS_HIDDEN);
 
+	if (is_added == true)
+		tgtdev->io_throttle_enabled =
+		    (flags & MPI3_DEVICE0_FLAGS_IO_THROTTLING_REQUIRED) ? 1 : 0;
+
+
 	if (tgtdev->starget && tgtdev->starget->hostdata) {
 		scsi_tgt_priv_data = (struct mpi3mr_stgt_priv_data *)
 		    tgtdev->starget->hostdata;
 		scsi_tgt_priv_data->perst_id = tgtdev->perst_id;
 		scsi_tgt_priv_data->dev_handle = tgtdev->dev_handle;
 		scsi_tgt_priv_data->dev_type = tgtdev->dev_type;
+		scsi_tgt_priv_data->io_throttle_enabled =
+		    tgtdev->io_throttle_enabled;
 	}
 
 	switch (dev_pg0->access_status) {
@@ -1042,10 +1083,27 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 	{
 		struct mpi3_device0_vd_format *vdinf =
 		    &dev_pg0->device_specific.vd_format;
+		struct mpi3mr_throttle_group_info *tg = NULL;
+		u16 vdinf_io_throttle_group =
+		    le16_to_cpu(vdinf->io_throttle_group);
 
-		tgtdev->dev_spec.vol_inf.state = vdinf->vd_state;
+		tgtdev->dev_spec.vd_inf.state = vdinf->vd_state;
 		if (vdinf->vd_state == MPI3_DEVICE0_VD_STATE_OFFLINE)
 			tgtdev->is_hidden = 1;
+		tgtdev->dev_spec.vd_inf.tg_id = vdinf_io_throttle_group;
+		tgtdev->dev_spec.vd_inf.tg_high =
+		    le16_to_cpu(vdinf->io_throttle_group_high) * 2048;
+		tgtdev->dev_spec.vd_inf.tg_low =
+		    le16_to_cpu(vdinf->io_throttle_group_low) * 2048;
+		if (vdinf_io_throttle_group < mrioc->num_io_throttle_group) {
+			tg = mrioc->throttle_groups + vdinf_io_throttle_group;
+			tg->id = vdinf_io_throttle_group;
+			tg->high = tgtdev->dev_spec.vd_inf.tg_high;
+			tg->low = tgtdev->dev_spec.vd_inf.tg_low;
+		}
+		tgtdev->dev_spec.vd_inf.tg = tg;
+		if (scsi_tgt_priv_data)
+			scsi_tgt_priv_data->throttle_group = tg;
 		break;
 	}
 	default:
@@ -1142,7 +1200,7 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
 	if (!tgtdev)
 		goto out;
-	mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0);
+	mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, false);
 	if (!tgtdev->is_hidden && !tgtdev->host_exposed)
 		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
 	if (tgtdev->is_hidden && tgtdev->host_exposed)
@@ -1548,13 +1606,13 @@ static int mpi3mr_create_tgtdev(struct mpi3mr_ioc *mrioc,
 	perst_id = le16_to_cpu(dev_pg0->persistent_id);
 	tgtdev = mpi3mr_get_tgtdev_by_perst_id(mrioc, perst_id);
 	if (tgtdev) {
-		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0);
+		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, true);
 		mpi3mr_tgtdev_put(tgtdev);
 	} else {
 		tgtdev = mpi3mr_alloc_tgtdev();
 		if (!tgtdev)
 			return -ENOMEM;
-		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0);
+		mpi3mr_update_tgtdev(mrioc, tgtdev, dev_pg0, true);
 		mpi3mr_tgtdev_add_to_list(mrioc, tgtdev);
 	}
 
@@ -2566,6 +2624,11 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 	u32 xfer_count = 0, sense_count = 0, resp_data = 0;
 	u16 dev_handle = 0xFFFF;
 	struct scsi_sense_hdr sshdr;
+	struct mpi3mr_stgt_priv_data *stgt_priv_data = NULL;
+	struct mpi3mr_sdev_priv_data *sdev_priv_data = NULL;
+	u32 ioc_pend_data_len = 0, tg_pend_data_len = 0, data_len_blks = 0;
+	struct mpi3mr_throttle_group_info *tg = NULL;
+	u8 throttle_enabled_dev = 0;
 
 	*reply_dma = 0;
 	reply_desc_type = le16_to_cpu(reply_desc->reply_flags) &
@@ -2622,6 +2685,51 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		goto out;
 	}
 	priv = scsi_cmd_priv(scmd);
+
+	data_len_blks = scsi_bufflen(scmd) >> 9;
+	sdev_priv_data = scmd->device->hostdata;
+	if (sdev_priv_data) {
+		stgt_priv_data = sdev_priv_data->tgt_priv_data;
+		if (stgt_priv_data) {
+			tg = stgt_priv_data->throttle_group;
+			throttle_enabled_dev =
+			    stgt_priv_data->io_throttle_enabled;
+		}
+	}
+	if (unlikely((data_len_blks >= mrioc->io_throttle_data_length) &&
+	    throttle_enabled_dev)) {
+		ioc_pend_data_len = atomic_sub_return(data_len_blks,
+		    &mrioc->pend_large_data_sz);
+		if (tg) {
+			tg_pend_data_len = atomic_sub_return(data_len_blks,
+			    &tg->pend_large_data_sz);
+			if (tg->io_divert  && ((ioc_pend_data_len <=
+			    mrioc->io_throttle_low) &&
+			    (tg_pend_data_len <= tg->low))) {
+				tg->io_divert = 0;
+				mpi3mr_set_io_divert_for_all_vd_in_tg(
+				    mrioc, tg, 0);
+			}
+		} else {
+			if (ioc_pend_data_len <= mrioc->io_throttle_low)
+				stgt_priv_data->io_divert = 0;
+		}
+	} else if (unlikely((stgt_priv_data && stgt_priv_data->io_divert))) {
+		ioc_pend_data_len = atomic_read(&mrioc->pend_large_data_sz);
+		if (!tg) {
+			if (ioc_pend_data_len <= mrioc->io_throttle_low)
+				stgt_priv_data->io_divert = 0;
+
+		} else if (ioc_pend_data_len <= mrioc->io_throttle_low) {
+			tg_pend_data_len = atomic_read(&tg->pend_large_data_sz);
+			if (tg->io_divert  && (tg_pend_data_len <= tg->low)) {
+				tg->io_divert = 0;
+				mpi3mr_set_io_divert_for_all_vd_in_tg(
+				    mrioc, tg, 0);
+			}
+		}
+	}
+
 	if (success_desc) {
 		scmd->result = DID_OK << 16;
 		goto out_success;
@@ -3842,6 +3950,11 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 		tgt_dev->starget = starget;
 		atomic_set(&scsi_tgt_priv_data->block_io, 0);
 		retval = 0;
+		scsi_tgt_priv_data->io_throttle_enabled =
+		    tgt_dev->io_throttle_enabled;
+		if (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_VD)
+			scsi_tgt_priv_data->throttle_group =
+			    tgt_dev->dev_spec.vd_inf.tg;
 	} else
 		retval = -ENXIO;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
@@ -3997,10 +4110,13 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 	int retval = 0;
 	u16 dev_handle;
 	u16 host_tag;
-	u32 scsiio_flags = 0;
+	u32 scsiio_flags = 0, data_len_blks = 0;
 	struct request *rq = scsi_cmd_to_rq(scmd);
 	int iprio_class;
 	u8 is_pcie_dev = 0;
+	u32 tracked_io_sz = 0;
+	u32 ioc_pend_data_len = 0, tg_pend_data_len = 0;
+	struct mpi3mr_throttle_group_info *tg = NULL;
 
 	if (mrioc->unrecoverable) {
 		scmd->result = DID_ERROR << 16;
@@ -4104,11 +4220,48 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
 		goto out;
 	}
 	op_req_q = &mrioc->req_qinfo[scmd_priv_data->req_q_idx];
+		data_len_blks = scsi_bufflen(scmd) >> 9;
+	if ((data_len_blks >= mrioc->io_throttle_data_length) &&
+	    stgt_priv_data->io_throttle_enabled) {
+		tracked_io_sz = data_len_blks;
+		tg = stgt_priv_data->throttle_group;
+		if (tg) {
+			ioc_pend_data_len = atomic_add_return(data_len_blks,
+			    &mrioc->pend_large_data_sz);
+			tg_pend_data_len = atomic_add_return(data_len_blks,
+			    &tg->pend_large_data_sz);
+			if (!tg->io_divert  && ((ioc_pend_data_len >=
+			    mrioc->io_throttle_high) ||
+			    (tg_pend_data_len >= tg->high))) {
+				tg->io_divert = 1;
+				mpi3mr_set_io_divert_for_all_vd_in_tg(mrioc,
+				    tg, 1);
+			}
+		} else {
+			ioc_pend_data_len = atomic_add_return(data_len_blks,
+			    &mrioc->pend_large_data_sz);
+			if (ioc_pend_data_len >= mrioc->io_throttle_high)
+				stgt_priv_data->io_divert = 1;
+		}
+	}
+
+	if (stgt_priv_data->io_divert) {
+		scsiio_req->msg_flags |=
+		    MPI3_SCSIIO_MSGFLAGS_DIVERT_TO_FIRMWARE;
+		scsiio_flags |= MPI3_SCSIIO_FLAGS_DIVERT_REASON_IO_THROTTLING;
+	}
+	scsiio_req->flags = cpu_to_le32(scsiio_flags);
 
 	if (mpi3mr_op_request_post(mrioc, op_req_q,
 	    scmd_priv_data->mpi3mr_scsiio_req)) {
 		mpi3mr_clear_scmd_priv(mrioc, scmd);
 		retval = SCSI_MLQUEUE_HOST_BUSY;
+		if (tracked_io_sz) {
+			atomic_sub(tracked_io_sz, &mrioc->pend_large_data_sz);
+			if (tg)
+				atomic_sub(tracked_io_sz,
+				    &tg->pend_large_data_sz);
+		}
 		goto out;
 	}
 
-- 
2.27.0


--0000000000000e820205e35058f5
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFvZirXdyYtg3IC0iEZs
EDncAFyL6CAeqwiO6T/PezNaMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcwODE5MzgxN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCVAp5gp59WyOM/Xf5qlaPo4pnAL6B0DyuWCmum
gidrdtCzIUy2nSazkRQZdrLk/TtFyi79UoNEUeAlzsX0nj4xbp7ziL9prtM/qWa7y/0eOJCnRc93
TwZ02qBfW8MVe4XFCo2GHyUgTJSwexv9lvTzz69r/tBwYZzQAcKr0cWRmww+YREVPutbICECqbis
6425IGzRC8HIcQzRat/pQvqYlSLESuNmkV8Vw/H1t3HE57VU80CpM72CEoWIvtms/Mhi9ZGvZmVH
a1r5NG/z2joeaY3v1qi+xzRKYqBTXf0PTOAf2ujul9GDRTI/Q+Uav2dahVf038D5bulaOtViiFfF
--0000000000000e820205e35058f5--
