From: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>
Subject: PATCH: usb-storage-psc1350-v4.patch (was Linux scsi / usb-mass-storage
 and HP printer cardreader bug + fix)
Date: Fri, 11 Jan 2008 21:14:00 +0100
Message-ID: <4787CE08.5000304@hhs.nl>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com> <4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050305030702030700030601"
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47860106.3090509-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: USB Storage list <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, fedora-kernel-list-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, USB development list <linux-usb-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, David Brown <usb-storage2-GijAUarxTbMdnm+yROfE0A@public.gmane.org>, Guillaume Bedot <littletux-QFiJtcdG+fw@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050305030702030700030601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Boaz Harrosh wrote:
> Yes, you're right. in ULDs it is a much proper way to do this.
> 
> So I guess you'll have to do that special host flag or device
> flag, and add a check for it in sd.c. You'll see that sd.c is 
> already doing bufflen truncation at sd_prep_fn(), just add one
> more case.
> 

Done, thanks for the hint. Patch implementing my fix this way attached, please 
apply.

Thanks & Regards,

Hans


--------------050305030702030700030601
Content-Type: text/x-patch;
 name="usb-storage-psc1350-v4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="usb-storage-psc1350-v4.patch"

This patch makes the cardreader on the HP PSC 1350 multifunction printer work,
it adds a new scsi_device and US_FL_ flag + handling, and a new
UNUSUAL_DEV_MULTI macro to support multifunction devices.

The difference between this version and the previous v3 version is that this
version has been rewritten to lower the number of sectors requested in the
scsi command when the command is generated instead of later modifying the
command in flight. This patch is against 2.6.24rc7 .

Signed-off-by: Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>
diff -up vanilla-2.6.24-rc7/include/scsi/scsi_device.h.psc1350 vanilla-2.6.24-rc7/include/scsi/scsi_device.h
--- vanilla-2.6.24-rc7/include/scsi/scsi_device.h.psc1350	2008-01-11 19:40:31.000000000 +0100
+++ vanilla-2.6.24-rc7/include/scsi/scsi_device.h	2008-01-11 19:40:48.000000000 +0100
@@ -142,6 +142,7 @@ struct scsi_device {
 	unsigned fix_capacity:1;	/* READ_CAPACITY is too high by 1 */
 	unsigned guess_capacity:1;	/* READ_CAPACITY might be too high by 1 */
 	unsigned retry_hwerror:1;	/* Retry HARDWARE_ERROR */
+	unsigned last_sector_bug:1;	/* Always read last sector in a 1 sector read */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
 	struct list_head event_list;	/* asserted events */
diff -up vanilla-2.6.24-rc7/include/linux/usb_usual.h.psc1350 vanilla-2.6.24-rc7/include/linux/usb_usual.h
--- vanilla-2.6.24-rc7/include/linux/usb_usual.h.psc1350	2008-01-11 19:40:31.000000000 +0100
+++ vanilla-2.6.24-rc7/include/linux/usb_usual.h	2008-01-11 19:42:14.000000000 +0100
@@ -50,7 +50,9 @@
 	US_FLAG(CAPACITY_HEURISTICS,	0x00001000)		\
 		/* sometimes sizes is too big */		\
 	US_FLAG(MAX_SECTORS_MIN,0x00002000)			\
-		/* Sets max_sectors to arch min */
+		/* Sets max_sectors to arch min */		\
+	US_FLAG(LAST_SECTOR_BUG,0x00004000)			\
+		/* Always read last sector in a 1 sector read */
 
 
 #define US_FLAG(name, value)	US_FL_##name = value ,
diff -up vanilla-2.6.24-rc7/drivers/scsi/sd.c.psc1350 vanilla-2.6.24-rc7/drivers/scsi/sd.c
--- vanilla-2.6.24-rc7/drivers/scsi/sd.c.psc1350	2008-01-11 19:55:43.000000000 +0100
+++ vanilla-2.6.24-rc7/drivers/scsi/sd.c	2008-01-11 20:48:54.000000000 +0100
@@ -395,6 +395,13 @@ static int sd_prep_fn(struct request_que
 		goto out;
 	}
 
+	/* Some devices (some sdcards for one) don't like it if the last sector
+	   gets read in a larger then 1 sector read */
+	if (sdp->last_sector_bug && rq->nr_sectors > sdp->sector_size / 512 &&
+ 	    block + rq->nr_sectors == get_capacity(disk)) {
+		this_count -= sdp->sector_size / 512;
+	}
+
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
 
diff -up vanilla-2.6.24-rc7/drivers/usb/storage/libusual.c.psc1350 vanilla-2.6.24-rc7/drivers/usb/storage/libusual.c
--- vanilla-2.6.24-rc7/drivers/usb/storage/libusual.c.psc1350	2008-01-11 19:40:31.000000000 +0100
+++ vanilla-2.6.24-rc7/drivers/usb/storage/libusual.c	2008-01-11 19:40:48.000000000 +0100
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
diff -up vanilla-2.6.24-rc7/drivers/usb/storage/scsiglue.c.psc1350 vanilla-2.6.24-rc7/drivers/usb/storage/scsiglue.c
--- vanilla-2.6.24-rc7/drivers/usb/storage/scsiglue.c.psc1350	2008-01-11 19:40:31.000000000 +0100
+++ vanilla-2.6.24-rc7/drivers/usb/storage/scsiglue.c	2008-01-11 19:40:48.000000000 +0100
@@ -165,6 +165,9 @@ static int slave_configure(struct scsi_d
 		if (us->flags & US_FL_CAPACITY_HEURISTICS)
 			sdev->guess_capacity = 1;
 
+		if (us->flags & US_FL_LAST_SECTOR_BUG)
+			sdev->last_sector_bug = 1;
+
 		/* Some devices report a SCSI revision level above 2 but are
 		 * unable to handle the REPORT LUNS command (for which
 		 * support is mandatory at level 3).  Since we already have
diff -up vanilla-2.6.24-rc7/drivers/usb/storage/usb.c.psc1350 vanilla-2.6.24-rc7/drivers/usb/storage/usb.c
--- vanilla-2.6.24-rc7/drivers/usb/storage/usb.c.psc1350	2008-01-11 19:40:31.000000000 +0100
+++ vanilla-2.6.24-rc7/drivers/usb/storage/usb.c	2008-01-11 19:40:48.000000000 +0100
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
diff -up vanilla-2.6.24-rc7/drivers/usb/storage/unusual_devs.h.psc1350 vanilla-2.6.24-rc7/drivers/usb/storage/unusual_devs.h
--- vanilla-2.6.24-rc7/drivers/usb/storage/unusual_devs.h.psc1350	2008-01-11 19:40:31.000000000 +0100
+++ vanilla-2.6.24-rc7/drivers/usb/storage/unusual_devs.h	2008-01-11 19:40:48.000000000 +0100
@@ -1580,6 +1580,20 @@ UNUSUAL_DEV(  0xed06, 0x4500, 0x0001, 0x
 		US_SC_DEVICE, US_PR_DEVICE, NULL,
 		US_FL_CAPACITY_HEURISTICS),
 
+/* Reported by Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org> */
+UNUSUAL_DEV_MULTI( 0x03F0, 0x3B11, 0x100, 0x100, USB_CLASS_MASS_STORAGE,
+		"hp",
+		"psc 1300 series",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_LAST_SECTOR_BUG),
+
+/* Reported by Guillaume Bedot <littletux-QFiJtcdG+fw@public.gmane.org> */
+UNUSUAL_DEV_MULTI( 0x03F0, 0x4811, 0x100, 0x100, USB_CLASS_MASS_STORAGE,
+		"hp",
+		"psc 1600 series",
+		US_SC_DEVICE, US_PR_DEVICE, NULL,
+		US_FL_LAST_SECTOR_BUG),
+
 /* Control/Bulk transport for all SubClass values */
 USUAL_DEV(US_SC_RBC, US_PR_CB, USB_US_TYPE_STOR),
 USUAL_DEV(US_SC_8020, US_PR_CB, USB_US_TYPE_STOR),

--------------050305030702030700030601--
-
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
