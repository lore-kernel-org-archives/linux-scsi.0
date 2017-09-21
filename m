From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: usb/storage/uas: slab-out-of-bounds in uas_probe
Date: Thu, 21 Sep 2017 15:04:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1709211456370.1294-100000@iolanthe.rowland.org>
References: <CAAeHK+yVXYJrVKW++kE+cXp=TMoDRCzPVd7G1X4YCueMbJF4HA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAeHK+yVXYJrVKW++kE+cXp=TMoDRCzPVd7G1X4YCueMbJF4HA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrey Konovalov <andreyknvl-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kostya Serebryany <kcc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 21 Sep 2017, Andrey Konovalov wrote:

> On Thu, Sep 21, 2017 at 6:10 PM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > On Thu, Sep 21, 2017 at 05:39:05PM +0200, Andrey Konovalov wrote:
> >> Hi!
> >>
> >> I've got the following report while fuzzing the kernel with syzkaller.
> >>
> >> On commit ebb2c2437d8008d46796902ff390653822af6cc4 (Sep 18).
> >>
> >> The issue occurs when we iterate over interface altsettings, but I
> >> don't see the driver doing anything wrong. I might be missing
> >> something, or this might be an issue in USB core altsettings parsing.
> >
> >
> > Any chance you happen to have the descriptors that you were feeding into
> > the kernel at this crash?  That might help in figuring out what "went
> > wrong".
> 
> Here's the data that I feed into dummy_udc:
> 
> 00 00 00 00 09 02 12 00 01 34 05 80 07 09 04 6e
> 09 00 08 06 62 00 12 01 05 00 cb f7 71 83 04 00
> 05 00 ab f6 07 81 08 01
> 
> Also attaching a C reproducer (requires dummy_hcd and gadgetfs) and my .config.

Why do your reproducers use an mmap'ed array for their data instead of 
a plain old statically allocated array?

Anyway, this turns out to be a genuine (and subtle!) bug in the uas
driver.  The uas_find_uas_alt_setting() routine in uas-detect.h returns
a bAlternateSetting value, but then the uas_use_uas_driver() routine
uses this value as an index to the altsetting array -- which it isn't.  

Normally this doesn't cause any problems because the the entries in the
array have bAlternateSetting values 0, 1, etc., so the value is equal
to the index.  But in your fuzzed case, that wasn't true.

The patch below fixes this bug, by returning a pointer to the 
alt-setting entry instead of either the value or the index.  Pointers 
are less subject to misinterpretation.

Alan Stern



Index: usb-4.x/drivers/usb/storage/uas-detect.h
===================================================================
--- usb-4.x.orig/drivers/usb/storage/uas-detect.h
+++ usb-4.x/drivers/usb/storage/uas-detect.h
@@ -9,7 +9,8 @@ static int uas_is_interface(struct usb_h
 		intf->desc.bInterfaceProtocol == USB_PR_UAS);
 }
 
-static int uas_find_uas_alt_setting(struct usb_interface *intf)
+static struct usb_host_interface *uas_find_uas_alt_setting(
+		struct usb_interface *intf)
 {
 	int i;
 
@@ -17,10 +18,10 @@ static int uas_find_uas_alt_setting(stru
 		struct usb_host_interface *alt = &intf->altsetting[i];
 
 		if (uas_is_interface(alt))
-			return alt->desc.bAlternateSetting;
+			return alt;
 	}
 
-	return -ENODEV;
+	return NULL;
 }
 
 static int uas_find_endpoints(struct usb_host_interface *alt,
@@ -58,14 +59,14 @@ static int uas_use_uas_driver(struct usb
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_hcd *hcd = bus_to_hcd(udev->bus);
 	unsigned long flags = id->driver_info;
-	int r, alt;
-
+	struct usb_host_interface *alt;
+	int r;
 
 	alt = uas_find_uas_alt_setting(intf);
-	if (alt < 0)
+	if (!alt)
 		return 0;
 
-	r = uas_find_endpoints(&intf->altsetting[alt], eps);
+	r = uas_find_endpoints(alt, eps);
 	if (r < 0)
 		return 0;
 
Index: usb-4.x/drivers/usb/storage/uas.c
===================================================================
--- usb-4.x.orig/drivers/usb/storage/uas.c
+++ usb-4.x/drivers/usb/storage/uas.c
@@ -873,14 +873,14 @@ MODULE_DEVICE_TABLE(usb, uas_usb_ids);
 static int uas_switch_interface(struct usb_device *udev,
 				struct usb_interface *intf)
 {
-	int alt;
+	struct usb_host_interface *alt;
 
 	alt = uas_find_uas_alt_setting(intf);
-	if (alt < 0)
-		return alt;
+	if (!alt)
+		return -ENODEV;
 
-	return usb_set_interface(udev,
-			intf->altsetting[0].desc.bInterfaceNumber, alt);
+	return usb_set_interface(udev, alt->desc.bInterfaceNumber,
+			alt->desc.bAlternateSetting);
 }
 
 static int uas_configure_endpoints(struct uas_dev_info *devinfo)

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
