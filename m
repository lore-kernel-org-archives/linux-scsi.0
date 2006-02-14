From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [SCSI] fix wrong context bugs in SCSI
Date: Tue, 14 Feb 2006 10:42:07 -0600
Message-ID: <1139935327.14115.7.camel@mulgrave.il.steeleye.com>
References: <1139342419.6065.8.camel@mulgrave.il.steeleye.com>
	 <1139342922.6065.12.camel@mulgrave.il.steeleye.com>
	 <20060208085629.GE4338@suse.de>
	 <1139412662.3003.5.camel@mulgrave.il.steeleye.com>
	 <20060208155242.GO4338@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422631AbWBNQmW@vger.kernel.org>
In-Reply-To: <20060208155242.GO4338@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2006-02-08 at 16:52 +0100, Jens Axboe wrote:
> Yeah it does get a lot more complicated. I guess I'm fine with the
> current change, but please just keep it in SCSI then. It's not the sort
> of thing you'd want to advertise as an exported API.

OK, this pulls the API into scsi for 2.6.16

James

---

[PATCH] add scsi_execute_in_process_context() API

We have several points in the SCSI stack (primarily for our device
functions) where we need to guarantee process context, but (given the
place where the last reference was released) we cannot guarantee this.

This API gets around the issue by executing the function directly if
the caller has process context, but scheduling a workqueue to execute
in process context if the caller doesn't have it.  Unfortunately, it
requires memory allocation in interrupt context, but it's better than
what we have previously.  The true solution will require a bit of
re-engineering, so isn't appropriate for 2.6.16.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

Index: BUILD-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_lib.c	2006-02-12 12:37:18.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_lib.c	2006-02-14 10:17:12.000000000 -0600
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
+#include <linux/hardirq.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
@@ -2248,3 +2249,61 @@
 		device_for_each_child(dev, NULL, target_unblock);
 }
 EXPORT_SYMBOL_GPL(scsi_target_unblock);
+
+
+struct work_queue_work {
+	struct work_struct	work;
+	void			(*fn)(void *);
+	void			*data;
+};
+
+static void execute_in_process_context_work(void *data)
+{
+	void (*fn)(void *data);
+	struct work_queue_work *wqw = data;
+
+	fn = wqw->fn;
+	data = wqw->data;
+
+	kfree(wqw);
+
+	fn(data);
+}
+
+/**
+ * scsi_execute_in_process_context - reliably execute the routine with user context
+ * @fn:		the function to execute
+ * @data:	data to pass to the function
+ *
+ * Executes the function immediately if process context is available,
+ * otherwise schedules the function for delayed execution.
+ *
+ * Returns:	0 - function was executed
+ *		1 - function was scheduled for execution
+ *		<0 - error
+ */
+int scsi_execute_in_process_context(void (*fn)(void *data), void *data)
+{
+	struct work_queue_work *wqw;
+
+	if (!in_interrupt()) {
+		fn(data);
+		return 0;
+	}
+
+	wqw = kmalloc(sizeof(struct work_queue_work), GFP_ATOMIC);
+
+	if (unlikely(!wqw)) {
+		printk(KERN_ERR "Failed to allocate memory\n");
+		WARN_ON(1);
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&wqw->work, execute_in_process_context_work, wqw);
+	wqw->fn = fn;
+	wqw->data = data;
+	schedule_work(&wqw->work);
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(scsi_execute_in_process_context);
Index: BUILD-2.6/include/scsi/scsi.h
===================================================================
--- BUILD-2.6.orig/include/scsi/scsi.h	2006-02-12 12:38:10.000000000 -0600
+++ BUILD-2.6/include/scsi/scsi.h	2006-02-14 09:07:54.000000000 -0600
@@ -433,4 +433,6 @@
 /* Used to obtain the PCI location of a device */
 #define SCSI_IOCTL_GET_PCI		0x5387
 
+int scsi_execute_in_process_context(void (*fn)(void *data), void *data);
+
 #endif /* _SCSI_SCSI_H */
