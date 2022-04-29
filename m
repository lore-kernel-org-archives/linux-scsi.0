Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C55F7C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Apr 2022 21:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbiD2VUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Apr 2022 17:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235804AbiD2VUm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2022 17:20:42 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89813D1FB
        for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2022 14:17:22 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b12so8190919plg.4
        for <linux-scsi@vger.kernel.org>; Fri, 29 Apr 2022 14:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=63+LTMr0xLcbq5hR8qmPBUxizekaLHZT52Mw7p+SocU=;
        b=WyyKDFPmGAGF3c/bZ3V2EDqtAdo61wylL/ez8fSqkEKyxClZ3l8P4j72HuQZF9Oo2n
         nLISz3nuKAmsV+xLg/caaODrwJ8bLHWo1z2EjgK2GHC8mIvX8cI1g/hFcLK//0Wh9Xt9
         4PhMeayUegtezAp78v3JUdtK+JNU7Nlpg6woA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=63+LTMr0xLcbq5hR8qmPBUxizekaLHZT52Mw7p+SocU=;
        b=nGJ4FIl+zigUxaLE7Ar85EwVxaOeT+k78GdBwJB+vPpVEIEqSLjVLXuFMOE+Mn3oJc
         kbFwrgjsV/bY7vCDYbwQI0eXl1KH4h5T7q22w9kpj07Jpa/JKr/wSFUYoK980AW43yRa
         WhbN2mT1R4lOrDv99H1SbUQRqpPD9q4hM4EXUp7ALDHaIvukGeRrBDp/Aq7sIA65+UxA
         IbmN1P7+X0SGCK3NE24yaPpiiFLpsotyHPmkiuazZIjdXgIRaIoiqXZuAzIeGGeUKPJA
         te8ikhYq78wxTFsbROk9Eb9CO4qN38iESV6YspUl3tHLKpkRFd8hcuc/BFxE+pdQH4dG
         4feA==
X-Gm-Message-State: AOAM533tLCGbBmDiP3oFqEd0r6xmsJvUw0Q6zrGMHclnuS3XhOocMSCZ
        f6XLB7iq6AgoFlafULiYv6X+z/OSKHsFzb7bDJIAtEWPVMmtK+zUwwPzBq+oU2+bGGeyHmBSuMX
        TBHOjJAv9/Kvd0sspYe70wSlGwXV86OfsAwfqnLCw0+rRqEKF1Gh7eXXVGoRZwrg0bHVSVFfNLw
        y7KlJ/bK4=
X-Google-Smtp-Source: ABdhPJxCn7mS3ASpxzo2aqAmhIwW7wReSJB9+cxX2fXbOhyGjcsMHoSd35i37hPqWk5EPZ/8h9ewqQ==
X-Received: by 2002:a17:90a:e517:b0:1da:3d42:7fb8 with SMTP id t23-20020a17090ae51700b001da3d427fb8mr1072397pjy.194.1651267042067;
        Fri, 29 Apr 2022 14:17:22 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id y9-20020a17090a1f4900b001cd498dc153sm14494849pjy.3.2022.04.29.14.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 14:17:21 -0700 (PDT)
From:   Sumit Saxena <sumit.saxena@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        hare@suse.de, himanshu.madhani@oracle.com,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v7 1/8] mpi3mr: Add bsg device support
Date:   Fri, 29 Apr 2022 17:16:34 -0400
Message-Id: <20220429211641.642010-2-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220429211641.642010-1-sumit.saxena@broadcom.com>
References: <20220429211641.642010-1-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000080a24d05ddd19189"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--00000000000080a24d05ddd19189
Content-Transfer-Encoding: 8bit

Create bsg device per controller for controller management purposes.
bsg device nodes will be named /dev/bsg/mpi3mrctl0,/dev/bsg/mpi3mrctl1,
etc.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/mpi3mr/Kconfig      |   1 +
 drivers/scsi/mpi3mr/Makefile     |   1 +
 drivers/scsi/mpi3mr/mpi3mr.h     |  20 ++++++
 drivers/scsi/mpi3mr/mpi3mr_app.c | 105 +++++++++++++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi3mr_os.c  |   2 +
 5 files changed, 129 insertions(+)
 create mode 100644 drivers/scsi/mpi3mr/mpi3mr_app.c

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
index 6672d907d75d..f0515f929110 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -148,6 +148,7 @@ extern int prot_mask;
 
 #define MPI3MR_DEFAULT_MDTS	(128 * 1024)
 #define MPI3MR_DEFAULT_PGSZEXP         (12)
+
 /* Command retry count definitions */
 #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
 
@@ -175,6 +176,18 @@ extern int prot_mask;
 /* MSI Index from Reply Queue Index */
 #define REPLY_QUEUE_IDX_TO_MSIX_IDX(qidx, offset)	(qidx + offset)
 
+/*
+ * Maximum data transfer size definitions for management
+ * application commands
+ */
+#define MPI3MR_MAX_APP_XFER_SIZE	(1 * 1024 * 1024)
+#define MPI3MR_MAX_APP_XFER_SEGMENTS	512
+/*
+ * 2048 sectors are for data buffers and additional 512 sectors for
+ * other buffers
+ */
+#define MPI3MR_MAX_APP_XFER_SECTORS	(2048 + 512)
+
 /* IOC State definitions */
 enum mpi3mr_iocstate {
 	MRIOC_STATE_READY = 1,
@@ -714,6 +727,8 @@ struct scmd_priv {
  * @default_qcount: Total Default queues
  * @active_poll_qcount: Currently active poll queue count
  * @requested_poll_qcount: User requested poll queue count
+ * @bsg_dev: BSG device structure
+ * @bsg_queue: Request queue for BSG device
  */
 struct mpi3mr_ioc {
 	struct list_head list;
@@ -854,6 +869,9 @@ struct mpi3mr_ioc {
 	u16 default_qcount;
 	u16 active_poll_qcount;
 	u16 requested_poll_qcount;
+
+	struct device *bsg_dev;
+	struct request_queue *bsg_queue;
 };
 
 /**
@@ -962,5 +980,7 @@ void mpi3mr_check_rh_fault_ioc(struct mpi3mr_ioc *mrioc, u32 reason_code);
 int mpi3mr_process_op_reply_q(struct mpi3mr_ioc *mrioc,
 	struct op_reply_qinfo *op_reply_q);
 int mpi3mr_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num);
+void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc);
+void mpi3mr_bsg_exit(struct mpi3mr_ioc *mrioc);
 
 #endif /*MPI3MR_H_INCLUDED*/
diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
new file mode 100644
index 000000000000..948d4ff2ea06
--- /dev/null
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -0,0 +1,105 @@
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
+static int mpi3mr_bsg_request(struct bsg_job *job)
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
+static void mpi3mr_bsg_node_release(struct device *dev)
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
+	blk_queue_max_segments(mrioc->bsg_queue, MPI3MR_MAX_APP_XFER_SEGMENTS);
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


--00000000000080a24d05ddd19189
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAmPGgYYm8k3iaeWyISOwjGLjyV0Oy92
Yr2xYzcMDw4AMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQy
OTIxMTcyMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC9X4zk83fpod1vuBqaN+/Ha4LvjMcPXBwJ3OOgwgFcOvZSbuSu
LD4i2WEAZ37gxkiL/H/mZasuwFFGbI5owd4omEhL6O/ywSI6gEfmrX0M9fMFzYh7jCDPsCaHuKHO
smc+cfpM+lEsqzfHbJ1CyvKp+Pxfk2yQZN6arrVwq4zZwE/MAKPlqZ4KjxzO52U0b5uI5lGzFDD4
lGwpE2+ehwtojJ3vC07OUuphKcFBW8N9lBHspKYNdhFlFsu90ELsXovayZZKUDv79lqxKJnOUBKk
WBUHDvYwUNR8d0y8cJWHNQueJMwVhIeQ703HKAxirBHuQrcmW82EkKo4eyf1RUPj
--00000000000080a24d05ddd19189--
