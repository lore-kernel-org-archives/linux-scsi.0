From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/4] scsi_debug: use shost_priv macro
Date: Sun,  2 Mar 2008 18:30:18 +0900
Message-ID: <1204450218-6858-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1204450218-6858-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204450218-6858-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204450218-6858-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1204450218-6858-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:50844 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbYCBJn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:43:58 -0500
In-Reply-To: <1204450218-6858-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index f70df03..f3f3a20 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2076,8 +2076,8 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 
 	if (devip)
 		return devip;
-	sdbg_host = *(struct sdebug_host_info **) sdev->host->hostdata;
-        if(! sdbg_host) {
+	sdbg_host = *(struct sdebug_host_info **)shost_priv(sdev->host);
+	if (!sdbg_host) {
                 printk(KERN_ERR "Host info NULL\n");
 		return NULL;
         }
@@ -2204,7 +2204,7 @@ static int scsi_debug_bus_reset(struct scsi_cmnd * SCpnt)
 		printk(KERN_INFO "scsi_debug: bus_reset\n");
 	++num_bus_resets;
 	if (SCpnt && ((sdp = SCpnt->device)) && ((hp = sdp->host))) {
-		sdbg_host = *(struct sdebug_host_info **) hp->hostdata;
+		sdbg_host = *(struct sdebug_host_info **)shost_priv(hp);
 		if (sdbg_host) {
 			list_for_each_entry(dev_info,
                                             &sdbg_host->dev_info_list,
-- 
1.5.3.7

