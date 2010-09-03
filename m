From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 26/41] dm: fix locking context in queue_io()
Date: Fri,  3 Sep 2010 12:29:41 +0200
Message-ID: <1283509796-1510-27-git-send-email-tj@kernel.org>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Now queue_io() is called from dec_pending(), which may be called with
interrupts disabled, so queue_io() must not enable interrupts
unconditionally and must save/restore the current interrupts status.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/md/dm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2011704..cd2f7e7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -512,9 +512,11 @@ static void end_io_acct(struct dm_io *io)
  */
 static void queue_io(struct mapped_device *md, struct bio *bio)
 {
-	spin_lock_irq(&md->deferred_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&md->deferred_lock, flags);
 	bio_list_add(&md->deferred, bio);
-	spin_unlock_irq(&md->deferred_lock);
+	spin_unlock_irqrestore(&md->deferred_lock, flags);
 	queue_work(md->wq, &md->work);
 }
 
-- 
1.7.1
