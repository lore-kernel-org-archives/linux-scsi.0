Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A735AC83000
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:45:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44552206B8
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 06:45:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eHMwzPsW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgD1Gpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 02:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726279AbgD1Gph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 02:45:37 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98718C03C1A9
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2020 23:45:37 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o185so9854236pgo.3
        for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2020 23:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JxWkLxRe+Z9iC469r5nnbiYM+CkwZeVvk2yozbHsbQs=;
        b=eHMwzPsWygWeAaLi7ktD0A1cYf8qAVY1nex7KDgWZcMdDFMb8mArbZuYxuTG07nxUh
         EusKqF8OrALRiw3O5c8/fDWuXExxQcPg0vkEj6fON7jaR80EfWvDb0tpQfnwb+oIGknO
         qNg2S6X0seWUxcDUfWeG2oSRyfFkHqSdmraFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JxWkLxRe+Z9iC469r5nnbiYM+CkwZeVvk2yozbHsbQs=;
        b=JoYWUIeoEzs3eFbCRn24Bp7mUwKnfm9EhAqfw2YPUJEImsZHz2EBdoB0LpEmcsE2kn
         ih0dKgJsC3YpgxQ4C7cmmHRAit6Rd+QV5aAzwXmX9l/czqcaUvUR0H3KuoutWiimcLgM
         7cTG+gJVEKE+FB99RYsAi+JU16e5B0Sn4HOrE9QEkLuTgfpGisUpEeiJJWuGecPNIJSO
         nyaSbRyDHkS4BXrWjTSy/ELxRjjT378haRdBnm7eNH97WDMuQByp03bV6W5pVRvMA8fN
         YoYN+ToqD0rOmY8RE6VYEddULo8bl4IUcdOzFqkyPL/0gpnvFk+qD0y/BZLYqetVzoIT
         weeA==
X-Gm-Message-State: AGi0PuZ2BRaTvyVMtY4iEVrECHwHeVPtP0oOG9muWq6rO/5DwkkIbmek
        sC3EPemxqqbJheJ/40Q49SFzfUfqrHAIY21DGbrqQFwm86r+OP06AkJc10f1iMBM3AksKY8lK+6
        TOL7IJVl58ZzLej5dADyIk6Lmo5ep57uzacDNbb++KME3biVMIcX4pbzCpWW9sQLOv2Y5178B8w
        q0NUAVcj7bk9yowFq3P0Os
X-Google-Smtp-Source: APiQypLlmC87pgdqF3NTkXgUs+FjpaJazOlHbw+/kOBVnxRqzSKyu+mTFH72qomBn3Zh1KgnWgEdlA==
X-Received: by 2002:a62:7555:: with SMTP id q82mr27957039pfc.136.1588056336365;
        Mon, 27 Apr 2020 23:45:36 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id m24sm12067851pgn.91.2020.04.27.23.45.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 23:45:35 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH] mpt3sas: Capture IOC data for analyzing the issue.
Date:   Tue, 28 Apr 2020 02:45:22 -0400
Message-Id: <1588056322-29227-1-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If some issue happens OR if firmware fault occurs then to get the basic
information developer may ask the customer to reproduce the issue with
logging level enabled. But most of the basic information needed to
analyze the issue will be available in ioc’s MPT3SAS_ADAPTER structure
such as IOCFacts, ioc flags (related to sge, msix, error recovery etc.),
performance mode type, TMs and internal commands reply status etc. So if
this MPT3SAS_ADAPTER data is captured into a file whenever some issue
occurs then developer can get some basic of the information that he needed
to analyze the issue from this captured data.
pros
       - Reduces the number of reproductions count,
       - No need to add the printk statements which affects the performance
                when they are added in IO path.

User can capture the MPT3SAS_ADAPTER structure data into a file by
executing below command.
cat /sys/kernel/debug/mpt3sas/scsi_hostX/ioc_dump > file.dump
(where X is host number).

Signed-off-by: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/Makefile          |   3 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h    |  18 +++-
 drivers/scsi/mpt3sas/mpt3sas_debugfs.c | 158 +++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_scsih.c   |   4 +
 4 files changed, 179 insertions(+), 4 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpt3sas_debugfs.c

diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefile
index 84fb3fb..e76d994 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -7,4 +7,5 @@ mpt3sas-y +=  mpt3sas_base.o     \
 		mpt3sas_transport.o     \
 		mpt3sas_ctl.o	\
 		mpt3sas_trigger_diag.o \
-		mpt3sas_warpdrive.o
+		mpt3sas_warpdrive.o \
+		mpt3sas_debugfs.o \
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index c574379..4fca393 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -76,9 +76,9 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"33.101.00.00"
-#define MPT3SAS_MAJOR_VERSION		33
-#define MPT3SAS_MINOR_VERSION		101
+#define MPT3SAS_DRIVER_VERSION		"34.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		34
+#define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
@@ -1472,6 +1472,8 @@ struct MPT3SAS_ADAPTER {
 	u16		device_remove_in_progress_sz;
 	u8		is_gen35_ioc;
 	u8		is_aero_ioc;
+	struct dentry	*debugfs_root;
+	struct dentry	*ioc_dump;
 	PUT_SMID_IO_FP_HIP put_smid_scsi_io;
 	PUT_SMID_IO_FP_HIP put_smid_fast_path;
 	PUT_SMID_IO_FP_HIP put_smid_hi_priority;
@@ -1479,6 +1481,11 @@ struct MPT3SAS_ADAPTER {
 	GET_MSIX_INDEX get_msix_index_for_smlio;
 };
 
+struct mpt3sas_debugfs_buffer {
+	void	*buf;
+	u32	len;
+};
+
 #define MPT_DRV_SUPPORT_BITMAP_MEMMOVE 0x00000001
 
 typedef u8 (*MPT_CALLBACK)(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
@@ -1782,6 +1789,11 @@ mpt3sas_setup_direct_io(struct MPT3SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
 /* NCQ Prio Handling Check */
 bool scsih_ncq_prio_supp(struct scsi_device *sdev);
 
+void mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_destroy_debugfs(struct MPT3SAS_ADAPTER *ioc);
+void mpt3sas_init_debugfs(void);
+void mpt3sas_exit_debugfs(void);
+
 /**
  * _scsih_is_pcie_scsi_device - determines if device is an pcie scsi device
  * @device_info: bitfield providing information about the device.
diff --git a/drivers/scsi/mpt3sas/mpt3sas_debugfs.c b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
new file mode 100644
index 0000000..e323611
--- /dev/null
+++ b/drivers/scsi/mpt3sas/mpt3sas_debugfs.c
@@ -0,0 +1,158 @@
+// SPDX-License-Identifier: GPL-2.
+/*
+ * Debugfs interface Support for MPT (Message Passing Technology) based
+ * controllers.
+ *
+ * Copyright (C) 2020  Broadcom Inc.
+ *
+ * Authors: Broadcom Inc.
+ * Sreekanth Reddy  <sreekanth.reddy@broadcom.com>
+ * Suganath Prabu <suganath-prabu.subramani@broadcom.com>
+ *
+ * Send feedback to : MPT-FusionLinux.pdl@broadcom.com)
+ *
+ **/
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/compat.h>
+#include <linux/uio.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+#include "mpt3sas_base.h"
+#include <linux/debugfs.h>
+
+static struct dentry *mpt3sas_debugfs_root;
+
+/*
+ * _debugfs_iocdump_read - copy ioc dump from debugfs buffer
+ * @filep:	File Pointer
+ * @ubuf:	Buffer to fill data
+ * @cnt:	Length of the buffer
+ * @ppos:	Offset in the file
+ */
+
+static ssize_t
+_debugfs_iocdump_read(struct file *filp, char __user *ubuf, size_t cnt,
+	loff_t *ppos)
+
+{
+	struct mpt3sas_debugfs_buffer *debug = filp->private_data;
+
+	if (!debug || !debug->buf)
+		return 0;
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, debug->buf, debug->len);
+}
+
+/*
+ * _debugfs_iocdump_open :	open the ioc_dump debugfs attribute file
+ */
+static int
+_debugfs_iocdump_open(struct inode *inode, struct file *file)
+{
+	struct MPT3SAS_ADAPTER *ioc = inode->i_private;
+	struct mpt3sas_debugfs_buffer *debug;
+
+	debug = kzalloc(sizeof(struct mpt3sas_debugfs_buffer), GFP_KERNEL);
+	if (!debug)
+		return -ENOMEM;
+
+	debug->buf = (void *)ioc;
+	debug->len = sizeof(struct MPT3SAS_ADAPTER);
+	file->private_data = debug;
+	return 0;
+}
+
+/*
+ * _debugfs_iocdump_release :	release the ioc_dump debugfs attribute
+ * @inode: inode structure to the corresponds device
+ * @file: File pointer
+ */
+static int
+_debugfs_iocdump_release(struct inode *inode, struct file *file)
+{
+	struct mpt3sas_debugfs_buffer *debug = file->private_data;
+
+	if (!debug)
+		return 0;
+
+	file->private_data = NULL;
+	kfree(debug);
+	return 0;
+}
+
+static const struct file_operations mpt3sas_debugfs_iocdump_fops = {
+	.owner		= THIS_MODULE,
+	.open           = _debugfs_iocdump_open,
+	.read           = _debugfs_iocdump_read,
+	.release        = _debugfs_iocdump_release,
+};
+
+/*
+ * mpt3sas_init_debugfs :	Create debugfs root for mpt3sas driver
+ */
+void mpt3sas_init_debugfs(void)
+{
+	mpt3sas_debugfs_root = debugfs_create_dir("mpt3sas", NULL);
+	if (!mpt3sas_debugfs_root)
+		pr_info("mpt3sas: Cannot create debugfs root\n");
+}
+
+/*
+ * mpt3sas_exit_debugfs :	Remove debugfs root for mpt3sas driver
+ */
+void mpt3sas_exit_debugfs(void)
+{
+	debugfs_remove_recursive(mpt3sas_debugfs_root);
+}
+
+/*
+ * mpt3sas_setup_debugfs :	Setup debugfs per HBA adapter
+ * ioc:				MPT3SAS_ADAPTER object
+ */
+void
+mpt3sas_setup_debugfs(struct MPT3SAS_ADAPTER *ioc)
+{
+	char name[64];
+
+	snprintf(name, sizeof(name), "scsi_host%d", ioc->shost->host_no);
+	if (!ioc->debugfs_root) {
+		ioc->debugfs_root =
+		    debugfs_create_dir(name, mpt3sas_debugfs_root);
+		if (!ioc->debugfs_root) {
+			dev_err(&ioc->pdev->dev,
+			    "Cannot create per adapter debugfs directory\n");
+			return;
+		}
+	}
+
+	snprintf(name, sizeof(name), "ioc_dump");
+	ioc->ioc_dump =	debugfs_create_file(name, 0444,
+	    ioc->debugfs_root, ioc, &mpt3sas_debugfs_iocdump_fops);
+	if (!ioc->ioc_dump) {
+		dev_err(&ioc->pdev->dev,
+		    "Cannot create ioc_dump debugfs file\n");
+		debugfs_remove(ioc->debugfs_root);
+		return;
+	}
+
+	snprintf(name, sizeof(name), "host_recovery");
+	debugfs_create_u8(name, 0444, ioc->debugfs_root, &ioc->shost_recovery);
+
+}
+
+/*
+ * mpt3sas_destroy_debugfs :	Destroy debugfs per HBA adapter
+ * @ioc:	MPT3SAS_ADAPTER object
+ */
+void mpt3sas_destroy_debugfs(struct MPT3SAS_ADAPTER *ioc)
+{
+	debugfs_remove_recursive(ioc->debugfs_root);
+}
+
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c597d54..58fb55d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -9928,6 +9928,7 @@ static void scsih_remove(struct pci_dev *pdev)
 				&ioc->ioc_pg1_copy);
 	/* release all the volumes */
 	_scsih_ir_shutdown(ioc);
+	mpt3sas_destroy_debugfs(ioc);
 	sas_remove_host(shost);
 	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
 	    list) {
@@ -10814,6 +10815,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	scsi_scan_host(shost);
+	mpt3sas_setup_debugfs(ioc);
 	return 0;
 out_add_shost_fail:
 	mpt3sas_base_detach(ioc);
@@ -11220,6 +11222,7 @@ scsih_init(void)
 	tm_sas_control_cb_idx = mpt3sas_base_register_callback_handler(
 	    _scsih_sas_control_complete);
 
+	mpt3sas_init_debugfs();
 	return 0;
 }
 
@@ -11251,6 +11254,7 @@ scsih_exit(void)
 	if (hbas_to_enumerate != 2)
 		raid_class_release(mpt2sas_raid_template);
 	sas_release_transport(mpt3sas_transport_template);
+	mpt3sas_exit_debugfs();
 }
 
 /**
-- 
1.8.3.1

