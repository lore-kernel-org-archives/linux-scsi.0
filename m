From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.8-rc8
Date: Sat, 01 Oct 2016 15:36:12 +0800
Message-ID: <1475307372.3881.13.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

One final fix before 4.8: there's a memory leak triggered by turning
scsi mq off due to the fact that we assume on host release that the
already running hosts weren't mq based because that's the state of the
global flag (even though they were), so fix it by tracking this on a
per host host basis.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: Avoid that toggling use_blk_mq triggers a memory leak

And the diffstat:

 drivers/scsi/hosts.c     | 2 ++
 drivers/scsi/scsi.c      | 1 -
 drivers/scsi/scsi_priv.h | 1 +
 include/scsi/scsi_host.h | 5 +----
 4 files changed, 4 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index ba9af4a..ec6381e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -486,6 +486,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	else
 		shost->dma_boundary = 0xffffffff;
 
+	shost->use_blk_mq = scsi_use_blk_mq;
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus = &scsi_bus_type;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1f36aca..1deb6ad 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -1160,7 +1160,6 @@ bool scsi_use_blk_mq = true;
 bool scsi_use_blk_mq = false;
 #endif
 module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
-EXPORT_SYMBOL_GPL(scsi_use_blk_mq);
 
 static int __init init_scsi(void)
 {
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 57a4b99..85c8a51 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -29,6 +29,7 @@ extern int scsi_init_hosts(void);
 extern void scsi_exit_hosts(void);
 
 /* scsi.c */
+extern bool scsi_use_blk_mq;
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
 #ifdef CONFIG_SCSI_LOGGING
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0dee7af..7e4cd53 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -771,12 +771,9 @@ static inline int scsi_host_in_recovery(struct Scsi_Host *shost)
 		shost->tmf_in_progress;
 }
 
-extern bool scsi_use_blk_mq;
-
 static inline bool shost_use_blk_mq(struct Scsi_Host *shost)
 {
-	return scsi_use_blk_mq;
-
+	return shost->use_blk_mq;
 }
 
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
