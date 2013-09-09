From: Hiral Patel <hiralpat@cisco.com>
Subject: [PATCH 6/9] fnic: Kernel panic while running sh/nosh with max lun cfg
Date: Mon,  9 Sep 2013 13:31:50 -0700
Message-ID: <1378758713-22443-6-git-send-email-hiralpat@cisco.com>
References: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-3.cisco.com ([173.37.86.74]:45797 "EHLO
	rcdn-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469Ab3IIUgU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 16:36:20 -0400
In-Reply-To: <1378758713-22443-1-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Sesidhar Beddel <sebaddel@cisco.com>, Hiral Patel <hiralpat@cisco.com>

From: Sesidhar Beddel <sebaddel@cisco.com>

Kernel panics due to NULL lport while executing the log message because
of synchronization issues between libfc and scsi transport fc. Checking
for NULL pointers at the beginning of this routine would resolve the issue
from kernel panic point of view.

Signed-off-by: Sesidhar Baddel <sebaddel@cisco.com>
Signed-off-by: Hiral Patel <hiralpat@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 100cdba..b1d1921 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1416,12 +1416,29 @@ void fnic_terminate_rport_io(struct fc_rport *rport)
 	unsigned long flags;
 	struct scsi_cmnd *sc;
 	struct scsi_lun fc_lun;
-	struct fc_rport_libfc_priv *rdata = rport->dd_data;
-	struct fc_lport *lport = rdata->local_port;
-	struct fnic *fnic = lport_priv(lport);
+	struct fc_rport_libfc_priv *rdata;
+	struct fc_lport *lport;
+	struct fnic *fnic;
 	struct fc_rport *cmd_rport;
 	enum fnic_ioreq_state old_ioreq_state;
 
+	if (!rport) {
+		printk(KERN_ERR "fnic_terminate_rport_io: rport is NULL\n");
+		return;
+	}
+	rdata = rport->dd_data;
+
+	if (!rdata) {
+		printk(KERN_ERR "fnic_terminate_rport_io: rdata is NULL\n");
+		return;
+	}
+	lport = rdata->local_port;
+
+	if (!lport) {
+		printk(KERN_ERR "fnic_terminate_rport_io: lport is NULL\n");
+		return;
+	}
+	fnic = lport_priv(lport);
 	FNIC_SCSI_DBG(KERN_DEBUG,
 		      fnic->lport->host, "fnic_terminate_rport_io called"
 		      " wwpn 0x%llx, wwnn0x%llx, rport 0x%p, portid 0x%06x\n",
-- 
1.7.10.4

