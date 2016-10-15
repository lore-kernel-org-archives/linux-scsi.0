From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: Make EXTENDED_COPY 0xe4 failure return COPY TARGET DEVICE NOT REACHABLE
Date: Sat, 15 Oct 2016 05:34:31 +0000
Message-ID: <1476509672-27182-3-git-send-email-nab@linux-iscsi.org>
References: <1476509672-27182-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1476509672-27182-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Vaibhav Tandon <vst@datera.io>, Dinesh Israni <ddi@datera.io>, Nixon Vincent <nixon.vincent@calsoftinc.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a bug where EXTENDED_COPY across multiple LUNs
results in a CHECK_CONDITION when the source + destination are not
located on the same physical node.

ESX Host environments expect sense COPY_ABORTED w/ COPY TARGET DEVICE
NOT REACHABLE to be returned when this occurs, in order to signal
fallback to local copy method.

As described in section 6.3.3 of spc4r22:

  "If it is not possible to complete processing of a segment because the
   copy manager is unable to establish communications with a copy target
   device, because the copy target device does not respond to INQUIRY,
   or because the data returned in response to INQUIRY indicates
   an unsupported logical unit, then the EXTENDED COPY command shall be
   terminated with CHECK CONDITION status, with the sense key set to
   COPY ABORTED, and the additional sense code set to COPY TARGET DEVICE
   NOT REACHABLE."

Tested on v4.1.y with ESX v5.5u2+ with BlockCopy across multiple nodes.

Reported-by: Nixon Vincent <nixon.vincent@calsoftinc.com>
Tested-by: Nixon Vincent <nixon.vincent@calsoftinc.com>
Cc: Nixon Vincent <nixon.vincent@calsoftinc.com>
Tested-by: Dinesh Israni <ddi@datera.io>
Signed-off-by: Dinesh Israni <ddi@datera.io>
Cc: Dinesh Israni <ddi@datera.io>
Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |  7 +++++++
 drivers/target/target_core_xcopy.c     | 22 ++++++++++++++++------
 include/target/target_core_base.h      |  1 +
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 00ec464..000bc6d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1706,6 +1706,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED:
 	case TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED:
 	case TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED:
+	case TCM_COPY_TARGET_DEVICE_NOT_REACHABLE:
 		break;
 	case TCM_OUT_OF_RESOURCES:
 		sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -2873,6 +2874,12 @@ static const struct sense_info sense_info_table[] = {
 		.ascq = 0x03, /* LOGICAL BLOCK REFERENCE TAG CHECK FAILED */
 		.add_sector_info = true,
 	},
+	[TCM_COPY_TARGET_DEVICE_NOT_REACHABLE] = {
+		.key = COPY_ABORTED,
+		.asc = 0x0d,
+		.ascq = 0x02, /* COPY TARGET DEVICE NOT REACHABLE */
+
+	},
 	[TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE] = {
 		/*
 		 * Returning ILLEGAL REQUEST would cause immediate IO errors on
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 75cd854..f2a1443 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -104,7 +104,7 @@ static int target_xcopy_locate_se_dev_e4(struct se_cmd *se_cmd, struct xcopy_op
 	}
 	mutex_unlock(&g_device_mutex);
 
-	pr_err("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
+	pr_debug_ratelimited("Unable to locate 0xe4 descriptor for EXTENDED_COPY\n");
 	return -EINVAL;
 }
 
@@ -185,7 +185,7 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 
 static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 				struct xcopy_op *xop, unsigned char *p,
-				unsigned short tdll)
+				unsigned short tdll, sense_reason_t *sense_ret)
 {
 	struct se_device *local_dev = se_cmd->se_dev;
 	unsigned char *desc = p;
@@ -193,6 +193,8 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 	unsigned short start = 0;
 	bool src = true;
 
+	*sense_ret = TCM_INVALID_PARAMETER_LIST;
+
 	if (offset != 0) {
 		pr_err("XCOPY target descriptor list length is not"
 			" multiple of %d\n", XCOPY_TARGET_DESC_LEN);
@@ -243,9 +245,16 @@ static int target_xcopy_parse_target_descriptors(struct se_cmd *se_cmd,
 		rc = target_xcopy_locate_se_dev_e4(se_cmd, xop, true);
 	else
 		rc = target_xcopy_locate_se_dev_e4(se_cmd, xop, false);
-
-	if (rc < 0)
+	/*
+	 * If a matching IEEE NAA 0x83 descriptor for the requested device
+	 * is not located on this node, return COPY_ABORTED with ASQ/ASQC
+	 * 0x0d/0x02 - COPY_TARGET_DEVICE_NOT_REACHABLE to request the
+	 * initiator to fall back to normal copy method.
+	 */
+	if (rc < 0) {
+		*sense_ret = TCM_COPY_TARGET_DEVICE_NOT_REACHABLE;
 		goto out;
+	}
 
 	pr_debug("XCOPY TGT desc: Source dev: %p NAA IEEE WWN: 0x%16phN\n",
 		 xop->src_dev, &xop->src_tid_wwn[0]);
@@ -816,7 +825,8 @@ out:
 	xcopy_pt_undepend_remotedev(xop);
 	kfree(xop);
 
-	pr_warn("target_xcopy_do_work: Setting X-COPY CHECK_CONDITION -> sending response\n");
+	pr_warn_ratelimited("target_xcopy_do_work: rc: %d, Setting X-COPY CHECK_CONDITION"
+			    " -> sending response\n", rc);
 	ec_cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 	target_complete_cmd(ec_cmd, SAM_STAT_CHECK_CONDITION);
 }
@@ -875,7 +885,7 @@ sense_reason_t target_do_xcopy(struct se_cmd *se_cmd)
 		" tdll: %hu sdll: %u inline_dl: %u\n", list_id, list_id_usage,
 		tdll, sdll, inline_dl);
 
-	rc = target_xcopy_parse_target_descriptors(se_cmd, xop, &p[16], tdll);
+	rc = target_xcopy_parse_target_descriptors(se_cmd, xop, &p[16], tdll, &ret);
 	if (rc <= 0)
 		goto out;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index fb8e3b6..c211900 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -177,6 +177,7 @@ enum tcm_sense_reason_table {
 	TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED	= R(0x15),
 	TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED	= R(0x16),
 	TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED	= R(0x17),
+	TCM_COPY_TARGET_DEVICE_NOT_REACHABLE	= R(0x18),
 #undef R
 };
 
-- 
1.9.1
