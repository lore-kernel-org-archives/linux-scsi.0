From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v8 11/13] libsas: use ->lldd_I_T_nexus_reset for
 ->eh_bus_reset_handler
Date: Fri, 10 Feb 2012 00:45:35 -0800
Message-ID: <20120210084535.25701.74616.stgit@dwillia2-linux.jf.intel.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Jack Wang <jack_wang@usish.com>, Luben Tuikov <ltuikov@yahoo.com>, Xiangliang Yu <yuxiangl@marvell.com>
List-Id: linux-scsi@vger.kernel.org

sas_eh_bus_reset_handler() amounts to sas_phy_reset() without
notification of the reset to the lldd.  If this is triggered from
eh-cmnd recovery there may be sas_tasks for the lldd to terminate, so
->lldd_I_T_nexus_reset is warranted.

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>
Cc: Jack Wang <jack_wang@usish.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 82f7532..86ffd8f 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -505,25 +505,22 @@ int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
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
 		return FAILED;
 
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

