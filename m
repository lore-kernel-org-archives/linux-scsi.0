From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/6] aha152x.c - In debug mode
Date: Sun, 29 Jul 2007 22:16:14 +0300
Message-ID: <46ACE77E.8080700@panasas.com>
References: <46ACE62F.4070108@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6673 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932823AbXG2TQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 15:16:25 -0400
In-Reply-To: <46ACE62F.4070108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, =?ISO-8859-1?Q?=22J=FC?= =?ISO-8859-1?Q?rgen_E=2E_Fischer=22?= <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>


The symbol <debug_locks> conflicts with the rather global one in
include/linux/locks.h.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

---
 drivers/scsi/aha152x.c |   10 +++++-----
 drivers/scsi/aha152x.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 85f2394..0afc0c9 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -289,18 +289,18 @@ static LIST_HEAD(aha152x_host_list);
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
@@ -3395,7 +3395,7 @@ static int aha152x_proc_info(struct Scsi_Host *shpnt, char *buffer, char **start
 	PDEBUG(debug_datai, "data in");
 	PDEBUG(debug_datao, "data out");
 	PDEBUG(debug_eh, "eh");
-	PDEBUG(debug_locks, "locks");
+	PDEBUG(debug_locking, "locks");
 	PDEBUG(debug_phases, "phases");
 
 	SPRINTF("\n");
diff --git a/drivers/scsi/aha152x.h b/drivers/scsi/aha152x.h
index d2add24..ac4bfa4 100644
--- a/drivers/scsi/aha152x.h
+++ b/drivers/scsi/aha152x.h
@@ -298,7 +298,7 @@ typedef union {
 enum {
   debug_procinfo  = 0x0001,
   debug_queue     = 0x0002,
-  debug_locks     = 0x0004,
+  debug_locking   = 0x0004,
   debug_intr      = 0x0008,
   debug_selection = 0x0010,
   debug_msgo      = 0x0020,
-- 
1.5.2.2.249.g45fd


