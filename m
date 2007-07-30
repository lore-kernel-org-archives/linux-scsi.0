From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/23] advansys: Clean up proc_info implementation
Date: Mon, 30 Jul 2007 10:56:47 -0600
Message-ID: <1185814628978-git-send-email-matthew@wil.cx>
References: <20070730165508.GH21219@parisc-linux.org> <11858146283240-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:35764 "EHLO
	smtp-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934299AbXG3Q5K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 12:57:10 -0400
In-Reply-To: <11858146283240-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Just use the Scsi_Host passed in, rather than looking through the driver's
own array of boards for one that matches it.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 8ace30e..6d11076 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4031,9 +4031,7 @@ static int
 advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		   off_t offset, int length, int inout)
 {
-	struct Scsi_Host *shp;
 	asc_board_t *boardp;
-	int i;
 	char *cp;
 	int cplen;
 	int cnt;
@@ -4058,18 +4056,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 * User read of /proc/scsi/advansys/[0...] file.
 	 */
 
-	/* Find the specified board. */
-	for (i = 0; i < asc_board_count; i++) {
-		if (asc_host[i]->host_no == shost->host_no) {
-			break;
-		}
-	}
-	if (i == asc_board_count) {
-		return (-ENOENT);
-	}
-
-	shp = asc_host[i];
-	boardp = ASC_BOARDP(shp);
+	boardp = ASC_BOARDP(shost);
 
 	/* Copy read data starting at the beginning of the buffer. */
 	*start = buffer;
@@ -4083,7 +4070,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 *
 	 * advansys_info() returns the board string from its own static buffer.
 	 */
-	cp = (char *)advansys_info(shp);
+	cp = (char *)advansys_info(shost);
 	strcat(cp, "\n");
 	cplen = strlen(cp);
 	/* Copy board information. */
@@ -4102,7 +4089,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	if (ASC_WIDE_BOARD(boardp)) {
 		cp = boardp->prtbuf;
-		cplen = asc_prt_adv_bios(shp, cp, ASC_PRTBUF_SIZE);
+		cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
 		ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
 		cnt =
 		    asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
@@ -4121,7 +4108,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 * Display driver information for each device attached to the board.
 	 */
 	cp = boardp->prtbuf;
-	cplen = asc_prt_board_devices(shp, cp, ASC_PRTBUF_SIZE);
+	cplen = asc_prt_board_devices(shost, cp, ASC_PRTBUF_SIZE);
 	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
@@ -4138,9 +4125,9 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	cp = boardp->prtbuf;
 	if (ASC_NARROW_BOARD(boardp)) {
-		cplen = asc_prt_asc_board_eeprom(shp, cp, ASC_PRTBUF_SIZE);
+		cplen = asc_prt_asc_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
 	} else {
-		cplen = asc_prt_adv_board_eeprom(shp, cp, ASC_PRTBUF_SIZE);
+		cplen = asc_prt_adv_board_eeprom(shost, cp, ASC_PRTBUF_SIZE);
 	}
 	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
@@ -4157,7 +4144,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 * Display driver configuration and information for the board.
 	 */
 	cp = boardp->prtbuf;
-	cplen = asc_prt_driver_conf(shp, cp, ASC_PRTBUF_SIZE);
+	cplen = asc_prt_driver_conf(shost, cp, ASC_PRTBUF_SIZE);
 	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
@@ -4174,7 +4161,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 * Display driver statistics for the board.
 	 */
 	cp = boardp->prtbuf;
-	cplen = asc_prt_board_stats(shp, cp, ASC_PRTBUF_SIZE);
+	cplen = asc_prt_board_stats(shost, cp, ASC_PRTBUF_SIZE);
 	ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
@@ -4191,7 +4178,8 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	for (tgt_id = 0; tgt_id <= ADV_MAX_TID; tgt_id++) {
 		cp = boardp->prtbuf;
-		cplen = asc_prt_target_stats(shp, tgt_id, cp, ASC_PRTBUF_SIZE);
+		cplen = asc_prt_target_stats(shost, tgt_id, cp,
+							ASC_PRTBUF_SIZE);
 		ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
 		cnt =
 		    asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
@@ -4213,9 +4201,9 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	cp = boardp->prtbuf;
 	if (ASC_NARROW_BOARD(boardp)) {
-		cplen = asc_prt_asc_board_info(shp, cp, ASC_PRTBUF_SIZE);
+		cplen = asc_prt_asc_board_info(shost, cp, ASC_PRTBUF_SIZE);
 	} else {
-		cplen = asc_prt_adv_board_info(shp, cp, ASC_PRTBUF_SIZE);
+		cplen = asc_prt_adv_board_info(shost, cp, ASC_PRTBUF_SIZE);
 	}
 	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
-- 
1.4.4.4

