From: madhu.iyengar@qlogic.com
Subject: [PATCH 07/14] qla2xxx: Code cleanup to remove unwanted comments and code.
Date: Tue, 21 Dec 2010 16:00:20 -0800
Message-ID: <1292976027-12034-8-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36167 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753923Ab0LVADY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:24 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |   36 ------------------------------------
 drivers/scsi/qla2xxx/qla_nx.h |    2 --
 2 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 6ea5e98..22b0d78 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -1254,25 +1254,6 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 }
 
 static int
-qla82xx_check_for_bad_spd(struct qla_hw_data *ha)
-{
-	u32 val = 0;
-	val = qla82xx_rd_32(ha, BOOT_LOADER_DIMM_STATUS);
-	val &= QLA82XX_BOOT_LOADER_MN_ISSUE;
-	if (val & QLA82XX_PEG_TUNE_MN_SPD_ZEROED) {
-		qla_printk(KERN_INFO, ha,
-			"Memory DIMM SPD not programmed. "
-			" Assumed valid.\n");
-		return 1;
-	} else if (val) {
-		qla_printk(KERN_INFO, ha,
-			"Memory DIMM type incorrect.Info:%08X.\n", val);
-		return 2;
-	}
-	return 0;
-}
-
-static int
 qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
 		u64 off, void *data, int size)
 {
@@ -1337,11 +1318,6 @@ qla82xx_pci_mem_write_2M(struct qla_hw_data *ha,
 		word[startword+1] |= tmpw >> (sz[0] * 8);
 	}
 
-	/*
-	 * don't lock here - write_wx gets the lock if each time
-	 * write_lock_irqsave(&adapter->adapter_lock, flags);
-	 * netxen_nic_pci_change_crbwindow_128M(adapter, 0);
-	 */
 	for (i = 0; i < loop; i++) {
 		temp = off8 + (i << shift_amount);
 		qla82xx_wr_32(ha, mem_crb+MIU_TEST_AGT_ADDR_LO, temp);
@@ -1443,12 +1419,6 @@ qla82xx_pci_mem_read_2M(struct qla_hw_data *ha,
 	off0[1] = 0;
 	sz[1] = size - sz[0];
 
-	/*
-	 * don't lock here - write_wx gets the lock if each time
-	 * write_lock_irqsave(&adapter->adapter_lock, flags);
-	 * netxen_nic_pci_change_crbwindow_128M(adapter, 0);
-	 */
-
 	for (i = 0; i < loop; i++) {
 		temp = off8 + (i << shift_amount);
 		qla82xx_wr_32(ha, mem_crb + MIU_TEST_AGT_ADDR_LO, temp);
@@ -1481,11 +1451,6 @@ qla82xx_pci_mem_read_2M(struct qla_hw_data *ha,
 		}
 	}
 
-	/*
-	 * netxen_nic_pci_change_crbwindow_128M(adapter, 1);
-	 * write_unlock_irqrestore(&adapter->adapter_lock, flags);
-	 */
-
 	if (j >= MAX_CTL_CHECK)
 		return -1;
 
@@ -1916,7 +1881,6 @@ qla82xx_check_cmdpeg_state(struct qla_hw_data *ha)
 	qla_printk(KERN_INFO, ha,
 	    "Cmd Peg initialization failed: 0x%x.\n", val);
 
-	qla82xx_check_for_bad_spd(ha);
 	val = qla82xx_rd_32(ha, QLA82XX_ROMUSB_GLB_PEGTUNE_DONE);
 	read_lock(&ha->hw_lock);
 	qla82xx_wr_32(ha, CRB_CMDPEG_STATE, PHAN_INITIALIZE_FAILED);
diff --git a/drivers/scsi/qla2xxx/qla_nx.h b/drivers/scsi/qla2xxx/qla_nx.h
index 51ec0c5..ed5883f 100644
--- a/drivers/scsi/qla2xxx/qla_nx.h
+++ b/drivers/scsi/qla2xxx/qla_nx.h
@@ -523,8 +523,6 @@
 # define QLA82XX_CAM_RAM_BASE		(QLA82XX_CRB_CAM + 0x02000)
 # define QLA82XX_CAM_RAM(reg)		(QLA82XX_CAM_RAM_BASE + (reg))
 
-#define QLA82XX_PEG_TUNE_MN_SPD_ZEROED	0x80000000
-#define QLA82XX_BOOT_LOADER_MN_ISSUE	0xff00ffff
 #define QLA82XX_PORT_MODE_ADDR		(QLA82XX_CAM_RAM(0x24))
 #define QLA82XX_PEG_HALT_STATUS1	(QLA82XX_CAM_RAM(0xa8))
 #define QLA82XX_PEG_HALT_STATUS2	(QLA82XX_CAM_RAM(0xac))
-- 
1.6.0.2

