From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 03/15] target: Update SPC/SBC emulation for sess_prot_type
Date: Mon, 30 Mar 2015 03:28:12 +0000
Message-ID: <1427686104-14231-4-git-send-email-nab@daterainc.com>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, Doug Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates standard INQUIRY, INQUIRY EVPD=0x86, READ_CAPACITY_16
and control mode pages to use se_sess->sess_prot_type when determing which
type of T10-PI related feature bits can be exposed.

This is required for fabric sessions supporting T10-PI metadata to
backend devices that don't have protection enabled.

Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 13 +++++++++++--
 drivers/target/target_core_spc.c | 14 +++++++++-----
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 5b3564a..68373c9 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -93,6 +93,8 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
+	int pi_prot_type = dev->dev_attrib.pi_prot_type;
+
 	unsigned char *rbuf;
 	unsigned char buf[32];
 	unsigned long long blocks = dev->transport->get_blocks(dev);
@@ -114,8 +116,15 @@ sbc_emulate_readcapacity_16(struct se_cmd *cmd)
 	 * Set P_TYPE and PROT_EN bits for DIF support
 	 */
 	if (sess->sup_prot_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS)) {
-		if (dev->dev_attrib.pi_prot_type)
-			buf[12] = (dev->dev_attrib.pi_prot_type - 1) << 1 | 0x1;
+		/*
+		 * Only override a device's pi_prot_type if no T10-PI is
+		 * available, and sess_prot_type has been explicitly enabled.
+		 */
+		if (!pi_prot_type)
+			pi_prot_type = sess->sess_prot_type;
+
+		if (pi_prot_type)
+			buf[12] = (pi_prot_type - 1) << 1 | 0x1;
 	}
 
 	if (dev->transport->get_lbppbe)
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f310aac..9ec6459 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -103,10 +103,12 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 		buf[5] |= 0x8;
 	/*
 	 * Set Protection (PROTECT) bit when DIF has been enabled on the
-	 * device, and the transport supports VERIFY + PASS.
+	 * device, and the fabric supports VERIFY + PASS.  Also report
+	 * PROTECT=1 if sess_prot_type has been configured to allow T10-PI
+	 * to unprotected devices.
 	 */
 	if (sess->sup_prot_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS)) {
-		if (dev->dev_attrib.pi_prot_type)
+		if (dev->dev_attrib.pi_prot_type || cmd->se_sess->sess_prot_type)
 			buf[5] |= 0x1;
 	}
 
@@ -480,9 +482,11 @@ spc_emulate_evpd_86(struct se_cmd *cmd, unsigned char *buf)
 	 * only for TYPE3 protection.
 	 */
 	if (sess->sup_prot_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS)) {
-		if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT)
+		if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE1_PROT ||
+		    cmd->se_sess->sess_prot_type == TARGET_DIF_TYPE1_PROT)
 			buf[4] = 0x5;
-		else if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE3_PROT)
+		else if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE3_PROT ||
+			cmd->se_sess->sess_prot_type == TARGET_DIF_TYPE3_PROT)
 			buf[4] = 0x4;
 	}
 
@@ -874,7 +878,7 @@ static int spc_modesense_control(struct se_cmd *cmd, u8 pc, u8 *p)
 	 * TAG field.
 	 */
 	if (sess->sup_prot_ops & (TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS)) {
-		if (dev->dev_attrib.pi_prot_type)
+		if (dev->dev_attrib.pi_prot_type || sess->sess_prot_type)
 			p[5] |= 0x80;
 	}
 
-- 
1.9.1
