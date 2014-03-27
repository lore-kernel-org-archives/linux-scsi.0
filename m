From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH 5/6] be2iscsi: Fix TCP parameters while connection offloading.
Date: Thu, 27 Mar 2014 12:39:29 -0400
Message-ID: <1395938371-2149-5-git-send-email-Jayamohan.Kallickal@emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:41623 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaC0Qjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2014 12:39:48 -0400
Received: by mail-pa0-f48.google.com with SMTP id hz1so3721571pad.21
        for <linux-scsi@vger.kernel.org>; Thu, 27 Mar 2014 09:39:46 -0700 (PDT)
In-Reply-To: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 SKH-R adapter, TCP Window Size/Scale parameters are passed
 in TCP Connection Offload Mbx Command.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <Jayamohan.Kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.h  |  20 ++++++++
 drivers/scsi/be2iscsi/be_iscsi.c |  19 +++++--
 drivers/scsi/be2iscsi/be_mgmt.c  | 104 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/be2iscsi/be_mgmt.h  |   5 ++
 4 files changed, 144 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index cd4410f..1cef380 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -1013,6 +1013,26 @@ struct tcp_connect_and_offload_in {
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
+	u8 rsvd0[3];
+	u16 tcp_window_size;
+	u8 tcp_window_scale_count;
+	u8 rsvd1;
+#define BEISCSI_TCP_MSS_MASK	0x1FFFFFF	/* bits 0 - 24 */
+	u32 tcp_mss;
+	u8 rsvd2;
+} __packed;
+
 struct tcp_connect_and_offload_out {
 	struct be_cmd_resp_hdr hdr;
 	u32 connection_handle;
diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a3df433..9fe7804 100644
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
 
@@ -1139,9 +1145,14 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		beiscsi_free_ep(beiscsi_ep);
 		return -ENOMEM;
 	}
-	nonemb_cmd.size = sizeof(struct tcp_connect_and_offload_in);
+	nonemb_cmd.size = req_memsize;
 	memset(nonemb_cmd.va, 0, nonemb_cmd.size);
-	tag = mgmt_open_connection(phba, dst_addr, beiscsi_ep, &nonemb_cmd);
+	if (is_chip_be2_be3r(phba))
+		tag = mgmt_open_connection(phba, dst_addr,
+					   beiscsi_ep, &nonemb_cmd);
+	else
+		tag = mgmt_open_connection_v1(phba, dst_addr,
+					   beiscsi_ep, &nonemb_cmd);
 	if (tag <= 0) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
 			    "BS_%d : mgmt_open_connection Failed for cid=%d\n",
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 52a36fb..6756def 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -794,6 +794,110 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
 	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
 	sge->len = cpu_to_le32(nonemb_cmd->size);
+
+	be_mcc_notify(phba);
+	spin_unlock(&ctrl->mbox_lock);
+	return tag;
+}
+
+int mgmt_open_connection_v1(struct beiscsi_hba *phba,
+			     struct sockaddr *dst_addr,
+			     struct beiscsi_endpoint *beiscsi_ep,
+			     struct be_dma_mem *nonemb_cmd)
+{
+	struct hwi_controller *phwi_ctrlr;
+	struct hwi_context_memory *phwi_context;
+	struct sockaddr_in *daddr_in = (struct sockaddr_in *)dst_addr;
+	struct sockaddr_in6 *daddr_in6 = (struct sockaddr_in6 *)dst_addr;
+	struct be_ctrl_info *ctrl = &phba->ctrl;
+	struct be_mcc_wrb *wrb;
+	struct tcp_connect_and_offload_in_v1 *req;
+	unsigned short def_hdr_id;
+	unsigned short def_data_id;
+	struct phys_addr template_address = { 0, 0 };
+	struct phys_addr *ptemplate_address;
+	unsigned int tag = 0;
+	unsigned int i, ulp_num;
+	unsigned short cid = beiscsi_ep->ep_cid;
+	struct be_sge *sge;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	phwi_context = phwi_ctrlr->phwi_ctxt;
+
+	ulp_num = phwi_ctrlr->wrb_context[BE_GET_CRI_FROM_CID(cid)].ulp_num;
+
+	def_hdr_id = (unsigned short)HWI_GET_DEF_HDRQ_ID(phba, ulp_num);
+	def_data_id = (unsigned short)HWI_GET_DEF_BUFQ_ID(phba, ulp_num);
+
+	ptemplate_address = &template_address;
+	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
+	spin_lock(&ctrl->mbox_lock);
+	tag = alloc_mcc_tag(phba);
+	if (!tag) {
+		spin_unlock(&ctrl->mbox_lock);
+		return tag;
+	}
+	wrb = wrb_from_mccq(phba);
+	sge = nonembedded_sgl(wrb);
+
+	req = nonemb_cmd->va;
+	memset(req, 0, sizeof(*req));
+	wrb->tag0 |= tag;
+
+	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
+	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
+			   OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
+			   sizeof(*req));
+	if (dst_addr->sa_family == PF_INET) {
+		__be32 s_addr = daddr_in->sin_addr.s_addr;
+		req->ip_address.ip_type = BE2_IPV4;
+		req->ip_address.addr[0] = s_addr & 0x000000ff;
+		req->ip_address.addr[1] = (s_addr & 0x0000ff00) >> 8;
+		req->ip_address.addr[2] = (s_addr & 0x00ff0000) >> 16;
+		req->ip_address.addr[3] = (s_addr & 0xff000000) >> 24;
+		req->tcp_port = ntohs(daddr_in->sin_port);
+		beiscsi_ep->dst_addr = daddr_in->sin_addr.s_addr;
+		beiscsi_ep->dst_tcpport = ntohs(daddr_in->sin_port);
+		beiscsi_ep->ip_type = BE2_IPV4;
+	} else if (dst_addr->sa_family == PF_INET6) {
+		req->ip_address.ip_type = BE2_IPV6;
+		memcpy(&req->ip_address.addr,
+		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
+		req->tcp_port = ntohs(daddr_in6->sin6_port);
+		beiscsi_ep->dst_tcpport = ntohs(daddr_in6->sin6_port);
+		memcpy(&beiscsi_ep->dst6_addr,
+		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
+		beiscsi_ep->ip_type = BE2_IPV6;
+	} else{
+		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
+			    "BG_%d : unknown addr family %d\n",
+			    dst_addr->sa_family);
+		spin_unlock(&ctrl->mbox_lock);
+		free_mcc_tag(&phba->ctrl, tag);
+		return -EINVAL;
+
+	}
+	req->cid = cid;
+	i = phba->nxt_cqid++;
+	if (phba->nxt_cqid == phba->num_cpus)
+		phba->nxt_cqid = 0;
+	req->cq_id = phwi_context->be_cq[i].id;
+	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
+		    "BG_%d : i=%d cq_id=%d\n", i, req->cq_id);
+	req->defq_id = def_hdr_id;
+	req->hdr_ring_id = def_hdr_id;
+	req->data_ring_id = def_data_id;
+	req->do_offload = 1;
+	req->dataout_template_pa.lo = ptemplate_address->lo;
+	req->dataout_template_pa.hi = ptemplate_address->hi;
+	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
+	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
+	sge->len = cpu_to_le32(nonemb_cmd->size);
+
+	req->hdr.version = 1;
+	req->tcp_window_size = 0;
+	req->tcp_window_scale_count = 2;
+
 	be_mcc_notify(phba);
 	spin_unlock(&ctrl->mbox_lock);
 	return tag;
diff --git a/drivers/scsi/be2iscsi/be_mgmt.h b/drivers/scsi/be2iscsi/be_mgmt.h
index 24a8fc5..02f2fdd 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.h
+++ b/drivers/scsi/be2iscsi/be_mgmt.h
@@ -102,6 +102,11 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 			 struct beiscsi_endpoint *beiscsi_ep,
 			 struct be_dma_mem *nonemb_cmd);
 
+int mgmt_open_connection_v1(struct beiscsi_hba *phba,
+			     struct sockaddr *dst_addr,
+			     struct beiscsi_endpoint *beiscsi_ep,
+			     struct be_dma_mem *nonemb_cmd);
+
 unsigned int mgmt_upload_connection(struct beiscsi_hba *phba,
 				     unsigned short cid,
 				     unsigned int upload_flag);
-- 
1.8.5.3

