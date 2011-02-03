From: "Bhanu Gollapudi" <bprakash@broadcom.com>
Subject: Re: [v5 PATCH 2/4] bnx2fc: Firmware interface and ELS handling
Date: Wed, 2 Feb 2011 19:41:34 -0800
Message-ID: <1296704494.268.549.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
References: <1296266428.268.51.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
 <4D491744.2020304@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=cp1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2180 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab1BCDly (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 22:41:54 -0500
In-Reply-To: <4D491744.2020304@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Michael Chan <mchan@broadcom.com>

On Wed, 2011-02-02 at 00:35 -0800, Mike Christie wrote: 
> On 01/28/2011 08:00 PM, Bhanu Gollapudi wrote:
> > +void bnx2fc_fill_fc_hdr(struct fc_frame_header *fc_hdr, enum fc_rctl r_ctl,
> > +			u32 sid, u32 did, enum fc_fh_type fh_type,
> > +			u32 f_ctl, u32 parm_offset)
> > +{
> > +	hton24(fc_hdr->fh_s_id, sid);
> > +	hton24(fc_hdr->fh_d_id, did);
> > +	fc_hdr->fh_r_ctl = r_ctl;
> > +	fc_hdr->fh_type = fh_type;
> > +	hton24(fc_hdr->fh_f_ctl, f_ctl);
> > +	fc_hdr->fh_cs_ctl = 0;
> > +	fc_hdr->fh_df_ctl = 0;
> > +	fc_hdr->fh_parm_offset = htonl(parm_offset);
> > +}

> 
> This is just fc_fill_fc_hdr() right?

there is a small different in the prototype, as fc_fill_fc_hdr() takes
fc_frame as the argument. But I can introduce __fc_fill_fc_hdr() that
takes fc_frame_header as an argument, and let bnx2fc and
fc_fill_fc_hdr() call this new routine.

> 
> 
> > +}
> > +
> > +static int bnx2fc_initiate_els(struct bnx2fc_rport *tgt, unsigned int op,
> > +			void *data, u32 data_len,
> > +			void (*cb_func)(struct bnx2fc_els_cb_arg *cb_arg),
> > +			struct bnx2fc_els_cb_arg *cb_arg, u32 timer_msec)
> 
> 
> 
> > +	els_req->cb_arg = cb_arg;
> > +
> > +	mp_req = (struct bnx2fc_mp_req *)&(els_req->mp_req);
> > +	rc = bnx2fc_init_mp_req(els_req);
> > +	if (rc == FAILED) {
> > +		printk(KERN_ALERT PFX "ELS MP request init failed\n");
> > +		spin_lock_bh(&tgt->tgt_lock);
> > +		kref_put(&els_req->refcount, bnx2fc_cmd_release);
> > +		spin_unlock_bh(&tgt->tgt_lock);
> > +		goto els_err;
> 
> Normally you return a -EXYZ in this function, but here you return the 
> scsi value FAILED.

Will take care.

> 
> 
> > +
> > +els_err:
> > +	return rc;
> > +}
> 
> 
> 
> > +}
> > +
> > +void bnx2fc_process_l2_frame_compl(struct bnx2fc_rport *tgt,
> > +				   unsigned char *buf,
> > +				   u32 frame_len, u16 l2_oxid)
> > +{
> > +	struct fcoe_port *port = tgt->port;
> > +	struct bnx2fc_hba *hba = port->priv;
> > +	struct fc_lport *lport = port->lport;
> > +	struct fc_frame *fp;
> > +	struct fc_frame_header *fh;
> > +	struct fcoe_hdr *hp;
> > +	struct fcoe_crc_eof *cp;
> > +	struct fcoe_rcv_info *fr;
> > +	struct fcoe_percpu_s *bg;
> > +
> > +	struct sk_buff *skb;
> > +	unsigned int hlen;	/* header length implies the version */
> > +	unsigned int tlen;	/* trailer length */
> > +	unsigned int elen;	/* eth header, may include vlan */
> > +	u32 crc;
> > +	struct ethhdr *eh;
> > +
> > +	u32 payload_len;
> > +	u16 oxid;
> > +	int idx;
> > +	u8 op;
> > +
> > +	BNX2FC_TGT_DBG(tgt, "l2_frame_compl l2_oxid = 0x%x, frame_len = %d\n",
> > +		l2_oxid, frame_len);
> > +	payload_len = frame_len - sizeof(struct fc_frame_header);
> > +
> > +	fp = fc_frame_alloc(lport, payload_len);
> > +	if (!fp) {
> > +		printk(KERN_ERR PFX "fc_frame_alloc failure\n");
> > +		return;
> > +	}
> > +
> > +	fh = (struct fc_frame_header *) fc_frame_header_get(fp);
> > +	/* Copy FC Frame header and payload into the frame */
> > +	memcpy(fh, buf, frame_len);
> > +
> > +	if (l2_oxid != FC_XID_UNKNOWN)
> > +		fh->fh_ox_id = htons(l2_oxid);
> > +
> > +	skb = fp_skb(fp);
> > +
> > +	if ((fh->fh_r_ctl == FC_RCTL_ELS_REQ) ||
> > +	    (fh->fh_r_ctl == FC_RCTL_ELS_REP)) {
> > +
> > +		if (fh->fh_type == FC_TYPE_ELS) {
> > +			op = fc_frame_payload_op(fp);
> > +			if ((op == ELS_TEST) ||	(op == ELS_ESTC) ||
> > +			    (op == ELS_FAN) || (op == ELS_CSU)) {
> > +				/*
> > +				 * No need to reply for these
> > +				 * ELS requests
> > +				 */
> > +				printk(KERN_ERR PFX "dropping ELS 0x%x\n", op);
> > +				kfree_skb(skb);
> > +				return;
> > +			}
> > +		}
> > +		/* Pass it on to libfc for further processing */
> 
> I did not get this comment. Did you mean to put the code below in the 
> fcoe lib, then call it? It looks identical to fcoe_xmit.

No, I didnt mean that. Its unsolicited ELS handling, and I'm tyring to
encapsulate it back to FCoE frame and send it through L2 path to libfc.
But I guess I dont have to do that, and will avoid all this code, by
directly calling fc_exch_recv().

> 
> 
> > +		elen = (hba->netdev->priv_flags&  IFF_802_1Q_VLAN) ?
> > +			sizeof(struct vlan_ethhdr) :
> > +			sizeof(struct ethhdr);
> > +		hlen = sizeof(struct fcoe_hdr);
> > +		tlen = sizeof(struct fcoe_crc_eof);
> > +		skb->ip_summed = CHECKSUM_NONE;
> > +		crc = fcoe_fc_crc(fp);
> > +
> > +		if (skb_is_nonlinear(skb)) {
> > +			skb_frag_t *frag;
> > +			if (bnx2fc_get_paged_crc_eof(skb, tlen)) {
> > +				printk(KERN_ERR PFX "Frame crc error\n");
> > +				kfree_skb(skb);
> > +				return;
> > +			}
> > +			idx = skb_shinfo(skb)->nr_frags - 1;
> > +			frag =&skb_shinfo(skb)->frags[idx];
> > +			cp = kmap_atomic(frag->page,
> > +					 KM_SKB_DATA_SOFTIRQ) +
> > +					 frag->page_offset;
> > +		} else {
> > +			cp = (struct fcoe_crc_eof *)skb_put(skb, tlen);
> > +		}
> > +		memset(cp, 0, sizeof(*cp));
> > +		/*
> > +		 * We are supposed to receive single frame
> > +		 * sequences from the firmware
> > +		 */
> > +		cp->fcoe_eof = FC_EOF_T;
> > +		cp->fcoe_crc32 = cpu_to_le32(~crc);
> > +
> > +		if (skb_is_nonlinear(skb)) {
> > +			kunmap_atomic(cp, KM_SKB_DATA_SOFTIRQ);
> > +			cp = NULL;
> > +		}
> > +
> > +		skb_push(skb, hlen + elen);
> > +		skb_reset_mac_header(skb);
> > +		skb_set_network_header(skb, elen);
> > +		skb_set_transport_header(skb, elen+hlen);
> > +		skb->mac_len = elen;
> > +		skb->protocol = htons(ETH_P_FCOE);
> > +		skb->dev = hba->netdev;
> > +
> > +		/* adjust skb->data to point to fcoe_hdr */
> > +		skb_pull(skb, elen);
> > +
> > +		eh = eth_hdr(skb);
> > +		eh->h_proto = htons(ETH_P_FCOE);
> > +
> > +		/* Should we be setting eh->h_dest and h_source? */
> > +		memcpy(eh->h_dest, port->data_src_addr, ETH_ALEN);
> > +
> > +		hp = (struct fcoe_hdr *)skb_network_header(skb);
> > +		memset(hp, 0, sizeof(*hp));
> > +		if (FC_FCOE_VER)
> > +			FC_FCOE_ENCAPS_VER(hp, FC_FCOE_VER);
> > +
> > +		/* needs to be less than 0x30 - FC_SOF_N3 */
> > +		hp->fcoe_sof = FC_SOF_I3;
> > +
> > +		fr = fcoe_dev_from_skb(skb);
> > +		fr->fr_dev = lport;
> > +		oxid =  ntohs(fh->fh_ox_id);
> > +
> > +		bg =&bnx2fc_global;
> > +		spin_lock_bh(&bg->fcoe_rx_list.lock);
> > +
> > +		if (unlikely(!bg->thread)) {
> > +			spin_unlock_bh(&bg->fcoe_rx_list.lock);
> > +			printk(KERN_ERR PFX "ERROR-thread is NULL\n");
> > +			kfree_skb(skb);
> > +			return;
> > +		}
> > +		__skb_queue_tail(&bg->fcoe_rx_list, skb);
> > +		if (bg->fcoe_rx_list.qlen == 1)
> > +			wake_up_process(bg->thread);
> > +		spin_unlock_bh(&bg->fcoe_rx_list.lock);
> > +	} else {
> > +		BNX2FC_HBA_DBG(lport, "fh_r_ctl = 0x%x\n", fh->fh_r_ctl);
> > +		kfree_skb(skb);
> > +	}
> > +}
> > +
> > +static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
> > +{
> 
> 
> > +
> > +		num_rq = (frame_len + BNX2FC_RQ_BUF_SZ - 1) / BNX2FC_RQ_BUF_SZ;
> > +
> > +		rq_data = (unsigned char *)bnx2fc_get_next_rqe(tgt, num_rq);
> > +		if (rq_data) {
> > +			buf = rq_data;
> > +		} else {
> > +			buf1 = buf = kmalloc((num_rq * BNX2FC_RQ_BUF_SZ),
> > +					      GFP_ATOMIC);
> 
> 
> Need to check for NULL before accessing buf1 below.

OK.

> 
> > +			for (i = 0; i<  num_rq; i++) {
> > +				rq_data = (unsigned char *)
> > +					   bnx2fc_get_next_rqe(tgt, 1);
> > +				len = BNX2FC_RQ_BUF_SZ;
> > +				memcpy(buf1, rq_data, len);
> > +				buf1 += len;
> > +			}
> > +		}
> > +		bnx2fc_process_l2_frame_compl(tgt, buf, frame_len,
> > +					      FC_XID_UNKNOWN);
> > +
> 
> 
> 
> 
> 
> 
> > +
> > +struct bnx2fc_work *bnx2fc_alloc_work(struct bnx2fc_rport *tgt, u16 wqe)
> > +{
> > +	struct bnx2fc_work *work;
> > +	work = kzalloc(sizeof(struct bnx2fc_work), GFP_ATOMIC);
> > +	if (!work)
> > +		return NULL;
> > +
> > +	INIT_LIST_HEAD(&work->list);
> > +	work->tgt = tgt;
> > +	work->wqe = wqe;
> > +	return work;
> > +}
> > +
> > +int bnx2fc_process_new_cqes(struct bnx2fc_rport *tgt)
> > +{
> > +	struct fcoe_cqe *cq;
> > +	u32 cq_cons;
> > +	struct fcoe_cqe *cqe;
> > +	u16 wqe;
> > +	bool more_cqes_found = false;
> > +
> > +	/*
> > +	 * cq_lock is a low contention lock used to protect
> > +	 * the CQ data structure from being freed up during
> > +	 * the upload operation
> > +	 */
> > +	spin_lock_bh(&tgt->cq_lock);
> > +
> > +	if (!tgt->cq) {
> > +		printk(KERN_ERR PFX "process_new_cqes: cq is NULL\n");
> > +		spin_unlock_bh(&tgt->cq_lock);
> > +		return 0;
> > +	}
> > +	cq = tgt->cq;
> > +	cq_cons = tgt->cq_cons_idx;
> > +	cqe =&cq[cq_cons];
> > +
> > +	do {
> > +		more_cqes_found ^= true;
> > +
> > +		while (((wqe = cqe->wqe)&  FCOE_CQE_TOGGLE_BIT) ==
> > +		       (tgt->cq_curr_toggle_bit<<
> > +		       FCOE_CQE_TOGGLE_BIT_SHIFT)) {
> > +
> > +			/* new entry on the cq */
> > +			if (wqe&  FCOE_CQE_CQE_TYPE) {
> > +				/* Unsolicited event notification */
> > +				bnx2fc_process_unsol_compl(tgt, wqe);
> > +			} else {
> > +				struct bnx2fc_work *work = NULL;
> > +				struct bnx2fc_percpu_s *fps = NULL;
> > +				unsigned int cpu = wqe % num_possible_cpus();
> > +
> > +				fps =&per_cpu(bnx2fc_percpu, cpu);
> > +				spin_lock_bh(&fps->fp_work_lock);
> > +				if (unlikely(!fps->iothread))
> > +					goto unlock;
> > +
> > +				work =  bnx2fc_alloc_work(tgt, wqe);
> > +				if (!work)
> > +					goto unlock;
> > +
> > +				list_add_tail(&work->list,&fps->work_list);
> > +unlock:
> 
> 
> This seems like one of the most evil uses of goto :) Why not just do
> 
> if (work)
> 	list_add_tail(&work->list,&fps->work_list);
> spin_unlock_bh(&fps->fp_work_lock);

Yes. Will take care.

> 
> 
> > +				spin_unlock_bh(&fps->fp_work_lock);
> > +
> > +				/* Pending work request completion */
> > +				if (fps->iothread&&  work)
> > +					wake_up_process(fps->iothread);
> 
> 
> This looks like blk io poll but with a thread instead of a softirq. Use 
> what is in the kernel already.

I'll have to take a look at implementation details of blk io poll. This
will be a change in IO path, and I'll have to do a lot of testing. So, I
cannot promise I can do this change in v6 submittal. Probably will stage
it later.


> 
> 
> 
> > +				else
> > +					bnx2fc_process_cq_compl(tgt, wqe);
> > +			}
> 



