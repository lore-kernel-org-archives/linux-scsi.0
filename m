From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH 6/8] snic: Fixing race in the hba reset and IO/TM completion
Date: Thu, 17 Mar 2016 00:51:15 -0700
Message-ID: <1458201077-10211-6-git-send-email-nmusini@cisco.com>
References: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:21738 "EHLO
	alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656AbcCQH5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2016 03:57:37 -0400
In-Reply-To: <1458201077-10211-1-git-send-email-nmusini@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hare@suse.de
Cc: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>

While HBA reset is in progress, if IO/TM completion is received for the
same IO then IO/TM completion path releases the driver private resources
associated with IO. This fix prevents releasing the resources in
IO and TM completion path if HBA reset is in progress.

Signed-off-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/snic/snic.h      |  5 ++++-
 drivers/scsi/snic/snic_scsi.c | 11 +++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index d7f5ba6..8ed778d 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -95,6 +95,8 @@
 #define SNIC_DEV_RST_NOTSUP		BIT(25)
 #define SNIC_SCSI_CLEANUP		BIT(26)
 #define SNIC_HOST_RESET_ISSUED		BIT(27)
+#define SNIC_HOST_RESET_CMD_TERM	\
+	(SNIC_DEV_RST_NOTSUP | SNIC_SCSI_CLEANUP | SNIC_HOST_RESET_ISSUED)
 
 #define SNIC_ABTS_TIMEOUT		30000		/* msec */
 #define SNIC_LUN_RESET_TIMEOUT		30000		/* msec */
@@ -216,9 +218,10 @@ enum snic_msix_intr_index {
 	SNIC_MSIX_INTR_MAX,
 };
 
+#define SNIC_INTRHDLR_NAMSZ	(2 * IFNAMSIZ)
 struct snic_msix_entry {
 	int requested;
-	char devname[IFNAMSIZ];
+	char devname[SNIC_INTRHDLR_NAMSZ];
 	irqreturn_t (*isr)(int, void *);
 	void *devid;
 };
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 5a709eb..abada16 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -601,6 +601,12 @@ snic_icmnd_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 		      sc->device->lun, sc, sc->cmnd[0], snic_cmd_tag(sc),
 		      CMD_FLAGS(sc), rqi);
 
+	if (CMD_FLAGS(sc) & SNIC_HOST_RESET_CMD_TERM) {
+		spin_unlock_irqrestore(io_lock, flags);
+
+		return;
+	}
+
 	SNIC_BUG_ON(rqi != (struct snic_req_info *)ctx);
 	WARN_ON_ONCE(req);
 	if (!rqi) {
@@ -782,6 +788,11 @@ snic_process_itmf_cmpl(struct snic *snic,
 
 	io_lock = snic_io_lock_hash(snic, sc);
 	spin_lock_irqsave(io_lock, flags);
+	if (CMD_FLAGS(sc) & SNIC_HOST_RESET_CMD_TERM) {
+		spin_unlock_irqrestore(io_lock, flags);
+
+		return ret;
+	}
 	rqi = (struct snic_req_info *) CMD_SP(sc);
 	WARN_ON_ONCE(!rqi);
 
-- 
1.8.5.4

