From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 5/5] Leftshift returned scsi_cmnd error code 16 bits
Date: Mon, 14 Mar 2016 11:14:22 -0700
Message-ID: <1457979262-26571-5-git-send-email-satishkh@cisco.com>
References: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:46432 "EHLO
	rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbcCNSX4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 14:23:56 -0400
In-Reply-To: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com, linux-scsi@vger.kernel.org

The the scsi_cmnd error code is expected to be in the left 16 bits
of the result field. Change is to correct this.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
---
 drivers/scsi/fnic/fnic.h      | 2 +-
 drivers/scsi/fnic/fnic_scsi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 35264c7..e4e22f1 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.22"
+#define DRV_VERSION		"1.6.0.24"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 8492143..92a4ca3 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -461,7 +461,7 @@ static int fnic_queuecommand_lck(struct scsi_cmnd *sc, void (*done)(struct scsi_
 			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
 				"returning DID_NO_CONNECT for IO as rport is removed\n");
 			atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
-			sc->result = DID_NO_CONNECT;
+			sc->result = DID_NO_CONNECT<<16;
 			done(sc);
 			return 0;
 		}
-- 
2.4.3

