From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: [PATCH] retry HARDWARE ERROR for IBM ESS (using BLIST)
Date: Fri, 26 Nov 2004 17:42:15 +0100
Message-ID: <OF4EF7026A.98AD4B65-ONC1256F58.00451604-C1256F58.005C5C9E@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:62401 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S262303AbUKZTUS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2004 14:20:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org





> please don't hardcode models deep inside the scsu layer.
> Add a new blacklist flags and set it from the table in
> scsi_devinfo.c
right - patch is below

Here again the patch descrition:
Under certain conditions IBM's Enterprise Storage Server returns sense data
HARDWARE ERROR - INTERNAL TARGET FAILURE, while it wants the OS
to retry the very command.
Although this is apparently a firmware issue (ABORTED COMMAND would be
an appropriate choice), a Linux workaround would be needed to handle it.
It doesn't look like we'll ever get hold of a firmware fix for the model
addressed
by the patch below.


Martin

Signed-off-by: Martin Peschke <mpeschke@de.ibm.com>

===== drivers/scsi/scsi_devinfo.c 1.30 vs edited =====
--- 1.30/drivers/scsi/scsi_devinfo.c      Sat Nov 13 21:40:51 2004
+++ edited/drivers/scsi/scsi_devinfo.c    Fri Nov 26 13:45:14 2004
@@ -158,6 +158,7 @@
      {"HP", "C3323-300", "4269", BLIST_NOTQ},
      {"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
      {"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+     {"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
      {"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
      {"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
      {"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
===== drivers/scsi/scsi_error.c 1.83 vs edited =====
--- 1.83/drivers/scsi/scsi_error.c  Fri Sep 10 22:03:06 2004
+++ edited/drivers/scsi/scsi_error.c      Fri Nov 26 13:45:14 2004
@@ -31,6 +31,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_request.h>
+#include <scsi/scsi_devinfo.h>

 #include "scsi_priv.h"
 #include "scsi_logging.h"
@@ -325,10 +326,18 @@
      case MEDIUM_ERROR:
            return NEEDS_RETRY;

+     case HARDWARE_ERROR:
+           if (scsi_get_device_flags(scmd->device,
+                               scmd->device->vendor,
+                               scmd->device->model)
+               & BLIST_RETRY_HWERROR)
+                 return NEEDS_RETRY;
+           else
+                 return SUCCESS;
+
      case ILLEGAL_REQUEST:
      case BLANK_CHECK:
      case DATA_PROTECT:
-     case HARDWARE_ERROR:
      default:
            return SUCCESS;
      }
===== include/scsi/scsi_devinfo.h 1.9 vs edited =====
--- 1.9/include/scsi/scsi_devinfo.h Tue Oct  5 15:25:13 2004
+++ edited/include/scsi/scsi_devinfo.h    Fri Nov 26 13:46:22 2004
@@ -27,4 +27,5 @@
 #define BLIST_NOT_LOCKABLE   0x80000     /* don't use PREVENT-ALLOW commands */
 #define BLIST_NO_ULD_ATTACH  0x100000 /* device is actually for RAID config */
 #define BLIST_SELECT_NO_ATN  0x200000 /* select without ATN */
+#define BLIST_RETRY_HWERROR  0x400000 /* retry HARDWARE_ERROR */
 #endif

