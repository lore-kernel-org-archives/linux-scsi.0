From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of
 REQ_TYPE_BLOCK_PC
Date: Tue, 6 Jul 2010 16:01:46 +0900
Message-ID: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34628 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0GFHCU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jul 2010 03:02:20 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, hch@lst.de, snitzer@redhat.com, axboe@kernel.dk

I confirmed that mkfs.xfs worked with Intel X25-M (trim) and
scsi_debug (write same and unmap).

REQ_TYPE_FS should give the same scsi_cmnd struct as REQ_TYPE_BLOCK_PC.

This can be applied to block's for-2.6.36.

The git tree is also available:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git fs-discard

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC

The block layer (file systems) sends discard requests as REQ_TYPE_FS
(the role of REQ_TYPE_FS is that setting up commands and interpreting
the results). But SCSI-ml treats discard requests as
REQ_TYPE_BLOCK_PC.

scsi-ml can handle discard requests as REQ_TYPE_FS
easily. scsi_setup_discard_cmnd() sets up struct request and the bio
nicely. Only remaining issue is that discard requests can't be
completed partially so we need to modify sd_done.

This conversion also fixes the problem that discard requests aren't
retried when possible (e.g. UNIT ATTENTION).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sd.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0994ab6..5f59601 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -433,7 +433,6 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 		nr_sectors >>= 3;
 	}
 
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
 
 	memset(rq->cmd, 0, rq->cmd_len);
@@ -1185,6 +1184,12 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 
+	if (SCpnt->request->cmd_flags & REQ_DISCARD) {
+		if (!result)
+			scsi_set_resid(SCpnt, 0);
+		return good_bytes;
+	}
+
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
 		if (sense_valid)
-- 
1.6.5

