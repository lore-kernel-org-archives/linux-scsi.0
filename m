From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: 2.5.48 /proc/scsi directory missing
Date: Mon, 18 Nov 2002 17:14:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118171446.A28459@eng2.beaverton.ibm.com>
References: <3DD97B95.9040908@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DD97B95.9040908@torque.net>; from dougg@torque.net on Tue, Nov 19, 2002 at 10:45:25AM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, "J. E. J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 19, 2002 at 10:45:25AM +1100, Douglas Gilbert wrote:
> That directory (and all who sail in her, e.g. /proc/scsi/scsi)
> seems to have disappeared. When the scsi_debug module is
> loaded a /proc/scsi_debug/0 entry appears (that used to be
> /proc/scsi/scsi_debug/0).
> 
> Doug Gilbert

It looks like the merge of Doug and Christoph's code dropped two calls
(unless the exit devfs_unregister was supposed to be removed).

Here's a patch for the addition of scsi_init_procfs, devfs_mk_dir and
bus_unregister calls, and a small reordering so calls in exit_scsi
match the reverse of those in init_scsi.

--- 1.67/drivers/scsi/scsi.c	Mon Nov 18 08:42:42 2002
+++ edited/scsi.c	Mon Nov 18 16:14:23 2002
@@ -2225,6 +2225,8 @@
 			printk(KERN_ERR "SCSI: can't init sg mempool %s\n", sgp->name);
 	}
 
+	scsi_init_procfs();
+	scsi_devfs_handle = devfs_mk_dir(NULL, "scsi", NULL);
 	scsi_host_init();
 	scsi_dev_info_list_init(scsi_dev_flags);
 	bus_register(&scsi_driverfs_bus_type);
@@ -2236,9 +2238,10 @@
 {
 	int i;
 
+	bus_unregister(&scsi_driverfs_bus_type);
+	scsi_dev_info_list_delete();
 	devfs_unregister(scsi_devfs_handle);
 	scsi_exit_procfs();
-	scsi_dev_info_list_delete();
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
 		struct scsi_host_sg_pool *sgp = scsi_sg_pools + i;
