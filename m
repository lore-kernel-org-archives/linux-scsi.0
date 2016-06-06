From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH] scsi:stex.c Support Pegasus 3 product
Date: Mon,  6 Jun 2016 15:53:53 +0800
Message-ID: <1465199633-21182-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com, paul.lyu@tw.promise.com
List-Id: linux-scsi@vger.kernel.org

From: Charles <charles.chiou@tw.promise.com>

Pegasus series is a RAID support product by using Thunderbolt technology.

The newest product, Pegasus 3 is support Thunderbolt 3 technology with another chip.

1.Change driver version.

2.Add Pegasus 3 VID, DID and define it's device address.

3.Pegasus 3 use msi interrupt, so stex_request_irq P3 type enable msi.

4.For hibernation, use msi_lock in stex_ss_handshake to prevent msi register write again when handshaking.

5.Pegasus 3 don't need read() as flush.

6.In stex_ss_intr & stex_abort, P3 only clear interrupt register when getting vendor defined interrupt.

7.Add reboot notifier and register it in stex_probe for all supported device.

8.For all supported device in restart flow, we get a callback from notifier and set S6flag for stex_shutdown & stex_hba_stop to send restart command to FW.

Signed-off-by: Charles <charles.chiou@tw.promise.com>
Signed-off-by: Paul <paul.lyu@tw.promise.com>
---
 drivers/scsi/stex.c | 282 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 214 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 5b23175..9de2de2 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/ktime.h>
+#include <linux/reboot.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -38,8 +39,8 @@
 #include <scsi/scsi_eh.h>
 
 #define DRV_NAME "stex"
-#define ST_DRIVER_VERSION	"5.00.0000.01"
-#define ST_VER_MAJOR		5
+#define ST_DRIVER_VERSION	"6.00.0000.01"
+#define ST_VER_MAJOR		6
 #define ST_VER_MINOR		00
 #define ST_OEM				0000
 #define ST_BUILD_VER		01
@@ -64,6 +65,13 @@ enum {
 	YI2H_INT_C				= 0xa0,
 	YH2I_REQ				= 0xc0,
 	YH2I_REQ_HI				= 0xc4,
+	PSCRATCH0				= 0xb0,
+	PSCRATCH1				= 0xb4,
+	PSCRATCH2				= 0xb8,
+	PSCRATCH3				= 0xbc,
+	PSCRATCH4				= 0xc8,
+	MAILBOX_BASE			= 0x1000,
+	MAILBOX_HNDSHK_STS		= 0x0,
 
 	/* MU register value */
 	MU_INBOUND_DOORBELL_HANDSHAKE		= (1 << 0),
@@ -87,7 +95,7 @@ enum {
 	MU_STATE_STOP				= 5,
 	MU_STATE_NOCONNECT			= 6,
 
-	MU_MAX_DELAY				= 120,
+	MU_MAX_DELAY				= 50,
 	MU_HANDSHAKE_SIGNATURE			= 0x55aaaa55,
 	MU_HANDSHAKE_SIGNATURE_HALF		= 0x5a5a0000,
 	MU_HARD_RESET_WAIT			= 30000,
@@ -135,6 +143,7 @@ enum {
 	st_yosemite				= 2,
 	st_seq					= 3,
 	st_yel					= 4,
+	st_P3					= 5,
 
 	PASSTHRU_REQ_TYPE			= 0x00000001,
 	PASSTHRU_REQ_NO_WAKEUP			= 0x00000100,
@@ -339,6 +348,7 @@ struct st_hba {
 	u16 rq_size;
 	u16 sts_count;
 	u8  supports_pm;
+	int msi_lock;
 };
 
 struct st_card_info {
@@ -353,6 +363,12 @@ struct st_card_info {
 	u16 sts_count;
 };
 
+int S6flag;
+static int stex_halt(struct notifier_block *nb, ulong event, void *buf);
+static struct notifier_block stex_notifier = {
+	stex_halt, NULL, 0
+};
+
 static int msi;
 module_param(msi, int, 0);
 MODULE_PARM_DESC(msi, "Enable Message Signaled Interrupts(0=off, 1=on)");
@@ -540,11 +556,15 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 
 	++hba->req_head;
 	hba->req_head %= hba->rq_count+1;
-
-	writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
-	readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
-	writel(addr, hba->mmio_base + YH2I_REQ);
-	readl(hba->mmio_base + YH2I_REQ); /* flush */
+	if (hba->cardtype == st_P3) {
+		writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
+		writel(addr, hba->mmio_base + YH2I_REQ);
+	} else {
+		writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
+		readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
+		writel(addr, hba->mmio_base + YH2I_REQ);
+		readl(hba->mmio_base + YH2I_REQ); /* flush */
+	}
 }
 
 static void return_abnormal_state(struct st_hba *hba, int status)
@@ -974,15 +994,31 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 
-	data = readl(base + YI2H_INT);
-	if (data && data != 0xffffffff) {
-		/* clear the interrupt */
-		writel(data, base + YI2H_INT_C);
-		stex_ss_mu_intr(hba);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		if (unlikely(data & SS_I2H_REQUEST_RESET))
-			queue_work(hba->work_q, &hba->reset_work);
-		return IRQ_HANDLED;
+	if (hba->cardtype == st_yel) {
+		data = readl(base + YI2H_INT);
+		if (data && data != 0xffffffff) {
+			/* clear the interrupt */
+			writel(data, base + YI2H_INT_C);
+			stex_ss_mu_intr(hba);
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			if (unlikely(data & SS_I2H_REQUEST_RESET))
+				queue_work(hba->work_q, &hba->reset_work);
+			return IRQ_HANDLED;
+		}
+	} else {
+		data = readl(base + PSCRATCH4);
+		if (data != 0xffffffff) {
+			if (data != 0) {
+				/* clear the interrupt */
+				writel(data, base + PSCRATCH1);
+				writel((1 << 22), base + YH2I_INT);
+			}
+			stex_ss_mu_intr(hba);
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			if (unlikely(data & SS_I2H_REQUEST_RESET))
+				queue_work(hba->work_q, &hba->reset_work);
+			return IRQ_HANDLED;
+		}
 	}
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1085,14 +1121,27 @@ static int stex_ss_handshake(struct st_hba *hba)
 	int ret = 0;
 
 	before = jiffies;
-	while ((readl(base + YIOA_STATUS) & SS_MU_OPERATIONAL) == 0) {
-		if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
-			printk(KERN_ERR DRV_NAME
-				"(%s): firmware not operational\n",
-				pci_name(hba->pdev));
-			return -1;
+
+	if (hba->cardtype == st_yel) {
+		while ((readl(base + YIOA_STATUS) & SS_MU_OPERATIONAL) == 0) {
+			if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
+				printk(KERN_ERR DRV_NAME
+					"(%s): firmware not operational\n",
+					pci_name(hba->pdev));
+				return -1;
+			}
+			msleep(1);
+		}
+	} else if (hba->cardtype == st_P3) {
+		while ((readl(base + PSCRATCH3) & SS_MU_OPERATIONAL) == 0) {
+			if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
+				printk(KERN_ERR DRV_NAME
+					"(%s): firmware not operational\n",
+					pci_name(hba->pdev));
+				return -1;
+			}
+			msleep(1);
 		}
-		msleep(1);
 	}
 
 	msg_h = (struct st_msg_header *)hba->dma_mem;
@@ -1111,30 +1160,63 @@ static int stex_ss_handshake(struct st_hba *hba)
 	scratch_size = (hba->sts_count+1)*sizeof(u32);
 	h->scratch_size = cpu_to_le32(scratch_size);
 
-	data = readl(base + YINT_EN);
-	data &= ~4;
-	writel(data, base + YINT_EN);
-	writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
-	readl(base + YH2I_REQ_HI);
-	writel(hba->dma_handle, base + YH2I_REQ);
-	readl(base + YH2I_REQ); /* flush */
+	if (hba->cardtype == st_yel) {
+		data = readl(base + YINT_EN);
+		data &= ~4;
+		writel(data, base + YINT_EN);
+		writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
+		readl(base + YH2I_REQ_HI);
+		writel(hba->dma_handle, base + YH2I_REQ);
+		readl(base + YH2I_REQ); /* flush */
+	} else if (hba->cardtype == st_P3) {
+		data = readl(base + YINT_EN);
+		data &= ~(1 << 0);
+		data &= ~(1 << 2);
+		writel(data, base + YINT_EN);
+		if (hba->msi_lock == 0) {
+			/* P3 MSI Register cannot access twice */
+			writel((1 << 6), base + YH2I_INT);
+			hba->msi_lock  = 1;
+		}
+		writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
+		writel(hba->dma_handle, base + YH2I_REQ);
+	}
 
-	scratch = hba->scratch;
 	before = jiffies;
-	while (!(le32_to_cpu(*scratch) & SS_STS_HANDSHAKE)) {
-		if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
-			printk(KERN_ERR DRV_NAME
-				"(%s): no signature after handshake frame\n",
-				pci_name(hba->pdev));
-			ret = -1;
-			break;
+
+	if (hba->cardtype == st_yel) {
+		scratch = hba->scratch;
+
+		while (!(le32_to_cpu(*scratch) & SS_STS_HANDSHAKE)) {
+			if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
+				printk(KERN_ERR DRV_NAME
+					"(%s): no signature after handshake frame\n",
+					pci_name(hba->pdev));
+				ret = -1;
+				break;
+			}
+			rmb();
+			msleep(1);
 		}
-		rmb();
-		msleep(1);
+		memset(scratch, 0, scratch_size);
+	} else if (hba->cardtype == st_P3) {
+		while ((readl(base + MAILBOX_BASE + MAILBOX_HNDSHK_STS)
+		 & SS_STS_HANDSHAKE) == 0) {
+			if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
+				printk(KERN_ERR DRV_NAME
+					"(%s): no signature after handshake frame\n",
+					pci_name(hba->pdev));
+				ret = -1;
+				break;
+			}
+			rmb();
+			msleep(1);
+		}
+		memset(hba->scratch, 0, scratch_size);
 	}
 
-	memset(scratch, 0, scratch_size);
 	msg_h->flag = 0;
+
 	return ret;
 }
 
@@ -1144,7 +1226,7 @@ static int stex_handshake(struct st_hba *hba)
 	unsigned long flags;
 	unsigned int mu_status;
 
-	err = (hba->cardtype == st_yel) ?
+	err = (hba->cardtype == st_yel || hba->cardtype == st_P3) ?
 		stex_ss_handshake(hba) : stex_common_handshake(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	mu_status = hba->mu_status;
@@ -1190,6 +1272,15 @@ static int stex_abort(struct scsi_cmnd *cmd)
 
 		writel(data, base + YI2H_INT_C);
 		stex_ss_mu_intr(hba);
+	} else if (hba->cardtype == st_P3) {
+		data = readl(base + PSCRATCH4);
+		if (data == 0xffffffff)
+			goto fail_out;
+		if (data != 0) {
+			writel(data, base + PSCRATCH1);
+			writel((1 << 22), base + YH2I_INT);
+		}
+		stex_ss_mu_intr(hba);
 	} else {
 		data = readl(base + ODBL);
 		if (data == 0 || data == 0xffffffff)
@@ -1197,9 +1288,9 @@ static int stex_abort(struct scsi_cmnd *cmd)
 
 		writel(data, base + ODBL);
 		readl(base + ODBL); /* flush */
-
 		stex_mu_intr(hba, data);
 	}
+
 	if (hba->wait_ccb == NULL) {
 		printk(KERN_WARNING DRV_NAME
 			"(%s): lost interrupt\n", pci_name(hba->pdev));
@@ -1293,6 +1384,12 @@ static void stex_ss_reset(struct st_hba *hba)
 	ssleep(5);
 }
 
+static void stex_p3_reset(struct st_hba *hba)
+{
+	writel(SS_H2I_INT_RESET, hba->mmio_base + YH2I_INT);
+	ssleep(5);
+}
+
 static int stex_do_reset(struct st_hba *hba)
 {
 	unsigned long flags;
@@ -1329,7 +1426,8 @@ static int stex_do_reset(struct st_hba *hba)
 		stex_hard_reset(hba);
 	else if (hba->cardtype == st_yel)
 		stex_ss_reset(hba);
-
+	else if (hba->cardtype == st_P3)
+		stex_p3_reset(hba);
 
 	return_abnormal_state(hba, DID_RESET);
 
@@ -1414,6 +1512,13 @@ static struct pci_device_id stex_pci_tbl[] = {
 	/* st_yel */
 	{ 0x105a, 0x8650, 0x1033, PCI_ANY_ID, 0, 0, st_yel },
 	{ 0x105a, 0x8760, PCI_ANY_ID, PCI_ANY_ID, 0, 0, st_yel },
+
+	/* st_P3, pluto */
+	{ PCI_VENDOR_ID_PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE,
+		0x8870, 0, 0, st_P3 },
+	/* st_P3, p3 */
+	{ PCI_VENDOR_ID_PROMISE, 0x8870, PCI_VENDOR_ID_PROMISE,
+		0x4300, 0, 0, st_P3 },
 	{ }	/* terminate list */
 };
 
@@ -1482,6 +1587,19 @@ static struct st_card_info stex_card_info[] = {
 		.map_sg		= stex_ss_map_sg,
 		.send		= stex_ss_send_cmd,
 	},
+
+	/* st_P3 */
+	{
+		.max_id		= 129,
+		.max_lun	= 256,
+		.max_channel	= 0,
+		.rq_count	= 801,
+		.rq_size	= 512,
+		.sts_count	= 801,
+		.alloc_rq	= stex_ss_alloc_req,
+		.map_sg		= stex_ss_map_sg,
+		.send		= stex_ss_send_cmd,
+	},
 };
 
 static int stex_set_dma_mask(struct pci_dev * pdev)
@@ -1502,18 +1620,30 @@ static int stex_request_irq(struct st_hba *hba)
 	struct pci_dev *pdev = hba->pdev;
 	int status;
 
-	if (msi) {
+	if (hba->cardtype == st_yel) {
+		if (msi) {
+			status = pci_enable_msi(pdev);
+			if (status != 0)
+				printk(KERN_ERR DRV_NAME
+					"(%s): error %d setting up MSI\n",
+					 pci_name(pdev), status);
+			else
+				hba->msi_enabled = 1;
+		} else
+			hba->msi_enabled = 0;
+	} else if (hba->cardtype == st_P3) {
 		status = pci_enable_msi(pdev);
 		if (status != 0)
 			printk(KERN_ERR DRV_NAME
 				"(%s): error %d setting up MSI\n",
-				pci_name(pdev), status);
+				 pci_name(pdev), status);
 		else
 			hba->msi_enabled = 1;
 	} else
 		hba->msi_enabled = 0;
 
-	status = request_irq(pdev->irq, hba->cardtype == st_yel ?
+	status = request_irq(pdev->irq,
+		(hba->cardtype == st_yel || hba->cardtype == st_P3) ?
 		stex_ss_intr : stex_intr, IRQF_SHARED, DRV_NAME, hba);
 
 	if (status != 0) {
@@ -1546,6 +1676,9 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_master(pdev);
 
+	S6flag = 0;
+	register_reboot_notifier(&stex_notifier);
+
 	host = scsi_host_alloc(&driver_template, sizeof(struct st_hba));
 
 	if (!host) {
@@ -1597,12 +1730,12 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	case 0x4265:
 		break;
 	default:
-		if (hba->cardtype == st_yel)
+		if (hba->cardtype == st_yel || hba->cardtype == st_P3)
 			hba->supports_pm = 1;
 	}
 
 	sts_offset = scratch_offset = (ci->rq_count+1) * ci->rq_size;
-	if (hba->cardtype == st_yel)
+	if (hba->cardtype == st_yel || hba->cardtype == st_P3)
 		sts_offset += (ci->sts_count+1) * sizeof(u32);
 	cp_offset = sts_offset + (ci->sts_count+1) * sizeof(struct status_msg);
 	hba->dma_size = cp_offset + sizeof(struct st_frame);
@@ -1642,7 +1775,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_pci_free;
 	}
 
-	if (hba->cardtype == st_yel)
+	if (hba->cardtype == st_yel || hba->cardtype == st_P3)
 		hba->scratch = (__le32 *)(hba->dma_mem + scratch_offset);
 	hba->status_buffer = (struct status_msg *)(hba->dma_mem + sts_offset);
 	hba->copy_buffer = hba->dma_mem + cp_offset;
@@ -1653,8 +1786,9 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hba->map_sg = ci->map_sg;
 	hba->send = ci->send;
 	hba->mu_status = MU_STATE_STARTING;
+	hba->msi_lock = 0;
 
-	if (hba->cardtype == st_yel)
+	if (hba->cardtype == st_yel || hba->cardtype == st_P3)
 		host->sg_tablesize = 38;
 	else
 		host->sg_tablesize = 32;
@@ -1736,28 +1870,29 @@ static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 
-	if (hba->cardtype == st_yel && hba->supports_pm == 1)
-	{
-		if(st_sleep_mic == ST_NOTHANDLED)
-		{
+	if ((hba->cardtype == st_yel && hba->supports_pm == 1)
+		|| (hba->cardtype == st_P3 && hba->supports_pm == 1)) {
+		if (st_sleep_mic == ST_NOTHANDLED) {
 			spin_unlock_irqrestore(hba->host->host_lock, flags);
 			return;
 		}
 	}
 	req = hba->alloc_rq(hba);
-	if (hba->cardtype == st_yel) {
+	if (hba->cardtype == st_yel || hba->cardtype == st_P3) {
 		msg_h = (struct st_msg_header *)req - 1;
 		memset(msg_h, 0, hba->rq_size);
 	} else
 		memset(req, 0, hba->rq_size);
 
-	if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel)
+	if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel
+		|| hba->cardtype == st_P3)
 		&& st_sleep_mic == ST_IGNORED) {
 		req->cdb[0] = MGT_CMD;
 		req->cdb[1] = MGT_CMD_SIGNATURE;
 		req->cdb[2] = CTLR_CONFIG_CMD;
 		req->cdb[3] = CTLR_SHUTDOWN;
-	} else if (hba->cardtype == st_yel && st_sleep_mic != ST_IGNORED) {
+	} else if ((hba->cardtype == st_yel || hba->cardtype == st_P3)
+		&& st_sleep_mic != ST_IGNORED) {
 		req->cdb[0] = MGT_CMD;
 		req->cdb[1] = MGT_CMD_SIGNATURE;
 		req->cdb[2] = CTLR_CONFIG_CMD;
@@ -1768,16 +1903,14 @@ static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
 		req->cdb[1] = CTLR_POWER_STATE_CHANGE;
 		req->cdb[2] = CTLR_POWER_SAVING;
 	}
-
 	hba->ccb[tag].cmd = NULL;
 	hba->ccb[tag].sg_count = 0;
 	hba->ccb[tag].sense_bufflen = 0;
 	hba->ccb[tag].sense_buffer = NULL;
 	hba->ccb[tag].req_type = PASSTHRU_REQ_TYPE;
-
 	hba->send(hba, req, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	before = jiffies;
 	while (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE) {
 		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
@@ -1821,24 +1954,29 @@ static void stex_remove(struct pci_dev *pdev)
 	scsi_host_put(hba->host);
 
 	pci_disable_device(pdev);
+
+	unregister_reboot_notifier(&stex_notifier);
 }
 
 static void stex_shutdown(struct pci_dev *pdev)
 {
 	struct st_hba *hba = pci_get_drvdata(pdev);
-
-	if (hba->supports_pm == 0)
+	if (hba->supports_pm == 0) {
 		stex_hba_stop(hba, ST_IGNORED);
-	else
+	} else if (hba->supports_pm == 1 && S6flag) {
+		unregister_reboot_notifier(&stex_notifier);
+		stex_hba_stop(hba, ST_S6);
+	} else
 		stex_hba_stop(hba, ST_S5);
 }
 
-static int stex_choice_sleep_mic(pm_message_t state)
+static int stex_choice_sleep_mic(struct st_hba *hba, pm_message_t state)
 {
 	switch (state.event) {
 	case PM_EVENT_SUSPEND:
 		return ST_S3;
 	case PM_EVENT_HIBERNATE:
+		hba->msi_lock = 0;
 		return ST_S4;
 	default:
 		return ST_NOTHANDLED;
@@ -1849,8 +1987,9 @@ static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct st_hba *hba = pci_get_drvdata(pdev);
 
-	if (hba->cardtype == st_yel && hba->supports_pm == 1)
-		stex_hba_stop(hba, stex_choice_sleep_mic(state));
+	if ((hba->cardtype == st_yel || hba->cardtype == st_P3)
+		&& hba->supports_pm == 1)
+		stex_hba_stop(hba, stex_choice_sleep_mic(hba, state));
 	else
 		stex_hba_stop(hba, ST_IGNORED);
 	return 0;
@@ -1864,6 +2003,13 @@ static int stex_resume(struct pci_dev *pdev)
 	stex_handshake(hba);
 	return 0;
 }
+
+static int stex_halt(struct notifier_block *nb, unsigned long event, void *buf)
+{
+	S6flag = 1;
+	return NOTIFY_OK;
+}
+
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
 
 static struct pci_driver stex_pci_driver = {
-- 
1.9.1
