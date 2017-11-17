From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH 2/3] scsi: aacraid: Perform initialization reset only once
Date: Fri, 17 Nov 2017 19:14:54 -0200
Message-ID: <20171117211455.29031-3-gpiccoli@linux.vnet.ibm.com>
References: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37296 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753217AbdKQVPM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Nov 2017 16:15:12 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vAHLF8rA055885
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 16:15:11 -0500
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ea5ba60br-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 17 Nov 2017 16:15:11 -0500
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Fri, 17 Nov 2017 14:15:10 -0700
In-Reply-To: <20171117211455.29031-1-gpiccoli@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@microsemi.com, linux-scsi@vger.kernel.org
Cc: gpiccoli@linux.vnet.ibm.com, david.carroll@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, gpiccoli@protonmail.ch

Currently the driver accepts two ways of requesting an initialization
reset on the adapter: by passing aac_reset_devices module parameter,
or the generic kernel parameter reset_devices.

It's working as intended...but if we end up reaching a scsi hang and
the scsi EH mechanism takes place, aacraid performs resets as part of
the scsi error recovery procedure. These EH routines might reinitialize
the device, and if we have provided some of the reset parameters in the
kernel command-line, we again perform an "initialization" reset.

So, to avoid this duplication of resets in case of scsi EH path, this
patch adds a field to aac_dev struct to keep per-adapter track of the
init reset request - once it's done, we set it to false and don't
proactively reset anymore in case of reinitializations.

Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
---
 drivers/scsi/aacraid/aacraid.h |  1 +
 drivers/scsi/aacraid/linit.c   |  3 +++
 drivers/scsi/aacraid/rx.c      | 15 ++++++++++-----
 drivers/scsi/aacraid/src.c     | 20 ++++++++++++++------
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 403a639574e5..6e3d81969a77 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1673,6 +1673,7 @@ struct aac_dev
 	struct aac_hba_map_info	hba_map[AAC_MAX_BUSES][AAC_MAX_TARGETS];
 	u8			adapter_shutdown;
 	u32			handle_pci_error;
+	bool			init_reset;
 };
 
 #define aac_adapter_interrupt(dev) \
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index c9252b138c1f..bdf127aaab41 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1680,6 +1680,9 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	aac->cardtype = index;
 	INIT_LIST_HEAD(&aac->entry);
 
+	if (aac_reset_devices || reset_devices)
+		aac->init_reset = true;
+
 	aac->fibs = kzalloc(sizeof(struct fib) * (shost->can_queue + AAC_NUM_MGT_FIB), GFP_KERNEL);
 	if (!aac->fibs)
 		goto out_free_host;
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 93ef7c37e568..ff2af06e7dd9 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -561,11 +561,16 @@ int _aac_rx_init(struct aac_dev *dev)
 	dev->a_ops.adapter_sync_cmd = rx_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
 	dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
-	if ((((status & 0x0c) != 0x0c) || aac_reset_devices || reset_devices) &&
-	  !aac_rx_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
-		/* Make sure the Hardware FIFO is empty */
-		while ((++restart < 512) &&
-		  (rx_readl(dev, MUnit.OutboundQueue) != 0xFFFFFFFFL));
+
+	if (((status & 0x0c) != 0x0c) || dev->init_reset) {
+		dev->init_reset = false;
+		if (!aac_rx_restart_adapter(dev, 0, IOP_HWSOFT_RESET)) {
+			/* Make sure the Hardware FIFO is empty */
+			while ((++restart < 512) &&
+			      (rx_readl(dev, MUnit.OutboundQueue) != 0xFFFFFFFFL));
+		}
+	}
+
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 0c9361c87ec8..fde6b6aa86e3 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -868,9 +868,13 @@ int aac_src_init(struct aac_dev *dev)
 	/* Failure to reset here is an option ... */
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
-	if ((aac_reset_devices || reset_devices) &&
-		!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
-		++restart;
+
+	if (dev->init_reset) {
+		dev->init_reset = false;
+		if (!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
+			++restart;
+	}
+
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
@@ -1014,9 +1018,13 @@ int aac_srcv_init(struct aac_dev *dev)
 	/* Failure to reset here is an option ... */
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
-	if ((aac_reset_devices || reset_devices) &&
-		!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
-		++restart;
+
+	if (dev->init_reset) {
+		dev->init_reset = false;
+		if (!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
+			++restart;
+	}
+
 	/*
 	 *	Check to see if flash update is running.
 	 *	Wait for the adapter to be up and running. Wait up to 5 minutes
-- 
2.15.0
