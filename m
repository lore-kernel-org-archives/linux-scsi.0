From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH RFC] qla2xxx: Fix qla27xx_write_reg()
Date: Wed, 14 Jan 2015 17:10:31 +0100
Message-ID: <54B694F7.7030005@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0056.outbound.protection.outlook.com ([157.56.111.56]:6272
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754232AbbANQY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2015 11:24:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The second argument passed to qla27xx_write_reg() is a byte offset.
This means that this function must read data from (void *)reg + offset
instead of (void *)reg + sizeof(*reg) * offset. Found this via source
reading. Untested.
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index a8c0c73..7a92f60 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -190,7 +190,7 @@ static inline void
 qla27xx_write_reg(__iomem struct device_reg_24xx *reg,
 	uint offset, uint32_t data, void *buf)
 {
-	__iomem void *window = reg + offset;
+	__iomem void *window = (void __iomem *)reg + offset;
 
 	if (buf) {
 		WRT_REG_DWORD(window, data);
-- 
2.1.2

