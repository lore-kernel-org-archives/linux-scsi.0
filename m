From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 03/35] qla2xxx: ISP27xx fwdump template remove high frequency debug logs.
Date: Thu, 25 Sep 2014 05:16:34 -0400
Message-ID: <1411636626-7566-4-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:52306 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890AbaIYJvO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:14 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c  |    2 +-
 drivers/scsi/qla2xxx/qla_tmpl.c |   17 -----------------
 2 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 55edaa2..61bd49f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -64,7 +64,7 @@
  * |                              |                    | 0xb13c-0xb140  |
  * |                              |                    | 0xb149		|
  * | MultiQ                       |       0xc00c       |		|
- * | Misc                         |       0xd212       | 0xd017		|
+ * | Misc                         |       0xd212       | 0xd011-0xd017	|
  * |                              |                    | 0xd020		|
  * |                              |                    | 0xd030-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 29271cc..6da9dd2 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -151,8 +151,6 @@ qla27xx_read8(void *window, void *buf, ulong *len)
 
 	if (buf) {
 		value = RD_REG_BYTE((__iomem void *)window);
-		ql_dbg(ql_dbg_misc, NULL, 0xd011,
-		    "%s: -> %x\n", __func__, value);
 	}
 	qla27xx_insert32(value, buf, len);
 }
@@ -164,8 +162,6 @@ qla27xx_read16(void *window, void *buf, ulong *len)
 
 	if (buf) {
 		value = RD_REG_WORD((__iomem void *)window);
-		ql_dbg(ql_dbg_misc, NULL, 0xd012,
-		    "%s: -> %x\n", __func__, value);
 	}
 	qla27xx_insert32(value, buf, len);
 }
@@ -177,8 +173,6 @@ qla27xx_read32(void *window, void *buf, ulong *len)
 
 	if (buf) {
 		value = RD_REG_DWORD((__iomem void *)window);
-		ql_dbg(ql_dbg_misc, NULL, 0xd013,
-		    "%s: -> %x\n", __func__, value);
 	}
 	qla27xx_insert32(value, buf, len);
 }
@@ -197,10 +191,6 @@ qla27xx_read_reg(__iomem struct device_reg_24xx *reg,
 {
 	void *window = (void *)reg + offset;
 
-	if (buf) {
-		ql_dbg(ql_dbg_misc, NULL, 0xd014,
-		    "%s: @%x\n", __func__, offset);
-	}
 	qla27xx_read32(window, buf, len);
 }
 
@@ -211,8 +201,6 @@ qla27xx_write_reg(__iomem struct device_reg_24xx *reg,
 	__iomem void *window = reg + offset;
 
 	if (buf) {
-		ql_dbg(ql_dbg_misc, NULL, 0xd015,
-		    "%s: @%x <- %x\n", __func__, offset, data);
 		WRT_REG_DWORD(window, data);
 	}
 }
@@ -225,11 +213,6 @@ qla27xx_read_window(__iomem struct device_reg_24xx *reg,
 	void *window = (void *)reg + offset;
 	void (*readn)(void *, void *, ulong *) = qla27xx_read_vector(width);
 
-	if (buf) {
-		ql_dbg(ql_dbg_misc, NULL, 0xd016,
-		    "%s: base=%x offset=%x count=%x width=%x\n",
-		    __func__, addr, offset, count, width);
-	}
 	qla27xx_write_reg(reg, IOBASE_ADDR, addr, buf);
 	while (count--) {
 		qla27xx_insert32(addr, buf, len);
-- 
1.7.7

