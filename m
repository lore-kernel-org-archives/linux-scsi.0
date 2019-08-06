From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: fas216: Mark expected switch fall-throughs
Date: Tue, 6 Aug 2019 03:29:02 -0500
Message-ID: <20190806082902.GA11122@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <linux@armlinux.org.uk>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Mark switch cases where we are expecting to fall through.

Fix the following warnings (Building: rpc_defconfig arm):

drivers/scsi/arm/fas216.c: In function ‘fas216_disconnect_intr’:
drivers/scsi/arm/fas216.c:913:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (fas216_get_last_msg(info, info->scsi.msgin_fifo) == ABORT) {
      ^
drivers/scsi/arm/fas216.c:919:2: note: here
  default:    /* huh?     */
  ^~~~~~~
drivers/scsi/arm/fas216.c: In function ‘fas216_kick’:
drivers/scsi/arm/fas216.c:1959:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
   fas216_allocate_tag(info, SCpnt);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/arm/fas216.c:1960:2: note: here
  case TYPE_OTHER:
  ^~~~
drivers/scsi/arm/fas216.c: In function ‘fas216_busservice_intr’:
drivers/scsi/arm/fas216.c:1413:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
   fas216_stoptransfer(info);
   ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/arm/fas216.c:1414:2: note: here
  case STATE(STAT_STATUS, PHASE_SELSTEPS):/* Sel w/ steps -> Status       */
  ^~~~
drivers/scsi/arm/fas216.c:1424:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
   fas216_stoptransfer(info);
   ^~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/arm/fas216.c:1425:2: note: here
  case STATE(STAT_MESGIN, PHASE_COMMAND): /* Command -> Message In */
  ^~~~
drivers/scsi/arm/fas216.c: In function ‘fas216_funcdone_intr’:
drivers/scsi/arm/fas216.c:1573:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if ((stat & STAT_BUSMASK) == STAT_MESGIN) {
      ^
drivers/scsi/arm/fas216.c:1579:2: note: here
  default:
  ^~~~~~~
drivers/scsi/arm/fas216.c: In function ‘fas216_handlesync’:
drivers/scsi/arm/fas216.c:605:20: warning: this statement may fall through [-Wimplicit-fallthrough=]
   info->scsi.phase = PHASE_MSGOUT_EXPECT;
   ~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~
drivers/scsi/arm/fas216.c:607:2: note: here
  case async:
  ^~~~

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/arm/fas216.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index aea4fd73c862..6c68c2303638 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -603,6 +603,7 @@ static void fas216_handlesync(FAS216_Info *info, char *msg)
 		msgqueue_flush(&info->scsi.msgs);
 		msgqueue_addmsg(&info->scsi.msgs, 1, MESSAGE_REJECT);
 		info->scsi.phase = PHASE_MSGOUT_EXPECT;
+		/* fall through */
 
 	case async:
 		dev->period = info->ifcfg.asyncperiod / 4;
@@ -915,6 +916,7 @@ static void fas216_disconnect_intr(FAS216_Info *info)
 			fas216_done(info, DID_ABORT);
 			break;
 		}
+		/* else, fall through */
 
 	default:				/* huh?					*/
 		printk(KERN_ERR "scsi%d.%c: unexpected disconnect in phase %s\n",
@@ -1411,6 +1413,8 @@ static void fas216_busservice_intr(FAS216_Info *info, unsigned int stat, unsigne
 	case STATE(STAT_STATUS, PHASE_DATAOUT): /* Data Out     -> Status       */
 	case STATE(STAT_STATUS, PHASE_DATAIN):  /* Data In      -> Status       */
 		fas216_stoptransfer(info);
+		/* fall through */
+
 	case STATE(STAT_STATUS, PHASE_SELSTEPS):/* Sel w/ steps -> Status       */
 	case STATE(STAT_STATUS, PHASE_MSGOUT):  /* Message Out  -> Status       */
 	case STATE(STAT_STATUS, PHASE_COMMAND): /* Command      -> Status       */
@@ -1422,6 +1426,8 @@ static void fas216_busservice_intr(FAS216_Info *info, unsigned int stat, unsigne
 	case STATE(STAT_MESGIN, PHASE_DATAOUT): /* Data Out     -> Message In   */
 	case STATE(STAT_MESGIN, PHASE_DATAIN):  /* Data In      -> Message In   */
 		fas216_stoptransfer(info);
+		/* fall through */
+
 	case STATE(STAT_MESGIN, PHASE_COMMAND):	/* Command	-> Message In	*/
 	case STATE(STAT_MESGIN, PHASE_SELSTEPS):/* Sel w/ steps -> Message In   */
 	case STATE(STAT_MESGIN, PHASE_MSGOUT):  /* Message Out  -> Message In   */
@@ -1575,6 +1581,7 @@ static void fas216_funcdone_intr(FAS216_Info *info, unsigned int stat, unsigned
 			fas216_message(info);
 			break;
 		}
+		/* else, fall through */
 
 	default:
 		fas216_log(info, 0, "internal phase %s for function done?"
@@ -1957,6 +1964,7 @@ static void fas216_kick(FAS216_Info *info)
 	switch (where_from) {
 	case TYPE_QUEUE:
 		fas216_allocate_tag(info, SCpnt);
+		/* fall through */
 	case TYPE_OTHER:
 		fas216_start_command(info, SCpnt);
 		break;
-- 
2.22.0
