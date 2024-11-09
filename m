Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D613A89B
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127535; cv=none; b=o3X+DAq58FMeutwbc/JY8B9HmwrjGEuJ3fVGatvuJJltbgRQmYeayv3Ol2rvPtqHxUlc7k01I28yFkJZwscrO3VmMHjfJ0L4INQ6sf03BWjbzJFTDVn+nfhxWxAHxE1ru5fy72b8MWwEWaNI4c7KUfCLJKsVyg3t6aidXoCo4+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127535; c=relaxed/simple;
	bh=BLaDdgRfFUM588wy0p12T5Q1kij4RkekpGW9gKfae50=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyvihMLEC4yMjcoHxP+dccrcA+rBySfZM5DeoAFTsjq/nUZJ0/1hiskQg8BPFmG6rxAd0/wS0wo7MSurdGb7QN9NqfI3HIdRb8FKwhdQnK1onQJ8dECeqoodVdr1EBY+jWbrr6BECxSJyaRHUZ4ZCCdWw686cE87ONKxgo5LajA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZQTXXewN; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZQTXXewN"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94JDEF005644
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=YeVHt
	uld5WncezmePkw/P2ZIM6RS83710TQscqSyfZQ=; b=ZQTXXewNlTexMRZ1uFKPu
	HTKc+ymN9kt+XBIMPQM6cUrk4hz+pi6nPrp07vswBFQWJT1t2Xh8fkRxW4MtXgB+
	i2XdB43UgYACJJ2HudD8GHFDyZqS+w11RcefJAvR5QhiTMW26nXMPv22BJuOtEwL
	34pQhXplItaCkEXUSbMD6vb/o5hAmbzemRWq/DBa7IJdqvIYXDkic409En9jgCEF
	IxQ3H6hLWUwEHUO9RS+WWlYb1aSqNHixerzc1yPz//EbTiAPhPXO1YKE6EIUOQn/
	oWOa/RrBteuXYwNssR4aU7IZ+HINUq3M8fIFQMv3ThZZbOkk6rZoA1r/OstLVfcU
	g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0k200a2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91Xu83034477
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65aj9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTdO001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:29 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-2;
	Sat, 09 Nov 2024 04:45:29 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 1/8] scsi: Add multipath device support
Date: Sat,  9 Nov 2024 04:45:22 +0000
Message-ID: <20241109044529.992935-2-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.41.0.rc2
In-Reply-To: <20241109044529.992935-1-himanshu.madhani@oracle.com>
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_03,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090036
X-Proofpoint-ORIG-GUID: vqJjILdD9TFpMlSHmCa27Dm6rVJt1Cis
X-Proofpoint-GUID: vqJjILdD9TFpMlSHmCa27Dm6rVJt1Cis

From: Himanshu Madhani <himanshu.madhani@oracle.com>

- Add multipath device support to scsi_device
- Add multipath support to scsi_host
- Add Kconfig and Makefile
- Create new scsi_multipath.[ch] files

Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/Kconfig          |  12 +
 drivers/scsi/Makefile         |   2 +
 drivers/scsi/scsi_multipath.c | 896 ++++++++++++++++++++++++++++++++++
 include/scsi/scsi_device.h    |  64 +++
 include/scsi/scsi_host.h      |   7 +
 include/scsi/scsi_multipath.h |  86 ++++
 6 files changed, 1067 insertions(+)
 create mode 100644 drivers/scsi/scsi_multipath.c
 create mode 100644 include/scsi/scsi_multipath.h

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 37c24ffea65c..d1298fac774c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,18 @@ config SCSI_LIB_KUNIT_TEST
 
 	  If unsure say N.
 
+config SCSI_MULTIPATH
+	bool "SCSI multipath support"
+	depends on SCSI
+	depends on SCSI_DH  && SCSI_DH_ALUA
+	help
+	  This option enables support for native SCSI multipath support for
+	  SCSI host. This option depends on Asymmetric Logical Unit Access
+	  support to be enabled on the device. If this option is enabled a
+	  single /dev/mpathXsdY device will show up for each SCSI host.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1313ddf2fd1a..017795bc224d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -154,6 +154,8 @@ obj-$(CONFIG_SCSI_ENCLOSURE)	+= ses.o
 
 obj-$(CONFIG_SCSI_HISI_SAS) += hisi_sas/
 
+obj-$(CONFIG_SCSI_MULTIPATH) += scsi_multipath.o
+
 # This goes last, so that "real" scsi devices probe earlier
 obj-$(CONFIG_SCSI_DEBUG)	+= scsi_debug.o
 scsi_mod-y			+= scsi.o hosts.o scsi_ioctl.o \
diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
new file mode 100644
index 000000000000..45684704b9e2
--- /dev/null
+++ b/drivers/scsi/scsi_multipath.c
@@ -0,0 +1,896 @@
+// SPDX-License-Indentifier: GPL-2.0
+/*
+ * Copyright (c) 2024 Himanshu Madhani
+ *
+ * SCSI Multipath support using ALUA (Asymmetric Logical Unit Access)
+ * capable devices.
+ */
+
+#include <linux/bio.h>
+#include <linux/moduleparam.h>
+#include <linux/topology.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dh.h>
+#include <scsi/scsi_proto.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_multipath.h>
+
+bool scsi_multipath = true;
+module_param(scsi_multipath, bool, 0444);
+MODULE_PARM_DESC(scsi_multipath,
+    "turn on native support for multiple scsi devices \n"
+    "set this value to false to disable multipath, \n");
+
+static const char *scsi_iopolicy_names[] = {
+	[SCSI_MPATH_IOPOLICY_NUMA]	= "numa",
+	[SCSI_MPATH_IOPOLICY_RR]	= "round-robin",
+};
+
+static int iopolicy = SCSI_MPATH_IOPOLICY_NUMA;
+
+/*
+ * SCSI multipath will only allow 'NUMA' or 'round-robin' policy for IO.
+ * In Future, if more apropriate IO-policy is introduced will be added
+ * based on community feedback.
+ */
+static int scsi_set_iopolicy(const char *val, const struct kernel_param *kp)
+{
+	if (!val)
+		return -EINVAL;
+	if (!strncmp(val, "numa", 4))
+		iopolicy = SCSI_MPATH_IOPOLICY_NUMA;
+	else if (!strncmp(val, "round-robin", 11))
+		iopolicy = SCSI_MPATH_IOPOLICY_RR;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static int scsi_get_iopolicy(char *buf, const struct kernel_param *kp)
+{
+	return sprintf(buf, "%s\n", scsi_iopolicy_names[iopolicy]);
+}
+
+module_param_call(iopolicy, scsi_set_iopolicy, scsi_get_iopolicy,
+    &iopolicy, 0644);
+MODULE_PARM_DESC(iopolicy,
+    "Default multipath I/O policy; 'numa' (default) or 'round-robin'");
+
+void scsi_mpath_default_iopolicy(struct scsi_device *sdev)
+{
+	sdev->mpath_iopolicy = iopolicy;
+}
+
+void scsi_multipath_iopolicy_update(struct scsi_device *sdev, int iopolicy)
+{
+	struct Scsi_Host *shost =  sdev->host;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+	int old_iopolicy = READ_ONCE(sdev->mpath_iopolicy);
+
+	if (old_iopolicy == iopolicy)
+		return;
+
+	WRITE_ONCE(sdev->mpath_iopolicy, iopolicy);
+
+	/* iopoliocy changes clear the multipath */
+	mutex_lock(&mpath_dev->mpath_lock);
+	list_for_each_entry_rcu(sdev, &shost->mpath_sdev, mpath_entry)
+		scsi_mpath_clear_paths(shost);
+	mutex_unlock(&mpath_dev->mpath_lock);
+
+	sdev_printk(KERN_NOTICE, sdev, "Multipath iopolocy changed from %s to %s\n",
+	    scsi_iopolicy_names[old_iopolicy], scsi_iopolicy_names[iopolicy]);
+}
+
+bool scsi_mpath_clear_current_path(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+	bool changed = false;
+	int node;
+
+	if (!sdev)
+		return changed;
+
+	for_each_node(node) {
+		if (sdev == rcu_access_pointer(mpath_dev->current_path[node])) {
+			rcu_assign_pointer(mpath_dev->current_path[node], NULL);
+			changed = true;
+		}
+	}
+
+	return changed;
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_clear_current_path);
+
+void scsi_mpath_clear_paths(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	int srcu_idx;
+
+	srcu_idx = srcu_read_lock(&shost->mpath_dev->srcu);
+	list_for_each_entry_rcu(sdev, &shost->mpath_sdev, mpath_entry) {
+		scsi_mpath_clear_current_path(sdev);
+		kblockd_schedule_work(&shost->mpath_dev->mpath_requeue_work);
+	}
+	srcu_read_unlock(&shost->mpath_dev->srcu, srcu_idx);
+
+}
+
+static inline bool scsi_mpath_state_is_live(enum scsi_mpath_access_state state)
+{
+	if (state == SCSI_MPATH_OPTIMAL ||
+	    state == SCSI_MPATH_ACTIVE)
+		return true;
+
+	return false;
+}
+
+/* Check for path error */
+static inline bool scsi_is_mpath_error(struct scsi_cmnd *scmd)
+{
+	struct request *req = scsi_cmd_to_rq(scmd);
+	struct scsi_device *sdev = req->q->queuedata;
+
+	if (sdev->handler && sdev->handler->prep_fn) {
+		blk_status_t ret = sdev->handler->prep_fn(sdev, req);
+
+		if (ret != BLK_STS_OK)
+			return true;
+	}
+
+	return false;
+}
+
+static bool scsi_mpath_is_disabled(struct scsi_device *sdev)
+{
+	enum scsi_device_state sdev_state = sdev->sdev_state;
+
+	/*
+	 * if device multipath state is not set to LIVE
+	 * then return true
+	 */
+	if (!scsi_mpath_state_is_live(sdev->mpath_state))
+		return true;
+
+	/*
+	 * Do not treat DELETING as a disabled path as I/O should
+	 * still be able to complete assuming that scsi_device is
+	 * within timeout limit.
+	 * Otherwise I/O will fail immeadiately and return to
+	 * requeue list
+	 */
+	if (sdev_state != SDEV_RUNNING && sdev_state != SDEV_CANCEL)
+		return true;
+
+	return false;
+}
+
+/* handle failover request for path */
+void scsi_mpath_failover_req(struct request *req)
+{
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = scmd->device;
+	struct Scsi_Host *shost = scmd->device->host;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+	unsigned long flags;
+	struct bio *bio;
+
+	if (!scsi_device_online(sdev) || sdev->was_reset || sdev->locked)
+		return;
+
+	scsi_mpath_clear_current_path(sdev);
+
+	/*
+	 * if we got device handler error, we know that device is alive but not
+	 * ready to process command. kick off a requeue of scsi command and try
+	 * other available path
+	 */
+	if (scsi_is_mpath_error(scmd)) {
+		/*
+		 * Set flag as pending and requeue bio for retry on
+		 * another path
+		 */
+		set_bit(SCSI_MPATH_DISK_IO_PENDING, &sdev->mpath_flags);
+		queue_work(shost->work_q, &mpath_dev->mpath_requeue_work);
+	}
+
+	/*
+	 * following logic tries to steal bio, check if the bio has polled
+	 * operation, if yes, then clear polled reqeust and reqeue bio
+	 */
+	spin_lock_irqsave(&mpath_dev->mpath_requeue_lock, flags);
+	for (bio = req->bio; bio; bio = bio->bi_next) {
+		bio_set_dev(bio, req->q->disk->part0);
+		if (bio->bi_opf & REQ_POLLED) {
+			bio->bi_opf &= ~REQ_POLLED;
+			bio->bi_cookie = BLK_QC_T_NONE;
+		}
+	}
+	blk_steal_bios(&mpath_dev->mpath_requeue_list, req);
+	spin_unlock_irqrestore(&mpath_dev->mpath_requeue_lock, flags);
+
+	scmd->result = 0;
+
+	blk_mq_end_request(req, 0);
+
+	kblockd_schedule_work(&mpath_dev->mpath_requeue_work);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_failover_req);
+
+static inline bool scsi_mpath_is_optimized(struct scsi_device *sdev)
+{
+	return (!scsi_device_online(sdev) &&
+	    ((sdev->mpath_state == SCSI_MPATH_OPTIMAL) ||
+	     (sdev->mpath_state == SCSI_MPATH_ACTIVE)));
+}
+
+static struct scsi_device *scsi_next_mpath_sdev(struct Scsi_Host *shost,
+			struct scsi_device *sdev)
+{
+	sdev = list_next_or_null_rcu(&shost->mpath_sdev, &sdev->siblings,
+	    struct scsi_device, siblings);
+
+	if (sdev)
+		return sdev;
+
+	return list_first_or_null_rcu(&shost->mpath_sdev, struct scsi_device,
+	    siblings);
+}
+
+static struct scsi_device *scsi_mpath_round_robin_path(struct Scsi_Host *shost,
+	int node, struct scsi_device *old_sdev)
+{
+	struct scsi_device *sdev, *found = NULL;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+
+	if (list_is_singular(&shost->mpath_sdev)) {
+		if(scsi_mpath_is_disabled(old_sdev))
+			return NULL;
+		return old_sdev;
+	}
+
+	for (sdev = scsi_next_mpath_sdev(shost, old_sdev);
+	    sdev && sdev != old_sdev;
+	    sdev = scsi_next_mpath_sdev(shost, sdev)) {
+		if (scsi_mpath_is_disabled(sdev))
+			continue;
+		if (sdev->mpath_state == SCSI_MPATH_OPTIMAL) {
+			found = sdev;
+			goto out;
+		}
+		if (sdev->mpath_state == SCSI_MPATH_ACTIVE)
+			found = sdev;
+	}
+
+	if (!scsi_mpath_is_disabled(old_sdev) &&
+	    (old_sdev->mpath_state == SCSI_MPATH_OPTIMAL ||
+	    (!found && old_sdev->mpath_state == SCSI_MPATH_ACTIVE)))
+		return old_sdev;
+
+	if (!found)
+		return NULL;
+out:
+	rcu_assign_pointer(mpath_dev->current_path[node], found);
+
+	return found;
+}
+
+/*
+ * Search path based on iopolicy and numa node affinity
+ * and return the scsi_device for that path
+ */
+inline struct scsi_device *__scsi_find_path(struct Scsi_Host *shost, int node)
+{
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+	int found_distance = INT_MAX, fallback_distance = INT_MAX, distance;
+	struct scsi_device *sdev_found = NULL, *sdev_fallback = NULL, *sdev;
+
+	list_for_each_entry_rcu(sdev, &shost->mpath_sdev, mpath_entry) {
+		if (scsi_mpath_is_disabled(sdev))
+			continue;
+
+		if (sdev->mpath_numa_node != NUMA_NO_NODE &&
+		    (READ_ONCE(sdev->mpath_iopolicy) == SCSI_MPATH_IOPOLICY_NUMA))
+			distance = node_distance(node, sdev->mpath_numa_node);
+		else
+			distance = LOCAL_DISTANCE;
+
+		switch(sdev->mpath_state) {
+		case SCSI_MPATH_OPTIMAL:
+		    if (distance < found_distance) {
+			    found_distance = distance;
+			    sdev_found = sdev;
+		    }
+		    break;
+		case SCSI_MPATH_ACTIVE:
+		    if (distance < fallback_distance) {
+			    fallback_distance = distance;
+			    sdev_fallback = sdev;
+		    }
+		    break;
+		default:
+		    break;
+		}
+	}
+
+	if (!sdev_found)
+		sdev_found = sdev_fallback;
+
+	if (sdev_found)
+		rcu_assign_pointer(mpath_dev->current_path[node], sdev_found);
+
+	return sdev_found;
+}
+
+inline struct scsi_device *scsi_find_path(struct Scsi_Host *shost)
+{
+	int node = numa_node_id();
+	struct scsi_device *sdev;
+
+	sdev = srcu_dereference(shost->mpath_dev->current_path[node],
+	    &shost->mpath_dev->srcu);
+
+	if (unlikely(!sdev))
+		sdev = __scsi_find_path(shost, node);
+
+	if (READ_ONCE(sdev->mpath_iopolicy) == SCSI_MPATH_IOPOLICY_RR)
+		return scsi_mpath_round_robin_path(shost, node, sdev);
+
+	if (unlikely(!scsi_mpath_is_optimized(sdev)))
+		return __scsi_find_path(shost, node);
+
+	return sdev;
+}
+
+void scsi_mpath_requeue_work(struct work_struct *work)
+{
+	struct scsi_mpath *mpath_dev =
+	    container_of(work, struct scsi_mpath, mpath_requeue_work);
+	struct bio *bio, *next;
+
+	spin_lock_irq(&mpath_dev->mpath_requeue_lock);
+	next = bio_list_get(&mpath_dev->mpath_requeue_list);
+	spin_unlock(&mpath_dev->mpath_requeue_lock);
+
+	while ((bio = next) != NULL) {
+		next = bio->bi_next;
+		bio->bi_next = NULL;
+		submit_bio_noacct(bio);
+	}
+}
+
+void scsi_mpath_set_live(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+	int ret;
+
+	if (!sdev->mpath_disk)
+		return;
+
+	if (!test_and_set_bit(SCSI_MPATH_DISK_LIVE, &sdev->mpath_flags)) {
+		ret = device_add_disk(&sdev->sdev_dev, sdev->mpath_disk, NULL);
+		if (ret) {
+			clear_bit(SCSI_MPATH_DISK_LIVE, &sdev->mpath_flags);
+			return;
+		}
+	}
+
+	pr_info("Attached SCSI %s disk\n", sdev->mpath_disk->disk_name);
+
+	mutex_lock(&mpath_dev->mpath_lock);
+	if (scsi_mpath_is_optimized(sdev)) {
+		int node, srcu_idx;
+
+		srcu_idx = srcu_read_lock(&mpath_dev->srcu);
+		for_each_online_node(node)
+			__scsi_find_path(shost, node);
+		srcu_read_unlock(&mpath_dev->srcu, srcu_idx);
+	}
+	mutex_unlock(&mpath_dev->mpath_lock);
+
+	synchronize_srcu(&mpath_dev->srcu);
+	kblockd_schedule_work(&mpath_dev->mpath_requeue_work);
+}
+
+/**
+ * Callback function for activating multipath devices
+ */
+static void activate_mpath(void *data, int err)
+{
+	struct scsi_device *sdev = data;
+	struct scsi_mpath_dh_data *mpath_h = sdev->mpath_pg_data;
+	bool retry = false;
+
+	if (!mpath_h)
+		return;
+
+	switch (err) {
+	case SCSI_DH_OK:
+		break;
+	case SCSI_DH_NOSYS:
+		sdev_printk(KERN_ERR, sdev,
+			"Could not failover the device scsi_dh_%s, Error %d\n",
+			sdev->handler->name, err);
+		scsi_mpath_clear_current_path(sdev);
+		break;
+	case SCSI_DH_DEV_TEMP_BUSY:
+		sdev_printk(KERN_ERR, sdev,
+			"Device Handler Path Busy\n");
+		break;
+	case SCSI_DH_RETRY:
+		sdev_printk(KERN_ERR, sdev,
+			"Device Handler Path Retry \n");
+		retry = true;
+		fallthrough;
+	case SCSI_DH_IMM_RETRY:
+	case SCSI_DH_RES_TEMP_UNAVAIL:
+		sdev_printk(KERN_ERR, sdev,
+			"Device Handler Path Unavailable, Clear current path \n");
+		if ((mpath_h->state == SCSI_ACCESS_STATE_OFFLINE) ||
+		    (mpath_h->state == SCSI_ACCESS_STATE_UNAVAILABLE))
+			scsi_mpath_clear_current_path(sdev);
+		err = 0;
+		break;
+	case SCSI_DH_DEV_OFFLINED:
+	default:
+		sdev_printk(KERN_ERR, sdev, "Device Handler Path offlined \n");
+		scsi_mpath_clear_current_path(sdev);
+		break;
+	}
+
+	if (retry)
+		set_bit(SCSI_MPATH_DISK_IO_PENDING, &sdev->mpath_flags);
+
+        if (scsi_mpath_state_is_live(sdev->mpath_state))
+		scsi_mpath_set_live(sdev);
+}
+
+void scsi_activate_path(struct scsi_device *sdev)
+{
+	struct request_queue *q = sdev->mpath_disk->queue;
+	struct scsi_mpath_dh_data *mpath_dh = sdev->mpath_pg_data;
+
+	if (!mpath_dh)
+		return;
+
+        if (!(scsi_mpath_state_is_live(sdev->mpath_state))) {
+		sdev_printk(KERN_INFO, sdev, "Path state is not live \n");
+                return;
+	}
+
+	if (!blk_queue_dying(q))
+		scsi_dh_activate(q, activate_mpath, sdev);
+	else
+		activate_mpath(sdev, SCSI_DH_OK);
+}
+
+static void scsi_activate_mpath_work(struct work_struct *work)
+{
+        struct scsi_device *sdev = container_of(work,
+            struct scsi_device, activate_mpath);
+
+	if (!sdev)
+		return;
+
+	scsi_activate_path(sdev);
+}
+
+int scsi_mpath_add_disk(struct scsi_device *sdev)
+{
+	if (!sdev->mpath_pg_data) {
+		/* Re initialize ALUA */
+		sdev->handler->rescan(sdev);
+	} else {
+		sdev->mpath_state = SCSI_MPATH_OPTIMAL;
+		scsi_mpath_set_live(sdev);
+	}
+
+	return (test_bit(SCSI_MPATH_DISK_LIVE, &sdev->mpath_flags));
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_add_disk);
+
+int scsi_multipath_init(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath_dh_data *h;
+	struct scsi_mpath *mpath_dev;
+	int ret = -ENOMEM;
+
+	mpath_dev = kzalloc(sizeof(struct scsi_mpath), GFP_KERNEL);
+	if (!mpath_dev)
+		return ret;
+
+	h = kzalloc(sizeof(struct scsi_mpath_dh_data), GFP_KERNEL);
+	if (!h)
+		goto out_mpath_dev;
+
+	sdev->mpath_pg_data = h;
+
+	ret = init_srcu_struct(&mpath_dev->srcu);
+	if (ret) {
+		cleanup_srcu_struct(&mpath_dev->srcu);
+		goto out_handler;
+	}
+
+	shost->mpath_dev = mpath_dev;
+
+	mutex_init(&mpath_dev->mpath_lock);
+	bio_list_init(&mpath_dev->mpath_requeue_list);
+	spin_lock_init(&mpath_dev->mpath_requeue_lock);
+	INIT_WORK(&mpath_dev->mpath_requeue_work, scsi_mpath_requeue_work);
+	INIT_LIST_HEAD(&mpath_dev->mpath_list);
+	INIT_WORK(&sdev->activate_mpath, scsi_activate_mpath_work);
+	INIT_LIST_HEAD(&sdev->mpath_entry);
+	sdev->mpath_numa_node = NUMA_NO_NODE;
+	sdev->is_shared = 1;
+
+	return 0;
+
+out_handler:
+	kfree(h);
+out_mpath_dev:
+	if (mpath_dev)
+		kfree(mpath_dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scsi_multipath_init);
+
+static bool scsi_available_mpath(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	list_for_each_entry_rcu(sdev, &shost->mpath_sdev, mpath_entry) {
+		if (scsi_device_online(sdev))
+			return true;
+	}
+	return false;
+}
+
+/*  called when shost is being freed */
+void scsi_mpath_dev_release(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath *mpath_dev;
+
+	if (!shost->mpath_dev)
+		return;
+
+	mpath_dev = shost->mpath_dev;
+	cancel_work_sync(&mpath_dev->mpath_requeue_work);
+	cleanup_srcu_struct(&mpath_dev->srcu);
+
+	if (sdev->mpath_pg_data)
+                kfree(sdev->mpath_pg_data);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_dev_release);
+
+void scsi_put_mpath_sdev(struct scsi_device *sdev)
+{
+	scsi_device_put(sdev);
+}
+
+void scsi_mpath_revalidate_path(struct gendisk *mpath_disk, sector_t capacity)
+{
+	struct Scsi_Host *shost = mpath_disk->private_data;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+	struct scsi_device *sdev;
+	int srcu_idx;
+	int node;
+
+	if (!shost->mpath_dev)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_dev->srcu);
+	list_for_each_entry_rcu(sdev, &shost->mpath_sdev, mpath_entry) {
+		if (capacity != get_capacity(sdev->mpath_disk))
+			clear_bit(SCSI_MPATH_DISK_LIVE, &sdev->mpath_flags);
+	}
+	srcu_read_unlock(&mpath_dev->srcu, srcu_idx);
+
+	for_each_node(node)
+		rcu_assign_pointer(mpath_dev->current_path[node], NULL);
+	kblockd_schedule_work(&mpath_dev->mpath_requeue_work);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_revalidate_path);
+
+static int scsi_mpath_open(struct gendisk *disk, blk_mode_t mode)
+{
+	if (!scsi_get_device(disk->private_data))
+		return -ENXIO;
+
+	return 0;
+}
+
+static void scsi_mpath_release(struct gendisk *disk)
+{
+	struct Scsi_Host *shost = disk->private_data;
+	struct scsi_device *sdev;
+	int srcu_idx;
+
+	srcu_idx = srcu_read_lock(&shost->mpath_dev->srcu);
+	sdev = scsi_find_path(shost);
+	srcu_read_unlock(&shost->mpath_dev->srcu, srcu_idx);
+}
+
+int scsi_mpath_failover_disposition(struct scsi_cmnd *scmd)
+{
+	struct request *req = scsi_cmd_to_rq(scmd);
+
+	if (req->cmd_flags & REQ_SCSI_MPATH) {
+		if (scsi_is_mpath_error(scmd) ||
+		    blk_queue_dying(req->q)) {
+			return NEEDS_RETRY;
+		}
+	} else {
+		if (blk_queue_dying(req->q))
+			return SUCCESS;
+	}
+
+	return SUCCESS;
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_failover_disposition);
+
+static void scsi_multipath_submit_bio(struct bio *bio)
+{
+	struct Scsi_Host *shost = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+	struct scsi_device *sdev;
+	int srcu_idx;
+
+	/*
+	 * The scsi device might be going away and the bio might be
+	 * moved to a difference queue via blk_steal_bios(), so we
+	 * need to use bio_split pool from the original queue to
+	 * allocate the bvecs from.
+	 */
+	bio = bio_split_to_limits(bio);
+	if (!bio)
+		return;
+
+	srcu_idx = srcu_read_lock(&mpath_dev->srcu);
+	sdev = scsi_find_path(shost);
+	if (likely(sdev)) {
+		bio_set_dev(bio, bio->bi_bdev->bd_disk->part0);
+		bio->bi_opf |= REQ_SCSI_MPATH;
+		submit_bio_noacct(bio);
+	} else if (scsi_available_mpath(shost)) {
+		sdev_printk(KERN_NOTICE, NULL,
+		    "No Usable Path - Requeing I/O \n");
+
+		spin_lock_irq(&mpath_dev->mpath_requeue_lock);
+		bio_list_add(&mpath_dev->mpath_requeue_list, bio);
+		spin_unlock_irq(&mpath_dev->mpath_requeue_lock);
+	} else {
+		sdev_printk(KERN_NOTICE, NULL,
+		    "No available path = Failing I/O \n");
+
+		bio_io_error(bio);
+	}
+	srcu_read_unlock(&mpath_dev->srcu, srcu_idx);
+}
+
+static int scsi_mpath_get_unique_id(struct gendisk *disk, u8 id[16],
+    enum blk_unique_id type)
+{
+	struct Scsi_Host *shost = disk->private_data;
+	struct scsi_device *sdev;
+	int srcu_idx, ret = -EWOULDBLOCK;
+
+	srcu_idx = srcu_read_lock(&shost->mpath_dev->srcu);
+	sdev = scsi_find_path(shost);
+	if (sdev)
+		ret = scsi_mpath_unique_id(sdev, id, type);
+	srcu_read_unlock(&shost->mpath_dev->srcu, srcu_idx);
+
+	return ret;
+}
+
+const struct block_device_operations scsi_mpath_ops = {
+	.owner          = THIS_MODULE,
+	.submit_bio	= scsi_multipath_submit_bio,
+	.open		= scsi_mpath_open,
+	.release	= scsi_mpath_release,
+	.get_unique_id	= scsi_mpath_get_unique_id,
+};
+
+int scsi_mpath_unique_id(struct scsi_device *sdev, u8 id[16],
+		enum blk_unique_id type)
+{
+	struct scsi_mpath_dh_data *dh_data = sdev->mpath_pg_data;
+
+	if (type != BLK_UID_NAA)
+		return -EINVAL;
+
+	if (strncmp(dh_data->device_id_str, id, 16) == 0)
+		return dh_data->device_id_len;
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_unique_id);
+
+int scsi_mpath_unique_lun_id(struct scsi_device *sdev)
+{
+	struct scsi_mpath_dh_data *dh_data = sdev->mpath_pg_data;
+	char device_id_str[20];
+	int ret = -EINVAL;
+
+	ret = scsi_vpd_lun_id(sdev, device_id_str, dh_data->device_id_len);
+	if (ret < 0)
+		return ret;
+
+	if (strncmp(dh_data->device_id_str, device_id_str,
+	    dh_data->device_id_len) == 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+/*
+ * Allocate Disk for Multipath Device
+ */
+int scsi_mpath_alloc_disk(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	struct queue_limits lim;
+
+	/*
+	 * Don't allocate mpath disk if ALUA handler is not attached
+	 */
+	if (!sdev->handler || strncmp(sdev->handler->name, "alua", 4) != 0) {
+		sdev_printk(KERN_NOTICE, sdev,
+		    "No Handler or correct handler attached for multipath \n");
+		return 0;
+	}
+
+	/*
+	 * Add multipath disk only if scsi host supports multipath modparam
+	 */
+	if (!scsi_multipath) {
+		sdev_printk(KERN_NOTICE, sdev,
+		    "%s Handler attached but modparam scsi_multipath is set to false \n",
+		    sdev->handler->name);
+		return 0;
+	}
+
+	if (scsi_mpath_unique_lun_id(sdev) == 0) {
+		sdev_printk(KERN_NOTICE, sdev,
+		    "existing sdev with path, return\n");
+		return 0;
+	}
+
+	blk_set_stacking_limits(&lim);
+
+	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT | BLK_FEAT_POLL;
+	lim.max_zone_append_sectors = 0;
+	lim.dma_alignment = 3;
+
+	sdev->mpath_disk = blk_alloc_disk(&lim, sdev->mpath_numa_node);
+	if (IS_ERR(sdev->mpath_disk))
+		return PTR_ERR(sdev->mpath_disk);
+
+	sdev->mpath_disk->private_data = shost;
+	sdev->mpath_disk->fops = &scsi_mpath_ops;
+
+	list_add_tail(&shost->mpath_sdev, &sdev->mpath_entry);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_alloc_disk);
+
+void scsi_mpath_start_request(struct request *req)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+
+	if (!blk_queue_io_stat(sdev->mpath_disk->queue) ||
+	    blk_rq_is_passthrough(req))
+		return;
+
+	req->rq_flags |= SCSI_MPATH_IO_STATS;
+	mpath_dev->mpath_start_time = bdev_start_io_acct(sdev->mpath_disk->part0,
+	    req_op(req), jiffies);
+}
+
+void scsi_mpath_end_request(struct request *req)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+	struct scsi_device *sdev = cmd->device;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+
+	if (!(req->rq_flags & SCSI_MPATH_IO_STATS))
+		return;
+
+	bdev_end_io_acct(sdev->mpath_disk->part0, req_op(req),
+	    blk_rq_bytes(req) >> SECTOR_SHIFT,
+	    mpath_dev->mpath_start_time);
+}
+
+void scsi_mpath_kick_requeue_lists(struct Scsi_Host *shost)
+{
+	struct scsi_mpath *mpath_dev = shost->mpath_dev;
+	struct scsi_device *sdev;
+	int srcu_idx;
+
+	srcu_idx = srcu_read_lock(&mpath_dev->srcu);
+	list_for_each_entry_rcu(sdev, &shost->mpath_sdev, mpath_entry) {
+		if (sdev->is_shared)
+			continue;
+
+		kblockd_schedule_work(&mpath_dev->mpath_requeue_work);
+		if (sdev->sdev_state == SDEV_RUNNING)
+			disk_uevent(sdev->mpath_disk, KOBJ_CHANGE);
+	}
+	srcu_read_unlock(&mpath_dev->srcu, srcu_idx);
+}
+
+void scsi_mpath_shutdown_disk(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!sdev->mpath_disk)
+		return;
+
+	if (test_and_clear_bit(SCSI_MPATH_DISK_LIVE, &sdev->mpath_flags)) {
+		synchronize_srcu(&shost->mpath_dev->srcu);
+		kblockd_schedule_work(&shost->mpath_dev->mpath_requeue_work);
+		del_gendisk(sdev->mpath_disk);
+	}
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_shutdown_disk);
+
+void scsi_mpath_remove_disk(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+
+	if (!sdev->mpath_disk)
+		return;
+
+	if (!sdev->is_shared)
+		return;
+
+	/* Make sure All pending bio's are cleaned up */
+	kblockd_schedule_work(&shost->mpath_dev->mpath_requeue_work);
+	flush_work(&shost->mpath_dev->mpath_requeue_work);
+	put_disk(sdev->mpath_disk);
+}
+EXPORT_SYMBOL_GPL(scsi_mpath_remove_disk);
+
+int scsi_mpath_update_state(struct scsi_device *sdev)
+{
+        struct scsi_mpath_dh_data *mpath_h;
+
+        mpath_h = sdev->mpath_pg_data;
+        if (!mpath_h)
+		return SCSI_MPATH_UNAVAILABLE;
+
+	switch(mpath_h->state) {
+		case SCSI_ACCESS_STATE_OPTIMAL:
+			sdev->mpath_state = SCSI_MPATH_OPTIMAL;
+			break;
+		case SCSI_ACCESS_STATE_ACTIVE:
+			sdev->mpath_state = SCSI_MPATH_ACTIVE;
+			break;
+		case SCSI_ACCESS_STATE_STANDBY:
+			sdev->mpath_state = SCSI_MPATH_STANDBY;
+			break;
+		case SCSI_ACCESS_STATE_UNAVAILABLE:
+			sdev->mpath_state = SCSI_MPATH_UNAVAILABLE;
+			break;
+		case SCSI_ACCESS_STATE_TRANSITIONING:
+			sdev->mpath_state = SCSI_MPATH_TRANSITIONING;
+			break;
+		case SCSI_ACCESS_STATE_OFFLINE:
+		default:
+                    sdev->mpath_state = SCSI_MPATH_OFFLINE;
+		    break;
+	}
+
+	return sdev->mpath_state;
+}
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9c540f5468eb..b46e06a01179 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -9,6 +9,8 @@
 #include <scsi/scsi.h>
 #include <linux/atomic.h>
 #include <linux/sbitmap.h>
+#include <scsi/scsi_multipath.h>
+#include <scsi/scsi_host.h>
 
 struct bsg_device;
 struct device;
@@ -100,6 +102,11 @@ struct scsi_vpd {
 	unsigned char	data[];
 };
 
+/*
+ * Mark bio as coming from scsi multipath node
+ */
+#define REQ_SCSI_MPATH		REQ_DRV
+
 struct scsi_device {
 	struct Scsi_Host *host;
 	struct request_queue *request_queue;
@@ -120,6 +127,7 @@ struct scsi_device {
 	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
 	unsigned long last_queue_full_time;	/* last queue full time */
 	unsigned long queue_ramp_up_period;	/* ramp up period in jiffies */
+
 #define SCSI_DEFAULT_RAMP_UP_PERIOD	(120 * HZ)
 
 	unsigned long last_queue_ramp_up;	/* last queue ramp up time */
@@ -265,6 +273,25 @@ struct scsi_device {
 	struct device		sdev_gendev,
 				sdev_dev;
 
+#ifdef	CONFIG_SCSI_MULTIPATH
+	int				is_shared; 	/* Set Multipath flag  */
+	int				mpath_first_path; /* Indicate if this was first path */
+	struct gendisk          	*mpath_disk;	/* Multipath disk */
+	int				mpath_numa_node; /* NUMA node for Path  */
+	enum scsi_mpath_access_state	mpath_state;	/* Multipath State */
+	enum scsi_mpath_iopolicy	mpath_iopolicy;	/* IO Policy */
+	struct list_head		mpath_entry;	/* list of all mpath_sdevs */
+	struct scsi_mpath_dh_data	*mpath_pg_data; /* Place holder for Port group data */
+	struct work_struct		activate_mpath; /* Activate path work */
+	atomic_t			nr_mpath;	/* Number of Active mpath */
+
+#define SCSI_MPATH_DISK_LIVE            0
+#define SCSI_MPATH_DISK_IO_PENDING      1
+#define SCSI_MPATH_IO_STATS             2
+
+	unsigned long           mpath_flags;		/* flag for multipath devices*/
+#endif
+
 	struct work_struct	requeue_work;
 
 	struct scsi_device_handler *handler;
@@ -294,6 +321,43 @@ struct scsi_device {
 #define sdev_dbg(sdev, fmt, a...) \
 	dev_dbg(&(sdev)->sdev_gendev, fmt, ##a)
 
+#ifdef CONFIG_SCSI_MULTIPATH
+extern bool scsi_multipath;
+extern const struct block_device_operations scsi_mpath_ops;
+
+static inline bool scsi_sdev_use_alua(struct scsi_device *sdev)
+{
+	return sdev->handler_data != NULL;
+}
+
+static inline bool scsi_disk_is_multipath(struct gendisk *disk)
+{
+	return disk->fops == &scsi_mpath_ops;
+}
+
+static inline bool scsi_mpath_enabled(struct scsi_device *sdev)
+{
+	return IS_ENABLED(CONFIG_SCSI_MULTIPATH);
+}
+static inline bool scsi_is_sdev_multipath(struct scsi_device *sdev)
+{
+	return IS_ENABLED(CONFIG_SCSI_MULTIPATH) && sdev->mpath_disk;
+}
+#else
+#define scsi_multipath	false;
+static inline bool scsi_disk_is_multipath(struct gendisk *disk)
+{
+	return false;
+}
+static inline bool scsi_mpath_enabled(struct scsi_device *sdev)
+{
+	return false;
+}
+static inline bool scsi_is_sdev_multipath(struct scsi_device *sdev)
+{
+	return false;
+}
+#endif
 /*
  * like scmd_printk, but the device name is passed in
  * as a string pointer
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2b4ab0369ffb..d20def053254 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -571,6 +571,12 @@ struct Scsi_Host {
 	/* Area to keep a shared tag map */
 	struct blk_mq_tag_set	tag_set;
 
+#ifdef	CONFIG_SCSI_MULTIPATH
+	struct scsi_mpath	*mpath_dev;
+	struct list_head	mpath_sdev;
+	int			mpath_alua_grpid; /* Grounp ID for ALUA devices */
+#endif
+
 	atomic_t host_blocked;
 
 	unsigned int host_failed;	   /* commands that failed.
@@ -761,6 +767,7 @@ static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 		shost->tmf_in_progress;
 }
 
+
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
 extern void scsi_flush_work(struct Scsi_Host *);
 
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
new file mode 100644
index 000000000000..b441241c8316
--- /dev/null
+++ b/include/scsi/scsi_multipath.h
@@ -0,0 +1,86 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _SCSI_SCSI_MULTIPATH_H
+#define _SCSI_SCSI_MULTIPATH_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/rcupdate.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+#include <linux/blk-mq.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+struct scsi_device;
+
+enum scsi_mpath_iopolicy {
+	SCSI_MPATH_IOPOLICY_NUMA,
+	SCSI_MPATH_IOPOLICY_RR,
+};
+
+enum scsi_mpath_access_state {
+	SCSI_MPATH_OPTIMAL	= SCSI_ACCESS_STATE_OPTIMAL,
+	SCSI_MPATH_ACTIVE	= SCSI_ACCESS_STATE_ACTIVE,
+	SCSI_MPATH_STANDBY	= SCSI_ACCESS_STATE_STANDBY,
+	SCSI_MPATH_UNAVAILABLE	= SCSI_ACCESS_STATE_UNAVAILABLE,
+	SCSI_MPATH_LBA		= SCSI_ACCESS_STATE_LBA,
+	SCSI_MPATH_OFFLINE	= SCSI_ACCESS_STATE_OFFLINE,
+	SCSI_MPATH_TRANSITIONING = SCSI_ACCESS_STATE_TRANSITIONING,
+	SCSI_MPATH_INVALID	= 0xFF
+};
+
+struct scsi_mpath_dh_data {
+	const char	*hndlr_name; /* device Handler name */
+	int	group_id;		/* Group ID reported from RTPG cmd */
+	int	tpgs;			/* Target Port Groups reported from RTPG cmd */
+	int	state;			/* Target Port Group State */
+	char	*device_id_str;		/* Multipath Device String */
+	int	device_id_len;		/* Device ID Length */
+	int	valid_states;		/* states from RTPG cmd */
+	int	prefrence;		/* Path prefrence for Port Group from RTPG cmd */
+	int	is_active;		/* Current Sdev is active */
+};
+
+struct scsi_mpath {
+	struct srcu_struct 	srcu;
+	struct Scsi_Host	*shost;	/*Scsi_Host where this mpath belong */
+	struct list_head        mpath_list;  /* list of multipath scsi_device   */
+	struct	bio_list	mpath_requeue_list; /* list for requeing bio */
+	spinlock_t		mpath_requeue_lock;
+	struct work_struct	mpath_requeue_work; /* work struct for requeue */
+	struct mutex            mpath_lock;
+	unsigned long		mpath_start_time;
+	struct delayed_work	activate_mpath; /* Path Activation work */
+	struct scsi_device __rcu *current_path[]; /* scsi_device of current path */
+};
+
+extern void scsi_mpath_default_iopolicy(struct scsi_device *);
+extern void scsi_mpath_unfreeze(struct Scsi_Host *);
+extern void scsi_mpath_wait_freeze(struct Scsi_Host *);
+extern void scsi_mpath_start_freeze(struct Scsi_Host *);
+extern void scsi_mpath_failover_req(struct request *);
+extern void scsi_mpath_start_request(struct request *);
+extern void scsi_mpath_end_request(struct request *);
+extern void scsi_kick_requeue_lists(struct Scsi_Host *);
+extern bool scsi_mpath_clear_current_path(struct scsi_device *);
+int scsi_multipath_init(struct scsi_device *);
+extern int scsi_mpath_failover_disposition(struct scsi_cmnd *);
+int scsi_mpath_alloc_disk(struct scsi_device *);
+extern void scsi_mpath_remove_disk(struct scsi_device *);
+extern void scsi_mpath_shutdown_disk(struct scsi_device *);
+void scsi_put_mpath_sdev(struct scsi_device *);
+void scsi_mpath_requeue_work(struct work_struct *);
+extern void scsi_mpath_dev_release(struct scsi_device *);
+void scsi_mpath_kick_requeue_lists(struct Scsi_Host *);
+int scsi_mpath_update_state(struct scsi_device *);
+extern int scsi_mpath_add_disk(struct scsi_device *);
+void scsi_mpath_set_live(struct scsi_device *);
+void scsi_activate_path(struct scsi_device *);
+void scsi_multipath_iopolicy_update(struct scsi_device *, int);
+void scsi_mpath_clear_paths(struct Scsi_Host *);
+int scsi_mpath_unique_lun_id(struct scsi_device *);
+
+extern void scsi_mpath_revalidate_path(struct gendisk *, sector_t);
+extern int scsi_mpath_unique_id(struct scsi_device *sdev, u8 id[16], enum blk_unique_id type);
+#endif /* _SCSI_SCSI_MULTIPATH_H */
-- 
2.41.0.rc2

