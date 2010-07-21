From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH resend] scsi: convert discard to REQ_TYPE_FS from
 REQ_TYPE_BLOCK_PC
Date: Wed, 21 Jul 2010 10:29:37 +0900
Message-ID: <20100721102855Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34220 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761771Ab0GUBaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 21:30:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: James.Bottomley@suse.de, hch@lst.de, snitzer@redhat.com, linux-scsi@vger.kernel.org

Jens, any reason why this isn't included in your for-2.6.36 yet?

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH resend] scsi: convert discard to REQ_TYPE_FS from REQ_TYPE_BLOCK_PC

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fc5d69a..e63b85a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -434,7 +434,6 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 		nr_sectors >>= 3;
 	}
 
-	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = SD_TIMEOUT;
 
 	memset(rq->cmd, 0, rq->cmd_len);
@@ -1200,6 +1199,12 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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

