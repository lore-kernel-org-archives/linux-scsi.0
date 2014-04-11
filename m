From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 03/42] qla2xxx: Correct operations for ISP27xx template types 270 and 271.
Date: Fri, 11 Apr 2014 16:54:08 -0400
Message-ID: <1397249687-32666-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:57138 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438AbaDKVc1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Apr 2014 17:32:27 -0400
In-Reply-To: <1397249687-32666-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c |   21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 97255f7..c6ecd24 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -60,7 +60,7 @@
  * |                              |                    | 0xb13c-0xb140  |
  * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc00c       |		|
- * | Misc                         |       0xd2ff       | 0xd017-0xd019	|
+ * | Misc                         |       0xd300       | 0xd017-0xd019	|
  * |                              |                    | 0xd020		|
  * |                              |                    | 0xd02e-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index a804e9b..2909804 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -192,6 +192,19 @@ static inline void (*qla27xx_read_vector(uint width))(void *, void *, ulong *)
 }
 
 static inline void
+qla27xx_read_off(__iomem struct device_reg_24xx *reg,
+	uint offset, void *buf, ulong *len)
+{
+	void *window = (void *)reg + offset;
+
+	if (buf) {
+		ql_dbg(ql_dbg_misc, NULL, 0xd300,
+		    "%s: @%x\n", __func__, offset);
+	}
+	qla27xx_read32(window, buf, len);
+}
+
+static inline void
 qla27xx_read_reg(__iomem struct device_reg_24xx *reg,
 	uint offset, void *buf, ulong *len)
 {
@@ -590,7 +603,6 @@ qla27xx_fwdt_entry_t270(struct scsi_qla_host *vha,
 	struct qla27xx_fwdt_entry *ent, void *buf, ulong *len)
 {
 	struct device_reg_24xx __iomem *reg = qla27xx_isp_reg(vha);
-	void *window = (void *)reg + 0xc4;
 	ulong dwords = ent->t270.count;
 	ulong addr = ent->t270.addr;
 
@@ -599,9 +611,8 @@ qla27xx_fwdt_entry_t270(struct scsi_qla_host *vha,
 	qla27xx_write_reg(reg, IOBASE_ADDR, 0x40, buf);
 	while (dwords--) {
 		qla27xx_write_reg(reg, 0xc0, addr|0x80000000, buf);
-		qla27xx_read_reg(reg, 0xc4, buf, len);
 		qla27xx_insert32(addr, buf, len);
-		qla27xx_read32(window, buf, len);
+		qla27xx_read_off(reg, 0xc4, buf, len);
 		addr++;
 	}
 
@@ -614,12 +625,12 @@ qla27xx_fwdt_entry_t271(struct scsi_qla_host *vha,
 {
 	struct device_reg_24xx __iomem *reg = qla27xx_isp_reg(vha);
 	ulong addr = ent->t271.addr;
+	ulong data = ent->t271.data;
 
 	ql_dbg(ql_dbg_misc, vha, 0xd20f,
 	    "%s: wrremreg [%lx]\n", __func__, *len);
 	qla27xx_write_reg(reg, IOBASE_ADDR, 0x40, buf);
-	qla27xx_read_reg(reg, 0xc4, buf, len);
-	qla27xx_insert32(addr, buf, len);
+	qla27xx_write_reg(reg, 0xc4, data, buf);
 	qla27xx_write_reg(reg, 0xc0, addr, buf);
 
 	return false;
-- 
1.7.7

