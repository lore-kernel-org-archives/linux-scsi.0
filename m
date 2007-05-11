From: akpm@linux-foundation.org
Subject: [patch 14/28] scsi: fix CONFIG_SCSI_WAIT_SCAN=m
Date: Thu, 10 May 2007 23:00:57 -0700
Message-ID: <200705110600.l4B60vwX008157@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758386AbXEKGB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:01:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, hugh@veritas.com

From: Hugh Dickins <hugh@veritas.com>

CONFIG_MODULES=y
CONFIG_SCSI=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2, but boots
okay if I change drivers/scsi/Kconfig to "default y" instead of "default m"
for SCSI_WAIT_SCAN.

Make sure there's a late_initcall to scsi_complete_async_scans when it's
built in, so a monolithic SCSI_SCAN_ASYNC kernel can rely on the scans
being completed before trying to mount root, even if they're slow.

[akpm@linux-foundation.org: build fixes]
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
---
James sayeth "This isn't the right fix ...  this has to be invoked last in the
call sequence ...  I can't see another way of doing this except yet another
file added as a final component to the link."
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/scsi/scsi_scan.c~scsi-fix-config_scsi_wait_scan=m drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-fix-config_scsi_wait_scan=m
+++ a/drivers/scsi/scsi_scan.c
@@ -184,6 +184,15 @@ int scsi_complete_async_scans(void)
 /* Only exported for the benefit of scsi_wait_scan */
 EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
 
+#ifndef MODULE
+/*
+ * For async scanning we need to wait for all the scans to complete before
+ * trying to mount the root fs.  Otherwise non-modular drivers may not be ready
+ * yet.
+ */
+late_initcall(scsi_complete_async_scans);
+#endif
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sdev:	scsi device to send command to
_
