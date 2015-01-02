From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.19-rc2
Date: Fri, 02 Jan 2015 08:41:57 -0800
Message-ID: <1420216917.2072.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of three fixes: one to correct an abort path thinko
causing failures (and a panic) in USB on device misbehaviour, One to fix
an out of order issue in the fnic driver and one to match discard
expectations to qemu which otherwise cause Linux to behave badly as a
guest.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Alan Stern (1):
      SCSI: fix regression in scsi_send_eh_cmnd()

Anil Chintalapati (achintal) (1):
      fnic: IOMMU Fault occurs when IO and abort IO is out of order

Martin K. Petersen (1):
      sd: tweak discard heuristics to work around QEMU SCSI issue

The diffstat is:

 drivers/scsi/fnic/fnic.h      |  2 +-
 drivers/scsi/fnic/fnic_scsi.c | 15 +++++++++++++++
 drivers/scsi/scsi_error.c     |  4 ++--
 drivers/scsi/sd.c             |  5 +++--
 4 files changed, 21 insertions(+), 5 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 3b73b96..26270c3 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -39,7 +39,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.6.0.16"
+#define DRV_VERSION		"1.6.0.17"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2097de4..155b286 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1892,6 +1892,21 @@ int fnic_abort_cmd(struct scsi_cmnd *sc)
 		goto fnic_abort_cmd_end;
 	}
 
+	/* IO out of order */
+
+	if (!(CMD_FLAGS(sc) & (FNIC_IO_ABORTED | FNIC_IO_DONE))) {
+		spin_unlock_irqrestore(io_lock, flags);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"Issuing Host reset due to out of order IO\n");
+
+		if (fnic_host_reset(sc) == FAILED) {
+			FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+				"fnic_host_reset failed.\n");
+		}
+		ret = FAILED;
+		goto fnic_abort_cmd_end;
+	}
+
 	CMD_STATE(sc) = FNIC_IOREQ_ABTS_COMPLETE;
 
 	/*
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index e42fff6..8afb016 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1041,7 +1041,7 @@ retry:
 		}
 		/* signal not to enter either branch of the if () below */
 		timeleft = 0;
-		rtn = NEEDS_RETRY;
+		rtn = FAILED;
 	} else {
 		timeleft = wait_for_completion_timeout(&done, timeout);
 		rtn = SUCCESS;
@@ -1081,7 +1081,7 @@ retry:
 			rtn = FAILED;
 			break;
 		}
-	} else if (!rtn) {
+	} else if (rtn != FAILED) {
 		scsi_abort_eh_cmnd(scmd);
 		rtn = FAILED;
 	}
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fedab3c..3995169 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2623,8 +2623,9 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 				sd_config_discard(sdkp, SD_LBP_WS16);
 
 		} else {	/* LBP VPD page tells us what to use */
-
-			if (sdkp->lbpws)
+			if (sdkp->lbpu && sdkp->max_unmap_blocks && !sdkp->lbprz)
+				sd_config_discard(sdkp, SD_LBP_UNMAP);
+			else if (sdkp->lbpws)
 				sd_config_discard(sdkp, SD_LBP_WS16);
 			else if (sdkp->lbpws10)
 				sd_config_discard(sdkp, SD_LBP_WS10);
