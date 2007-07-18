From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] aha152x in debug mode
Date: Wed, 18 Jul 2007 15:19:33 -0700
Message-ID: <20070718151933.30d96598.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:18282 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbXGRWRO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 18:17:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

The symbol <debug_locks> conflicts with the rather global one in
include/linux/locks.h.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/aha152x.c |   10 +++++-----
 drivers/scsi/aha152x.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- linux-2622.orig/drivers/scsi/aha152x.c
+++ linux-2622/drivers/scsi/aha152x.c
@@ -291,18 +291,18 @@ static LIST_HEAD(aha152x_host_list);
 		if(spin_is_locked(&QLOCK)) { \
 			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
 		} \
-		DPRINTK(debug_locks, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
 		spin_lock_irqsave(&QLOCK,flags); \
-		DPRINTK(debug_locks, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
 		QLOCKER=__FUNCTION__; \
 		QLOCKERL=__LINE__; \
 	} while(0)
 
 #define DO_UNLOCK(flags)	\
 	do { \
-		DPRINTK(debug_locks, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
 		spin_unlock_irqrestore(&QLOCK,flags); \
-		DPRINTK(debug_locks, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
 		QLOCKER="(not locked)"; \
 		QLOCKERL=0; \
 	} while(0)
@@ -3402,7 +3402,7 @@ static int aha152x_proc_info(struct Scsi
 	PDEBUG(debug_datai, "data in");
 	PDEBUG(debug_datao, "data out");
 	PDEBUG(debug_eh, "eh");
-	PDEBUG(debug_locks, "locks");
+	PDEBUG(debug_locking, "locks");
 	PDEBUG(debug_phases, "phases");
 
 	SPRINTF("\n");
--- linux-2622.orig/drivers/scsi/aha152x.h
+++ linux-2622/drivers/scsi/aha152x.h
@@ -298,7 +298,7 @@ typedef union {
 enum {
   debug_procinfo  = 0x0001,
   debug_queue     = 0x0002,
-  debug_locks     = 0x0004,
+  debug_locking   = 0x0004,
   debug_intr      = 0x0008,
   debug_selection = 0x0010,
   debug_msgo      = 0x0020,
