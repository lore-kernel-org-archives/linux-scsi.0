From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v2 05/30] cxlflash: Fix data corruption when vLUN used over multiple cards
Date: Wed, 16 Sep 2015 11:53:00 -0500
Message-ID: <1442422380-41110-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:37580 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967AbbIPQx2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 12:53:28 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 16 Sep 2015 12:53:27 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 5B8396E8045
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 12:45:09 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8GGrPI050921660
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 16:53:25 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8GGrO5k029847
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 12:53:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com, andrew.donnellan@au1.ibm.com
Cc: mikey@neuling.org, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

If the same virtual LUN is accessed over multiple cards, only accesses
made over the first card will be valid. Accesses made over the second
card will go to the wrong LUN causing data corruption.

This is because the global LUN's mode word was being used to determine
whether the LUN table for that card needs to be programmed. The mode
word would be setup by the first card, causing the LUN table for the
second card to not be programmed.

By unconditionally initializing the LUN table (not depending on the
mode word), the problem is avoided.

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

