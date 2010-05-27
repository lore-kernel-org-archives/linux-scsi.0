From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 23/24] hpsa: fix block fetch table problem.
Date: Thu, 27 May 2010 15:14:39 -0500
Message-ID: <20100527201439.3116.5339.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25236 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab0E0UKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:10:00 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix block fetch table problem.
We have 32 (MAXSGENTRIES) scatter gather elements embedded
in the command.  With all these, the total command size is
about 576 bytes.  However, the last entry in the block fetch table
is 35.  (the block fetch table contains the number of 16-byte chunks
the firmware needs to fetch for a given number of scatter gather
elements.)  35 * 16 = 560 bytes, which isn't enough.  It needs to be
36. (36 * 16 == 576) or, MAXSGENTRIES + 4.  (plus 4 because there's a
bunch of stuff at the front of the command before the first scatter
gather element that takes up 4 * 16 bytes.)  Without this fix, the
controller may have to perform two DMA operations to fetch the
command since the first one may not get the whole thing.

Signed-off-by: Don Brace <brace@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 066dde9..2c75f68 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3834,7 +3834,26 @@ static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h)
 {
 	int i;
 	unsigned long register_value;
-	int bft[8] = {5, 6, 8, 10, 12, 20, 28, 35}; /* for scatter/gathers */
+
+	/* This is a bit complicated.  There are 8 registers on
+	 * the controller which we write to to tell it 8 different
+	 * sizes of commands which there may be.  It's a way of
+	 * reducing the DMA done to fetch each command.  Encoded into
+	 * each command's tag are 3 bits which communicate to the controller
+	 * which of the eight sizes that command fits within.  The size of
+	 * each command depends on how many scatter gather entries there are.
+	 * Each SG entry requires 16 bytes.  The eight registers are programmed
+	 * with the number of 16-byte blocks a command of that size requires.
+	 * The smallest command possible requires 5 such 16 byte blocks.
+	 * the largest command possible requires MAXSGENTRIES + 4 16-byte
+	 * blocks.  Note, this only extends to the SG entries contained
+	 * within the command block, and does not extend to chained blocks
+	 * of SG elements.   bft[] contains the eight values we write to
+	 * the registers.  They are not evenly distributed, but have more
+	 * sizes for small commands, and fewer sizes for larger commands.
+	 */
+	int bft[8] = {5, 6, 8, 10, 12, 20, 28, MAXSGENTRIES + 4};
+	BUILD_BUG_ON(28 > MAXSGENTRIES + 4);
 	/*  5 = 1 s/g entry or 4k
 	 *  6 = 2 s/g entry or 8k
 	 *  8 = 4 s/g entry or 16k

