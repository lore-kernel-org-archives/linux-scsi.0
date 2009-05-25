From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 3/4] cnic: Add new Broadcom CNIC driver.
Date: Mon, 25 May 2009 17:19:41 +0200
Message-ID: <200905251719.59610.eike-kernel@sf-tec.de>
References: <1243113110-29635-1-git-send-email-mchan@broadcom.com> <1243113110-29635-4-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16589098.S4gWZYNYUk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:47410 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZEYPUT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 May 2009 11:20:19 -0400
In-Reply-To: <1243113110-29635-4-git-send-email-mchan@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: James.Bottomley@hansenpartnership.com, michaelc@cs.wisc.edu, davem@davemloft.net, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, anilgv@broadcom.com, benli@broadcom.com

--nextPart16589098.S4gWZYNYUk
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Michael Chan wrote:
> The CNIC driver controls BNX2 hardware rings and resources used by
> iSCSI.  Most hardware resources for iSCSI are separate from those
> used for ethernet networking.
>
> iSCSI uses a separate MAC address and IP address.  The CNIC driver
> creates a UIO interface to handle the non-offloaded packets such as
> ARP, etc in userspace.
>

> +static int cnic_alloc_context(struct cnic_dev *dev)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +
> +	if (CHIP_NUM(cp) == CHIP_NUM_5709) {
> +		int i, k, arr_size;
> +
> +		cp->ctx_blk_size = BCM_PAGE_SIZE;
> +		cp->cids_per_blk = BCM_PAGE_SIZE / 128;
> +		arr_size = BNX2_MAX_CID / cp->cids_per_blk *
> +			   sizeof(struct cnic_ctx);
> +		cp->ctx_arr = kmalloc(arr_size, GFP_KERNEL);
> +		if (cp->ctx_arr == NULL)
> +			return -ENOMEM;
> +
> +		memset(cp->ctx_arr, 0, arr_size);

cp->ctx_arr = kzalloc(arr_size, GFP_KERNEL);

> +		k = 0;
> +		for (i = 0; i < 2; i++) {
> +			u32 j, reg, off, lo, hi;
> +
> +			if (i == 0)
> +				off = BNX2_PG_CTX_MAP;
> +			else
> +				off = BNX2_ISCSI_CTX_MAP;
> +
> +			reg = cnic_reg_rd_ind(dev, off);
> +			lo = reg >> 16;
> +			hi = reg & 0xffff;
> +			for (j = lo; j < hi; j += cp->cids_per_blk, k++)
> +				cp->ctx_arr[k].cid = j;
> +		}
> +
> +		cp->ctx_blks = k;
> +		if (cp->ctx_blks >= (BNX2_MAX_CID / cp->cids_per_blk)) {
> +			cp->ctx_blks = 0;
> +			return -ENOMEM;
> +		}
> +
> +		for (i = 0; i < cp->ctx_blks; i++) {
> +			cp->ctx_arr[i].ctx =
> +				pci_alloc_consistent(dev->pcidev, BCM_PAGE_SIZE,
> +						     &cp->ctx_arr[i].mapping);
> +			if (cp->ctx_arr[i].ctx == NULL)
> +				return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int cnic_alloc_bnx2_resc(struct cnic_dev *dev)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	struct uio_info *uinfo;
> +	int ret;
> +
> +	ret = cnic_alloc_dma(dev, &cp->kwq_info, KWQ_PAGE_CNT, 1);
> +	if (ret)
> +		goto error;
> +	cp->kwq = (struct kwqe **) cp->kwq_info.pg_arr;
> +
> +	ret = cnic_alloc_dma(dev, &cp->kcq_info, KCQ_PAGE_CNT, 1);
> +	if (ret)
> +		goto error;
> +	cp->kcq = (struct kcqe **) cp->kcq_info.pg_arr;
> +
> +	ret = cnic_alloc_context(dev);
> +	if (ret)
> +		goto error;
> +
> +	cp->l2_ring_size = 2 * BCM_PAGE_SIZE;
> +	cp->l2_ring = pci_alloc_consistent(dev->pcidev, cp->l2_ring_size,
> +					   &cp->l2_ring_map);
> +	if (!cp->l2_ring)
> +		goto error;
> +
> +	cp->l2_buf_size = (cp->l2_rx_ring_size + 1) * cp->l2_single_buf_size;
> +	cp->l2_buf_size = PAGE_ALIGN(cp->l2_buf_size);
> +	cp->l2_buf = pci_alloc_consistent(dev->pcidev, cp->l2_buf_size,
> +					   &cp->l2_buf_map);
> +	if (!cp->l2_buf)
> +		goto error;
> +
> +	uinfo = kzalloc(sizeof(*uinfo), GFP_ATOMIC);
> +	if (!uinfo)
> +		goto error;
> +
> +	uinfo->mem[0].addr = dev->netdev->base_addr;
> +	uinfo->mem[0].internal_addr = dev->regview;
> +	uinfo->mem[0].size = dev->netdev->mem_end - dev->netdev->mem_start;
> +	uinfo->mem[0].memtype = UIO_MEM_PHYS;
> +
> +	uinfo->mem[1].addr = (unsigned long) cp->status_blk & PAGE_MASK;
> +	if (cp->ethdev->drv_state & CNIC_DRV_STATE_USING_MSIX)
> +		uinfo->mem[1].size = BNX2_SBLK_MSIX_ALIGN_SIZE * 9;
> +	else
> +		uinfo->mem[1].size = BNX2_SBLK_MSIX_ALIGN_SIZE;
> +	uinfo->mem[1].memtype = UIO_MEM_LOGICAL;
> +
> +	uinfo->mem[2].addr = (unsigned long) cp->l2_ring;
> +	uinfo->mem[2].size = cp->l2_ring_size;
> +	uinfo->mem[2].memtype = UIO_MEM_LOGICAL;
> +
> +	uinfo->mem[3].addr = (unsigned long) cp->l2_buf;
> +	uinfo->mem[3].size = cp->l2_buf_size;
> +	uinfo->mem[3].memtype = UIO_MEM_LOGICAL;
> +
> +	uinfo->name = "bnx2_cnic";
> +	uinfo->version = CNIC_MODULE_VERSION;
> +	uinfo->irq = UIO_IRQ_CUSTOM;
> +
> +	uinfo->open = cnic_uio_open;
> +	uinfo->release = cnic_uio_close;
> +
> +	uinfo->priv = dev;
> +
> +	ret = uio_register_device(&dev->pcidev->dev, uinfo);
> +	if (ret) {
> +		kfree(uinfo);
> +		goto error;
> +	}
> +
> +	cp->cnic_uinfo = uinfo;
> +
> +	return 0;
> +
> +error:
> +	cnic_free_resc(dev);
> +	return ret;
> +}
> +
> +static inline u32 cnic_kwq_avail(struct cnic_local *cp)
> +{
> +	return cp->max_kwq_idx -
> +		((cp->kwq_prod_idx - cp->kwq_con_idx) & cp->max_kwq_idx);
> +}
> +
> +static int cnic_submit_bnx2_kwqes(struct cnic_dev *dev, struct kwqe
> *wqes[], +				  u32 num_wqes)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	struct kwqe *prod_qe;
> +	u16 prod, sw_prod, i;
> +
> +	if (!test_bit(CNIC_F_CNIC_UP, &dev->flags))
> +		return -EAGAIN;		/* bnx2 is down */
> +
> +	spin_lock_bh(&cp->cnic_ulp_lock);
> +	if (num_wqes > cnic_kwq_avail(cp) &&
> +	    !(cp->cnic_local_flags & CNIC_LCL_FL_KWQ_INIT)) {
> +		spin_unlock_bh(&cp->cnic_ulp_lock);
> +		return -EAGAIN;
> +	}
> +
> +	cp->cnic_local_flags &= ~CNIC_LCL_FL_KWQ_INIT;
> +
> +	prod = cp->kwq_prod_idx;
> +	sw_prod = prod & MAX_KWQ_IDX;
> +	for (i = 0; i < num_wqes; i++) {
> +		prod_qe = &cp->kwq[KWQ_PG(sw_prod)][KWQ_IDX(sw_prod)];
> +		memcpy(prod_qe, wqes[i], sizeof(struct kwqe));
> +		prod++;
> +		sw_prod = prod & MAX_KWQ_IDX;
> +	}
> +	cp->kwq_prod_idx = prod;
> +
> +	CNIC_WR16(dev, cp->kwq_io_addr, cp->kwq_prod_idx);
> +
> +	spin_unlock_bh(&cp->cnic_ulp_lock);
> +	return 0;
> +}
> +
> +static void service_kcqes(struct cnic_dev *dev, int num_cqes)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	int i, j;
> +
> +	i = 0;
> +	j = 1;
> +	while (num_cqes) {
> +		struct cnic_ulp_ops *ulp_ops;
> +		int ulp_type;
> +		u32 kcqe_op_flag = cp->completed_kcq[i]->kcqe_op_flag;
> +		u32 kcqe_layer = kcqe_op_flag & KCQE_FLAGS_LAYER_MASK;
> +
> +		if (unlikely(kcqe_op_flag & KCQE_RAMROD_COMPLETION))
> +			cnic_kwq_completion(dev, 1);
> +
> +		while (j < num_cqes) {
> +			u32 next_op = cp->completed_kcq[i + j]->kcqe_op_flag;
> +
> +			if ((next_op & KCQE_FLAGS_LAYER_MASK) != kcqe_layer)
> +				break;
> +
> +			if (unlikely(next_op & KCQE_RAMROD_COMPLETION))
> +				cnic_kwq_completion(dev, 1);
> +			j++;
> +		}
> +
> +		if (kcqe_layer == KCQE_FLAGS_LAYER_MASK_L5_RDMA)
> +			ulp_type = CNIC_ULP_RDMA;
> +		else if (kcqe_layer == KCQE_FLAGS_LAYER_MASK_L5_ISCSI)
> +			ulp_type = CNIC_ULP_ISCSI;
> +		else if (kcqe_layer == KCQE_FLAGS_LAYER_MASK_L4)
> +			ulp_type = CNIC_ULP_L4;
> +		else if (kcqe_layer == KCQE_FLAGS_LAYER_MASK_L2)
> +			goto end;
> +		else {
> +			printk(KERN_ERR PFX "%s: Unknown type of KCQE(0x%x)\n",
> +			       dev->netdev->name, kcqe_op_flag);
> +			goto end;
> +		}
> +
> +		rcu_read_lock();
> +		ulp_ops = rcu_dereference(cp->ulp_ops[ulp_type]);
> +		if (likely(ulp_ops)) {
> +			ulp_ops->indicate_kcqes(cp->ulp_handle[ulp_type],
> +						  cp->completed_kcq + i, j);
> +		}
> +		rcu_read_unlock();
> +end:
> +		num_cqes -= j;
> +		i += j;
> +		j = 1;
> +	}
> +	return;
> +}
> +
> +static u16 cnic_bnx2_next_idx(u16 idx)
> +{
> +	return idx + 1;
> +}
> +
> +static u16 cnic_bnx2_hw_idx(u16 idx)
> +{
> +	return idx;
> +}
> +
> +static int cnic_get_kcqes(struct cnic_dev *dev, u16 hw_prod, u16 *sw_prod)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	u16 i, ri, last;
> +	struct kcqe *kcqe;
> +	int kcqe_cnt = 0, last_cnt = 0;
> +
> +	i = ri = last = *sw_prod;
> +	ri &= MAX_KCQ_IDX;
> +
> +	while ((i != hw_prod) && (kcqe_cnt < MAX_COMPLETED_KCQE)) {
> +		kcqe = &cp->kcq[KCQ_PG(ri)][KCQ_IDX(ri)];
> +		cp->completed_kcq[kcqe_cnt++] = kcqe;
> +		i = cp->next_idx(i);
> +		ri = i & MAX_KCQ_IDX;
> +		if (likely(!(kcqe->kcqe_op_flag & KCQE_FLAGS_NEXT))) {
> +			last_cnt = kcqe_cnt;
> +			last = i;
> +		}
> +	}
> +
> +	*sw_prod = last;
> +	return last_cnt;
> +}
> +
> +static void cnic_chk_bnx2_pkt_rings(struct cnic_local *cp)
> +{
> +	u16 rx_cons = *cp->rx_cons_ptr;
> +	u16 tx_cons = *cp->tx_cons_ptr;
> +
> +	if (cp->tx_cons != tx_cons || cp->rx_cons != rx_cons) {
> +		cp->tx_cons = tx_cons;
> +		cp->rx_cons = rx_cons;
> +		uio_event_notify(cp->cnic_uinfo);
> +	}
> +}
> +
> +static int cnic_service_bnx2(void *data, void *status_blk)
> +{
> +	struct cnic_dev *dev = data;
> +	struct status_block *sblk = status_blk;
> +	struct cnic_local *cp = dev->cnic_priv;
> +	u32 status_idx = sblk->status_idx;
> +	u16 hw_prod, sw_prod;
> +	int kcqe_cnt;
> +
> +	if (unlikely(!test_bit(CNIC_F_CNIC_UP, &dev->flags)))
> +		return status_idx;
> +
> +	cp->kwq_con_idx = *cp->kwq_con_idx_ptr;
> +
> +	hw_prod = sblk->status_completion_producer_index;
> +	sw_prod = cp->kcq_prod_idx;
> +	while (sw_prod != hw_prod) {
> +		kcqe_cnt = cnic_get_kcqes(dev, hw_prod, &sw_prod);
> +		if (kcqe_cnt == 0)
> +			goto done;
> +
> +		service_kcqes(dev, kcqe_cnt);
> +
> +		/* Tell compiler that status_blk fields can change. */
> +		barrier();
> +		if (status_idx != sblk->status_idx) {
> +			status_idx = sblk->status_idx;
> +			cp->kwq_con_idx = *cp->kwq_con_idx_ptr;
> +			hw_prod = sblk->status_completion_producer_index;
> +		} else
> +			break;
> +	}
> +
> +done:
> +	CNIC_WR16(dev, cp->kcq_io_addr, sw_prod);
> +
> +	cp->kcq_prod_idx = sw_prod;
> +
> +	cnic_chk_bnx2_pkt_rings(cp);
> +	return status_idx;
> +}
> +
> +static void cnic_service_bnx2_msix(unsigned long data)
> +{
> +	struct cnic_dev *dev = (struct cnic_dev *) data;
> +	struct cnic_local *cp = dev->cnic_priv;
> +	struct status_block_msix *status_blk = cp->bnx2_status_blk;
> +	u32 status_idx = status_blk->status_idx;
> +	u16 hw_prod, sw_prod;
> +	int kcqe_cnt;
> +
> +	cp->kwq_con_idx = status_blk->status_cmd_consumer_index;
> +
> +	hw_prod = status_blk->status_completion_producer_index;
> +	sw_prod = cp->kcq_prod_idx;
> +	while (sw_prod != hw_prod) {
> +		kcqe_cnt = cnic_get_kcqes(dev, hw_prod, &sw_prod);
> +		if (kcqe_cnt == 0)
> +			goto done;
> +
> +		service_kcqes(dev, kcqe_cnt);
> +
> +		/* Tell compiler that status_blk fields can change. */
> +		barrier();
> +		if (status_idx != status_blk->status_idx) {
> +			status_idx = status_blk->status_idx;
> +			cp->kwq_con_idx = status_blk->status_cmd_consumer_index;
> +			hw_prod = status_blk->status_completion_producer_index;
> +		} else
> +			break;
> +	}
> +
> +done:
> +	CNIC_WR16(dev, cp->kcq_io_addr, sw_prod);
> +	cp->kcq_prod_idx = sw_prod;
> +
> +	cnic_chk_bnx2_pkt_rings(cp);
> +
> +	cp->last_status_idx = status_idx;
> +	CNIC_WR(dev, BNX2_PCICFG_INT_ACK_CMD, cp->int_num |
> +		BNX2_PCICFG_INT_ACK_CMD_INDEX_VALID | cp->last_status_idx);
> +}
> +
> +static irqreturn_t cnic_irq(int irq, void *dev_instance)
> +{
> +	struct cnic_dev *dev = dev_instance;
> +	struct cnic_local *cp = dev->cnic_priv;
> +	u16 prod = cp->kcq_prod_idx & MAX_KCQ_IDX;
> +
> +	if (cp->ack_int)
> +		cp->ack_int(dev);
> +
> +	prefetch(cp->status_blk);
> +	prefetch(&cp->kcq[KCQ_PG(prod)][KCQ_IDX(prod)]);
> +
> +	if (likely(test_bit(CNIC_F_CNIC_UP, &dev->flags)))
> +		tasklet_schedule(&cp->cnic_irq_task);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void cnic_ulp_stop(struct cnic_dev *dev)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	int if_type;
> +
> +	rcu_read_lock();
> +	for (if_type = 0; if_type < MAX_CNIC_ULP_TYPE; if_type++) {
> +		struct cnic_ulp_ops *ulp_ops;
> +
> +		ulp_ops = rcu_dereference(cp->ulp_ops[if_type]);
> +		if (!ulp_ops)
> +			continue;
> +
> +		if (test_and_clear_bit(ULP_F_START, &cp->ulp_flags[if_type]))
> +			ulp_ops->cnic_stop(cp->ulp_handle[if_type]);
> +	}
> +	rcu_read_unlock();
> +}
> +
> +static void cnic_ulp_start(struct cnic_dev *dev)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	int if_type;
> +
> +	rcu_read_lock();
> +	for (if_type = 0; if_type < MAX_CNIC_ULP_TYPE; if_type++) {
> +		struct cnic_ulp_ops *ulp_ops;
> +
> +		ulp_ops = rcu_dereference(cp->ulp_ops[if_type]);
> +		if (!ulp_ops || !ulp_ops->cnic_start)
> +			continue;
> +
> +		if (!test_and_set_bit(ULP_F_START, &cp->ulp_flags[if_type]))
> +			ulp_ops->cnic_start(cp->ulp_handle[if_type]);
> +	}
> +	rcu_read_unlock();
> +}
> +
> +static int cnic_ctl(void *data, struct cnic_ctl_info *info)
> +{
> +	struct cnic_dev *dev = data;
> +
> +	switch (info->cmd) {
> +	case CNIC_CTL_STOP_CMD:
> +		cnic_hold(dev);
> +		mutex_lock(&cnic_lock);
> +
> +		cnic_ulp_stop(dev);
> +		cnic_stop_hw(dev);
> +
> +		mutex_unlock(&cnic_lock);
> +		cnic_put(dev);
> +		break;
> +	case CNIC_CTL_START_CMD:
> +		cnic_hold(dev);
> +		mutex_lock(&cnic_lock);
> +
> +		if (!cnic_start_hw(dev))
> +			cnic_ulp_start(dev);
> +
> +		mutex_unlock(&cnic_lock);
> +		cnic_put(dev);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static void cnic_ulp_init(struct cnic_dev *dev)
> +{
> +	int i;
> +	struct cnic_local *cp = dev->cnic_priv;
> +
> +	rcu_read_lock();
> +	for (i = 0; i < MAX_CNIC_ULP_TYPE_EXT; i++) {
> +		struct cnic_ulp_ops *ulp_ops;
> +
> +		ulp_ops = rcu_dereference(cnic_ulp_tbl[i]);
> +		if (!ulp_ops || !ulp_ops->cnic_init)
> +			continue;
> +
> +		if (!test_and_set_bit(ULP_F_INIT, &cp->ulp_flags[i]))
> +			ulp_ops->cnic_init(dev);
> +
> +	}
> +	rcu_read_unlock();
> +}
> +
> +static void cnic_ulp_exit(struct cnic_dev *dev)
> +{
> +	int i;
> +	struct cnic_local *cp = dev->cnic_priv;
> +
> +	rcu_read_lock();
> +	for (i = 0; i < MAX_CNIC_ULP_TYPE_EXT; i++) {
> +		struct cnic_ulp_ops *ulp_ops;
> +
> +		ulp_ops = rcu_dereference(cnic_ulp_tbl[i]);
> +		if (!ulp_ops || !ulp_ops->cnic_exit)
> +			continue;
> +
> +		if (test_and_clear_bit(ULP_F_INIT, &cp->ulp_flags[i]))
> +			ulp_ops->cnic_exit(dev);
> +
> +	}
> +	rcu_read_unlock();
> +}
> +
> +static int cnic_cm_offload_pg(struct cnic_sock *csk)
> +{
> +	struct cnic_dev *dev = csk->dev;
> +	struct l4_kwq_offload_pg *l4kwqe;
> +	struct kwqe *wqes[1];
> +
> +	l4kwqe = (struct l4_kwq_offload_pg *) &csk->kwqe1;
> +	memset(l4kwqe, 0, sizeof(*l4kwqe));
> +	wqes[0] = (struct kwqe *) l4kwqe;
> +
> +	l4kwqe->op_code = L4_KWQE_OPCODE_VALUE_OFFLOAD_PG;
> +	l4kwqe->flags =
> +		L4_LAYER_CODE << L4_KWQ_OFFLOAD_PG_LAYER_CODE_SHIFT;
> +	l4kwqe->l2hdr_nbytes = ETH_HLEN;
> +
> +	l4kwqe->da0 = csk->ha[0];
> +	l4kwqe->da1 = csk->ha[1];
> +	l4kwqe->da2 = csk->ha[2];
> +	l4kwqe->da3 = csk->ha[3];
> +	l4kwqe->da4 = csk->ha[4];
> +	l4kwqe->da5 = csk->ha[5];
> +
> +	l4kwqe->sa0 = dev->mac_addr[0];
> +	l4kwqe->sa1 = dev->mac_addr[1];
> +	l4kwqe->sa2 = dev->mac_addr[2];
> +	l4kwqe->sa3 = dev->mac_addr[3];
> +	l4kwqe->sa4 = dev->mac_addr[4];
> +	l4kwqe->sa5 = dev->mac_addr[5];
> +
> +	l4kwqe->etype = ETH_P_IP;
> +	l4kwqe->ipid_count = DEF_IPID_COUNT;
> +	l4kwqe->host_opaque = csk->l5_cid;
> +
> +	if (csk->vlan_id) {
> +		l4kwqe->pg_flags |= L4_KWQ_OFFLOAD_PG_VLAN_TAGGING;
> +		l4kwqe->vlan_tag = csk->vlan_id;
> +		l4kwqe->l2hdr_nbytes += 4;
> +	}
> +
> +	return dev->submit_kwqes(dev, wqes, 1);
> +}
> +
> +static int cnic_cm_update_pg(struct cnic_sock *csk)
> +{
> +	struct cnic_dev *dev = csk->dev;
> +	struct l4_kwq_update_pg *l4kwqe;
> +	struct kwqe *wqes[1];
> +
> +	l4kwqe = (struct l4_kwq_update_pg *) &csk->kwqe1;
> +	memset(l4kwqe, 0, sizeof(*l4kwqe));
> +	wqes[0] = (struct kwqe *) l4kwqe;
> +
> +	l4kwqe->opcode = L4_KWQE_OPCODE_VALUE_UPDATE_PG;
> +	l4kwqe->flags =
> +		L4_LAYER_CODE << L4_KWQ_UPDATE_PG_LAYER_CODE_SHIFT;
> +	l4kwqe->pg_cid = csk->pg_cid;
> +
> +	l4kwqe->da0 = csk->ha[0];
> +	l4kwqe->da1 = csk->ha[1];
> +	l4kwqe->da2 = csk->ha[2];
> +	l4kwqe->da3 = csk->ha[3];
> +	l4kwqe->da4 = csk->ha[4];
> +	l4kwqe->da5 = csk->ha[5];
> +
> +	l4kwqe->pg_host_opaque = csk->l5_cid;
> +	l4kwqe->pg_valids = L4_KWQ_UPDATE_PG_VALIDS_DA;
> +
> +	return dev->submit_kwqes(dev, wqes, 1);
> +}
> +
> +static int cnic_cm_upload_pg(struct cnic_sock *csk)
> +{
> +	struct cnic_dev *dev = csk->dev;
> +	struct l4_kwq_upload *l4kwqe;
> +	struct kwqe *wqes[1];
> +
> +	l4kwqe = (struct l4_kwq_upload *) &csk->kwqe1;
> +	memset(l4kwqe, 0, sizeof(*l4kwqe));
> +	wqes[0] = (struct kwqe *) l4kwqe;
> +
> +	l4kwqe->opcode = L4_KWQE_OPCODE_VALUE_UPLOAD_PG;
> +	l4kwqe->flags =
> +		L4_LAYER_CODE << L4_KWQ_UPLOAD_LAYER_CODE_SHIFT;
> +	l4kwqe->cid = csk->pg_cid;
> +
> +	return dev->submit_kwqes(dev, wqes, 1);
> +}
> +
> +static int cnic_cm_conn_req(struct cnic_sock *csk)
> +{
> +	struct cnic_dev *dev = csk->dev;
> +	struct l4_kwq_connect_req1 *l4kwqe1;
> +	struct l4_kwq_connect_req2 *l4kwqe2;
> +	struct l4_kwq_connect_req3 *l4kwqe3;
> +	struct kwqe *wqes[3];
> +	u8 tcp_flags = 0;
> +	int num_wqes = 2;
> +
> +	l4kwqe1 = (struct l4_kwq_connect_req1 *) &csk->kwqe1;
> +	l4kwqe2 = (struct l4_kwq_connect_req2 *) &csk->kwqe2;
> +	l4kwqe3 = (struct l4_kwq_connect_req3 *) &csk->kwqe3;
> +	memset(l4kwqe1, 0, sizeof(*l4kwqe1));
> +	memset(l4kwqe2, 0, sizeof(*l4kwqe2));
> +	memset(l4kwqe3, 0, sizeof(*l4kwqe3));
> +
> +	l4kwqe3->op_code = L4_KWQE_OPCODE_VALUE_CONNECT3;
> +	l4kwqe3->flags =
> +		L4_LAYER_CODE << L4_KWQ_CONNECT_REQ3_LAYER_CODE_SHIFT;
> +	l4kwqe3->ka_timeout = csk->ka_timeout;
> +	l4kwqe3->ka_interval = csk->ka_interval;
> +	l4kwqe3->ka_max_probe_count = csk->ka_max_probe_count;
> +	l4kwqe3->tos = csk->tos;
> +	l4kwqe3->ttl = csk->ttl;
> +	l4kwqe3->snd_seq_scale = csk->snd_seq_scale;
> +	l4kwqe3->pmtu = csk->mtu;
> +	l4kwqe3->rcv_buf = csk->rcv_buf;
> +	l4kwqe3->snd_buf = csk->snd_buf;
> +	l4kwqe3->seed = csk->seed;
> +
> +	wqes[0] = (struct kwqe *) l4kwqe1;
> +	if (test_bit(SK_F_IPV6, &csk->flags)) {
> +		wqes[1] = (struct kwqe *) l4kwqe2;
> +		wqes[2] = (struct kwqe *) l4kwqe3;
> +		num_wqes = 3;
> +
> +		l4kwqe1->conn_flags = L4_KWQ_CONNECT_REQ1_IP_V6;
> +		l4kwqe2->op_code = L4_KWQE_OPCODE_VALUE_CONNECT2;
> +		l4kwqe2->flags =
> +			L4_KWQ_CONNECT_REQ2_LINKED_WITH_NEXT |
> +			L4_LAYER_CODE << L4_KWQ_CONNECT_REQ2_LAYER_CODE_SHIFT;
> +		l4kwqe2->src_ip_v6_2 = be32_to_cpu(csk->src_ip[1]);
> +		l4kwqe2->src_ip_v6_3 = be32_to_cpu(csk->src_ip[2]);
> +		l4kwqe2->src_ip_v6_4 = be32_to_cpu(csk->src_ip[3]);
> +		l4kwqe2->dst_ip_v6_2 = be32_to_cpu(csk->dst_ip[1]);
> +		l4kwqe2->dst_ip_v6_3 = be32_to_cpu(csk->dst_ip[2]);
> +		l4kwqe2->dst_ip_v6_4 = be32_to_cpu(csk->dst_ip[3]);
> +		l4kwqe3->mss = l4kwqe3->pmtu - sizeof(struct ipv6hdr) -
> +			       sizeof(struct tcphdr);
> +	} else {
> +		wqes[1] = (struct kwqe *) l4kwqe3;
> +		l4kwqe3->mss = l4kwqe3->pmtu - sizeof(struct iphdr) -
> +			       sizeof(struct tcphdr);
> +	}
> +
> +	l4kwqe1->op_code = L4_KWQE_OPCODE_VALUE_CONNECT1;
> +	l4kwqe1->flags =
> +		(L4_LAYER_CODE << L4_KWQ_CONNECT_REQ1_LAYER_CODE_SHIFT) |
> +		 L4_KWQ_CONNECT_REQ3_LINKED_WITH_NEXT;
> +	l4kwqe1->cid = csk->cid;
> +	l4kwqe1->pg_cid = csk->pg_cid;
> +	l4kwqe1->src_ip = be32_to_cpu(csk->src_ip[0]);
> +	l4kwqe1->dst_ip = be32_to_cpu(csk->dst_ip[0]);
> +	l4kwqe1->src_port = be16_to_cpu(csk->src_port);
> +	l4kwqe1->dst_port = be16_to_cpu(csk->dst_port);
> +	if (csk->tcp_flags & SK_TCP_NO_DELAY_ACK)
> +		tcp_flags |= L4_KWQ_CONNECT_REQ1_NO_DELAY_ACK;
> +	if (csk->tcp_flags & SK_TCP_KEEP_ALIVE)
> +		tcp_flags |= L4_KWQ_CONNECT_REQ1_KEEP_ALIVE;
> +	if (csk->tcp_flags & SK_TCP_NAGLE)
> +		tcp_flags |= L4_KWQ_CONNECT_REQ1_NAGLE_ENABLE;
> +	if (csk->tcp_flags & SK_TCP_TIMESTAMP)
> +		tcp_flags |= L4_KWQ_CONNECT_REQ1_TIME_STAMP;
> +	if (csk->tcp_flags & SK_TCP_SACK)
> +		tcp_flags |= L4_KWQ_CONNECT_REQ1_SACK;
> +	if (csk->tcp_flags & SK_TCP_SEG_SCALING)
> +		tcp_flags |= L4_KWQ_CONNECT_REQ1_SEG_SCALING;
> +
> +	l4kwqe1->tcp_flags = tcp_flags;
> +
> +	return dev->submit_kwqes(dev, wqes, num_wqes);
> +}
> +
> +static int cnic_cm_close_req(struct cnic_sock *csk)
> +{
> +	struct cnic_dev *dev = csk->dev;
> +	struct l4_kwq_close_req *l4kwqe;
> +	struct kwqe *wqes[1];
> +
> +	l4kwqe = (struct l4_kwq_close_req *) &csk->kwqe2;
> +	memset(l4kwqe, 0, sizeof(*l4kwqe));
> +	wqes[0] = (struct kwqe *) l4kwqe;
> +
> +	l4kwqe->op_code = L4_KWQE_OPCODE_VALUE_CLOSE;
> +	l4kwqe->flags = L4_LAYER_CODE << L4_KWQ_CLOSE_REQ_LAYER_CODE_SHIFT;
> +	l4kwqe->cid = csk->cid;
> +
> +	return dev->submit_kwqes(dev, wqes, 1);
> +}
> +
> +static int cnic_cm_abort_req(struct cnic_sock *csk)
> +{
> +	struct cnic_dev *dev = csk->dev;
> +	struct l4_kwq_reset_req *l4kwqe;
> +	struct kwqe *wqes[1];
> +
> +	l4kwqe = (struct l4_kwq_reset_req *) &csk->kwqe2;
> +	memset(l4kwqe, 0, sizeof(*l4kwqe));
> +	wqes[0] = (struct kwqe *) l4kwqe;
> +
> +	l4kwqe->op_code = L4_KWQE_OPCODE_VALUE_RESET;
> +	l4kwqe->flags = L4_LAYER_CODE << L4_KWQ_RESET_REQ_LAYER_CODE_SHIFT;
> +	l4kwqe->cid = csk->cid;
> +
> +	return dev->submit_kwqes(dev, wqes, 1);
> +}
> +
> +static int cnic_cm_create(struct cnic_dev *dev, int ulp_type, u32 cid,
> +			  u32 l5_cid, struct cnic_sock **csk, void *context)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	struct cnic_sock *csk1;
> +
> +	if (l5_cid >= MAX_CM_SK_TBL_SZ)
> +		return -EINVAL;
> +
> +	csk1 = &cp->csk_tbl[l5_cid];
> +	if (atomic_read(&csk1->ref_count))
> +		return -EAGAIN;
> +
> +	if (test_and_set_bit(SK_F_INUSE, &csk1->flags))
> +		return -EBUSY;
> +
> +	csk1->dev = dev;
> +	csk1->cid = cid;
> +	csk1->l5_cid = l5_cid;
> +	csk1->ulp_type = ulp_type;
> +	csk1->context = context;
> +
> +	csk1->ka_timeout = DEF_KA_TIMEOUT;
> +	csk1->ka_interval = DEF_KA_INTERVAL;
> +	csk1->ka_max_probe_count = DEF_KA_MAX_PROBE_COUNT;
> +	csk1->tos = DEF_TOS;
> +	csk1->ttl = DEF_TTL;
> +	csk1->snd_seq_scale = DEF_SND_SEQ_SCALE;
> +	csk1->rcv_buf = DEF_RCV_BUF;
> +	csk1->snd_buf = DEF_SND_BUF;
> +	csk1->seed = DEF_SEED;
> +
> +	*csk = csk1;
> +	return 0;
> +}
> +
> +static void cnic_cm_cleanup(struct cnic_sock *csk)
> +{
> +	if (csk->src_port) {
> +		struct cnic_dev *dev = csk->dev;
> +		struct cnic_local *cp = dev->cnic_priv;
> +
> +		cnic_free_id(&cp->csk_port_tbl, csk->src_port);
> +		csk->src_port = 0;
> +	}
> +}
> +
> +static void cnic_close_conn(struct cnic_sock *csk)
> +{
> +	if (test_bit(SK_F_PG_OFFLD_COMPLETE, &csk->flags)) {
> +		cnic_cm_upload_pg(csk);
> +		clear_bit(SK_F_PG_OFFLD_COMPLETE, &csk->flags);
> +	}
> +	cnic_cm_cleanup(csk);
> +}
> +
> +static int cnic_cm_destroy(struct cnic_sock *csk)
> +{
> +	if (!cnic_in_use(csk))
> +		return -EINVAL;
> +
> +	csk_hold(csk);
> +	clear_bit(SK_F_INUSE, &csk->flags);
> +	smp_mb__after_clear_bit();
> +	while (atomic_read(&csk->ref_count) != 1)
> +		msleep(1);
> +	cnic_cm_cleanup(csk);
> +
> +	csk->flags = 0;
> +	csk_put(csk);
> +	return 0;
> +}
> +
> +static inline u16 cnic_get_vlan(struct net_device *dev,
> +				struct net_device **vlan_dev)
> +{
> +	if (dev->priv_flags & IFF_802_1Q_VLAN) {
> +		*vlan_dev = vlan_dev_real_dev(dev);
> +		return vlan_dev_vlan_id(dev);
> +	}
> +	*vlan_dev = dev;
> +	return 0;
> +}
> +
> +static int cnic_get_v4_route(struct sockaddr_in *dst_addr,
> +			     struct dst_entry **dst)
> +{
> +	struct flowi fl;
> +	int err;
> +	struct rtable *rt;
> +
> +	memset(&fl, 0, sizeof(fl));
> +	fl.nl_u.ip4_u.daddr = dst_addr->sin_addr.s_addr;
> +
> +	err = ip_route_output_key(&init_net, &rt, &fl);
> +	if (!err)
> +		*dst = &rt->u.dst;
> +	return err;
> +}
> +
> +static int cnic_get_v6_route(struct sockaddr_in6 *dst_addr,
> +			     struct dst_entry **dst)
> +{
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
> +	struct flowi fl;
> +
> +	memset(&fl, 0, sizeof(fl));
> +	ipv6_addr_copy(&fl.fl6_dst, &dst_addr->sin6_addr);
> +	if (ipv6_addr_type(&fl.fl6_dst) & IPV6_ADDR_LINKLOCAL)
> +		fl.oif = dst_addr->sin6_scope_id;
> +
> +	*dst = ip6_route_output(&init_net, NULL, &fl);
> +	if (*dst)
> +		return 0;
> +#endif
> +
> +	return -ENETUNREACH;
> +}
> +
> +static struct cnic_dev *cnic_cm_select_dev(struct sockaddr_in *dst_addr,
> +					   int ulp_type)
> +{
> +	struct cnic_dev *dev = NULL;
> +	struct dst_entry *dst;
> +	struct net_device *netdev = NULL;
> +	int err = -ENETUNREACH;
> +
> +	if (dst_addr->sin_family == AF_INET)
> +		err = cnic_get_v4_route(dst_addr, &dst);
> +	else if (dst_addr->sin_family == AF_INET6) {
> +		struct sockaddr_in6 *dst_addr6 =
> +			(struct sockaddr_in6 *) dst_addr;
> +
> +		err = cnic_get_v6_route(dst_addr6, &dst);
> +	} else
> +		return NULL;
> +
> +	if (err)
> +		return NULL;
> +
> +	if (!dst->dev)
> +		goto done;
> +
> +	cnic_get_vlan(dst->dev, &netdev);
> +
> +	dev = cnic_from_netdev(netdev);
> +
> +done:
> +	dst_release(dst);
> +	if (dev)
> +		cnic_put(dev);
> +	return dev;
> +}
> +
> +static int cnic_resolve_addr(struct cnic_sock *csk, struct cnic_sockaddr
> *saddr) +{
> +	struct cnic_dev *dev = csk->dev;
> +	struct cnic_local *cp = dev->cnic_priv;
> +
> +	return cnic_send_nlmsg(cp, ISCSI_KEVENT_PATH_REQ, csk);
> +}
> +
> +static int cnic_get_route(struct cnic_sock *csk, struct cnic_sockaddr
> *saddr) +{
> +	struct cnic_dev *dev = csk->dev;
> +	struct cnic_local *cp = dev->cnic_priv;
> +	int is_v6, err, rc = -ENETUNREACH;
> +	struct dst_entry *dst;
> +	struct net_device *realdev;
> +	u32 local_port;
> +
> +	if (saddr->local.v6.sin6_family == AF_INET6 &&
> +	    saddr->remote.v6.sin6_family == AF_INET6)
> +		is_v6 = 1;
> +	else if (saddr->local.v4.sin_family == AF_INET &&
> +		 saddr->remote.v4.sin_family == AF_INET)
> +		is_v6 = 0;
> +	else
> +		return -EINVAL;
> +
> +	clear_bit(SK_F_IPV6, &csk->flags);
> +
> +	if (is_v6) {
> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
> +		set_bit(SK_F_IPV6, &csk->flags);
> +		err = cnic_get_v6_route(&saddr->remote.v6, &dst);
> +		if (err)
> +			return err;
> +
> +		if (!dst || dst->error || !dst->dev)
> +			goto err_out;
> +
> +		memcpy(&csk->dst_ip[0], &saddr->remote.v6.sin6_addr,
> +		       sizeof(struct in6_addr));
> +		csk->dst_port = saddr->remote.v6.sin6_port;
> +		local_port = saddr->local.v6.sin6_port;
> +#else
> +		return rc;
> +#endif
> +
> +	} else {
> +		err = cnic_get_v4_route(&saddr->remote.v4, &dst);
> +		if (err)
> +			return err;
> +
> +		if (!dst || dst->error || !dst->dev)
> +			goto err_out;
> +
> +		csk->dst_ip[0] = saddr->remote.v4.sin_addr.s_addr;
> +		csk->dst_port = saddr->remote.v4.sin_port;
> +		local_port = saddr->local.v4.sin_port;
> +	}
> +
> +	csk->vlan_id = cnic_get_vlan(dst->dev, &realdev);
> +	if (realdev != dev->netdev)
> +		goto err_out;
> +
> +	if (local_port >= CNIC_LOCAL_PORT_MIN &&
> +	    local_port < CNIC_LOCAL_PORT_MAX) {
> +		if (cnic_alloc_id(&cp->csk_port_tbl, local_port))
> +			local_port = 0;
> +	} else
> +		local_port = 0;
> +
> +	if (!local_port) {
> +		local_port = cnic_alloc_new_id(&cp->csk_port_tbl);
> +		if (local_port == -1) {
> +			rc = -ENOMEM;
> +			goto err_out;
> +		}
> +	}
> +	csk->src_port = local_port;
> +
> +	csk->mtu = dst_mtu(dst);
> +	rc = 0;
> +
> +err_out:
> +	dst_release(dst);
> +	return rc;
> +}
> +
> +static void cnic_init_csk_state(struct cnic_sock *csk)
> +{
> +	csk->state = 0;
> +	clear_bit(SK_F_OFFLD_SCHED, &csk->flags);
> +	clear_bit(SK_F_CLOSING, &csk->flags);
> +}
> +
> +static int cnic_cm_connect(struct cnic_sock *csk, struct cnic_sockaddr
> *saddr) +{
> +	int err = 0;
> +
> +	if (!cnic_in_use(csk))
> +		return -EINVAL;
> +
> +	if (test_and_set_bit(SK_F_CONNECT_START, &csk->flags))
> +		return -EINVAL;
> +
> +	cnic_init_csk_state(csk);
> +
> +	err = cnic_get_route(csk, saddr);
> +	if (err)
> +		goto err_out;
> +
> +	err = cnic_resolve_addr(csk, saddr);
> +	if (!err)
> +		return 0;
> +
> +err_out:
> +	clear_bit(SK_F_CONNECT_START, &csk->flags);
> +	return err;
> +}
> +
> +static int cnic_cm_abort(struct cnic_sock *csk)
> +{
> +	struct cnic_local *cp = csk->dev->cnic_priv;
> +	u32 opcode;
> +
> +	if (!cnic_in_use(csk))
> +		return -EINVAL;
> +
> +	if (cnic_abort_prep(csk))
> +		return cnic_cm_abort_req(csk);
> +
> +	/* Getting here means that we haven't started connect, or
> +	 * connect was not successful.
> +	 */
> +
> +	csk->state = L4_KCQE_OPCODE_VALUE_RESET_COMP;
> +	if (test_bit(SK_F_PG_OFFLD_COMPLETE, &csk->flags))
> +		opcode = csk->state;
> +	else
> +		opcode = L5CM_RAMROD_CMD_ID_TERMINATE_OFFLOAD;
> +	cp->close_conn(csk, opcode);
> +
> +	return 0;
> +}
> +
> +static int cnic_cm_close(struct cnic_sock *csk)
> +{
> +	if (!cnic_in_use(csk))
> +		return -EINVAL;
> +
> +	if (cnic_close_prep(csk)) {
> +		csk->state = L4_KCQE_OPCODE_VALUE_CLOSE_COMP;
> +		return cnic_cm_close_req(csk);
> +	}
> +	return 0;
> +}
> +
> +static void cnic_cm_upcall(struct cnic_local *cp, struct cnic_sock *csk,
> +			   u8 opcode)
> +{
> +	struct cnic_ulp_ops *ulp_ops;
> +	int ulp_type = csk->ulp_type;
> +
> +	rcu_read_lock();
> +	ulp_ops = rcu_dereference(cp->ulp_ops[ulp_type]);
> +	if (ulp_ops) {
> +		if (opcode == L4_KCQE_OPCODE_VALUE_CONNECT_COMPLETE)
> +			ulp_ops->cm_connect_complete(csk);
> +		else if (opcode == L4_KCQE_OPCODE_VALUE_CLOSE_COMP)
> +			ulp_ops->cm_close_complete(csk);
> +		else if (opcode == L4_KCQE_OPCODE_VALUE_RESET_RECEIVED)
> +			ulp_ops->cm_remote_abort(csk);
> +		else if (opcode == L4_KCQE_OPCODE_VALUE_RESET_COMP)
> +			ulp_ops->cm_abort_complete(csk);
> +		else if (opcode == L4_KCQE_OPCODE_VALUE_CLOSE_RECEIVED)
> +			ulp_ops->cm_remote_close(csk);
> +	}
> +	rcu_read_unlock();
> +}
> +
> +static int cnic_cm_set_pg(struct cnic_sock *csk)
> +{
> +	if (cnic_offld_prep(csk)) {
> +		if (test_bit(SK_F_PG_OFFLD_COMPLETE, &csk->flags))
> +			cnic_cm_update_pg(csk);
> +		else
> +			cnic_cm_offload_pg(csk);
> +	}
> +	return 0;
> +}
> +
> +static void cnic_cm_process_offld_pg(struct cnic_dev *dev, struct l4_kcq
> *kcqe) +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	u32 l5_cid = kcqe->pg_host_opaque;
> +	u8 opcode = kcqe->op_code;
> +	struct cnic_sock *csk = &cp->csk_tbl[l5_cid];
> +
> +	csk_hold(csk);
> +	if (!cnic_in_use(csk))
> +		goto done;
> +
> +	if (opcode == L4_KCQE_OPCODE_VALUE_UPDATE_PG) {
> +		clear_bit(SK_F_OFFLD_SCHED, &csk->flags);
> +		goto done;
> +	}
> +	csk->pg_cid = kcqe->pg_cid;
> +	set_bit(SK_F_PG_OFFLD_COMPLETE, &csk->flags);
> +	cnic_cm_conn_req(csk);
> +
> +done:
> +	csk_put(csk);
> +}
> +
> +static void cnic_cm_process_kcqe(struct cnic_dev *dev, struct kcqe *kcqe)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +	struct l4_kcq *l4kcqe = (struct l4_kcq *) kcqe;
> +	u8 opcode = l4kcqe->op_code;
> +	u32 l5_cid;
> +	struct cnic_sock *csk;
> +
> +	if (opcode == L4_KCQE_OPCODE_VALUE_OFFLOAD_PG ||
> +	    opcode == L4_KCQE_OPCODE_VALUE_UPDATE_PG) {
> +		cnic_cm_process_offld_pg(dev, l4kcqe);
> +		return;
> +	}
> +
> +	l5_cid = l4kcqe->conn_id;
> +	if (opcode & 0x80)
> +		l5_cid = l4kcqe->cid;
> +	if (l5_cid >= MAX_CM_SK_TBL_SZ)
> +		return;
> +
> +	csk = &cp->csk_tbl[l5_cid];
> +	csk_hold(csk);
> +
> +	if (!cnic_in_use(csk)) {
> +		csk_put(csk);
> +		return;
> +	}
> +
> +	switch (opcode) {
> +	case L4_KCQE_OPCODE_VALUE_CONNECT_COMPLETE:
> +		if (l4kcqe->status == 0)
> +			set_bit(SK_F_OFFLD_COMPLETE, &csk->flags);
> +
> +		smp_mb__before_clear_bit();
> +		clear_bit(SK_F_OFFLD_SCHED, &csk->flags);
> +		cnic_cm_upcall(cp, csk, opcode);
> +		break;
> +
> +	case L4_KCQE_OPCODE_VALUE_RESET_RECEIVED:
> +		if (test_and_clear_bit(SK_F_OFFLD_COMPLETE, &csk->flags))
> +			csk->state = opcode;
> +		/* fall through */
> +	case L4_KCQE_OPCODE_VALUE_CLOSE_COMP:
> +	case L4_KCQE_OPCODE_VALUE_RESET_COMP:
> +		cp->close_conn(csk, opcode);
> +		break;
> +
> +	case L4_KCQE_OPCODE_VALUE_CLOSE_RECEIVED:
> +		cnic_cm_upcall(cp, csk, opcode);
> +		break;
> +	}
> +	csk_put(csk);
> +}
> +
> +static void cnic_cm_indicate_kcqe(void *data, struct kcqe *kcqe[], u32
> num) +{
> +	struct cnic_dev *dev = data;
> +	int i;
> +
> +	for (i = 0; i < num; i++)
> +		cnic_cm_process_kcqe(dev, kcqe[i]);
> +}
> +
> +static struct cnic_ulp_ops cm_ulp_ops = {
> +	.indicate_kcqes		= cnic_cm_indicate_kcqe,
> +};
> +
> +static void cnic_cm_free_mem(struct cnic_dev *dev)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +
> +	kfree(cp->csk_tbl);
> +	cp->csk_tbl = NULL;
> +	cnic_free_id_tbl(&cp->csk_port_tbl);
> +}
> +
> +static int cnic_cm_alloc_mem(struct cnic_dev *dev)
> +{
> +	struct cnic_local *cp = dev->cnic_priv;
> +
> +	cp->csk_tbl = kmalloc(sizeof(struct cnic_sock) * MAX_CM_SK_TBL_SZ,
> +			      GFP_KERNEL);
> +	if (!cp->csk_tbl)
> +		return -ENOMEM;
> +	memset(cp->csk_tbl, 0, sizeof(struct cnic_sock) * MAX_CM_SK_TBL_SZ);

cp->csk_tbl = kzalloc(sizeof(struct cnic_sock) * MAX_CM_SK_TBL_SZ,
			      GFP_KERNEL);


There are some more of these.

Greetings,

Eike

--nextPart16589098.S4gWZYNYUk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkoatx8ACgkQXKSJPmm5/E7yZQCdG8d81YQr7yyycihRZcUG3IrK
gbkAoId98NrHKApt8zjLeePT0D4IrjkW
=o74U
-----END PGP SIGNATURE-----

--nextPart16589098.S4gWZYNYUk--
