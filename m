From: Baoyou Xie <baoyou.xie@linaro.org>
Subject: [PATCH] [SCSI] bnx2fc: mark symbols static where possible
Date: Sun,  4 Sep 2016 14:52:21 +0800
Message-ID: <1472971941-4882-1-git-send-email-baoyou.xie@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35485 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbcIDHAG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Sep 2016 03:00:06 -0400
Received: by mail-pf0-f173.google.com with SMTP id x72so55197585pfd.2
        for <linux-scsi@vger.kernel.org>; Sat, 03 Sep 2016 23:59:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org, xie.baoyou@zte.com.cn

We get a few warnings when building kernel with W=1:
drivers/scsi/bnx2fc/bnx2fc_els.c:257:6: warning: no previous prototype for 'bnx2fc_srr_compl' [-Wmissing-prototypes]
drivers/scsi/bnx2fc/bnx2fc_els.c:367:6: warning: no previous prototype for 'bnx2fc_rec_compl' [-Wmissing-prototypes]
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:628:5: warning: no previous prototype for 'bnx2fc_percpu_io_thread' [-Wmissing-prototypes]
drivers/scsi/bnx2fc/bnx2fc_fcoe.c:1413:26: warning: no previous prototype for 'bnx2fc_interface_create' [-Wmissing-prototypes]
drivers/scsi/bnx2fc/bnx2fc_hwi.c:997:21: warning: no previous prototype for 'bnx2fc_alloc_work' [-Wmissing-prototypes]
drivers/scsi/bnx2fc/bnx2fc_io.c:1082:5: warning: no previous prototype for 'bnx2fc_abts_cleanup' [-Wmissing-prototypes]
....

In fact, these functions are only used in the file in which they are
declared and don't need a declaration, but can be made static.
so this patch marks these functions with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/scsi/bnx2fc/bnx2fc_els.c  | 4 ++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 9 +++++----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  | 2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c   | 2 +-
 4 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_els.c b/drivers/scsi/bnx2fc/bnx2fc_els.c
index 5beea77..68ca518 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_els.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_els.c
@@ -254,7 +254,7 @@ int bnx2fc_send_rls(struct bnx2fc_rport *tgt, struct fc_frame *fp)
 	return rc;
 }
 
-void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_srr_compl(struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_mp_req *mp_req;
 	struct fc_frame_header *fc_hdr, *fh;
@@ -364,7 +364,7 @@ srr_compl_done:
 	kref_put(&orig_io_req->refcount, bnx2fc_cmd_release);
 }
 
-void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
+static void bnx2fc_rec_compl(struct bnx2fc_els_cb_arg *cb_arg)
 {
 	struct bnx2fc_cmd *orig_io_req, *new_io_req;
 	struct bnx2fc_cmd *rec_req;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a5052dd..5eb38c7 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -625,7 +625,7 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
  *
  * @arg:	ptr to bnx2fc_percpu_info structure
  */
-int bnx2fc_percpu_io_thread(void *arg)
+static int bnx2fc_percpu_io_thread(void *arg)
 {
 	struct bnx2fc_percpu_s *p = arg;
 	struct bnx2fc_work *work, *tmp;
@@ -1410,9 +1410,10 @@ bind_err:
 	return NULL;
 }
 
-struct bnx2fc_interface *bnx2fc_interface_create(struct bnx2fc_hba *hba,
-				      struct net_device *netdev,
-				      enum fip_state fip_mode)
+static struct bnx2fc_interface *
+bnx2fc_interface_create(struct bnx2fc_hba *hba,
+			struct net_device *netdev,
+			enum fip_state fip_mode)
 {
 	struct fcoe_ctlr_device *ctlr_dev;
 	struct bnx2fc_interface *interface;
diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 28c671b..5ff9f89 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -994,7 +994,7 @@ void bnx2fc_arm_cq(struct bnx2fc_rport *tgt)
 
 }
 
-struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
+static struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
 {
 	struct bnx2fc_work *work;
 	work = kzalloc(sizeof(struct bnx2fc_work), GFP_ATOMIC);
diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 8f24d60..f501095 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1079,7 +1079,7 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	return bnx2fc_initiate_tmf(sc_cmd, FCP_TMF_LUN_RESET);
 }
 
-int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
+static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
 {
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	int rc = SUCCESS;
-- 
2.7.4

