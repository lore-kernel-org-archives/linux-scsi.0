From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.7-rc1
Date: Sun, 29 May 2016 09:46:06 -0700
Message-ID: <1464540366.2287.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38648 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752721AbcE2QqK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 May 2016 12:46:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of four fixes noticed in the merge window.  The aacraid
one is an optimisation, the mp3sas one fixes a spurious printk, the
sd_check_events one fixes a theoretical race and the failed zero length
commands fixes a bug in our completion/retry routines that has been
causing problems in the field.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (1):
      mpt3sas: add missing curly braces

Hannes Reinecke (2):
      aacraid: do not activate events on non-SRC adapters
      sd: get disk reference in sd_check_events()

James Bottomley (1):
      scsi_lib: correctly retry failed zero length REQ_TYPE_FS commands

And the diffstat:

 drivers/scsi/aacraid/aacraid.h       |  5 +++++
 drivers/scsi/aacraid/linit.c         | 11 ++++++-----
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  3 ++-
 drivers/scsi/scsi_lib.c              |  7 +++++--
 drivers/scsi/sd.c                    |  9 +++++++--
 5 files changed, 25 insertions(+), 10 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 8f90d9e..969c312 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -621,6 +621,11 @@ struct aac_driver_ident
 #define AAC_QUIRK_SCSI_32	0x0020
 
 /*
+ * SRC based adapters support the AifReqEvent functions
+ */
+#define AAC_QUIRK_SRC 0x0040
+
+/*
  *	The adapter interface specs all queues to be located in the same
  *	physically contiguous block. The host structure that defines the
  *	commuication queues will assume they are each a separate physically
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a943bd2..79871f3 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -236,10 +236,10 @@ static struct aac_driver_ident aac_drivers[] = {
 	{ aac_rx_init, "aacraid",  "ADAPTEC ", "RAID            ", 2 }, /* Adaptec Catch All */
 	{ aac_rkt_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec Rocket Catch All */
 	{ aac_nark_init, "aacraid", "ADAPTEC ", "RAID           ", 2 }, /* Adaptec NEMER/ARK Catch All */
-	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec PMC Series 6 (Tupelo) */
-	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec PMC Series 7 (Denali) */
-	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 }, /* Adaptec PMC Series 8 */
-	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2 } /* Adaptec PMC Series 9 */
+	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 6 (Tupelo) */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 7 (Denali) */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 8 */
+	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC } /* Adaptec PMC Series 9 */
 };
 
 /**
@@ -1299,7 +1299,8 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		shost->this_id = shost->max_id;
 
-	aac_intr_normal(aac, 0, 2, 0, NULL);
+	if (aac_drivers[index].quirks & AAC_QUIRK_SRC)
+		aac_intr_normal(aac, 0, 2, 0, NULL);
 
 	/*
 	 * dmb - we may need to move the setting of these parms somewhere else once
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6a4df5a..6bff13e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -7975,13 +7975,14 @@ mpt3sas_scsih_event_callback(struct MPT3SAS_ADAPTER *ioc, u8 msix_index,
 		ActiveCableEventData =
 		    (Mpi26EventDataActiveCableExcept_t *) mpi_reply->EventData;
 		if (ActiveCableEventData->ReasonCode ==
-				MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER)
+				MPI26_EVENT_ACTIVE_CABLE_INSUFFICIENT_POWER) {
 			pr_info(MPT3SAS_FMT "Currently an active cable with ReceptacleID %d",
 			    ioc->name, ActiveCableEventData->ReceptacleID);
 			pr_info("cannot be powered and devices connected to this active cable");
 			pr_info("will not be seen. This active cable");
 			pr_info("requires %d mW of power",
 			    ActiveCableEventData->ActiveCablePowerRequirement);
+		}
 		break;
 
 	default: /* ignore the rest */
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2e332a..c71344a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -821,9 +821,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	}
 
 	/*
-	 * If we finished all bytes in the request we are done now.
+	 * special case: failed zero length commands always need to
+	 * drop down into the retry code. Otherwise, if we finished
+	 * all bytes in the request we are done now.
 	 */
-	if (!scsi_end_request(req, error, good_bytes, 0))
+	if (!(blk_rq_bytes(req) == 0 && error) &&
+	    !scsi_end_request(req, error, good_bytes, 0))
 		return;
 
 	/*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 428c03e..f459dff 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1398,11 +1398,15 @@ static int media_not_present(struct scsi_disk *sdkp,
  **/
 static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 {
-	struct scsi_disk *sdkp = scsi_disk(disk);
-	struct scsi_device *sdp = sdkp->device;
+	struct scsi_disk *sdkp = scsi_disk_get(disk);
+	struct scsi_device *sdp;
 	struct scsi_sense_hdr *sshdr = NULL;
 	int retval;
 
+	if (!sdkp)
+		return 0;
+
+	sdp = sdkp->device;
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_check_events\n"));
 
 	/*
@@ -1459,6 +1463,7 @@ out:
 	kfree(sshdr);
 	retval = sdp->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 	sdp->changed = 0;
+	scsi_disk_put(sdkp);
 	return retval;
 }
 
