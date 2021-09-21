Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MIME_HEADER_CTYPE_ONLY,
	SPF_HELO_NONE,SPF_PASS,T_TVD_MIME_NO_HEADERS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33641C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E2561186
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Sep 2021 18:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhIUSsD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Sep 2021 14:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbhIUSrq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Sep 2021 14:47:46 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFABAC061574
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:17 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n18so23057plp.7
        for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2021 11:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OwPy8zKfimZJx9Q6nVxwgwiPC8w/5O5PvtDTTl2lDPI=;
        b=UQ6z5717uPjJK/7CLP0jXw/FBFWR2iW47vH2vcSckbT9AMBVeMRALM1p0j2NS1Gjko
         Y9DL0LRwl/mrmjePDodhnpjJzC+qMcudLXliL66L4tUXmCxXtAKFolTheTte9mWjmV0s
         rNu3mdeEsvsB83RSn7RrLNRu8Y3cdlPbrDQKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OwPy8zKfimZJx9Q6nVxwgwiPC8w/5O5PvtDTTl2lDPI=;
        b=hzEzkgdJmccItKyRWR5Ww3i/7mLZGDB+L0Bi/QHTMksj4vdV2Gc+XkSobj9XcaBUhU
         /QTAhvQgtgxVv2h1slfh42RRc0WMETKOsndAn+ZAyZB8lj7ztTfCoYOyd+hmkbp3Y/bE
         ZwFaL3CZ7mFruCvhqifwRjxaNCq/HJbVf00Sf044r0QF/cry91VZFV+PTVb85uW+ajIe
         mm9rMCeRfhg4HrsojShqc1Cmmc8vwf7B/+okWuhvnDWtlxaD2tmEquTROd3cNllD6feL
         RTaOhIBN+v6MljRoEAKoQIS7cuf/pTSlvrcFsP3HNJ8HMJmH2raSfYI4491pEWmiWkhX
         Y85g==
X-Gm-Message-State: AOAM5317caokgMYbS9hsTuAqXq2vly9fr8nhUrIkWW8mY/AT+iNg+xRJ
        qIJmoPuNobRn2QyktvEQLFafKK+uhYlIXfzlGD1ynnNz32JAPxGECLT7jctLgknQOdcKhpdULof
        QM6vpJ6ZC5zmSVAvfw1jBXa4vpATE4IRTFOXBivb22BXT2lazHSM74RD3qF2xXdUseCrM/ewwsy
        rDw/cD96u/
X-Google-Smtp-Source: ABdhPJxM9nnx9LmE5So7j916Lx127/hnVa8CgWEoWlynJ46FPRQ+uQTlj1TlFu6bExVkkjqqdhuS5w==
X-Received: by 2002:a17:90a:53:: with SMTP id 19mr6760513pjb.159.1632249976169;
        Tue, 21 Sep 2021 11:46:16 -0700 (PDT)
Received: from drv-bst-rhel8.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id f144sm18258897pfa.24.2021.09.21.11.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:46:15 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        sathya.prakash@broadcom.com
Subject: [PATCH 3/7] mpi3mr: controller management application support
Date:   Wed, 22 Sep 2021 00:15:56 +0530
Message-Id: <20210921184600.64427-4-kashyap.desai@broadcom.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20210921184600.64427-1-kashyap.desai@broadcom.com>
References: <20210921184600.64427-1-kashyap.desai@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000014efb805cc85d0cc"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000014efb805cc85d0cc

This patch series implements various IOCTL interfaces in the mpi3mr driver
for supporting management applications developed specifically to manage
the Avenger series of the RAID and I/O controllers and devices attached to
those controllers

Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>

Cc: sathya.prakash@broadcom.com
---
 drivers/scsi/mpi3mr/Makefile     |   1 +
 drivers/scsi/mpi3mr/mpi3mr.h     |  23 +
 drivers/scsi/mpi3mr/mpi3mr_app.c | 850 +++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_app.h | 369 ++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_fw.c  |  24 +
 drivers/scsi/mpi3mr/mpi3mr_os.c  |   9 +-
 6 files changed, 1274 insertions(+), 2 deletions(-)
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.c
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.h

diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
index 7c2063e04c81..7c1f79186679 100644
--- a/drivers/scsi/mpi3mr/Makefile
+++ b/drivers/scsi/mpi3mr/Makefile
@@ -2,3 +2,4 @@
 obj-m += mpi3mr.o
 mpi3mr-y +=  mpi3mr_os.o     \
 		mpi3mr_fw.o \
+		mpi3mr_app.o
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 9787b53a2b59..5ae73927590c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -538,6 +538,7 @@ struct mpi3mr_sdev_priv_data {
  * @ioc_status: IOC status from the firmware
  * @ioc_loginfo:IOC log info from the firmware
  * @is_waiting: Is the command issued in block mode
+ * @is_sense: Is Sense data present
  * @retry_count: Retry count for retriable commands
  * @host_tag: Host tag used by the command
  * @callback: Callback for non blocking commands
@@ -553,6 +554,7 @@ struct mpi3mr_drv_cmd {
 	u16 ioc_status;
 	u32 ioc_loginfo;
 	u8 is_waiting;
+	bool is_sense;
 	u8 retry_count;
 	u16 host_tag;
 
@@ -679,6 +681,7 @@ struct scmd_priv {
  * @chain_bitmap_sz: Chain buffer allocator bitmap size
  * @chain_bitmap: Chain buffer allocator bitmap
  * @chain_buf_lock: Chain buffer list lock
+ * @ioctl_cmds: Command tracker for IOCTL command
  * @host_tm_cmds: Command tracker for task management commands
  * @dev_rmhs_cmds: Command tracker for device removal commands
  * @devrem_bitmap_sz: Device removal bitmap size
@@ -690,6 +693,7 @@ struct scmd_priv {
  * @fault_dbg: Fault debug flag
  * @reset_in_progress: Reset in progress flag
  * @unrecoverable: Controller unrecoverable flag
+ * @block_ioctls: Block IOCTL flag
  * @reset_mutex: Controller reset mutex
  * @reset_waitq: Controller reset  wait queue
  * @diagsave_timeout: Diagnostic information save timeout
@@ -699,6 +703,9 @@ struct scmd_priv {
  * @driver_info: Driver, Kernel, OS information to firmware
  * @change_count: Topology change count
  * @op_reply_q_offset: Operational reply queue offset with MSIx
+ * @logdata_buf: Circular buffer to store log data entries
+ * @logdata_buf_idx: Index of entry in buffer to store
+ * @logdata_entry_sz: log data entry size
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -803,6 +810,7 @@ struct mpi3mr_ioc {
 	void *chain_bitmap;
 	spinlock_t chain_buf_lock;
 
+	struct mpi3mr_drv_cmd ioctl_cmds;
 	struct mpi3mr_drv_cmd host_tm_cmds;
 	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
 	u16 devrem_bitmap_sz;
@@ -815,6 +823,7 @@ struct mpi3mr_ioc {
 	u8 fault_dbg;
 	u8 reset_in_progress;
 	u8 unrecoverable;
+	u8 block_ioctls;
 	struct mutex reset_mutex;
 	wait_queue_head_t reset_waitq;
 
@@ -826,6 +835,10 @@ struct mpi3mr_ioc {
 	struct mpi3_driver_info_layout driver_info;
 	u16 change_count;
 	u16 op_reply_q_offset;
+
+	u8 *logdata_buf;
+	u16 logdata_buf_idx;
+	u16 logdata_entry_sz;
 };
 
 /**
@@ -889,6 +902,13 @@ void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mrioc,
 void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc);
 void mpi3mr_os_handle_events(struct mpi3mr_ioc *mrioc,
 			     struct mpi3_event_notification_reply *event_reply);
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
+				struct mpi3mr_ioc *mrioc, u16 handle);
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_perst_id(
+				struct mpi3mr_ioc *mrioc, u16 persist_id);
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_from_tgtpriv(
+				struct mpi3mr_ioc *mrioc,
+				struct mpi3mr_stgt_priv_data *tgt_priv);
 void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 				  struct mpi3_default_reply_descriptor *reply_desc,
 				  u64 *reply_dma, u16 qidx);
@@ -913,4 +933,7 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *mrioc);
 void mpi3mr_rfresh_tgtdevs(struct mpi3mr_ioc *mrioc);
 void mpi3mr_flush_delayed_rmhs_list(struct mpi3mr_ioc *mrioc);
 
+void mpi3mr_app_init(void);
+void mpi3mr_app_exit(void);
+
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
new file mode 100644
index 000000000000..021615889dcd
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -0,0 +1,850 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Driver for Broadcom MPI3 Storage Controllers
+ *
+ * Copyright (C) 2017-2021 Broadcom Inc.
+ *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
+ *
+ */
+
+#include "mpi3mr.h"
+#include "mpi3mr_app.h"
+
+static struct fasync_struct *mpi3mr_app_async_queue;
+
+/**
+ * mpi3mr_verify_adapter - verify adapter number is valid
+ * @ioc_number: Adapter number
+ * @mriocpp: Pointer to hold per adapter instance
+ *
+ * This function checks whether given adapter number matches
+ * with an adapter id in the driver's list and if so fills
+ * pointer to the per adapter instance in mriocpp else set that
+ * to NULL.
+ *
+ * Return: Nothing.
+ */
+static void mpi3mr_verify_adapter(int ioc_number, struct mpi3mr_ioc **mriocpp)
+{
+	struct mpi3mr_ioc *mrioc;
+
+	spin_lock(&mrioc_list_lock);
+	list_for_each_entry(mrioc, &mrioc_list, list) {
+		if (mrioc->id != ioc_number)
+			continue;
+		spin_unlock(&mrioc_list_lock);
+		*mriocpp = mrioc;
+		return;
+	}
+	spin_unlock(&mrioc_list_lock);
+	*mriocpp = NULL;
+}
+
+/**
+ * mpi3mr_get_all_tgt_info - Get all target information
+ * @mrioc: Adapter instance reference
+ * @data_in_buf: User buffer to copy the target information
+ * @data_in_sz: length of the user buffer.
+ *
+ * This function copies the driver managed target devices device
+ * handle, persistent ID, bus ID and taret ID to the user
+ * provided buffer for the specific controller. This function
+ * also provides the number of devices managed by the driver for
+ * the specific controller.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
+		void __user *data_in_buf, uint32_t data_in_sz)
+{
+	long rval = 0, devmap_info_sz;
+	u16 num_devices = 0, i = 0;
+	unsigned long flags;
+	struct mpi3mr_tgt_dev *tgtdev;
+	struct mpi3mr_device_map_info *devmap_info = NULL;
+	struct mpi3mr_all_tgt_info __user *all_tgt_info =
+		(struct mpi3mr_all_tgt_info *)data_in_buf;
+	u32 min_entrylen, kern_entrylen = 0, usr_entrylen;
+
+	if (data_in_sz < sizeof(u32)) {
+		dbgprint(mrioc, "failure at %s:%d/%s()!\n",
+			 __FILE__, __LINE__, __func__);
+		return -EINVAL;
+	}
+
+	devmap_info_sz = sizeof(struct mpi3mr_device_map_info);
+
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list)
+		num_devices++;
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
+	usr_entrylen = (data_in_sz - sizeof(u32)) / devmap_info_sz;
+	usr_entrylen *= devmap_info_sz;
+
+	if (!num_devices || !usr_entrylen)
+		goto copy_usrbuf;
+
+	devmap_info = kcalloc(num_devices, devmap_info_sz, GFP_KERNEL);
+	if (!devmap_info)
+		return -ENOMEM;
+
+	kern_entrylen = num_devices * devmap_info_sz;
+	memset((u8 *)devmap_info, 0xFF, kern_entrylen);
+	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
+		if (i >= num_devices)
+			break;
+		devmap_info[i].handle = tgtdev->dev_handle;
+		devmap_info[i].perst_id = tgtdev->perst_id;
+		if (tgtdev->host_exposed && tgtdev->starget) {
+			devmap_info[i].target_id = tgtdev->starget->id;
+			devmap_info[i].bus_id = tgtdev->starget->channel;
+		}
+		i++;
+	}
+	num_devices = i;
+	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+
+copy_usrbuf:
+	if (copy_to_user(&all_tgt_info->num_devices, &num_devices,
+			 sizeof(num_devices)))
+		rval = -EFAULT;
+	else {
+		min_entrylen = min(usr_entrylen, kern_entrylen);
+		if (min_entrylen &&
+			copy_to_user(&all_tgt_info->dmi,
+				      devmap_info, min_entrylen))
+			rval = -EFAULT;
+	}
+
+	kfree(devmap_info);
+	return rval;
+}
+
+/**
+ * mpi3mr_enable_logdata - Handler for log data enable IOCTL
+ * @mrioc: Adapter instance reference
+ * @data_in_buf: User buffer to copy the max logdata entry count
+ * @data_in_sz: length of the user buffer.
+ *
+ * This function enables log data caching in the driver if not
+ * already enabled and return the maximum number of log data
+ * entries that can be cached in the driver.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_enable_logdata(struct mpi3mr_ioc *mrioc,
+		void __user *data_in_buf, uint32_t data_in_sz)
+{
+	struct mpi3mr_logdata_enable logdata_enable;
+	u16 entry_size;
+
+	entry_size = mrioc->facts.reply_sz -
+			(sizeof(struct mpi3_event_notification_reply) - 4);
+	entry_size += MPI3MR_IOCTL_LOGDATA_ENTRY_HEADER_SZ;
+	logdata_enable.max_entries = MPI3MR_IOCTL_LOGDATA_MAX_ENTRIES;
+
+	if (!mrioc->logdata_buf) {
+		mrioc->logdata_buf_idx = 0;
+		mrioc->logdata_entry_sz = entry_size;
+		mrioc->logdata_buf =
+			kcalloc(MPI3MR_IOCTL_LOGDATA_MAX_ENTRIES,
+					entry_size, GFP_KERNEL);
+		if (!mrioc->logdata_buf)
+			return -ENOMEM;
+	}
+
+	if (copy_to_user(data_in_buf, &logdata_enable, sizeof(logdata_enable)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
+ * mpi3mr_get_logdata - Handler for get log data  IOCTL
+ * @mrioc: Adapter instance reference
+ * @data_in_buf: User buffer to copy the logdata entries
+ * @data_in_sz: length of the user buffer.
+ *
+ * This function copies the log data entries to the user buffer
+ * when log caching is enabled in the driver.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_get_logdata(struct mpi3mr_ioc *mrioc,
+		void __user *data_in_buf, uint32_t data_in_sz)
+{
+	u16 num_entries, sz, entry_sz;
+
+	entry_sz = mrioc->logdata_entry_sz;
+	if ((!mrioc->logdata_buf) || (data_in_sz < entry_sz))
+		return -EINVAL;
+
+	num_entries = data_in_sz / entry_sz;
+	num_entries = min_t(int, num_entries,
+				MPI3MR_IOCTL_LOGDATA_MAX_ENTRIES);
+	sz = num_entries * entry_sz;
+
+	if (copy_to_user(data_in_buf, mrioc->logdata_buf, sz))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
+ * mpi3mr_get_change_count - Get topology change count
+ * @mrioc: Adapter instance reference
+ * @data_in_buf: User buffer to copy the change count
+ * @data_in_sz: length of the user buffer.
+ *
+ * This function copies the topology change count provided by the
+ * driver in events and cached in the driver to the user
+ * provided buffer for the specific controller.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_get_change_count(struct mpi3mr_ioc *mrioc,
+		void __user *data_in_buf, uint32_t data_in_sz)
+{
+	struct mpi3mr_change_count chgcnt;
+
+	chgcnt.change_count = mrioc->change_count;
+	if (copy_to_user(data_in_buf, &chgcnt, sizeof(chgcnt)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
+ * mpi3mr_ioctl_adp_reset - Issue controller reset
+ * @mrioc: Adapter instance reference
+ * @data_out_buf: User buffer with reset type
+ * @data_out_sz: length of the user buffer.
+ *
+ * This function identifies the user provided reset type and
+ * issues approporiate reset to the controller and.wait for that
+ * to complete and reinitialize the controller and then returns
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_ioctl_adp_reset(struct mpi3mr_ioc *mrioc,
+		void __user *data_out_buf, uint32_t data_out_sz)
+{
+	long rval = 0;
+	struct mpi3mr_ioctl_adp_reset adpreset;
+	u8 save_snapdump;
+
+	if (copy_from_user(&adpreset, data_out_buf, sizeof(adpreset)))
+		return -EFAULT;
+
+	switch (adpreset.reset_type) {
+	case MPI3MR_IOCTL_ADPRESET_SOFT:
+		save_snapdump = 0;
+		break;
+	case MPI3MR_IOCTL_ADPRESET_DIAG_FAULT:
+		save_snapdump = 1;
+		break;
+	default:
+		dbgprint(mrioc, "%s: unknown reset_type(%d)\n",
+		    __func__, adpreset.reset_type);
+		return -EINVAL;
+	}
+
+	rval = mpi3mr_soft_reset_handler(mrioc, MPI3MR_RESET_FROM_IOCTL,
+	    save_snapdump);
+
+	if (rval)
+		dbgprint(mrioc,
+		    "%s: reset handler returned error(%ld) for reset type %d\n",
+		    __func__, rval, adpreset.reset_type);
+
+	return rval;
+}
+
+/**
+ * mpi3mr_populate_adpinfo - Get adapter info IOCTL handler
+ * @mrioc: Adapter instance reference
+ * @data_in_buf: User buffer to hold adapter information
+ * @data_in_sz: length of the user buffer.
+ *
+ * This function provides adapter information for the given
+ * controller
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_populate_adpinfo(struct mpi3mr_ioc *mrioc,
+		void __user *data_in_buf, uint32_t data_in_sz)
+{
+	struct mpi3mr_adp_info adpinfo;
+
+	memset(&adpinfo, 0, sizeof(adpinfo));
+	adpinfo.adp_type = MPI3MR_IOCTL_ADPTYPE_AVGFAMILY;
+	adpinfo.pci_dev_id = mrioc->pdev->device;
+	adpinfo.pci_dev_hw_rev = mrioc->pdev->revision;
+	adpinfo.pci_subsys_dev_id = mrioc->pdev->subsystem_device;
+	adpinfo.pci_subsys_ven_id = mrioc->pdev->subsystem_vendor;
+	adpinfo.pci_bus = mrioc->pdev->bus->number;
+	adpinfo.pci_dev = PCI_SLOT(mrioc->pdev->devfn);
+	adpinfo.pci_func = PCI_FUNC(mrioc->pdev->devfn);
+	adpinfo.pci_seg_id = pci_domain_nr(mrioc->pdev->bus);
+	adpinfo.ioctl_ver = MPI3MR_IOCTL_VERSION;
+	memcpy((u8 *)&adpinfo.driver_info, (u8 *)&mrioc->driver_info,
+	       sizeof(adpinfo.driver_info));
+
+	if (copy_to_user(data_in_buf, &adpinfo, sizeof(adpinfo)))
+		return -EFAULT;
+
+	return 0;
+}
+
+/**
+ * mpi3mr_ioctl_process_drv_cmds - Driver IOCTL handler
+ * @mrioc: Adapter instance reference
+ * @arg: User data payload buffer for the IOCTL
+ *
+ * This function is the top level handler for driver commands,
+ * this does basic validation of the buffer and identifies the
+ * opcode and switches to correct sub handler.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long
+mpi3mr_ioctl_process_drv_cmds(struct file *file, void __user *arg)
+{
+	long rval = 0;
+	struct mpi3mr_ioc *mrioc = NULL;
+	struct mpi3mr_ioctl_drv_cmd karg;
+
+	if (copy_from_user(&karg, arg, sizeof(karg)))
+		return -EFAULT;
+
+	mpi3mr_verify_adapter(karg.mrioc_id, &mrioc);
+	if (!mrioc)
+		return -ENODEV;
+
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&mrioc->ioctl_cmds.mutex))
+			return -EAGAIN;
+	} else if (mutex_lock_interruptible(&mrioc->ioctl_cmds.mutex))
+		return -ERESTARTSYS;
+
+	switch (karg.opcode) {
+	case MPI3MR_DRVIOCTL_OPCODE_ADPINFO:
+		rval = mpi3mr_populate_adpinfo(mrioc, karg.data_in_buf,
+					karg.data_in_size);
+		break;
+	case MPI3MR_DRVIOCTL_OPCODE_ADPRESET:
+		rval = mpi3mr_ioctl_adp_reset(mrioc, karg.data_out_buf,
+					karg.data_out_size);
+		break;
+	case MPI3MR_DRVIOCTL_OPCODE_ALLTGTDEVINFO:
+		rval = mpi3mr_get_all_tgt_info(mrioc, karg.data_in_buf,
+					karg.data_in_size);
+		break;
+	case MPI3MR_DRVIOCTL_OPCODE_LOGDATAENABLE:
+		rval = mpi3mr_enable_logdata(mrioc, karg.data_in_buf,
+					karg.data_in_size);
+		break;
+	case MPI3MR_DRVIOCTL_OPCODE_GETLOGDATA:
+		rval = mpi3mr_get_logdata(mrioc, karg.data_in_buf,
+					karg.data_in_size);
+		break;
+	case MPI3MR_DRVIOCTL_OPCODE_GETCHGCNT:
+		rval = mpi3mr_get_change_count(mrioc, karg.data_in_buf,
+					karg.data_in_size);
+		break;
+	case MPI3MR_DRVIOCTL_OPCODE_UNKNOWN:
+	default:
+		rval = -EINVAL;
+		dbgprint(mrioc, "Unsupported drv ioctl opcode 0x%x\n",
+			 karg.opcode);
+		break;
+	}
+	mutex_unlock(&mrioc->ioctl_cmds.mutex);
+	return rval;
+}
+
+/**
+ * mpi3mr_ioctl_build_sgl - SGL consturction for MPI IOCTLs
+ * @mpi_req: MPI request
+ * @sgl_offset: offset to start SGL in the MPI request
+ * @dma_buffers: DMA address of the buffers to be placed in SGL
+ * @bufcnt: Number of DMA buffers
+ * @is_rmc: Does the buffer list has management command buffer
+ * @is_rmr: Does the buffer list has management response buffer
+ * @num_data_sges: Number of data buffers in the list
+ *
+ * This function places the DMA address of the given buffers in
+ * proper format as SGEs in the given MPI request.
+ *
+ * Return: Nothing
+ */
+static void mpi3mr_ioctl_build_sgl(u8 *mpi_req, uint32_t sgl_offset,
+		struct mpi3mr_buf_map *dma_buffers,
+		u8 bufcnt, bool is_rmc, bool is_rmr, u8 num_data_sges)
+{
+	u8 *sgl;
+	u8 sgl_flags, sgl_flags_last, count = 0;
+	struct mpi3_mgmt_passthrough_request *mgmt_pt_req;
+	struct mpi3mr_buf_map *dma_buff;
+
+	sgl = (mpi_req + sgl_offset);
+	mgmt_pt_req = (struct mpi3_mgmt_passthrough_request *)mpi_req;
+	dma_buff = dma_buffers;
+
+	sgl_flags = MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE |
+			MPI3_SGE_FLAGS_DLAS_SYSTEM |
+			MPI3_SGE_FLAGS_END_OF_BUFFER;
+
+	sgl_flags_last = sgl_flags | MPI3_SGE_FLAGS_END_OF_LIST;
+
+	if (is_rmc) {
+		mpi3mr_add_sg_single(&mgmt_pt_req->command_sgl,
+				     sgl_flags_last, dma_buff->kern_buf_len,
+				     dma_buff->kern_buf_dma);
+		sgl = (u8 *)dma_buff->kern_buf + dma_buff->user_buf_len;
+		dma_buff++;
+		count++;
+		if (is_rmr) {
+			mpi3mr_add_sg_single(&mgmt_pt_req->response_sgl,
+					sgl_flags_last,
+					dma_buff->kern_buf_len,
+					dma_buff->kern_buf_dma);
+			dma_buff++;
+			count++;
+		} else
+			mpi3mr_build_zero_len_sge(&mgmt_pt_req->response_sgl);
+	}
+	if (!num_data_sges) {
+		mpi3mr_build_zero_len_sge(sgl);
+		return;
+	}
+	for (; count < bufcnt; count++, dma_buff++) {
+		if (dma_buff->data_dir == DMA_BIDIRECTIONAL)
+			continue;
+		if (num_data_sges == 1 || !is_rmc)
+			mpi3mr_add_sg_single(sgl, sgl_flags_last,
+					     dma_buff->kern_buf_len,
+					     dma_buff->kern_buf_dma);
+		else
+			mpi3mr_add_sg_single(sgl, sgl_flags,
+					     dma_buff->kern_buf_len,
+					     dma_buff->kern_buf_dma);
+		sgl += sizeof(struct mpi3_sge_common);
+		num_data_sges--;
+	}
+}
+
+/**
+ * mpi3mr_ioctl_process_mpt_cmds - MPI Pass through IOCTL handler
+ * @mrioc: Adapter instance reference
+ * @arg: User data payload buffer for the IOCTL
+ *
+ * This function is the top level handler for MPI Pass through
+ * IOCTL, this does basic validation of the input data buffers,
+ * identifies the given buffer types and MPI command, allocates
+ * DMAable memory for user given buffers, constructs SGL
+ * properly and passes the command to the firmware.
+ *
+ * Once the MPI command is completed the driver copies the data
+ * if any and reply, sense information to user provided buffers.
+ * If the command is timed out then issues controller reset
+ * prior to returning.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_ioctl_process_mpt_cmds(struct file *file,
+	void __user *arg)
+{
+	long rval = -EINVAL;
+	struct mpi3mr_ioc *mrioc = NULL;
+	struct mpi3mr_ioctl_mptcmd karg;
+	struct mpi3mr_ioctl_buf_entry_list *buffer_list = NULL;
+	struct mpi3mr_buf_entry *buf_entries = NULL;
+	struct mpi3mr_buf_map *dma_buffers = NULL, *dma_buff;
+	struct mpi3_request_header *mpi_header = NULL;
+	struct mpi3_status_reply_descriptor *status_desc;
+	struct mpi3mr_ioctl_reply_buf *ioctl_reply_buf = NULL;
+	u8 *mpi_req = NULL, *sense_buff_k = NULL;
+	u8 count, bufcnt, din_cnt = 0, dout_cnt = 0;
+	u8 erb_offset = 0xFF, reply_offset = 0xFF, sg_entries = 0;
+	bool invalid_be = false, is_rmcb = false, is_rmrb = false;
+	u32 tmplen;
+
+	if (copy_from_user(&karg, arg, sizeof(karg)))
+		return -EFAULT;
+
+	mpi3mr_verify_adapter(karg.mrioc_id, &mrioc);
+	if (!mrioc)
+		return -ENODEV;
+
+	if (karg.timeout < MPI3MR_IOCTL_DEFAULT_TIMEOUT)
+		karg.timeout = MPI3MR_IOCTL_DEFAULT_TIMEOUT;
+
+	if (!karg.buf_entry_list_size || !karg.mpi_msg_size)
+		return -EINVAL;
+
+	if ((karg.mpi_msg_size * 4) > MPI3MR_ADMIN_REQ_FRAME_SZ)
+		return -EINVAL;
+
+	mpi_req = kzalloc(MPI3MR_ADMIN_REQ_FRAME_SZ, GFP_KERNEL);
+	if (!mpi_req)
+		return -ENOMEM;
+
+	mpi_header = (struct mpi3_request_header *)mpi_req;
+
+	if (copy_from_user(mpi_req, karg.mpi_msg_buf,
+			   (karg.mpi_msg_size * 4)))
+		goto out;
+
+	buffer_list = kzalloc(karg.buf_entry_list_size, GFP_KERNEL);
+	if (!buffer_list) {
+		rval = -ENOMEM;
+		goto out;
+	}
+
+	if (copy_from_user(buffer_list, karg.buf_entry_list,
+			   karg.buf_entry_list_size)) {
+		rval = -EFAULT;
+		goto out;
+	}
+
+	if (!buffer_list->num_of_entries) {
+		rval = -EINVAL;
+		goto out;
+	}
+
+	bufcnt = buffer_list->num_of_entries;
+	dma_buffers = kzalloc((sizeof(struct mpi3mr_buf_map) * bufcnt), GFP_KERNEL);
+	if (!dma_buffers) {
+		rval = -ENOMEM;
+		goto out;
+	}
+
+	buf_entries = buffer_list->buf_entry;
+	dma_buff = dma_buffers;
+	for (count = 0; count < bufcnt; count++, buf_entries++, dma_buff++) {
+		dma_buff->user_buf = buf_entries->buffer;
+		dma_buff->user_buf_len = buf_entries->buf_len;
+
+		switch (buf_entries->buf_type) {
+		case MPI3MR_IOCTL_BUFTYPE_RAIDMGMT_CMD:
+			is_rmcb = true;
+			if (count != 0)
+				invalid_be = true;
+			dma_buff->data_dir = DMA_FROM_DEVICE;
+			break;
+		case MPI3MR_IOCTL_BUFTYPE_RAIDMGMT_RESP:
+			is_rmrb = true;
+			if (count != 1 || !is_rmcb)
+				invalid_be = true;
+			dma_buff->data_dir = DMA_TO_DEVICE;
+			break;
+		case MPI3MR_IOCTL_BUFTYPE_DATA_IN:
+			din_cnt++;
+			if ((din_cnt > 1) && !is_rmcb)
+				invalid_be = true;
+			dma_buff->data_dir = DMA_TO_DEVICE;
+			break;
+		case MPI3MR_IOCTL_BUFTYPE_DATA_OUT:
+			dout_cnt++;
+			if ((dout_cnt > 1) && !is_rmcb)
+				invalid_be = true;
+			dma_buff->data_dir = DMA_FROM_DEVICE;
+			break;
+		case MPI3MR_IOCTL_BUFTYPE_MPI_REPLY:
+			reply_offset = count;
+			dma_buff->data_dir = DMA_BIDIRECTIONAL;
+			break;
+		case MPI3MR_IOCTL_BUFTYPE_ERR_RESPONSE:
+			erb_offset = count;
+			dma_buff->data_dir = DMA_BIDIRECTIONAL;
+			break;
+		default:
+			invalid_be = true;
+			break;
+		}
+		if (invalid_be)
+			break;
+	}
+	if (invalid_be) {
+		rval = -EINVAL;
+		goto out;
+	}
+
+	if (!is_rmcb && (dout_cnt || din_cnt)) {
+		sg_entries = dout_cnt + din_cnt;
+		if (((karg.mpi_msg_size * 4) + (sg_entries *
+		      sizeof(struct mpi3_sge_common))) > MPI3MR_ADMIN_REQ_FRAME_SZ) {
+			rval = -EINVAL;
+			goto out;
+		}
+	}
+
+	dma_buff = dma_buffers;
+	for (count = 0; count < bufcnt; count++, dma_buff++) {
+		dma_buff->kern_buf_len = dma_buff->user_buf_len;
+		if (is_rmcb && !count)
+			dma_buff->kern_buf_len += ((dout_cnt + din_cnt) *
+			    sizeof(struct mpi3_sge_common));
+		if ((count == reply_offset) || (count == erb_offset)) {
+			dma_buff->kern_buf_len = 0;
+			continue;
+		}
+		if (!dma_buff->kern_buf_len)
+			continue;
+
+		dma_buff->kern_buf = dma_alloc_coherent(&mrioc->pdev->dev,
+						dma_buff->kern_buf_len,
+						&dma_buff->kern_buf_dma,
+						GFP_KERNEL);
+		if (!dma_buff->kern_buf) {
+			rval = -ENOMEM;
+			goto out;
+		}
+		if (dma_buff->data_dir == DMA_FROM_DEVICE) {
+			tmplen = min(dma_buff->kern_buf_len,
+					dma_buff->user_buf_len);
+			if (copy_from_user(dma_buff->kern_buf,
+					dma_buff->user_buf, tmplen)) {
+				rval = -EFAULT;
+				goto out;
+			}
+		}
+	}
+	if (erb_offset != 0xFF) {
+		sense_buff_k = kzalloc(MPI3MR_SENSE_BUF_SZ, GFP_KERNEL);
+		if (!sense_buff_k) {
+			rval = -ENOMEM;
+			goto out;
+		}
+	}
+
+	if (mpi_header->function != MPI3_FUNCTION_NVME_ENCAPSULATED)
+		mpi3mr_ioctl_build_sgl(mpi_req, (karg.mpi_msg_size * 4),
+					dma_buffers, bufcnt, is_rmcb,
+					is_rmrb, (dout_cnt + din_cnt));
+
+	if (file->f_flags & O_NONBLOCK) {
+		if (!mutex_trylock(&mrioc->ioctl_cmds.mutex)) {
+			rval = -EAGAIN;
+			goto out;
+		}
+	} else if (mutex_lock_interruptible(&mrioc->ioctl_cmds.mutex)) {
+		rval = -ERESTARTSYS;
+		goto out;
+	}
+	if (mrioc->ioctl_cmds.state & MPI3MR_CMD_PENDING) {
+		rval = -EAGAIN;
+		dbgprint(mrioc, "%s command is in use\n", __func__);
+		mutex_unlock(&mrioc->ioctl_cmds.mutex);
+		goto out;
+	}
+	if (mrioc->reset_in_progress) {
+		dbgprint(mrioc, "%s reset in progress\n", __func__);
+		rval = -EAGAIN;
+		mutex_unlock(&mrioc->ioctl_cmds.mutex);
+		goto out;
+	}
+	if (mrioc->block_ioctls) {
+		dbgprint(mrioc, "%s IOCTLs are blocked\n", __func__);
+		rval = -EAGAIN;
+		mutex_unlock(&mrioc->ioctl_cmds.mutex);
+		goto out;
+	}
+
+	mrioc->ioctl_cmds.state = MPI3MR_CMD_PENDING;
+	mrioc->ioctl_cmds.is_waiting = 1;
+	mrioc->ioctl_cmds.callback = NULL;
+	mrioc->ioctl_cmds.is_sense = false;
+	mrioc->ioctl_cmds.sensebuf = sense_buff_k;
+	memset(mrioc->ioctl_cmds.reply, 0, mrioc->facts.reply_sz);
+	mpi_header->host_tag = cpu_to_le16(MPI3MR_HOSTTAG_IOCTLCMDS);
+	init_completion(&mrioc->ioctl_cmds.done);
+	rval = mpi3mr_admin_request_post(mrioc, mpi_req,
+					 MPI3MR_ADMIN_REQ_FRAME_SZ, 0);
+	if (rval) {
+		rval = -EAGAIN;
+		goto out_unlock;
+	}
+	wait_for_completion_timeout(&mrioc->ioctl_cmds.done,
+				    (karg.timeout * HZ));
+	if (!(mrioc->ioctl_cmds.state & MPI3MR_CMD_COMPLETE)) {
+		mrioc->ioctl_cmds.is_waiting = 0;
+		dbgprint(mrioc, "%s command timed out\n", __func__);
+		rval = -EFAULT;
+		mpi3mr_soft_reset_handler(mrioc,
+				MPI3MR_RESET_FROM_IOCTL_TIMEOUT, 1);
+		goto out_unlock;
+	}
+
+	if ((mrioc->ioctl_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
+	     != MPI3_IOCSTATUS_SUCCESS) {
+		dbgprint(mrioc,
+			"%s ioc_status(0x%04x)  Loginfo(0x%08x)\n", __func__,
+			(mrioc->ioctl_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK),
+			mrioc->ioctl_cmds.ioc_loginfo);
+	}
+
+	if ((reply_offset != 0xFF) && dma_buffers[reply_offset].user_buf_len) {
+		dma_buff = &dma_buffers[reply_offset];
+		dma_buff->kern_buf_len =
+			(sizeof(struct mpi3mr_ioctl_reply_buf) - 1
+			+ mrioc->facts.reply_sz);
+		ioctl_reply_buf = kzalloc(dma_buff->kern_buf_len, GFP_KERNEL);
+
+		if (!ioctl_reply_buf) {
+			rval = -ENOMEM;
+			goto out_unlock;
+		}
+		if (mrioc->ioctl_cmds.state & MPI3MR_CMD_REPLY_VALID) {
+			ioctl_reply_buf->mpi_reply_type =
+				MPI3MR_IOCTL_MPI_REPLY_BUFTYPE_ADDRESS;
+			memcpy(ioctl_reply_buf->ioctl_reply_buf,
+					mrioc->ioctl_cmds.reply,
+					mrioc->facts.reply_sz);
+		} else {
+			ioctl_reply_buf->mpi_reply_type =
+				MPI3MR_IOCTL_MPI_REPLY_BUFTYPE_STATUS;
+			status_desc = (struct mpi3_status_reply_descriptor *)
+				ioctl_reply_buf->ioctl_reply_buf;
+			status_desc->ioc_status = mrioc->ioctl_cmds.ioc_status;
+			status_desc->ioc_log_info = mrioc->ioctl_cmds.ioc_loginfo;
+		}
+		tmplen = min(dma_buff->kern_buf_len, dma_buff->user_buf_len);
+		if (copy_to_user(dma_buff->user_buf, ioctl_reply_buf, tmplen)) {
+			rval = -EFAULT;
+			goto out_unlock;
+		}
+	}
+
+	if (erb_offset != 0xFF && mrioc->ioctl_cmds.sensebuf &&
+	    mrioc->ioctl_cmds.is_sense) {
+		dma_buff = &dma_buffers[erb_offset];
+		tmplen = min_t(int, dma_buff->user_buf_len,
+				MPI3MR_SENSE_BUF_SZ);
+		if (copy_to_user(dma_buff->user_buf, sense_buff_k, tmplen)) {
+			rval = -EFAULT;
+			goto out_unlock;
+		}
+	}
+
+	dma_buff = dma_buffers;
+	for (count = 0; count < bufcnt; count++, dma_buff++) {
+		if (dma_buff->data_dir == DMA_TO_DEVICE) {
+			tmplen = min(dma_buff->kern_buf_len,
+					dma_buff->user_buf_len);
+			if (copy_to_user(dma_buff->user_buf,
+					dma_buff->kern_buf, tmplen))
+				rval = -EFAULT;
+		}
+	}
+
+out_unlock:
+	mrioc->ioctl_cmds.is_sense = false;
+	mrioc->ioctl_cmds.sensebuf = NULL;
+	mrioc->ioctl_cmds.state = MPI3MR_CMD_NOTUSED;
+	mutex_unlock(&mrioc->ioctl_cmds.mutex);
+out:
+	kfree(sense_buff_k);
+	kfree(buffer_list);
+	kfree(mpi_req);
+	if (dma_buffers) {
+		dma_buff = dma_buffers;
+		for (count = 0; count < bufcnt; count++, dma_buff++) {
+			if (dma_buff->kern_buf && dma_buff->kern_buf_dma)
+				dma_free_coherent(&mrioc->pdev->dev,
+						dma_buff->kern_buf_len,
+						dma_buff->kern_buf,
+						dma_buff->kern_buf_dma);
+		}
+		kfree(dma_buffers);
+	}
+	kfree(ioctl_reply_buf);
+	return rval;
+}
+
+/**
+ * mpi3mr_ioctl - Main IOCTL handler
+ * @file: File pointer
+ * @cmd: IOCTL command
+ * @arg: User data payload buffer for the IOCTL
+ *
+ * This is main IOCTL handler which checks the command type and
+ * executes proper sub handler specific for the command.
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+static long mpi3mr_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	long rval = -EINVAL;
+
+	switch (cmd) {
+	case MPI3MRDRVCMD:
+		if (_IOC_SIZE(cmd) == sizeof(struct mpi3mr_ioctl_drv_cmd))
+			rval = mpi3mr_ioctl_process_drv_cmds(file,
+					(void __user *)arg);
+		break;
+	case MPI3MRMPTCMD:
+		if (_IOC_SIZE(cmd) == sizeof(struct mpi3mr_ioctl_mptcmd))
+			rval = mpi3mr_ioctl_process_mpt_cmds(file,
+					(void __user *)arg);
+		break;
+	default:
+		pr_err("%s:Unsupported ioctl cmd (0x%08x)\n", __func__, cmd);
+		break;
+	}
+	return rval;
+}
+
+/**
+ * mpi3mr_app_fasync - fasync callback
+ * @fd: File descriptor
+ * @filep: File pointer
+ * @mode: Mode
+ *
+ * Return: fasync_helper() returned value
+ */
+static int mpi3mr_app_fasync(int fd, struct file *filep, int mode)
+{
+	return fasync_helper(fd, filep, mode, &mpi3mr_app_async_queue);
+}
+
+static const struct file_operations mpi3mr_app_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = mpi3mr_ioctl,
+	.fasync = mpi3mr_app_fasync,
+};
+
+static struct miscdevice mpi3mr_app_dev = {
+	.minor  = MPI3MR_MINOR,
+	.name   = MPI3MR_DEV_NAME,
+	.fops   = &mpi3mr_app_fops,
+};
+
+/**
+ * mpi3mr_app_init - Character driver interface initializer
+ *
+ */
+void mpi3mr_app_init(void)
+{
+	mpi3mr_app_async_queue = NULL;
+
+	if (misc_register(&mpi3mr_app_dev) < 0)
+		pr_err("%s can't register misc device [minor=%d]\n",
+		       MPI3MR_DRIVER_NAME, MPI3MR_MINOR);
+}
+
+/**
+ * mpi3mr_app_exit - Character driver interface cleanup function
+ *
+ */
+void mpi3mr_app_exit(void)
+{
+	misc_deregister(&mpi3mr_app_dev);
+}
+
+MODULE_ALIAS_MISCDEV(MPI3MR_MINOR);
+MODULE_ALIAS("devname:" MPI3MR_DEV_NAME);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.h b/drivers/scsi/mpi3mr/mpi3mr_app.h
new file mode 100644
index 000000000000..ec714d210b9e
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.h
@@ -0,0 +1,369 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Driver for Broadcom MPI3 Storage Controllers
+ *
+ * Copyright (C) 2017-2021 Broadcom Inc.
+ *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
+ *
+ */
+
+#ifndef MPI3MR_APP_INTFC_H_INCLUDED
+#define MPI3MR_APP_INTFC_H_INCLUDED
+
+#ifdef __KERNEL__
+#include <linux/miscdevice.h>
+#endif
+
+/*Definitions for IOCTL commands*/
+#define MPI3MR_DEV_NAME			"mpi3mrctl"
+#define MPI3MR_MAGIC_NUMBER		'B'
+
+#define MPI3MR_IOCTL_VERSION		0x05
+
+#define MPI3MR_IOCTL_DEFAULT_TIMEOUT	(60) /*seconds*/
+
+#define MPI3MR_IOCTL_ADPTYPE_UNKNOWN		0
+#define MPI3MR_IOCTL_ADPTYPE_AVGFAMILY		1
+
+#define MPI3MR_IOCTL_ADPRESET_UNKNOWN		0
+#define MPI3MR_IOCTL_ADPRESET_SOFT		1
+#define MPI3MR_IOCTL_ADPRESET_DIAG_FAULT	2
+
+#define MPI3MR_IOCTL_LOGDATA_MAX_ENTRIES	400
+#define MPI3MR_IOCTL_LOGDATA_ENTRY_HEADER_SZ	4
+
+#define MPI3MR_DRVIOCTL_OPCODE_UNKNOWN			0
+#define MPI3MR_DRVIOCTL_OPCODE_ADPINFO			1
+#define MPI3MR_DRVIOCTL_OPCODE_ADPRESET			2
+#define MPI3MR_DRVIOCTL_OPCODE_ALLTGTDEVINFO		4
+#define MPI3MR_DRVIOCTL_OPCODE_GETCHGCNT		5
+#define MPI3MR_DRVIOCTL_OPCODE_LOGDATAENABLE		6
+#define MPI3MR_DRVIOCTL_OPCODE_PELENABLE		7
+#define MPI3MR_DRVIOCTL_OPCODE_GETLOGDATA		8
+#define MPI3MR_DRVIOCTL_OPCODE_QUERY_HDB		9
+#define MPI3MR_DRVIOCTL_OPCODE_REPOST_HDB		10
+#define MPI3MR_DRVIOCTL_OPCODE_UPLOAD_HDB		11
+#define MPI3MR_DRVIOCTL_OPCODE_REFRESH_HDB_TRIGGERS	12
+
+
+#define MPI3MR_IOCTL_BUFTYPE_UNKNOWN		0
+#define MPI3MR_IOCTL_BUFTYPE_RAIDMGMT_CMD	1
+#define MPI3MR_IOCTL_BUFTYPE_RAIDMGMT_RESP	2
+#define MPI3MR_IOCTL_BUFTYPE_DATA_IN		3
+#define MPI3MR_IOCTL_BUFTYPE_DATA_OUT		4
+#define MPI3MR_IOCTL_BUFTYPE_MPI_REPLY		5
+#define MPI3MR_IOCTL_BUFTYPE_ERR_RESPONSE	6
+
+#define MPI3MR_IOCTL_MPI_REPLY_BUFTYPE_UNKNOWN	0
+#define MPI3MR_IOCTL_MPI_REPLY_BUFTYPE_STATUS	1
+#define MPI3MR_IOCTL_MPI_REPLY_BUFTYPE_ADDRESS	2
+
+#define MPI3MR_HDB_BUFTYPE_UNKNOWN		0
+#define MPI3MR_HDB_BUFTYPE_TRACE		1
+#define MPI3MR_HDB_BUFTYPE_FIRMWARE		2
+#define MPI3MR_HDB_BUFTYPE_RESERVED		3
+
+#define MPI3MR_HDB_BUFSTATUS_UNKNOWN		0
+#define MPI3MR_HDB_BUFSTATUS_NOT_ALLOCATED	1
+#define MPI3MR_HDB_BUFSTATUS_POSTED_UNPAUSED	2
+#define MPI3MR_HDB_BUFSTATUS_POSTED_PAUSED	3
+#define MPI3MR_HDB_BUFSTATUS_RELEASED		4
+
+#define MPI3MR_HDB_TRIGGER_TYPE_UNKNOWN		0
+#define MPI3MR_HDB_TRIGGER_TYPE_DIAGFAULT	1
+#define MPI3MR_HDB_TRIGGER_TYPE_ELEMENT		2
+#define MPI3MR_HDB_TRIGGER_TYPE_MASTER		3
+
+/**
+ * struct mpi3mr_adp_info - Adapter information IOCTL
+ * data returned by the driver.
+ *
+ * @adp_type: Adapter type
+ * @rsvd1: Reserved
+ * @pci_dev_id: PCI device ID of the adapter
+ * @pci_dev_hw_rev: PCI revision of the adapter
+ * @pci_subsys_dev_id: PCI subsystem device ID of the adapter
+ * @pci_subsys_ven_id: PCI subsystem vendor ID of the adapter
+ * @pci_dev: PCI device
+ * @pci_func: PCI function
+ * @pci_bus: PCI bus
+ * @pci_seg_id: PCI segment ID
+ * @ioctl_ver: version of the IOCTL definition
+ * @rsvd2: Reserved
+ * @driver_info: Driver Information (Version/Name)
+ */
+struct mpi3mr_adp_info {
+	uint32_t adp_type;
+	uint32_t rsvd1;
+	uint32_t pci_dev_id;
+	uint32_t pci_dev_hw_rev;
+	uint32_t pci_subsys_dev_id;
+	uint32_t pci_subsys_ven_id;
+	uint32_t pci_dev:5;
+	uint32_t pci_func:3;
+	uint32_t pci_bus:24;
+	uint32_t pci_seg_id;
+	uint32_t ioctl_ver;
+	uint32_t rsvd2[3];
+	struct mpi3_driver_info_layout driver_info;
+};
+
+/**
+ * struct mpi3mr_buf_map -  local structure to
+ * track kernel and user buffers associated with an IOCTL
+ * structure.
+ *
+ * @user_buf: User buffer virtual address
+ * @kern_buf: Kernel buffer virtual address
+ * @kern_buf_dma: Kernel buffer DMA address
+ * @user_buf_len: User buffer length
+ * @kern_buf_len: Kernel buffer length
+ * @data_dir: Data direction.
+ */
+struct mpi3mr_buf_map {
+	void __user *user_buf;
+	void *kern_buf;
+	dma_addr_t kern_buf_dma;
+	u32 user_buf_len;
+	u32 kern_buf_len;
+	u8 data_dir;
+};
+
+/**
+ * struct mpi3mr_ioctl_adp_reset - Adapter reset IOCTL
+ * payload data to the driver.
+ *
+ * @reset_type: Reset type
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ */
+struct mpi3mr_ioctl_adp_reset {
+	uint8_t reset_type;
+	uint8_t rsvd1;
+	uint16_t rsvd2;
+};
+
+/**
+ * struct mpi3mr_change_count - Topology change count
+ * returned by the driver.
+ *
+ * @change_count: Topology change count
+ * @rsvd: Reserved
+ */
+struct mpi3mr_change_count {
+	uint16_t change_count;
+	uint16_t rsvd;
+};
+
+/**
+ * struct mpi3mr_device_map_info - Target device mapping
+ * information
+ *
+ * @handle: Firmware device handle
+ * @perst_id: Persistent ID assigned by the firmware
+ * @target_id: Target ID assigned by the driver
+ * @bus_id: Bus ID assigned by the driver
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ */
+struct mpi3mr_device_map_info {
+	uint16_t handle;
+	uint16_t perst_id;
+	uint32_t target_id;
+	uint8_t bus_id;
+	uint8_t rsvd1;
+	uint16_t rsvd2;
+};
+
+/**
+ * struct mpi3mr_all_tgt_info - Target device mapping
+ * information returned by the driver
+ *
+ * @num_devices: The number of devices in driver's inventory
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @dmi: Variable length array of mapping information of targets
+ */
+struct mpi3mr_all_tgt_info {
+	uint16_t num_devices; //The number of devices in driver's inventory
+	uint16_t rsvd1;
+	uint32_t rsvd2;
+	struct mpi3mr_device_map_info dmi[1]; //Variable length Array
+};
+
+/**
+ * struct mpi3mr_logdata_enable - Number of log data
+ * entries saved by the driver returned as payload data for
+ * enable logdata IOCTL by the driver.
+ *
+ * @max_entries: Number of log data entries cached by the driver
+ * @rsvd: Reserved
+ */
+struct mpi3mr_logdata_enable {
+	uint16_t max_entries;
+	uint16_t rsvd;
+};
+
+/**
+ * struct mpi3mr_ioctl_out_pel_enable - PEL enable IOCTL payload
+ * data to the driver.
+ *
+ * @pel_locale: PEL locale to the firmware
+ * @pel_class: PEL class to the firmware
+ * @rsvd: Reserved
+ */
+struct mpi3mr_ioctl_out_pel_enable {
+	uint16_t pel_locale;
+	uint8_t pel_class;
+	uint8_t rsvd;
+};
+
+/**
+ * struct mpi3mr_logdata_entry - Log data entry cached by the
+ * driver.
+ *
+ * @valid_entry: Is the entry valid
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @data: Log entry data of controller specific size
+ */
+struct mpi3mr_logdata_entry {
+	uint8_t valid_entry;
+	uint8_t rsvd1;
+	uint16_t rsvd2;
+	uint8_t data[1]; //Variable length Array
+};
+
+/**
+ * struct mpi3mr_ioctl_in_log_data - Log data entries saved by
+ * the driver returned as payload data for Get logdata IOCTL
+ * by the driver.
+ *
+ * @entry: Log data entry
+ */
+struct mpi3mr_ioctl_in_log_data {
+	struct mpi3mr_logdata_entry entry[1]; //Variable length Array
+};
+
+
+/**
+ * struct mpi3mr_ioctl_drv_cmd -  Generic IOCTL payload data
+ * structure for all driver specific IOCTLS .
+ *
+ * @mrioc_id: Controller ID
+ * @opcode: Driver IOCTL specific opcode
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @data_in_buf: User data buffer pointer of data from driver
+ * @data_out_buf: User data buffer pointer of data to driver
+ * @data_in_size: Data in buffer size
+ * @data_out_size: Data out buffer size
+ */
+struct mpi3mr_ioctl_drv_cmd {
+	uint8_t mrioc_id;
+	uint8_t opcode;
+	uint16_t rsvd1;
+	uint32_t rsvd2;
+#ifdef __KERNEL__
+	void __user *data_in_buf;
+	void __user *data_out_buf;
+#else
+	void *data_in_buf;
+	void *data_out_buf;
+#endif
+	uint32_t data_in_size;
+	uint32_t data_out_size;
+};
+
+/**
+ * struct mpi3mr_ioctl_reply_buf - MPI reply buffer returned
+ * for MPI Passthrough IOCTLs .
+ *
+ * @mpi_reply_type: Type of MPI reply
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @ioctl_reply_buf: Variable Length buffer based on mpirep type
+ */
+struct mpi3mr_ioctl_reply_buf {
+	uint8_t mpi_reply_type;
+	uint8_t rsvd1;
+	uint16_t rsvd2;
+	uint8_t ioctl_reply_buf[1]; /*Variable Length buffer based on mpirep type*/
+};
+
+
+/**
+ * struct mpi3mr_buf_entry - User buffer descriptor for MPI
+ * Passthrough IOCTLs.
+ *
+ * @buf_type: Buffer type
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @buf_len: Buffer length
+ * @buffer: User space buffer address
+ */
+struct mpi3mr_buf_entry {
+	uint8_t buf_type;
+	uint8_t rsvd1;
+	uint16_t rsvd2;
+	uint32_t buf_len;
+#ifdef __KERNEL__
+	void __user *buffer;
+#else
+	void *buffer;
+#endif
+};
+
+/**
+ * struct mpi3mr_ioctl_buf_entry_list - list of user buffer
+ * descriptor for MPI Passthrough IOCTLs.
+ *
+ * @num_of_entries: Number of buffer descriptors
+ * @rsvd1: Reserved
+ * @rsvd2: Reserved
+ * @rsvd3: Reserved
+ * @buf_entry: Variable length array of buffer descriptors
+ */
+struct mpi3mr_ioctl_buf_entry_list {
+	uint8_t num_of_entries;
+	uint8_t rsvd1;
+	uint16_t rsvd2;
+	uint32_t rsvd3;
+	struct mpi3mr_buf_entry buf_entry[1]; //Variable length Array
+};
+
+/**
+ * struct mpi3mr_ioctl_mptcmd -  Generic IOCTL payload data
+ * structure for all MPI Passthrough IOCTLS .
+ *
+ * @mrioc_id: Controller ID
+ * @rsvd1: Reserved
+ * @timeout: MPI command timeout
+ * @rsvd2: Reserved
+ * @mpi_msg_size: MPI message size
+ * @mpi_msg_buf: MPI message
+ * @buf_entry_list: Buffer descriptor list
+ * @buf_entry_list_size: Buffer descriptor list size
+ */
+struct mpi3mr_ioctl_mptcmd {
+	uint8_t mrioc_id;
+	uint8_t rsvd1;
+	uint16_t timeout;
+	uint16_t rsvd2;
+	uint16_t mpi_msg_size;
+#ifdef __KERNEL__
+	void __user *mpi_msg_buf;
+	void __user *buf_entry_list;
+#else
+	void *mpi_msg_buf;
+	void *buf_entry_list;
+#endif
+	uint32_t buf_entry_list_size;
+};
+
+#define MPI3MRDRVCMD	_IOWR(MPI3MR_MAGIC_NUMBER, 1, \
+	struct mpi3mr_ioctl_drv_cmd)
+#define MPI3MRMPTCMD	_IOWR(MPI3MR_MAGIC_NUMBER, 2, \
+	struct mpi3mr_ioctl_mptcmd)
+
+#endif
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 878a4963e2ad..337cbb3ffaaa 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -287,6 +287,8 @@ mpi3mr_get_drv_cmd(struct mpi3mr_ioc *mrioc, u16 host_tag,
 	switch (host_tag) {
 	case MPI3MR_HOSTTAG_INITCMDS:
 		return &mrioc->init_cmds;
+	case MPI3MR_HOSTTAG_IOCTLCMDS:
+		return &mrioc->ioctl_cmds;
 	case MPI3MR_HOSTTAG_BLK_TMS:
 		return &mrioc->host_tm_cmds;
 	case MPI3MR_HOSTTAG_INVALID:
@@ -371,6 +373,11 @@ static void mpi3mr_process_admin_reply_desc(struct mpi3mr_ioc *mrioc,
 				memcpy((u8 *)cmdptr->reply, (u8 *)def_reply,
 				    mrioc->facts.reply_sz);
 			}
+			if (sense_buf && cmdptr->sensebuf) {
+				cmdptr->is_sense = true;
+				memcpy(cmdptr->sensebuf, sense_buf,
+				    MPI3MR_SENSE_BUF_SZ);
+			}
 			if (cmdptr->is_waiting) {
 				complete(&cmdptr->done);
 				cmdptr->is_waiting = 0;
@@ -2454,6 +2461,10 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->init_cmds.reply)
 		goto out_failed;
 
+	mrioc->ioctl_cmds.reply = kzalloc(mrioc->facts.reply_sz, GFP_KERNEL);
+	if (!mrioc->ioctl_cmds.reply)
+		goto out_failed;
+
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++) {
 		mrioc->dev_rmhs_cmds[i].reply = kzalloc(mrioc->facts.reply_sz,
 		    GFP_KERNEL);
@@ -3505,6 +3516,7 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 	memset(mrioc->admin_reply_base, 0, mrioc->admin_reply_q_sz);
 
 	memset(mrioc->init_cmds.reply, 0, sizeof(*mrioc->init_cmds.reply));
+	memset(mrioc->ioctl_cmds.reply, 0, sizeof(*mrioc->ioctl_cmds.reply));
 	memset(mrioc->host_tm_cmds.reply, 0,
 	    sizeof(*mrioc->host_tm_cmds.reply));
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
@@ -3601,6 +3613,9 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 	kfree(mrioc->init_cmds.reply);
 	mrioc->init_cmds.reply = NULL;
 
+	kfree(mrioc->ioctl_cmds.reply);
+	mrioc->ioctl_cmds.reply = NULL;
+
 	kfree(mrioc->host_tm_cmds.reply);
 	mrioc->host_tm_cmds.reply = NULL;
 
@@ -3644,6 +3659,9 @@ static void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
+
+	kfree(mrioc->logdata_buf);
+	mrioc->logdata_buf = NULL;
 }
 
 /**
@@ -3788,6 +3806,10 @@ static void mpi3mr_flush_drv_cmds(struct mpi3mr_ioc *mrioc)
 
 	cmdptr = &mrioc->init_cmds;
 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
+	cmdptr = &mrioc->ioctl_cmds;
+	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
+
 	cmdptr = &mrioc->host_tm_cmds;
 	mpi3mr_drv_cmd_comp_reset(mrioc, cmdptr);
 
@@ -3875,6 +3897,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 		return -1;
 	}
 	mrioc->reset_in_progress = 1;
+	mrioc->block_ioctls = 1;
 
 	if ((!snapdump) && (reset_reason != MPI3MR_RESET_FROM_FAULT_WATCH) &&
 	    (reset_reason != MPI3MR_RESET_FROM_CIACTIV_FAULT)) {
@@ -3945,6 +3968,7 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 			    &mrioc->watchdog_work,
 			    msecs_to_jiffies(MPI3MR_WATCHDOG_INTERVAL));
 		spin_unlock_irqrestore(&mrioc->watchdog_lock, flags);
+		mrioc->block_ioctls = 0;
 	} else {
 		mpi3mr_issue_reset(mrioc,
 		    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT, reset_reason);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index a17d2172bddf..cd53c4920207 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -537,7 +537,7 @@ static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_by_handle(
  *
  * Return: Target device reference.
  */
-static struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_handle(
 	struct mpi3mr_ioc *mrioc, u16 handle)
 {
 	struct mpi3mr_tgt_dev *tgtdev;
@@ -585,7 +585,7 @@ static struct mpi3mr_tgt_dev  *__mpi3mr_get_tgtdev_by_perst_id(
  *
  * Return: Target device reference.
  */
-static struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_perst_id(
+struct mpi3mr_tgt_dev *mpi3mr_get_tgtdev_by_perst_id(
 	struct mpi3mr_ioc *mrioc, u16 persist_id)
 {
 	struct mpi3mr_tgt_dev *tgtdev;
@@ -3074,6 +3074,7 @@ static int mpi3mr_scan_finished(struct Scsi_Host *shost,
 	ioc_info(mrioc, "%s :port enable: SUCCESS\n", __func__);
 	mpi3mr_start_watchdog(mrioc);
 	mrioc->is_driver_loading = 0;
+	mrioc->block_ioctls = 0;
 
 	return 1;
 }
@@ -3717,6 +3718,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	mutex_init(&mrioc->reset_mutex);
 	mpi3mr_init_drv_cmd(&mrioc->init_cmds, MPI3MR_HOSTTAG_INITCMDS);
+	mpi3mr_init_drv_cmd(&mrioc->ioctl_cmds, MPI3MR_HOSTTAG_IOCTLCMDS);
 	mpi3mr_init_drv_cmd(&mrioc->host_tm_cmds, MPI3MR_HOSTTAG_BLK_TMS);
 
 	for (i = 0; i < MPI3MR_NUM_DEVRMCMD; i++)
@@ -3730,6 +3732,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mrioc->logging_level = logging_level;
 	mrioc->shost = shost;
 	mrioc->pdev = pdev;
+	mrioc->block_ioctls = 1;
 
 	/* init shost parameters */
 	shost->max_cmd_len = MPI3MR_MAX_CDB_LENGTH;
@@ -4006,6 +4009,7 @@ static int __init mpi3mr_init(void)
 	pr_info("Loading %s version %s\n", MPI3MR_DRIVER_NAME,
 	    MPI3MR_DRIVER_VERSION);
 
+	mpi3mr_app_init();
 	ret_val = pci_register_driver(&mpi3mr_pci_driver);
 
 	return ret_val;
@@ -4021,6 +4025,7 @@ static void __exit mpi3mr_exit(void)
 		pr_info("Unloading %s version %s\n", MPI3MR_DRIVER_NAME,
 		    MPI3MR_DRIVER_VERSION);
 
+	mpi3mr_app_exit();
 	pci_unregister_driver(&mpi3mr_pci_driver);
 }
 
-- 
2.18.1


--00000000000014efb805cc85d0cc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
P3lSxcw4Cg90iKHqfpwLnGNc9AGXHMxUCukpnAHRlivljilKHMx1ymb180BLmtF+ZLm6KrFLQWzB
4KeiUOMtKM13wJrQubqTeZgB1XA+89jeLYlxagVsMyksdwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRprYXNoeWFwLmRlc2FpQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUkTOZp9jXE3yPj4ieKeDT
OiNyCtswDQYJKoZIhvcNAQELBQADggEBABG1KCh7cLjStywh4S37nKE1eE8KPyAxDzQCkhxYLBVj
gnnhaLmEOayEucPAsM1hCRAm/vR3RQ27lMXBGveCHaq9RZkzTjGSbzr8adOGK3CluPrasNf5StX3
GSk4HwCapA39BDUrhnc/qG5vHwLrgA1jwAvSy8e/vn4F4h+KPrPoFNd1OnCafedbuiEXTqTkn5Rk
vZ2AOTcSbxvmyKBMb/iu1vn7AAoui0d8GYCPoz8shf2iWMSUXVYJAMrtRHVJr47J5jlopF5F2ghC
MzNfx6QsmJhYiRByd8L9sUOjp/DMgkC6H93PyYpYMiBGapgNf6UMsLg/1kx5DATNwhPAJbkxggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxwO04DXOeYbZtr
4mAwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPQjkapkALP4ZQtbQ/Tp7W9NMNUa
WfAIJQxNc4gzA4brMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIx
MDkyMTE4NDYxN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQBdBuUuI5za5pRo2xj08SFuz6lsNx4xwG7GqwDYU4Q7wQbh
SiFcZWkHvwQgYf0Xwqf/HzxF/SRMsZCt07nu3OyjVQbxoJVlFOODq8FZ5rEiTFwQO0LsdTJJvsch
bmsOazVOS71WVh/qNYE9VWc0qFriltcDNIP/JMkv8c2xlrIIILI9vBpu7LYKZPCoKv4/JZqz9UZL
wMaZ9/uDFYM3b8tE12/+17MLpdCjtAai3rcRL2KwC7kcngITB/KWmKpkGYizxNffqfLb14cidSZL
S9/S1HmxU/hhb4+MDrn8dhPumoUMdxs39Kv+g6qndTEAZbDgNB/EfZ7hip8LFOxb6xnN
--00000000000014efb805cc85d0cc--
