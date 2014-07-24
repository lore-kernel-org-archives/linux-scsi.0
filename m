From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 79901] Extremely slow boot on Promise VTrak E610f due to
 sd_mod RSOC usage
Date: Thu, 24 Jul 2014 08:28:38 -0700
Message-ID: <20140724152838.GA1533@infradead.org>
References: <bug-79901-11613@https.bugzilla.kernel.org/>
 <bug-79901-11613-LvEuXu4SmD@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55742 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbaGXP2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2014 11:28:39 -0400
Content-Disposition: inline
In-Reply-To: <bug-79901-11613-LvEuXu4SmD@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rraptorr@nails.eu.org
Cc: linux-scsi@vger.kernel.org

Thanks, this one looks good to me.  Can someone else give me a second
review on the attached patch so I can merged it?

---
>From 95bc83fa0d6e9a6152cd6fce79ff87c0994e83ed Mon Sep 17 00:00:00 2001
From: Janusz Dziemidowicz <rraptorr@nails.eu.org>
Date: Thu, 24 Jul 2014 15:48:46 +0200
Subject: [PATCH] Do not issue SCSI RSOC command to Promise Vtrak E610f

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

