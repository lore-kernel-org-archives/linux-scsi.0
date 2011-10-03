From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 3/4] bnx2fc: Return error statistics of remote peer
Date: Mon, 3 Oct 2011 16:45:02 -0700
Message-ID: <1317685503-22622-4-git-send-email-bprakash@broadcom.com>
References: <1317685503-22622-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1274 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab1JCXpT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 19:45:19 -0400
In-Reply-To: <1317685503-22622-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org

Add support for get_lesb so that the valid statistics are returned by the
remote peer when RLS command is issued.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index d2bbb80..0f1ca86 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -99,6 +99,25 @@ static struct notifier_block bnx2fc_cpu_notifier = {
 	.notifier_call = bnx2fc_cpu_callback,
 };
 
+static inline struct net_device *bnx2fc_netdev(const struct fc_lport *lport)
+{
+	return ((struct bnx2fc_interface *)
+		((struct fcoe_port *)lport_priv(lport))->priv)->netdev;
+}
+
+/**
+ * bnx2fc_get_lesb() - Fill the FCoE Link Error Status Block
+ * @lport: the local port
+ * @fc_lesb: the link error status block
+ */
+static void bnx2fc_get_lesb(struct fc_lport *lport,
+			    struct fc_els_lesb *fc_lesb)
+{
+	struct net_device *netdev = bnx2fc_netdev(lport);
+
+	__fcoe_get_lesb(lport, fc_lesb, netdev);
+}
+
 static void bnx2fc_clean_rx_queue(struct fc_lport *lp)
 {
 	struct fcoe_percpu_s *bg;
@@ -2512,6 +2531,7 @@ static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
 	.elsct_send		= bnx2fc_elsct_send,
 	.fcp_abort_io		= bnx2fc_abort_io,
 	.fcp_cleanup		= bnx2fc_cleanup,
+	.get_lesb		= bnx2fc_get_lesb,
 	.rport_event_callback	= bnx2fc_rport_event_handler,
 };
 
-- 
1.7.0.6


