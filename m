From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 5/6] be2iscsi: Fix TCP parameters while connection
 offloading.
Date: Thu, 3 Apr 2014 05:02:54 +0000
Message-ID: <df7be47d-07f0-42e5-8bd2-2da4ede7d1e7@CMEXHTCAS1.ad.emulex.com>
References: <1395938371-2149-1-git-send-email-Jayamohan.Kallickal@emulex.com>
 <1395938371-2149-5-git-send-email-Jayamohan.Kallickal@emulex.com>
 <5338F4D6.9000303@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:22360 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874AbaDCFDA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2014 01:03:00 -0400
In-Reply-To: <5338F4D6.9000303@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jayamohan Kallickal <jayamohank@gmail.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Minh Duc Tran <MinhDuc.Tran@Emulex.Com>, Sony John-N <Sony.John-N@Emulex.Com>



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Sunday, March 30, 2014 9:54 PM
To: Jayamohan Kallickal
Cc: jbottomley@parallels.com; linux-scsi@vger.kernel.org; Jayamohan Kallickal; Minh Duc Tran; Sony John-N
Subject: Re: [PATCH 5/6] be2iscsi: Fix TCP parameters while connection offloading.

On 03/27/2014 11:39 AM, Jayamohan Kallickal wrote:
> +int mgmt_open_connection_v1(struct beiscsi_hba *phba,
> +			     struct sockaddr *dst_addr,
> +			     struct beiscsi_endpoint *beiscsi_ep,
> +			     struct be_dma_mem *nonemb_cmd) {
> +	struct hwi_controller *phwi_ctrlr;
> +	struct hwi_context_memory *phwi_context;
> +	struct sockaddr_in *daddr_in = (struct sockaddr_in *)dst_addr;
> +	struct sockaddr_in6 *daddr_in6 = (struct sockaddr_in6 *)dst_addr;
> +	struct be_ctrl_info *ctrl = &phba->ctrl;
> +	struct be_mcc_wrb *wrb;
> +	struct tcp_connect_and_offload_in_v1 *req;
> +	unsigned short def_hdr_id;
> +	unsigned short def_data_id;
> +	struct phys_addr template_address = { 0, 0 };
> +	struct phys_addr *ptemplate_address;
> +	unsigned int tag = 0;
> +	unsigned int i, ulp_num;
> +	unsigned short cid = beiscsi_ep->ep_cid;
> +	struct be_sge *sge;
> +
> +	phwi_ctrlr = phba->phwi_ctrlr;
> +	phwi_context = phwi_ctrlr->phwi_ctxt;
> +
> +	ulp_num = phwi_ctrlr->wrb_context[BE_GET_CRI_FROM_CID(cid)].ulp_num;
> +
> +	def_hdr_id = (unsigned short)HWI_GET_DEF_HDRQ_ID(phba, ulp_num);
> +	def_data_id = (unsigned short)HWI_GET_DEF_BUFQ_ID(phba, ulp_num);
> +
> +	ptemplate_address = &template_address;
> +	ISCSI_GET_PDU_TEMPLATE_ADDRESS(phba, ptemplate_address);
> +	spin_lock(&ctrl->mbox_lock);
> +	tag = alloc_mcc_tag(phba);
> +	if (!tag) {
> +		spin_unlock(&ctrl->mbox_lock);
> +		return tag;
> +	}
> +	wrb = wrb_from_mccq(phba);
> +	sge = nonembedded_sgl(wrb);
> +
> +	req = nonemb_cmd->va;
> +	memset(req, 0, sizeof(*req));
> +	wrb->tag0 |= tag;
> +
> +	be_wrb_hdr_prepare(wrb, sizeof(*req), false, 1);
> +	be_cmd_hdr_prepare(&req->hdr, CMD_SUBSYSTEM_ISCSI,
> +			   OPCODE_COMMON_ISCSI_TCP_CONNECT_AND_OFFLOAD,
> +			   sizeof(*req));
> +	if (dst_addr->sa_family == PF_INET) {
> +		__be32 s_addr = daddr_in->sin_addr.s_addr;
> +		req->ip_address.ip_type = BE2_IPV4;
> +		req->ip_address.addr[0] = s_addr & 0x000000ff;
> +		req->ip_address.addr[1] = (s_addr & 0x0000ff00) >> 8;
> +		req->ip_address.addr[2] = (s_addr & 0x00ff0000) >> 16;
> +		req->ip_address.addr[3] = (s_addr & 0xff000000) >> 24;
> +		req->tcp_port = ntohs(daddr_in->sin_port);
> +		beiscsi_ep->dst_addr = daddr_in->sin_addr.s_addr;
> +		beiscsi_ep->dst_tcpport = ntohs(daddr_in->sin_port);
> +		beiscsi_ep->ip_type = BE2_IPV4;
> +	} else if (dst_addr->sa_family == PF_INET6) {
> +		req->ip_address.ip_type = BE2_IPV6;
> +		memcpy(&req->ip_address.addr,
> +		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
> +		req->tcp_port = ntohs(daddr_in6->sin6_port);
> +		beiscsi_ep->dst_tcpport = ntohs(daddr_in6->sin6_port);
> +		memcpy(&beiscsi_ep->dst6_addr,
> +		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
> +		beiscsi_ep->ip_type = BE2_IPV6;
> +	} else{
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
> +			    "BG_%d : unknown addr family %d\n",
> +			    dst_addr->sa_family);
> +		spin_unlock(&ctrl->mbox_lock);
> +		free_mcc_tag(&phba->ctrl, tag);
> +		return -EINVAL;
> +
> +	}
> +	req->cid = cid;
> +	i = phba->nxt_cqid++;
> +	if (phba->nxt_cqid == phba->num_cpus)
> +		phba->nxt_cqid = 0;
> +	req->cq_id = phwi_context->be_cq[i].id;
> +	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
> +		    "BG_%d : i=%d cq_id=%d\n", i, req->cq_id);
> +	req->defq_id = def_hdr_id;
> +	req->hdr_ring_id = def_hdr_id;
> +	req->data_ring_id = def_data_id;
> +	req->do_offload = 1;
> +	req->dataout_template_pa.lo = ptemplate_address->lo;
> +	req->dataout_template_pa.hi = ptemplate_address->hi;
> +	sge->pa_hi = cpu_to_le32(upper_32_bits(nonemb_cmd->dma));
> +	sge->pa_lo = cpu_to_le32(nonemb_cmd->dma & 0xFFFFFFFF);
> +	sge->len = cpu_to_le32(nonemb_cmd->size);
> +
> +	req->hdr.version = 1;
> +	req->tcp_window_size = 0;
> +	req->tcp_window_scale_count = 2;

>Is this approx 100 lines exactly the same as mgmt_open_connection except these 3 lines? Maybe a lib/helper function that does the common 100 lines then >some v1 function over that which does the extra 3 lines.

Agreed. Will redo this

Thanks
Jay
--
