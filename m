From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 06/13] libsas: don't recover end devices attached to
 disabled phys
Date: Fri, 10 Feb 2012 00:45:10 -0800
Message-ID: <20120210084510.25701.10004.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Luben Tuikov <ltuikov@yahoo.com>
List-Id: linux-scsi@vger.kernel.org

If userspace has decided to disable a phy the kernel should honor that
and not inadvertantly re-enable the phy via error recovery.  This is
more straightforward in the sata case where link recovery (via
libata-eh) is separate from sas_task cancelling in libsas-eh.  Teach
libsas to accept -ENODEV as a successful response from I_T_nexus_reset
('successful' in terms of not escalating further).

This is a more comprehensive fix then "libsas: don't recover 'gone'
devices in sas_ata_hard_reset()", as it is no longer sata-specific.

aic94xx does check the return value from sas_phy_reset() so if the phy
is disabled we proceed with clearing the I_T_nexus.

Cc: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/aic94xx/aic94xx_tmf.c  |    2 +-
 drivers/scsi/libsas/sas_ata.c       |    5 ++---
 drivers/scsi/libsas/sas_init.c      |    3 +++
 drivers/scsi/libsas/sas_scsi_host.c |    3 ++-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 50b914f..cf90409 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -192,7 +192,7 @@ int asd_I_T_nexus_reset(struct domain_device *dev)
 	ASD_DPRINTK("sending %s reset to %s\n",
 		    reset_type ? "hard" : "soft", dev_name(&phy->dev));
 	res = sas_phy_reset(phy, reset_type);
-	if (res == TMF_RESP_FUNC_COMPLETE) {
+	if (res == TMF_RESP_FUNC_COMPLETE || res == -ENODEV) {
 		/* wait for the maximum settle time */
 		msleep(500);
 		/* clear all outstanding commands (keep nexus suspended) */
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index befba2c..1b1d4b7 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -407,10 +407,9 @@ static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
 	struct domain_device *dev = ap->private_data;
 	struct sas_internal *i = dev_to_sas_internal(dev);
 
-	if (test_bit(SAS_DEV_GONE, &dev->state))
-		return -ENODEV;
-
 	res = i->dft->lldd_I_T_nexus_reset(dev);
+	if (res == -ENODEV)
+		return res;
 
 	if (res != TMF_RESP_FUNC_COMPLETE)
 		sas_ata_printk(KERN_DEBUG, dev, "Unable to reset ata device?\n");
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 09c14ca..120bff6 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -298,6 +298,9 @@ int sas_phy_reset(struct sas_phy *phy, int hard_reset)
 	int ret;
 	enum phy_func reset_type;
 
+	if (!phy->enabled)
+		return -ENODEV;
+
 	if (hard_reset)
 		reset_type = PHY_FUNC_HARD_RESET;
 	else
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index fd32913..f0b9b7b 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -607,7 +607,8 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
 			SAS_DPRINTK("task 0x%p is not at LU: I_T recover\n",
 				    task);
 			tmf_resp = sas_recover_I_T(task->dev);
-			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
+			if (tmf_resp == TMF_RESP_FUNC_COMPLETE ||
+			    tmf_resp == -ENODEV) {
 				struct domain_device *dev = task->dev;
 				SAS_DPRINTK("I_T %016llx recovered\n",
 					    SAS_ADDR(task->dev->sas_addr));

