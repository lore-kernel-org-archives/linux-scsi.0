From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.13+ merge window
Date: Wed, 13 Sep 2017 07:24:44 -0700
Message-ID: <1505312684.3028.12.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

A tiny update: one patch corrects a Kconfig problem with the shift of
the SAS SMP code to BSG and the other removes a vestige of user space
target mode.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

The short changelog is:

Arnd Bergmann (1):
      scsi: scsi_transport_sas: select BLK_DEV_BSGLIB

Bart Van Assche (1):
      scsi: Remove Scsi_Host.uspace_req_q

And the diffstat:

 drivers/scsi/Kconfig     | 2 +-
 drivers/scsi/hosts.c     | 8 --------
 include/scsi/scsi_host.h | 6 ------
 3 files changed, 1 insertion(+), 15 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f4538d7a3016..c470a05c7f47 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -272,7 +272,7 @@ config SCSI_ISCSI_ATTRS
 config SCSI_SAS_ATTRS
 	tristate "SAS Transport Attributes"
 	depends on SCSI
-	select BLK_DEV_BSG
+	select BLK_DEV_BSGLIB
 	help
 	  If you wish to export transport-specific information about
 	  each attached SAS device to sysfs, say Y.
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 831a1c8b9f89..fe3a0da3ec97 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -315,8 +315,6 @@ static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
-	struct request_queue *q;
-	void *queuedata;
 
 	scsi_proc_hostdir_rm(shost->hostt);
 
@@ -326,12 +324,6 @@ static void scsi_host_dev_release(struct device *dev)
 		kthread_stop(shost->ehandler);
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
-	q = shost->uspace_req_q;
-	if (q) {
-		queuedata = q->queuedata;
-		blk_cleanup_queue(q);
-		kfree(queuedata);
-	}
 
 	if (shost->shost_state == SHOST_CREATED) {
 		/*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index afb04811b7b9..0a804b1a4726 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -691,12 +691,6 @@ struct Scsi_Host {
 	unsigned int prot_capabilities;
 	unsigned char prot_guard_type;
 
-	/*
-	 * q used for scsi_tgt msgs, async events or any other requests that
-	 * need to be processed in userspace
-	 */
-	struct request_queue *uspace_req_q;
-
 	/* legacy crap */
 	unsigned long base;
 	unsigned long io_port;
