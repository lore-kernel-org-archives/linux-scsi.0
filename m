From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: [PATCH 5/8] qla4xxx: updated mbx_sys_info struct to sync with FW
	4.6.x
Date: Fri, 30 Jul 2010 14:27:45 +0530
Message-ID: <20100730085744.GA12314@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:19090
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1754321Ab0G3JBH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 05:01:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, ravi.anand@qlogic.com, michaelc@cs.wisc.edu

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>

Also, changed boundary checking from size of total
structure to verification that we received the amount of
data needed to cache inernally. This change will provide
compatibility with mbx_sys_info structure sizes in both
older and newer firmware versions.
---
 drivers/scsi/qla4xxx/ql4_fw.h |   20 ++++++++++----------
 drivers/scsi/qla4xxx/ql4_nx.c |    3 ++-
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index c94c9dd..0336c6d 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -673,17 +673,17 @@ struct flash_sys_info {
 };	/* 200 */
 
 struct mbx_sys_info {
-	uint8_t board_id_str[16];	/* Keep board ID string first */
-					/* in this structure for GUI. */
-	uint16_t board_id;	/* board ID code */
-	uint16_t phys_port_cnt;	/* number of physical network ports */
-	uint16_t port_num;	/* network port for this PCI function */
+	uint8_t board_id_str[16];   /*  0-f  Keep board ID string first */
+				/* in this structure for GUI. */
+	uint16_t board_id;	/* 10-11 board ID code */
+	uint16_t phys_port_cnt;	/* 12-13 number of physical network ports */
+	uint16_t port_num;	/* 14-15 network port for this PCI function */
 				/* (port 0 is first port) */
-	uint8_t mac_addr[6];	/* MAC address for this PCI function */
-	uint32_t iscsi_pci_func_cnt;	/* number of iSCSI PCI functions */
-	uint32_t pci_func;		/* this PCI function */
-	unsigned char serial_number[16];	/* serial number string */
-	uint8_t reserved[16];
+	uint8_t mac_addr[6];	/* 16-1b MAC address for this PCI function */
+	uint32_t iscsi_pci_func_cnt;  /* 1c-1f number of iSCSI PCI functions */
+	uint32_t pci_func;	      /* 20-23 this PCI function */
+	unsigned char serial_number[16];  /* 24-33 serial number string */
+	uint8_t reserved[12];		  /* 34-3f */
 };
 
 struct crash_record {
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 3e119ae..ec46651 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -2145,7 +2145,8 @@ int qla4_8xxx_get_sys_info(struct scsi_qla_host *ha)
 		goto exit_validate_mac82;
 	}
 
-	if (mbox_sts[4] < sizeof(*sys_info)) {
+	/* Make sure we receive the minimum required data to cache internally */
+	if (mbox_sts[4] < offsetof(struct mbx_sys_info, reserved)) {
 		DEBUG2(printk("scsi%ld: %s: GET_SYS_INFO data receive"
 		    " error (%x)\n", ha->host_no, __func__, mbox_sts[4]));
 		goto exit_validate_mac82;
-- 
1.6.6

