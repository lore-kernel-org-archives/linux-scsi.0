From: heinzm@redhat.com
Subject: [PATCH] [REGRESSION] md: md.c: fix oops in mddev_suspend for raid0
Date: Tue,  3 May 2016 19:11:30 +0200
Message-ID: <1462295490-23805-1-git-send-email-heinzm@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip5f587210.dynamic.kabel-deutschland.de ([95.88.114.16]:51496
	"EHLO o.ww.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932270AbcECSDq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2016 14:03:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Heinz Mauelshagen <heinzm@redhat.com>

From: Heinz Mauelshagen <heinzm@redhat.com>

Introduced by upstream commit 70d9798b95562abac005d4ba71d28820f9a201eb

The raid0 personality does not create mddev->thread as oposed to
other personalities leading to its unconditional access in
mddev_suspend() causing an oops.

Patch checks for mddev->thread in order to keep the
intention of aforementioned commit.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>


---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 194580f..d91920d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -305,7 +305,7 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
  */
 void mddev_suspend(struct mddev *mddev)
 {
-	WARN_ON_ONCE(current == mddev->thread->tsk);
+	WARN_ON_ONCE(mddev->thread && current == mddev->thread->tsk);
 	if (mddev->suspended++)
 		return;
 	synchronize_rcu();
-- 
2.5.5

