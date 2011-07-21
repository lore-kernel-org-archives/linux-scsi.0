From: <kgudipat@brocade.com>
Subject: [PATCH 11/15] bfa: Add support to collect fabric stats.
Date: Wed, 20 Jul 2011 17:03:27 -0700
Message-ID: <1311206607-10543-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56091 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751957Ab1GUADq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 20:03:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Added support to collect / reset fabric stats.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_bsg.c |   51 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_bsg.h |   15 ++++++++++++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 2109ed3..66349bd 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2349,6 +2349,51 @@ out:
 	return 0;
 }
 
+int
+bfad_iocmd_vf_get_stats(struct bfad_s *bfad, void *cmd)
+{
+	struct bfa_bsg_vf_stats_s *iocmd =
+			(struct bfa_bsg_vf_stats_s *)cmd;
+	struct bfa_fcs_fabric_s	*fcs_vf;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_vf = bfa_fcs_vf_lookup(&bfad->bfa_fcs, iocmd->vf_id);
+	if (fcs_vf == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		iocmd->status = BFA_STATUS_UNKNOWN_VFID;
+		goto out;
+	}
+	memcpy((void *)&iocmd->stats, (void *)&fcs_vf->stats,
+		sizeof(struct bfa_vf_stats_s));
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	iocmd->status = BFA_STATUS_OK;
+out:
+	return 0;
+}
+
+int
+bfad_iocmd_vf_clr_stats(struct bfad_s *bfad, void *cmd)
+{
+	struct bfa_bsg_vf_reset_stats_s *iocmd =
+			(struct bfa_bsg_vf_reset_stats_s *)cmd;
+	struct bfa_fcs_fabric_s	*fcs_vf;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	fcs_vf = bfa_fcs_vf_lookup(&bfad->bfa_fcs, iocmd->vf_id);
+	if (fcs_vf == NULL) {
+		spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+		iocmd->status = BFA_STATUS_UNKNOWN_VFID;
+		goto out;
+	}
+	memset((void *)&fcs_vf->stats, 0, sizeof(struct bfa_vf_stats_s));
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+	iocmd->status = BFA_STATUS_OK;
+out:
+	return 0;
+}
+
 static int
 bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 		unsigned int payload_len)
@@ -2661,6 +2706,12 @@ bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 	case IOCMD_QOS_RESET_STATS:
 		rc = bfad_iocmd_qos_reset_stats(bfad, iocmd);
 		break;
+	case IOCMD_VF_GET_STATS:
+		rc = bfad_iocmd_vf_get_stats(bfad, iocmd);
+		break;
+	case IOCMD_VF_RESET_STATS:
+		rc = bfad_iocmd_vf_clr_stats(bfad, iocmd);
+		break;
 	default:
 		rc = -EINVAL;
 		break;
diff --git a/drivers/scsi/bfa/bfad_bsg.h b/drivers/scsi/bfa/bfad_bsg.h
index 3c0ce22..1e02652 100644
--- a/drivers/scsi/bfa/bfad_bsg.h
+++ b/drivers/scsi/bfa/bfad_bsg.h
@@ -135,6 +135,8 @@ enum {
 	IOCMD_QOS_GET_VC_ATTR,
 	IOCMD_QOS_GET_STATS,
 	IOCMD_QOS_RESET_STATS,
+	IOCMD_VF_GET_STATS,
+	IOCMD_VF_RESET_STATS,
 };
 
 struct bfa_bsg_gen_s {
@@ -686,6 +688,19 @@ struct bfa_bsg_qos_vc_attr_s {
 	struct bfa_qos_vc_attr_s attr;
 };
 
+struct bfa_bsg_vf_stats_s {
+	bfa_status_t	status;
+	u16		bfad_num;
+	u16		vf_id;
+	struct bfa_vf_stats_s	stats;
+};
+
+struct bfa_bsg_vf_reset_stats_s {
+	bfa_status_t	status;
+	u16		bfad_num;
+	u16		vf_id;
+};
+
 struct bfa_bsg_fcpt_s {
 	bfa_status_t    status;
 	u16		vf_id;
-- 
1.7.3.rc1

