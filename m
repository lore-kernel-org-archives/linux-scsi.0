From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 05/10] simscsi: use sg buffer copy helper funcitons
Date: Sun,  9 Mar 2008 13:44:32 +0900
Message-ID: <1205037877-12843-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47280 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbYCIEqE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:04 -0500
In-Reply-To: <1205037877-12843-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tony Luck <tony.luck@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

This replaces simscsi_fillresult with scsi_sg_copy_from_buffer.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/ia64/hp/sim/simscsi.c |   23 ++++-------------------
 1 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index 7661bb0..3a078ad 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -201,22 +201,6 @@ simscsi_readwrite10 (struct scsi_cmnd *sc, int mode)
 	simscsi_sg_readwrite(sc, mode, offset);
 }
 
-static void simscsi_fillresult(struct scsi_cmnd *sc, char *buf, unsigned len)
-{
-
-	int i;
-	unsigned thislen;
-	struct scatterlist *slp;
-
-	scsi_for_each_sg(sc, slp, scsi_sg_count(sc), i) {
-		if (!len)
-			break;
-		thislen = min(len, slp->length);
-		memcpy(sg_virt(slp), buf, thislen);
-		len -= thislen;
-	}
-}
-
 static int
 simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
@@ -258,7 +242,7 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			buf[6] = 0;	/* reserved */
 			buf[7] = 0;	/* various flags */
 			memcpy(buf + 8, "HP      SIMULATED DISK  0.00",  28);
-			simscsi_fillresult(sc, buf, 36);
+			scsi_sg_copy_from_buffer(sc, buf, 36);
 			sc->result = GOOD;
 			break;
 
@@ -306,14 +290,15 @@ simscsi_queuecommand (struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			buf[5] = 0;
 			buf[6] = 2;
 			buf[7] = 0;
-			simscsi_fillresult(sc, buf, 8);
+			scsi_sg_copy_from_buffer(sc, buf, 8);
 			sc->result = GOOD;
 			break;
 
 		      case MODE_SENSE:
 		      case MODE_SENSE_10:
 			/* sd.c uses this to determine whether disk does write-caching. */
-			simscsi_fillresult(sc, (char *)empty_zero_page, scsi_bufflen(sc));
+			scsi_sg_copy_from_buffer(sc, (char *)empty_zero_page,
+						 PAGE_SIZE);
 			sc->result = GOOD;
 			break;
 
-- 
1.5.3.7

