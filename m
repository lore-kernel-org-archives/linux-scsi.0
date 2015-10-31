From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.3-rc4
Date: Sat, 31 Oct 2015 12:39:41 +0900
Message-ID: <1446262781.25009.59.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58350 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbbJaDjr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 23:39:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is three essential bug fixes for various SCSI parts.  The only
affected users are SCSI multi-path via device handler (basically all th=
e
enterprise) and mvsas users.  The dh bugs are an async entanglement in
boot resulting in a serious WARN_ON trip and a use after free on remove
leading to a crash with strict memory accounting.  The mvsas bug
manifests as a null deref oops but only on abort sequences; however,
these can commonly occur with SATA attached devices, hence the fix.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      scsi_dh: don't try to load a device handler during async probing

D=C4=81vis Mos=C4=81ns (1):
      mvsas: Fix NULL pointer dereference in mvs_slot_task_free

Junichi Nomura (1):
      scsi_dh: fix use-after-free when removing scsi device

And the diffstat:

 drivers/scsi/mvsas/mv_sas.c | 2 ++
 drivers/scsi/scsi_dh.c      | 8 ++++++--
 drivers/scsi/scsi_priv.h    | 2 ++
 drivers/scsi/scsi_sysfs.c   | 2 ++
 4 files changed, 12 insertions(+), 2 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 454536c..9c78074 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -887,6 +887,8 @@ static void mvs_slot_free(struct mvs_info *mvi, u32=
 rx_desc)
 static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *=
task,
 			  struct mvs_slot_info *slot, u32 slot_idx)
 {
+	if (!slot)
+		return;
 	if (!slot->task)
 		return;
 	if (!sas_protocol_ata(task->task_proto))
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 0a2168e..e7649ed 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -226,16 +226,20 @@ int scsi_dh_add_device(struct scsi_device *sdev)
=20
 	drv =3D scsi_dh_find_driver(sdev);
 	if (drv)
-		devinfo =3D scsi_dh_lookup(drv);
+		devinfo =3D __scsi_dh_lookup(drv);
 	if (devinfo)
 		err =3D scsi_dh_handler_attach(sdev, devinfo);
 	return err;
 }
=20
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
=20
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
 static inline int scsi_dh_add_device(struct scsi_device *sdev) { retur=
n 0; }
+static inline void scsi_dh_release_device(struct scsi_device *sdev) { =
}
 static inline void scsi_dh_remove_device(struct scsi_device *sdev) { }
 #endif
=20
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389..dff8faf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -399,6 +399,8 @@ static void scsi_device_dev_release_usercontext(str=
uct work_struct *work)
=20
 	sdev =3D container_of(work, struct scsi_device, ew.work);
=20
+	scsi_dh_release_device(sdev);
+
 	parent =3D sdev->sdev_gendev.parent;
=20
 	spin_lock_irqsave(sdev->host->host_lock, flags);


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
