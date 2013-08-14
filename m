From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/1] cciss: set max scatter gather entries to 32 on P600
Date: Wed, 14 Aug 2013 15:52:36 -0500
Message-ID: <20130814205236.GB23042@beardog.cce.hp.com>
Reply-To: mike.miller@hp.com, mikem@thumper.usa.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, thenzl@redhat.com, bubrown@redhat.com, scameron@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Patch 1/1

From: Mike Miller <mike.miller@hp.com>

At one time we used to set the maximum number of scatter gather elements on 
all Smart Array controllers to 32. At some point in time the firmware began 
to write the "appropriate" value for each controller into the config table. 
The cciss driver would then read that and set h->maxsgentries.

        h->maxsgentries = readl(&(h->cfgtable->MaxSGElements);

On the P600 that value is 544. Under some workloads a significant 
performance reduction may result. This patch forces the P600 to use only 32 
scatter gather elements. Other controllers are not affected.

Signed-off-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Dwight (Bud) Brown <bubrown@redhat.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Stephen M. Cameron <steve.cameron@hp.com>
---
 drivers/block/cciss.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 62b6c2c..d2d95ff 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4258,6 +4258,13 @@ static void cciss_find_board_params(ctlr_info_t *h)
 	h->nr_cmds = h->max_commands - 4 - cciss_tape_cmds;
 	h->maxsgentries = readl(&(h->cfgtable->MaxSGElements));
 	/*
+	 * The P600 may exhibit poor performnace under some workloads
+	 * if we use the value in the configuration table. Limit this
+	 * controller to MAXSGENTRIES (32) instead.
+	 */
+	if (h->board_id == 0x3225103C)
+		h->maxsgentries = MAXSGENTRIES;
+	/*
 	 * Limit in-command s/g elements to 32 save dma'able memory.
 	 * Howvever spec says if 0, use 31
 	 */
