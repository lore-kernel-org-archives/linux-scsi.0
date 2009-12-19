From: Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH] scsi/libfc: Clean up hard coded array size calculation.
Date: Sat, 19 Dec 2009 18:26:16 -0500
Message-ID: <1261265176-5241-1-git-send-email-tfransosi@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:39909 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZLSX03 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2009 18:26:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: James.Bottomley@suse.de, robert.w.love@intel.com, vasu.dev@intel.com, jeykholt@cisco.com, linux-scsi@vger.kernel.org

Use ARRAY_SIZE macro from kernel.h api instead.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/scsi/libfc/fc_exch.c  |    9 ++++-----
 drivers/scsi/libfc/fc_lport.c |    3 ++-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index c1c1574..b65652a 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -23,9 +23,10 @@
  * Fibre Channel exchange and sequence handling.
  */
 
-#include <linux/timer.h>
-#include <linux/gfp.h>
 #include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/timer.h>
 
 #include <scsi/fc/fc_fc2.h>
 
@@ -194,8 +195,6 @@ static struct fc_seq *fc_seq_start_next_locked(struct fc_seq *sp);
  */
 static char *fc_exch_rctl_names[] = FC_RCTL_NAMES_INIT;
 
-#define FC_TABLE_SIZE(x)   (sizeof(x) / sizeof(x[0]))
-
 static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
 					      unsigned int max_index)
 {
@@ -211,7 +210,7 @@ static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
 static const char *fc_exch_rctl_name(unsigned int op)
 {
 	return fc_exch_name_lookup(op, fc_exch_rctl_names,
-				   FC_TABLE_SIZE(fc_exch_rctl_names));
+				   ARRAY_SIZE(fc_exch_rctl_names));
 }
 
 /*
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index bd2f771..98b4eaf 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -87,6 +87,7 @@
  * (i.e. _enter_* function).
  */
 
+#include <linux/kernel.h>
 #include <linux/timer.h>
 #include <asm/unaligned.h>
 
@@ -1137,7 +1138,7 @@ static void fc_lport_enter_rft_id(struct fc_lport *lport)
 	fc_lport_state_enter(lport, LPORT_ST_RFT_ID);
 
 	lps = &lport->fcts;
-	i = sizeof(lps->ff_type_map) / sizeof(lps->ff_type_map[0]);
+	i = ARRAY_SIZE(lps->ff_type_map);
 	while (--i >= 0)
 		if (ntohl(lps->ff_type_map[i]) != 0)
 			break;
-- 
1.6.6.rc0.61.g41d5b

