From: Mike Christie <mikenc@us.ibm.com>
Subject: [PATCH] fixes an ide-scsi oops in 2.6-test5
Date: Fri, 12 Sep 2003 18:00:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F626C27.9060806@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080209080101030505050407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:44194 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261978AbTIMBA0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2003 21:00:26 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h8D10PUj250546
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2003 21:00:25 -0400
Received: from us.ibm.com (d03av02.boulder.ibm.com [9.17.193.82])
	by westrelay02.boulder.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id h8D10OQ5284374
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2003 19:00:24 -0600
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080209080101030505050407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


The attached patch cleans up the ide-scsi driver model code and fixes
the oops described below which is caused when doing a rmmod on the
driver.  The patch was built against 2.6-test5.


Mike Christie
mikenc@us.ibm.com




Sep 12 17:00:14 dyn318274bld kernel: Unable to handle kernel NULL
pointer dereference at virtual address 00000024
Sep 12 17:00:14 dyn318274bld kernel:  printing eip:
Sep 12 17:00:14 dyn318274bld kernel: c01a9a25
Sep 12 17:00:14 dyn318274bld kernel: *pde = 00000000
Sep 12 17:00:14 dyn318274bld kernel: Oops: 0002 [#1]
Sep 12 17:00:14 dyn318274bld kernel: CPU:    0
Sep 12 17:00:14 dyn318274bld kernel: EIP:    0060:[<c01a9a25>]    Not
tainted
Sep 12 17:00:14 dyn318274bld kernel: EFLAGS: 00210202
Sep 12 17:00:14 dyn318274bld kernel: EIP is at simple_rmdir+0x35/0x50
Sep 12 17:00:14 dyn318274bld kernel: eax: 00000000   ebx: cb225c80
ecx: cb225c88   edx: ffffffd9
Sep 12 17:00:14 dyn318274bld kernel: esi: c50a8740   edi: c636b0e0
ebp: cb225c80   esp: c565fe90
Sep 12 17:00:14 dyn318274bld kernel: ds: 007b   es: 007b   ss: 0068
Sep 12 17:00:14 dyn318274bld kernel: Process rmmod (pid: 2916,
threadinfo=c565e000 task=ca07c100)
Sep 12 17:00:14 dyn318274bld kernel: Stack: cb225c80 c8e89740 c50a87c0
c50a8740 c01c7a70 c50a8740 cb225c80 00000000
Sep 12 17:00:14 dyn318274bld kernel:        c565e000 cb225c80 cb225cb4
c01c7c51 cb225c80 cb225bc0 c01c7a70 c8e89740
Sep 12 17:00:14 dyn318274bld kernel:        cb225b00 c59d50e8 c0500e80
c565e000 c59d510c c05008a8 d08aa7c0 00000000
Sep 12 17:00:14 dyn318274bld kernel: Call Trace:
Sep 12 17:00:14 dyn318274bld kernel:  [<c01c7a70>] remove_dir+0x70/0xb0
Sep 12 17:00:14 dyn318274bld kernel:  [<c01c7c51>]
sysfs_remove_dir+0x191/0x3c0
Sep 12 17:00:14 dyn318274bld kernel:  [<c01c7a70>] remove_dir+0x70/0xb0
Sep 12 17:00:14 dyn318274bld kernel:  [<c026ab73>] kobject_del+0x43/0x80
Sep 12 17:00:14 dyn318274bld kernel:  [<c02e43bf>] device_del+0x7f/0xb0
Sep 12 17:00:14 dyn318274bld kernel:  [<d08a81dd>]
idescsi_cleanup+0x4d/0x60 [ide_scsi]
Sep 12 17:00:14 dyn318274bld kernel:  [<c03194bf>]
ide_unregister_driver+0x12f/0x214
Sep 12 17:00:14 dyn318274bld kernel:  [<c026a828>] unlink+0x48/0xb0
Sep 12 17:00:14 dyn318274bld kernel:  [<d08a92c7>]
exit_idescsi_module+0x27/0x29 [ide_scsi]
Sep 12 17:00:14 dyn318274bld kernel:  [<c01483d8>]
sys_delete_module+0x168/0x1d0
Sep 12 17:00:14 dyn318274bld kernel:  [<c010b269>]
sysenter_past_esp+0x52/0x71
Sep 12 17:00:14 dyn318274bld kernel:
Sep 12 17:00:14 dyn318274bld kernel: Code: ff 48 24 89 5c 24 04 89 34 24
e8 9c ff ff ff 31 d2 ff 4e 24


--------------080209080101030505050407
Content-Type: text/plain;
 name="rmmod_ide_scsi.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rmmod_ide_scsi.patch"

--- linux-2.6.0-test5/drivers/scsi/ide-scsi.c	2003-09-08 12:50:08.000000000 -0700
+++ linux-2.6.0-test5-test/drivers/scsi/ide-scsi.c	2003-09-12 16:51:18.716099041 -0700
@@ -946,13 +946,6 @@
 	.proc_name		= "ide-scsi",
 };
 
-static struct device     idescsi_primary = {
-	.bus_id		= "ide-scsi",
-};
-static struct bus_type   idescsi_emu_bus = {
-	.name		= "ide-scsi",
-};
-
 static int idescsi_attach(ide_drive_t *drive)
 {
 	idescsi_scsi_t *idescsi;
@@ -975,7 +968,7 @@
 	if (!err) {
 		idescsi_setup (drive, idescsi);
 		drive->disk->fops = &idescsi_ops;
-		err = scsi_add_host(host, &idescsi_primary);
+		err = scsi_add_host(host, &drive->gendev);
 		if (!err) {
 			scsi_scan_host(host);
 			return 0;
@@ -990,27 +983,11 @@
 
 static int __init init_idescsi_module(void)
 {
-	int err;
-
-	err = bus_register(&idescsi_emu_bus);
-	if (!err) {
-		err = device_register(&idescsi_primary);
-		if (!err) {
-			err = ide_register_driver(&idescsi_driver);
-			if (!err)
-				return 0;
-
-			device_unregister(&idescsi_primary);
-		}
-		bus_unregister(&idescsi_emu_bus);
-	}
-	return err;
+	return ide_register_driver(&idescsi_driver);
 }
 
 static void __exit exit_idescsi_module(void)
 {
-	device_unregister(&idescsi_primary);
-	bus_unregister   (&idescsi_emu_bus);
 	ide_unregister_driver(&idescsi_driver);
 }
 


--------------080209080101030505050407--

