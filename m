From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 23/30] scsi: aacraid: Block concurrent hotplug event handling
Date: Tue, 26 Dec 2017 20:34:44 -0800
Message-ID: <20171227043451.27813-24-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0082.outbound.protection.outlook.com ([104.47.36.82]:6720
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751853AbdL0EfV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:21 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Currently driver will attempt to process hotplug events concurrently based
on the FW interrupt.

Protect safw update function with a scan mutex.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/aacraid.h | 1 +
 drivers/scsi/aacraid/commsup.c | 2 ++
 drivers/scsi/aacraid/linit.c   | 1 +
 3 files changed, 4 insertions(+)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index a8fe1e1..c70c998 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1565,6 +1565,7 @@ struct aac_dev
 	spinlock_t		fib_lock;
 
 	struct mutex		ioctl_mutex;
+	struct mutex		scan_mutex;
 	struct aac_queue_block *queues;
 	/*
 	 *	The user API will use an IOCTL to register itself to receive
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 34155b1..491e633 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1997,7 +1997,9 @@ static void aac_handle_sa_aif(struct aac_dev *dev, struct fib *fibptr)
 	case SA_AIF_LDEV_CHANGE:
 	case SA_AIF_BPCFG_CHANGE:
 
+		mutex_lock(&dev->scan_mutex);
 		aac_update_safw_host_devices(dev, AAC_RESCAN);
+		mutex_unlock(&dev->scan_mutex);
 		break;
 
 	case SA_AIF_BPSTAT_CHANGE:
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index b2273e3..2c862cd 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1683,6 +1683,7 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&aac->fib_lock);
 
 	mutex_init(&aac->ioctl_mutex);
+	mutex_init(&aac->scan_mutex);
 	/*
 	 *	Map in the registers from the adapter.
 	 */
-- 
2.9.4
