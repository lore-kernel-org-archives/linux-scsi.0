From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] scsi:fnic Avoid sending reset to fnic firmware when another reset is already in progress
Date: Wed, 14 Dec 2016 13:20:41 -0800
Message-ID: <1481750441-15755-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:46052 "EHLO
        alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756681AbcLNVVJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 16:21:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com, linux-scsi@vger.kernel.org
Cc: Sesidhar Baddela <sebaddel@cisco.com>

This fix is to avoid calling fnic_fw_reset_handler through fnic_host_reset
when a finc reset is alreay in progress.

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 drivers/scsi/fnic/fnic.h      |  1 +
 drivers/scsi/fnic/fnic_scsi.c | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 9ddc920..9e4b770 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -248,6 +248,7 @@ struct fnic {
 	struct completion *remove_wait; /* device remove thread blocks */
 
 	atomic_t in_flight;		/* io counter */
+	bool internal_reset_inprogress;
 	u32 _reserved;			/* fill hole */
 	unsigned long state_flags;	/* protected by host lock */
 	enum fnic_state state;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2544a37..adb3d58 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2581,6 +2581,19 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	unsigned long wait_host_tmo;
 	struct Scsi_Host *shost = sc->device->host;
 	struct fc_lport *lp = shost_priv(shost);
+	struct fnic *fnic = lport_priv(lp);
+	unsigned long flags;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (fnic->internal_reset_inprogress == 0) {
+		fnic->internal_reset_inprogress = 1;
+	} else {
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"host reset in progress skipping another host reset\n");
+		return SUCCESS;
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	/*
 	 * If fnic_reset is successful, wait for fabric login to complete
@@ -2601,6 +2614,9 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 		}
 	}
 
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	fnic->internal_reset_inprogress = 0;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 	return ret;
 }
 
-- 
2.5.5

