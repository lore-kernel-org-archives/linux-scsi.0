From: David Jeffery <david_jeffery@adaptec.com>
Subject: [PATCH2.5] ips 2/4: 2.4 resync
Date: 15 Aug 2003 08:43:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060951401.3259.44.camel@blackmagic>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xEHAuzdu3Bu2gY2ML/FV"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:19168 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S275932AbTHOMkv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2003 08:40:51 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id h7FCeoo28087
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2003 05:40:50 -0700
Received: from rtpexc01.adaptec.com (rtpexc01.adaptec.com [10.110.12.22])
	by redfish.adaptec.com (8.8.8p2+Sun/8.8.8) with ESMTP id FAA24379
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2003 05:40:49 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--=-xEHAuzdu3Bu2gY2ML/FV
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch is a resync with the 6.10 driver for 2.4 and updates the 2.4
compatability code.  It adds a new wrapper function for differences
between the 2.4 and 2.6 scsi proc interface,  forces pci posting in 3
places, corrects using a meaningless constant of 0x80 to 0, and syncs
comments that had changed. 

David Jeffery

--=-xEHAuzdu3Bu2gY2ML/FV
Content-Disposition: attachment; filename=test3.patch2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=test3.patch2; charset=ANSI_X3.4-1968

diff -urN linux-2.6.0-test3_p1/drivers/scsi/ips.c linux-2.6.0-test3_p2/driv=
ers/scsi/ips.c
--- linux-2.6.0-test3_p1/drivers/scsi/ips.c	2003-08-11 12:32:04.000000000 -=
0400
+++ linux-2.6.0-test3_p2/drivers/scsi/ips.c	2003-08-11 13:53:24.000000000 -=
0400
@@ -130,6 +130,7 @@
 /* 5.10.15  - remove unused code (sem, macros, etc.)                      =
   */
 /* 5.30.00  - use __devexit_p()                                           =
   */
 /* 6.00.00  - Add 6x Adapters and Battery Flash                           =
   */
+/* 6.10.00  - Remove 1G Addressing Limitations                            =
   */
 /*************************************************************************=
****/
=20
 /*
@@ -202,6 +203,7 @@
 #endif
=20
 #if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2,5,0)
+#include <linux/blk.h>
 #include "sd.h"
 #define IPS_SG_ADDRESS(sg)       ((sg)->address)
 #define IPS_LOCK_SAVE(lock,flags) spin_lock_irqsave(&io_request_lock,flags=
)
@@ -257,9 +259,12 @@
 	.queuecommand =3D ips_queue,
 	.eh_abort_handler =3D ips_eh_abort,
 	.eh_host_reset_handler =3D ips_eh_reset,
+	.proc_name =3D "ips",
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
+	.proc_info =3D ips_proc_info,
 	.slave_configure =3D ips_slave_configure,
 #else
+	.proc_info =3D ips_proc24_info,
 	.select_queue_depths =3D ips_select_queue_depth,
 #endif
 	.bios_param =3D ips_biosparam,
@@ -321,8 +326,8 @@
 	"ServeRAID 4Lx",
 	"ServeRAID 5i",
 	"ServeRAID 5i",
-	"ServeRAID 00",
-	"ServeRAID 00"
+	"ServeRAID 6M",
+	"ServeRAID 6i"
 };
=20
 static struct notifier_block ips_notifier =3D {
@@ -595,9 +600,6 @@
 		}
 	}
=20
-	SHT->proc_info =3D ips_proc_info;
-	SHT->proc_name =3D "ips";
-
 	for (i =3D 0; i < ips_num_controllers; i++) {
 		if (ips_register_scsi(i))
 			ips_free(ips_ha[i]);
@@ -1122,7 +1124,7 @@
=20
 		ips_copp_wait_item_t *scratch;
=20
-		/* A Reset IOCTL is only sent by the ServeRAID boot CD in extreme cases.=
 */
+		/* A Reset IOCTL is only sent by the boot CD in extreme cases.          =
 */
 		/* There can never be any system activity ( network or disk ), but check=
 */
 		/* anyway just as a good practice.                                      =
 */
 		pt =3D (ips_passthru_t *) SC->request_buffer;
@@ -1222,6 +1224,24 @@
 }
=20
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+
+/* ips_proc24_info is a wrapper around ips_proc_info *
+ * for compatibility with the 2.4 scsi parameters    */
+static int
+ips_proc24_info(char *buffer, char **start, off_t offset, int length,
+		              int hostno, int func)
+{
+	int i;
+
+	for (i =3D 0; i < ips_next_controller; i++) {
+		if (ips_sh[i] && ips_sh[i]->host_no =3D=3D hostno) {
+			return ips_proc_info(ips_sh[i], buffer, start,
+					     offset, length, func);
+		}
+	}
+	return -EINVAL;=09
+}
+
 /*************************************************************************=
***/
 /*                                                                        =
  */
 /* Routine Name: ips_select_queue_depth                                   =
  */
@@ -3501,7 +3521,7 @@
 /*                                                                        =
  */
 /* Routine Description:                                                   =
  */
 /*                                                                        =
  */
-/*   Map ServeRAID error codes to Linux Error Codes                       =
  */
+/*   Map Controller Error codes to Linux Error Codes                      =
  */
 /*                                                                        =
  */
 /*************************************************************************=
***/
 static int
@@ -3755,8 +3775,8 @@
 		/* internal command */
=20
 		if (scb->bus > 0) {
-			/* ServeRAID commands can't be issued */
-			/* to real devices -- fail them       */
+			/* Controller commands can't be issued */
+			/* to real devices -- fail them        */
 			if ((ha->waitflag =3D=3D TRUE) &&
 			    (ha->cmd_in_progress =3D=3D scb->cdb[0])) {
 				ha->waitflag =3D FALSE;
@@ -4867,6 +4887,7 @@
 	METHOD_TRACE("ips_enable_int_copperhead", 1);
=20
 	outb(ha->io_addr + IPS_REG_HISR, IPS_BIT_EI);
+	inb(ha->io_addr + IPS_REG_HISR);	/*Ensure PCI Posting Completes*/
 }
=20
 /*************************************************************************=
***/
@@ -4883,6 +4904,7 @@
 	METHOD_TRACE("ips_enable_int_copperhead_memio", 1);
=20
 	writeb(IPS_BIT_EI, ha->mem_ptr + IPS_REG_HISR);
+	readb(ha->mem_ptr + IPS_REG_HISR);	/*Ensure PCI Posting Completes*/
 }
=20
 /*************************************************************************=
***/
@@ -4903,6 +4925,7 @@
 	Oimr =3D readl(ha->mem_ptr + IPS_REG_I960_OIMR);
 	Oimr &=3D ~0x08;
 	writel(Oimr, ha->mem_ptr + IPS_REG_I960_OIMR);
+	readl(ha->mem_ptr + IPS_REG_I960_OIMR);	/*Ensure PCI Posting Completes*/
 }
=20
 /*************************************************************************=
***/
@@ -6192,7 +6215,7 @@
 	scb->cmd.ffdc.op_code =3D IPS_CMD_FFDC;
 	scb->cmd.ffdc.command_id =3D IPS_COMMAND_ID(ha, scb);
 	scb->cmd.ffdc.reset_count =3D 0;
-	scb->cmd.ffdc.reset_type =3D 0x80;
+	scb->cmd.ffdc.reset_type =3D 0;
=20
 	/* convert time to what the card wants */
 	ips_fix_ffdc_time(ha, scb, ha->last_ffdc);
@@ -6781,7 +6804,7 @@
 /*     Assumes that ips_read_adapter_status() is called first filling in  =
   */
 /*     the data for SubSystem Parameters.                                 =
   */
 /*     Called from ips_write_driver_status() so it also assumes NVRAM Page=
 5 */
-/*     Data is availaible.                                                =
   */
+/*     Data is available.                                                 =
   */
 /*                                                                        =
   */
 /*------------------------------------------------------------------------=
---*/
 static void
@@ -6866,7 +6889,7 @@
 /*   Routine Name: ips_get_version_info                                   =
   */
 /*                                                                        =
   */
 /*   Routine Description:                                                 =
   */
-/*     Issue an internal GETVERSION ServeRAID Command                     =
   */
+/*     Issue an internal GETVERSION Command                               =
   */
 /*                                                                        =
   */
 /*   Return Value:                                                        =
   */
 /*     0 if Successful, else non-zero                                     =
   */
diff -urN linux-2.6.0-test3_p1/drivers/scsi/ips.h linux-2.6.0-test3_p2/driv=
ers/scsi/ips.h
--- linux-2.6.0-test3_p1/drivers/scsi/ips.h	2003-08-11 11:20:56.000000000 -=
0400
+++ linux-2.6.0-test3_p2/drivers/scsi/ips.h	2003-08-11 12:43:05.000000000 -=
0400
@@ -106,8 +106,10 @@
       #define IPS_REMOVE_HOST(shost)
       #define IPS_SCSI_SET_DEVICE(sh,ha)   scsi_set_pci_device(sh, (ha)->p=
cidev)
       #define IPS_PRINTK(level, pcidev, format, arg...)                 \
-            printk(level "%s %s:" format , (pcidev)->driver->name ,     \
-            pci_name(pcidev) , ## arg)
+            printk(level "%s %s:" format , "ips" ,     \
+            (pcidev)->slot_name , ## arg)
+      #define scsi_host_alloc(sh,size)         scsi_register(sh,size)
+      #define scsi_host_put(sh)             scsi_unregister(sh)
    #else
       #define IPS_REGISTER_HOSTS(SHT)      (!ips_detect(SHT))
       #define IPS_UNREGISTER_HOSTS(SHT)
@@ -451,9 +453,11 @@
     * Scsi_Host Template
     */
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
+   static int ips_proc24_info(char *, char **, off_t, int, int, int);
    static void ips_select_queue_depth(struct Scsi_Host *, Scsi_Device *);
    static int ips_biosparam(Disk *disk, kdev_t dev, int geom[]);
 #else
+   int ips_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int)=
;
    static int ips_biosparam(struct scsi_device *sdev, struct block_device =
*bdev,
 		sector_t capacity, int geom[]);
    int ips_slave_configure(Scsi_Device *SDptr);

--=-xEHAuzdu3Bu2gY2ML/FV--

