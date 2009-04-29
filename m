From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] ide-tape: don't initialize rq->sector for rw requests
Date: Wed, 29 Apr 2009 18:13:40 +0900
Message-ID: <1240996428-10159-3-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

rq->sector is set to the tape->first_frame but it's never actually
used and not even in the correct unit (512 byte sectors).  Don't set
it.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ide/ide-tape.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 8dfc688..7149224 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -892,7 +892,6 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->cmd[13] = cmd;
 	rq->rq_disk = tape->disk;
-	rq->sector = tape->first_frame;
 
 	if (size) {
 		ret = blk_rq_map_kern(drive->queue, rq, tape->buf, size,
-- 
1.6.0.2

