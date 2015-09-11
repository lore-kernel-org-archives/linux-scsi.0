From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 05/29] cxlflash: Always attempt LUN table initialization
Date: Fri, 11 Sep 2015 16:10:14 -0500
Message-ID: <1442005814-46498-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:44936 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbbIKVKc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2015 17:10:32 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Fri, 11 Sep 2015 17:10:31 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id B5F5438C8039
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:10:29 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8BLATGU53084176
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 21:10:29 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8BLAStJ002343
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2015 17:10:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On a virtual LUN open, there should always be an attempt made to
update the LUN table for the adapter, regardless of the the global
LUN's state prior to the open. This is necessary in a multi-adapter
environment so that access to a LUN [that has already been transitioned
to virtual mode] through a second (or greater) adapter is configured
correctly by programming the adapter's LUN table.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/vlun.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 68994c4..96b074f 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -915,16 +915,9 @@ int cxlflash_disk_virtual_open(struct scsi_device *sdev, void *arg)
 
 	pr_debug("%s: ctxid=%llu ls=0x%llx\n", __func__, ctxid, lun_size);
 
+	/* Setup the LUNs block allocator on first call */
 	mutex_lock(&gli->mutex);
 	if (gli->mode == MODE_NONE) {
-		/* Setup the LUN table and block allocator on first call */
-		rc = init_luntable(cfg, lli);
-		if (rc) {
-			dev_err(dev, "%s: call to init_luntable failed "
-				"rc=%d!\n", __func__, rc);
-			goto err0;
-		}
-
 		rc = init_vlun(lli);
 		if (rc) {
 			dev_err(dev, "%s: call to init_vlun failed rc=%d!\n",
@@ -942,6 +935,13 @@ int cxlflash_disk_virtual_open(struct scsi_device *sdev, void *arg)
 	}
 	mutex_unlock(&gli->mutex);
 
+	rc = init_luntable(cfg, lli);
+	if (rc) {
+		dev_err(dev, "%s: call to init_luntable failed rc=%d!\n",
+			__func__, rc);
+		goto err1;
+	}
+
 	ctxi = get_context(cfg, rctxid, lli, 0);
 	if (unlikely(!ctxi)) {
 		dev_err(dev, "%s: Bad context! (%llu)\n", __func__, ctxid);
-- 
2.1.0

