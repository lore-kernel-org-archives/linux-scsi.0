From: Dan Williams <djbw@fb.com>
Subject: [resend PATCH] scsi_remove_target: fix softlockup regression on hot
 remove
Date: Tue, 28 Aug 2012 22:12:10 -0700
Message-ID: <20120829051119.26395.15980.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56726 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab2H2FMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Aug 2012 01:12:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: John Drescher <drescherjm@gmail.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org, Jack Wang <jack_wang@usish.com>

John reports:
 BUG: soft lockup - CPU#2 stuck for 23s! [kworker/u:8:2202]
 [..]
 Call Trace:
  [<ffffffff8141782a>] scsi_remove_target+0xda/0x1f0
  [<ffffffff81421de5>] sas_rphy_remove+0x55/0x60
  [<ffffffff81421e01>] sas_rphy_delete+0x11/0x20
  [<ffffffff81421e35>] sas_port_delete+0x25/0x160
  [<ffffffff814549a3>] mptsas_del_end_device+0x183/0x270

...introduced by commit 3b661a9 "[SCSI] fix hot unplug vs async scan race".

Don't restart lookup of more stargets in the multi-target case, just
arrange to traverse the list once, on the assumption that new targets
are always added at the end.  There is no guarantee that the target will
change state in scsi_target_reap() so we can end up spinning if we
restart.

Cc: <stable@vger.kernel.org>
Acked-by: Jack Wang <jack_wang@usish.com>
LKML-Reference: <CAEhu1-6wq1YsNiscGMwP4ud0Q+MrViRzv=kcWCQSBNc8c68N5Q@mail.gmail.com>
Reported-by: John Drescher <drescherjm@gmail.com>
Tested-by: John Drescher <drescherjm@gmail.com>
Signed-off-by: Dan Williams <djbw@fb.com>
---

Jack, thanks for the reminder to cc stable!

 drivers/scsi/scsi_sysfs.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 093d4f6..ce5224c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1031,33 +1031,31 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *found;
+	struct scsi_target *starget, *last = NULL;
 	unsigned long flags;
 
- restart:
-	found = NULL;
+	/* remove targets being careful to lookup next entry before
+	 * deleting the last
+	 */
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(starget, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
-			found = starget;
-			found->reap_ref++;
-			break;
+			/* assuming new targets arrive at the end */
+			starget->reap_ref++;
+			spin_unlock_irqrestore(shost->host_lock, flags);
+			if (last)
+				scsi_target_reap(last);
+			last = starget;
+			__scsi_remove_target(starget);
+			spin_lock_irqsave(shost->host_lock, flags);
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (found) {
-		__scsi_remove_target(found);
-		scsi_target_reap(found);
-		/* in the case where @dev has multiple starget children,
-		 * continue removing.
-		 *
-		 * FIXME: does such a case exist?
-		 */
-		goto restart;
-	}
+	if (last)
+		scsi_target_reap(last);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 

