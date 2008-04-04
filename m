From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] scsi: ncr53c8xx.c make functions static
Date: Fri, 04 Apr 2008 15:20:59 -0700
Message-ID: <1207347659.18838.102.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.189]:47787 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbYDDWVA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Apr 2008 18:21:00 -0400
Received: by rn-out-0910.google.com with SMTP id e24so447371rng.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Apr 2008 15:20:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>

Forward declarations were already marked static, marke the definitions
as well.  Small codingstyle changes on the changed lines.

Noticed by sparse:
drivers/scsi/ncr53c8xx.c:3445:13: warning: symbol 'ncr_script_fill' was not declared. Should it be static?
drivers/scsi/ncr53c8xx.c:4816:6: warning: symbol 'ncr_complete' was not declared. Should it be static?
drivers/scsi/ncr53c8xx.c:5116:6: warning: symbol 'ncr_wakeup_done' was not declared. Should it be static?
drivers/scsi/ncr53c8xx.c:5162:6: warning: symbol 'ncr_wakeup' was not declared. Should it be static?
drivers/scsi/ncr53c8xx.c:5205:6: warning: symbol 'ncr_init' was not declared. Should it be static?
drivers/scsi/ncr53c8xx.c:5903:6: warning: symbol 'ncr_exception' was not declared. Should it be static?
drivers/scsi/ncr53c8xx.c:6086:6: warning: symbol 'ncr_int_sto' was not declared. Should it be static?
drivers/scsi/ncr53c8xx.c:6692:6: warning: symbol 'ncr_int_sir' was not declared. Should it be static?
drivers/scsi/ncr53c8xx.c:8189:31: warning: Using plain integer as NULL pointer
drivers/scsi/ncr53c8xx.c:8225:34: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/scsi/ncr53c8xx.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c5ebf01..e77b8e7 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -3442,7 +3442,7 @@ static	struct scripth scripth0 __initdata = {
 **==========================================================
 */
 
-void __init ncr_script_fill (struct script * scr, struct scripth * scrh)
+static void __init ncr_script_fill(struct script *scr, struct scripth *scrh)
 {
 	int	i;
 	ncrcmd	*p;
@@ -4813,7 +4813,7 @@ static void ncr_detach(struct ncb *np)
 **==========================================================
 */
 
-void ncr_complete (struct ncb *np, struct ccb *cp)
+static void ncr_complete(struct ncb *np, struct ccb *cp)
 {
 	struct scsi_cmnd *cmd;
 	struct tcb *tp;
@@ -5113,7 +5113,7 @@ static void ncr_ccb_skipped(struct ncb *np, struct ccb *cp)
 **	The NCR has completed CCBs.
 **	Look at the DONE QUEUE if enabled, otherwise scan all CCBs
 */
-void ncr_wakeup_done (struct ncb *np)
+static void ncr_wakeup_done(struct ncb *np)
 {
 	struct ccb *cp;
 #ifdef SCSI_NCR_CCB_DONE_SUPPORT
@@ -5159,7 +5159,7 @@ void ncr_wakeup_done (struct ncb *np)
 /*
 **	Complete all active CCBs.
 */
-void ncr_wakeup (struct ncb *np, u_long code)
+static void ncr_wakeup(struct ncb *np, u_long code)
 {
 	struct ccb *cp = np->ccb;
 
@@ -5202,7 +5202,7 @@ static void ncr_chip_reset(struct ncb *np, int delay)
 **==========================================================
 */
 
-void ncr_init (struct ncb *np, int reset, char * msg, u_long code)
+static void ncr_init(struct ncb *np, int reset, char *msg, u_long code)
 {
  	int	i;
 
@@ -5900,7 +5900,7 @@ static void ncr_log_hard_error(struct ncb *np, u16 sist, u_char dstat)
 **============================================================
 */
 
-void ncr_exception (struct ncb *np)
+static void ncr_exception(struct ncb *np)
 {
 	u_char	istat, dstat;
 	u16	sist;
@@ -6083,7 +6083,7 @@ void ncr_exception (struct ncb *np)
 **----------------------------------------------------------
 */
 
-void ncr_int_sto (struct ncb *np)
+static void ncr_int_sto(struct ncb *np)
 {
 	u_long dsa;
 	struct ccb *cp;
@@ -6689,7 +6689,7 @@ out:
 **==========================================================
 */
 
-void ncr_int_sir (struct ncb *np)
+static void ncr_int_sir(struct ncb *np)
 {
 	u_char scntl3;
 	u_char chg, ofs, per, fak, wide;
@@ -8186,7 +8186,7 @@ static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cmd)
 	cmd->next_wcmd = NULL;
 	if (!(wcmd = np->waiting_list)) np->waiting_list = cmd;
 	else {
-		while ((wcmd->next_wcmd) != 0)
+		while (wcmd->next_wcmd)
 			wcmd = (struct scsi_cmnd *) wcmd->next_wcmd;
 		wcmd->next_wcmd = (char *) cmd;
 	}
@@ -8222,7 +8222,7 @@ static void process_waiting_list(struct ncb *np, int sts)
 #ifdef DEBUG_WAITING_LIST
 	if (waiting_list) printk("%s: waiting_list=%lx processing sts=%d\n", ncr_name(np), (u_long) waiting_list, sts);
 #endif
-	while ((wcmd = waiting_list) != 0) {
+	while ((wcmd = waiting_list) != NULL) {
 		waiting_list = (struct scsi_cmnd *) wcmd->next_wcmd;
 		wcmd->next_wcmd = NULL;
 		if (sts == DID_OK) {
-- 
1.5.5.rc1.135.g8527



