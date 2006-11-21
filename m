From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH] [SCSI] qla4xxx: fix for timing issue for nvram
	accesses.
Date: Mon, 20 Nov 2006 16:20:22 -0800
Message-ID: <1164068423.3960.3.camel@dcslnxpc.site>
References: <1163548841.3938.14.camel@dcslnxpc.site>
	 <1163637669.3867.12.camel@dcslnxpc.site>
	 <1163817489.4136.6.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:61722 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S966888AbWKUAUV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Nov 2006 19:20:21 -0500
In-Reply-To: <1163817489.4136.6.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>

On Fri, 2006-11-17 at 18:38 -0800, David C Somayajulu wrote:
> This patch fixes a timing issue related to nvram accesses in qla4xxx driver for some cpu/slot speed combination.
Cleaned up patch.
> 
> Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>


---
 drivers/scsi/qla4xxx/ql4_nvram.c |   64 +++++++++++++++++++++-----------------
 1 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index fc50203..58afd13 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -7,6 +7,13 @@
 
 #include "ql4_def.h"
 
+static inline void eeprom_cmd(uint32_t cmd, struct scsi_qla_host *ha)
+{
+	writel(cmd, isp_nvram(ha));
+	readl(isp_nvram(ha));
+	udelay(1);
+}
+
 static inline int eeprom_size(struct scsi_qla_host *ha)
 {
 	return is_qla4010(ha) ? FM93C66A_SIZE_16 : FM93C86A_SIZE_16;
@@ -28,8 +35,7 @@ static int fm93c56a_select(struct scsi_q
 	DEBUG5(printk(KERN_ERR "fm93c56a_select:\n"));
 
 	ha->eeprom_cmd_data = AUBURN_EEPROM_CS_1 | 0x000f0000;
-	writel(ha->eeprom_cmd_data, isp_nvram(ha));
-	readl(isp_nvram(ha));
+	eeprom_cmd(ha->eeprom_cmd_data, ha);
 	return 1;
 }
 
@@ -41,12 +47,13 @@ static int fm93c56a_cmd(struct scsi_qla_
 	int previousBit;
 
 	/* Clock in a zero, then do the start bit. */
-	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1, isp_nvram(ha));
-	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
-	       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
-	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
-	       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
-	readl(isp_nvram(ha));
+	eeprom_cmd(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1, ha);
+
+	eeprom_cmd(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
+	       AUBURN_EEPROM_CLK_RISE, ha);
+	eeprom_cmd(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
+	       AUBURN_EEPROM_CLK_FALL, ha);
+
 	mask = 1 << (FM93C56A_CMD_BITS - 1);
 
 	/* Force the previous data bit to be different. */
@@ -60,14 +67,14 @@ static int fm93c56a_cmd(struct scsi_qla_
 			 * If the bit changed, then change the DO state to
 			 * match.
 			 */
-			writel(ha->eeprom_cmd_data | dataBit, isp_nvram(ha));
+			eeprom_cmd(ha->eeprom_cmd_data | dataBit, ha);
 			previousBit = dataBit;
 		}
-		writel(ha->eeprom_cmd_data | dataBit |
-		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
-		writel(ha->eeprom_cmd_data | dataBit |
-		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
-		readl(isp_nvram(ha));
+		eeprom_cmd(ha->eeprom_cmd_data | dataBit |
+		       AUBURN_EEPROM_CLK_RISE, ha);
+		eeprom_cmd(ha->eeprom_cmd_data | dataBit |
+		       AUBURN_EEPROM_CLK_FALL, ha);
+
 		cmd = cmd << 1;
 	}
 	mask = 1 << (eeprom_no_addr_bits(ha) - 1);
@@ -82,14 +89,15 @@ static int fm93c56a_cmd(struct scsi_qla_
 			 * If the bit changed, then change the DO state to
 			 * match.
 			 */
-			writel(ha->eeprom_cmd_data | dataBit, isp_nvram(ha));
+			eeprom_cmd(ha->eeprom_cmd_data | dataBit, ha);
+
 			previousBit = dataBit;
 		}
-		writel(ha->eeprom_cmd_data | dataBit |
-		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
-		writel(ha->eeprom_cmd_data | dataBit |
-		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
-		readl(isp_nvram(ha));
+		eeprom_cmd(ha->eeprom_cmd_data | dataBit |
+		       AUBURN_EEPROM_CLK_RISE, ha);
+		eeprom_cmd(ha->eeprom_cmd_data | dataBit |
+		       AUBURN_EEPROM_CLK_FALL, ha);
+
 		addr = addr << 1;
 	}
 	return 1;
@@ -98,8 +106,7 @@ static int fm93c56a_cmd(struct scsi_qla_
 static int fm93c56a_deselect(struct scsi_qla_host * ha)
 {
 	ha->eeprom_cmd_data = AUBURN_EEPROM_CS_0 | 0x000f0000;
-	writel(ha->eeprom_cmd_data, isp_nvram(ha));
-	readl(isp_nvram(ha));
+	eeprom_cmd(ha->eeprom_cmd_data, ha);
 	return 1;
 }
 
@@ -112,12 +119,13 @@ static int fm93c56a_datain(struct scsi_q
 	/* Read the data bits
 	 * The first bit is a dummy.  Clock right over it. */
 	for (i = 0; i < eeprom_no_data_bits(ha); i++) {
-		writel(ha->eeprom_cmd_data |
-		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
-		writel(ha->eeprom_cmd_data |
-		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
-		dataBit =
-			(readw(isp_nvram(ha)) & AUBURN_EEPROM_DI_1) ? 1 : 0;
+		eeprom_cmd(ha->eeprom_cmd_data |
+		       AUBURN_EEPROM_CLK_RISE, ha);
+		eeprom_cmd(ha->eeprom_cmd_data |
+		       AUBURN_EEPROM_CLK_FALL, ha);
+
+		dataBit = (readw(isp_nvram(ha)) & AUBURN_EEPROM_DI_1) ? 1 : 0;
+
 		data = (data << 1) | dataBit;
 	}
 
-- 
1.4.2.3


