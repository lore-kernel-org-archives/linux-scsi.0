From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] scsi: aha152x: Remove residual AHA152X_DEBUG references
Date: Tue, 28 Apr 2015 15:55:52 -0400
Message-ID: <1430250952-19889-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030978AbbD1Tzx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Apr 2015 15:55:53 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 7CC8E8EAE3
	for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2015 19:55:53 +0000 (UTC)
Received: from emilne.csb (dhcp-25-104.bos.redhat.com [10.18.25.104])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id t3SJtqqT018683
	for <linux-scsi@vger.kernel.org>; Tue, 28 Apr 2015 15:55:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Commit f75ae8ed.. ("aha152x: debug output update and whitespace cleanup")
removed all AHA152X_DEBUG code from aha152x.c, so the build option no longer
does anything useful.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 Documentation/scsi/aha152x.txt |  3 ---
 drivers/scsi/aha152x.h         | 22 ----------------------
 2 files changed, 25 deletions(-)

diff --git a/Documentation/scsi/aha152x.txt b/Documentation/scsi/aha152x.txt
index 9484873..248dde1 100644
--- a/Documentation/scsi/aha152x.txt
+++ b/Documentation/scsi/aha152x.txt
@@ -40,9 +40,6 @@ COMPILE TIME CONFIGURATION (go into AHA152X in drivers/scsi/Makefile):
 -DSETUP1="{ IOPORT, IRQ, SCSI_ID, RECONNECT, PARITY, SYNCHRONOUS, DELAY, EXT_TRANS }"
  override for the second controller
 
--DAHA152X_DEBUG
- enable debugging output
-
 -DAHA152X_STAT
  enable some statistics
 
diff --git a/drivers/scsi/aha152x.h b/drivers/scsi/aha152x.h
index ac4bfa438b..1addbe6 100644
--- a/drivers/scsi/aha152x.h
+++ b/drivers/scsi/aha152x.h
@@ -294,25 +294,6 @@ typedef union {
 
 #define SETRATE(RATE)		SETPORT(SCSIRATE,(RATE) & 0x7f)
 
-#if defined(AHA152X_DEBUG)
-enum {
-  debug_procinfo  = 0x0001,
-  debug_queue     = 0x0002,
-  debug_locking   = 0x0004,
-  debug_intr      = 0x0008,
-  debug_selection = 0x0010,
-  debug_msgo      = 0x0020,
-  debug_msgi      = 0x0040,
-  debug_status    = 0x0080,
-  debug_cmd       = 0x0100,
-  debug_datai     = 0x0200,
-  debug_datao     = 0x0400,
-  debug_eh	  = 0x0800,
-  debug_done      = 0x1000,
-  debug_phases    = 0x2000,
-};
-#endif
-
 /* for the pcmcia stub */
 struct aha152x_setup {
 	int io_port;
@@ -324,9 +305,6 @@ struct aha152x_setup {
 	int delay;
 	int ext_trans;
 	int tc1550;
-#if defined(AHA152X_DEBUG)
-	int debug;
-#endif
 	char *conf;
 };
 
-- 
2.1.0

