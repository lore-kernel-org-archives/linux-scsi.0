From: James.Smart@Emulex.Com
Subject: [Patch 2.4] Fix memory leaks in scsi_scan.c
Date: Tue, 2 Nov 2004 11:50:46 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C08684D@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53714 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262002AbUKBQus convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Nov 2004 11:50:48 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id iA2GolgI005754
	for <linux-scsi@vger.kernel.org>; Tue, 2 Nov 2004 08:50:47 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In module load/unload testing for 2.4, one of our engineers reported memory leaks, and has the following patch that resolves it.

-- James S



--- linux-2.4.28-rc1/drivers/scsi/scsi_scan.c	2004-11-02 11:00:31.000000000 -0500
+++ linux-2.4.28-rc1-fixmemleak/drivers/scsi/scsi_scan.c	2004-11-02 11:04:42.271444392 -0500
@@ -535,6 +535,7 @@
 
 	/* Last device block does not exist.  Free memory. */
 	if (SDpnt != NULL) {
+		scsi_release_commandblocks(SDpnt);
 		blk_cleanup_queue(&SDpnt->request_queue);
 		kfree((char *) SDpnt);
 	}
@@ -686,6 +687,7 @@
 	 */
 	if ((scsi_result[0] >> 5) == 3) {
 		scsi_release_request(SRpnt);
+		scsi_release_commandblocks(SDpnt);
 		return 0;	/* assume no peripheral if any sort of error */
 	}
 	 /*   The Toshiba ROM was "gender-changed" here as an inline hack.
@@ -719,7 +721,6 @@
 	SDpnt->changed = 0;
 	SDpnt->access_count = 0;
 	SDpnt->busy = 0;
-	SDpnt->has_cmdblocks = 0;
 	/*
 	 * Currently, all sequential devices are assumed to be tapes, all random
 	 * devices disk, with the appropriate read only flags set for ROM / WORM
