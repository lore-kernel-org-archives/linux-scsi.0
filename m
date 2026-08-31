Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 624333ED5C7
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 12:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788177678; cv=none; b=L/96yjXYmphAriIqinqWnuglkpaXhLFkpW4HT3Fo751+LAjiCTt1NKSuPI42msKAmHIx1OV8bqG7/sGl35vTmiNTMw8saXyvWHz5y2bHeQ44bDEYiRK59wBNLg0poj78vq6sj6F8x0gWThWTMvkzDBGOfxZcXhr6bcZzKQnwdX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788177678; c=relaxed/simple;
	bh=DBju7k9kMQC8qqgXpXH+kqclTXN534pl+MbHO3aOxYM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=BH6bU4RBuSWLObs0dfqxqcixxXnLXbNxXfmQsaLU/fnYdQ+N2m/QytDYCoGowPtTVr4gk978iq2mVNwyRzzTgJEcvk/CsxmuT44MLj5H8WHTP2Imo1CbWQOAt5JpqG5FcJm2zMZfqAaQFJOFFmbXw3oW7bymq6pbikmfi9GuHGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OeMeBydu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OeMeBydu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788177675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5396ZjweTt4EBjj5itKQciktsGGRHiml8CvDA7sBNqA=;
	b=OeMeByduCizKcs/iLcDzMaltE4oHSUoucGuUlhLZRUTRHqe573ifcIFx1+aza0MHTiHbe8
	tayj07uKIb7zFL7wAdf8tXcFmH663Sen0bOh7cMDN9bp8biJTOOXdTmk5Ptno/V+MXOgaa
	l6uGLs0iGIPFL005n6+57mvHyZLTaQQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-56-RQP_YJhUO3CNhpinVwRPdw-1; Mon,
 31 Aug 2026 08:01:13 -0400
X-MC-Unique: RQP_YJhUO3CNhpinVwRPdw-1
X-Mimecast-MFC-AGG-ID: RQP_YJhUO3CNhpinVwRPdw_1788177669
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 567FC187079B;
	Mon, 31 Aug 2026 12:01:09 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68DE040E;
	Mon, 31 Aug 2026 12:01:08 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: loberman@redhat.com,
	linux-scsi@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	martin.petersen@oracle.com,
	chandrakanth.patil@broadcom.com
Subject: [PATCH] scsi: mpi3mr: fix use-after-free on tgt_dev->starget during target device refresh/update
Date: Mon, 31 Aug 2026 07:59:17 -0400
Message-ID: <20260831120047.14690-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

mpi3mr_refresh_tgtdevs() and mpi3mr_devinfochg_evt_bh() read
tgt_dev->starget and immediately pass it to starget_for_each_device()
without holding mrioc->tgtdev_lock. Every writer of this field --
mpi3mr_target_alloc(), mpi3mr_target_destroy(), mpi3mr_slave_destroy()
and mpi3mr_sdev_init() -- correctly serializes access under
tgtdev_lock, but these two read sites do not, which leaves a
check-then-use window against the SCSI core's target teardown path
(scsi_remove_target(), invoked e.g. via a concurrent host reset,
sysfs "delete", or SCSI EH device offlining running independently of
the fwevt workqueue).

Sequence observed on production hardware, triggered on the
mpi3mr0_fwevt_wrkr workqueue during a SAS topology change shortly
after a controller reset:

  BUG: kernel NULL pointer dereference, address: 0000000000000058
  RIP: scsi_is_host_device+0x7/0x20
  Call Trace:
   starget_for_each_device+0x34/0x100
   mpi3mr_refresh_tgtdevs+0x152/0x1d0 [mpi3mr]
   mpi3mr_fwevt_bh+0x514/0x6c0 [mpi3mr]
   mpi3mr_fwevt_worker+0x1a/0x50 [mpi3mr]
   process_one_work+0x194/0x380
   worker_thread+0x2fe/0x410

mpi3mr_refresh_tgtdevs() reads tgt_dev->starget as non-NULL, but by
the time starget_for_each_device() dereferences it, a concurrent
mpi3mr_target_destroy() has already cleared tgt_dev->starget under
tgtdev_lock and the SCSI/device core has freed the underlying
scsi_target (and its embedded struct device). The stale pointer is
then walked by dev_to_shost() -> scsi_is_host_device(), producing the
NULL/garbage dereference above.

Fix this by taking mrioc->tgtdev_lock around every read of
tgt_dev->starget, matching the existing writer-side discipline. Since
starget_for_each_device() and mpi3mr_update_sdev() can end up doing
non-atomic work (e.g. queue_limits_commit_update()), the lock cannot
be held across the whole call, so instead pin the target's device
with get_device() while holding the lock, drop the lock, then run
starget_for_each_device() against the pinned reference and
put_device() afterwards. This closes the TOCTOU window instead of
merely narrowing it.

The same unlocked read-and-dereference pattern also exists earlier in
mpi3mr_refresh_tgtdevs()'s first removal-scan loop
(tgt_dev->starget->hostdata); fix it the same way by holding
tgtdev_lock across that check, which is cheap since it only touches
plain struct fields.

Assisted-by: Claude:Sonnet5 [Claude Code]
Signed-off-by: Laurence Oberman <loberman@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 45 +++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 402d1f35d214..922b28c3fe12 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1094,10 +1094,13 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 {
 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
 	struct mpi3mr_stgt_priv_data *tgt_priv;
+	struct scsi_target *starget;
+	unsigned long flags;
 
 	dprint_reset(mrioc, "refresh target devices: check for removals\n");
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
 	    list) {
+		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 		if (((tgtdev->dev_handle == MPI3MR_INVALID_DEV_HANDLE) ||
 		     tgtdev->is_hidden) &&
 		     tgtdev->host_exposed && tgtdev->starget &&
@@ -1106,6 +1109,7 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 			tgt_priv->dev_removed = 1;
 			atomic_set(&tgt_priv->block_io, 0);
 		}
+		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 	}
 
 	list_for_each_entry_safe(tgtdev, tgtdev_next, &mrioc->tgtdev_list,
@@ -1127,15 +1131,25 @@ static void mpi3mr_refresh_tgtdevs(struct mpi3mr_ioc *mrioc)
 	tgtdev = NULL;
 	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
 		if ((tgtdev->dev_handle != MPI3MR_INVALID_DEV_HANDLE) &&
-		    !tgtdev->is_hidden) {
-			if (!tgtdev->host_exposed)
+				!tgtdev->is_hidden) {
+			if (!tgtdev->host_exposed) {
 				mpi3mr_report_tgtdev_to_host(mrioc,
-							     tgtdev->perst_id);
-			else if (tgtdev->starget)
-				starget_for_each_device(tgtdev->starget,
-							(void *)tgtdev, mpi3mr_update_sdev);
-	}
+				     tgtdev->perst_id);
+				continue;
+			}
+			spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+			starget = tgtdev->starget;
+			if (starget)
+				get_device(&starget->dev);
+			spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+			if (starget) {
+				starget_for_each_device(starget, (void *)tgtdev,
+							mpi3mr_update_sdev);
+				put_device(&starget->dev);
+			}
+		}
 	}
+	dprint_reset(mrioc, "refresh target devices: done\n");
 }
 
 /**
@@ -1515,6 +1529,8 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 	struct mpi3_device_page0 *dev_pg0)
 {
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
+	struct scsi_target *starget;
+	unsigned long flags;
 	u16 dev_handle = 0, perst_id = 0;
 
 	perst_id = le16_to_cpu(dev_pg0->persistent_id);
@@ -1535,9 +1551,18 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr_ioc *mrioc,
 		mpi3mr_report_tgtdev_to_host(mrioc, perst_id);
 	if (tgtdev->is_hidden && tgtdev->host_exposed)
 		mpi3mr_remove_tgtdev_from_host(mrioc, tgtdev);
-	if (!tgtdev->is_hidden && tgtdev->host_exposed && tgtdev->starget)
-		starget_for_each_device(tgtdev->starget, (void *)tgtdev,
-		    mpi3mr_update_sdev);
+	if (!tgtdev->is_hidden && tgtdev->host_exposed) {
+		spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
+		starget = tgtdev->starget;
+		if (starget)
+			get_device(&starget->dev);
+		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+		if (starget) {
+			starget_for_each_device(starget, (void *)tgtdev,
+						mpi3mr_update_sdev);
+			put_device(&starget->dev);
+		}
+	}
 out:
 	if (tgtdev)
 		mpi3mr_tgtdev_put(tgtdev);
-- 
2.55.0

