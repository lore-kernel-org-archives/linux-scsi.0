From: David C Somayajulu <david.somayajulu@qlogic.com>
Subject: Re: [PATCH] [SCSI] qla4xxx: fix for timing issue for nvram
	accesses.
Date: Fri, 17 Nov 2006 18:38:08 -0800
Message-ID: <1163817489.4136.6.camel@dcslnxpc.site>
References: <1163548841.3938.14.camel@dcslnxpc.site>
	 <1163637669.3867.12.camel@dcslnxpc.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:62114 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1753095AbWKRCiI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Nov 2006 21:38:08 -0500
In-Reply-To: <1163637669.3867.12.camel@dcslnxpc.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: open-iscsi@googlegroups.com, David Wagner <david.wagner@qlogic.com>, David Somayajulu <david.somayajulu@qlogic.com>

This patch fixes a timing issue related to nvram accesses in qla4xxx driver for some cpu/slot speed combination.

Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>

---
 drivers/scsi/qla4xxx/ql4_nvram.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nvram.c b/drivers/scsi/qla4xxx/ql4_nvram.c
index fc50203..a84ed3e 100644
--- a/drivers/scsi/qla4xxx/ql4_nvram.c
+++ b/drivers/scsi/qla4xxx/ql4_nvram.c
@@ -29,7 +29,9 @@ static int fm93c56a_select(struct scsi_q
 
 	ha->eeprom_cmd_data = AUBURN_EEPROM_CS_1 | 0x000f0000;
 	writel(ha->eeprom_cmd_data, isp_nvram(ha));
+	udelay(1);
 	readl(isp_nvram(ha));
+	udelay(1);
 	return 1;
 }
 
@@ -42,11 +44,15 @@ static int fm93c56a_cmd(struct scsi_qla_
 
 	/* Clock in a zero, then do the start bit. */
 	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1, isp_nvram(ha));
+	udelay(1);
 	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
 	       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
+	udelay(1);
 	writel(ha->eeprom_cmd_data | AUBURN_EEPROM_DO_1 |
 	       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
+	udelay(1);
 	readl(isp_nvram(ha));
+	udelay(1);
 	mask = 1 << (FM93C56A_CMD_BITS - 1);
 
 	/* Force the previous data bit to be different. */
@@ -61,13 +67,17 @@ static int fm93c56a_cmd(struct scsi_qla_
 			 * match.
 			 */
 			writel(ha->eeprom_cmd_data | dataBit, isp_nvram(ha));
+			udelay(1);
 			previousBit = dataBit;
 		}
 		writel(ha->eeprom_cmd_data | dataBit |
 		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
+		udelay(1);
 		writel(ha->eeprom_cmd_data | dataBit |
 		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
+		udelay(1);
 		readl(isp_nvram(ha));
+		udelay(1);
 		cmd = cmd << 1;
 	}
 	mask = 1 << (eeprom_no_addr_bits(ha) - 1);
@@ -83,13 +93,17 @@ static int fm93c56a_cmd(struct scsi_qla_
 			 * match.
 			 */
 			writel(ha->eeprom_cmd_data | dataBit, isp_nvram(ha));
+			udelay(1);
 			previousBit = dataBit;
 		}
 		writel(ha->eeprom_cmd_data | dataBit |
 		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
+		udelay(1);
 		writel(ha->eeprom_cmd_data | dataBit |
 		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
+		udelay(1);
 		readl(isp_nvram(ha));
+		udelay(1);
 		addr = addr << 1;
 	}
 	return 1;
@@ -99,7 +113,9 @@ static int fm93c56a_deselect(struct scsi
 {
 	ha->eeprom_cmd_data = AUBURN_EEPROM_CS_0 | 0x000f0000;
 	writel(ha->eeprom_cmd_data, isp_nvram(ha));
+	udelay(1);
 	readl(isp_nvram(ha));
+	udelay(1);
 	return 1;
 }
 
@@ -114,10 +130,13 @@ static int fm93c56a_datain(struct scsi_q
 	for (i = 0; i < eeprom_no_data_bits(ha); i++) {
 		writel(ha->eeprom_cmd_data |
 		       AUBURN_EEPROM_CLK_RISE, isp_nvram(ha));
+		udelay(1);
 		writel(ha->eeprom_cmd_data |
 		       AUBURN_EEPROM_CLK_FALL, isp_nvram(ha));
+		udelay(1);
 		dataBit =
 			(readw(isp_nvram(ha)) & AUBURN_EEPROM_DI_1) ? 1 : 0;
+		udelay(1);
 		data = (data << 1) | dataBit;
 	}
 
-- 
1.4.2.3


