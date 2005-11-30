From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 7/11] [SYM2] Negotiate correctly with async-only devices
Date: Tue, 29 Nov 2005 23:08:40 -0500 (EST)
Message-ID: <20051130040840.5FB397626C@gonzo>
References: <20051130040537.GC1597@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:55509 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1750854AbVK3EIn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 23:08:43 -0500
Received: from mail3.magma.ca (mail3.magma.ca [206.191.0.221])
	by mx1.magmacom.com (8.13.0/8.13.0) with ESMTP id jAU48fOj002590
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:42 -0500
Received: from gonzo (ottawa-hs-209-217-123-220.d-ip.magma.ca [209.217.123.220])
	by mail3.magma.ca (8.13.0/8.13.0) with ESMTP id jAU48esD005463
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:08:41 -0500
In-Reply-To: <20051130040537.GC1597@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When we got a device only capable of async, we would zero out goal->period
which would cause us to try PPR negotiations.  Leave goal->period alone,
and check goal->offset before doing PPR.  Kudos to Daniel Forsgren for
figuring this out.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/sym53c8xx_2/sym_hipd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

applies-to: 9313e174962281a1344bfe2e43457b1e8d1b6083
719898c8be5a1acdd48dfaf60a337e1b36c32a59
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index b4f0d9a..aa5404d 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -1405,7 +1405,6 @@ static void sym_check_goals(struct sym_h
 		goal->iu = 0;
 		goal->dt = 0;
 		goal->qas = 0;
-		goal->period = 0;
 		goal->offset = 0;
 		return;
 	}
@@ -1465,7 +1464,8 @@ static int sym_prepare_nego(struct sym_h
 	 * Many devices implement PPR in a buggy way, so only use it if we
 	 * really want to.
 	 */
-	if (goal->iu || goal->dt || goal->qas || (goal->period < 0xa)) {
+	if (goal->offset &&
+	    (goal->iu || goal->dt || goal->qas || (goal->period < 0xa))) {
 		nego = NS_PPR;
 	} else if (spi_width(starget) != goal->width) {
 		nego = NS_WIDE;
---
0.99.9.GIT
