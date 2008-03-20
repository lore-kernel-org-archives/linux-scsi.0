From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/5] scsi_debug: create new scsi_debug devices at a single place
Date: Thu, 20 Mar 2008 11:09:16 +0900
Message-ID: <1205978959-30510-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205978959-30510-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60303 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbYCTCKI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 22:10:08 -0400
In-Reply-To: <1205978959-30510-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

Two functions, sdebug_add_adapter and devInfoReg, creates new
scsi_debug devices. To simplify the code, this patch adds a new helper
function to create new scsi_debug devices (sdebug_device_create) and
converts both functions to use it.

I plan to add more to scsi_debug devices (e.g. using a thread for a
scsi_debug device for scalability testings). This patch enable me to
add such to just the new helper function instead of touching two
functions, sdebug_add_adapter and devInfoReg.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2a388d0..161af1d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2014,6 +2014,19 @@ static void scsi_debug_slave_destroy(struct scsi_device * sdp)
 	}
 }
 
+struct sdebug_dev_info *sdebug_device_create(struct sdebug_host_info *sdbg_host,
+					     gfp_t flags)
+{
+	struct sdebug_dev_info *devip;
+
+	devip = kzalloc(sizeof(*devip), flags);
+	if (devip) {
+		devip->sdbg_host = sdbg_host;
+		list_add_tail(&devip->dev_list, &sdbg_host->dev_info_list);
+	}
+	return devip;
+}
+
 static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 {
 	struct sdebug_host_info * sdbg_host;
@@ -2038,16 +2051,13 @@ static struct sdebug_dev_info * devInfoReg(struct scsi_device * sdev)
 				open_devip = devip;
 		}
 	}
-	if (NULL == open_devip) { /* try and make a new one */
-		open_devip = kzalloc(sizeof(*open_devip),GFP_ATOMIC);
-		if (NULL == open_devip) {
+	if (!open_devip) { /* try and make a new one */
+		open_devip = sdebug_device_create(sdbg_host, GFP_ATOMIC);
+		if (!open_devip) {
 			printk(KERN_ERR "%s: out of memory at line %d\n",
 				__FUNCTION__, __LINE__);
 			return NULL;
 		}
-		open_devip->sdbg_host = sdbg_host;
-		list_add_tail(&open_devip->dev_list,
-		&sdbg_host->dev_info_list);
 	}
         if (open_devip) {
 		open_devip->channel = sdev->channel;
@@ -2935,16 +2945,13 @@ static int sdebug_add_adapter(void)
 
 	devs_per_host = scsi_debug_num_tgts * scsi_debug_max_luns;
         for (k = 0; k < devs_per_host; k++) {
-                sdbg_devinfo = kzalloc(sizeof(*sdbg_devinfo),GFP_KERNEL);
-                if (NULL == sdbg_devinfo) {
+		sdbg_devinfo = sdebug_device_create(sdbg_host, GFP_KERNEL);
+		if (!sdbg_devinfo) {
                         printk(KERN_ERR "%s: out of memory at line %d\n",
                                __FUNCTION__, __LINE__);
                         error = -ENOMEM;
 			goto clean;
                 }
-                sdbg_devinfo->sdbg_host = sdbg_host;
-                list_add_tail(&sdbg_devinfo->dev_list,
-                              &sdbg_host->dev_info_list);
         }
 
         spin_lock(&sdebug_host_list_lock);
-- 
1.5.3.7

