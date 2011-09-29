From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5/5] isci: export phy events via ->lldd_control_phy()
Date: Wed, 28 Sep 2011 18:48:02 -0700
Message-ID: <20110929014801.23617.83419.stgit@localhost6.localdomain6>
References: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30302 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab1I2BsD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 21:48:03 -0400
In-Reply-To: <20110929013717.23617.3675.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: dmilburn@redhat.com, Sreeram Patnam <sreeram.patnam@intel.com>, dave.jiang@intel.com, hare@suse.de, linux-scsi@vger.kernel.org

Allow the sas-transport-class to update events for local phys via a new
PHY_FUNC_GET_EVENTS command to ->lldd_control_phy().  Fixup drivers that
are not prepared for new enum phy_func values, and unify
->lldd_control_phy() error codes.

These are the SAS defined phy events that are reported in a
smp-report-phy-error-log command:
 * /sys/class/sas_phy/<phyX>/invalid_dword_count
 * /sys/class/sas_phy/<phyX>/running_disparity_error_count
 * /sys/class/sas_phy/<phyX>/loss_of_dword_sync_count
 * /sys/class/sas_phy/<phyX>/phy_reset_problem_count

Cc: Sreeram Patnam <sreeram.patnam@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/aic94xx/aic94xx_scb.c |    1 +
 drivers/scsi/isci/phy.c            |   11 +++++++++++
 drivers/scsi/libsas/sas_init.c     |   13 +++++++++----
 drivers/scsi/mvsas/mv_sas.c        |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c   |    2 +-
 include/scsi/sas.h                 |    1 +
 6 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 2959327..fdac7c2 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -906,6 +906,7 @@ int asd_control_phy(struct asd_sas_phy *phy, enum phy_func func, void *arg)
 
 	switch (func) {
 	case PHY_FUNC_CLEAR_ERROR_LOG:
+	case PHY_FUNC_GET_EVENTS:
 		return -ENOSYS;
 	case PHY_FUNC_SET_LINK_RATE:
 		rates = arg;
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index 430fc8f..ab48bb1 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -1313,6 +1313,17 @@ int isci_phy_control(struct asd_sas_phy *sas_phy,
 		ret = isci_port_perform_hard_reset(ihost, iport, iphy);
 
 		break;
+	case PHY_FUNC_GET_EVENTS: {
+		struct scu_link_layer_registers __iomem *r;
+		struct sas_phy *phy = sas_phy->phy;
+
+		r = iphy->link_layer_registers;
+		phy->running_disparity_error_count = readl(&r->running_disparity_error_count);
+		phy->loss_of_dword_sync_count = readl(&r->loss_of_sync_error_count);
+		phy->phy_reset_problem_count = readl(&r->phy_reset_problem_count);
+		phy->invalid_dword_count = readl(&r->invalid_dword_counter);
+		break;
+	}
 
 	default:
 		dev_dbg(&ihost->pdev->dev,
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index dd56ea8..d81c3b1 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -177,10 +177,15 @@ int sas_unregister_ha(struct sas_ha_struct *sas_ha)
 
 static int sas_get_linkerrors(struct sas_phy *phy)
 {
-	if (scsi_is_sas_phy_local(phy))
-		/* FIXME: we have no local phy stats
-		 * gathering at this time */
-		return -EINVAL;
+	if (scsi_is_sas_phy_local(phy)) {
+		struct Scsi_Host *shost = dev_to_shost(phy->dev.parent);
+		struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(shost);
+		struct asd_sas_phy *asd_phy = sas_ha->sas_phy[phy->number];
+		struct sas_internal *i =
+			to_sas_internal(sas_ha->core.shost->transportt);
+
+		return i->dft->lldd_control_phy(asd_phy, PHY_FUNC_GET_EVENTS, NULL);
+	}
 
 	return sas_smp_get_phy_events(phy);
 }
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f2ac01f..5672bd7 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -214,7 +214,7 @@ int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		break;
 	case PHY_FUNC_RELEASE_SPINUP_HOLD:
 	default:
-		rc = -EOPNOTSUPP;
+		rc = -ENOSYS;
 	}
 	msleep(200);
 	return rc;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 9068f12..2d5494e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -210,7 +210,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		PM8001_CHIP_DISP->phy_stop_req(pm8001_ha, phy_id);
 		break;
 	default:
-		rc = -EOPNOTSUPP;
+		rc = -ENOSYS;
 	}
 	msleep(300);
 	return rc;
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index a3001ad..be6a36c 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -121,6 +121,7 @@ enum phy_func {
 	PHY_FUNC_TX_SATA_PS_SIGNAL,
 	PHY_FUNC_RELEASE_SPINUP_HOLD = 0x10, /* LOCAL PORT ONLY! */
 	PHY_FUNC_SET_LINK_RATE,
+	PHY_FUNC_GET_EVENTS,
 };
 
 /* SAS LLDD would need to report only _very_few_ of those, like BROADCAST.

