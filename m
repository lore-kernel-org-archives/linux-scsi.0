From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 07/12] qla4xxx: Fail initialization if
 qla4_8xxx_pci_mem_write_2M fails
Date: Thu, 2 Dec 2010 22:12:40 -0800
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872243F411E@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:3255 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab0LCGMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Dec 2010 01:12:42 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Lalit Chandivade <lalit.chandivade@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Since if fw load is failing, running on incomplete fw load would
be fatal.

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_nx.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 2d95ef2..18b0ad6 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1127,14 +1127,14 @@ qla4_8xxx_pinit_from_rom(struct scsi_qla_host *ha, int verbose)
 static int
 qla4_8xxx_load_from_flash(struct scsi_qla_host *ha, uint32_t image_start)
 {
-	int  i;
+	int  i, rval = 0;
 	long size = 0;
 	long flashaddr, memaddr;
 	u64 data;
 	u32 high, low;
 
 	flashaddr = memaddr = ha->hw.flt_region_bootload;
-	size = (image_start - flashaddr)/8;
+	size = (image_start - flashaddr) / 8;
 
 	DEBUG2(printk("scsi%ld: %s: bootldr=0x%lx, fw_image=0x%x\n",
 	    ha->host_no, __func__, flashaddr, image_start));
@@ -1143,14 +1143,18 @@ qla4_8xxx_load_from_flash(struct scsi_qla_host *ha, uint32_t image_start)
 		if ((qla4_8xxx_rom_fast_read(ha, flashaddr, (int *)&low)) ||
 		    (qla4_8xxx_rom_fast_read(ha, flashaddr + 4,
 		    (int *)&high))) {
-			return -1;
+			rval = -1;
+			goto exit_load_from_flash;
 		}
 		data = ((u64)high << 32) | low ;
-		qla4_8xxx_pci_mem_write_2M(ha, memaddr, &data, 8);
+		rval = qla4_8xxx_pci_mem_write_2M(ha, memaddr, &data, 8);
+		if (rval)
+			goto exit_load_from_flash;
+
 		flashaddr += 8;
 		memaddr   += 8;
 
-		if (i%0x1000 == 0)
+		if (i % 0x1000 == 0)
 			msleep(1);
 
 	}
@@ -1162,7 +1166,8 @@ qla4_8xxx_load_from_flash(struct scsi_qla_host *ha, uint32_t image_start)
 	qla4_8xxx_wr_32(ha, QLA82XX_ROMUSB_GLB_SW_RESET, 0x80001e);
 	read_unlock(&ha->hw_lock);
 
-	return 0;
+exit_load_from_flash:
+	return rval;
 }
 
 static int qla4_8xxx_load_fw(struct scsi_qla_host *ha, uint32_t image_start)
-- 
1.7.3.2

