From: rraptorr@nails.eu.org
Subject: [PATCH] Do not issue SCSI RSOC command to Promise Vtrak E610f
Date: Tue, 29 Jul 2014 22:50:40 +0200
Message-ID: <1406667040-2052-1-git-send-email-rraptorr@nails.eu.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59048 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaG2Uuo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jul 2014 16:50:44 -0400
Received: by mail-we0-f174.google.com with SMTP id x48so225935wes.33
        for <linux-scsi@vger.kernel.org>; Tue, 29 Jul 2014 13:50:41 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, Janusz Dziemidowicz <rraptorr@nails.eu.org>

From: Janusz Dziemidowicz <rraptorr@nails.eu.org>

Some devices don't like REPORT SUPPORTED OPERATION CODES and will
simply timeout causing sd_mod init to take a very very long time.
Introduce BLIST_NO_RSOC scsi scan flag, that stops RSOC from being
issued. Add it to Promise Vtrak E610f entry in scsi scan
blacklist. Fixes bug #79901 reported at
https://bugzilla.kernel.org/show_bug.cgi?id=79901

Fixes: 98dcc2946adb ("SCSI: sd: Update WRITE SAME heuristics")

Signed-off-by: Janusz Dziemidowicz <rraptorr@nails.eu.org>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/scsi_scan.c    | 6 ++++++
 include/scsi/scsi_devinfo.h | 1 +
 3 files changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index f969aca..49014a1 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -222,6 +222,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
 	{"QUANTUM", "XP34301", "1071", BLIST_NOTQ},
 	{"REGAL", "CDC-4X", NULL, BLIST_MAX5LUN | BLIST_SINGLELUN},
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e02b3aa..70919fc 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -922,6 +922,12 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_USE_10_BYTE_MS)
 		sdev->use_10_for_ms = 1;
 
+	/* some devices don't like REPORT SUPPORTED OPERATION CODES
+	 * and will simply timeout causing sd_mod init to take a very
+	 * very long time */
+	if (*bflags & BLIST_NO_RSOC)
+		sdev->no_report_opcodes = 1;
+
 	/* set the device running here so that slave configure
 	 * may do I/O */
 	ret = scsi_device_set_state(sdev, SDEV_RUNNING);
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 447d2d7..1d5ba9e 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -32,4 +32,5 @@
 #define BLIST_ATTACH_PQ3	0x1000000 /* Scan: Attach to PQ3 devices */
 #define BLIST_NO_DIF		0x2000000 /* Disable T10 PI (DIF) */
 #define BLIST_SKIP_VPD_PAGES	0x4000000 /* Ignore SBC-3 VPD pages */
+#define BLIST_NO_RSOC		0x8000000 /* don't try REPORT SUPPORTED OPERATION CODES */
 #endif
-- 
1.9.3

