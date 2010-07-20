From: akpm@linux-foundation.org
Subject: [patch 23/27] scsi: remove private BIT macros
Date: Tue, 20 Jul 2010 15:29:03 -0700
Message-ID: <201007202229.o6KMT3v6021791@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932733Ab0GTWfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:35:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, huangj@brocade.com, robert.w.love@intel.com

From: Andrew Morton <akpm@linux-foundation.org>

A couple of scsi drivers define a BIT() macro, duplicating the one in
bitops.h.  

Cc: Jing Huang <huangj@brocade.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/bfa/include/protocol/fcp.h |    4 +---
 drivers/scsi/fnic/fnic.h                |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/bfa/include/protocol/fcp.h~scsi-remove-private-bit-macros drivers/scsi/bfa/include/protocol/fcp.h
--- a/drivers/scsi/bfa/include/protocol/fcp.h~scsi-remove-private-bit-macros
+++ a/drivers/scsi/bfa/include/protocol/fcp.h
@@ -18,6 +18,7 @@
 #ifndef __FCPPROTO_H__
 #define __FCPPROTO_H__
 
+#include <linux/bitops.h>
 #include <protocol/scsi.h>
 
 #pragma pack(1)
@@ -102,9 +103,6 @@ enum {
 /*
  * Task management flags field - only one bit shall be set
  */
-#ifndef BIT
-#define BIT(_x)	(1 << (_x))
-#endif
 enum fcp_tm_cmnd{
 	FCP_TM_ABORT_TASK_SET	= BIT(1),
 	FCP_TM_CLEAR_TASK_SET	= BIT(2),
diff -puN drivers/scsi/fnic/fnic.h~scsi-remove-private-bit-macros drivers/scsi/fnic/fnic.h
--- a/drivers/scsi/fnic/fnic.h~scsi-remove-private-bit-macros
+++ a/drivers/scsi/fnic/fnic.h
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
+#include <linux/bitops.h>
 #include <scsi/libfc.h>
 #include <scsi/libfcoe.h>
 #include "fnic_io.h"
@@ -49,7 +50,6 @@
 /*
  * Tag bits used for special requests.
  */
-#define BIT(nr)			(1UL << (nr))
 #define FNIC_TAG_ABORT		BIT(30)		/* tag bit indicating abort */
 #define FNIC_TAG_DEV_RST	BIT(29)		/* indicates device reset */
 #define FNIC_TAG_MASK		(BIT(24) - 1)	/* mask for lookup */
_
