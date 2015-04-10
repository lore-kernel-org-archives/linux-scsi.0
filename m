From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.0-rc7
Date: Fri, 10 Apr 2015 16:14:59 -0700
Message-ID: <1428707699.2637.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is our remaining set of three fixes for 4.0: two oops fixes(one for
cable pulls triggering oopses and the other be2iscsi specific) and one
warn on in sysfs on multipath devices using enclosures.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      Defer processing of REQ_PREEMPT requests for blocked devices

James Bottomley (1):
      enclosure: fix WARN_ON removing an adapter in multi-path devices

John Soni Jose (1):
      be2iscsi: Fix kernel panic when device initialization fails

And the diffstat:

 drivers/misc/enclosure.c        | 11 ++++++-----
 drivers/scsi/be2iscsi/be_main.c |  2 +-
 drivers/scsi/scsi_lib.c         |  4 +++-
 include/linux/blk_types.h       |  4 +++-
 4 files changed, 13 insertions(+), 8 deletions(-)

With full diff below.

James

---

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 38552a3..65fed71 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -202,16 +202,17 @@ static void enclosure_remove_links(struct enclosure_component *cdev)
 {
 	char name[ENCLOSURE_NAME_SIZE];
 
+	enclosure_link_name(cdev, name);
+
 	/*
 	 * In odd circumstances, like multipath devices, something else may
 	 * already have removed the links, so check for this condition first.
 	 */
-	if (!cdev->dev->kobj.sd)
-		return;
+	if (cdev->dev->kobj.sd)
+		sysfs_remove_link(&cdev->dev->kobj, name);
 
-	enclosure_link_name(cdev, name);
-	sysfs_remove_link(&cdev->dev->kobj, name);
-	sysfs_remove_link(&cdev->cdev.kobj, "device");
+	if (cdev->cdev.kobj.sd)
+		sysfs_remove_link(&cdev->cdev.kobj, "device");
 }
 
 static int enclosure_add_links(struct enclosure_component *cdev)
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index a7cc618..923a2b5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -5734,9 +5734,9 @@ free_port:
 hba_free:
 	if (phba->msix_enabled)
 		pci_disable_msix(phba->pcidev);
-	iscsi_host_remove(phba->shost);
 	pci_dev_put(phba->pcidev);
 	iscsi_host_free(phba->shost);
+	pci_set_drvdata(pcidev, NULL);
 disable_pci:
 	pci_disable_device(pcidev);
 	return ret;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 54d7a6c..b1a2631 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1311,9 +1311,11 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 				    "rejecting I/O to dead device\n");
 			ret = BLKPREP_KILL;
 			break;
-		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
 		case SDEV_CREATED_BLOCK:
+			ret = BLKPREP_DEFER;
+			break;
+		case SDEV_QUIESCE:
 			/*
 			 * If the devices is blocked we defer normal commands.
 			 */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c294e3e..a1b25e3 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -181,7 +181,9 @@ enum rq_flag_bits {
 	__REQ_ELVPRIV,		/* elevator private data attached */
 	__REQ_FAILED,		/* set if the request failed */
 	__REQ_QUIET,		/* don't worry about errors */
-	__REQ_PREEMPT,		/* set for "ide_preempt" requests */
+	__REQ_PREEMPT,		/* set for "ide_preempt" requests and also
+				   for requests for which the SCSI "quiesce"
+				   state must be ignored. */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_COPY_USER,	/* contains copies of user pages */
 	__REQ_FLUSH_SEQ,	/* request for flush sequence */
