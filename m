From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Linux scsi / usb-mass-storage and HP printer
	cardreader bug + fix
Date: Wed, 09 Jan 2008 22:44:49 +0100
Message-ID: <47854051.1060307@hhs.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020507090307080204000103"
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: USB Storage list <usb-storage@lists.one-eyed-alien.net>
Cc: Guillaume Bedot <littletux@zarb.org>, USB development list <linux-usb-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, David Brown <usb-storage2@davidb.org>, fedora-kernel-list@redhat.com
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020507090307080204000103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

First of all sorry for the somewhat massive cross-posting, I've spend a 
significant amount of time hunting down this bug, and so far the response has 
been less the overwhelming.

The problem is with the HP PSC 1350 (my printer and confirmed by 2 others) and 
atleast also the HP PSC 1610 (confirmed by Guillaume Bedot, in the CC).

The cardreader of the multi function printers will "crash" and from that moment 
on no longer communicate in any sane way, if you try to read the last sector of 
an sdcard* in a read that is more then 1 sector, so trying to read 8 sectors 
starting at sector capicity-8 will crash it, as will reading 2 sectors starting 
at sector capicity-2, however reading the last sector in a one 1 sector read 
will succeed! (* xdcards seem to be fine).

I haven't tried if it will crash on larger then 1 sector writes which include 
the last sector too, I immediately added code to not do that in both the read 
and write paths. I have tested reading and writing the end of the disk with 
this kludge in and it works.

I currently have a somewhat ugly proof of concept patch for this, which adds 
another type of usb-massstorage quirk. When this quirk flag is set, the 
usb-massstorage driver modifies READ_10 and WRITE_10 commands of more then 1 
sector which includes the last sector to become one sector less. I've been told 
by scsi subsystem developers that doing a shorter read / write then requested 
is not a problem, the scsi subsystem is designed to handle getting less then it 
asked for and will send a seperate request for the last sector.

I and 3 others (2 on a PSC 1350 too, one on a PSC1610) have tested this patch 
with success. I'm not asking for this patch to be included to the kernel as is, 
I'm asking for the now known workaround for this to be added to the kernel in 
someway!

Perhaps its an idea to add the posibility to have a scsi command filter 
function / callback to the scsi or usb-massstorage subsystem, and then add a 
mechanism to set this filter depending on usb id's and if added to the scsi 
layer, a mechanism to set it based on scsi device and manufacturer 
identification strings. Such a mechanism might be usefull in the future to work 
around other broken hardware too, and has the added advantage of not having 
todo much changes to the normal code path, keep that readable.

I'm willing to come up with a patch for such a filter mechanism, provided I get 
some pointers where this is best added.

Thanks & Regards,

Hans


p.s.

I've also included the fedora-kernel list in the addressee's because I was 
hoping that maybe someone can take one of these printers to the kernel hackfest 
   in the weekend's fudcon and take a look at this.

--------------020507090307080204000103
Content-Type: text/x-patch;
 name="usb-storage-psc1350-v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb-storage-psc1350-v3.patch"

This patch makes the cardreader on the HP PSC 1350 multifunction printer work,
it adds a new US_FL_ flag + handling, and a new UNUSUAL_DEV_MULTI macro to
support multifunction devices.

The difference between this version and the previous v2 version is that this
version also adds an unusual_devs entry for the psc1610, which also needs this
patch for its cardreader to function.

Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
diff -up linux-2.6.23.9/include/scsi/sd.h.psc1350 linux-2.6.23.9/include/scsi/sd.h
--- linux-2.6.23.9/include/scsi/sd.h.psc1350	2008-01-09 21:58:52.000000000 +0100
+++ linux-2.6.23.9/include/scsi/sd.h	2008-01-09 21:59:06.000000000 +0100
@@ -47,6 +47,8 @@ struct scsi_disk {
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)
 
+#ifdef __SD_C__
+
 static int  sd_revalidate_disk(struct gendisk *disk);
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
 static int  sd_probe(struct device *);
@@ -61,6 +63,8 @@ static void scsi_disk_release(struct cla
 static void sd_print_sense_hdr(struct scsi_disk *, struct scsi_sense_hdr *);
 static void sd_print_result(struct scsi_disk *, int);
 
+#endif
+
 #define sd_printk(prefix, sdsk, fmt, a...)				\
         (sdsk)->disk ?							\
 	sdev_printk(prefix, (sdsk)->device, "[%s] " fmt,		\
diff -up linux-2.6.23.9/include/linux/usb_usual.h.psc1350 linux-2.6.23.9/include/linux/usb_usual.h
--- linux-2.6.23.9/include/linux/usb_usual.h.psc1350	2008-01-09 21:58:52.000000000 +0100
+++ linux-2.6.23.9/include/linux/usb_usual.h	2008-01-09 21:59:06.000000000 +0100
@@ -48,7 +48,22 @@
 	US_FLAG(IGNORE_DEVICE,	0x00000800)			\
 		/* Don't claim device */			\
 	US_FLAG(CAPACITY_HEURISTICS,	0x00001000)		\
-		/* sometimes sizes is too big */
+		/* sometimes sizes is too big */		\
+	US_FLAG(LAST_SECTOR_BUG,	0x00002000)		\
+		/* The cardreader of the HP PSC 1350 all-in-one \
+		   printer / scanner / cardreader. Has a nasty	\
+		   bug where the cardreader part will return an	\
+		   error when the last sector of a SD card gets \
+		   read in a read command of more then 1 sector \
+		   once this has happened the cardreader will	\
+		   return nothing but errors. This bug gets	\
+		   triggered on every sd-card insertion with	\
+		   newer kernels, because the partition code	\
+		   now tries to read the last sector. When this \
+		   flag is set a read request of more then 1	\
+		   sector which incompases the last sector will \
+		   be split into 2 requests avoiding the 	\
+		   triggering of this cardreader bug. */
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
 enum { US_DO_ALL_FLAGS };
diff -up linux-2.6.23.9/drivers/scsi/sd.c.psc1350 linux-2.6.23.9/drivers/scsi/sd.c
--- linux-2.6.23.9/drivers/scsi/sd.c.psc1350	2008-01-09 21:58:52.000000000 +0100
+++ linux-2.6.23.9/drivers/scsi/sd.c	2008-01-09 21:59:06.000000000 +0100
@@ -49,6 +49,8 @@
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
 
+#define __SD_C__
+
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
diff -up linux-2.6.23.9/drivers/usb/storage/libusual.c.psc1350 linux-2.6.23.9/drivers/usb/storage/libusual.c
--- linux-2.6.23.9/drivers/usb/storage/libusual.c.psc1350	2008-01-09 21:58:52.000000000 +0100
+++ linux-2.6.23.9/drivers/usb/storage/libusual.c	2008-01-09 21:59:06.000000000 +0100
@@ -45,6 +45,18 @@ static int usu_probe_thread(void *arg);
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin,bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
+/* for multiple interface / function devices */
+#define UNUSUAL_DEV_MULTI(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
+		interfaceClass, vendorName, productName, useProtocol, \
+		useTransport, initFunction, flags) \
+{	.match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION| \
+		USB_DEVICE_ID_MATCH_INT_CLASS, \
+	.idVendor = (id_vendor), .idProduct = (id_product), \
+	.bcdDevice_lo = (bcdDeviceMin), .bcdDevice_hi = (bcdDeviceMax), \
+	.bInterfaceClass = (interfaceClass), \
+	.driver_info = (flags) | (USB_US_TYPE_STOR << 24) \
+}
+
 #define USUAL_DEV(useProto, useTrans, useType) \
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans), \
   .driver_info = ((useType)<<24) }
@@ -56,6 +68,7 @@ struct usb_device_id storage_usb_ids [] 
 
 #undef USUAL_DEV
 #undef UNUSUAL_DEV
+#undef UNUSUAL_DEV_MULTI
 
 MODULE_DEVICE_TABLE(usb, storage_usb_ids);
 EXPORT_SYMBOL_GPL(storage_usb_ids);
diff -up linux-2.6.23.9/drivers/usb/storage/usb.c.psc1350 linux-2.6.23.9/drivers/usb/storage/usb.c
--- linux-2.6.23.9/drivers/usb/storage/usb.c.psc1350	2008-01-09 21:58:52.000000000 +0100
+++ linux-2.6.23.9/drivers/usb/storage/usb.c	2008-01-09 21:59:06.000000000 +0100
@@ -124,6 +124,18 @@ MODULE_PARM_DESC(delay_use, "seconds to 
 { USB_DEVICE_VER(id_vendor, id_product, bcdDeviceMin,bcdDeviceMax), \
   .driver_info = (flags)|(USB_US_TYPE_STOR<<24) }
 
+/* for multiple interface / function devices */
+#define UNUSUAL_DEV_MULTI(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \
+		interfaceClass, vendorName, productName, useProtocol, \
+		useTransport, initFunction, flags) \
+{	.match_flags = USB_DEVICE_ID_MATCH_DEVICE_AND_VERSION| \
+		USB_DEVICE_ID_MATCH_INT_CLASS, \
+	.idVendor = (id_vendor), .idProduct = (id_product), \
+	.bcdDevice_lo = (bcdDeviceMin), .bcdDevice_hi = (bcdDeviceMax), \
+	.bInterfaceClass = (interfaceClass), \
+	.driver_info = (flags) | (USB_US_TYPE_STOR << 24) \
+}
+
 #define USUAL_DEV(useProto, useTrans, useType) \
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans), \
   .driver_info = (USB_US_TYPE_STOR<<24) }
@@ -132,6 +144,7 @@ static struct usb_device_id storage_usb_
 
 #	include "unusual_devs.h"
 #undef UNUSUAL_DEV
+#undef UNUSUAL_DEV_MULTI
 #undef USUAL_DEV
 	/* Terminating entry */
 	{ }
@@ -162,6 +175,13 @@ MODULE_DEVICE_TABLE (usb, storage_usb_id
 	.initFunction = init_function,	\
 }
 
+#define UNUSUAL_DEV_MULTI(idVendor, idProduct, bcdDeviceMin, bcdDeviceMax, \
+		interfaceClass, vendorName, productName, useProtocol, \
+		useTransport, initFunction, flags) \
+	UNUSUAL_DEV(idVendor, idProduct, bcdDeviceMin, bcdDeviceMax, \
+		vendorName, productName, useProtocol, useTransport, \
+		initFunction, flags)
+
 #define USUAL_DEV(use_protocol, use_transport, use_type) \
 { \
 	.useProtocol = use_protocol,	\
diff -up linux-2.6.23.9/drivers/usb/storage/unusual_devs.h.psc1350 linux-2.6.23.9/drivers/usb/storage/unusual_devs.h
--- linux-2.6.23.9/drivers/usb/storage/unusual_devs.h.psc1350	2008-01-09 21:58:52.000000000 +0100
+++ linux-2.6.23.9/drivers/usb/storage/unusual_devs.h	2008-01-09 22:05:28.000000000 +0100
@@ -1542,6 +1542,20 @@ UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_CAPACITY_HEURISTICS),
 
+/* Reported by Hans de Goede <j.w.r.degoede@hhs.nl> */
+UNUSUAL_DEV_MULTI( 0x03F0, 0x3B11, 0x100, 0x100, USB_CLASS_MASS_STORAGE,
+		"hp",
+		"psc 1300 series",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_LAST_SECTOR_BUG),
+
+/* Reported by Guillaume Bedot <littletux@zarb.org> */
+UNUSUAL_DEV_MULTI( 0x03F0, 0x4811, 0x100, 0x100, USB_CLASS_MASS_STORAGE,
+		"hp",
+		"psc 1600 series",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_LAST_SECTOR_BUG),
+
 /* Control/Bulk transport for all SubClass values */
 USUAL_DEV(US_SC_RBC, US_PR_CB, USB_US_TYPE_STOR),
 USUAL_DEV(US_SC_8020, US_PR_CB, USB_US_TYPE_STOR),
diff -up linux-2.6.23.9/drivers/usb/storage/protocol.c.psc1350 linux-2.6.23.9/drivers/usb/storage/protocol.c
--- linux-2.6.23.9/drivers/usb/storage/protocol.c.psc1350	2008-01-09 21:58:52.000000000 +0100
+++ linux-2.6.23.9/drivers/usb/storage/protocol.c	2008-01-09 21:59:06.000000000 +0100
@@ -47,6 +47,8 @@
 #include <linux/highmem.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/sd.h>
 
 #include "usb.h"
 #include "protocol.h"
@@ -140,6 +142,24 @@ void usb_stor_ufi_command(struct scsi_cm
 void usb_stor_transparent_scsi_command(struct scsi_cmnd *srb,
 				       struct us_data *us)
 {
+	if ((us->flags & US_FL_LAST_SECTOR_BUG) &&
+			(srb->cmnd[0] == READ_10 ||
+			 srb->cmnd[0] == WRITE_10) &&
+			srb->device->type == TYPE_DISK) {
+		struct scsi_disk *sdkp = dev_get_drvdata(
+						&srb->device->sdev_gendev);
+		sector_t offset = srb->cmnd[2] << 24 | srb->cmnd[3] << 16 |
+			srb->cmnd[4] << 8 | srb->cmnd[5];
+		sector_t num = srb->cmnd[7] << 8 | srb->cmnd[8];
+		
+		if ((offset + num) == sdkp->capacity && num > 1) {
+			if (srb->cmnd[8] == 0)
+				srb->cmnd[7]--;
+			srb->cmnd[8]--;
+			srb->request_bufflen -= 512;
+			srb->underflow -= 512;
+		}
+	}
 	/* send the command to the transport layer */
 	usb_stor_invoke_transport(srb, us);
 }

--------------020507090307080204000103
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
--------------020507090307080204000103
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel

--------------020507090307080204000103--
