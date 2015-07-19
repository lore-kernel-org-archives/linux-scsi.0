From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.2-rc2
Date: Sun, 19 Jul 2015 12:37:45 +0300
Message-ID: <1437298665.2284.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Two fairly simple fixes: one is a change that causes us to have a very
low queue depth leading to performance issues and the other is a null
deref occasionally in tapes thanks to use after put.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Jens Axboe (1):
      scsi: fix host max depth checking for the 'queue_depth' sysfs interface

Seymour, Shane M (1):
      st: null pointer dereference panic caused by use after kref_put by st_open

And the diffstat:

 drivers/scsi/scsi_sysfs.c | 2 +-
 drivers/scsi/st.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

With full diffs below.

James

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 1ac38e7..9ad4116 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -859,7 +859,7 @@ sdev_store_queue_depth(struct device *dev, struct device_attribute *attr,
 
 	depth = simple_strtoul(buf, NULL, 0);
 
-	if (depth < 1 || depth > sht->can_queue)
+	if (depth < 1 || depth > sdev->host->can_queue)
 		return -EINVAL;
 
 	retval = sht->change_queue_depth(sdev, depth);
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3f25b8f..871f355 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -1329,9 +1329,9 @@ static int st_open(struct inode *inode, struct file *filp)
 	spin_lock(&st_use_lock);
 	STp->in_use = 0;
 	spin_unlock(&st_use_lock);
-	scsi_tape_put(STp);
 	if (resumed)
 		scsi_autopm_put_device(STp->device);
+	scsi_tape_put(STp);
 	return retval;
 
 }
