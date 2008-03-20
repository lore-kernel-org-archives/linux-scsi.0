From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/5] scsi_debug: use list_for_each_entry_safe
Date: Thu, 20 Mar 2008 11:09:18 +0900
Message-ID: <1205978959-30510-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205978959-30510-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205978959-30510-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205978959-30510-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:60302 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbYCTCKI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 22:10:08 -0400
In-Reply-To: <1205978959-30510-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Douglas Gilbert <dougg@torque.net>, James Bottomley <James.Bottomley@HansenPartnership.com>

This replaces list_for_each_safe and list_entry with
list_for_each_entry_safe.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_debug.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1a91063..681b591 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2930,8 +2930,7 @@ static int sdebug_add_adapter(void)
 	int k, devs_per_host;
         int error = 0;
         struct sdebug_host_info *sdbg_host;
-        struct sdebug_dev_info *sdbg_devinfo;
-        struct list_head *lh, *lh_sf;
+	struct sdebug_dev_info *sdbg_devinfo, *tmp;
 
         sdbg_host = kzalloc(sizeof(*sdbg_host),GFP_KERNEL);
         if (NULL == sdbg_host) {
@@ -2971,9 +2970,8 @@ static int sdebug_add_adapter(void)
         return error;
 
 clean:
-	list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
-		sdbg_devinfo = list_entry(lh, struct sdebug_dev_info,
-					  dev_list);
+	list_for_each_entry_safe(sdbg_devinfo, tmp, &sdbg_host->dev_info_list,
+				 dev_list) {
 		list_del(&sdbg_devinfo->dev_list);
 		kfree(sdbg_devinfo);
 	}
@@ -3062,9 +3060,8 @@ static int sdebug_driver_probe(struct device * dev)
 
 static int sdebug_driver_remove(struct device * dev)
 {
-        struct list_head *lh, *lh_sf;
         struct sdebug_host_info *sdbg_host;
-        struct sdebug_dev_info *sdbg_devinfo;
+	struct sdebug_dev_info *sdbg_devinfo, *tmp;
 
 	sdbg_host = to_sdebug_host(dev);
 
@@ -3076,9 +3073,8 @@ static int sdebug_driver_remove(struct device * dev)
 
         scsi_remove_host(sdbg_host->shost);
 
-        list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
-                sdbg_devinfo = list_entry(lh, struct sdebug_dev_info,
-                                          dev_list);
+	list_for_each_entry_safe(sdbg_devinfo, tmp, &sdbg_host->dev_info_list,
+				 dev_list) {
                 list_del(&sdbg_devinfo->dev_list);
                 kfree(sdbg_devinfo);
         }
-- 
1.5.3.7

