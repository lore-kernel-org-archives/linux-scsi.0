From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 04/10] qla2xxx: Replace two macros with an inline function
Date: Tue, 27 Jan 2015 10:33:22 +0100
Message-ID: <54C75B62.10909@sandisk.com>
References: <54C75AF8.90102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0071.outbound.protection.outlook.com ([65.55.169.71]:38223
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751895AbbA0Jdu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jan 2015 04:33:50 -0500
In-Reply-To: <54C75AF8.90102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Replace the QLA82XX_ADDR_IN_RANGE() and QLA8044_ADDR_IN_RANGE() macros
with the inline function addr_in_range(). This avoids that the compiler
reports the following warning when building with W=1: comparison of
unsigned expression >= 0 is always true.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c  | 21 +++++++++------------
 drivers/scsi/qla2xxx/qla_nx2.c |  4 ++--
 drivers/scsi/qla2xxx/qla_nx2.h |  6 ++++--
 3 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 5c0f950..25c8bbb 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -547,9 +547,6 @@ void qla82xx_idc_unlock(struct qla_hw_data *ha)
 	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM5_UNLOCK));
 }
 
-/*  PCI Windowing for DDR regions.  */
-#define QLA82XX_ADDR_IN_RANGE(addr, low, high) \
-	(((addr) <= (high)) && ((addr) >= (low)))
 /*
  * check memory access boundary.
  * used by test agent. support ddr access only for now
@@ -558,9 +555,9 @@ static unsigned long
 qla82xx_pci_mem_bound_check(struct qla_hw_data *ha,
 	unsigned long long addr, int size)
 {
-	if (!QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
+	if (!addr_in_range(addr, QLA82XX_ADDR_DDR_NET,
 		QLA82XX_ADDR_DDR_NET_MAX) ||
-		!QLA82XX_ADDR_IN_RANGE(addr + size - 1, QLA82XX_ADDR_DDR_NET,
+		!addr_in_range(addr + size - 1, QLA82XX_ADDR_DDR_NET,
 		QLA82XX_ADDR_DDR_NET_MAX) ||
 		((size != 1) && (size != 2) && (size != 4) && (size != 8)))
 			return 0;
@@ -577,7 +574,7 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 	u32 win_read;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 
-	if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
+	if (addr_in_range(addr, QLA82XX_ADDR_DDR_NET,
 		QLA82XX_ADDR_DDR_NET_MAX)) {
 		/* DDR network side */
 		window = MN_WIN(addr);
@@ -592,7 +589,7 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 			    __func__, window, win_read);
 		}
 		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_DDR_NET;
-	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM0,
+	} else if (addr_in_range(addr, QLA82XX_ADDR_OCM0,
 		QLA82XX_ADDR_OCM0_MAX)) {
 		unsigned int temp1;
 		if ((addr & 0x00ff800) == 0xff800) {
@@ -615,7 +612,7 @@ qla82xx_pci_set_window(struct qla_hw_data *ha, unsigned long long addr)
 		}
 		addr = GET_MEM_OFFS_2M(addr) + QLA82XX_PCI_OCM0_2M;
 
-	} else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_QDR_NET,
+	} else if (addr_in_range(addr, QLA82XX_ADDR_QDR_NET,
 		QLA82XX_P3_ADDR_QDR_NET_MAX)) {
 		/* QDR network side */
 		window = MS_WIN(addr);
@@ -656,16 +653,16 @@ static int qla82xx_pci_is_same_window(struct qla_hw_data *ha,
 	qdr_max = QLA82XX_P3_ADDR_QDR_NET_MAX;
 
 	/* DDR network side */
-	if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_DDR_NET,
+	if (addr_in_range(addr, QLA82XX_ADDR_DDR_NET,
 		QLA82XX_ADDR_DDR_NET_MAX))
 		BUG();
-	else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM0,
+	else if (addr_in_range(addr, QLA82XX_ADDR_OCM0,
 		QLA82XX_ADDR_OCM0_MAX))
 		return 1;
-	else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_OCM1,
+	else if (addr_in_range(addr, QLA82XX_ADDR_OCM1,
 		QLA82XX_ADDR_OCM1_MAX))
 		return 1;
-	else if (QLA82XX_ADDR_IN_RANGE(addr, QLA82XX_ADDR_QDR_NET, qdr_max)) {
+	else if (addr_in_range(addr, QLA82XX_ADDR_QDR_NET, qdr_max)) {
 		/* QDR network side */
 		window = ((addr - QLA82XX_ADDR_QDR_NET) >> 22) & 0x3f;
 		if (ha->qdr_sn_window == window)
diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index f478d8f..b8ceb82 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1129,9 +1129,9 @@ qla8044_ms_mem_write_128b(struct scsi_qla_host *vha,
 	}
 
 	for (i = 0; i < count; i++, addr += 16) {
-		if (!((QLA8044_ADDR_IN_RANGE(addr, QLA8044_ADDR_QDR_NET,
+		if (!((addr_in_range(addr, QLA8044_ADDR_QDR_NET,
 		    QLA8044_ADDR_QDR_NET_MAX)) ||
-		    (QLA8044_ADDR_IN_RANGE(addr, QLA8044_ADDR_DDR_NET,
+		    (addr_in_range(addr, QLA8044_ADDR_DDR_NET,
 			QLA8044_ADDR_DDR_NET_MAX)))) {
 			ret_val = QLA_FUNCTION_FAILED;
 			goto exit_ms_mem_write_unlock;
diff --git a/drivers/scsi/qla2xxx/qla_nx2.h b/drivers/scsi/qla2xxx/qla_nx2.h
index ada3605..02fe3c4 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.h
+++ b/drivers/scsi/qla2xxx/qla_nx2.h
@@ -58,8 +58,10 @@
 #define QLA8044_PCI_QDR_NET_MAX		((unsigned long)0x043fffff)
 
 /*  PCI Windowing for DDR regions.  */
-#define QLA8044_ADDR_IN_RANGE(addr, low, high)		\
-	(((addr) <= (high)) && ((addr) >= (low)))
+static inline bool addr_in_range(u64 addr, u64 low, u64 high)
+{
+	return addr <= high && addr >= low;
+}
 
 /* Indirectly Mapped Registers */
 #define QLA8044_FLASH_SPI_STATUS	0x2808E010
-- 
2.1.2

