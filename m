From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (4/4)
Date: Tue, 11 Feb 2003 00:19:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030211081903.GD1368@beaverton.ibm.com>
References: <20030211081351.GA1368@beaverton.ibm.com> <20030211081536.GB1368@beaverton.ibm.com> <20030211081744.GC1368@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e31.co.us.ibm.com (8.12.7/8.12.2) with ESMTP id h1B8HGCA067158
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 03:17:16 -0500
Received: from hmsbounty (sig-9-65-26-42.mts.ibm.com [9.65.26.42])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.5) with ESMTP id h1B8HGih140192
	for <linux-scsi@vger.kernel.org>; Tue, 11 Feb 2003 01:17:16 -0700
Content-Disposition: inline
In-Reply-To: <20030211081744.GC1368@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch series is against scsi-misc-2.5.

03_serror-dev-offline-1.diff:
	- Add scsi_set_device_offline interface.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 scsi.c      |   38 ++++++++++++++++++++++++++++++++++++++
 scsi.h      |    1 +
 scsi_syms.c |    1 +
 3 files changed, 40 insertions(+)
------

diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/scsi.c	Mon Feb 10 22:25:47 2003
@@ -1519,6 +1519,44 @@
 {
 	sdev->access_count--;
 	module_put(sdev->host->hostt->module);
+}
+
+/**
+ * scsi_set_device_offline - set scsi_device offline
+ * @sdev:	pointer to struct scsi_device to offline. 
+ *
+ * Locks:	host_lock held on entry.
+ **/
+void scsi_set_device_offline(struct scsi_device *sdev)
+{
+	struct scsi_cmnd *scmd;
+	int	cmds_active = 0;
+	unsigned long flags;
+
+	sdev->online = FALSE;
+
+	spin_lock_irqsave(&sdev->list_lock, flags);
+	list_for_each_entry(scmd, &sdev->cmd_list, list) {
+		if (scmd->request && scmd->request->rq_status != RQ_INACTIVE) {
+			/*
+			 * If we are unable to remove the timer, it means
+			 * that the command has already timed out or
+			 * finished.
+			 */
+			if (!scsi_delete_timer(scmd)) {
+				continue;
+			}
+
+			++cmds_active;
+
+			scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD);
+		}
+	}
+	spin_unlock_irqrestore(&sdev->list_lock, flags);
+
+	if (!cmds_active) {
+		/* FIXME: Send online state change hotplug event */
+	}
 }
 
 /*
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/scsi.h	Mon Feb 10 22:25:47 2003
@@ -456,6 +456,7 @@
 extern void scsi_slave_detach(struct scsi_device *);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
+extern void scsi_set_device_offline(struct scsi_device *);
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);
 extern int scsi_retry_command(Scsi_Cmnd *);

diff -Nru a/drivers/scsi/scsi_syms.c b/drivers/scsi/scsi_syms.c
--- a/drivers/scsi/scsi_syms.c	Mon Feb 10 22:25:47 2003
+++ b/drivers/scsi/scsi_syms.c	Mon Feb 10 22:25:47 2003
@@ -80,6 +80,7 @@
 EXPORT_SYMBOL(scsi_slave_detach);
 EXPORT_SYMBOL(scsi_device_get);
 EXPORT_SYMBOL(scsi_device_put);
+EXPORT_SYMBOL(scsi_set_device_offline);
 
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.
