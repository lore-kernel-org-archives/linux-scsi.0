From: Alan Cox <alan@redhat.com>
Subject: PATCH: Fix assorted dma_addr_t typing errors in ipr driver
Date: Mon, 28 Jun 2004 10:07:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040628140721.GA10393@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:18116 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S264954AbUF1OHp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 10:07:45 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.10/8.12.10) with ESMTP id i5SE7je1005117
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2004 10:07:45 -0400
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id i5SE7j007053
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2004 10:07:45 -0400
Received: from devserv.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by devserv.devel.redhat.com (8.12.11/8.12.10) with ESMTP id i5SE7LxC012112
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jun 2004 10:07:21 -0400
Received: (from alan@localhost)
	by devserv.devel.redhat.com (8.12.11/8.12.11/Submit) id i5SE7LM1012110
	for linux-scsi@vger.kernel.org; Mon, 28 Jun 2004 10:07:21 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

(Not cc the author since the authors email address seems to be an IBM state
 secret.. 8))


diff -u --new-file --recursive --exclude-from /usr/src/exclude linux-2.6.7/drivers/scsi/ipr.c linux-2.6.7-viroized/drivers/scsi/ipr.c
--- linux-2.6.7/drivers/scsi/ipr.c	2004-06-16 21:11:36.000000000 +0100
+++ linux-2.6.7-viroized/drivers/scsi/ipr.c	2004-06-27 20:07:29.218694904 +0100
@@ -5441,7 +5441,7 @@
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioarcb *ioarcb;
-	u32 dma_addr;
+	dma_addr_t dma_addr;
 	int i;
 
 	ioa_cfg->ipr_cmd_pool = pci_pool_create (IPR_NAME, ioa_cfg->pdev,
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux-2.6.7/drivers/scsi/ipr.h linux-2.6.7-viroized/drivers/scsi/ipr.h
--- linux-2.6.7/drivers/scsi/ipr.h	2004-06-16 21:11:36.000000000 +0100
+++ linux-2.6.7-viroized/drivers/scsi/ipr.h	2004-06-27 20:09:47.231713736 +0100
@@ -19,6 +19,8 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  *
+ * Alan Cox <alan@redhat.com> - Removed several careless u32/dma_addr_t errors
+ *				that broke 64bit platforms.
  */
 
 #ifndef _IPR_H
@@ -667,7 +669,7 @@
 
 struct ipr_hostrcb {
 	struct ipr_hcam hcam;
-	u32 hostrcb_dma;
+	dma_addr_t hostrcb_dma;
 	struct list_head queue;
 };
 
@@ -850,7 +852,7 @@
 	char cfg_table_start[8];
 #define IPR_CFG_TBL_START		"cfg"
 	struct ipr_config_table *cfg_table;
-	u32 cfg_table_dma;
+	dma_addr_t cfg_table_dma;
 
 	char resource_table_label[8];
 #define IPR_RES_TABLE_LABEL		"res_tbl"
@@ -861,12 +863,12 @@
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
@@ -905,7 +907,7 @@
 	enum ipr_sdt_state sdt_state;
 
 	struct ipr_misc_cbs *vpd_cbs;
-	u32 vpd_cbs_dma;
+	dma_addr_t vpd_cbs_dma;
 
 	struct pci_pool *ipr_cmd_pool;
 



----

Signed-off-by: Alan Cox <alan@redhat.com>

Developer's Certificate of Origin 1.0 included herein by reference.

