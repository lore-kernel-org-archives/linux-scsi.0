From: giridhar.malavali@qlogic.com
Subject: [PATCH 12/17] qla2xxx: Fix flash write failure on ISP82xx.
Date: Fri, 28 May 2010 15:08:26 -0700
Message-ID: <1275084511-95266-13-git-send-email-giridhar.malavali@qlogic.com>
References: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52695 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753074Ab0E1WIe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 May 2010 18:08:34 -0400
In-Reply-To: <1275084511-95266-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

Driver was not unprotecting correctly, use correct bits
to unprotect the flash on ISP 82xx.

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 512ba8a..ee575b4 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -19,6 +19,7 @@
 #define QLA82XX_PCI_OCM0_2M (0xc0000)
 #define VALID_OCM_ADDR(addr) (((addr) & 0x3f800) != 0x3f800)
 #define GET_MEM_OFFS_2M(addr) (addr & MASK(18))
+#define BLOCK_PROTECT_BITS 0x0F
 
 /* CRB window related */
 #define CRB_BLK(off)	((off >> 20) & 0x3f)
@@ -3147,10 +3148,10 @@ qla82xx_unprotect_flash(struct qla_hw_data *ha)
 	if (ret < 0)
 		goto done_unprotect;
 
-	val &= ~(0x7 << 2);
+	val &= ~(BLOCK_PROTECT_BITS << 2);
 	ret = qla82xx_write_status_reg(ha, val);
 	if (ret < 0) {
-		val |= (0x7 << 2);
+		val |= (BLOCK_PROTECT_BITS << 2);
 		qla82xx_write_status_reg(ha, val);
 	}
 
@@ -3178,7 +3179,7 @@ qla82xx_protect_flash(struct qla_hw_data *ha)
 	if (ret < 0)
 		goto done_protect;
 
-	val |= (0x7 << 2);
+	val |= (BLOCK_PROTECT_BITS << 2);
 	/* LOCK all sectors */
 	ret = qla82xx_write_status_reg(ha, val);
 	if (ret < 0)
-- 
1.6.2.rc1.30.gd43c

