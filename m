From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: [PATCH] retry HARDWARE ERROR for IBM ESS
Date: Fri, 10 Dec 2004 22:15:32 +0100
Message-ID: <OFAB4C7073.5C612549-ONC1256F66.0072A931-C1256F66.00756163@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:30343 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S261208AbULJVPX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Dec 2004 16:15:23 -0500
Received: from d12nrmr1507.megacenter.de.ibm.com (d12nrmr1507.megacenter.de.ibm.com [9.149.167.1])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id iBALFMbP147820
	for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2004 21:15:22 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1507.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id iBALFFTw115670
	for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2004 22:15:15 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id iBALFLDC008934
	for <linux-scsi@vger.kernel.org>; Fri, 10 Dec 2004 22:15:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org





James,

I did not see objections to the patch below. Please apply.

Martin


Signed-off-by: Martin Peschke <mpeschke@de.ibm.com>


diff -ur scsi-rc-fixes-2.6-ref/drivers/scsi/scsi_devinfo.c scsi-rc-fixes-2.6/drivers/scsi/scsi_devinfo.c
--- scsi-rc-fixes-2.6-ref/drivers/scsi/scsi_devinfo.c 2004-12-10 21:50:00.000000000 +0000
+++ scsi-rc-fixes-2.6/drivers/scsi/scsi_devinfo.c     2004-12-10 22:03:01.000000000 +0000
@@ -159,6 +159,7 @@
      {"HP", "C3323-300", "4269", BLIST_NOTQ},
      {"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
      {"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+     {"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
      {"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
      {"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
      {"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
diff -ur scsi-rc-fixes-2.6-ref/drivers/scsi/scsi_error.c scsi-rc-fixes-2.6/drivers/scsi/scsi_error.c
--- scsi-rc-fixes-2.6-ref/drivers/scsi/scsi_error.c   2004-12-10 21:50:00.000000000 +0000
+++ scsi-rc-fixes-2.6/drivers/scsi/scsi_error.c 2004-12-10 22:03:03.000000000 +0000
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
diff -ur scsi-rc-fixes-2.6-ref/include/scsi/scsi_devinfo.h scsi-rc-fixes-2.6/include/scsi/scsi_devinfo.h
--- scsi-rc-fixes-2.6-ref/include/scsi/scsi_devinfo.h 2004-12-10 21:50:32.000000000 +0000
+++ scsi-rc-fixes-2.6/include/scsi/scsi_devinfo.h     2004-12-10 22:03:04.000000000 +0000
@@ -27,4 +27,5 @@
 #define BLIST_NOT_LOCKABLE   0x80000     /* don't use PREVENT-ALLOW commands */
 #define BLIST_NO_ULD_ATTACH  0x100000 /* device is actually for RAID config */
 #define BLIST_SELECT_NO_ATN  0x200000 /* select without ATN */
+#define BLIST_RETRY_HWERROR  0x400000 /* retry HARDWARE_ERROR */
 #endif

