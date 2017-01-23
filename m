From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 19/24] aacraid: Added new IWBR reset
Date: Mon, 23 Jan 2017 10:09:03 -0800
Message-ID: <20170123180908.3465-20-RaghavaAditya.Renukunta@microsemi.com>
References: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0053.outbound.protection.outlook.com ([104.47.37.53]:15831
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751952AbdAXArL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 19:47:11 -0500
In-Reply-To: <20170123180908.3465-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, RaghavaAditya.Renukunta@microsemi.com, Scott.Banesh@microsemi.com

Added a new IWBR soft reset type, reworked the IOP reset interface for
a bit.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Signed-off-by: Dave Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aacraid.h |  15 +++--
 drivers/scsi/aacraid/commsup.c |  15 +++--
 drivers/scsi/aacraid/linit.c   |   8 ++-
 drivers/scsi/aacraid/rx.c      |  10 ++--
 drivers/scsi/aacraid/sa.c      |   2 +-
 drivers/scsi/aacraid/src.c     | 129 ++++++++++++++++++++++++++++++-----------
 6 files changed, 127 insertions(+), 52 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 58bb7a6..ed521bb 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -882,7 +882,7 @@ struct adapter_ops
 	void (*adapter_enable_int)(struct aac_dev *dev);
 	int  (*adapter_sync_cmd)(struct aac_dev *dev, u32 command, u32 p1, u32 p2, u32 p3, u32 p4, u32 p5, u32 p6, u32 *status, u32 *r1, u32 *r2, u32 *r3, u32 *r4);
 	int  (*adapter_check_health)(struct aac_dev *dev);
-	int  (*adapter_restart)(struct aac_dev *dev, int bled);
+	int  (*adapter_restart)(struct aac_dev *dev, int bled, u8 reset_type);
 	void (*adapter_start)(struct aac_dev *dev);
 	/* Transport operations */
 	int  (*adapter_ioremap)(struct aac_dev * dev, u32 size);
@@ -1661,8 +1661,8 @@ struct aac_dev
 #define aac_adapter_check_health(dev) \
 	(dev)->a_ops.adapter_check_health(dev)
 
-#define aac_adapter_restart(dev,bled) \
-	(dev)->a_ops.adapter_restart(dev,bled)
+#define aac_adapter_restart(dev, bled, reset_type) \
+	((dev)->a_ops.adapter_restart(dev, bled, reset_type))
 
 #define aac_adapter_start(dev) \
 	((dev)->a_ops.adapter_start(dev))
@@ -2337,6 +2337,13 @@ struct revision
 #define FSACTL_FORCE_DELETE_DISK		CTL_CODE(2120, METHOD_NEITHER)
 #define FSACTL_GET_CONTAINERS			2131
 #define FSACTL_SEND_LARGE_FIB			CTL_CODE(2138, METHOD_BUFFERED)
+/* flags defined for IOP & HW SOFT RESET */
+#define HW_IOP_RESET				0x01
+#define HW_SOFT_RESET				0x02
+#define IOP_HWSOFT_RESET			(HW_IOP_RESET | HW_SOFT_RESET)
+/* HW Soft Reset register offset */
+#define IBW_SWR_OFFSET				0x4000
+#define SOFT_RESET_TIME			60
 
 
 struct aac_common
@@ -2573,7 +2580,7 @@ unsigned int aac_command_normal(struct aac_queue * q);
 unsigned int aac_intr_normal(struct aac_dev *dev, u32 Index,
 			int isAif, int isFastResponse,
 			struct hw_fib *aif_fib);
-int aac_reset_adapter(struct aac_dev * dev, int forced);
+int aac_reset_adapter(struct aac_dev *dev, int forced, u8 reset_type);
 int aac_check_health(struct aac_dev * dev);
 int aac_command_thread(void *data);
 int aac_close_fib_context(struct aac_dev * dev, struct aac_fib_context *fibctx);
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 13c5c10..d6e3fa0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1455,7 +1455,7 @@ static void aac_handle_aif(struct aac_dev * dev, struct fib * fibptr)
 	}
 }
 
-static int _aac_reset_adapter(struct aac_dev *aac, int forced)
+static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 {
 	int index, quirks;
 	int retval;
@@ -1464,6 +1464,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	struct scsi_cmnd *command;
 	struct scsi_cmnd *command_list;
 	int jafo = 0;
+	int bled;
 
 	/*
 	 * Assumptions:
@@ -1488,7 +1489,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	 *	If a positive health, means in a known DEAD PANIC
 	 * state and the adapter could be reset to `try again'.
 	 */
-	retval = aac_adapter_restart(aac, forced ? 0 : aac_adapter_check_health(aac));
+	bled = forced ? 0 : aac_adapter_check_health(aac);
+	retval = aac_adapter_restart(aac, bled, reset_type);
 
 	if (retval)
 		goto out;
@@ -1598,7 +1600,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced)
 	return retval;
 }
 
-int aac_reset_adapter(struct aac_dev * aac, int forced)
+int aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 {
 	unsigned long flagv = 0;
 	int retval;
@@ -1651,7 +1653,9 @@ int aac_reset_adapter(struct aac_dev * aac, int forced)
 	if (forced < 2)
 		aac_send_shutdown(aac);
 	spin_lock_irqsave(host->host_lock, flagv);
-	retval = _aac_reset_adapter(aac, forced ? forced : ((aac_check_reset != 0) && (aac_check_reset != 1)));
+	retval = _aac_reset_adapter(aac,
+		forced ? forced : ((aac_check_reset != 0) &&
+		(aac_check_reset != 1)), reset_type);
 	spin_unlock_irqrestore(host->host_lock, flagv);
 
 	if ((forced < 2) && (retval == -ENODEV)) {
@@ -1814,7 +1818,8 @@ int aac_check_health(struct aac_dev * aac)
 	host = aac->scsi_host_ptr;
 	if (aac->thread->pid != current->pid)
 		spin_lock_irqsave(host->host_lock, flagv);
-	BlinkLED = _aac_reset_adapter(aac, aac_check_reset != 1);
+	BlinkLED = _aac_reset_adapter(aac,
+		aac_check_reset != 1, IOP_HWSOFT_RESET);
 	if (aac->thread->pid != current->pid)
 		spin_unlock_irqrestore(host->host_lock, flagv);
 	return BlinkLED;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index d86c178..99430aa 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -561,7 +561,7 @@ static ssize_t aac_show_unique_id(struct device *dev,
 		memcpy(sn, aac->fsa_dev[sdev_id(sdev)].identifier, sizeof(sn));
 
 	return snprintf(buf, 16 * 2 + 2,
-		"%02X%02X%02X%02X%02X%02X%02X%02X %02X%02X%02X%02X%02X%02X%02X%02X\n",
+		"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X\n",
 		sn[0], sn[1], sn[2], sn[3],
 		sn[4], sn[5], sn[6], sn[7],
 		sn[8], sn[9], sn[10], sn[11],
@@ -889,7 +889,7 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 			   !(aac->supplement_adapter_info.SupportedOptions2 &
 			    AAC_OPTION_IGNORE_RESET))) {
 			/* Bypass wait for command quiesce */
-			aac_reset_adapter(aac, 2);
+			aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET);
 		}
 		ret = SUCCESS;
 	}
@@ -1160,7 +1160,9 @@ static ssize_t aac_store_reset_adapter(struct device *device,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return retval;
-	retval = aac_reset_adapter((struct aac_dev*)class_to_shost(device)->hostdata, buf[0] == '!');
+	retval = aac_reset_adapter((struct aac_dev *)
+		class_to_shost(device)->hostdata,
+		buf[0] == '!', IOP_HWSOFT_RESET);
 	if (retval >= 0)
 		retval = count;
 	return retval;
diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
index 9810509..a29e0f3 100644
--- a/drivers/scsi/aacraid/rx.c
+++ b/drivers/scsi/aacraid/rx.c
@@ -470,7 +470,7 @@ static int aac_rx_ioremap(struct aac_dev * dev, u32 size)
 	return 0;
 }
 
-static int aac_rx_restart_adapter(struct aac_dev *dev, int bled)
+static int aac_rx_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 {
 	u32 var = 0;
 
@@ -559,7 +559,7 @@ int _aac_rx_init(struct aac_dev *dev)
 	dev->a_ops.adapter_enable_int = aac_rx_disable_interrupt;
 	dev->OIMR = status = rx_readb (dev, MUnit.OIMR);
 	if ((((status & 0x0c) != 0x0c) || aac_reset_devices || reset_devices) &&
-	  !aac_rx_restart_adapter(dev, 0))
+	  !aac_rx_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
 		/* Make sure the Hardware FIFO is empty */
 		while ((++restart < 512) &&
 		  (rx_readl(dev, MUnit.OutboundQueue) != 0xFFFFFFFFL));
@@ -568,7 +568,8 @@ int _aac_rx_init(struct aac_dev *dev)
 	 */
 	status = rx_readl(dev, MUnit.OMRx[0]);
 	if (status & KERNEL_PANIC) {
-		if (aac_rx_restart_adapter(dev, aac_rx_check_health(dev)))
+		if (aac_rx_restart_adapter(dev,
+			aac_rx_check_health(dev), IOP_HWSOFT_RESET))
 			goto error_iounmap;
 		++restart;
 	}
@@ -606,7 +607,8 @@ int _aac_rx_init(struct aac_dev *dev)
 		  ((startup_timeout > 60)
 		    ? (startup_timeout - 60)
 		    : (startup_timeout / 2))))) {
-			if (likely(!aac_rx_restart_adapter(dev, aac_rx_check_health(dev))))
+			if (likely(!aac_rx_restart_adapter(dev,
+				aac_rx_check_health(dev), IOP_HWSOFT_RESET)))
 				start = jiffies;
 			++restart;
 		}
diff --git a/drivers/scsi/aacraid/sa.c b/drivers/scsi/aacraid/sa.c
index 2c9629d..a03516e 100644
--- a/drivers/scsi/aacraid/sa.c
+++ b/drivers/scsi/aacraid/sa.c
@@ -257,7 +257,7 @@ static void aac_sa_start_adapter(struct aac_dev *dev)
 			NULL, NULL, NULL, NULL, NULL);
 }
 
-static int aac_sa_restart_adapter(struct aac_dev *dev, int bled)
+static int aac_sa_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
 {
 	return -EINVAL;
 }
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 40a486f..a9ad39d 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -656,44 +656,100 @@ static int aac_srcv_ioremap(struct aac_dev *dev, u32 size)
 	return 0;
 }
 
-static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
+static void aac_set_intx_mode(struct aac_dev *dev)
+{
+	if (dev->msi_enabled) {
+		aac_src_access_devreg(dev, AAC_ENABLE_INTX);
+		dev->msi_enabled = 0;
+		msleep(5000); /* Delay 5 seconds */
+	}
+}
+
+static void aac_send_iop_reset(struct aac_dev *dev, int bled)
 {
 	u32 var, reset_mask;
 
-	if (bled >= 0) {
-		if (bled)
-			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
+	bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
+				    0, 0, 0, 0, 0, 0, &var,
+				    &reset_mask, NULL, NULL, NULL);
+
+	if ((bled || var != 0x00000001) && !dev->doorbell_mask)
+		bled = -EINVAL;
+	else if (dev->doorbell_mask) {
+		reset_mask = dev->doorbell_mask;
+		bled = 0;
+		var = 0x00000001;
+	}
+
+	aac_set_intx_mode(dev);
+
+	if (!bled && (dev->supplement_adapter_info.SupportedOptions2 &
+	    AAC_OPTION_DOORBELL_RESET)) {
+		src_writel(dev, MUnit.IDR, reset_mask);
+	} else {
+		src_writel(dev, MUnit.IDR, 0x100);
+	}
+	msleep(30000);
+}
+
+static void aac_send_hardware_soft_reset(struct aac_dev *dev)
+{
+	u_int32_t val;
+
+	val = readl(((char *)(dev->base) + IBW_SWR_OFFSET));
+	val |= 0x01;
+	writel(val, ((char *)(dev->base) + IBW_SWR_OFFSET));
+	msleep_interruptible(20000);
+}
+
+static int aac_src_restart_adapter(struct aac_dev *dev, int bled, u8 reset_type)
+{
+	unsigned long status, start;
+
+	if (bled < 0)
+		goto invalid_out;
+
+	if (bled)
+		pr_err("%s%d: adapter kernel panic'd %x.\n",
 				dev->name, dev->id, bled);
-		dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
-		bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
-			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL, NULL);
-		if ((bled || (var != 0x00000001)) &&
-		    !dev->doorbell_mask)
-			return -EINVAL;
-		else if (dev->doorbell_mask) {
-			reset_mask = dev->doorbell_mask;
-			bled = 0;
-			var = 0x00000001;
-		}
 
-		if ((dev->pdev->device == PMC_DEVICE_S7 ||
-		    dev->pdev->device == PMC_DEVICE_S8 ||
-		    dev->pdev->device == PMC_DEVICE_S9) && dev->msi_enabled) {
-			aac_src_access_devreg(dev, AAC_ENABLE_INTX);
-			dev->msi_enabled = 0;
-			msleep(5000); /* Delay 5 seconds */
-		}
+	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 
-		if (!bled && (dev->supplement_adapter_info.SupportedOptions2 &
-		    AAC_OPTION_DOORBELL_RESET)) {
-			src_writel(dev, MUnit.IDR, reset_mask);
-			ssleep(45);
-		} else {
-			src_writel(dev, MUnit.IDR, 0x100);
-			ssleep(45);
+	switch (reset_type) {
+	case IOP_HWSOFT_RESET:
+		aac_send_iop_reset(dev, bled);
+		/*
+		 * Check to see if KERNEL_UP_AND_RUNNING
+		 * Wait for the adapter to be up and running.
+		 * If !KERNEL_UP_AND_RUNNING issue HW Soft Reset
+		 */
+		status = src_readl(dev, MUnit.OMR);
+		if (dev->sa_firmware
+		 && !(status & KERNEL_UP_AND_RUNNING)) {
+			start = jiffies;
+			do {
+				status = src_readl(dev, MUnit.OMR);
+				if (time_after(jiffies,
+				 start+HZ*SOFT_RESET_TIME)) {
+					aac_send_hardware_soft_reset(dev);
+					start = jiffies;
+				}
+			} while (!(status & KERNEL_UP_AND_RUNNING));
 		}
+		break;
+	case HW_SOFT_RESET:
+		if (dev->sa_firmware) {
+			aac_send_hardware_soft_reset(dev);
+			aac_set_intx_mode(dev);
+		}
+		break;
+	default:
+		aac_send_iop_reset(dev, bled);
+		break;
 	}
 
+invalid_out:
+
 	if (src_readl(dev, MUnit.OMR) & KERNEL_PANIC)
 		return -ENODEV;
 
@@ -748,14 +804,15 @@ int aac_src_init(struct aac_dev *dev)
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 	if ((aac_reset_devices || reset_devices) &&
-		!aac_src_restart_adapter(dev, 0))
+		!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
 		++restart;
 	/*
 	 *	Check to see if the board panic'd while booting.
 	 */
 	status = src_readl(dev, MUnit.OMR);
 	if (status & KERNEL_PANIC) {
-		if (aac_src_restart_adapter(dev, aac_src_check_health(dev)))
+		if (aac_src_restart_adapter(dev,
+			aac_src_check_health(dev), IOP_HWSOFT_RESET))
 			goto error_iounmap;
 		++restart;
 	}
@@ -796,7 +853,7 @@ int aac_src_init(struct aac_dev *dev)
 		    ? (startup_timeout - 60)
 		    : (startup_timeout / 2))))) {
 			if (likely(!aac_src_restart_adapter(dev,
-			    aac_src_check_health(dev))))
+				aac_src_check_health(dev), IOP_HWSOFT_RESET)))
 				start = jiffies;
 			++restart;
 		}
@@ -893,7 +950,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 	if ((aac_reset_devices || reset_devices) &&
-		!aac_src_restart_adapter(dev, 0))
+		!aac_src_restart_adapter(dev, 0, IOP_HWSOFT_RESET))
 		++restart;
 	/*
 	 *	Check to see if flash update is running.
@@ -922,7 +979,8 @@ int aac_srcv_init(struct aac_dev *dev)
 	 */
 	status = src_readl(dev, MUnit.OMR);
 	if (status & KERNEL_PANIC) {
-		if (aac_src_restart_adapter(dev, aac_src_check_health(dev)))
+		if (aac_src_restart_adapter(dev,
+			aac_src_check_health(dev), IOP_HWSOFT_RESET))
 			goto error_iounmap;
 		++restart;
 	}
@@ -961,7 +1019,8 @@ int aac_srcv_init(struct aac_dev *dev)
 		  ((startup_timeout > 60)
 		    ? (startup_timeout - 60)
 		    : (startup_timeout / 2))))) {
-			if (likely(!aac_src_restart_adapter(dev, aac_src_check_health(dev))))
+			if (likely(!aac_src_restart_adapter(dev,
+				aac_src_check_health(dev), IOP_HWSOFT_RESET)))
 				start = jiffies;
 			++restart;
 		}
-- 
2.7.4

