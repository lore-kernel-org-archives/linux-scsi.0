Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D42BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Mar 2022 12:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiCVMXY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Mar 2022 08:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiCVMXV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2022 08:23:21 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D2D82D3A
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 05:21:53 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p8so17985057pfh.8
        for <linux-scsi@vger.kernel.org>; Tue, 22 Mar 2022 05:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=FR8dmLb5OzNTU3IxTXHlcV8zxbcDta1lAqWF1IxCWZY=;
        b=PsYvWuFqLY/mPORm40N7Z1tiPZrOgNThwq55mSXJpGLY5J/F399jDURXHmuzqn883a
         nWlSR7kj1IFuD0pPhzEvDqS7oWHP06OEzKkG8nG6hpodMQL804QfLxW9P/aQkOZITpNX
         3gOVUGC4wjDZyvlanu9/bLSyfnsmCe+68bfU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=FR8dmLb5OzNTU3IxTXHlcV8zxbcDta1lAqWF1IxCWZY=;
        b=YOvwHw7eIE4zTrNo3UYckBMTwxHzS7rnEMu8X4tusVZsmjovLfqcQS/TNc3C8PBbo1
         IvEqtcFymtUt8UNLf+tFD0pbZUgB4wLQ5TdkuvB03Zq+Dtt7pvQhtPF3jfgwoDTHf5v/
         ml3kV7H+WYpT8oVAknxSnk3//72kIkwihxxaxz4ae0bq+8bPvDw1N+82sOEuc97qtgon
         CJQBLdunbcZwxVtm0bTLmbHGf16hWBkVOF43xLMyOLsHHlNIwLtuXNxfqVuvsk7ynm0F
         2l2Zt9GWVMGIyVQKnYQAZ78jNWLsnBNqqSDl6uqVnqdybQjKWsUhTTtDKpKpvdZM9JYH
         RSkg==
X-Gm-Message-State: AOAM532uzSubFAzUPM+dugpAAPeh9VpKvQSI4m3r8uGiO874Rthdsl2S
        P+y/WsihEwMaJo8qY1X04WJuQHeQVlzcJK88J/PBSiakPTw1XB+/TTWTLiv5SKei2yZak7pcftw
        spFRjtdR4h9AMJd/F/2341GwJJqo0LgpkGEdY8Dj7olL70pgCyuB9Pa3ufRHeCRb6DVFNojJq1F
        hQsM99nPgG3Q==
X-Google-Smtp-Source: ABdhPJws8CJM7MHxibl62vIcofu1K74gXM3FlaqOgQJ2aMhwvmHT8lV1mdUhr9aO9yKk4HWPzpAx5w==
X-Received: by 2002:a63:1f55:0:b0:382:65eb:3073 with SMTP id q21-20020a631f55000000b0038265eb3073mr10437045pgm.624.1647951712424;
        Tue, 22 Mar 2022 05:21:52 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d11-20020a056a0010cb00b004e1b76b09c0sm23225259pfu.74.2022.03.22.05.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 05:21:51 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 1/7] mpi3mr: add BSG device support for controller management
Date:   Tue, 22 Mar 2022 08:21:01 -0400
Message-Id: <20220322122107.8482-2-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220322122107.8482-1-sumit.saxena@broadcom.com>
References: <20220322122107.8482-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000074703705dacda8b8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000074703705dacda8b8
Content-Transfer-Encoding: 8bit

This patch creates BSG device per controller during load and destroys
during unload. BSG Device  nodes will be named as /dev/bsg/mpi3mrctl0,
/dev/bsg/mpi3mrctl1...

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/Kconfig      |   1 +
 drivers/scsi/mpi3mr/Makefile     |   1 +
 drivers/scsi/mpi3mr/mpi3mr.h     |   8 +++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 106 +++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_app.h |  20 ++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |   2 +
 6 files changed, 138 insertions(+)
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.c
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.h

diff --git a/drivers/scsi/mpi3mr/Kconfig b/drivers/scsi/mpi3mr/Kconfig
index f7882375e74f..8997531940c2 100644
--- a/drivers/scsi/mpi3mr/Kconfig
+++ b/drivers/scsi/mpi3mr/Kconfig
@@ -3,5 +3,6 @@
 config SCSI_MPI3MR
 	tristate "Broadcom MPI3 Storage Controller Device Driver"
 	depends on PCI && SCSI
+	select BLK_DEV_BSGLIB
 	help
 	MPI3 based Storage & RAID Controllers Driver.
diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
index 7c2063e04c81..f5cdbe48c150 100644
--- a/drivers/scsi/mpi3mr/Makefile
+++ b/drivers/scsi/mpi3mr/Makefile
@@ -2,3 +2,4 @@
 obj-m += mpi3mr.o
 mpi3mr-y +=  mpi3mr_os.o     \
 		mpi3mr_fw.o \
+		mpi3mr_app.o \
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6672d907d75d..f790b84c810a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -148,6 +148,7 @@ extern int prot_mask;
 
 #define MPI3MR_DEFAULT_MDTS	(128 * 1024)
 #define MPI3MR_DEFAULT_PGSZEXP         (12)
+
 /* Command retry count definitions */
 #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
 
@@ -714,6 +715,8 @@ struct scmd_priv {
  * @default_qcount: Total Default queues
  * @active_poll_qcount: Currently active poll queue count
  * @requested_poll_qcount: User requested poll queue count
+ * @bsg_dev: BSG device structure
+ * @bsg_queue: Request queue for BSG device
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -854,6 +857,9 @@ struct mpi3mr_ioc {
 	u16 default_qcount;
 	u16 active_poll_qcount;
 	u16 requested_poll_qcount;
+
+	struct device *bsg_dev;
+	struct request_queue *bsg_queue;
 };
 
 /**
@@ -962,5 +968,7 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	struct op_reply_qinfo *op_reply_q);
 int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
+void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc);
+void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
new file mode 100644
index 000000000000..ac420730c8c4
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Driver for Broadcom MPI3 Storage Controllers
+ *
+ * Copyright (C) 2017-2022 Broadcom Inc.
+ *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
+ *
+ */
+
+#include "mpi3mr.h"
+#include "mpi3mr_app.h"
+#include <linux/bsg-lib.h>
+
+/**
+ * mpi3mr_bsg_request - bsg request entry point
+ * @job: BSG job reference
+ *
+ * This is driver's entry point for bsg requests
+ *
+ * Return: 0 on success and proper error codes on failure
+ */
+int mpi3mr_bsg_request(struct bsg_job *job)
+{
+	return 0;
+}
+
+/**
+ * mpi3mr_bsg_exit - de-registration from bsg layer
+ *
+ * This will be called during driver unload and all
+ * bsg resources allocated during load will be freed.
+ *
+ * Return:Nothing
+ */
+void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc)
+{
+	if (!mrioc->bsg_queue)
+		return;
+
+	bsg_remove_queue(mrioc->bsg_queue);
+	mrioc->bsg_queue = NULL;
+
+	device_del(mrioc->bsg_dev);
+	put_device(mrioc->bsg_dev);
+	kfree(mrioc->bsg_dev);
+}
+
+/**
+ * mpi3mr_bsg_node_release -release bsg device node
+ * @dev: bsg device node
+ *
+ * decrements bsg dev reference count
+ *
+ * Return:Nothing
+ */
+void mpi3mr_bsg_node_release(struct device *dev)
+{
+	put_device(dev);
+}
+
+/**
+ * mpi3mr_bsg_init -  registration with bsg layer
+ *
+ * This will be called during driver load and it will
+ * register driver with bsg layer
+ *
+ * Return:Nothing
+ */
+void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
+{
+	mrioc->bsg_dev = kzalloc(sizeof(struct device), GFP_KERNEL);
+	if (!mrioc->bsg_dev) {
+		ioc_err(mrioc, "bsg device mem allocation failed\n");
+		return;
+	}
+
+	device_initialize(mrioc->bsg_dev);
+	dev_set_name(mrioc->bsg_dev, "mpi3mrctl%u", mrioc->id);
+
+	if (device_add(mrioc->bsg_dev)) {
+		ioc_err(mrioc, "%s: bsg device add failed\n",
+		    dev_name(mrioc->bsg_dev));
+		goto err_device_add;
+	}
+
+	mrioc->bsg_dev->release = mpi3mr_bsg_node_release;
+
+	mrioc->bsg_queue = bsg_setup_queue(mrioc->bsg_dev, dev_name(mrioc->bsg_dev),
+			mpi3mr_bsg_request, NULL, 0);
+	if (!mrioc->bsg_queue) {
+		ioc_err(mrioc, "%s: bsg registration failed\n",
+		    dev_name(mrioc->bsg_dev));
+		goto err_setup_queue;
+	}
+
+	blk_queue_max_segment_size(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SIZE);
+	blk_queue_max_hw_sectors(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SECTORS);
+
+	return;
+
+err_setup_queue:
+	device_del(mrioc->bsg_dev);
+	put_device(mrioc->bsg_dev);
+err_device_add:
+	kfree(mrioc->bsg_dev);
+}
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.h b/drivers/scsi/mpi3mr/mpi3mr_app.h
new file mode 100644
index 000000000000..4bc31d45c610
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Driver for Broadcom MPI3 Storage Controllers
+ *
+ * Copyright (C) 2017-2022 Broadcom Inc.
+ *  (mailto: mpi3mr-linuxdrv.pdl@broadcom.com)
+ *
+ */
+
+#ifndef MPI3MR_APP_H_INCLUDED
+#define MPI3MR_APP_H_INCLUDED
+
+/*
+ * Maximum data transfer size definitions for management
+ * application commands
+ */
+#define MPI3MR_MAX_APP_XFER_SIZE	(1 * 1024 * 1024)
+#define MPI3MR_MAX_APP_XFER_SECTORS	2048
+
+#endif
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f7cd70a15ea6..faf14a5f9123 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4345,6 +4345,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	scsi_scan_host(shost);
+	mpi3mr_bsg_init(mrioc);
 	return retval;
 
 addhost_failed:
@@ -4389,6 +4390,7 @@ static void mpi3mr_remove(struct pci_dev *pdev)
 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
 		ssleep(1);
 
+	mpi3mr_bsg_exit(mrioc);
 	mrioc->stop_drv_processing = 1;
 	mpi3mr_cleanup_fwevt_list(mrioc);
 	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
-- 
2.27.0


--00000000000074703705dacda8b8
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
GmgWG68YahkDuVSTTt2beZdyMeDwq/KifJFo18EkhcL3e7rmDAh8SniUI/0o3HX6hrgdmUI1wSdz
uIVL/m6Ok9mIl2U5kvguitOSC0bVaQPfNzlj+7PCKBECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZc3VtaXQuc2F4ZW5hQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUNz+JSIXEXl2uQ4Utcnx7FnFi
hhowDQYJKoZIhvcNAQELBQADggEBAL0HLbxgPSW4BFbbIMN3A/ifBg4Lzaph8ARJOnZpGQivo9jG
kQOd95knQi9Lm95JlBAJZCqXXj7QS+dnE71tsFeHWcHNNxHrTSwn4Xi5EqaRjLC6g4IEPyZHWDrD
zzJidgfwQvfZONkf4IXnnrIEFle+26/gPs2kOjCeLMo6XGkNC4HNla1ol1htToQaNN8974pCqwIC
rTXcWqD03VkqSOo+oPP/NAgFAZVfpeuBoK2Xv8zYlrF49Q4hxgFpWhaiDsZUSdWIS7vg1ak1n+6L
3aHRY/lheSkOn/uJWXsqsTDp613hVtOTEDsHSQK32yTGr8jN/oRQgJASuUqQFdD4VzAxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwoQTpBmhDxj9JoN1ow
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIApc7frCdGi2E0NS9AmuOMJ6Qgfj8z0G
THTnDuevuxoVMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MjEyMjE1MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDVtwKHmbLeqNZZk4lsTLHliH4uqoXIhu68ahPaH0hfZ3+td680
T3EdozjzfynyUezmXmvKR6EH0IhDAqHvvzlXunJQtBzgOgJ5PWY5MtWV7DfV8bdVvPf9zYQE0WRp
3/lX1BFzy6SJIVUfHKD6XgEzDw0ADx6JJ99OsW9d7ofrLLGQKGL8/FYK4StGualo8JLeUti/Fao/
+vENuirGeOvJ+uZKsA/2baSroHy8LauQDskYhHwJCUHUfQxbIj+ZbeXgyECqeQXrTQxKDPkqFyWT
EbW8oIRM0RGO4oWof0fYlUk7TEN69ZpVXUIPXMxqfcrg/tfIlkQaHsvhKjRdoovZ
--00000000000074703705dacda8b8--
