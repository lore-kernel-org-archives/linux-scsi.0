From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESEND 04/35] qla2xxx: ISP27xx fwdump template fix insertbuf() routine.
Date: Thu, 25 Sep 2014 05:16:35 -0400
Message-ID: <1411636626-7566-5-git-send-email-saurav.kashyap@qlogic.com>
References: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:54352 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbaIYJvR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 05:51:17 -0400
In-Reply-To: <1411636626-7566-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 6da9dd2..6f2f7b2 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -128,18 +128,10 @@ qla27xx_insert32(uint32_t value, void *buf, ulong *len)
 static inline void
 qla27xx_insertbuf(void *mem, ulong size, void *buf, ulong *len)
 {
-	ulong cnt = size;
 
-	if (buf && mem) {
+	if (buf && mem && size) {
 		buf += *len;
-		while (cnt >= sizeof(uint32_t)) {
-			*(__le32 *)buf = cpu_to_le32p(mem);
-			buf += sizeof(uint32_t);
-			mem += sizeof(uint32_t);
-			cnt -= sizeof(uint32_t);
-		}
-		if (cnt)
-			memcpy(buf, mem, cnt);
+		memcpy(buf, mem, size);
 	}
 	*len += size;
 }
-- 
1.7.7

