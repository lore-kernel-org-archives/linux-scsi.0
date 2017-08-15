From: Chad Dupuis <chad.dupuis@cavium.com>
Subject: [PATCH 1/6] qedf: Set WWNN and WWPN based on values from qed.
Date: Tue, 15 Aug 2017 10:08:16 -0700
Message-ID: <20170815170821.20806-2-chad.dupuis@cavium.com>
References: <20170815170821.20806-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0067.outbound.protection.outlook.com ([104.47.33.67]:18063
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751605AbdHORI2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Aug 2017 13:08:28 -0400
In-Reply-To: <20170815170821.20806-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

If dev_info.wwpn and dev_info.wwnn are set by qed use these values to set
the WWNs of the port. Otherwise fall back to the old method using
fcoe_wwn_from_mac().

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 1d13c9ca517d..9744b6aa2a03 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3056,9 +3056,24 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC, "MAC address is %pM.\n",
 		   qedf->mac);
 
-	/* Set the WWNN and WWPN based on the MAC address */
-	qedf->wwnn = fcoe_wwn_from_mac(qedf->mac, 1, 0);
-	qedf->wwpn = fcoe_wwn_from_mac(qedf->mac, 2, 0);
+	/*
+	 * Set the WWNN and WWPN in the following way:
+	 *
+	 * If the info we get from qed is non-zero then use that to set the
+	 * WWPN and WWNN. Otherwise fall back to use fcoe_wwn_from_mac() based
+	 * on the MAC address.
+	 */
+	if (qedf->dev_info.wwnn != 0 && qedf->dev_info.wwpn != 0) {
+		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
+		    "Setting WWPN and WWNN from qed dev_info.\n");
+		qedf->wwnn = qedf->dev_info.wwnn;
+		qedf->wwpn = qedf->dev_info.wwpn;
+	} else {
+		QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
+		    "Setting WWPN and WWNN using fcoe_wwn_from_mac().\n");
+		qedf->wwnn = fcoe_wwn_from_mac(qedf->mac, 1, 0);
+		qedf->wwpn = fcoe_wwn_from_mac(qedf->mac, 2, 0);
+	}
 	QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,  "WWNN=%016llx "
 		   "WWPN=%016llx.\n", qedf->wwnn, qedf->wwpn);
 
-- 
2.12.3
