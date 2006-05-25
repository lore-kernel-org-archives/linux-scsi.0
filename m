From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] wd7000: fix section mismatch warnings
Date: Thu, 25 May 2006 09:44:59 -0700
Message-ID: <20060525094459.bf812563.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:49841 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1030271AbWEYQno (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 May 2006 12:43:44 -0400
Received: from midway.site ([71.245.102.105]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 25 May 2006 09:43:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?B?X19zbWFpbCBE9m5tZXo=?= <ismail@pardus.org.tr>, scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@osdl.org>, jejb <james.bottomley@steeleye.com>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix section mismatch in wd7000 driver:
WARNING: drivers/scsi/wd7000.o - Section mismatch: reference to .init.text: from .text after 'wd7000_detect' (at offset 0xa5d)
WARNING: drivers/scsi/wd7000.o - Section mismatch: reference to .init.text: from .text after 'wd7000_detect' (at offset 0xab6)
WARNING: drivers/scsi/wd7000.o - Section mismatch: reference to .init.text: from .text after 'wd7000_detect' (at offset 0xb67

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/scsi/wd7000.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2617-rc5.orig/drivers/scsi/wd7000.c
+++ linux-2617-rc5/drivers/scsi/wd7000.c
@@ -1391,7 +1391,7 @@ static int wd7000_proc_info(struct Scsi_
  *
  */
 
-static int wd7000_detect(struct scsi_host_template *tpnt)
+static __init int wd7000_detect(struct scsi_host_template *tpnt)
 {
 	short present = 0, biosaddr_ptr, sig_ptr, i, pass;
 	short biosptr[NUM_CONFIGS];


---
