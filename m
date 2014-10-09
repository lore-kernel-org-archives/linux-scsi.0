From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] vhost-scsi: Take configfs group dependency during VHOST_SCSI_SET_ENDPOINT
Date: Thu,  9 Oct 2014 03:34:55 +0000
Message-ID: <1412825695-15134-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:37367 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaJIEEF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2014 00:04:05 -0400
Received: by mail-oi0-f47.google.com with SMTP id a141so1059002oig.6
        for <linux-scsi@vger.kernel.org>; Wed, 08 Oct 2014 21:04:04 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, "Michael S. Tsirkin" <mst@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a bug where individual vhost-scsi configfs endpoint
groups can be removed from below while active exports to QEMU userspace
still exist, resulting in an OOPs.

It adds a configfs_depend_item() in vhost_scsi_set_endpoint() to obtain
an explicit dependency on se_tpg->tpg_group in order to prevent individual
vhost-scsi WWPN endpoints from being released via normal configfs methods
while an QEMU ioctl reference still exists.

Also, add matching configfs_undepend_item() in vhost_scsi_clear_endpoint()
to release the dependency, once QEMU's reference to the individual group
at /sys/kernel/config/target/vhost/$WWPN/$TPGT is released.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: <stable@vger.kernel.org> # 3.6+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 69906ca..bc1b620 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1312,6 +1312,7 @@ static int
 vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			struct vhost_scsi_target *t)
 {
+	struct se_portal_group *se_tpg;
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tpg;
 	struct tcm_vhost_tpg **vs_tpg;
@@ -1359,6 +1360,19 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 				ret = -EEXIST;
 				goto out;
 			}
+			/*
+			 * In order to ensure individual vhost-scsi configfs
+			 * groups cannot be removed while in use by vhost ioctl,
+			 * go ahead and take an explicit se_tpg->tpg_group.cg_item
+			 * dependency now.
+			 */
+			se_tpg = &tpg->se_tpg;
+			ret = configfs_depend_item(se_tpg->se_tpg_tfo->tf_subsys,
+						   &se_tpg->tpg_group.cg_item);
+			if (ret) {
+				pr_warn("configfs_depend_item() failed: %d\n", ret);
+				goto out;
+			}
 			tpg->tv_tpg_vhost_count++;
 			tpg->vhost_scsi = vs;
 			vs_tpg[tpg->tport_tpgt] = tpg;
@@ -1401,6 +1415,7 @@ static int
 vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 			  struct vhost_scsi_target *t)
 {
+	struct se_portal_group *se_tpg;
 	struct tcm_vhost_tport *tv_tport;
 	struct tcm_vhost_tpg *tpg;
 	struct vhost_virtqueue *vq;
@@ -1449,6 +1464,13 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 		vs->vs_tpg[target] = NULL;
 		match = true;
 		mutex_unlock(&tpg->tv_tpg_mutex);
+		/*
+		 * Release se_tpg->tpg_group.cg_item configfs dependency now
+		 * to allow vhost-scsi WWPN se_tpg->tpg_group shutdown to occur.
+		 */
+		se_tpg = &tpg->se_tpg;
+		configfs_undepend_item(se_tpg->se_tpg_tfo->tf_subsys,
+				       &se_tpg->tpg_group.cg_item);
 	}
 	if (match) {
 		for (i = 0; i < VHOST_SCSI_MAX_VQ; i++) {
-- 
1.7.10.4

