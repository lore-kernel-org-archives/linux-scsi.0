From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_device proc printing from drivers
Date: Sun, 27 Apr 2003 18:56:28 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427185628.A30233@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:55565 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263220AbTD0QoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 12:44:15 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

A bunch of drivers contain loops over host->my_devices in their
proc_info method just to printout info we already get from sysfs.
Kill those, the ones that actually add additional information
from their private data need to get sysfs attributes for the fist.

BTW, does someone have opintions on reading of /proc/scsi/scsi?
It's just a duplication of the sysfs tree so it should probably
go away also.  OTOH there's a slightly higher chance on userland
actually using this than for the LLDDs..

--- 1.25/drivers/acorn/scsi/acornscsi.c	Wed Mar 19 10:19:28 2003
+++ edited/drivers/acorn/scsi/acornscsi.c	Sun Apr 27 09:12:47 2003
@@ -2935,37 +2935,6 @@
 	}
     }
 
-    p += sprintf(p, "\nAttached devices:\n");
-
-    list_for_each_entry(scd, &instance->my_devices, siblings) {
-	int len;
-
-	proc_print_scsidevice(scd, p, &len, 0);
-	p += len;
-
-	p += sprintf(p, "Extensions: ");
-
-	if (scd->tagged_supported)
-	    p += sprintf(p, "TAG %sabled [%d] ",
-			  scd->tagged_queue ? "en" : "dis", scd->current_tag);
-	p += sprintf(p, "\nTransfers: ");
-	if (host->device[scd->id].sync_xfer & 15)
-	    p += sprintf(p, "sync, offset %d, %d ns\n",
-			  host->device[scd->id].sync_xfer & 15,
-			  acornscsi_getperiod(host->device[scd->id].sync_xfer));
-	else
-	    p += sprintf(p, "async\n");
-
-	pos = p - buffer;
-	if (pos + begin < offset) {
-	    begin += pos;
-	    p = buffer;
-	}
-	pos = p - buffer;
-	if (pos + begin > offset + length)
-	    break;
-    }
-
     pos = p - buffer;
 
     *start = buffer + (offset - begin);
--- 1.22/drivers/acorn/scsi/cumana_2.c	Sun Jan 26 14:34:36 2003
+++ edited/drivers/acorn/scsi/cumana_2.c	Sun Apr 27 09:12:47 2003
@@ -380,26 +380,6 @@
 
 	pos += sprintf(buffer+pos, "\nAttached devices:\n");
 
-	list_for_each_entry(scd, &host->my_devices, siblings) {
-		int len;
-
-		proc_print_scsidevice(scd, buffer, &len, pos);
-		pos += len;
-		pos += sprintf(buffer+pos, "Extensions: ");
-		if (scd->tagged_supported)
-			pos += sprintf(buffer+pos, "TAG %sabled [%d] ",
-				       scd->tagged_queue ? "en" : "dis",
-				       scd->current_tag);
-		pos += sprintf(buffer+pos, "\n");
-
-		if (pos + begin < offset) {
-			begin += pos;
-			pos = 0;
-		}
-		if (pos + begin > offset + length)
-			break;
-	}
-
 	*start = buffer + (offset - begin);
 	pos -= offset - begin;
 	if (pos > length)
--- 1.22/drivers/acorn/scsi/eesox.c	Sun Jan 26 14:34:36 2003
+++ edited/drivers/acorn/scsi/eesox.c	Sun Apr 27 09:12:47 2003
@@ -452,25 +452,6 @@
 
 	pos += fas216_print_stats(&info->info, buffer + pos);
 
-	pos += sprintf(buffer+pos, "\nAttached devices:\n");
-
-	list_for_each_entry(scd, &host->my_devices, siblings) {
-		int len;
-
-		proc_print_scsidevice(scd, buffer, &len, pos);
-		pos += len;
-		pos += sprintf(buffer+pos, "Extensions: ");
-		if (scd->tagged_supported)
-			pos += sprintf(buffer+pos, "TAG %sabled [%d] ",
-					scd->tagged_queue ? "en" : "dis",
-					scd->current_tag);
-		pos += sprintf (buffer+pos, "\n");
-
-		if (pos + begin < offset) {
-			begin += pos;
-			pos = 0;
-		}
-	}
 	*start = buffer + (offset - begin);
 	pos -= offset - begin;
 	if (pos > length)
--- 1.28/drivers/ieee1394/sbp2.c	Mon Apr 21 12:30:57 2003
+++ edited/drivers/ieee1394/sbp2.c	Sun Apr 27 09:15:05 2003
@@ -3018,7 +3018,6 @@
 static int sbp2scsi_proc_info(char *buffer, char **start, off_t offset,
 			      int length, int hostno, int inout)
 {
-	Scsi_Device *scd;
 	struct Scsi_Host *host;
 	struct sbp2scsi_host_info *hi;
 	char *pos = buffer;
@@ -3044,30 +3043,6 @@
 	SPRINTF("  max_sectors          : %d\n", max_sectors);
 	SPRINTF("  serialize_io         : %s\n", serialize_io ? "yes" : "no");
 	SPRINTF("  exclusive_login      : %s\n", exclusive_login ? "yes" : "no");
-
-	SPRINTF("\nAttached devices       : %s\n", !list_empty(&host->my_devices) ?
-		"" : "none");
-
-	list_for_each_entry (scd, &host->my_devices, siblings) {
-		int i;
-
-		SPRINTF("  [Channel: %02d, Id: %02d, Lun: %02d]  ", scd->channel,
-			scd->id, scd->lun);
-		SPRINTF("%s ", (scd->type < MAX_SCSI_DEVICE_CODE) ?
-			scsi_device_types[(short) scd->type] : "Unknown device");
-
-		for (i = 0; (i < 8) && (scd->vendor[i] >= 0x20); i++)
-			SPRINTF("%c", scd->vendor[i]);
-
-		SPRINTF(" ");
-
-		for (i = 0; (i < 16) && (scd->model[i] >= 0x20); i++)
-			SPRINTF("%c", scd->model[i]);
-
-		SPRINTF("\n");
-	}
-
-	SPRINTF("\n");
 
 	/* release the reference count on this host */
 	scsi_host_put(host);
--- 1.22/drivers/scsi/wd7000.c	Sat Apr 26 10:28:29 2003
+++ edited/drivers/scsi/wd7000.c	Sun Apr 27 09:12:47 2003
@@ -1450,27 +1450,6 @@
 	SPRINTF(count ? "\n" : "none\n");
 #endif
 
-	/*
-	 * Display driver information for each device attached to the board.
-	 */
-	SPRINTF("\nAttached devices: %s\n", !list_empty(&host->my_devices) ?
-		       	"" : "none");
-
-	list_for_each_entry (scd, &host->my_devices, siblings) {
-		SPRINTF("  [Channel: %02d, Id: %02d, Lun: %02d]  ", scd->channel, scd->id, scd->lun);
-		SPRINTF("%s ", (scd->type < MAX_SCSI_DEVICE_CODE) ? scsi_device_types[(short) scd->type] : "Unknown device");
-
-		for (i = 0; (i < 8) && (scd->vendor[i] >= 0x20); i++)
-			SPRINTF("%c", scd->vendor[i]);
-		SPRINTF(" ");
-
-		for (i = 0; (i < 16) && (scd->model[i] >= 0x20); i++)
-			SPRINTF("%c", scd->model[i]);
-		SPRINTF("\n");
-	}
-
-	SPRINTF("\n");
-
 	spin_unlock_irqrestore(host->host_lock, flags);
 
 	/*
