Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CD314B09C;
	Tue, 23 Jul 2024 11:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721734415; cv=none; b=q2IIswdfKmOwVm7S6fKtK0Tv9K/2NKDaancn779S4TN/YDhD1iBuoRyxnZ5YeEdO0qz+m2FBFeWoka0KecYoyQyre0NCVBQtzxr7W/+1nxTNxMNJAZ4q8lQcxI0wMyWiQAVjToOIjCzydIcRC0iQAgk0JoRyJa9AEpOmfVXeM5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721734415; c=relaxed/simple;
	bh=B324Mavde/MWETm7k5fGhfNE4infyE63v4qqGCca8ww=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GP4Pq32m7bGbG2f6LJQVnKXg0+LdMQrOR61JvD0uLoQM+wg6Haf0gbJ5Zppi2JKMWWlL9wePG0KHzRAVvq9NCcfHJdVJjw9bKAQlZ2r0qLDPasIYzg2yEXO3HnuL+4D99xmzb4F9gD0m0714WmRl7bdRLX0EhieIMQjNbSgflgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=Xli3FUeZ; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="Xli3FUeZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1721734413; x=1753270413;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QYhEeIrrKUY0Mzt0+ocqIcydssRTDPW7HoluJgqubps=;
  b=Xli3FUeZQx6vVxh3gKEhrQ0PJhoxVdAut9ln6wdRvmGUnogOT50uyB07
   iYwKmPG08Iao3Hk77fInGJZHPllxAEjDCXKXgdbzrBC4epcd2URm9s3Vt
   sTtFoUC1MY2al66p/5B9e/YKhqLd2GVLhHudEv7cCOTDk6BP0d/OPBANg
   o=;
X-IronPort-AV: E=Sophos;i="6.09,230,1716249600"; 
   d="scan'208";a="669553889"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 11:33:30 +0000
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:10113]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.5.11:2525] with esmtp (Farcaster)
 id a00486dc-29f4-4c2c-be67-a995faecfec5; Tue, 23 Jul 2024 11:33:28 +0000 (UTC)
X-Farcaster-Flow-ID: a00486dc-29f4-4c2c-be67-a995faecfec5
Received: from EX19D008EUA001.ant.amazon.com (10.252.50.34) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 23 Jul 2024 11:33:28 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D008EUA001.ant.amazon.com (10.252.50.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 23 Jul 2024 11:33:27 +0000
Received: from dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (10.15.57.183)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server id
 15.2.1258.34 via Frontend Transport; Tue, 23 Jul 2024 11:33:27 +0000
Received: by dev-dsk-mheyne-1b-c1362c4d.eu-west-1.amazon.com (Postfix, from userid 5466572)
	id 5E6AD2FE7; Tue, 23 Jul 2024 11:33:27 +0000 (UTC)
From: Maximilian Heyne <mheyne@amazon.de>
To: 
CC: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Mike Christie <michael.christie@oracle.com>,
	Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>, "Li
 Zhijian" <lizhijian@fujitsu.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>, Maximilian Heyne <mheyne@amazon.de>,
	<stable@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 5.15] scsi: core: Fix a use-after-free
Date: Tue, 23 Jul 2024 11:33:14 +0000
Message-ID: <20240723113314.121754-1-mheyne@amazon.de>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 8fe4ce5836e932f5766317cb651c1ff2a4cd0506 ]

There are two .exit_cmd_priv implementations. Both implementations use
resources associated with the SCSI host. Make sure that these resources are
still available when .exit_cmd_priv is called by waiting inside
scsi_remove_host() until the tag set has been freed.

This commit fixes the following use-after-free:

==================================================================
BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
Read of size 8 at addr ffff888100337000 by task multipathd/16727
Call Trace:
 <TASK>
 dump_stack_lvl+0x34/0x44
 print_report.cold+0x5e/0x5db
 kasan_report+0xab/0x120
 srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
 scsi_mq_exit_request+0x4d/0x70
 blk_mq_free_rqs+0x143/0x410
 __blk_mq_free_map_and_rqs+0x6e/0x100
 blk_mq_free_tag_set+0x2b/0x160
 scsi_host_dev_release+0xf3/0x1a0
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 scsi_device_dev_release_usercontext+0x4c1/0x4e0
 execute_in_process_context+0x23/0x90
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 scsi_disk_release+0x3f/0x50
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 disk_release+0x17f/0x1b0
 device_release+0x54/0xe0
 kobject_put+0xa5/0x120
 dm_put_table_device+0xa3/0x160 [dm_mod]
 dm_put_device+0xd0/0x140 [dm_mod]
 free_priority_group+0xd8/0x110 [dm_multipath]
 free_multipath+0x94/0xe0 [dm_multipath]
 dm_table_destroy+0xa2/0x1e0 [dm_mod]
 __dm_destroy+0x196/0x350 [dm_mod]
 dev_remove+0x10c/0x160 [dm_mod]
 ctl_ioctl+0x2c2/0x590 [dm_mod]
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0xb4/0xf0
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0xb4/0xf0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Link: https://lore.kernel.org/r/20220826002635.919423-1-bvanassche@acm.org
Fixes: 65ca846a5314 ("scsi: core: Introduce {init,exit}_cmd_priv()")
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Li Zhijian <lizhijian@fujitsu.com>
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Tested-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
[mheyne: fixed contextual conflicts:
  - drivers/scsi/hosts.c: due to missing commit 973dac8a8a14 ("scsi: core: Refine how we set tag_set NUMA node")
  - drivers/scsi/scsi_sysfs.c: due to missing commit 6f8191fdf41d ("block: simplify disk shutdown")]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Cc: stable@vger.kernel.org # v5.15
---
 drivers/scsi/hosts.c      | 16 +++++++++++++---
 drivers/scsi/scsi_lib.c   |  6 +++++-
 drivers/scsi/scsi_priv.h  |  2 +-
 drivers/scsi/scsi_scan.c  |  1 +
 drivers/scsi/scsi_sysfs.c |  1 +
 include/scsi/scsi_host.h  |  2 ++
 6 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 4caee4e32461..eb3e8b41adb1 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -182,6 +182,15 @@ void scsi_remove_host(struct Scsi_Host *shost)
 	scsi_proc_host_rm(shost);
 	scsi_proc_hostdir_rm(shost->hostt);
 
+	/*
+	 * New SCSI devices cannot be attached anymore because of the SCSI host
+	 * state so drop the tag set refcnt. Wait until the tag set refcnt drops
+	 * to zero because .exit_cmd_priv implementations may need the host
+	 * pointer.
+	 */
+	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
+	wait_for_completion(&shost->tagset_freed);
+
 	spin_lock_irqsave(shost->host_lock, flags);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
@@ -240,6 +249,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	shost->dma_dev = dma_dev;
 
+	kref_init(&shost->tagset_refcnt);
+	init_completion(&shost->tagset_freed);
+
 	/*
 	 * Increase usage count temporarily here so that calling
 	 * scsi_autopm_put_host() will trigger runtime idle if there is
@@ -312,6 +324,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 	pm_runtime_disable(&shost->shost_gendev);
 	pm_runtime_set_suspended(&shost->shost_gendev);
 	pm_runtime_put_noidle(&shost->shost_gendev);
+	kref_put(&shost->tagset_refcnt, scsi_mq_free_tags);
  fail:
 	return error;
 }
@@ -344,9 +357,6 @@ static void scsi_host_dev_release(struct device *dev)
 		kfree(dev_name(&shost->shost_dev));
 	}
 
-	if (shost->tag_set.tags)
-		scsi_mq_destroy_tags(shost);
-
 	kfree(shost->shost_data);
 
 	ida_simple_remove(&host_index_ida, shost->host_no);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 0389bf281f4b..2d3779032163 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1949,9 +1949,13 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 	return blk_mq_alloc_tag_set(tag_set);
 }
 
-void scsi_mq_destroy_tags(struct Scsi_Host *shost)
+void scsi_mq_free_tags(struct kref *kref)
 {
+	struct Scsi_Host *shost = container_of(kref, typeof(*shost),
+					       tagset_refcnt);
+
 	blk_mq_free_tag_set(&shost->tag_set);
+	complete(&shost->tagset_freed);
 }
 
 /**
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b650407690a8..b531dec3d420 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -95,7 +95,7 @@ extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern void scsi_requeue_run_queue(struct work_struct *work);
 extern void scsi_start_queue(struct scsi_device *sdev);
 extern int scsi_mq_setup_tags(struct Scsi_Host *shost);
-extern void scsi_mq_destroy_tags(struct Scsi_Host *shost);
+extern void scsi_mq_free_tags(struct kref *kref);
 extern void scsi_exit_queue(void);
 extern void scsi_evt_thread(struct work_struct *work);
 
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 86c10edbb5f1..9c155d576814 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -324,6 +324,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 		kfree(sdev);
 		goto out;
 	}
+	kref_get(&sdev->host->tagset_refcnt);
 	sdev->request_queue = q;
 	q->queuedata = sdev;
 	__scsi_init_queue(sdev->host, q);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 774864b54b97..4c72116c8693 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1490,6 +1490,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	mutex_unlock(&sdev->state_mutex);
 
 	blk_cleanup_queue(sdev->request_queue);
+	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
 
 	if (sdev->host->hostt->slave_destroy)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f50861e4e88a..3ed93982dbf0 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -565,6 +565,8 @@ struct Scsi_Host {
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;
 
+	struct kref		tagset_refcnt;
+	struct completion	tagset_freed;
 	/* Area to keep a shared tag map */
 	struct blk_mq_tag_set	tag_set;
 
-- 
2.40.1




Amazon Web Services Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

