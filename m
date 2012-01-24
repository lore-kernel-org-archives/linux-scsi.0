From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/4] bnx2fc: NPIV ports go offline when interface is
 brought down & up
Date: Mon, 23 Jan 2012 18:00:48 -0800
Message-ID: <1327370449-28168-4-git-send-email-bprakash@broadcom.com>
References: <1327370449-28168-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3283 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755470Ab2AXCBH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 21:01:07 -0500
In-Reply-To: <1327370449-28168-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, mchan@broadcom.com

When there are 255 NPIV ports, and the interface is brought down & up, both
physical and NPIV ports are logged off and never logged back in. Since
discovery happens on single CPU, XID resources on that CPU will be limited,
which when exhausted the discovery fails. Increase the XID resource range to
ensure that the discovery completes successfully. Also ensure that
fc_exch_mgr_alloc() doesn't fail on the system that has lower number of CPUs.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    4 +++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    9 ++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index c5af098..aa8576f 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -123,8 +123,10 @@
 #define BNX2FC_MIN_XID			0
 #define BNX2FC_MAX_XID			\
 			(BNX2FC_MAX_OUTSTANDING_CMNDS + BNX2FC_ELSTM_XIDS - 1)
+#define FCOE_MAX_NUM_XIDS		0x2000
 #define FCOE_MIN_XID			(BNX2FC_MAX_XID + 1)
-#define FCOE_MAX_XID			(FCOE_MIN_XID + 4095)
+#define FCOE_MAX_XID			(FCOE_MIN_XID + FCOE_MAX_NUM_XIDS - 1)
+#define FCOE_XIDS_PER_CPU		(FCOE_MIN_XID + (512 * nr_cpu_ids) - 1)
 #define BNX2FC_MAX_LUN			0xFFFF
 #define BNX2FC_MAX_FCP_TGT		256
 #define BNX2FC_MAX_CMD_LEN		16
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index bd18ab5..0766b93 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -940,8 +940,14 @@ static int bnx2fc_libfc_config(struct fc_lport *lport)
 
 static int bnx2fc_em_config(struct fc_lport *lport)
 {
+	int max_xid;
+
+	if (nr_cpu_ids <= 2)
+		max_xid = FCOE_XIDS_PER_CPU;
+	else
+		max_xid = FCOE_MAX_XID;
 	if (!fc_exch_mgr_alloc(lport, FC_CLASS_3, FCOE_MIN_XID,
-				FCOE_MAX_XID, NULL)) {
+				max_xid, NULL)) {
 		printk(KERN_ERR PFX "em_config:fc_exch_mgr_alloc failed\n");
 		return -ENOMEM;
 	}
@@ -2056,6 +2062,7 @@ if_create_err:
 ifput_err:
 	bnx2fc_net_cleanup(interface);
 	bnx2fc_interface_put(interface);
+	goto mod_err;
 netdev_err:
 	module_put(THIS_MODULE);
 mod_err:
-- 
1.7.0.6


