From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH 2/5] Add P3 support, modify probe, irq & handshake
Date: Fri,  3 Jun 2016 20:12:49 +0800
Message-ID: <1464955969-16788-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com
Cc: Paul <paul.lyu@tw.promise.com>
List-Id: linux-scsi@vger.kernel.org

From: Paul <paul.lyu@tw.promise.com>

1.In probe, add p3 card_type for pm, offset, scract & SG
2.Init P3 to use msi interrupt
3.Handshake add P3 read/write reg

Signed-off-by: Paul <paul.lyu@tw.promise.com>
---
 drivers/scsi/stex.c | 122 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 88 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f8195c0..921f4e3 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -94,7 +94,7 @@ enum {
 	MU_STATE_STOP				= 5,
 	MU_STATE_NOCONNECT			= 6,
 
-	MU_MAX_DELAY				= 120,
+	MU_MAX_DELAY				= 50,
 	MU_HANDSHAKE_SIGNATURE			= 0x55aaaa55,
 	MU_HANDSHAKE_SIGNATURE_HALF		= 0x5a5a0000,
 	MU_HARD_RESET_WAIT			= 30000,
@@ -1093,14 +1093,27 @@ static int stex_ss_handshake(struct st_hba *hba)
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
@@ -1119,30 +1132,59 @@ static int stex_ss_handshake(struct st_hba *hba)
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
+		writel((1 << 6), base + YH2I_INT);
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
 
@@ -1152,7 +1194,7 @@ static int stex_handshake(struct st_hba *hba)
 	unsigned long flags;
 	unsigned int mu_status;
 
-	err = (hba->cardtype == st_yel) ?
+	err = (hba->cardtype == st_yel || hba->cardtype == st_P3) ?
 		stex_ss_handshake(hba) : stex_common_handshake(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	mu_status = hba->mu_status;
@@ -1530,18 +1572,30 @@ static int stex_request_irq(struct st_hba *hba)
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
@@ -1625,12 +1679,12 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
@@ -1670,7 +1724,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_pci_free;
 	}
 
-	if (hba->cardtype == st_yel)
+	if (hba->cardtype == st_yel || hba->cardtype == st_P3)
 		hba->scratch = (__le32 *)(hba->dma_mem + scratch_offset);
 	hba->status_buffer = (struct status_msg *)(hba->dma_mem + sts_offset);
 	hba->copy_buffer = hba->dma_mem + cp_offset;
@@ -1682,7 +1736,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hba->send = ci->send;
 	hba->mu_status = MU_STATE_STARTING;
 
-	if (hba->cardtype == st_yel)
+	if (hba->cardtype == st_yel || hba->cardtype == st_P3)
 		host->sg_tablesize = 38;
 	else
 		host->sg_tablesize = 32;
-- 
1.9.1
