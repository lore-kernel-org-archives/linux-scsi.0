From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/41] block: filter flush bio's in
	__generic_make_request()
Date: Fri,  3 Sep 2010 12:29:26 +0200
Message-ID: <1283509796-1510-12-git-send-email-tj@kernel.org>
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

There are a number of make_request based drivers which don't support
cache flushes.  Filter out flush bio's in __generic_make_request() so
that they don't have to worry about them.  All FLUSH/FUA requests with
data are converted to regular IO requests and empty ones are completed
immediately.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 18455c4..495bdc4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1509,6 +1509,19 @@ static inline void __generic_make_request(struct bio *bio)
 		if (bio_check_eod(bio, nr_sectors))
 			goto end_io;
 
+		/*
+		 * Filter flush bio's early so that make_request based
+		 * drivers without flush support don't have to worry
+		 * about them.
+		 */
+		if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) && !q->flush_flags) {
+			bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
+			if (!nr_sectors) {
+				err = 0;
+				goto end_io;
+			}
+		}
+
 		if ((bio->bi_rw & REQ_DISCARD) &&
 		    (!blk_queue_discard(q) ||
 		     ((bio->bi_rw & REQ_SECURE) &&
-- 
1.7.1
