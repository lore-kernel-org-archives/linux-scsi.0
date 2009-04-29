From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod/pSCSI]: Add
	block/blk-map.c:blk_rq_map_kern_sg() usage
Date: Tue, 28 Apr 2009 17:43:02 -0700
Message-ID: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from n22.bullet.mail.mud.yahoo.com ([68.142.206.161]:44798 "HELO
	n22.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754845AbZD2AnH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2009 20:43:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>

Greetings all,

This patch adds a new version of pscsi_map_task_SG() for the Linux/SCSI
passthrough subsystem plugin for target_core_mod v3.0 that uses Tejun's blk-map
patches on v2.6.30-rcX from git.kernel.org/pub/scm/linux/kernel/tj/misc.git blk-map.
This patch adds a LINUX_USE_NEW_BLK_MAP define to allow both blk_rq_map_kern_sg() and
legacy, non blk_rq_map_kern_sg() operation (with some limitiations with the latter) to
function.

Once Tejun's patches for block/blk-map.c:blk_rq_map_kern_sg() have been included
upstream, the legacy pscsi_map_task_SG() will be removed and blk-map will become
the preferred method for accessing struct scatterlist -> struct scsi_device for
SCSI target operations.  For now, I have created a blk-map branch in lio-core-2.6.git with
LINUX_USE_NEW_BLK_MAP=1 and left LINUX_USE_NEW_BLK_MAP=0 in branch master.

This patch also updates pscsi_map_task_non_SG()'s usage of blk_rq_map_kern(), whos
parameters have also been simplified in Tejun's patches.  It has been tested with
lio-core-2.6.git branch master and blk-map and tested on v2.6.30-rc3 x86 32-bit
HVM. The lio-core-2.6.git tree can be found at: 

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

So far, using Tejun's new code with LINUX_USE_NEW_BLK_MAP=1 is passing badblocks from
target_core_Mod/pSCSI exported Vmware mpt-fusion virtual SCSI HBA of TYPE_DISK.  Both the
ConfigFS 'file-descriptor' method and 'SCSI HCTL reference' method for accessing
struct scsi_device have been tested and are working with lio-core-2.6.git blk-map.

Currently *without* the blk-map patches on v2.6.30-rc3, is target_core_mod/pSCSI export is
limited to TYPE_DISK and TYPE_ROM that reference a struct block_device using the ConfigFS
'file descriptor' method.  This is because bio_add_page() expects struct block_device to be
each struct bio associated with the struct request w/o Tejun's blk_rq_map_kern_sg().

Thanks Tejun for this patch series!  Things have been stable so far and I hope to try some
'bare-metal' and IOV enabled Linux/SCSI target exports using this patch series, along with validating
blk-map on some non TYPE_DISK exports using target_core_mod/pSCSI.  I believe you intend this series for
v2.6.31 correct..? 

Boaz, have you had a chance to port your stuff over to this yet..?  Other comments..?

--nab

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/MCONFIG_TARGET      |    1 +
 drivers/target/Makefile            |    4 ++-
 drivers/target/target_core_pscsi.c |   49 ++++++++++++++++++++++++++++++++++-
 3 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/target/MCONFIG_TARGET b/drivers/target/MCONFIG_TARGET
index 8023deb..96541c4 100644
--- a/drivers/target/MCONFIG_TARGET
+++ b/drivers/target/MCONFIG_TARGET
@@ -22,3 +22,4 @@ LINUX_FILEIO ?= 1
 LINUX_VPD_PAGE_CHECK?=1
 
 LIO_TARGET_CONFIGFS?=1
+LINUX_USE_NEW_BLK_MAP?=0
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 47fef07..a19490d 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -73,7 +73,9 @@ endif
 ifeq ($(LINUX_SCSI_MEDIA_ROM), 1)
 EXTRA_CFLAGS += -DLINUX_SCSI_MEDIA_ROM
 endif
-
+ifeq ($(LINUX_USE_NEW_BLK_MAP), 1)
+EXTRA_CFLAGS += -DLINUX_USE_NEW_BLK_MAP
+endif
 ifeq ($(DEBUG_DEV), 1)
 EXTRA_CFLAGS += -DDEBUG_DEV
 endif
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 0962563..0edcb9a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -518,7 +518,12 @@ se_device_t *pscsi_create_virtdevice(
 				" parameter\n");
 		return NULL;
 	}
-
+#ifndef LINUX_USE_NEW_BLK_MAP
+	printk(KERN_ERR "Sorry, when running on >= v2.6.30 w/o blk-map branch"
+		" you need to use the ConfigFS file descriptor method for"
+		" accessing Linux/SCSI passthrough storage objects\n");
+	return -EINVAL;
+#endif
 	spin_lock_irq(sh->host_lock);
 	list_for_each_entry(sd, &sh->__devices, siblings) {
 		if (!(pdv->pdv_channel_id == sd->channel) ||
@@ -1269,6 +1274,39 @@ static inline struct bio *pscsi_get_bio(pscsi_dev_virt_t *pdv, int sg_num)
 #define DEBUG_PSCSI(x...)
 #endif
 
+#ifdef LINUX_USE_NEW_BLK_MAP
+
+/*	pscsi_map_task_SG()
+ *
+ *	This function uses the new struct scatterlist-> struct request mapping
+ *      from git.kernel.org/pub/scm/linux/kernel/tj/misc.git blk-map
+ *
+ *	This code is not upstream yet, so lio-core-2.6.git now has a blk-map
+ *	branch until this happens..
+ */
+int pscsi_map_task_SG(se_task_t *task)
+{
+	pscsi_plugin_task_t *pt = (pscsi_plugin_task_t *) task->transport_req;
+	struct request *rq = pt->pscsi_req;
+	int ret;
+	/*
+	 * For SCF_SCSI_DATA_SG_IO_CDB, use block/blk-map.c:blk_rq_map_kern_sg()
+	 * for mapping struct scatterlist to struct request.  Thanks Tejun!
+	 */
+	ret = blk_rq_map_kern_sg(rq, task->task_sg, task->task_sg_num,
+			GFP_KERNEL);
+	if (ret != 0) {
+		printk(KERN_ERR "blk_rq_map_kern_sg() failed for rq: %p"
+				" task_sg: %p task_sg_num: %u\n",
+			rq, task->task_sg, task->task_sg_num);
+		return -1;
+	}
+
+	return task->task_sg_num;
+}
+
+#else
+
 /*      pscsi_map_task_SG():
  *
  *
@@ -1376,6 +1414,9 @@ fail:
 	return ret;
 }
 
+#endif /* LINUX_USE_NEW_BLK_MAP */
+
+
 /*	pscsi_map_task_non_SG():
  *
  *
@@ -1389,10 +1430,14 @@ int pscsi_map_task_non_SG(se_task_t *task)
 
 	if (!task->task_size)
 		return 0;
-
+#ifdef LINUX_USE_NEW_BLK_MAP
+	ret = blk_rq_map_kern(pt->pscsi_req, T_TASK(cmd)->t_task_buf,
+			task->task_size, GFP_KERNEL);
+#else
 	ret = blk_rq_map_kern(pdv->pdv_sd->request_queue,
 			pt->pscsi_req, T_TASK(cmd)->t_task_buf,
 			task->task_size, GFP_KERNEL);
+#endif
 	if (ret < 0) {
 		printk(KERN_ERR "PSCSI: blk_rq_map_kern() failed: %d\n", ret);
 		return PYX_TRANSPORT_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-- 
1.5.4.1




