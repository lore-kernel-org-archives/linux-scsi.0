From: Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: [PATCH] scsi/sd.c: fix spun up and not ready messages to mention which disk
Date: Fri, 21 Feb 2014 11:34:43 +1100
Message-ID: <1392942883-4624-1-git-send-email-stewart@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55550 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbaBUAfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 19:35:11 -0500
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <stewart@linux.vnet.ibm.com>;
	Fri, 21 Feb 2014 06:05:08 +0530
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Stewart Smith <stewart@linux.vnet.ibm.com>

Previously, many years ago, this was done in series which was fine,
but things moved to be done in parallel and with many disks in a system
it can be hard to see which disk spun up and which one didn't as the
printk messages were all mixed together.

Signed-off-by: Stewart Smith <stewart@linux.vnet.ibm.com>
---
 drivers/scsi/sd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 470954a..1436c85 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1838,7 +1838,6 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			}
 			/* Wait 1 second for next try */
 			msleep(1000);
-			printk(".");
 
 		/*
 		 * Wait for USB flash devices with slow firmware.
@@ -1868,9 +1867,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 
 	if (spintime) {
 		if (scsi_status_is_good(the_result))
-			printk("ready\n");
+			sd_printk(KERN_NOTICE, sdkp, "ready\n");
 		else
-			printk("not responding...\n");
+			sd_printk(KERN_NOTICE, sdkp, "not responding...\n");
 	}
 }
 
-- 
1.8.5.3

