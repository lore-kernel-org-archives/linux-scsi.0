From: madhu.iyengar@qlogic.com
Subject: [PATCH 05/12] qla2xxx: Add qla82xx_rom_unlock() function.
Date: Fri,  6 May 2011 17:30:16 -0700
Message-ID: <1304728223-30817-11-git-send-email-madhu.iyengar@qlogic.com>
References: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:32825 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753608Ab1EGAnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 20:43:14 -0400
In-Reply-To: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

Encapsulate the unlocking of the ROM lock in a function for better
code readability.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    1 -
 drivers/scsi/qla2xxx/qla_nx.c  |   20 +++++++++++++-------
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fbb4b8f..53968cc 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -552,7 +552,6 @@ extern int qla82xx_wr_32(struct qla_hw_data *, ulong, u32);
 extern int qla82xx_rd_32(struct qla_hw_data *, ulong);
 extern int qla82xx_rdmem(struct qla_hw_data *, u64, void *, int);
 extern int qla82xx_wrmem(struct qla_hw_data *, u64, void *, int);
-extern void qla82xx_rom_unlock(struct qla_hw_data *);
 
 /* ISP 8021 IDC */
 extern void qla82xx_clear_drv_active(struct qla_hw_data *);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 752b03e..5d5b603 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -844,6 +844,12 @@ qla82xx_rom_lock(struct qla_hw_data *ha)
 	return 0;
 }
 
+static void
+qla82xx_rom_unlock(struct qla_hw_data *ha)
+{
+	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+}
+
 static int
 qla82xx_wait_rom_busy(struct qla_hw_data *ha)
 {
@@ -924,7 +930,7 @@ qla82xx_rom_fast_read(struct qla_hw_data *ha, int addr, int *valp)
 		return -1;
 	}
 	ret = qla82xx_do_rom_fast_read(ha, addr, valp);
-	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	qla82xx_rom_unlock(ha);
 	return ret;
 }
 
@@ -1056,7 +1062,7 @@ qla82xx_write_flash_dword(struct qla_hw_data *ha, uint32_t flashaddr,
 	ret = qla82xx_flash_wait_write_finish(ha);
 
 done_write:
-	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	qla82xx_rom_unlock(ha);
 	return ret;
 }
 
@@ -1144,7 +1150,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
 	qla82xx_wr_32(ha, QLA82XX_CRB_QDR_NET + 0xe4, val);
 	msleep(20);
 
-	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	qla82xx_rom_unlock(ha);
 
 	/* Read the signature value from the flash.
 	 * Offset 0: Contain signature (0xcafecafe)
@@ -3010,7 +3016,7 @@ qla82xx_unprotect_flash(struct qla_hw_data *ha)
 		qla_printk(KERN_WARNING, ha, "Write disable failed\n");
 
 done_unprotect:
-	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	qla82xx_rom_unlock(ha);
 	return ret;
 }
 
@@ -3039,7 +3045,7 @@ qla82xx_protect_flash(struct qla_hw_data *ha)
 	if (qla82xx_write_disable_flash(ha) != 0)
 		qla_printk(KERN_WARNING, ha, "Write disable failed\n");
 done_protect:
-	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	qla82xx_rom_unlock(ha);
 	return ret;
 }
 
@@ -3067,7 +3073,7 @@ qla82xx_erase_sector(struct qla_hw_data *ha, int addr)
 	}
 	ret = qla82xx_flash_wait_write_finish(ha);
 done:
-	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	qla82xx_rom_unlock(ha);
 	return ret;
 }
 
@@ -3247,7 +3253,7 @@ void qla82xx_rom_lock_recovery(struct qla_hw_data *ha)
 	 * else died while holding it.
 	 * In either case, unlock.
 	 */
-	qla82xx_rd_32(ha, QLA82XX_PCIE_REG(PCIE_SEM2_UNLOCK));
+	qla82xx_rom_unlock(ha);
 }
 
 /*
-- 
1.6.0.2

