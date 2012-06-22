From: Dan Williams <dan.j.williams@intel.com>
Subject: [set2 PATCH 3/4] libsas: use ->lldd_I_T_nexus_reset for
 ->eh_bus_reset_handler
Date: Thu, 21 Jun 2012 23:30:58 -0700
Message-ID: <20120622063058.21248.11856.stgit@dwillia2-linux.jf.intel.com>
References: <20120622063043.21248.12701.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1120 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761324Ab2FVGOU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2012 02:14:20 -0400
In-Reply-To: <20120622063043.21248.12701.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, Jacek Danecki <jacek.danecki@intel.com>, Luben Tuikov <ltuikov@yahoo.com>, Jack Wang <jack_wang@usish.com>

sas_eh_bus_reset_handler() amounts to sas_phy_reset() without
notification of the reset to the lldd.  If this is triggered from
eh-cmnd recovery there may be sas_tasks for the lldd to terminate, so
->lldd_I_T_nexus_reset is warranted.

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Cc: Jack Wang <jack_wang@usish.com>
Reviewed-by: Jacek Danecki <jacek.danecki@intel.com>
[jacek: modify pm8001_I_T_nexus_reset to return -ENODEV]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   19 ++++++++-----------
 drivers/scsi/pm8001/pm8001_sas.c    |    3 ++-
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 875b871..6764148 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -576,25 +576,22 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
 	return FAILED;
 }
 
-/* Attempt to send a phy (bus) reset */
 int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 {
-	struct domain_device *dev = cmd_to_domain_dev(cmd);
-	struct sas_phy *phy = sas_get_local_phy(dev);
-	struct Scsi_Host *host = cmd->device->host;
 	int res;
+	struct Scsi_Host *host = cmd->device->host;
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct sas_internal *i = to_sas_internal(host->transportt);
 
 	if (current != host->ehandler)
 		return sas_queue_reset(dev, SAS_DEV_RESET, 0, 0);
 
-	res = sas_phy_reset(phy, 1);
-	if (res)
-		SAS_DPRINTK("Bus reset of %s failed 0x%x\n",
-			    kobject_name(&phy->dev.kobj),
-			    res);
-	sas_put_local_phy(phy);
+	if (!i->dft->lldd_I_T_nexus_reset)
+		return FAILED;
 
-	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
+	res = i->dft->lldd_I_T_nexus_reset(dev);
+	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE ||
+	    res == -ENODEV)
 		return SUCCESS;
 
 	return FAILED;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 3b11edd..fdbba57 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -962,8 +962,9 @@ int pm8001_I_T_nexus_reset(struct domain_device *dev)
 	struct pm8001_device *pm8001_dev;
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_phy *phy;
+
 	if (!dev || !dev->lldd_dev)
-		return -1;
+		return -ENODEV;
 
 	pm8001_dev = dev->lldd_dev;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);

