From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH/RFC] scsi sync caches w/ dev offline
Date: Mon, 21 Oct 2002 00:49:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021021074925.GC3197@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e34.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g9L7m75Q032048
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2002 03:48:07 -0400
Received: from hmsbounty (sig-9-65-19-52.mts.ibm.com [9.65.19.52])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g9L7m63A251884
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2002 01:48:07 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When a scsi device is offlined and then the system is shutdown it will
hang during the synchronizing SCSI caches task. The error handler was
activated during this step, but post recovery the system did not
complete the shutdown. 

This patch just adds a check for online before sending the command. The
better approach appeared to be to use scsi_block_when_processing_errors,
but I was concerned that we might block to long in a shutdown case.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 sd.c |    3 +++
 1 files changed, 3 insertions(+)
-----

===== drivers/scsi/sd.c 1.73 vs edited =====
--- 1.73/drivers/scsi/sd.c	Fri Oct 18 13:32:54 2002
+++ edited/drivers/scsi/sd.c	Mon Oct 21 00:03:06 2002
@@ -1567,6 +1567,9 @@
 	Scsi_Device *SDpnt = sdkp->device;
 	int retries, the_result;
 
+	if (!SDpnt->online)
+		return 0;
+
 	if(verbose) {
 		char buf[16];
 
