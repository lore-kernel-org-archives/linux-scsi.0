From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: fix memory leak in scan_scsis_single
Date: Sun, 26 Oct 2003 19:23:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031027002304.GB19172@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gn78-101.ma.emulex.com ([138.239.78.101]:19862 "EHLO
	wintermute.ma.emulex.com") by vger.kernel.org with ESMTP
	id S263702AbTJ0AXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Oct 2003 19:23:05 -0500
Received: from wintermute.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by wintermute.ma.emulex.com (8.12.8/8.12.8) with ESMTP id h9R0N4ZW019649
	for <linux-scsi@vger.kernel.org>; Sun, 26 Oct 2003 19:23:04 -0500
Received: (from jamesw@localhost)
	by wintermute.ma.emulex.com (8.12.8/8.12.8/Submit) id h9R0N4Of019647
	for linux-scsi@vger.kernel.org; Sun, 26 Oct 2003 19:23:04 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There is a memory leak in the scan_scsis_single function in
2.4.23-pre8 (and previous): the scsi_release_commandblocks function is
not called when a SCSI target ID is probed, but no device exists
there.  (So a scsi host driver which supports 256 target IDs but only
has 1 attached will hit this code 255 times when it loads.)

This following small patch fixes this leak.

Thanks,
Jamie Wellnitz
Jamie.Wellnitz@emulex.com

--- drivers/scsi/scsi_scan.c.orig	2003-10-26 19:07:45.896336017 -0500
+++ drivers/scsi/scsi_scan.c	2003-10-26 19:12:08.411006676 -0500
@@ -619,6 +619,7 @@
 			/* not-ready to ready transition - good */
 		} else {
 			/* assume no peripheral if any other sort of error */
+			scsi_release_commandblocks(SDpnt);
 			scsi_release_request(SRpnt);
 			return 0;
 		}
