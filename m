From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH for v4.3-rc] scsi_dh: fix use-after-free when removing scsi
 device
Date: Tue, 6 Oct 2015 04:32:57 +0000
Message-ID: <20151006043256.GA8193@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:54324 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbJFEe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Oct 2015 00:34:27 -0400
Content-Language: ja-JP
Content-ID: <A8EB89EF7E82714199AFE2E1B55476C6@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

The commit 1bab0de0274f ("dm-mpath, scsi_dh: don't let dm detach device
handlers") removed reference counting of attached scsi device handler.
As a result, handler data is freed immediately via scsi_dh->detach()
in the context of scsi_remove_device() where activation request can be
still in flight.

This patch moves scsi_dh_handler_detach() to sdev releasing function,
scsi_device_dev_release_usercontext(), at that point the device
is already in quiesced state.

Fixes: 1bab0de0274f ("dm-mpath, scsi_dh: don't let dm detach device handlers")
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Acked-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_dh.c    | 6 +++++-
 drivers/scsi/scsi_priv.h  | 2 ++
 drivers/scsi/scsi_sysfs.c | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index edb044a..19bf9db 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -232,10 +232,14 @@ int scsi_dh_add_device(struct scsi_device *sdev)
 	return err;
 }
 
-void scsi_dh_remove_device(struct scsi_device *sdev)
+void scsi_dh_release_device(struct scsi_device *sdev)
 {
 	if (sdev->handler)
 		scsi_dh_handler_detach(sdev);
+}
+
+void scsi_dh_remove_device(struct scsi_device *sdev)
+{
 	device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
 }
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 644bb73..4d01cdb 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -173,9 +173,11 @@ extern struct async_domain scsi_sd_probe_domain;
 /* scsi_dh.c */
 #ifdef CONFIG_SCSI_DH
 int scsi_dh_add_device(struct scsi_device *sdev);
+void scsi_dh_release_device(struct scsi_device *sdev);
 void scsi_dh_remove_device(struct scsi_device *sdev);
 #else
 static inline int scsi_dh_add_device(struct scsi_device *sdev) { return 0; }
+static inline void scsi_dh_release_device(struct scsi_device *sdev) { }
 static inline void scsi_dh_remove_device(struct scsi_device *sdev) { }
 #endif
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389..dff8faf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -399,6 +399,8 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	scsi_dh_release_device(sdev);
+
 	parent = sdev->sdev_gendev.parent;
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-- 
2.1.0
