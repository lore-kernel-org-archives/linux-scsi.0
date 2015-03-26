From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: [V2 PATCH 07/11] aacraid: IOP RESET command handling changes
Date: Thu, 26 Mar 2015 10:41:28 -0400
Message-ID: <1427380892-1978-8-git-send-email-Mahesh.Rajashekhara@pmcs.com>
References: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:50325 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082AbbCZOsP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2015 10:48:15 -0400
In-Reply-To: <1427380892-1978-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de, JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Achim.Leubner@pmcs.com, Mahesh.Rajashekhara@pmcs.com

Add IOP RESET command handling changes

Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h  |    1 +
 drivers/scsi/aacraid/comminit.c |    4 +++-
 drivers/scsi/aacraid/src.c      |   36 +++++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index bf14ae0..9b469a4 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -1216,6 +1216,7 @@ struct aac_dev
 	int			sync_mode;
 	struct fib		*sync_fib;
 	struct list_head	sync_fib_list;
+	u32			doorbell_mask;
 	u32			max_msix;	/* max. MSI-X vectors */
 	u32			vector_cap;	/* MSI-X vector capab.*/
 	int			msi_enabled;	/* MSI/MSI-X enabled */
diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index fdd9524..284b1c5 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -358,8 +358,10 @@ struct aac_dev *aac_init_adapter(struct aac_dev *dev)
 	dev->raw_io_interface = dev->raw_io_64 = 0;
 
 	if ((!aac_adapter_sync_cmd(dev, GET_ADAPTER_PROPERTIES,
-		0, 0, 0, 0, 0, 0, status+0, status+1, status+2, NULL, NULL)) &&
+		0, 0, 0, 0, 0, 0,
+		status+0, status+1, status+2, status+3, NULL)) &&
 	 		(status[0] == 0x00000001)) {
+		dev->doorbell_mask = status[3];
 		if (status[1] & le32_to_cpu(AAC_OPT_NEW_COMM_64))
 			dev->raw_io_64 = 1;
 		dev->sync_mode = aac_sync_mode;
diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 50f181f..4a963cd 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -204,6 +204,7 @@ static int src_sync_cmd(struct aac_dev *dev, u32 command,
 	u32 *status, u32 * r1, u32 * r2, u32 * r3, u32 * r4)
 {
 	unsigned long start;
+	unsigned long delay;
 	int ok;
 
 	/*
@@ -246,10 +247,14 @@ static int src_sync_cmd(struct aac_dev *dev, u32 command,
 		ok = 0;
 		start = jiffies;
 
-		/*
-		 *	Wait up to 5 minutes
-		 */
-		while (time_before(jiffies, start+300*HZ)) {
+		if (command == IOP_RESET_ALWAYS) {
+			/* Wait up to 10 sec */
+			delay = 10*HZ;
+		} else {
+			/* Wait up to 5 minutes */
+			delay = 300*HZ;
+		}
+		while (time_before(jiffies, start+delay)) {
 			udelay(5);	/* Delay 5 microseconds to let Mon960 get info. */
 			/*
 			 *	Mon960 will set doorbell0 bit when it has completed the command.
@@ -574,10 +579,17 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
 		if (bled)
 			printk(KERN_ERR "%s%d: adapter kernel panic'd %x.\n",
 				dev->name, dev->id, bled);
+		dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 		bled = aac_adapter_sync_cmd(dev, IOP_RESET_ALWAYS,
 			0, 0, 0, 0, 0, 0, &var, &reset_mask, NULL, NULL, NULL);
-			if (bled || (var != 0x00000001))
-				return -EINVAL;
+		if ((bled || (var != 0x00000001)) &&
+		    !dev->doorbell_mask)
+			return -EINVAL;
+		else if (dev->doorbell_mask) {
+			reset_mask = dev->doorbell_mask;
+			bled = 0;
+			var = 0x00000001;
+		}
 
 		if ((dev->pdev->device == PMC_DEVICE_S7 ||
 		    dev->pdev->device == PMC_DEVICE_S8 ||
@@ -587,10 +599,13 @@ static int aac_src_restart_adapter(struct aac_dev *dev, int bled)
 			msleep(5000); /* Delay 5 seconds */
 		}
 
-		if (dev->supplement_adapter_info.SupportedOptions2 &
-			AAC_OPTION_DOORBELL_RESET) {
+		if (!bled && (dev->supplement_adapter_info.SupportedOptions2 &
+		    AAC_OPTION_DOORBELL_RESET)) {
 			src_writel(dev, MUnit.IDR, reset_mask);
 			ssleep(45);
+		} else {
+			src_writel(dev, MUnit.IDR, 0x100);
+			ssleep(45);
 		}
 	}
 
@@ -612,7 +627,6 @@ int aac_src_select_comm(struct aac_dev *dev, int comm)
 {
 	switch (comm) {
 	case AAC_COMM_MESSAGE:
-		dev->a_ops.adapter_enable_int = aac_src_enable_interrupt_message;
 		dev->a_ops.adapter_intr = aac_src_intr_message;
 		dev->a_ops.adapter_deliver = aac_src_deliver_message;
 		break;
@@ -710,6 +724,7 @@ int aac_src_init(struct aac_dev *dev)
 	 */
 	dev->a_ops.adapter_interrupt = aac_src_interrupt_adapter;
 	dev->a_ops.adapter_disable_int = aac_src_disable_interrupt;
+	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_src_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_src_check_health;
@@ -747,6 +762,7 @@ int aac_src_init(struct aac_dev *dev)
 	dev->dbg_base = pci_resource_start(dev->pdev, 2);
 	dev->dbg_base_mapped = dev->regs.src.bar1;
 	dev->dbg_size = AAC_MIN_SRC_BAR1_SIZE;
+	dev->a_ops.adapter_enable_int = aac_src_enable_interrupt_message;
 
 	aac_adapter_enable_int(dev);
 
@@ -873,6 +889,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	 */
 	dev->a_ops.adapter_interrupt = aac_src_interrupt_adapter;
 	dev->a_ops.adapter_disable_int = aac_src_disable_interrupt;
+	dev->a_ops.adapter_enable_int = aac_src_disable_interrupt;
 	dev->a_ops.adapter_notify = aac_src_notify_adapter;
 	dev->a_ops.adapter_sync_cmd = src_sync_cmd;
 	dev->a_ops.adapter_check_health = aac_src_check_health;
@@ -930,6 +947,7 @@ int aac_srcv_init(struct aac_dev *dev)
 	dev->dbg_base = dev->base_start;
 	dev->dbg_base_mapped = dev->base;
 	dev->dbg_size = dev->base_size;
+	dev->a_ops.adapter_enable_int = aac_src_enable_interrupt_message;
 
 	aac_adapter_enable_int(dev);
 
-- 
1.7.7.3

