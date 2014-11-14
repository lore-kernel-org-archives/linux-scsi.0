From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 01/13] hpsa: Clean up warnings from sparse.
Date: Fri, 14 Nov 2014 17:26:27 -0600
Message-ID: <20141114232627.20808.63834.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:37044 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935393AbaKNXYx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:24:53 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

Clean up issues reported when running sparse.

Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Webb Scales <webb.scales@hp.com>
---
 drivers/scsi/hpsa.c |   29 ++++++++++++++++-------------
 drivers/scsi/hpsa.h |    6 +++---
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index cef5d49..f345cc5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -48,6 +48,7 @@
 #include <linux/bitmap.h>
 #include <linux/atomic.h>
 #include <linux/jiffies.h>
+#include <linux/percpu-defs.h>
 #include <linux/percpu.h>
 #include <asm/div64.h>
 #include "hpsa_cmd.h"
@@ -193,12 +194,13 @@ static int number_of_controllers;
 
 static irqreturn_t do_hpsa_intr_intx(int irq, void *dev_id);
 static irqreturn_t do_hpsa_intr_msi(int irq, void *dev_id);
-static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg);
+static int hpsa_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 static void lock_and_start_io(struct ctlr_info *h);
 static void start_io(struct ctlr_info *h, unsigned long *flags);
 
 #ifdef CONFIG_COMPAT
-static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg);
+static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd,
+	void __user *arg);
 #endif
 
 static void cmd_free(struct ctlr_info *h, struct CommandList *c);
@@ -2941,8 +2943,8 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 	return 0;
 }
 
-u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position, int i,
-	int nphysicals, int nlogicals,
+static u8 *figure_lunaddrbytes(struct ctlr_info *h, int raid_ctlr_position,
+	int i, int nphysicals, int nlogicals,
 	struct ReportExtendedLUNdata *physdev_list,
 	struct ReportLUNdata *logdev_list)
 {
@@ -4410,7 +4412,7 @@ static struct CommandList *hpsa_find_cmd_in_queue(struct ctlr_info *h,
 	struct CommandList *c = NULL;	/* ptr into cmpQ */
 
 	if (!find)
-		return 0;
+		return NULL;
 	spin_lock_irqsave(&h->lock, flags);
 	list_for_each_entry(c, queue_head, list) {
 		if (c->scsi_cmd == NULL) /* e.g.: passthru ioctl */
@@ -4785,7 +4787,8 @@ static void cmd_special_free(struct ctlr_info *h, struct CommandList *c)
 
 #ifdef CONFIG_COMPAT
 
-static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
+static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd,
+	void __user *arg)
 {
 	IOCTL32_Command_struct __user *arg32 =
 	    (IOCTL32_Command_struct __user *) arg;
@@ -4810,7 +4813,7 @@ static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
 	if (err)
 		return -EFAULT;
 
-	err = hpsa_ioctl(dev, CCISS_PASSTHRU, (void *)p);
+	err = hpsa_ioctl(dev, CCISS_PASSTHRU, p);
 	if (err)
 		return err;
 	err |= copy_in_user(&arg32->error_info, &p->error_info,
@@ -4821,7 +4824,7 @@ static int hpsa_ioctl32_passthru(struct scsi_device *dev, int cmd, void *arg)
 }
 
 static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
-	int cmd, void *arg)
+	int cmd, void __user *arg)
 {
 	BIG_IOCTL32_Command_struct __user *arg32 =
 	    (BIG_IOCTL32_Command_struct __user *) arg;
@@ -4848,7 +4851,7 @@ static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
 	if (err)
 		return -EFAULT;
 
-	err = hpsa_ioctl(dev, CCISS_BIG_PASSTHRU, (void *)p);
+	err = hpsa_ioctl(dev, CCISS_BIG_PASSTHRU, p);
 	if (err)
 		return err;
 	err |= copy_in_user(&arg32->error_info, &p->error_info,
@@ -4858,7 +4861,7 @@ static int hpsa_ioctl32_big_passthru(struct scsi_device *dev,
 	return err;
 }
 
-static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void *arg)
+static int hpsa_compat_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 {
 	switch (cmd) {
 	case CCISS_GETPCIINFO:
@@ -5206,7 +5209,7 @@ static void decrement_passthru_count(struct ctlr_info *h)
 /*
  * ioctl
  */
-static int hpsa_ioctl(struct scsi_device *dev, int cmd, void *arg)
+static int hpsa_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 {
 	struct ctlr_info *h;
 	void __user *argp = (void __user *)arg;
@@ -5818,7 +5821,7 @@ static int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 #define hpsa_noop(p) hpsa_message(p, 3, 0)
 
 static int hpsa_controller_hard_reset(struct pci_dev *pdev,
-	void * __iomem vaddr, u32 use_doorbell)
+	void __iomem *vaddr, u32 use_doorbell)
 {
 	u16 pmcsr;
 	int pos;
@@ -6056,7 +6059,7 @@ unmap_vaddr:
  *   the io functions.
  *   This is for debug only.
  */
-static void print_cfg_table(struct device *dev, struct CfgTable *tb)
+static void print_cfg_table(struct device *dev, struct CfgTable __iomem *tb)
 {
 #ifdef HPSA_DEBUG
 	int i;
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 24472ce..80fa9a9 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -164,7 +164,7 @@ struct ctlr_info {
 	 */
 	u32 trans_support;
 	u32 trans_offset;
-	struct TransTable_struct *transtable;
+	struct TransTable_struct __iomem *transtable;
 	unsigned long transMethod;
 
 	/* cap concurrent passthrus at some reasonable maximum */
@@ -181,7 +181,7 @@ struct ctlr_info {
 	u32 *blockFetchTable;
 	u32 *ioaccel1_blockFetchTable;
 	u32 *ioaccel2_blockFetchTable;
-	u32 *ioaccel2_bft2_regs;
+	u32 __iomem *ioaccel2_bft2_regs;
 	unsigned char *hba_inquiry_data;
 	u32 driver_support;
 	u32 fw_support;
@@ -192,7 +192,7 @@ struct ctlr_info {
 	u64 last_heartbeat_timestamp;
 	u32 heartbeat_sample_interval;
 	atomic_t firmware_flash_in_progress;
-	u32 *lockup_detected;
+	u32 __percpu *lockup_detected;
 	struct delayed_work monitor_ctlr_work;
 	int remove_in_progress;
 	u32 fifo_recently_full;

