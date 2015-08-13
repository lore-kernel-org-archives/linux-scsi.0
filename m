From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] target/qla2xxx: Honor max_data_sg_nents I/O transfer limit
Date: Thu, 13 Aug 2015 08:45:50 +0000
Message-ID: <1439455550-2626-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35535 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbbHMIvK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 04:51:10 -0400
Received: by obbop1 with SMTP id op1so32328605obb.2
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 01:51:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Craig Watson <craig.watson@vanguard-rugged.com>, Roland Dreier <roland@purestorage.com>, Arun Easi <arun.easi@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Arun, Roland & Co,

Based upon the feedback from last week, here is a proper
patch for target-core to honor a fabric provided SGL limit
using residual count plus underflow response bit.

Everything appears to be working as expected with tcm-loop
LUNs with basic I/O and sg_raw to test CDB underflow, but
still needs to be verified on real qla2xxx hardware over
the next days for v4.2.0 code.

Please review + test.

--nab

This patch adds an optional fabric driver provided SGL limit
that target-core will honor as it's own internal I/O maximum
transfer length limit, as exposed by EVPD=0xb0 block limits
parameters.

This is required for handling cases when host I/O transfer
length exceeds the requested EVPD block limits maximum
transfer length. The initial user of this logic is qla2xxx,
so that we can avoid having to reject I/Os from some legacy
FC hosts where EVPD=0xb0 parameters are not honored.

When se_cmd payload length exceeds the provided limit in
target_check_max_data_sg_nents() code, se_cmd->data_length +
se_cmd->prot_length are reset with se_cmd->residual_count
plus underflow bit for outgoing TFO response callbacks.
It also checks for existing CDB level underflow + overflow
and recalculates final residual_count as necessary.

Note this patch currently assumes 1:1 mapping of PAGE_SIZE
per struct scatterlist entry.

Reported-by: Craig Watson <craig.watson@vanguard-rugged.com>
Cc: Craig Watson <craig.watson@vanguard-rugged.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  5 ++++
 drivers/target/target_core_spc.c       | 13 +++++++--
 drivers/target/target_core_transport.c | 51 +++++++++++++++++++++++++++++++++-
 include/target/target_core_fabric.h    | 13 +++++++++
 4 files changed, 78 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 9224a06..6649809 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1804,6 +1804,11 @@ static const struct target_core_fabric_ops tcm_qla2xxx_ops = {
 	.module				= THIS_MODULE,
 	.name				= "qla2xxx",
 	.node_acl_size			= sizeof(struct tcm_qla2xxx_nacl),
+	/*
+	 * XXX: Limit assumes single page per scatter-gather-list entry.
+	 * Current maximum is ~4.9 MB per se_cmd->t_data_sg with PAGE_SIZE=4096
+	 */
+	.max_data_sg_nents		= 1200,
 	.get_fabric_name		= tcm_qla2xxx_get_fabric_name,
 	.tpg_get_wwn			= tcm_qla2xxx_get_fabric_wwn,
 	.tpg_get_tag			= tcm_qla2xxx_get_tag,
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 556ea1b..da6130a 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -484,8 +484,8 @@ static sense_reason_t
 spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 {
 	struct se_device *dev = cmd->se_dev;
-	int have_tp = 0;
-	int opt, min;
+	u32 mtl = 0;
+	int have_tp = 0, opt, min;
 
 	/*
 	 * Following spc3r22 section 6.5.3 Block Limits VPD page, when
@@ -516,8 +516,15 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 
 	/*
 	 * Set MAXIMUM TRANSFER LENGTH
+	 *
+	 * XXX: Currently assumes single PAGE_SIZE per scatterlist for fabrics
+	 * enforcing maximum HW scatter-gather-list entry limit
 	 */
-	put_unaligned_be32(dev->dev_attrib.hw_max_sectors, &buf[8]);
+	if (cmd->se_tfo->max_data_sg_nents) {
+		mtl = (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE) /
+		       dev->dev_attrib.block_size;
+	}
+	put_unaligned_be32(min_not_zero(mtl, dev->dev_attrib.hw_max_sectors), &buf[8]);
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ce8574b..652471a1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1074,6 +1074,55 @@ transport_set_vpd_ident(struct t10_vpd *vpd, unsigned char *page_83)
 }
 EXPORT_SYMBOL(transport_set_vpd_ident);
 
+static sense_reason_t
+target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
+			       unsigned int size)
+{
+	u32 mtl;
+
+	if (!cmd->se_tfo->max_data_sg_nents)
+		return TCM_NO_SENSE;
+	/*
+	 * Check if fabric enforced maximum SGL entries per I/O descriptor
+	 * exceeds se_cmd->data_length.  If true, set SCF_UNDERFLOW_BIT +
+	 * residual_count and reduce original cmd->data_length to maximum
+	 * length based on single PAGE_SIZE entry scatter-lists.
+	 */
+	mtl = (cmd->se_tfo->max_data_sg_nents * PAGE_SIZE);
+	if (cmd->data_length > mtl) {
+		/*
+		 * If an existing CDB overflow is present, calculate new residual
+		 * based on CDB size minus fabric maximum transfer length.
+		 *
+		 * If an existing CDB underflow is present, calculate new residual
+		 * based on original cmd->data_length minus fabric maximum transfer
+		 * length.
+		 *
+		 * Otherwise, set the underflow residual based on cmd->data_length
+		 * minus fabric maximum transfer length.
+		 */
+		if (cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
+			cmd->residual_count = (size - mtl);
+		} else if (cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
+			u32 orig_dl = size + cmd->residual_count;
+			cmd->residual_count = (orig_dl - mtl);
+		} else {
+			cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
+			cmd->residual_count = (cmd->data_length - mtl);
+		}
+		cmd->data_length = mtl;
+		/*
+		 * Reset sbc_check_prot() calculated protection payload
+		 * length based upon the new smaller MTL.
+		 */
+		if (cmd->prot_length) {
+			u32 sectors = (mtl / dev->dev_attrib.block_size);
+			cmd->prot_length = dev->prot_length * sectors;
+		}
+	}
+	return TCM_NO_SENSE;
+}
+
 sense_reason_t
 target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 {
@@ -1119,7 +1168,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
 		}
 	}
 
-	return 0;
+	return target_check_max_data_sg_nents(cmd, dev, size);
 
 }
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 18afef9..995f2e1 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -5,6 +5,19 @@ struct target_core_fabric_ops {
 	struct module *module;
 	const char *name;
 	size_t node_acl_size;
+	/*
+	 * Limits number of scatterlist entries per SCF_SCSI_DATA_CDB payload.
+	 * Setting this value tells target-core to enforce this limit, and
+	 * report as INQUIRY EVPD=b0 MAXIMUM TRANSFER LENGTH.
+	 *
+	 * target-core will currently reset se_cmd->data_length to this
+	 * maximum size, and set OVERFLOW residual count if length exceeds
+	 * this limit.
+	 *
+	 * XXX: Not all initiator hosts honor this block-limit EVPD
+	 * XXX: Currently assumes single PAGE_SIZE per scatterlist entry
+	 */
+	u32 max_data_sg_nents;
 	char *(*get_fabric_name)(void);
 	char *(*tpg_get_wwn)(struct se_portal_group *);
 	u16 (*tpg_get_tag)(struct se_portal_group *);
-- 
1.9.1

