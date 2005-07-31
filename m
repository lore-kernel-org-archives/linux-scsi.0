From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] Documentation/scsi: a word of warning about
 scsi_block_requests()
Date: Mon, 1 Aug 2005 01:31:30 +0200 (CEST)
Message-ID: <200507312331.j6VNVV6B009929@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:31720 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S262084AbVGaXbj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 31 Jul 2005 19:31:39 -0400
Received: from s5r6.in-berlin.de ([62.180.98.151])
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id j6VNVV6B009929
	for <linux-scsi@vger.kernel.org>; Mon, 1 Aug 2005 01:31:36 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Document a pitfall of scsi_block_requests() and hot-unplugging.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

diff -rU 5 linux-2.6.13-rc4.orig/Documentation/scsi/scsi_mid_low_api.txt linux-2.6.13-rc4/Documentation/scsi/scsi_mid_low_api.txt
--- linux-2.6.13-rc4.orig/Documentation/scsi/scsi_mid_low_api.txt	2005-07-29 00:44:44.000000000 +0200
+++ linux-2.6.13-rc4/Documentation/scsi/scsi_mid_low_api.txt	2005-08-01 01:27:41.000000000 +0200
@@ -224,10 +224,13 @@
 scsi_remove_device() -------+
                             |
                      slave_destroy()
 ------------------------------------------------------------
 
+scsi_remove_device() may hang if the device's host was blocked by
+scsi_block_requests(), so take care that it is unblocked.
+
 It may be useful for an LLD to keep track of struct scsi_device instances
 (a pointer is passed as the parameter to slave_alloc() and
 slave_configure() callbacks). Such instances are "owned" by the mid-level.
 struct scsi_device instances are freed after slave_destroy().
 

