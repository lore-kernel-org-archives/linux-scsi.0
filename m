From: <kgudipat@brocade.com>
Subject: [PATCH 09/15] bfa: Add support to configure trunking on Brocade adapter ports.
Date: Wed, 20 Jul 2011 17:02:50 -0700
Message-ID: <1311206570-7930-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:56074 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab1GUADJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jul 2011 20:03:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, adapter_linux_open_src_team@brocade.com, kgudipat@brocade.com

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Added logic to enable / disable trunking on Brocade adapter ports.
	- Added logic to query trunking info.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/bfad_bsg.c |   54 +++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/bfa/bfad_bsg.h |   10 ++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index f782ee4..55a9180 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2181,6 +2181,53 @@ out:
 	return 0;
 }
 
+int
+bfad_iocmd_cfg_trunk(struct bfad_s *bfad, void *cmd, unsigned int v_cmd)
+{
+	struct bfa_bsg_gen_s *iocmd = (struct bfa_bsg_gen_s *)cmd;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(&bfad->bfa);
+	struct bfa_fcport_trunk_s *trunk = &fcport->trunk;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+
+	if (v_cmd == IOCMD_TRUNK_ENABLE) {
+		trunk->attr.state = BFA_TRUNK_OFFLINE;
+		bfa_fcport_disable(&bfad->bfa);
+		fcport->cfg.trunked = BFA_TRUE;
+	} else if (v_cmd == IOCMD_TRUNK_DISABLE) {
+		trunk->attr.state = BFA_TRUNK_DISABLED;
+		bfa_fcport_disable(&bfad->bfa);
+		fcport->cfg.trunked = BFA_FALSE;
+	}
+
+	if (!bfa_fcport_is_disabled(&bfad->bfa))
+		bfa_fcport_enable(&bfad->bfa);
+
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	iocmd->status = BFA_STATUS_OK;
+	return 0;
+}
+
+int
+bfad_iocmd_trunk_get_attr(struct bfad_s *bfad, void *cmd)
+{
+	struct bfa_bsg_trunk_attr_s *iocmd = (struct bfa_bsg_trunk_attr_s *)cmd;
+	struct bfa_fcport_s *fcport = BFA_FCPORT_MOD(&bfad->bfa);
+	struct bfa_fcport_trunk_s *trunk = &fcport->trunk;
+	unsigned long	flags;
+
+	spin_lock_irqsave(&bfad->bfad_lock, flags);
+	memcpy((void *)&iocmd->attr, (void *)&trunk->attr,
+		sizeof(struct bfa_trunk_attr_s));
+	iocmd->attr.port_id = bfa_lps_get_base_pid(&bfad->bfa);
+	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
+
+	iocmd->status = BFA_STATUS_OK;
+	return 0;
+}
+
 static int
 bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 		unsigned int payload_len)
@@ -2470,6 +2517,13 @@ bfad_iocmd_handler(struct bfad_s *bfad, unsigned int cmd, void *iocmd,
 	case IOCMD_ETHBOOT_QUERY:
 		rc = bfad_iocmd_ethboot_query(bfad, iocmd);
 		break;
+	case IOCMD_TRUNK_ENABLE:
+	case IOCMD_TRUNK_DISABLE:
+		rc = bfad_iocmd_cfg_trunk(bfad, iocmd, cmd);
+		break;
+	case IOCMD_TRUNK_GET_ATTR:
+		rc = bfad_iocmd_trunk_get_attr(bfad, iocmd);
+		break;
 	default:
 		rc = -EINVAL;
 		break;
diff --git a/drivers/scsi/bfa/bfad_bsg.h b/drivers/scsi/bfa/bfad_bsg.h
index 95694ce..2268045 100644
--- a/drivers/scsi/bfa/bfad_bsg.h
+++ b/drivers/scsi/bfa/bfad_bsg.h
@@ -126,6 +126,9 @@ enum {
 	IOCMD_PREBOOT_QUERY,
 	IOCMD_ETHBOOT_CFG,
 	IOCMD_ETHBOOT_QUERY,
+	IOCMD_TRUNK_ENABLE,
+	IOCMD_TRUNK_DISABLE,
+	IOCMD_TRUNK_GET_ATTR,
 };
 
 struct bfa_bsg_gen_s {
@@ -656,6 +659,13 @@ struct bfa_bsg_ethboot_s {
 	struct  bfa_ethboot_cfg_s  cfg;
 };
 
+struct bfa_bsg_trunk_attr_s {
+	bfa_status_t	status;
+	u16		bfad_num;
+	u16		rsvd;
+	struct bfa_trunk_attr_s attr;
+};
+
 struct bfa_bsg_fcpt_s {
 	bfa_status_t    status;
 	u16		vf_id;
-- 
1.7.3.rc1

