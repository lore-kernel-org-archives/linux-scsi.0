From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 6/7] bnx2fc: Make rport_terminate_io callback a NOOP.
Date: Mon, 26 Jun 2017 08:59:37 -0700
Message-ID: <20170626155938.2091-7-chad.dupuis@cavium.com>
References: <20170626155938.2091-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0062.outbound.protection.outlook.com ([104.47.37.62]:28608
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751463AbdFZP75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 11:59:57 -0400
In-Reply-To: <20170626155938.2091-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Do not call the stock libfc terminate rport i/o handler so we won't reset
the libfc exchange manager and kill any outstanding discovery requests.

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 31aeb02..7dfe709 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2573,6 +2573,11 @@ static void bnx2fc_ulp_exit(struct cnic_dev *dev)
 	bnx2fc_hba_destroy(hba);
 }
 
+static void bnx2fc_rport_terminate_io(struct fc_rport *rport)
+{
+	/* This is a no-op */
+}
+
 /**
  * bnx2fc_fcoe_reset - Resets the fcoe
  *
@@ -2909,7 +2914,7 @@ static void __exit bnx2fc_mod_exit(void)
 
 	.issue_fc_host_lip = bnx2fc_fcoe_reset,
 
-	.terminate_rport_io = fc_rport_terminate_io,
+	.terminate_rport_io = bnx2fc_rport_terminate_io,
 
 	.vport_create = bnx2fc_vport_create,
 	.vport_delete = bnx2fc_vport_destroy,
-- 
1.8.5.6
