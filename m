From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 17/21] advansys: remove detect_called
Date: Thu, 26 Jul 2007 13:22:53 -0400
Message-ID: <1185470577234-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:40143 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936170AbXGZSG0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 14:06:26 -0400
In-Reply-To: 20070726171141.GE19275@parisc-linux.org
References: 20070726171141.GE19275@parisc-linux.org
In-Reply-To: <20070726171141.GE19275@parisc-linux.org>
References: <20070726171141.GE19275@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Apparently it used to be possible to call the detect method twice.
That's not possible any more with the new style init routine.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 1be68c5..3a006ed 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -17888,18 +17888,9 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
  */
 static int __init advansys_detect(void)
 {
-	static int detect_called = ASC_FALSE;
 	int iop, bus, ioport = 0;
 	struct Scsi_Host *shost;
 
-	if (detect_called == ASC_FALSE) {
-		detect_called = ASC_TRUE;
-	} else {
-		printk
-		    ("AdvanSys SCSI: advansys_detect() multiple calls ignored\n");
-		return 0;
-	}
-
 	ASC_DBG(1, "advansys_detect: begin\n");
 
 	asc_board_count = 0;
-- 
1.4.4.4

