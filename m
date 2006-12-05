From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Tue, 5 Dec 2006 15:52:07 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>
References: <1165266433.3242.63.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43782 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031341AbWLEUwL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 15:52:11 -0500
In-Reply-To: <1165266433.3242.63.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joerg Schilling <schilling@fokus.fraunhofer.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

I decided to do this by email instead of bugzilla so that it would be 
visible to everyone on the linux-scsi mailing list.

Re: http://bugzilla.kernel.org/show_bug.cgi?id=7026

To recap: Joerg Schilling needs to be able to retrieve the max_sectors 
value for a SCSI device's request queue.  Doing it via sysfs is rather 
clumsy, especially when only a file descriptor is available and not the 
device name.  He has asked for an ioctl interface to provide the 
information.

Is the patch below acceptable?

Alan Stern



Index: usb-2.6/block/scsi_ioctl.c
===================================================================
--- usb-2.6.orig/block/scsi_ioctl.c
+++ usb-2.6/block/scsi_ioctl.c
@@ -97,6 +97,11 @@ static int sg_set_reserved_size(request_
 	return 0;
 }
 
+static int sg_get_max_transfer_length(request_queue_t *q, int __user *p)
+{
+	return put_user(q->max_sectors << 9, p);
+}
+
 /*
  * will always return that we are ATAPI even for a real SCSI drive, I'm not
  * so sure this is worth doing anything about (why would you care??)
@@ -558,6 +563,9 @@ int scsi_cmd_ioctl(struct file *file, st
 		case SG_SET_RESERVED_SIZE:
 			err = sg_set_reserved_size(q, arg);
 			break;
+		case SG_GET_MAX_TRANSFER_LENGTH:
+			err = sg_get_max_transfer_length(q, arg);
+			break;
 		case SG_EMULATED_HOST:
 			err = sg_emulated_host(q, arg);
 			break;
Index: usb-2.6/drivers/scsi/sg.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sg.c
+++ usb-2.6/drivers/scsi/sg.c
@@ -927,6 +927,11 @@ sg_ioctl(struct inode *inode, struct fil
 	case SG_GET_RESERVED_SIZE:
 		val = (int) sfp->reserve.bufflen;
 		return put_user(val, ip);
+	case SG_GET_MAX_TRANSFER_LENGTH:
+		if (sdp->detached || !sdp->device->request_queue)
+			return -ENODEV;
+		val = sdp->device->request_queue->max_sectors << 9;
+		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
 		result = get_user(val, ip);
 		if (result)
Index: usb-2.6/include/scsi/sg.h
===================================================================
--- usb-2.6.orig/include/scsi/sg.h
+++ usb-2.6/include/scsi/sg.h
@@ -219,6 +219,8 @@ typedef struct sg_req_info { /* used by 
 /* yields scsi midlevel's access_count for this SCSI device */
 #define SG_GET_ACCESS_COUNT 0x2289  
 
+/* Yields the SCSI device queue's max_sector value, in bytes */
+#define SG_GET_MAX_TRANSFER_LENGTH 0x228a
 
 #define SG_SCATTER_SZ (8 * 4096)
 /* Largest size (in bytes) a single scatter-gather list element can have.

