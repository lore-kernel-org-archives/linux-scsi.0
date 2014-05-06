From: Jay Kallickal <jayamohank@gmail.com>
Subject: [PATCH 4/8] be2iscsi: Fix TCP parameters while connection offloading.
Date: Mon,  5 May 2014 21:41:27 -0400
Message-ID: <1399340492-2136-4-git-send-email-jkallickal@emulex.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:45745 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaEFBlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2014 21:41:51 -0400
Received: by mail-pa0-f50.google.com with SMTP id fb1so3347090pad.37
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2014 18:41:50 -0700 (PDT)
In-Reply-To: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

 SKH-R adapter, TCP Window Size/Scale parameters are passed
 in TCP Connection Offload Mbx Command.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.h  | 21 +++++++++++++++++++++
 drivers/scsi/be2iscsi/be_iscsi.c | 12 +++++++++---
 drivers/scsi/be2iscsi/be_mgmt.c  | 13 ++++++++++---
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index cd4410f..cc7405c 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -71,6 +71,7 @@ struct be_mcc_wrb {
 #define BEISCSI_FW_MBX_TIMEOUT	100
 
 /* MBOX Command VER */
+#define MBX_CMD_VER1	0x01
 #define MBX_CMD_VER2	0x02
 
 struct be_mcc_compl {
@@ -1013,6 +1014,26 @@ struct tcp_connect_and_offload_in {
 	u8 rsvd0[3];
 } __packed;
 
+struct tcp_connect_and_offload_in_v1 {
+	struct be_cmd_req_hdr hdr;
+	struct ip_addr_format ip_address;
+	u16 tcp_port;
+	u16 cid;
+	u16 cq_id;
+	u16 defq_id;
+	struct phys_addr dataout_template_pa;
+	u16 hdr_ring_id;
+	u16 data_ring_id;
+	u8 do_offload;
+	u8 ifd_state;
+	u8 rsvd0[2];
+	u16 tcp_window_size;
+	u8 tcp_window_scale_count;
+	u8 rsvd1;
+	u32 tcp_mss:24;
+	u8 rsvd2;
+} __packed;
+
 struct tcp_connect_and_offload_out {
 	struct be_cmd_resp_hdr hdr;
 	u32 connection_handle;
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a3df433..fd284ff 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1106,7 +1106,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
 	struct tcp_connect_and_offload_out *ptcpcnct_out;
 	struct be_dma_mem nonemb_cmd;
-	unsigned int tag;
+	unsigned int tag, req_memsize;
 	int ret = -ENOMEM;
 
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
@@ -1127,8 +1127,14 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		       (beiscsi_ep->ep_cid)] = ep;
 
 	beiscsi_ep->cid_vld = 0;
+
+	if (is_chip_be2_be3r(phba))
+		req_memsize = sizeof(struct tcp_connect_and_offload_in);
+	else
+		req_memsize = sizeof(struct tcp_connect_and_offload_in_v1);
+
 	nonemb_cmd.va = pci_alloc_consistent(phba->ctrl.pdev,
-				sizeof(struct tcp_connect_and_offload_in),
+				req_memsize,
 				&nonemb_cmd.dma);
 	if (nonemb_cmd.va == NULL) {
 
@@ -1139,7 +1145,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		beiscsi_free_ep(beiscsi_ep);
 		return -ENOMEM;
 	}
-	nonemb_cmd.size = sizeof(struct tcp_connect_and_offload_in);
+	nonemb_cmd.size = req_memsize;
 	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
 	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep, &nonemb_cmd);
 	if (tag <= 0) {
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 52a36fb..6045aa7 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -712,7 +712,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	struct sockaddr_in6 *daddr_in6 = (struct sockaddr_in6 *)dst_addr;
 	struct be_ctrl_info *ctrl = &phba->ctrl;
 	struct be_mcc_wrb *wrb;
-	struct tcp_connect_and_offload_in *req;
+	struct tcp_connect_and_offload_in_v1 *req;
 	unsigned short def_hdr_id;
 	unsigned short def_data_id;
 	struct phys_addr template_address = { 0, 0 };
@@ -745,10 +745,10 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	memset(req, 0, sizeof(*req));
 	wrb->tag0 |= tag;
 
-	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
+	be_wrb_hdr_prepare(wrb, nonemb_cmd->size, false, 1);
 	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
 			   OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
-			   sizeof(*req));
+			   nonemb_cmd->size);
 	if (dst_addr->sa_family == PF_INET) {
 		__be32 s_addr = daddr_in->sin_addr.s_addr;
 		req->ip_address.ip_type = BE2_IPV4;
@@ -794,6 +794,13 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
 	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
 	sge->len = cpu_to_le32(nonemb_cmd->size);
+
+	if (!is_chip_be2_be3r(phba)) {
+		req->hdr.version = MBX_CMD_VER1;
+		req->tcp_window_size = 0;
+		req->tcp_window_scale_count = 2;
+	}
+
 	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
 	return tag;
-- 
1.8.5.3

