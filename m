From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 05/37] cxlflash: Fix data corruption when vLUN used over multiple cards
Date: Wed, 21 Oct 2015 15:11:26 -0500
Message-ID: <1445458286-35637-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:42453 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbbJUUMx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:12:53 -0400
Received: from localhost
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 16:12:53 -0400
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 1DC9638C805E
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:12:51 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKCpgR61145122
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 20:12:51 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKC4tU004562
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 16:12:09 -0400
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

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
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
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

