From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH v2 1/3] scsi: drop unlikely behind BUG_ON()
Date: Mon,  5 Oct 2015 21:26:04 +0800
Message-ID: <482d18783d6df356809b67431de95addfa20aa79.1444051018.git.geliangtang@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m50-134.163.com ([123.125.50.134]:52336 "EHLO m50-134.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbbJEN2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Oct 2015 09:28:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

(1) For !CONFIG_BUG cases, the bug call is a no-op, so we couldn't care
less and the change is ok.

(2) ppc and mips, which HAVE_ARCH_BUG_ON, do not rely on branch predictions
as it seems to be pointless[1] and thus callers should not be trying to
push an optimization in the first place.

(3) For CONFIG_BUG and !HAVE_ARCH_BUG_ON cases, BUG_ON() contains an
unlikely compiler flag already.

Hence, we can drop unlikely behind BUG_ON().

[1] http://lkml.iu.edu/hypermail/linux/kernel/1101.3/02289.html

Signed-off-by: Geliang Tang <geliangtang@163.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
Changes in v2:
 - Just rewrite the commit log.
---
 drivers/scsi/scsi_lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f570b48..3b5faab 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1164,8 +1164,8 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 
 		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
 						prot_sdb->table.sgl);
-		BUG_ON(unlikely(count > ivecs));
-		BUG_ON(unlikely(count > queue_max_integrity_segments(rq->q)));
+		BUG_ON(count > ivecs);
+		BUG_ON(count > queue_max_integrity_segments(rq->q));
 
 		cmd->prot_sdb = prot_sdb;
 		cmd->prot_sdb->table.nents = count;
-- 
2.5.0


