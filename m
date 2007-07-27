From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 2/24] advansys: Clean up proc_info implementation
Date: Fri, 27 Jul 2007 07:42:11 -0600
Message-ID: <11855437533288-git-send-email-matthew@wil.cx>
References: <20070727134038.GC21219@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:38888 "EHLO
	mail-06.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760043AbXG0Nmf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:42:35 -0400
In-Reply-To: <20070727134038.GC21219@parisc-linux.org>
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
index eced264..bfa1ffc 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4036,9 +4036,7 @@ static int
 advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 		   off_t offset, int length, int inout)
 {
-	struct Scsi_Host *shp;
 	asc_board_t *boardp;
-	int i;
 	char *cp;
 	int cplen;
 	int cnt;
@@ -4063,18 +4061,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
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
@@ -4088,7 +4075,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 *
 	 * advansys_info() returns the board string from its own static buffer.
 	 */
-	cp = (char *)advansys_info(shp);
+	cp = (char *)advansys_info(shost);
 	strcat(cp, "\n");
 	cplen = strlen(cp);
 	/* Copy board information. */
@@ -4107,7 +4094,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	if (ASC_WIDE_BOARD(boardp)) {
 		cp = boardp->prtbuf;
-		cplen = asc_prt_adv_bios(shp, cp, ASC_PRTBUF_SIZE);
+		cplen = asc_prt_adv_bios(shost, cp, ASC_PRTBUF_SIZE);
 		ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
 		cnt =
 		    asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
@@ -4126,7 +4113,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 * Display driver information for each device attached to the board.
 	 */
 	cp = boardp->prtbuf;
-	cplen = asc_prt_board_devices(shp, cp, ASC_PRTBUF_SIZE);
+	cplen = asc_prt_board_devices(shost, cp, ASC_PRTBUF_SIZE);
 	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
@@ -4143,9 +4130,9 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
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
@@ -4162,7 +4149,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 * Display driver configuration and information for the board.
 	 */
 	cp = boardp->prtbuf;
-	cplen = asc_prt_driver_conf(shp, cp, ASC_PRTBUF_SIZE);
+	cplen = asc_prt_driver_conf(shost, cp, ASC_PRTBUF_SIZE);
 	ASC_ASSERT(cplen < ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
@@ -4179,7 +4166,7 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 * Display driver statistics for the board.
 	 */
 	cp = boardp->prtbuf;
-	cplen = asc_prt_board_stats(shp, cp, ASC_PRTBUF_SIZE);
+	cplen = asc_prt_board_stats(shost, cp, ASC_PRTBUF_SIZE);
 	ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
 	cnt = asc_proc_copy(advoffset, offset, curbuf, leftlen, cp, cplen);
 	totcnt += cnt;
@@ -4196,7 +4183,8 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 	 */
 	for (tgt_id = 0; tgt_id <= ADV_MAX_TID; tgt_id++) {
 		cp = boardp->prtbuf;
-		cplen = asc_prt_target_stats(shp, tgt_id, cp, ASC_PRTBUF_SIZE);
+		cplen = asc_prt_target_stats(shost, tgt_id, cp,
+							ASC_PRTBUF_SIZE);
 		ASC_ASSERT(cplen <= ASC_PRTBUF_SIZE);
 		cnt =
 		    asc_proc_copy(advoffset, offset, curbuf, leftlen, cp,
@@ -4218,9 +4206,9 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
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

