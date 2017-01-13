From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.10-rc3
Date: Fri, 13 Jan 2017 07:02:07 -0800
Message-ID: <1484319727.2527.8.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The major fix is the bfa firmware, since the latest 10Gb cards fail
probing with the current firmware.  The rest is a set of minor fixes:
one missed Kconfig dependency causing randconfig failures, a missed
error return on an error leg, a change for how multiqueue waits on a
blocked device and a don't reset while in reset fix.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Bart Van Assche (1):
      scsi: scsi-mq: Wait for .queue_rq() if necessary

Benjamin Poirier (1):
      scsi: bfa: Increase requested firmware version to 3.2.5.1

Burak Ok (1):
      scsi: snic: Return error code on memory allocation failure

Randy Dunlap (1):
      scsi: qedi: fix build, depends on UIO

Satish Kharat (1):
      scsi: fnic: Avoid sending reset to firmware when another reset is in progress

And the diffstat:

 drivers/scsi/bfa/bfad.c       |  6 +++---
 drivers/scsi/bfa/bfad_drv.h   |  2 +-
 drivers/scsi/fnic/fnic.h      |  1 +
 drivers/scsi/fnic/fnic_scsi.c | 16 ++++++++++++++++
 drivers/scsi/qedi/Kconfig     |  2 +-
 drivers/scsi/scsi_lib.c       |  2 +-
 drivers/scsi/snic/snic_main.c |  3 +++
 7 files changed, 26 insertions(+), 6 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index d9e1521..5caf5f3 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -64,9 +64,9 @@ int		max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
 u32	bfi_image_cb_size, bfi_image_ct_size, bfi_image_ct2_size;
 u32	*bfi_image_cb, *bfi_image_ct, *bfi_image_ct2;
 
-#define BFAD_FW_FILE_CB		"cbfw-3.2.3.0.bin"
-#define BFAD_FW_FILE_CT		"ctfw-3.2.3.0.bin"
-#define BFAD_FW_FILE_CT2	"ct2fw-3.2.3.0.bin"
+#define BFAD_FW_FILE_CB		"cbfw-3.2.5.1.bin"
+#define BFAD_FW_FILE_CT		"ctfw-3.2.5.1.bin"
+#define BFAD_FW_FILE_CT2	"ct2fw-3.2.5.1.bin"
 
 static u32 *bfad_load_fwimg(struct pci_dev *pdev);
 static void bfad_free_fwimg(void);
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index f9e8620..cfcfff4 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -58,7 +58,7 @@
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "3.2.25.0"
+#define BFAD_DRIVER_VERSION    "3.2.25.1"
 #endif
 
 #define BFAD_PROTO_NAME FCPI_NAME
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 9ddc920..9e4b770 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -248,6 +248,7 @@ struct fnic {
 	struct completion *remove_wait; /* device remove thread blocks */
 
 	atomic_t in_flight;		/* io counter */
+	bool internal_reset_inprogress;
 	u32 _reserved;			/* fill hole */
 	unsigned long state_flags;	/* protected by host lock */
 	enum fnic_state state;
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 2544a37..adb3d58 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2581,6 +2581,19 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 	unsigned long wait_host_tmo;
 	struct Scsi_Host *shost = sc->device->host;
 	struct fc_lport *lp = shost_priv(shost);
+	struct fnic *fnic = lport_priv(lp);
+	unsigned long flags;
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (fnic->internal_reset_inprogress == 0) {
+		fnic->internal_reset_inprogress = 1;
+	} else {
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
+			"host reset in progress skipping another host reset\n");
+		return SUCCESS;
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	/*
 	 * If fnic_reset is successful, wait for fabric login to complete
@@ -2601,6 +2614,9 @@ int fnic_host_reset(struct scsi_cmnd *sc)
 		}
 	}
 
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	fnic->internal_reset_inprogress = 0;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 	return ret;
 }
 
diff --git a/drivers/scsi/qedi/Kconfig b/drivers/scsi/qedi/Kconfig
index 23ca8a2..2133145 100644
--- a/drivers/scsi/qedi/Kconfig
+++ b/drivers/scsi/qedi/Kconfig
@@ -1,6 +1,6 @@
 config QEDI
 	tristate "QLogic QEDI 25/40/100Gb iSCSI Initiator Driver Support"
-	depends on PCI && SCSI
+	depends on PCI && SCSI && UIO
 	depends on QED
 	select SCSI_ISCSI_ATTRS
 	select QED_LL2
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c35b6de..9fd9a97 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2893,7 +2893,7 @@ scsi_internal_device_block(struct scsi_device *sdev)
 	 * request queue. 
 	 */
 	if (q->mq_ops) {
-		blk_mq_stop_hw_queues(q);
+		blk_mq_quiesce_queue(q);
 	} else {
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_stop_queue(q);
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 396b32d..7cf70aa 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -591,6 +591,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!pool) {
 		SNIC_HOST_ERR(shost, "dflt sgl pool creation failed\n");
 
+		ret = -ENOMEM;
 		goto err_free_res;
 	}
 
@@ -601,6 +602,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!pool) {
 		SNIC_HOST_ERR(shost, "max sgl pool creation failed\n");
 
+		ret = -ENOMEM;
 		goto err_free_dflt_sgl_pool;
 	}
 
@@ -611,6 +613,7 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!pool) {
 		SNIC_HOST_ERR(shost, "snic tmreq info pool creation failed.\n");
 
+		ret = -ENOMEM;
 		goto err_free_max_sgl_pool;
 	}
 
