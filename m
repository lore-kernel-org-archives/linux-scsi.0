From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/41] block: initialize flush request with
	WRITE_FLUSH instead of REQ_FLUSH
Date: Fri,  3 Sep 2010 12:29:28 +0200
Message-ID: <1283509796-1510-14-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

init_flush_request() only set REQ_FLUSH when initializing flush
requests making them READ requests.  Use WRITE_FLUSH instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-flush.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 72905f8..f357f1f 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -77,7 +77,7 @@ static void post_flush_end_io(struct request *rq, int error)
 static void init_flush_request(struct request *rq, struct gendisk *disk)
 {
 	rq->cmd_type = REQ_TYPE_FS;
-	rq->cmd_flags = REQ_FLUSH;
+	rq->cmd_flags = WRITE_FLUSH;
 	rq->rq_disk = disk;
 }
 
-- 
1.7.1
