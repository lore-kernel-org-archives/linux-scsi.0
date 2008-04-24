From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting
 root
Date: Fri, 25 Apr 2008 00:25:04 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40573 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYDXVZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 17:25:12 -0400
In-Reply-To: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, dsd@gentoo.org, mdharm-usb@one-eyed-alien.net, linux-usb@vger.kernel.org, vegardno@ifi.uio.no, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thu, 24 Apr 2008, Pekka J Enberg wrote:
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > 
> > Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes the kernel
> > wait until background scanning of USB mass storage devices is complete before
> > attempting to mount the root filesystem.
> > 
> > The config option is an alternative to the root_delay= kernel parameter
> > solution people currently use to boot from USB mass storage devices.

On Thu, 24 Apr 2008, Alan Stern wrote:
> This doesn't take into account what happens when CONFIG_SCSI_SCAN_ASYNC
> is set.

Oh, right. Thanks! So something like the following should take care of it.

		Pekka

Subject: [RFC/PATCH] usb-storage: wait for device scanning before mounting root V2
From: Pekka Enberg <penberg@cs.helsinki.fi>

Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes the kernel
wait until background scanning of USB mass storage devices is complete before
attempting to mount the root filesystem.

The config option is an alternative to the root_delay= kernel parameter
solution people currently use to boot from USB mass storage devices.

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: <linux-usb@vger.kernel.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <linux-scsi@vger.kernel.org>
Tested-by: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/scsi/scsi_scan.c  |    2 ++
 drivers/usb/storage/usb.c |    3 +++
 include/linux/init.h      |   12 ++++++++++++
 init/Kconfig              |    5 +++++
 init/do_mounts.c          |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 54 insertions(+)

Index: linux-2.6/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.orig/drivers/usb/storage/usb.c
+++ linux-2.6/drivers/usb/storage/usb.c
@@ -928,6 +928,7 @@ static int usb_stor_scan_thread(void * _
 		/* Should we unbind if no devices were detected? */
 	}
 
+	complete_root_scan();
 	complete_and_exit(&us->scanning_done, 0);
 }
 
@@ -1007,12 +1008,14 @@ static int storage_probe(struct usb_inte
 		goto BadDevice;
 	}
 
+	begin_root_scan();
 	/* Start up the thread for delayed SCSI-device scanning */
 	th = kthread_create(usb_stor_scan_thread, us, "usb-stor-scan");
 	if (IS_ERR(th)) {
 		printk(KERN_WARNING USB_STORAGE 
 		       "Unable to start the device-scanning thread\n");
 		quiesce_and_remove_host(us);
+		complete_root_scan();
 		result = PTR_ERR(th);
 		goto BadDevice;
 	}
Index: linux-2.6/include/linux/init.h
===================================================================
--- linux-2.6.orig/include/linux/init.h
+++ linux-2.6/include/linux/init.h
@@ -147,6 +147,18 @@ extern unsigned int reset_devices;
 void setup_arch(char **);
 void prepare_namespace(void);
 
+#ifdef CONFIG_LATE_ROOT_MOUNT
+void begin_root_scan(void);
+void complete_root_scan(void);
+#else /* !CONFIG_LATE_ROOT_MOUNT */
+static inline void begin_root_scan(void)
+{
+}
+static inline void complete_root_scan(void)
+{
+}
+#endif /* CONFIG_LATE_ROOT_MOUNT */
+
 #endif
   
 #ifndef MODULE
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -473,6 +473,11 @@ config PID_NS
 	  Unless you want to work with an experimental feature
 	  say N here.
 
+config LATE_ROOT_MOUNT
+	bool "Wait for devices that do background scanning before mounting root"
+	help
+	  Say Y here if your root partition is, for example, on an USB disk.
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
Index: linux-2.6/init/do_mounts.c
===================================================================
--- linux-2.6.orig/init/do_mounts.c
+++ linux-2.6/init/do_mounts.c
@@ -326,6 +326,36 @@ void __init mount_root(void)
 #endif
 }
 
+#ifdef CONFIG_LATE_ROOT_MOUNT
+/*
+ * Late root mounting for devices that need background scanning.
+ */
+static DECLARE_COMPLETION(root_scan_done);
+static atomic_t nr_root_scans;
+
+void begin_root_scan(void)
+{
+	atomic_inc(&nr_root_scans);
+}
+
+void complete_root_scan(void)
+{
+	if (atomic_dec_and_test(&nr_root_scans))
+		complete(&root_scan_done);
+}
+
+static void __init wait_for_root_scan(void)
+{
+	if (atomic_read(&nr_root_scans))
+		wait_for_completion(&root_scan_done);
+}
+#else /* !CONFIG_LATE_ROOT_MOUNT */
+
+static inline void wait_for_root_scan(void)
+{
+}
+#endif /* CONFIG_LATE_ROOT_MOUNT */
+
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
  */
@@ -339,6 +369,8 @@ void __init prepare_namespace(void)
 		ssleep(root_delay);
 	}
 
+	wait_for_root_scan();
+
 	/* wait for the known devices to complete their probing */
 	while (driver_probe_done() != 0)
 		msleep(100);
Index: linux-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_scan.c
+++ linux-2.6/drivers/scsi/scsi_scan.c
@@ -1802,6 +1802,7 @@ static int do_scan_async(void *_data)
 	struct async_scan_data *data = _data;
 	do_scsi_scan_host(data->shost);
 	scsi_finish_async_scan(data);
+	complete_root_scan();
 	return 0;
 }
 
@@ -1823,6 +1824,7 @@ void scsi_scan_host(struct Scsi_Host *sh
 		return;
 	}
 
+	begin_root_scan();
 	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
 	if (unlikely(IS_ERR(p)))
 		do_scan_async(data);
