From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 12/17] Fix excessive gendisk freeing bug on driver
	unload.
Date: Thu, 20 Aug 2009 10:18:44 -0500
Message-ID: <20090820151844.22833.66257.stgit@beardog.cce.hp.com>
References: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27607 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZHTPSm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 11:18:42 -0400
In-Reply-To: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com

Fix bug that free_hba was calling put_disk for all gendisk[]
pointers -- all 1024 of them -- regardless of whether the were
used or not (NULL).  This bug could cause rmmod to oops if logical
drives had been deleted during the driver's lifetime.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---

 drivers/block/cciss.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 14d4cd6..a4cb041 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3892,15 +3892,16 @@ Enomem:
 	return -1;
 }
 
-static void free_hba(int i)
+static void free_hba(int n)
 {
-	ctlr_info_t *p = hba[i];
-	int n;
+	ctlr_info_t *h = hba[n];
+	int i;
 
-	hba[i] = NULL;
-	for (n = 0; n < CISS_MAX_LUN; n++)
-		put_disk(p->gendisk[n]);
-	kfree(p);
+	hba[n] = NULL;
+	for (i = 0; i < h->highest_lun + 1; i++)
+		if (h->gendisk[i] != NULL)
+			put_disk(h->gendisk[i]);
+	kfree(h);
 }
 
 /* Send a message CDB to the firmware. */

