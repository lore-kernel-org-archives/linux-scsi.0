From: brking@us.ibm.com
Subject: [PATCH 02/16] ipr: Fix assorted dma_addr_t typing errors
Date: Wed, 04 Aug 2004 17:31:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042232.i74MWpCu134930@northrelay02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:57508 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S267467AbUHDWb5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:31:57 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com, alan@redhat.com



From: Alan Cox <alan@redhat.com>
Subject: PATCH: Fix assorted dma_addr_t typing errors in ipr driver

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |    2 +-
 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_dma_addr_fixes drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_dma_addr_fixes	2004-08-04 17:17:24.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:24.000000000 -0500
@@ -5458,7 +5458,7 @@ static int __devinit ipr_alloc_cmd_blks(
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioarcb *ioarcb;
-	u32 dma_addr;
+	dma_addr_t dma_addr;
 	int i;
 
 	ioa_cfg->ipr_cmd_pool = pci_pool_create (IPR_NAME, ioa_cfg->pdev,
diff -puN drivers/scsi/ipr.h~ipr_dma_addr_fixes drivers/scsi/ipr.h
--- linux-2.6.8-rc3/drivers/scsi/ipr.h~ipr_dma_addr_fixes	2004-08-04 17:17:24.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h	2004-08-04 17:17:24.000000000 -0500
@@ -19,6 +19,8 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
+ * Alan Cox <alan@redhat.com> - Removed several careless u32/dma_addr_t errors
+ *				that broke 64bit platforms.
  */
 
 #ifndef _IPR_H
@@ -667,7 +669,7 @@ struct ipr_hcam {
 
 struct ipr_hostrcb {
 	struct ipr_hcam hcam;
-	u32 hostrcb_dma;
+	dma_addr_t hostrcb_dma;
 	struct list_head queue;
 };
 
@@ -850,7 +852,7 @@ struct ipr_ioa_cfg {
 	char cfg_table_start[8];
 #define IPR_CFG_TBL_START		"cfg"
 	struct ipr_config_table *cfg_table;
-	u32 cfg_table_dma;
+	dma_addr_t cfg_table_dma;
 
 	char resource_table_label[8];
 #define IPR_RES_TABLE_LABEL		"res_tbl"
@@ -861,12 +863,12 @@ struct ipr_ioa_cfg {
 	char ipr_hcam_label[8];
 #define IPR_HCAM_LABEL			"hcams"
 	struct ipr_hostrcb *hostrcb[IPR_NUM_HCAMS];
-	u32 hostrcb_dma[IPR_NUM_HCAMS];
+	dma_addr_t hostrcb_dma[IPR_NUM_HCAMS];
 	struct list_head hostrcb_free_q;
 	struct list_head hostrcb_pending_q;
 
 	u32 *host_rrq;
-	u32 host_rrq_dma;
+	dma_addr_t host_rrq_dma;
 #define IPR_HRRQ_REQ_RESP_HANDLE_MASK	0xfffffffc
 #define IPR_HRRQ_RESP_BIT_SET			0x00000002
 #define IPR_HRRQ_TOGGLE_BIT				0x00000001
@@ -905,7 +907,7 @@ struct ipr_ioa_cfg {
 	enum ipr_sdt_state sdt_state;
 
 	struct ipr_misc_cbs *vpd_cbs;
-	u32 vpd_cbs_dma;
+	dma_addr_t vpd_cbs_dma;
 
 	struct pci_pool *ipr_cmd_pool;
 
_
