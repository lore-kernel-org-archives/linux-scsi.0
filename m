From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 9/12] repost: cciss: add busy_configuring flag
Date: Mon, 6 Nov 2006 14:25:59 -0600
Message-ID: <20061106202559.GI17847@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:7642 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S1753660AbWKFU0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2006 15:26:00 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

PATCH 9 of 12

This patch adds a check for busy_configuring to prevent starting a queue
on a drive that may be in the midst of updating, configuring, deleting, etc.

This had a test for if the queue was stopped or plugged but that seemed
to cause issues.
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>

--------------------------------------------------------------------------------

---

 drivers/block/cciss.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/block/cciss.c~cciss_busy_conf_for_lx2619-rc4 drivers/block/cciss.c
--- linux-2.6/drivers/block/cciss.c~cciss_busy_conf_for_lx2619-rc4	2006-11-06 13:27:53.000000000 -0600
+++ linux-2.6-root/drivers/block/cciss.c	2006-11-06 13:27:53.000000000 -0600
@@ -1190,8 +1190,11 @@ static void cciss_check_queues(ctlr_info
 		/* make sure the disk has been added and the drive is real
 		 * because this can be called from the middle of init_one.
 		 */
-		if (!(h->drv[curr_queue].queue) || !(h->drv[curr_queue].heads))
+		if (!(h->drv[curr_queue].queue) ||
+		    !(h->drv[curr_queue].heads) ||
+		    h->drv[curr_queue].busy_configuring)
 			continue;
+
 		blk_start_queue(h->gendisk[curr_queue]->queue);
 
 		/* check to see if we have maxed out the number of commands
_
