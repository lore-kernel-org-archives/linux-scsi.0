From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH / RFC] scsi_set_host_offline
Date: Mon, 3 Mar 2003 14:15:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030303221532.GB1587@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mdharm-scsi@one-eyed-alien.net

I have added a scsi_set_host_offline which supplements
scsi_set_device_offline. host_lock should not be held on call of either
one of these functions.

Currently scsi_set_host_offline is just setting
each sdev in my_devices offline, but could be expanded without changing
the api to the LLDD. 

I also added a for_each function. Currently scsi_set_host_offline is the
only user and could have included the functionality, but I thought there
may be possible re-use in the ~50 references to my_devices. The for_each
function also calls scsi_device_[get/put] which are not complete yet,
and would need to handle the selected policy of when a list entry is
removed from the list.

I have only tested the interface using scsi_debug.

-andmike
--
Michael Anderson
andmike@us.ibm.com

=====
name:		00_scsi_set_host_offline-1.diff
version:	2003-03-03.12:59:06-0800
against:	scsi-misc-2.5

 scsi.c      |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 scsi.h      |    1 +
 scsi_syms.c |    1 +
 3 files changed, 53 insertions(+)

=====
===== drivers/scsi/scsi.c 1.97 vs edited =====
--- 1.97/drivers/scsi/scsi.c	Wed Feb 26 00:00:06 2003
+++ edited/drivers/scsi/scsi.c	Mon Mar  3 12:31:03 2003
@@ -1300,6 +1300,38 @@
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
+	for (lh = shost->my_devices.next; lh != &shost->my_devices;){
+		sdev = list_entry(lh, struct scsi_device, siblings);
+		scsi_device_get(sdev);
+		spin_unlock_irqrestore(shost->host_lock, flags);
+		error = fn(sdev, data);
+		spin_lock_irqsave(shost->host_lock, flags);
+		lh = lh->next;
+		scsi_device_put(sdev);
+		if (error)
+			break;
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
@@ -1338,6 +1370,25 @@
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
===== drivers/scsi/scsi.h 1.65 vs edited =====
--- 1.65/drivers/scsi/scsi.h	Sun Feb 23 10:34:55 2003
+++ edited/drivers/scsi/scsi.h	Mon Mar  3 12:34:21 2003
@@ -455,6 +455,7 @@
 extern void scsi_slave_detach(struct scsi_device *);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
+extern void scsi_set_host_offline(struct Scsi_Host *);
 extern void scsi_set_device_offline(struct scsi_device *);
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);
===== drivers/scsi/scsi_syms.c 1.29 vs edited =====
--- 1.29/drivers/scsi/scsi_syms.c	Sun Feb 23 10:36:05 2003
+++ edited/drivers/scsi/scsi_syms.c	Mon Mar  3 12:33:01 2003
@@ -80,6 +80,7 @@
 EXPORT_SYMBOL(scsi_device_put);
 EXPORT_SYMBOL(scsi_add_device);
 EXPORT_SYMBOL(scsi_remove_device);
+EXPORT_SYMBOL(scsi_set_host_offline);
 EXPORT_SYMBOL(scsi_set_device_offline);
 
 /*

