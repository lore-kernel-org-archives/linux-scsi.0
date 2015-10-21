From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 01/37] cxlflash: Fix to avoid invalid port_sel value
Date: Wed, 21 Oct 2015 15:10:31 -0500
Message-ID: <1445458231-50155-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:50189 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbbJUUMP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:12:15 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:12:15 -0400
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 817EE6E8059
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:00:24 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKCDjD63176928
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:12:13 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKCA3F017904
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:12:12 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Manoj Kumar <kumarmn@us.ibm.com>

From: Manoj Kumar <kumarmn@us.ibm.com>

If two concurrent MANAGE_LUN ioctls are issued with the same
WWID parameter, it would result in an incorrect value of port_sel.

This is because port_sel is modified without any locks being
held. If the first caller stalls after the return from
find_and_create_lun(), the value of port_sel will be set
incorrectly to indicate a single port, though in this case
it should have been set to both ports.

To fix, use the global mutex to serialize the lookup of the
WWID and the subsequent modification of port_sel.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
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

