From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] qla2xxx: remove unused rval
Date: Wed, 22 Jul 2015 15:08:15 -0700
Message-ID: <1437602898-15229-1-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "supporter:QLOGIC QLA2XXX FC-SCSI DRIVER" <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "open list:QLOGIC QLA2XXX FC-SCSI DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Joern Engel <joern@logfs.org>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Joern Engel <joern@logfs.org>

We don't touch the return value of qla2x00_loop_resync in
qla2x00_do_dpc, so don't bother collecting it. Fixes a compiler warning.

Signed-off-by: Joern Engel <joern@logfs.org>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a28815b..b9ee115 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4793,7 +4793,6 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 static int
 qla2x00_do_dpc(void *data)
 {
-	int		rval;
 	scsi_qla_host_t *base_vha;
 	struct qla_hw_data *ha;
 
@@ -5025,7 +5024,7 @@ loop_resync_check:
 			if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE,
 			    &base_vha->dpc_flags))) {
 
-				rval = qla2x00_loop_resync(base_vha);
+				qla2x00_loop_resync(base_vha);
 
 				clear_bit(LOOP_RESYNC_ACTIVE,
 						&base_vha->dpc_flags);
-- 
2.5.0.rc3
