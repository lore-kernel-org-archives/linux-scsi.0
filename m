From: Rob Landley <rob@landley.net>
Subject: [PATCH 10/15] Update kerneldoc comments in drivers/scsi/scsi_scan.c
Date: Fri, 26 Oct 2007 23:14:13 -0500
Message-ID: <200710262314.13731.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35984
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751542AbXJ0DOa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:14:30 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 0152373938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:17:13 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_scan.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_scan.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff -r a868e8217782 drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_scan.c	Fri Oct 26 22:44:43 2007 -0500
@@ -221,6 +221,9 @@ static void scsi_unlock_floptical(struct
 
 /**
  * scsi_alloc_sdev - allocate and setup a scsi_Device
+ * @starget: which target to allocate a &scsi_device for
+ * @lun: which lun
+ * @hostdata: usually NULL and set by ->slave_alloc instead
  *
  * Description:
  *     Allocate, initialize for io, and return a pointer to a scsi_Device.
@@ -954,9 +957,10 @@ static unsigned char *scsi_inq_str(unsig
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
  * @starget:	pointer to target device structure
  * @lun:	LUN of target device
- * @sdevscan:	probe the LUN corresponding to this scsi_device
- * @sdevnew:	store the value of any new scsi_device allocated
  * @bflagsp:	store bflags here if not NULL
+ * @sdevp:	probe the LUN corresponding to this scsi_device
+ * @rescan:     if nonzero skip some code only needed on first scan
+ * @hostdata:	passed to scsi_alloc_sdev()
  *
  * Description:
  *     Call scsi_probe_lun, if a LUN with an attached device is found,
@@ -1107,6 +1111,8 @@ static int scsi_probe_and_add_lun(struct
  * scsi_sequential_lun_scan - sequentially scan a SCSI target
  * @starget:	pointer to target structure to scan
  * @bflags:	black/white list flag for LUN 0
+ * @scsi_level: Which version of the standard does this device adhere to
+ * @rescan:     passed to scsi_probe_add_lun()
  *
  * Description:
  *     Generally, scan from LUN 1 (LUN 0 is assumed to already have been
@@ -1217,7 +1223,7 @@ EXPORT_SYMBOL(scsilun_to_int);
 
 /**
  * int_to_scsilun: reverts an int into a scsi_lun
- * @int:        integer to be reverted
+ * @lun:        integer to be reverted
  * @scsilun:	struct scsi_lun to be set.
  *
  * Description:
@@ -1249,18 +1255,22 @@ EXPORT_SYMBOL(int_to_scsilun);
 
 /**
  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
- * @sdevscan:	scan the host, channel, and id of this scsi_device
+ * @starget: which target
+ * @bflags: Zero or a mix of BLIST_NOLUN, BLIST_REPORTLUN2, or BLIST_NOREPORTLUN
+ * @rescan: nonzero if we can skip code only needed on first scan
  *
  * Description:
- *     If @sdevscan is for a SCSI-3 or up device, send a REPORT LUN
- *     command, and scan the resulting list of LUNs by calling
- *     scsi_probe_and_add_lun.
- *
- *     Modifies sdevscan->lun.
+ *   Fast scanning for modern (SCSI-3) devices by sending a REPORT LUN command.
+ *   Scan the resulting list of LUNs by calling scsi_probe_and_add_lun.
+ *
+ *   If BLINK_REPORTLUN2 is set, scan a target that supports more than 8
+ *   LUNs even if it's older than SCSI-3.
+ *   If BLIST_NOREPORTLUN is set, return 1 always.
+ *   If BLIST_NOLUN is set, return 0 always.
  *
  * Return:
  *     0: scan completed (or no memory, so further scanning is futile)
- *     1: no report lun scan, or not configured
+ *     1: could not scan with REPORT LUN
  **/
 static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 				int rescan)

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
