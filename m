From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH as468] Retry supposedly "unrecoverable" hardware errors
Date: Wed, 16 Feb 2005 11:53:48 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0502161144170.6418-100000@ida.rowland.org>
References: <20050216143714.GA11363@kassiopeia.juls.savba.sk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from ida.rowland.org ([192.131.102.52]:11780 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S262076AbVBPQxt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2005 11:53:49 -0500
In-Reply-To: <20050216143714.GA11363@kassiopeia.juls.savba.sk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Martin Peschke <mpeschke@de.ibm.com>, Radovan Garabik <garabik@kassiopeia.juls.savba.sk>, SCSI development list <linux-scsi@vger.kernel.org>

James:

This is an updated and unmangled version of the patch sent in by Martin 
Peschke.  Apparently some drives report Hardware Error sense for 
problems which do improve after retrying, so the patch retries these 
supposedly "unrecoverable" errors for such devices.

In addition to the IBM ESS drive it adds a blacklist entry for the drive
inside the MPIO HS200 Gigabox.

Alan Stern



Signed-off-by: Martin Peschke <mpeschke@de.ibm.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

===== include/scsi/scsi_devinfo.h 1.7 vs edited =====
--- 1.7/include/scsi/scsi_devinfo.h	2004-10-05 11:25:13 -04:00
+++ edited/include/scsi/scsi_devinfo.h	2005-02-11 13:21:51 -05:00
@@ -27,4 +27,5 @@
 #define BLIST_NOT_LOCKABLE	0x80000	/* don't use PREVENT-ALLOW commands */
 #define BLIST_NO_ULD_ATTACH	0x100000 /* device is actually for RAID config */
 #define BLIST_SELECT_NO_ATN	0x200000 /* select without ATN */
+#define BLIST_RETRY_HWERROR	0x400000 /* retry HARDWARE_ERROR */
 #endif
===== drivers/scsi/scsi_devinfo.c 1.14 vs edited =====
--- 1.14/drivers/scsi/scsi_devinfo.c	2004-12-10 11:54:56 -05:00
+++ edited/drivers/scsi/scsi_devinfo.c	2005-02-11 13:25:41 -05:00
@@ -159,6 +159,7 @@
 	{"HP", "C3323-300", "4269", BLIST_NOTQ},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
@@ -192,6 +193,7 @@
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
+	{"ST650211", "CF", NULL, BLIST_RETRY_HWERROR},
 	{"SUN", "T300", "*", BLIST_SPARSELUN},
 	{"SUN", "T4", "*", BLIST_SPARSELUN},
 	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
===== drivers/scsi/scsi_error.c 1.47 vs edited =====
--- 1.47/drivers/scsi/scsi_error.c	2005-02-02 21:56:01 -05:00
+++ edited/drivers/scsi/scsi_error.c	2005-02-11 13:23:45 -05:00
@@ -31,6 +31,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_request.h>
+#include <scsi/scsi_devinfo.h>
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -350,10 +351,18 @@
 	case MEDIUM_ERROR:
 		return NEEDS_RETRY;
 
+	case HARDWARE_ERROR:
+		if (scsi_get_device_flags(scmd->device,
+					scmd->device->vendor,
+					scmd->device->model)
+				& BLIST_RETRY_HWERROR)
+			return NEEDS_RETRY;
+		else
+			return SUCCESS;
+
 	case ILLEGAL_REQUEST:
 	case BLANK_CHECK:
 	case DATA_PROTECT:
-	case HARDWARE_ERROR:
 	default:
 		return SUCCESS;
 	}

