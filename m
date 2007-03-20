From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] correct SCSI_WAIT_SCAN selection for non-modular SCSI_SCAN_ASYNC builds.
Date: Tue, 20 Mar 2007 11:56:32 -0700
Message-ID: <20070320185632.GB22866@dmccrory-d810.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5876 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965908AbXCTS4g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 14:56:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Commit 840c2835a1c867281d27158378a9d34f593a7664 ([SCSI] make
scsi_wait_scan always modular) broke configurations where
SCSI_SCAN_ASYNC is selected for non-modular builds.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f3bc0f4..eb25abe 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -226,6 +226,7 @@ config SCSI_LOGGING
 config SCSI_SCAN_ASYNC
 	bool "Asynchronous SCSI scanning"
 	depends on SCSI
+	select SCSI_WAIT_SCAN
 	help
 	  The SCSI subsystem can probe for devices while the rest of the
 	  system continues booting, and even probe devices on different

