From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 01/29] cxlflash: Move global.mutex to caller of find_and_create_lun()
Date: Fri, 11 Sep 2015 16:09:40 -0500
Message-ID: <1442005780-46309-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:51268 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbbIKVLP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:11:15 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 15:11:14 -0600
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 1840A1FF004C
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:02:02 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BL9tk245154404
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 14:10:03 -0700
Received: from d03av02.boulder.ibm.com (localhost [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLAJiv001686
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 15:10:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, Manoj Kumar <kumarmn@us.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

From: Manoj Kumar <kumarmn@us.ibm.com>

Since the retrieved LUN is modified in the caller, hold the mutex
across modifications as well.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/lunmgt.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxlflash/lunmgt.c b/drivers/scsi/cxlflash/lunmgt.c
index d98ad0f..8c372fc 100644
--- a/drivers/scsi/cxlflash/lunmgt.c
+++ b/drivers/scsi/cxlflash/lunmgt.c
@@ -120,7 +120,8 @@ static struct glun_info *lookup_global(u8 *wwid)
  *
  * The LUN is kept both in a local list (per adapter) and in a global list
  * (across all adapters). Certain attributes of the LUN are local to the
- * adapter (such as index, port selection mask etc.).
+ * adapter (such as index, port selection mask, etc.).
+ *
  * The block allocation map is shared across all adapters (i.e. associated
  * wih the global list). Since different attributes are associated with
  * the per adapter and global entries, allocate two separate structures for each
@@ -128,6 +129,8 @@ static struct glun_info *lookup_global(u8 *wwid)
  *
  * Keep a pointer back from the local to the global entry.
  *
+ * This routine assumes the caller holds the global mutex.
+ *
  * Return: Found/Allocated local lun_info structure on success, NULL on failure
  */
 static struct llun_info *find_and_create_lun(struct scsi_device *sdev, u8 *wwid)
@@ -137,7 +140,6 @@ static struct llun_info *find_and_create_lun(struct scsi_device *sdev, u8 *wwid)
 	struct Scsi_Host *shost = sdev->host;
 	struct cxlflash_cfg *cfg = shost_priv(shost);
 
-	mutex_lock(&global.mutex);
 	if (unlikely(!wwid))
 		goto out;
 
@@ -169,7 +171,6 @@ static struct llun_info *find_and_create_lun(struct scsi_device *sdev, u8 *wwid)
 	list_add(&gli->list, &global.gluns);
 
 out:
-	mutex_unlock(&global.mutex);
 	pr_debug("%s: returning %p\n", __func__, lli);
 	return lli;
 }
@@ -235,6 +236,7 @@ int cxlflash_manage_lun(struct scsi_device *sdev,
 	u64 flags = manage->hdr.flags;
 	u32 chan = sdev->channel;
 
+	mutex_lock(&global.mutex);
 	lli = find_and_create_lun(sdev, manage->wwid);
 	pr_debug("%s: ENTER: WWID = %016llX%016llX, flags = %016llX li = %p\n",
 		 __func__, get_unaligned_le64(&manage->wwid[0]),
@@ -261,6 +263,7 @@ int cxlflash_manage_lun(struct scsi_device *sdev,
 	}
 
 out:
+	mutex_unlock(&global.mutex);
 	pr_debug("%s: returning rc=%d\n", __func__, rc);
 	return rc;
 }
-- 
2.1.0

