From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/5] bfa: rename some global variables
Date: Tue,  2 Aug 2016 17:22:48 +0200
Message-ID: <20160802152250.1964074-4-arnd@arndb.de>
References: <20160802152250.1964074-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160802152250.1964074-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Baoyou Xie <baoyou.xie@linaro.org>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

The global "supported_fc4s" and "max_xfer_size" variables have rather
generic names that might conflict with the same identifiers used in
other drivers, and we cannot make them 'static' because they are both
used across multiple files.

This adds a 'bfa_' prefix to ensure the identifiers are globally unique.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/bfa/bfad.c      | 20 ++++++++++----------
 drivers/scsi/bfa/bfad_attr.c |  2 +-
 drivers/scsi/bfa/bfad_drv.h  |  4 ++--
 drivers/scsi/bfa/bfad_im.c   |  6 +++---
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 9b010b999825..3cb11f6c0b28 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -42,7 +42,7 @@ static LIST_HEAD(bfad_list);
 
 int	bfad_inst;
 static int      num_sgpgs_parm;
-int		supported_fc4s;
+int		bfa_supported_fc4s;
 static char	*host_name, *os_name, *os_patch;
 static int	num_rports, num_ios, num_tms;
 static int	num_fcxps, num_ufbufs;
@@ -57,7 +57,7 @@ static int	fdmi_enable = BFA_TRUE;
 static int	pcie_max_read_reqsz;
 int		bfa_debugfs_enable = 1;
 static int	msix_disable_cb = 0, msix_disable_ct = 0;
-int		max_xfer_size = BFAD_MAX_SECTORS >> 1;
+int		bfa_max_xfer_size = BFAD_MAX_SECTORS >> 1;
 static int	max_rport_logins = BFA_FCS_MAX_RPORT_LOGINS;
 
 /* Firmware releated */
@@ -143,7 +143,7 @@ MODULE_PARM_DESC(pcie_max_read_reqsz, "PCIe max read request size, default=0 "
 module_param(bfa_debugfs_enable, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(bfa_debugfs_enable, "Enables debugfs feature, default=1,"
 		" Range[false:0|true:1]");
-module_param(max_xfer_size, int, S_IRUGO | S_IWUSR);
+module_param_named(max_xfer_size, bfa_max_xfer_size, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_xfer_size, "default=32MB,"
 		" Range[64k|128k|256k|512k|1024k|2048k]");
 module_param(max_rport_logins, int, S_IRUGO | S_IWUSR);
@@ -945,7 +945,7 @@ bfad_cfg_pport(struct bfad_s *bfad, enum bfa_lport_role role)
 	int		rc = BFA_STATUS_OK;
 
 	/* Allocate scsi_host for the physical port */
-	if ((supported_fc4s & BFA_LPORT_ROLE_FCP_IM) &&
+	if ((bfa_supported_fc4s & BFA_LPORT_ROLE_FCP_IM) &&
 	    (role & BFA_LPORT_ROLE_FCP_IM)) {
 		if (bfad->pport.im_port == NULL) {
 			rc = BFA_STATUS_FAILED;
@@ -969,7 +969,7 @@ out:
 static void
 bfad_uncfg_pport(struct bfad_s *bfad)
 {
-	if ((supported_fc4s & BFA_LPORT_ROLE_FCP_IM) &&
+	if ((bfa_supported_fc4s & BFA_LPORT_ROLE_FCP_IM) &&
 	    (bfad->pport.roles & BFA_LPORT_ROLE_FCP_IM)) {
 		bfad_im_scsi_host_free(bfad, bfad->pport.im_port);
 		bfad_im_port_clean(bfad->pport.im_port);
@@ -990,10 +990,10 @@ bfad_start_ops(struct bfad_s *bfad)
 	struct bfa_fcs_driver_info_s driver_info;
 
 	/* Limit min/max. xfer size to [64k-32MB] */
-	if (max_xfer_size < BFAD_MIN_SECTORS >> 1)
-		max_xfer_size = BFAD_MIN_SECTORS >> 1;
-	if (max_xfer_size > BFAD_MAX_SECTORS >> 1)
-		max_xfer_size = BFAD_MAX_SECTORS >> 1;
+	if (bfa_max_xfer_size < BFAD_MIN_SECTORS >> 1)
+		bfa_max_xfer_size = BFAD_MIN_SECTORS >> 1;
+	if (bfa_max_xfer_size > BFAD_MAX_SECTORS >> 1)
+		bfa_max_xfer_size = BFAD_MAX_SECTORS >> 1;
 
 	/* Fill the driver_info info to fcs*/
 	memset(&driver_info, 0, sizeof(driver_info));
@@ -1734,7 +1734,7 @@ bfad_init(void)
 	}
 
 	if (strcmp(FCPI_NAME, " fcpim") == 0)
-		supported_fc4s |= BFA_LPORT_ROLE_FCP_IM;
+		bfa_supported_fc4s |= BFA_LPORT_ROLE_FCP_IM;
 
 	bfa_auto_recover = ioc_auto_recover;
 	bfa_fcs_rport_set_del_timeout(rport_del_timeout);
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index d6a5edabf1ff..f49c6a7e6323 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -416,7 +416,7 @@ bfad_im_vport_create(struct fc_vport *fc_vport, bool disable)
 			sizeof(fc_host_supported_fc4s(vshost)));
 
 		/* For FCP type 0x08 */
-		if (supported_fc4s & BFA_LPORT_ROLE_FCP_IM)
+		if (bfa_supported_fc4s & BFA_LPORT_ROLE_FCP_IM)
 			fc_host_supported_fc4s(vshost)[2] = 1;
 
 		/* For fibre channel services type 0x20 */
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index b70870411af6..6c5b81708a08 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -311,8 +311,8 @@ int bfad_get_linkup_delay(struct bfad_s *bfad);
 extern int      bfa_lun_queue_depth;
 extern int      bfa_log_level;
 extern int      bfa_linkup_delay;
-extern int      supported_fc4s;
-extern int	max_xfer_size;
+extern int      bfa_supported_fc4s;
+extern int	bfa_max_xfer_size;
 extern int bfa_debugfs_enable;
 extern struct mutex bfad_mutex;
 
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index f56a22a640ea..50270e6188e9 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -759,8 +759,8 @@ bfad_scsi_host_alloc(struct bfad_im_port_s *im_port, struct bfad_s *bfad)
 	else
 		sht = &bfad_im_vport_template;
 
-	if (max_xfer_size != BFAD_MAX_SECTORS >> 1)
-		sht->max_sectors = max_xfer_size << 1;
+	if (bfa_max_xfer_size != BFAD_MAX_SECTORS >> 1)
+		sht->max_sectors = bfa_max_xfer_size << 1;
 
 	sht->sg_tablesize = bfad->cfg_data.io_max_sge;
 
@@ -1065,7 +1065,7 @@ bfad_fc_host_init(struct bfad_im_port_s *im_port)
 
 	memset(fc_host_supported_fc4s(host), 0,
 	       sizeof(fc_host_supported_fc4s(host)));
-	if (supported_fc4s & BFA_LPORT_ROLE_FCP_IM)
+	if (bfa_supported_fc4s & BFA_LPORT_ROLE_FCP_IM)
 		/* For FCP type 0x08 */
 		fc_host_supported_fc4s(host)[2] = 1;
 	/* For fibre channel services type 0x20 */
-- 
2.9.0
