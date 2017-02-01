From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sg: remove unreachable code in SET_FORCE_LOW_DMA
Date: Wed,  1 Feb 2017 12:26:39 +0100
Message-ID: <1485948399-83339-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52234 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbdBAL0n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 06:26:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The low_dma value is always '1' in that branch, so the remaining
'if' statement can never be reached.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sg.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dbe5b4b..652b934 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -890,14 +890,9 @@ static int max_sectors_bytes(struct request_queue *q)
 		result = get_user(val, ip);
 		if (result)
 			return result;
-		if (val) {
+		if (val)
 			sfp->low_dma = 1;
-			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
-				val = (int) sfp->reserve.bufflen;
-				sg_remove_scat(sfp, &sfp->reserve);
-				sg_build_reserve(sfp, val);
-			}
-		} else {
+		else {
 			if (atomic_read(&sdp->detaching))
 				return -ENODEV;
 			sfp->low_dma = sdp->device->host->unchecked_isa_dma;
-- 
1.8.5.6
