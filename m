From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: PATCH: usb-storage: move to SCSI hotplugging
Date: Sun, 19 Jan 2003 14:30:58 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030119143058.A31114@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, Linux SCSI list <linux-scsi@vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The attached patch is my first implementation of SCSI hotplugging.

It's only been tested that it compiles, as I can't get the current
linux-2.5 tree from linuxusb to boot.  It dies _very_ early.  Greg, I'm not
sure if you'll want to apply this.  Linus seemed to want this very much,
and it is 2.5.x... I say go for it, but I can understand if you have
reservations.

I would definately like to see this tested by anyone who can get a kernel
to boot.

This patch is quite large.  Lots of things had to be changed.  Among them:

(o) The proc interface now uses the host number to look up the SCSI host
    structure, and then finds the usb-storage structure from that.
(o) The SCSI interface has been changed.  The code flow is now much
    clearer, as more work is done from the USB probe/detach functions than
    from auxillary functions.
(o) Names have been changed for newer conventions
(o) GUIDs have been removed
(o) The linked-list of devices has been removed, and it's associated
    semaphore
(o) All code dealing with re-attaching a device to it's old association has
    been removed
(o) Some spaces changed to tabs
(o) usb-storage now takes one directory under /proc/scsi instead of
    one per virtual-HBA
(o) All control threads now have the same name.  This could be changed back
    to the old behavior, if enough people want it.

Known problems:
(o) Testing, testing, testing
(o) More dead code needs to be cut
(o) It's a unclear how a LLD is supposed to cut off the flow of
    commands, so that the unregister() call always succeeds.  SCSI folks
    need to work on this.
(o) Probing needs to be broken down into smaller functions, probably.

Matt

# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.666   -> 1.667 =20
#	drivers/usb/storage/usb.h	1.31    -> 1.35  =20
#	drivers/usb/storage/scsiglue.h	1.4     -> 1.5   =20
#	drivers/usb/storage/scsiglue.c	1.35    -> 1.39  =20
#	drivers/usb/storage/usb.c	1.64    -> 1.68  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/01/19	mdharm@zen.san.one-eyed-alien.net	1.667
# First pass implementation of SCSI hotplug/unplug.
# --------------------------------------------
#
diff -Nru a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c	Sun Jan 19 14:10:31 2003
+++ b/drivers/usb/storage/scsiglue.c	Sun Jan 19 14:10:31 2003
@@ -50,23 +50,25 @@
 #include "transport.h"
=20
 #include <linux/slab.h>
+#include <linux/module.h>
=20
=20
 /***********************************************************************
  * Host functions=20
  ***********************************************************************/
=20
-static const char* host_info(struct Scsi_Host *host)
+static const char* usb_storage_info(struct Scsi_Host *host)
 {
 	return "SCSI emulation for USB Mass Storage devices";
 }
=20
+#if 0
 /* detect a virtual adapter (always works)
  * Synchronization: 2.4: with the io_request_lock
  * 			2.5: no locks.
  * fortunately we don't care.
  * */
-static int detect(struct SHT *sht)
+static int usb_storage_detect(struct SHT *sht)
 {
 	struct us_data *us;
 	char local_name[32];
@@ -109,7 +111,7 @@
  * the driver and we're doing each virtual host in turn, not in parallel
  * Synchronization: BKL, no spinlock.
  */
-static int release(struct Scsi_Host *psh)
+static int usb_storage_release(struct Scsi_Host *psh)
 {
 	struct us_data *us =3D (struct us_data *)psh->hostdata[0];
=20
@@ -132,18 +134,11 @@
 	/* we always have a successful release */
 	return 0;
 }
-
-/* run command */
-static int command( Scsi_Cmnd *srb )
-{
-	US_DEBUGP("Bad use of us_command\n");
-
-	return DID_BAD_TARGET << 16;
-}
+#endif
=20
 /* queue a command */
 /* This is always called with scsi_lock(srb->host) held */
-static int queuecommand( Scsi_Cmnd *srb , void (*done)(Scsi_Cmnd *))
+static int usb_storage_queuecommand( Scsi_Cmnd *srb , void (*done)(Scsi_Cm=
nd *))
 {
 	struct us_data *us =3D (struct us_data *)srb->host->hostdata[0];
=20
@@ -168,7 +163,7 @@
=20
 /* Command abort */
 /* This is always called with scsi_lock(srb->host) held */
-static int command_abort( Scsi_Cmnd *srb )
+static int usb_storage_command_abort( Scsi_Cmnd *srb )
 {
 	struct us_data *us =3D (struct us_data *)srb->host->hostdata[0];
=20
@@ -187,7 +182,7 @@
 /* This invokes the transport reset mechanism to reset the state of the
  * device */
 /* This is always called with scsi_lock(srb->host) held */
-static int device_reset( Scsi_Cmnd *srb )
+static int usb_storage_device_reset( Scsi_Cmnd *srb )
 {
 	struct us_data *us =3D (struct us_data *)srb->host->hostdata[0];
 	int result;
@@ -219,7 +214,7 @@
  * disconnect/reconnect for all drivers which have claimed
  * interfaces, including ourself. */
 /* This is always called with scsi_lock(srb->host) held */
-static int bus_reset( Scsi_Cmnd *srb )
+static int usb_storage_bus_reset( Scsi_Cmnd *srb )
 {
 	struct us_data *us =3D (struct us_data *)srb->host->hostdata[0];
 	int i;
@@ -274,14 +269,6 @@
 	return SUCCESS;
 }
=20
-/* FIXME: This doesn't do anything right now */
-static int host_reset( Scsi_Cmnd *srb )
-{
-	printk(KERN_CRIT "usb-storage: host_reset() requested but not implemented=
\n" );
-	bus_reset(srb);
-	return FAILED;
-}
-
 /***********************************************************************
  * /proc/scsi/ functions
  ***********************************************************************/
@@ -291,29 +278,24 @@
 #define SPRINTF(args...) \
 	do { if (pos < buffer+length) pos +=3D sprintf(pos, ## args); } while (0)
=20
-static int proc_info (char *buffer, char **start, off_t offset, int length,
-		int hostno, int inout)
+static int usb_storage_proc_info (char *buffer, char **start, off_t offset,
+		int length, int hostno, int inout)
 {
 	struct us_data *us;
 	char *pos =3D buffer;
+	struct Scsi_Host *hostptr;
=20
 	/* if someone is sending us data, just throw it away */
 	if (inout)
 		return length;
=20
-	/* lock the data structures */
-	down(&us_list_semaphore);
-
-	/* find our data from hostno */
-	us =3D us_list;
-	while (us) {
-		if (us->host_no =3D=3D hostno)
-			break;
-		us =3D us->next;
+	/* find our data from the given hostno */
+	hostptr =3D scsi_host_hn_get(hostno);
+	if (!hostptr) {	 /* if we couldn't find it, we return an error */
+		return -ESRCH;
 	}
-
-	/* release our lock on the data structures */
-	up(&us_list_semaphore);
+	us =3D (struct us_data*)hostptr->hostdata[0];
+	scsi_host_put(hostptr);
=20
 	/* if we couldn't find it, we return an error */
 	if (!us) {
@@ -332,8 +314,7 @@
 	SPRINTF("     Protocol: %s\n", us->protocol_name);
 	SPRINTF("    Transport: %s\n", us->transport_name);
=20
-	/* show the GUID of the device */
-	SPRINTF("         GUID: " GUID_FORMAT "\n", GUID_ARGS(us->guid));
+	/* show attached status of the device */
 	SPRINTF("     Attached: %s\n", (us->flags & US_FL_DEV_ATTACHED ?
 			"Yes" : "No"));
=20
@@ -351,33 +332,69 @@
 }
=20
 /*
- * this defines our 'host'
+ * this defines our host template, with which we'll allocate hosts
  */
=20
-Scsi_Host_Template usb_stor_host_template =3D {
-	.name =3D			"usb-storage",
-	.proc_info =3D		proc_info,
-	.info =3D			host_info,
-
-	.detect =3D		detect,
-	.release =3D		release,
-	.command =3D		command,
-	.queuecommand =3D		queuecommand,
-
-	.eh_abort_handler =3D	command_abort,
-	.eh_device_reset_handler =3Ddevice_reset,
-	.eh_bus_reset_handler =3D	bus_reset,
-	.eh_host_reset_handler =3Dhost_reset,
-
-	.can_queue =3D		1,
-	.this_id =3D		-1,
-
-	.sg_tablesize =3D		SG_ALL,
-	.cmd_per_lun =3D		1,
-	.present =3D		0,
-	.unchecked_isa_dma =3D	FALSE,
-	.use_clustering =3D	TRUE,
-	.emulated =3D		TRUE
+struct SHT usb_stor_host_template =3D {
+	/* basic userland interface stuff */
+	.name =3D				"usb-storage",
+	.proc_name =3D			"usb-storage",
+	.proc_info =3D			usb_storage_proc_info,
+	.proc_dir =3D			NULL,
+	.info =3D				usb_storage_info,
+	.ioctl =3D			NULL,
+
+	/* old-style detect and release */
+	.detect =3D			NULL,
+	.release =3D			NULL,
+
+	/* command interface -- queued only */
+	.command =3D			NULL,
+	.queuecommand =3D			usb_storage_queuecommand,
+
+	/* error and abort handlers */
+	.eh_abort_handler =3D		usb_storage_command_abort,
+	.eh_device_reset_handler =3D	usb_storage_device_reset,
+	.eh_bus_reset_handler =3D		usb_storage_bus_reset,
+	.eh_host_reset_handler =3D	NULL,
+	.eh_strategy_handler =3D		NULL,
+
+	/* queue commands only, only one command per LUN */
+	.can_queue =3D			1,
+	.cmd_per_lun =3D			1,
+
+	/* unknown initiator id */
+	.this_id =3D			-1,
+
+	/* no limit on commands */
+	.max_sectors =3D			0,
+=09
+	/* pre- and post- device scan functions */
+	.slave_alloc =3D			NULL,
+	.slave_configure =3D		NULL,
+	.slave_destroy =3D		NULL,
+
+	/* lots of sg segments can be handled */
+	.sg_tablesize =3D			SG_ALL,
+
+	/* use 32-bit address space for DMA */
+	.unchecked_isa_dma =3D		FALSE,
+	.highmem_io =3D			FALSE,
+
+	/* merge commands... this seems to help performance, but
+	 * periodically someone should test to see which setting is more
+	 * optimal.
+	 */
+	.use_clustering =3D		TRUE,
+
+	/* emulated HBA */
+	.emulated =3D			TRUE,
+
+	/* sorry, no BIOS to help us */
+	.bios_param =3D			NULL,
+
+	/* module management */
+	.module =3D			THIS_MODULE
 };
=20
 /* For a device that is "Not Ready" */
diff -Nru a/drivers/usb/storage/scsiglue.h b/drivers/usb/storage/scsiglue.h
--- a/drivers/usb/storage/scsiglue.h	Sun Jan 19 14:10:31 2003
+++ b/drivers/usb/storage/scsiglue.h	Sun Jan 19 14:10:31 2003
@@ -47,7 +47,7 @@
=20
 extern unsigned char usb_stor_sense_notready[18];
 extern unsigned char usb_stor_sense_invalidCDB[18];
-extern Scsi_Host_Template usb_stor_host_template;
+extern struct SHT usb_stor_host_template;
 extern int usb_stor_scsiSense10to6(Scsi_Cmnd*);
 extern int usb_stor_scsiSense6to10(Scsi_Cmnd*);
=20
diff -Nru a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c	Sun Jan 19 14:10:31 2003
+++ b/drivers/usb/storage/usb.c	Sun Jan 19 14:10:31 2003
@@ -93,16 +93,6 @@
 MODULE_DESCRIPTION("USB Mass Storage driver for Linux");
 MODULE_LICENSE("GPL");
=20
-/*
- * Per device data
- */
-
-static int my_host_number;
-
-/* The list of structures and the protective lock for them */
-struct us_data *us_list;
-struct semaphore us_list_semaphore;
-
 static int storage_probe(struct usb_interface *iface,
 			 const struct usb_device_id *id);
=20
@@ -319,7 +309,7 @@
 	spin_unlock_irq(&current->sig->siglock);
=20
 	/* set our name for identification purposes */
-	sprintf(current->comm, "usb-storage-%d", us->host_number);
+	sprintf(current->comm, "usb-storage");
=20
 	unlock_kernel();
=20
@@ -563,12 +553,10 @@
 	char mf[USB_STOR_STRING_LEN];		     /* manufacturer */
 	char prod[USB_STOR_STRING_LEN];		     /* product */
 	char serial[USB_STOR_STRING_LEN];	     /* serial number */
-	GUID(guid);			   /* Global Unique Identifier */
 	unsigned int flags;
 	struct us_unusual_dev *unusual_dev;
 	struct us_data *ss =3D NULL;
 	int result;
-	int new_device =3D 0;
=20
 	/* these are temporary copies -- we test on these, then put them
 	 * in the us-data structure=20
@@ -676,8 +664,7 @@
 	/* At this point, we've decided to try to use the device */
 	usb_get_dev(dev);
=20
-	/* clear the GUID and fetch the strings */
-	GUID_CLEAR(guid);
+	/* fetch the strings */
 	if (dev->descriptor.iManufacturer)
 		usb_string(dev, dev->descriptor.iManufacturer,=20
 			   mf, sizeof(mf));
@@ -688,348 +675,276 @@
 		usb_string(dev, dev->descriptor.iSerialNumber,=20
 			   serial, sizeof(serial));
=20
-	/* Create a GUID for this device */
-	if (dev->descriptor.iSerialNumber && serial[0]) {
-		/* If we have a serial number, and it's a non-NULL string */
-		make_guid(guid, dev->descriptor.idVendor,=20
-			  dev->descriptor.idProduct, serial);
-	} else {
-		/* We don't have a serial number, so we use 0 */
-		make_guid(guid, dev->descriptor.idVendor,=20
-			  dev->descriptor.idProduct, "0");
+	/* New device -- allocate memory and initialize */
+	if ((ss =3D (struct us_data *)kmalloc(sizeof(struct us_data),=20
+					    GFP_KERNEL)) =3D=3D NULL) {
+		printk(KERN_WARNING USB_STORAGE "Out of memory\n");
+		usb_put_dev(dev);
+		return -ENOMEM;
+	}
+	memset(ss, 0, sizeof(struct us_data));
+
+	/* Initialize the mutexes only when the struct is new */
+	init_completion(&(ss->notify));
+	init_MUTEX_LOCKED(&(ss->dev_semaphore));
+
+	/* copy over the subclass and protocol data */
+	ss->subclass =3D subclass;
+	ss->protocol =3D protocol;
+	ss->flags =3D flags | US_FL_DEV_ATTACHED;
+	ss->unusual_dev =3D unusual_dev;
+
+	/* copy over the endpoint data */
+	ss->ep_in =3D ep_in->bEndpointAddress &=20
+		USB_ENDPOINT_NUMBER_MASK;
+	ss->ep_out =3D ep_out->bEndpointAddress &=20
+		USB_ENDPOINT_NUMBER_MASK;
+	if (ep_int) {
+		ss->ep_int =3D ep_int->bEndpointAddress &=20
+			USB_ENDPOINT_NUMBER_MASK;
+		ss->ep_bInterval =3D ep_int->bInterval;
 	}
+	else
+		ss->ep_int =3D ss->ep_bInterval =3D 0;
=20
-	/*
-	 * Now check if we have seen this GUID before
-	 * We're looking for a device with a matching GUID that isn't
-	 * already on the system
-	 */
-	ss =3D us_list;
-	while ((ss !=3D NULL) &&=20
-	           ((ss->flags & US_FL_DEV_ATTACHED) ||
-		    !GUID_EQUAL(guid, ss->guid)))
-		ss =3D ss->next;
-
-	if (ss !=3D NULL) {
-		/* Existing device -- re-connect */
-		US_DEBUGP("Found existing GUID " GUID_FORMAT "\n",
-			  GUID_ARGS(guid));
-
-		/* lock the device pointers */
-		down(&(ss->dev_semaphore));
-
-		/* establish the connection to the new device upon reconnect */
-		ss->ifnum =3D ifnum;
-		ss->pusb_dev =3D dev;
-		ss->flags |=3D US_FL_DEV_ATTACHED;
-
-		/* copy over the endpoint data */
-		ss->ep_in =3D ep_in->bEndpointAddress &=20
-			USB_ENDPOINT_NUMBER_MASK;
-		ss->ep_out =3D ep_out->bEndpointAddress &=20
-			USB_ENDPOINT_NUMBER_MASK;
-		if (ep_int) {
-			ss->ep_int =3D ep_int->bEndpointAddress &=20
-				USB_ENDPOINT_NUMBER_MASK;
-			ss->ep_bInterval =3D ep_int->bInterval;
-		}
+	/* establish the connection to the new device */
+	ss->ifnum =3D ifnum;
+	ss->pusb_dev =3D dev;
+
+	/* copy over the identifiying strings */
+	strncpy(ss->vendor, mf, USB_STOR_STRING_LEN);
+	strncpy(ss->product, prod, USB_STOR_STRING_LEN);
+	strncpy(ss->serial, serial, USB_STOR_STRING_LEN);
+	if (strlen(ss->vendor) =3D=3D 0) {
+		if (unusual_dev->vendorName)
+			strncpy(ss->vendor, unusual_dev->vendorName,
+				USB_STOR_STRING_LEN);
 		else
-			ss->ep_int =3D ss->ep_bInterval =3D 0;
-
-		/* allocate the URB, the usb_ctrlrequest, and the IRQ URB */
-		if (usb_stor_allocate_urbs(ss))
-			goto BadDevice;
-
-                /* Re-Initialize the device if it needs it */
-		if (unusual_dev && unusual_dev->initFunction)
-			(unusual_dev->initFunction)(ss);
-
-		/* unlock the device pointers */
-		up(&(ss->dev_semaphore));
-
-	} else {=20
-		/* New device -- allocate memory and initialize */
-		US_DEBUGP("New GUID " GUID_FORMAT "\n", GUID_ARGS(guid));
-
-		if ((ss =3D (struct us_data *)kmalloc(sizeof(struct us_data),=20
-						    GFP_KERNEL)) =3D=3D NULL) {
-			printk(KERN_WARNING USB_STORAGE "Out of memory\n");
-			usb_put_dev(dev);
-			return -ENOMEM;
-		}
-		memset(ss, 0, sizeof(struct us_data));
-		new_device =3D 1;
-
-		/* Initialize the mutexes only when the struct is new */
-		init_completion(&(ss->notify));
-		init_MUTEX_LOCKED(&(ss->dev_semaphore));
-
-		/* copy over the subclass and protocol data */
-		ss->subclass =3D subclass;
-		ss->protocol =3D protocol;
-		ss->flags =3D flags | US_FL_DEV_ATTACHED;
-		ss->unusual_dev =3D unusual_dev;
-
-		/* copy over the endpoint data */
-		ss->ep_in =3D ep_in->bEndpointAddress &=20
-			USB_ENDPOINT_NUMBER_MASK;
-		ss->ep_out =3D ep_out->bEndpointAddress &=20
-			USB_ENDPOINT_NUMBER_MASK;
-		if (ep_int) {
-			ss->ep_int =3D ep_int->bEndpointAddress &=20
-				USB_ENDPOINT_NUMBER_MASK;
-			ss->ep_bInterval =3D ep_int->bInterval;
-		}
+			strncpy(ss->vendor, "Unknown",
+				USB_STOR_STRING_LEN);
+	}
+	if (strlen(ss->product) =3D=3D 0) {
+		if (unusual_dev->productName)
+			strncpy(ss->product, unusual_dev->productName,
+				USB_STOR_STRING_LEN);
 		else
-			ss->ep_int =3D ss->ep_bInterval =3D 0;
-
-		/* establish the connection to the new device */
-		ss->ifnum =3D ifnum;
-		ss->pusb_dev =3D dev;
-
-		/* copy over the identifiying strings */
-		strncpy(ss->vendor, mf, USB_STOR_STRING_LEN);
-		strncpy(ss->product, prod, USB_STOR_STRING_LEN);
-		strncpy(ss->serial, serial, USB_STOR_STRING_LEN);
-		if (strlen(ss->vendor) =3D=3D 0) {
-			if (unusual_dev->vendorName)
-				strncpy(ss->vendor, unusual_dev->vendorName,
-					USB_STOR_STRING_LEN);
-			else
-				strncpy(ss->vendor, "Unknown",
-					USB_STOR_STRING_LEN);
-		}
-		if (strlen(ss->product) =3D=3D 0) {
-			if (unusual_dev->productName)
-				strncpy(ss->product, unusual_dev->productName,
-					USB_STOR_STRING_LEN);
-			else
-				strncpy(ss->product, "Unknown",
-					USB_STOR_STRING_LEN);
-		}
-		if (strlen(ss->serial) =3D=3D 0)
-			strncpy(ss->serial, "None", USB_STOR_STRING_LEN);
-
-		/* copy the GUID we created before */
-		memcpy(ss->guid, guid, sizeof(guid));
-
-		/*=20
-		 * Set the handler pointers based on the protocol
-		 * Again, this data is persistant across reattachments
-		 */
-		switch (ss->protocol) {
-		case US_PR_CB:
-			ss->transport_name =3D "Control/Bulk";
-			ss->transport =3D usb_stor_CB_transport;
-			ss->transport_reset =3D usb_stor_CB_reset;
-			ss->max_lun =3D 7;
-			break;
-
-		case US_PR_CBI:
-			ss->transport_name =3D "Control/Bulk/Interrupt";
-			ss->transport =3D usb_stor_CBI_transport;
-			ss->transport_reset =3D usb_stor_CB_reset;
-			ss->max_lun =3D 7;
-			break;
+			strncpy(ss->product, "Unknown",
+				USB_STOR_STRING_LEN);
+	}
+	if (strlen(ss->serial) =3D=3D 0)
+		strncpy(ss->serial, "None", USB_STOR_STRING_LEN);
=20
-		case US_PR_BULK:
-			ss->transport_name =3D "Bulk";
-			ss->transport =3D usb_stor_Bulk_transport;
-			ss->transport_reset =3D usb_stor_Bulk_reset;
-			ss->max_lun =3D usb_stor_Bulk_max_lun(ss);
-			break;
+	/*=20
+	 * Set the handler pointers based on the protocol
+	 * Again, this data is persistant across reattachments
+	 */
+	switch (ss->protocol) {
+	case US_PR_CB:
+		ss->transport_name =3D "Control/Bulk";
+		ss->transport =3D usb_stor_CB_transport;
+		ss->transport_reset =3D usb_stor_CB_reset;
+		ss->max_lun =3D 7;
+		break;
+
+	case US_PR_CBI:
+		ss->transport_name =3D "Control/Bulk/Interrupt";
+		ss->transport =3D usb_stor_CBI_transport;
+		ss->transport_reset =3D usb_stor_CB_reset;
+		ss->max_lun =3D 7;
+		break;
+
+	case US_PR_BULK:
+		ss->transport_name =3D "Bulk";
+		ss->transport =3D usb_stor_Bulk_transport;
+		ss->transport_reset =3D usb_stor_Bulk_reset;
+		ss->max_lun =3D usb_stor_Bulk_max_lun(ss);
+		break;
=20
 #ifdef CONFIG_USB_STORAGE_HP8200e
-		case US_PR_SCM_ATAPI:
-			ss->transport_name =3D "SCM/ATAPI";
-			ss->transport =3D hp8200e_transport;
-			ss->transport_reset =3D usb_stor_CB_reset;
-			ss->max_lun =3D 1;
-			break;
+	case US_PR_SCM_ATAPI:
+		ss->transport_name =3D "SCM/ATAPI";
+		ss->transport =3D hp8200e_transport;
+		ss->transport_reset =3D usb_stor_CB_reset;
+		ss->max_lun =3D 1;
+		break;
 #endif
=20
 #ifdef CONFIG_USB_STORAGE_SDDR09
-		case US_PR_EUSB_SDDR09:
-			ss->transport_name =3D "EUSB/SDDR09";
-			ss->transport =3D sddr09_transport;
-			ss->transport_reset =3D usb_stor_CB_reset;
-			ss->max_lun =3D 0;
-			break;
+	case US_PR_EUSB_SDDR09:
+		ss->transport_name =3D "EUSB/SDDR09";
+		ss->transport =3D sddr09_transport;
+		ss->transport_reset =3D usb_stor_CB_reset;
+		ss->max_lun =3D 0;
+		break;
 #endif
=20
 #ifdef CONFIG_USB_STORAGE_SDDR55
-		case US_PR_SDDR55:
-			ss->transport_name =3D "SDDR55";
-			ss->transport =3D sddr55_transport;
-			ss->transport_reset =3D sddr55_reset;
-			ss->max_lun =3D 0;
-			break;
+	case US_PR_SDDR55:
+		ss->transport_name =3D "SDDR55";
+		ss->transport =3D sddr55_transport;
+		ss->transport_reset =3D sddr55_reset;
+		ss->max_lun =3D 0;
+		break;
 #endif
=20
 #ifdef CONFIG_USB_STORAGE_DPCM
-		case US_PR_DPCM_USB:
-			ss->transport_name =3D "Control/Bulk-EUSB/SDDR09";
-			ss->transport =3D dpcm_transport;
-			ss->transport_reset =3D usb_stor_CB_reset;
-			ss->max_lun =3D 1;
-			break;
+	case US_PR_DPCM_USB:
+		ss->transport_name =3D "Control/Bulk-EUSB/SDDR09";
+		ss->transport =3D dpcm_transport;
+		ss->transport_reset =3D usb_stor_CB_reset;
+		ss->max_lun =3D 1;
+		break;
 #endif
=20
 #ifdef CONFIG_USB_STORAGE_FREECOM
-                case US_PR_FREECOM:
-                        ss->transport_name =3D "Freecom";
-                        ss->transport =3D freecom_transport;
-                        ss->transport_reset =3D usb_stor_freecom_reset;
-                        ss->max_lun =3D 0;
-                        break;
+	case US_PR_FREECOM:
+		ss->transport_name =3D "Freecom";
+		ss->transport =3D freecom_transport;
+		ss->transport_reset =3D usb_stor_freecom_reset;
+		ss->max_lun =3D 0;
+		break;
 #endif
=20
 #ifdef CONFIG_USB_STORAGE_DATAFAB
-                case US_PR_DATAFAB:
-                        ss->transport_name  =3D "Datafab Bulk-Only";
-                        ss->transport =3D datafab_transport;
-                        ss->transport_reset =3D usb_stor_Bulk_reset;
-                        ss->max_lun =3D 1;
-                        break;
+	case US_PR_DATAFAB:
+		ss->transport_name  =3D "Datafab Bulk-Only";
+		ss->transport =3D datafab_transport;
+		ss->transport_reset =3D usb_stor_Bulk_reset;
+		ss->max_lun =3D 1;
+		break;
 #endif
=20
 #ifdef CONFIG_USB_STORAGE_JUMPSHOT
-                case US_PR_JUMPSHOT:
-                        ss->transport_name  =3D "Lexar Jumpshot Control/Bu=
lk";
-                        ss->transport =3D jumpshot_transport;
-                        ss->transport_reset =3D usb_stor_Bulk_reset;
-                        ss->max_lun =3D 1;
-                        break;
+	case US_PR_JUMPSHOT:
+		ss->transport_name  =3D "Lexar Jumpshot Control/Bulk";
+		ss->transport =3D jumpshot_transport;
+		ss->transport_reset =3D usb_stor_Bulk_reset;
+		ss->max_lun =3D 1;
+		break;
 #endif
=20
-		default:
-			/* ss->transport_name =3D "Unknown"; */
-			goto BadDevice;
-		}
-		US_DEBUGP("Transport: %s\n", ss->transport_name);
-
-		/* fix for single-lun devices */
-		if (ss->flags & US_FL_SINGLE_LUN)
-			ss->max_lun =3D 0;
-
-		switch (ss->subclass) {
-		case US_SC_RBC:
-			ss->protocol_name =3D "Reduced Block Commands (RBC)";
-			ss->proto_handler =3D usb_stor_transparent_scsi_command;
-			break;
-
-		case US_SC_8020:
-			ss->protocol_name =3D "8020i";
-			ss->proto_handler =3D usb_stor_ATAPI_command;
-			ss->max_lun =3D 0;
-			break;
-
-		case US_SC_QIC:
-			ss->protocol_name =3D "QIC-157";
-			ss->proto_handler =3D usb_stor_qic157_command;
-			ss->max_lun =3D 0;
-			break;
-
-		case US_SC_8070:
-			ss->protocol_name =3D "8070i";
-			ss->proto_handler =3D usb_stor_ATAPI_command;
-			ss->max_lun =3D 0;
-			break;
-
-		case US_SC_SCSI:
-			ss->protocol_name =3D "Transparent SCSI";
-			ss->proto_handler =3D usb_stor_transparent_scsi_command;
-			break;
-
-		case US_SC_UFI:
-			ss->protocol_name =3D "Uniform Floppy Interface (UFI)";
-			ss->proto_handler =3D usb_stor_ufi_command;
-			break;
+	default:
+		/* ss->transport_name =3D "Unknown"; */
+		goto BadDevice;
+	}
+	US_DEBUGP("Transport: %s\n", ss->transport_name);
+
+	/* fix for single-lun devices */
+	if (ss->flags & US_FL_SINGLE_LUN)
+		ss->max_lun =3D 0;
+
+	switch (ss->subclass) {
+	case US_SC_RBC:
+		ss->protocol_name =3D "Reduced Block Commands (RBC)";
+		ss->proto_handler =3D usb_stor_transparent_scsi_command;
+		break;
+
+	case US_SC_8020:
+		ss->protocol_name =3D "8020i";
+		ss->proto_handler =3D usb_stor_ATAPI_command;
+		ss->max_lun =3D 0;
+		break;
+
+	case US_SC_QIC:
+		ss->protocol_name =3D "QIC-157";
+		ss->proto_handler =3D usb_stor_qic157_command;
+		ss->max_lun =3D 0;
+		break;
+
+	case US_SC_8070:
+		ss->protocol_name =3D "8070i";
+		ss->proto_handler =3D usb_stor_ATAPI_command;
+		ss->max_lun =3D 0;
+		break;
+
+	case US_SC_SCSI:
+		ss->protocol_name =3D "Transparent SCSI";
+		ss->proto_handler =3D usb_stor_transparent_scsi_command;
+		break;
+
+	case US_SC_UFI:
+		ss->protocol_name =3D "Uniform Floppy Interface (UFI)";
+		ss->proto_handler =3D usb_stor_ufi_command;
+		break;
=20
 #ifdef CONFIG_USB_STORAGE_ISD200
-                case US_SC_ISD200:
-                        ss->protocol_name =3D "ISD200 ATA/ATAPI";
-                        ss->proto_handler =3D isd200_ata_command;
-                        break;
+	case US_SC_ISD200:
+		ss->protocol_name =3D "ISD200 ATA/ATAPI";
+		ss->proto_handler =3D isd200_ata_command;
+		break;
 #endif
=20
-		default:
-			/* ss->protocol_name =3D "Unknown"; */
-			goto BadDevice;
-		}
-		US_DEBUGP("Protocol: %s\n", ss->protocol_name);
-
-		/* allocate the URB, the usb_ctrlrequest, and the IRQ URB */
-		if (usb_stor_allocate_urbs(ss))
-			goto BadDevice;
-
-		/*
-		 * Since this is a new device, we need to generate a scsi=20
-		 * host definition, and register with the higher SCSI layers
-		 */
-
-		/* Initialize the host template based on the default one */
-		memcpy(&(ss->htmplt), &usb_stor_host_template,=20
-		       sizeof(usb_stor_host_template));
-
-		/* Grab the next host number */
-		ss->host_number =3D my_host_number++;
-
-		/* We abuse this pointer so we can pass the ss pointer to=20
-		 * the host controller thread in us_detect.  But how else are
-		 * we to do it?
-		 */
-		(struct us_data *)ss->htmplt.proc_dir =3D ss;=20
-
-		/* Just before we start our control thread, initialize
-		 * the device if it needs initialization */
-		if (unusual_dev && unusual_dev->initFunction)
-			unusual_dev->initFunction(ss);
-
-		/* start up our control thread */
-		atomic_set(&ss->sm_state, US_STATE_IDLE);
-		ss->pid =3D kernel_thread(usb_stor_control_thread, ss,
-					CLONE_VM);
-		if (ss->pid < 0) {
-			printk(KERN_WARNING USB_STORAGE=20
-			       "Unable to start control thread\n");
-			goto BadDevice;
-		}
-
-		/* wait for the thread to start */
-		wait_for_completion(&(ss->notify));
+	default:
+		/* ss->protocol_name =3D "Unknown"; */
+		goto BadDevice;
+	}
+	US_DEBUGP("Protocol: %s\n", ss->protocol_name);
+
+	/* allocate the URB, the usb_ctrlrequest, and the IRQ URB */
+	if (usb_stor_allocate_urbs(ss))
+		goto BadDevice;
=20
-		/* unlock the device pointers */
-		up(&(ss->dev_semaphore));
+	/*
+	 * Since this is a new device, we need to generate a scsi=20
+	 * host definition, and register with the higher SCSI layers
+	 */
=20
-		/* now register	 - our detect function will be called */
-		ss->htmplt.module =3D THIS_MODULE;
-		result =3D scsi_register_host(&(ss->htmplt));
-		if (result) {
-			printk(KERN_WARNING USB_STORAGE
-				"Unable to register the scsi host\n");
-
-			/* tell the control thread to exit */
-			ss->srb =3D NULL;
-			up(&ss->sema);
-			wait_for_completion(&ss->notify);
-
-			/* re-lock the device pointers */
-			down(&ss->dev_semaphore);
-			goto BadDevice;
-		}
+	/* Just before we start our control thread, initialize
+	 * the device if it needs initialization */
+	if (unusual_dev && unusual_dev->initFunction)
+		unusual_dev->initFunction(ss);
+
+	/* start up our control thread */
+	atomic_set(&ss->sm_state, US_STATE_IDLE);
+	ss->pid =3D kernel_thread(usb_stor_control_thread, ss,
+				CLONE_VM);
+	if (ss->pid < 0) {
+		printk(KERN_WARNING USB_STORAGE=20
+		       "Unable to start control thread\n");
+		goto BadDevice;
+	}
=20
-		/* lock access to the data structures */
-		down(&us_list_semaphore);
+	/* wait for the thread to start */
+	wait_for_completion(&(ss->notify));
=20
-		/* put us in the list */
-		ss->next =3D us_list;
-		us_list =3D ss;
+	/* unlock the device pointers */
+	up(&(ss->dev_semaphore));
=20
-		/* release the data structure lock */
-		up(&us_list_semaphore);
+	/* now register	*/
+	ss->host =3D scsi_register(&usb_stor_host_template, sizeof(ss));
+	if (ss->host) {
+		printk(KERN_WARNING USB_STORAGE
+			"Unable to register the scsi host\n");
+
+		/* tell the control thread to exit */
+		ss->srb =3D NULL;
+		up(&ss->sema);
+		wait_for_completion(&ss->notify);
+
+		/* re-lock the device pointers */
+		down(&ss->dev_semaphore);
+		goto BadDevice;
+	}
+
+	/* now add the host */
+	result =3D scsi_add_host(ss->host, NULL);
+	if (result) {
+		printk(KERN_WARNING USB_STORAGE
+			"Unable to add the scsi host\n");
+
+		/* tell the control thread to exit */
+		ss->srb =3D NULL;
+		up(&ss->sema);
+		wait_for_completion(&ss->notify);
+
+		/* re-lock the device pointers */
+		down(&ss->dev_semaphore);
+		goto BadDevice;
 	}
=20
+	ss->host->hostdata[0] =3D (unsigned long)ss;
+	scsi_set_device(ss->host, &intf->dev);
+
 	printk(KERN_DEBUG=20
 	       "WARNING: USB Mass Storage data integrity not assured\n");
 	printk(KERN_DEBUG=20
@@ -1041,12 +956,11 @@
=20
 	/* we come here if there are any problems */
 	/* ss->dev_semaphore must be locked */
-	BadDevice:
+BadDevice:
 	US_DEBUGP("storage_probe() failed\n");
 	usb_stor_deallocate_urbs(ss);
 	up(&ss->dev_semaphore);
-	if (new_device)
-		kfree(ss);
+	kfree(ss);
 	return -EIO;
 }
=20
@@ -1065,9 +979,52 @@
 		return;
 	}
=20
+	/* lock device access -- no need to unlock, as we're going away */
 	down(&(ss->dev_semaphore));
+
+	/* remove the pointer to the data structure we were using */
+	(struct us_data*)ss->host->hostdata[0] =3D NULL;
+
+	/* begin SCSI host removal sequence */
+	if(scsi_remove_host(ss->host)) {
+		US_DEBUGP("-- SCSI refused to unregister\n");
+		BUG();
+		return;
+	};
+
+	/* finish SCSI host removal sequence */
+	scsi_unregister(ss->host);
+
+	/* Kill the control threads
+	 *
+	 * Enqueue the command, wake up the thread, and wait for=20
+	 * notification that it has exited.
+	 */
+	US_DEBUGP("-- sending exit command to thread\n");
+	BUG_ON(atomic_read(&ss->sm_state) !=3D US_STATE_IDLE);
+	ss->srb =3D NULL;
+	up(&(ss->sema));
+	wait_for_completion(&(ss->notify));
+
+	/* free allocated urbs */
 	usb_stor_deallocate_urbs(ss);
-	up(&(ss->dev_semaphore));
+
+	/* If there's extra data in the us_data structure then
+	 * free that first */
+	if (ss->extra) {
+		/* call the destructor routine, if it exists */
+		if (ss->extra_destructor) {
+			US_DEBUGP("-- calling extra_destructor()\n");
+			ss->extra_destructor(ss->extra);
+		}
+
+		/* destroy the extra data */
+		US_DEBUGP("-- freeing the data structure\n");
+		kfree(ss->extra);
+	}
+
+	/* free the structure itself */
+	kfree (ss);
 }
=20
 /***********************************************************************
@@ -1078,11 +1035,6 @@
 {
 	printk(KERN_INFO "Initializing USB Mass Storage driver...\n");
=20
-	/* initialize internal global data elements */
-	us_list =3D NULL;
-	init_MUTEX(&us_list_semaphore);
-	my_host_number =3D 0;
-
 	/* register the driver, return -1 if error */
 	if (usb_register(&usb_storage_driver) < 0)
 		return -1;
@@ -1094,16 +1046,16 @@
=20
 void __exit usb_stor_exit(void)
 {
-	struct us_data *next;
-
 	US_DEBUGP("usb_stor_exit() called\n");
=20
 	/* Deregister the driver
-	 * This eliminates races with probes and disconnects=20
+	 * This will cause disconnect() to be called for each
+	 * attached unit
 	 */
 	US_DEBUGP("-- calling usb_deregister()\n");
 	usb_deregister(&usb_storage_driver) ;
=20
+#if 0
 	/* While there are still virtual hosts, unregister them
 	 * Note that it's important to do this completely before removing
 	 * the structures because of possible races with the /proc
@@ -1111,7 +1063,7 @@
 	 */
 	for (next =3D us_list; next; next =3D next->next) {
 		US_DEBUGP("-- calling scsi_unregister_host()\n");
-		scsi_unregister_host(&(next->htmplt));
+		scsi_unregister_host(&usb_stor_host_template);
 	}
=20
 	/* While there are still structures, free them.  Note that we are
@@ -1137,11 +1089,12 @@
 		}
=20
 		/* free the structure itself */
-                kfree (us_list);
+		kfree (us_list);
=20
 		/* advance the list pointer */
 		us_list =3D next;
 	}
+#endif
 }
=20
 module_init(usb_stor_init);
diff -Nru a/drivers/usb/storage/usb.h b/drivers/usb/storage/usb.h
--- a/drivers/usb/storage/usb.h	Sun Jan 19 14:10:31 2003
+++ b/drivers/usb/storage/usb.h	Sun Jan 19 14:10:31 2003
@@ -52,33 +52,6 @@
 #include "scsi.h"
 #include "hosts.h"
=20
-/*=20
- * GUID definitions
- */
-
-#define GUID(x) __u32 x[3]
-#define GUID_EQUAL(x, y) (x[0] =3D=3D y[0] && x[1] =3D=3D y[1] && x[2] =3D=
=3D y[2])
-#define GUID_CLEAR(x) x[0] =3D x[1] =3D x[2] =3D 0;
-#define GUID_NONE(x) (!x[0] && !x[1] && !x[2])
-#define GUID_FORMAT "%08x%08x%08x"
-#define GUID_ARGS(x) x[0], x[1], x[2]
-
-static inline void make_guid( __u32 *pg, __u16 vendor, __u16 product, char=
 *serial)
-{
-	pg[0] =3D (vendor << 16) | product;
-	pg[1] =3D pg[2] =3D 0;
-	while (*serial) {
-		pg[1] <<=3D 4;
-		pg[1] |=3D pg[2] >> 28;
-		pg[2] <<=3D 4;
-		if (*serial >=3D 'a')
-			*serial -=3D 'a' - 'A';
-		pg[2] |=3D (*serial <=3D '9' && *serial >=3D '0') ? *serial - '0'
-			: *serial - 'A' + 10;
-		serial++;
-	}
-}
-
 struct us_data;
=20
 /*
@@ -124,8 +97,6 @@
=20
 /* we allocate one of these for every device that we remember */
 struct us_data {
-	struct us_data		*next;		 /* next device */
-
 	/* The device we're working with
 	 * It's important to note:
 	 *    (o) you must hold dev_semaphore to change pusb_dev
@@ -163,11 +134,7 @@
 	proto_cmnd		proto_handler;	 /* protocol handler	   */
=20
 	/* SCSI interfaces */
-	GUID(guid);				 /* unique dev id	*/
 	struct Scsi_Host	*host;		 /* our dummy host data */
-	Scsi_Host_Template	htmplt;		 /* own host template	*/
-	int			host_number;	 /* to find us		*/
-	int			host_no;	 /* allocated by scsi	*/
 	Scsi_Cmnd		*srb;		 /* current srb		*/
=20
 	/* thread information */
@@ -191,10 +158,6 @@
 	void			*extra;		 /* Any extra data          */
 	extra_data_destructor	extra_destructor;/* extra data destructor   */
 };
-
-/* The list of structures and the protective lock for them */
-extern struct us_data *us_list;
-extern struct semaphore us_list_semaphore;
=20
 /* The structure which defines our driver */
 extern struct usb_driver usb_storage_driver;
--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

S:  Another stupid question?
G:  There's no such thing as a stupid question, only stupid people.
					-- Stef and Greg
User Friendly, 7/15/1998

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+KyciIjReC7bSPZARApGbAJ9JAnr4SgSG2EQpEEWWo1r3N9o18QCguW7o
a1vEy+6Jga5xpynIqHMcpZk=
=zPrF
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
