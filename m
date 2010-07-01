From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] scsi: remove unused free discard page in sd_done
Date: Thu,  1 Jul 2010 19:49:19 +0900
Message-ID: <1277981359-10717-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33213 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab0GAKu6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2010 06:50:58 -0400
In-Reply-To: <1277981359-10717-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: snitzer@redhat.com, hch@lst.de, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, dm-devel@redhat.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org

- sd_done isn't called for pc request so we never call the code.
- we use sd_unprep to free discard page now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sd.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2d4e3a8..aa6b48b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1179,15 +1179,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
-	/*
-	 * If this is a discard request that originated from the kernel
-	 * we need to free our payload here.  Note that we need to check
-	 * the request flag as the normal payload rules apply for
-	 * pass-through UNMAP / WRITE SAME requests.
-	 */
-	if (SCpnt->request->cmd_flags & REQ_DISCARD)
-		__free_page(bio_page(SCpnt->request->bio));
-
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
 		if (sense_valid)
-- 
1.6.5

