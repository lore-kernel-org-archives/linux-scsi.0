From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi_set_host_offline (resend)
Date: Tue, 25 Mar 2003 02:07:04 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030325100704.GC3868@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e32.co.us.ibm.com (8.12.8/8.12.2) with ESMTP id h2PA41Tr057344
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2003 05:04:01 -0500
Received: from hmsbounty (sig-9-65-18-25.mts.ibm.com [9.65.18.25])
	by westrelay01.boulder.ibm.com (8.12.8/NCO/VER6.5) with ESMTP id h2PA53k3036416
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2003 03:05:04 -0700
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a resend of a previous patch for the scsi_set_host_offline
interface.

-andmike
--
Michael Anderson
andmike@us.ibm.com

=====
name:		00_scsi_set_host_offline-2.diff
version:	2003-03-25.02:01:33-0800
against:	2.5.66

 scsi.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 scsi.h |    1 +
 2 files changed, 51 insertions(+)

=====
===== drivers/scsi/scsi.c 1.99 vs edited =====
--- 1.99/drivers/scsi/scsi.c	Mon Mar  3 10:48:16 2003
+++ edited/drivers/scsi/scsi.c	Tue Mar 25 01:45:00 2003
@@ -1295,6 +1295,37 @@
 }
 
 /**
+ * scsi_host_for_each_device - call function for each host child device
+ * @shost:	struct Scsi_Host to interate over.
+ * @data:	void pointer argumnet passed to called function.
+ * @fn:		function to call for each device.
+ *
+ **/
+static int scsi_host_for_each_device(struct Scsi_Host *shost,
+			 void * data, int (*fn)(struct scsi_device *, void *))
+{
+	struct list_head *lh;
+	struct scsi_device *sdev;
+	unsigned long flags;
+	int error = 0;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	for (lh = shost->my_devices.next; 
+	      (!error) && (lh != &shost->my_devices);) {
+		sdev = list_entry(lh, struct scsi_device, siblings);
+		scsi_device_get(sdev);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		error = fn(sdev, data);
+		spin_lock_irqsave(shost->host_lock, flags);
+		lh = lh->next;
+		scsi_device_put(sdev);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	return error;
+}
+
+/**
  * scsi_set_device_offline - set scsi_device offline
  * @sdev:	pointer to struct scsi_device to offline. 
  *
@@ -1333,6 +1364,25 @@
 	} else {
 		/* FIXME: Send online state change hotplug event */
 	}
+}
+
+/**
+ * scsi_set_device_offline - wrapper.
+ **/
+static int __scsi_set_device_offline(struct scsi_device *sdev, void *data)
+{
+	scsi_set_device_offline(sdev);
+	return 0;
+}
+
+/**
+ * scsi_set_host_offline - set all scsi_devices on a host offline
+ * @shost:	pointer to struct Scsi_Host.
+ *
+ **/
+void scsi_set_host_offline(struct Scsi_Host *shost)
+{
+	scsi_host_for_each_device(shost, NULL, __scsi_set_device_offline);
 }
 
 /*
===== drivers/scsi/scsi.h 1.67 vs edited =====
--- 1.67/drivers/scsi/scsi.h	Fri Mar 14 16:35:26 2003
+++ edited/drivers/scsi/scsi.h	Mon Mar 24 11:24:59 2003
@@ -436,6 +436,7 @@
 extern void scsi_slave_detach(struct scsi_device *);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
+extern void scsi_set_host_offline(struct Scsi_Host *);
 extern void scsi_set_device_offline(struct scsi_device *);
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);

