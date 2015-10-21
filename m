From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH v6 30/37] cxlflash: Fix to avoid corrupting adapter fops
Date: Wed, 21 Oct 2015 15:15:37 -0500
Message-ID: <1445458537-60298-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:44635 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825AbbJUURA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 16:17:00 -0400
Received: from localhost
	by e39.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 21 Oct 2015 14:17:00 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0A2B619D804C
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:05:07 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9LKGu7W1704352
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 13:16:56 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9LKGt39000852
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2015 14:16:56 -0600
In-Reply-To: <1445458134-63197-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Brian King <brking@linux.vnet.ibm.com>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Tomas Henzl <thenzl@redhat.com>, David Laight <David.Laight@ACULAB.COM>
Cc: Michael Neuling <mikey@neuling.org>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org

The fops owned by the adapter can be corrupted in certain scenarios,
opening a window where certain fops are temporarily NULLed before being
reset to their proper value. This can potentially lead software to make
incorrect decisions, leaving the user with the inability to function as
intended.

An example of this behavior can be observed when there are a number of
users with a high rate of turn around (attach to LUN, perform an I/O,
detach from LUN, repeat). Every so often a user is given a valid
context and adapter file descriptor, but the file associated with the
descriptor lacks the correct read permission bit (FMODE_CAN_READ) and
thus the read system call bails before calling the valid read fop.

Background:

The fops is stored in the adapter structure to provide the ability to
lookup the adapter structure from within the fop handler. CXL services
use the file's private_data and at present, the CXL context does not
have a private section. In an effort to limit areas of the cxlflash
driver with code specific the superpipe function, a design choice was
made to keep the details of the fops situated away from the legacy
portions of the driver. This drove the behavior that the adapter fops
is set at the beginning of the disk attach ioctl handler when there
are no users present.

The corruption that this fix remedies is due to the fact that the fops
is initially defaulted to values found within a static structure. When
the fops is handed down to the CXL services later in the attach path,
certain services are patched. The fops structure remains correct until
the user count drops to 0 and the fops is reset, triggering the process
to repeat again. The user counts are tightly coupled with the creation
and deletion of the user context. If multiple users perform a disk
attach at the same time, when the user count is currently 0, some users
can be in the middle of obtaining a file descriptor and have not yet
reached the context creation code that [in addition to creating the
context] increments the user count. Subsequent users coming in to
perform the attach see that the user count is still 0, and reinitialize
the fops, temporarily removing the patched fops. The users that are in
the middle obtaining their file descriptor may then receive an invalid
descriptor.

The fix simply removes the user count altogether and moves the fops
initialization to probe time such that it is only performed one time
for the life of the adapter. In the future, if the CXL services adopt
a private member for their context, that could be used to store the
adapter structure reference and cxlflash could revert to a model that
does not require an embedded fops.

Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Reviewed-by: Daniel Axtens <dja@axtens.net>
---
 drivers/scsi/cxlflash/common.h    |  3 +--
 drivers/scsi/cxlflash/main.c      |  1 +
 drivers/scsi/cxlflash/superpipe.c | 11 +----------
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/cxlflash/common.h b/drivers/scsi/cxlflash/common.h
index bbfe711..c11cd19 100644
--- a/drivers/scsi/cxlflash/common.h
+++ b/drivers/scsi/cxlflash/common.h
@@ -21,6 +21,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 
+extern const struct file_operations cxlflash_cxl_fops;
 
 #define MAX_CONTEXT  CXLFLASH_MAX_CONTEXT       /* num contexts per afu */
 
@@ -115,8 +116,6 @@ struct cxlflash_cfg {
 	struct list_head ctx_err_recovery; /* contexts w/ recovery pending */
 	struct file_operations cxl_fops;
 
-	atomic_t num_user_contexts;
-
 	/* Parameters that are LUN table related */
 	int last_lun_index[CXLFLASH_NUM_FC_PORTS];
 	int promote_lun_index;
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 51883be..3f43879 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -2386,6 +2386,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 
 	cfg->init_state = INIT_STATE_NONE;
 	cfg->dev = pdev;
+	cfg->cxl_fops = cxlflash_cxl_fops;
 
 	/*
 	 * The promoted LUNs move to the top of the LUN table. The rest stay
diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 3cc8609..f625e07 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -712,7 +712,6 @@ static void destroy_context(struct cxlflash_cfg *cfg,
 	kfree(ctxi->rht_needs_ws);
 	kfree(ctxi->rht_lun);
 	kfree(ctxi);
-	atomic_dec_if_positive(&cfg->num_user_contexts);
 }
 
 /**
@@ -769,7 +768,6 @@ static struct ctx_info *create_context(struct cxlflash_cfg *cfg,
 	INIT_LIST_HEAD(&ctxi->luns);
 	INIT_LIST_HEAD(&ctxi->list); /* initialize for list_empty() */
 
-	atomic_inc(&cfg->num_user_contexts);
 	mutex_lock(&ctxi->mutex);
 out:
 	return ctxi;
@@ -1164,10 +1162,7 @@ out:
 	return rc;
 }
 
-/*
- * Local fops for adapter file descriptor
- */
-static const struct file_operations cxlflash_cxl_fops = {
+const struct file_operations cxlflash_cxl_fops = {
 	.owner = THIS_MODULE,
 	.mmap = cxlflash_cxl_mmap,
 	.release = cxlflash_cxl_release,
@@ -1286,10 +1281,6 @@ static int cxlflash_disk_attach(struct scsi_device *sdev,
 
 	int fd = -1;
 
-	/* On first attach set fileops */
-	if (atomic_read(&cfg->num_user_contexts) == 0)
-		cfg->cxl_fops = cxlflash_cxl_fops;
-
 	if (attach->num_interrupts > 4) {
 		dev_dbg(dev, "%s: Cannot support this many interrupts %llu\n",
 			__func__, attach->num_interrupts);
-- 
2.1.0

