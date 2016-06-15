From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 1/3] cxlflash: Fix to drain operations from previous reset
Date: Wed, 15 Jun 2016 18:49:20 -0500
Message-ID: <1466034560-17864-1-git-send-email-ukrishn@linux.vnet.ibm.com>
References: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10670 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932321AbcFOXti (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 19:49:38 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FNmoLj004683
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:49:37 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23jggtyweh-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:49:37 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 17:49:37 -0600
In-Reply-To: <1466034460-17797-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

From: "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

While running 'sg_reset -H' in a loop with a user-space application active,
hit the following exception:

cpu 0x2: Vector: 300 (Data Access)
    pc: : afu_attach+0x50/0x240 [cxlflash]
    lr: : cxlflash_afu_recover+0x3dc/0x7d0 [cxlflash]
    pid   = 20365, comm = run_block_fvt

Linux version 4.5.0-491-26f710d+

cxlflash_afu_recover+0x3dc/0x7d0 [cxlflash]
cxlflash_ioctl+0x5a8/0x6f0 [cxlflash]
scsi_ioctl+0x3b0/0x4c0
sd_ioctl+0x110/0x190
blkdev_ioctl+0x28c/0xc20
block_ioctl+0xa4/0xd0
do_vfs_ioctl+0xd8/0x8c0
SyS_ioctl+0xd4/0xf0
system_call+0x38/0xb4

The problem here is that the problem space area is unmapped while the
application issues the DK_CXLFLASH_RECOVER_AFU ioctl.

This is the order I observe:

proc1				proc2
1) sg_reset
				2) ioctl(DK_CXLFLASH_RECOVER_AFU)
3) sg_reset again
   causing a PSA unmap
				4) continues RECOVER_AFU processing

The resolution to this problem is to have the reset handler drain all
outstanding user space initiated ioctls before proceeding.  It is safe
to drain after the state has been changed to STATE_RESET. Also since
drain_ioctls() was static, it had to be moved up a bit to be before
cxlflash_eh_host_reset_handler().

Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 8fb9643..f1f977f 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -1916,6 +1916,19 @@ static int afu_reset(struct cxlflash_cfg *cfg)
 }
 
 /**
+ * drain_ioctls() - wait until all currently executing ioctls have completed
+ * @cfg:	Internal structure associated with the host.
+ *
+ * Obtain write access to read/write semaphore that wraps ioctl
+ * handling to 'drain' ioctls currently executing.
+ */
+static void drain_ioctls(struct cxlflash_cfg *cfg)
+{
+	down_write(&cfg->ioctl_rwsem);
+	up_write(&cfg->ioctl_rwsem);
+}
+
+/**
  * cxlflash_eh_device_reset_handler() - reset a single LUN
  * @scp:	SCSI command to send.
  *
@@ -1986,6 +1999,7 @@ static int cxlflash_eh_host_reset_handler(struct scsi_cmnd *scp)
 	switch (cfg->state) {
 	case STATE_NORMAL:
 		cfg->state = STATE_RESET;
+		drain_ioctls(cfg);
 		cxlflash_mark_contexts_error(cfg);
 		rcr = afu_reset(cfg);
 		if (rcr) {
@@ -2504,19 +2518,6 @@ out_remove:
 }
 
 /**
- * drain_ioctls() - wait until all currently executing ioctls have completed
- * @cfg:	Internal structure associated with the host.
- *
- * Obtain write access to read/write semaphore that wraps ioctl
- * handling to 'drain' ioctls currently executing.
- */
-static void drain_ioctls(struct cxlflash_cfg *cfg)
-{
-	down_write(&cfg->ioctl_rwsem);
-	up_write(&cfg->ioctl_rwsem);
-}
-
-/**
  * cxlflash_pci_error_detected() - called when a PCI error is detected
  * @pdev:	PCI device struct.
  * @state:	PCI channel state.
-- 
2.1.0

