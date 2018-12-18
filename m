From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.20-rc7
Date: Tue, 18 Dec 2018 07:57:14 -0800
Message-ID: <1545148634.2837.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Three fixes: The t10-pi one is a regression from the 4.19 release, the
qla2xxx one is a 4.20 merge window regression and the bnx2fc is a very
old bug.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (1):
      scsi: bnx2fc: Fix NULL dereference in error handling

Himanshu Madhani (1):
      Revert "scsi: qla2xxx: Fix NVMe Target discovery"

Martin K. Petersen (1):
      scsi: t10-pi: Return correct ref tag when queue has no integrity profile

And the diffstat:

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 2 +-
 drivers/scsi/qla2xxx/qla_os.c     | 4 ++--
 include/linux/t10-pi.h            | 9 +++++----
 3 files changed, 8 insertions(+), 7 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index cd160f2ec75d..bcd30e2374f1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2364,7 +2364,7 @@ static int _bnx2fc_create(struct net_device *netdev,
 	if (!interface) {
 		printk(KERN_ERR PFX "bnx2fc_interface_create failed\n");
 		rc = -ENOMEM;
-		goto ifput_err;
+		goto netdev_err;
 	}
 
 	if (is_vlan_dev(netdev)) {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b658b9a5eb1e..d0ecc729a90a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4886,10 +4886,10 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 			fcport->d_id = e->u.new_sess.id;
 			fcport->flags |= FCF_FABRIC_DEVICE;
 			fcport->fw_login_state = DSC_LS_PLOGI_PEND;
-			if (e->u.new_sess.fc4_type & FS_FC4TYPE_FCP)
+			if (e->u.new_sess.fc4_type == FS_FC4TYPE_FCP)
 				fcport->fc4_type = FC4_TYPE_FCP_SCSI;
 
-			if (e->u.new_sess.fc4_type & FS_FC4TYPE_NVME) {
+			if (e->u.new_sess.fc4_type == FS_FC4TYPE_NVME) {
 				fcport->fc4_type = FC4_TYPE_OTHER;
 				fcport->fc4f_nvme = FC4_TYPE_NVME;
 			}
diff --git a/include/linux/t10-pi.h b/include/linux/t10-pi.h
index b9626aa7e90c..3e2a80cc7b56 100644
--- a/include/linux/t10-pi.h
+++ b/include/linux/t10-pi.h
@@ -39,12 +39,13 @@ struct t10_pi_tuple {
 
 static inline u32 t10_pi_ref_tag(struct request *rq)
 {
+	unsigned int shift = ilog2(queue_logical_block_size(rq->q));
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
-	return blk_rq_pos(rq) >>
-		(rq->q->integrity.interval_exp - 9) & 0xffffffff;
-#else
-	return -1U;
+	if (rq->q->integrity.interval_exp)
+		shift = rq->q->integrity.interval_exp;
 #endif
+	return blk_rq_pos(rq) >> (shift - SECTOR_SHIFT) & 0xffffffff;
 }
 
 extern const struct blk_integrity_profile t10_pi_type1_crc;
