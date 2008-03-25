From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH v2 2/5] scsi_debug: use scsi_build_sense_buffer
Date: Tue, 25 Mar 2008 09:26:50 +0900
Message-ID: <1206404816-21710-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: 1206378609.3494.50.camel@localhost.localdomain
 <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:37391 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbYCYAs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2008 20:48:28 -0400
In-Reply-To: <1206404816-21710-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4f4c5b7..5f348e7 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -46,6 +46,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsicam.h>
+#include <scsi/scsi_eh.h>
 
 #include <linux/stat.h>
 
@@ -1808,22 +1809,13 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 static void mk_sense_buffer(struct sdebug_dev_info * devip, int key,
 			    int asc, int asq)
 {
-	unsigned char * sbuff;
+	unsigned char *sbuff;
 
 	sbuff = devip->sense_buff;
 	memset(sbuff, 0, SDEBUG_SENSE_LEN);
-	if (scsi_debug_dsense) {
-		sbuff[0] = 0x72;  /* descriptor, current */
-		sbuff[1] = key;
-		sbuff[2] = asc;
-		sbuff[3] = asq;
-	} else {
-		sbuff[0] = 0x70;  /* fixed, current */
-		sbuff[2] = key;
-		sbuff[7] = 0xa;	  /* implies 18 byte sense buffer */
-		sbuff[12] = asc;
-		sbuff[13] = asq;
-	}
+
+	scsi_build_sense_buffer(scsi_debug_dsense, sbuff, key, asc, asq);
+
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
 		printk(KERN_INFO "scsi_debug:    [sense_key,asc,ascq]: "
 		      "[0x%x,0x%x,0x%x]\n", key, asc, asq);
-- 
1.5.3.7

