From: Artur Wojcik <artur.wojcik@intel.com>
Subject: [PATCH] libsas: add SMP READ/WRTIE GPIO support
Date: Wed, 01 Jun 2011 16:02:03 +0200
Message-ID: <20110601140203.26324.22849.stgit@gklab-128-184.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab1FAOCf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2011 10:02:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

This patch enables the SMP READ/WRITE GPIO function interface in libsas SMP
host module. The interface is used to control the SGPIO initiator in the SAS
initiator. The implementation is SFF-8485 and SAS-2 compliant.

There are two functions in transport class only responsible for reading and
writting GPIO registers. I decided to leave the decission about what type of
registers are supported to lldd.

Now the user space application may issue SMP READ/WRITE GPIO frame to HBA in
order to read/write GPIO registers.

Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
---
 drivers/scsi/libsas/sas_host_smp.c |   48 +++++++++++++++++++++++++++++++++++-
 include/scsi/libsas.h              |   14 +++++++++++
 include/scsi/sas.h                 |    4 +++
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
index 04ad8dd..2d34cb6 100644
--- a/drivers/scsi/libsas/sas_host_smp.c
+++ b/drivers/scsi/libsas/sas_host_smp.c
@@ -51,6 +51,40 @@ static void sas_host_smp_discover(struct sas_ha_struct *sas_ha, u8 *resp_data,
 	resp_data[15] = rphy->identify.target_port_protocols;
 }
 
+static void sas_host_smp_read_gpio(struct sas_ha_struct *sas_ha, u8 *resp_data,
+	u8 reg_type, u8 reg_index, u8 reg_count)
+{
+	struct sas_internal *i =
+		to_sas_internal(sas_ha->core.shost->transportt);
+
+	if (i->dft->lldd_read_gpio == NULL) {
+		resp_data[2] = SMP_RESP_FUNC_UNK;
+	} else {
+		if (i->dft->lldd_read_gpio(sas_ha, reg_type, reg_index,
+					   reg_count, &resp_data[4]) == 0)
+			resp_data[2] = SMP_RESP_FUNC_ACC;
+		else
+			resp_data[2] = SMP_RESP_FUNC_FAILED;
+	}
+}
+
+static void sas_host_smp_write_gpio(struct sas_ha_struct *sas_ha, u8 *resp_data,
+	u8 reg_type, u8 reg_index, u8 reg_count, u8 *write_data)
+{
+	struct sas_internal *i =
+		to_sas_internal(sas_ha->core.shost->transportt);
+
+	if (i->dft->lldd_write_gpio == NULL) {
+		resp_data[2] = SMP_RESP_FUNC_UNK;
+	} else {
+		if (i->dft->lldd_write_gpio(sas_ha, reg_type, reg_index,
+					    reg_count, &resp_data[8]) == 0)
+			resp_data[2] = SMP_RESP_FUNC_ACC;
+		else
+			resp_data[2] = SMP_RESP_FUNC_FAILED;
+	}
+}
+
 static void sas_report_phy_sata(struct sas_ha_struct *sas_ha, u8 *resp_data,
 				u8 phy_id)
 {
@@ -195,8 +229,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		       SAS_EXPANDER_PRODUCT_ID_LEN);
 		break;
 
+	case SMP_READ_GPIO_REG_ENHANCED:
 	case SMP_READ_GPIO_REG:
-		/* FIXME: need GPIO support in the transport class */
+		if (req->resid_len != 12)
+			resp_data[2] = SMP_RESP_INV_FRM_LEN;
+		else
+			sas_host_smp_read_gpio(sas_ha, resp_data, req_data[2],
+				req_data[3], req_data[4]);
 		break;
 
 	case SMP_DISCOVER:
@@ -230,8 +269,13 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
 		/* Can't implement; hosts have no routes */
 		break;
 
+	case SMP_WRITE_GPIO_REG_ENHANCED:
 	case SMP_WRITE_GPIO_REG:
-		/* FIXME: need GPIO support in the transport class */
+		if (req->resid_len < (req_data[4] * 4) + 8)
+			resp_data[2] = SMP_RESP_INV_FRM_LEN;
+		else
+			sas_host_smp_write_gpio(sas_ha, resp_data, req_data[2],
+				req_data[3], req_data[4], &req_data[5]);
 		break;
 
 	case SMP_CONF_ROUTE_INFO:
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8f6bb9c..6d876ca 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -56,6 +56,14 @@ enum sas_phy_type {
         PHY_TYPE_VIRTUAL
 };
 
+enum gpio_reg_type {
+	GPIO_REG_CFG = 0,
+	GPIO_REG_RX = 1,
+	GPIO_REG_RX_GP = 2,
+	GPIO_REG_TX = 3,
+	GPIO_REG_TX_GP = 4,
+};
+
 /* The events are mnemonically described in sas_dump.c
  * so when updating/adding events here, please also
  * update the other file too.
@@ -613,6 +621,12 @@ struct sas_domain_function_template {
 
 	/* Phy management */
 	int (*lldd_control_phy)(struct asd_sas_phy *, enum phy_func, void *);
+
+	/* GPIO support */
+	int (*lldd_read_gpio)(struct sas_ha_struct *, u8 reg_type,
+			      u8 reg_index, u8 reg_count, u8 *read_data);
+	int (*lldd_write_gpio)(struct sas_ha_struct *, u8 reg_type,
+			       u8 reg_index, u8 reg_count, u8 *write_data);
 };
 
 extern int sas_register_ha(struct sas_ha_struct *);
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index e9fd022..253094d 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -54,6 +54,10 @@
 #define SMP_PHY_CONTROL          0x91
 #define SMP_PHY_TEST_FUNCTION    0x92
 
+/* SAS-2 specific */
+#define SMP_READ_GPIO_REG_ENHANCED    0x07
+#define SMP_WRITE_GPIO_REG_ENHANCED   0x83
+
 #define SMP_RESP_FUNC_ACC        0x00
 #define SMP_RESP_FUNC_UNK        0x01
 #define SMP_RESP_FUNC_FAILED     0x02

