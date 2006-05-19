From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] SCSI: make scsi_implement_eh() generic API for SCSI transports
Date: Fri, 19 May 2006 21:07:05 +0900
Message-ID: <20060519120705.GB10058@htj.dyndns.org>
References: <4469F2B2.703@garzik.org> <1147794708.3505.30.camel@mulgrave.il.steeleye.com> <4469F906.7040602@gmail.com> <1147796999.3505.42.camel@mulgrave.il.steeleye.com> <446A0053.5070203@gmail.com> <1147798226.3505.56.camel@mulgrave.il.steeleye.com> <446A06C7.5050609@gmail.com> <20060516195836.GA3807@infradead.org> <1147814935.3505.88.camel@mulgrave.il.steeleye.com> <446BE9B4.60605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:52030 "EHLO
	py-out-1112.google.com") by vger.kernel.org with ESMTP
	id S932298AbWESMHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 08:07:13 -0400
Received: by py-out-1112.google.com with SMTP id z59so900716pyg
        for <linux-scsi@vger.kernel.org>; Fri, 19 May 2006 05:07:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <446BE9B4.60605@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

libata implemented a feature to schedule EH without an associated EH
by manipulating shost->host_eh_scheduled in ata_scsi_schedule_eh()
directly.  Move this function to scsi_error.c and rename it to
scsi_schedule_eh().  It is now an exported API for SCSI transports and
exported via new header file drivers/scsi/scsi_transport_api.h

This patch also de-export scsi_eh_wakeup() which was exported
specifically for ata_scsi_schedule_eh().

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

Okay, I went with drivers/scsi/scsi_transport_api.h.  I intentionally
didn't add any banner at the top of the file.  Feel free to fill with
appropriate description/blurb.

 drivers/scsi/libata-eh.c          |    3 ++-
 drivers/scsi/libata-scsi.c        |   24 ------------------------
 drivers/scsi/scsi_error.c         |   23 ++++++++++++++++++++++-
 drivers/scsi/scsi_priv.h          |    1 +
 drivers/scsi/scsi_transport_api.h |    6 ++++++
 include/scsi/scsi_eh.h            |    1 -
 6 files changed, 31 insertions(+), 27 deletions(-)
 create mode 100644 drivers/scsi/scsi_transport_api.h

6daec98e81a98db0dafc4846a97432746bf94f9c
diff --git a/drivers/scsi/libata-eh.c b/drivers/scsi/libata-eh.c
index 750e734..71b45ad 100644
--- a/drivers/scsi/libata-eh.c
+++ b/drivers/scsi/libata-eh.c
@@ -39,6 +39,7 @@ #include <scsi/scsi_host.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include "scsi_transport_api.h"
 
 #include <linux/libata.h>
 
@@ -432,7 +433,7 @@ void ata_port_schedule_eh(struct ata_por
 	WARN_ON(!ap->ops->error_handler);
 
 	ap->flags |= ATA_FLAG_EH_PENDING;
-	ata_schedule_scsi_eh(ap->host);
+	scsi_schedule_eh(ap->host);
 
 	DPRINTK("port EH scheduled\n");
 }
diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
index f036ae4..2007b4b 100644
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -2745,27 +2745,3 @@ void ata_scsi_scan_host(struct ata_port 
 			scsi_scan_target(&ap->host->shost_gendev, 0, i, 0, 0);
 	}
 }
-
-/**
- *	ata_schedule_scsi_eh - schedule EH for SCSI host
- *	@shost:	SCSI host to invoke error handling on.
- *
- *	Schedule SCSI EH without scmd.  This is a hack.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host_set lock)
- **/
-void ata_schedule_scsi_eh(struct Scsi_Host *shost)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-
-	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
-	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
-		shost->host_eh_scheduled++;
-		scsi_eh_wakeup(shost);
-	}
-
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 9ca71cb..346ab72 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -56,7 +56,28 @@ void scsi_eh_wakeup(struct Scsi_Host *sh
 				printk("Waking error handler thread\n"));
 	}
 }
-EXPORT_SYMBOL_GPL(scsi_eh_wakeup);
+
+/**
+ * scsi_schedule_eh - schedule EH for SCSI host
+ * @shost:	SCSI host to invoke error handling on.
+ *
+ * Schedule SCSI EH without scmd.
+ **/
+void scsi_schedule_eh(struct Scsi_Host *shost)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+
+	if (scsi_host_set_state(shost, SHOST_RECOVERY) == 0 ||
+	    scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY) == 0) {
+		shost->host_eh_scheduled++;
+		scsi_eh_wakeup(shost);
+	}
+
+	spin_unlock_irqrestore(shost->host_lock, flags);
+}
+EXPORT_SYMBOL_GPL(scsi_schedule_eh);
 
 /**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 0b39081..27c4827 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -63,6 +63,7 @@ extern int scsi_delete_timer(struct scsi
 extern void scsi_times_out(struct scsi_cmnd *cmd);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
+extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
 
 /* scsi_lib.c */
diff --git a/drivers/scsi/scsi_transport_api.h b/drivers/scsi/scsi_transport_api.h
new file mode 100644
index 0000000..934f0e6
--- /dev/null
+++ b/drivers/scsi/scsi_transport_api.h
@@ -0,0 +1,6 @@
+#ifndef _SCSI_TRANSPORT_API_H
+#define _SCSI_TRANSPORT_API_H
+
+void scsi_schedule_eh(struct Scsi_Host *shost);
+
+#endif /* _SCSI_TRANSPORT_API_H */
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 212c983..d160880 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -35,7 +35,6 @@ static inline int scsi_sense_valid(struc
 }
 
 
-extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern void scsi_eh_finish_cmd(struct scsi_cmnd *scmd,
 			       struct list_head *done_q);
 extern void scsi_eh_flush_done_q(struct list_head *done_q);
-- 
1.3.2

