Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B4F224F5
	for <linux-scsi@vger.kernel.org>; Mon, 19 Feb 2024 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708333178; cv=none; b=VwDX50fucSV6SS+CJFq+yhDclSpp06EcHcTNk0tZ2OA9aTYBYSrdDzZfJFvhcw8m8gRbkfNXGYsC95FknFD8mrrF+JUwx/B81PdYYiYuHh3xHwIQ0Xcab5EZysVTnYw8c00S+ctsbpkSXo9gvDKfvHAh5I4PaP07CXWnSn7pTDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708333178; c=relaxed/simple;
	bh=ikmZhADSrUsDZIz7zPd91If5CKDROuuLkYgqZftl+Z8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V954KNAXpUqNLKQYEM65YMDDKfLrVH+OxLl/E8pSIqie5lV+xLcaip54eJkPkfE49h0LBXnNZBkHrwNnDzDkAasYblXPHdMCjOqKLoU6CF8kEOCHdMGEU8U3MjWubp4qz1nAOvRYg396DM1sX2sIBgXE+SPF2RXZw8b1uNxqEdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PskdjkVh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PskdjkVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784DFC43394;
	Mon, 19 Feb 2024 08:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708333178;
	bh=ikmZhADSrUsDZIz7zPd91If5CKDROuuLkYgqZftl+Z8=;
	h=From:To:Cc:Subject:Date:From;
	b=PskdjkVhi/MSQtL5FTwMmmU3O0gotS5+k7/zcxSICuexhEPH6cG43hET/oBBZscUf
	 sJQKhysuj0vJ3F7HrlDHsIYCXIZlgoi4Tym8gJaaJzZhs4qTi7ESaKbrHDafMxsTjP
	 opbsU395VYCTCGnds0vaj7G6mHf2dFQAoa3pAySfFFDiKmuBpkgdg7TFwhGlY7t6MN
	 Z6VWdMcBDYmEFTUhzA5mzW5+IKtqHNAxFjZJJf635BzDGTzbHCOllbLSh4BpFt3050
	 QeDGEVTp4IBtc53px3vDYwH1xyg4ULnpM3Uriv/2aG5E96C/ki3Cb6X2U79mOxmmbH
	 GGLB5ZTtusm4A==
From: hare@kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	James Smart <james.smart@broadcom.com>,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC] nvme-fc: FPIN link integrity handling
Date: Mon, 19 Feb 2024 09:59:29 +0100
Message-Id: <20240219085929.31255-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Hannes Reinecke <hare@suse.de>

FPIN LI (link integrity) messages are received when the attached
fabric detects hardware errors. In response to these messages the
affected ports should not be used for I/O, and only put back into
service once the ports had been reset as then the hardware might
have been replaced.
This patch adds a new controller flag 'NVME_CTRL_TRANSPORT_BLOCKED'
which will be checked during multipath path selection, causing the
path to be skipped.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/nvme/host/core.c       |  13 ++--
 drivers/nvme/host/fc.c         | 108 +++++++++++++++++++++++++++++++++
 drivers/nvme/host/multipath.c  |   2 +
 drivers/nvme/host/nvme.h       |   1 +
 drivers/scsi/lpfc/lpfc_els.c   |   6 +-
 drivers/scsi/qla2xxx/qla_isr.c |   1 +
 include/linux/nvme-fc-driver.h |   3 +
 7 files changed, 129 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index eed3e22e24d9..5e9a0cf43636 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -750,10 +750,14 @@ blk_status_t nvme_fail_nonready_command(struct nvme_ctrl *ctrl,
 
 	if (state != NVME_CTRL_DELETING_NOIO &&
 	    state != NVME_CTRL_DELETING &&
-	    state != NVME_CTRL_DEAD &&
-	    !test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags) &&
-	    !blk_noretry_request(rq) && !(rq->cmd_flags & REQ_NVME_MPATH))
-		return BLK_STS_RESOURCE;
+	    state != NVME_CTRL_DEAD) {
+		if (!test_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags) &&
+		    !blk_noretry_request(rq) &&
+		    !(rq->cmd_flags & REQ_NVME_MPATH))
+			return BLK_STS_RESOURCE;
+		if (test_bit(NVME_CTRL_TRANSPORT_BLOCKED, &ctrl->flags))
+			return BLK_STS_TRANSPORT;
+	}
 	return nvme_host_path_error(rq);
 }
 EXPORT_SYMBOL_GPL(nvme_fail_nonready_command);
@@ -4575,6 +4579,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
 	WRITE_ONCE(ctrl->state, NVME_CTRL_NEW);
 	ctrl->passthru_err_log_enabled = false;
 	clear_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags);
+	clear_bit(NVME_CTRL_TRANSPORT_BLOCKED, &ctrl->flags);
 	spin_lock_init(&ctrl->lock);
 	mutex_init(&ctrl->scan_lock);
 	INIT_LIST_HEAD(&ctrl->namespaces);
diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 5e226728c822..fdf77f5cb944 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -787,6 +787,9 @@ nvme_fc_ctrl_connectivity_loss(struct nvme_fc_ctrl *ctrl)
 		"NVME-FC{%d}: controller connectivity lost. Awaiting "
 		"Reconnect", ctrl->cnum);
 
+	/* clear 'transport blocked' flag as controller will be reset */
+	clear_bit(NVME_CTRL_TRANSPORT_BLOCKED, &ctrl->flags);
+
 	switch (nvme_ctrl_state(&ctrl->ctrl)) {
 	case NVME_CTRL_NEW:
 	case NVME_CTRL_LIVE:
@@ -3741,6 +3744,111 @@ static struct nvmf_transport_ops nvme_fc_transport = {
 	.create_ctrl	= nvme_fc_create_ctrl,
 };
 
+static struct nvme_fc_rport *nvme_fc_rport_from_wwpn(struct nvme_fc_lport *lport,
+						     u64 rport_wwpn)
+{
+	struct nvme_fc_rport *rport;
+
+	list_for_each_entry(rport, &lport->endp_list, endp_list) {
+		if (!nvme_fc_rport_get(rport))
+			continue;
+		if (rport->remoteport.port_name == rport_wwpn &&
+		    rport->remoteport.port_role & FC_PORT_ROLE_NVME_TARGET)
+			return rport;
+		nvme_fc_rport_put(rport);
+	}
+	return NULL;
+}
+
+/*
+ * nvme_fc_fpin_li_lport_update - routine to update Link Integrity
+ * event statistics.
+ * @lport:		local port the FPIN was received on
+ * @tlv:		pointer to link integrity descriptor
+ *
+ */
+static void
+nvme_fc_fpin_li_lport_update(struct nvme_fc_lport *lport, struct fc_tlv_desc *tlv)
+{
+	unsigned int i, pname_count;
+	struct nvme_fc_rport *attached_rport;
+	struct fc_fn_li_desc *li_desc = (struct fc_fn_li_desc *)tlv;
+	u64 wwpn;
+
+	wwpn = be64_to_cpu(li_desc->attached_wwpn);
+	attached_rport = nvme_fc_rport_from_wwpn(lport, wwpn);
+	pname_count = be32_to_cpu(li_desc->pname_count);
+
+	for (i = 0; pname_count; i++) {
+		struct nvme_fc_rport *rport;
+
+		wwpn = be64_to_cpu(li_desc->pname_list[i]);
+		rport = nvme_fc_rport_from_wwpn(lport, wwpn);
+		if (!rport)
+			continue;
+		if (rport != attached_rport) {
+			struct nvme_fc_ctrl *ctrl;
+
+			spin_lock_irq(&rport->lock);
+			list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list)
+				set_bit(NVME_CTRL_TRANSPORT_BLOCKED, &ctrl->ctrl.flags);
+			spin_unlock_irq(&rport->lock);
+		}
+		nvme_fc_rport_put(rport);
+	}
+	if (attached_rport) {
+		struct nvme_fc_ctrl *ctrl;
+
+		spin_lock_irq(&attached_rport->lock);
+		list_for_each_entry(ctrl, &attached_rport->ctrl_list, ctrl_list)
+			set_bit(NVME_CTRL_TRANSPORT_BLOCKED, &ctrl->ctrl.flags);
+		spin_unlock_irq(&attached_rport->lock);
+		nvme_fc_rport_put(attached_rport);
+	}
+}
+
+/**
+ * fc_host_fpin_rcv - routine to process a received FPIN.
+ * @localport:		local port the FPIN was received on
+ * @fpin_len:		length of FPIN payload, in bytes
+ * @fpin_buf:		pointer to FPIN payload
+ * Notes:
+ *	This routine assumes no locks are held on entry.
+ */
+void
+nvme_fc_fpin_rcv(struct nvme_fc_local_port *localport,
+		 u32 fpin_len, char *fpin_buf)
+{
+	struct nvme_fc_lport *lport;
+	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
+	struct fc_tlv_desc *tlv;
+	u32 bytes_remain;
+	u32 dtag;
+
+	if (!localport)
+		return;
+	lport = localport_to_lport(localport);
+	tlv = (struct fc_tlv_desc *)&fpin->fpin_desc[0];
+	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
+	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
+
+	while (bytes_remain >= FC_TLV_DESC_HDR_SZ &&
+	       bytes_remain >= FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
+		dtag = be32_to_cpu(tlv->desc_tag);
+		switch (dtag) {
+		case ELS_DTAG_LNK_INTEGRITY:
+			nvme_fc_fpin_li_lport_update(lport, tlv);
+			break;
+		default:
+			break;
+		}
+
+		bytes_remain -= FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
+		tlv = fc_tlv_next_desc(tlv);
+	}
+}
+EXPORT_SYMBOL(nvme_fc_fpin_rcv);
+
 /* Arbitrary successive failures max. With lots of subsystems could be high */
 #define DISCOVERY_MAX_FAIL	20
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 4a90dad43303..e0dcfe9edb89 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -235,6 +235,8 @@ static bool nvme_path_is_disabled(struct nvme_ns *ns)
 	 */
 	if (state != NVME_CTRL_LIVE && state != NVME_CTRL_DELETING)
 		return true;
+	if (test_bit(NVME_CTRL_TRANSPORT_BLOCKED, &ns->ctrl->flags))
+		return true;
 	if (test_bit(NVME_NS_ANA_PENDING, &ns->flags) ||
 	    !test_bit(NVME_NS_READY, &ns->flags))
 		return true;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ee30bb63e36b..6ed2ca6b35e4 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -258,6 +258,7 @@ enum nvme_ctrl_flags {
 	NVME_CTRL_SKIP_ID_CNS_CS	= 4,
 	NVME_CTRL_DIRTY_CAPABILITY	= 5,
 	NVME_CTRL_FROZEN		= 6,
+	NVME_CTRL_TRANSPORT_BLOCKED	= 7,
 };
 
 struct nvme_ctrl {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4d723200690a..ecfe6bc8ab63 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_transport_fc.h>
 #include <uapi/scsi/fc/fc_fs.h>
 #include <uapi/scsi/fc/fc_els.h>
+#include <linux/nvme-fc-driver.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -10343,9 +10344,12 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void *p, u32 fpin_length)
 		fpin_length += sizeof(struct fc_els_fpin); /* the entire FPIN */
 
 		/* Send every descriptor individually to the upper layer */
-		if (deliver)
+		if (deliver) {
 			fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
 					 fpin_length, (char *)fpin, 0);
+			nvme_fc_fpin_rcv(vport->localport,
+					 fpin_length, (char *)fpin);
+		}
 		desc_cnt++;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index d48007e18288..b180e10053c5 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -46,6 +46,7 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
 		       pkt, pkt_size);
 
 	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, 0);
+	nvme_fc_fpin_rcv(vha->nvme_local_port, pkt_size, (char *)pkt);
 }
 
 const char *const port_state_str[] = {
diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
index 4109f1bd6128..994bc459e6dd 100644
--- a/include/linux/nvme-fc-driver.h
+++ b/include/linux/nvme-fc-driver.h
@@ -536,6 +536,9 @@ void nvme_fc_rescan_remoteport(struct nvme_fc_remote_port *remoteport);
 int nvme_fc_set_remoteport_devloss(struct nvme_fc_remote_port *remoteport,
 			u32 dev_loss_tmo);
 
+void nvme_fc_fpin_rcv(struct nvme_fc_local_port *localport,
+		      u32 fpin_len, char *fpin_buf);
+
 /*
  * Routine called to pass a NVME-FC LS request, received by the lldd,
  * to the nvme-fc transport.
-- 
2.35.3

