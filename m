From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: virtual_gb ignores sector_size
Date: Sun, 25 Apr 2010 12:30:23 +0200
Message-ID: <4BD419BF.4040109@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050107060102000801070100"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:55658 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab0DYKa2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Apr 2010 06:30:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, SCSI development list <linux-scsi@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

This is a multi-part message in MIME format.
--------------050107060102000801070100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

In the scsi_debug driver, the virtual_gb option
ignores the sector_size, implicitly assuming
that is 512 bytes.
So if 'virtual_gb=1 sector_size=4096' the result is
an 8 GB (virtual) disk.

ChangeLog:
   - correct get_sdebug_capacity() calculation of
     sectors when virtual_gb option is used. Needs
     to take into account sector_size.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------050107060102000801070100
Content-Type: text/x-patch;
 name="sdebug_vgig_ss1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug_vgig_ss1.patch"

--- linux/drivers/scsi/scsi_debug.c	2010-03-24 20:13:03.000000000 +0100
+++ linux/drivers/scsi/scsi_debug.c2633mqnu2ss	2010-04-25 12:03:50.000000000 +0200
@@ -58,7 +58,7 @@
 #include "scsi_logging.h"
 
 #define SCSI_DEBUG_VERSION "1.82"
-static const char * scsi_debug_version_date = "20100324";
+static const char * scsi_debug_version_date = "20100425";
 
 /* Additional Sense Code (ASC) */
 #define NO_ADDITIONAL_SENSE 0x0
@@ -961,7 +961,8 @@ static int resp_start_stop(struct scsi_c
 static sector_t get_sdebug_capacity(void)
 {
 	if (scsi_debug_virtual_gb > 0)
-		return 2048 * 1024 * (sector_t)scsi_debug_virtual_gb;
+		return (sector_t)scsi_debug_virtual_gb *
+			(1073741824 / scsi_debug_sector_size);
 	else
 		return sdebug_store_sectors;
 }

--------------050107060102000801070100--
