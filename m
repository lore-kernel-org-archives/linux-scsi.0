From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH v1 09/10] mlx4_fc: Implement fcoe/fcoib offload driver,
 fcoib initialization protocol driver
Date: Tue, 17 Aug 2010 10:25:53 -0700
Message-ID: <4C6AC621.7000401@cisco.com>
References: <4C69B8D5.20908@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:40958 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab0HQRZy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2010 13:25:54 -0400
In-Reply-To: <4C69B8D5.20908@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vu Pham <vuhuong@mellanox.com>
Cc: Roland Dreier <rdreier@cisco.com>, Linux RDMA <linux-rdma@vger.kernel.org>, OpenFabrics EWG <ewg@lists.openfabrics.org>, Linux SCSI <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>

On 8/16/10 3:16 PM, Vu Pham wrote:
> 
> 
> 0009-mlx4_fc-Implement-fcoe-fcoib-offload-driver-fcoib-in.patch
> 
> 
> From 0b10d95be067595dbb050d3cc2c779372038aec4 Mon Sep 17 00:00:00 2001
> From: Vu Pham <vu@vu-lt.mti.mtl.com>
> Date: Mon, 16 Aug 2010 14:47:34 -0700
> Subject: [PATCH 09/10] mlx4_fc: Implement fcoe/fcoib offload driver, fcoib initialization protocol driver
> 
> Implement fcoe/fcoib offload driver. The driver utilizes mlx4_device to
> completely offload SCSI operations, and FC-CRC calculations.
> 
> Implement mlx4_fcoib driver which uses FIP-alike protocol to discover
> BridgeX gateways in the Infiniband fabric
> 
> Signed-off-by: Oren Duer <oren@mellanox.co.il>
> Signed-off-by: Vu Pham <vu@mellanox.com>
> ---

<snip>

I skimmed through the patch and just noticed a few issues.  I didn't
do anything like a full review.  I'm copying devel@open-fcoe.org, although
some of them have seen this on the linux-scsi list.

> +static int mlx4_fip_recv(struct sk_buff *skb, struct net_device *dev,
> +			 struct packet_type *ptype, struct net_device *orig_dev)
> +{
> +	struct mfc_vhba *vhba =
> +	    container_of(ptype, struct mfc_vhba, fip_packet_type);
> +	struct ethhdr *eh = eth_hdr(skb);
> +
> +	fcoe_ctlr_recv(&vhba->ctlr, skb);
> +
> +	/* XXX: This is ugly */
> +	memcpy(vhba->dest_addr, eh->h_source, 6);

Not just ugly.  First of all, picking up the dest addr from the FIP packet
source means you may be changing it each time you receive an advertisement
from an FCF, whether its appropriate or not.

Also, the skb may have been freed by fcoe_ctlr_recv().  It is responsible
for it being freed eventually and this could be done before it returns.
Since eh points into the skb it is garbage at this point.

The gateway MAC address will be in vhba->ctlr.dest_addr.

> +
> +	return 0;
> +}
> +
> +static void mlx4_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
> +{
> +	skb->dev = (struct net_device *)mlx4_from_ctlr(fip)->underdev;
> +	dev_queue_xmit(skb);
> +}
> +
> +static int mlx4_fip_ctrl_start(struct mfc_vhba *vhba)
> +{
> +	struct net_device *netdev = (struct net_device *)vhba->underdev;
> +
> +	/* Setup lport private data to point to fcoe softc */
> +	vhba->ctlr.lp = vhba->lp;
> +
> +	/* setup Source Mac Address */
> +	if (!vhba->ctlr.spma)
> +		memcpy(vhba->ctlr.ctl_src_addr, netdev->dev_addr,
> +		       netdev->addr_len);
> +
> +	dev_mc_add(netdev, FIP_ALL_ENODE_MACS);
> +
> +	vhba->fip_packet_type.func = mlx4_fip_recv;
> +	vhba->fip_packet_type.type = htons(ETH_P_FIP);
> +	vhba->fip_packet_type.dev = netdev;
> +	dev_add_pack(&vhba->fip_packet_type);
> +
> +	return 0;
> +}
> +
> +int mlx4_fip_ctrl_stop(struct mfc_vhba *vhba)
> +{
> +	dev_remove_pack(&vhba->fip_packet_type);
> +	fcoe_ctlr_link_down(&vhba->ctlr);
> +	fcoe_ctlr_destroy(&vhba->ctlr);
> +
> +	return 0;
> +}
> +
> +static void mfc_libfc_destroy(struct fc_lport *lp)
> +{
> +	fc_remove_host(lp->host);
> +	scsi_remove_host(lp->host);
> +	fc_lport_destroy(lp);
> +}
> +
> +static void mfc_flogi_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
> +{
> +	struct fcoe_ctlr *fip = arg;
> +	struct fc_exch *exch = fc_seq_exch(seq);
> +	struct fc_lport *lport = exch->lp;
> +	struct mfc_vhba *vhba = lport_priv(lport);
> +	u8 *mac;
> +
> +	if (IS_ERR(fp))
> +		goto done;
> +
> +	mac = fr_cb(fp)->granted_mac;
> +	if (is_zero_ether_addr(mac) && vhba->net_type == NET_ETH) {
> +		/* pre-FIP */
> +		if (fcoe_ctlr_recv_flogi(fip, lport, fp)) {
> +			fc_frame_free(fp);
> +			return;
> +		}
> +	}
> +
> +	mfc_update_src_mac(lport, mac);
> +done:
> +	fc_lport_flogi_resp(seq, fp, lport);
> +}
> +
> +static void mfc_logo_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
> +{
> +	struct fc_lport *lport = arg;
> +	static u8 zero_mac[ETH_ALEN] = { 0 };
> +
> +	if (!IS_ERR(fp))
> +		mfc_update_src_mac(lport, zero_mac);
> +	fc_lport_logo_resp(seq, fp, lport);
> +}
> +
> +static struct fc_seq *mfc_elsct_send(struct fc_lport *lport, u32 did,
> +				     struct fc_frame *fp, unsigned int op,
> +				     void (*resp) (struct fc_seq *,
> +						   struct fc_frame *,
> +						   void *), void *arg,
> +						   u32 timeout)
> +{
> +	struct mfc_vhba *vhba = lport_priv(lport);
> +	struct fcoe_ctlr *fip = &vhba->ctlr;
> +	struct fc_frame_header *fh = fc_frame_header_get(fp);
> +
> +	switch (op) {
> +	case ELS_FLOGI:
> +	case ELS_FDISC:
> +		return fc_elsct_send(lport, did, fp, op, mfc_flogi_resp,
> +				     fip, timeout);
> +	case ELS_LOGO:
> +		/* only hook onto fabric logouts, not port logouts */
> +		if (ntoh24(fh->fh_d_id) != FC_FID_FLOGI)
> +			break;
> +		return fc_elsct_send(lport, did, fp, op, mfc_logo_resp,
> +				     lport, timeout);
> +	}
> +	return fc_elsct_send(lport, did, fp, op, resp, arg, timeout);

A better way to pick up the assigned MAC address after FLOGI succeeds
is by providing a callback in the libfc_function_template for lport_set_port_id().

That gets a copy of the original frame and fcoe_ctlr_recv_flogi()
can get the granted_mac address out of that for the non-FIP case.
It also gets called at LOGO when the port_id is being set to 0.
See how fnic does it.  That's cleaner than intercepting FLOGI and
LOGO ELSes.  Also, the callback for set_mac_addr()
should take care of the assigned MAC address.

I forget why fcoe.ko did it this way, and its OK for you to do this, too,
but I think the fnic way is cleaner.

> +}
> +
> +static int mfc_libfc_init(struct fc_lport *lp, int min_xid, int max_xid,
> +			  const char *symbolic_name, u64 wwpn, u64 wwnn)
> +{
> +	struct mfc_vhba *vhba = lport_priv(lp);
> +	int err;
> +
> +	fc_set_wwnn(lp, wwnn);
> +	fc_set_wwpn(lp, wwpn);
> +
> +	/* libfc expects max FC frame size, including native FC header */
> +	fc_set_mfs(lp, vhba->fc_payload_size + sizeof(struct fc_frame_header));
> +
> +	lp->host->max_lun = MFC_MAX_LUN;
> +	lp->host->max_id = MFC_MAX_FCP_TARGET;
> +	lp->host->max_channel = 0;
> +	lp->host->transportt = mfc_transport_template;
> +
> +	err = scsi_add_host(lp->host, NULL);
> +	if (err) {
> +		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
> +			"Failed scsi_add_host port %d vhba %d\n",
> +			vhba->mfc_port->port, vhba->idx);
> +		return err;
> +	}
> +
> +	snprintf(fc_host_symbolic_name(lp->host), FC_SYMBOLIC_NAME_SIZE,
> +		 "%s v%s over %s", DRV_NAME, DRV_VERSION, symbolic_name);
> +
> +	if (vhba->net_type == NET_ETH) {
> +		/* Initialize FIP */
> +		fcoe_ctlr_init(&vhba->ctlr, FIP_MODE_AUTO);
> +		vhba->ctlr.send = mlx4_fip_send;
> +		vhba->ctlr.update_mac = mfc_update_src_mac;
> +		vhba->ctlr.get_src_addr = mfc_get_src_addr;
> +	}
> +
> +	lp->tt = mlx4_libfc_fcn_templ;
> +
> +	fc_exch_init(lp);
> +	fc_elsct_init(lp);
> +	fc_lport_init(lp);
> +	fc_rport_init(lp);
> +
> +	if (vhba->net_type == NET_ETH) {
> +		vhba->fc_rport_login = (void *)lp->tt.rport_login;
> +		lp->tt.rport_login = (void *)mlx4_rport_login;
> +	}
> +
> +	fc_disc_init(lp);
> +
> +	vhba->emp = fc_exch_mgr_alloc(lp, FC_CLASS_3, min_xid, max_xid, NULL);
> +	if (!vhba->emp) {
> +		dev_err(vhba->mfc_port->mfc_dev->dma_dev,
> +			"Failed allo libfc exch manager on port %d vhba %d\n",
> +			vhba->mfc_port->port, vhba->idx);
> +		return -ENOMEM;
> +	}
> +
> +	if (vhba->net_type == NET_IB)
> +		fc_fabric_login(lp);
> +
> +	return 0;
> +}
> +
> +int mfc_create_vhba(struct mfc_port *fc_port,
> +		    unsigned int mtu,
> +		    int vlan_id, int prio,
> +		    int dest_lid, unsigned long dest_ctrl_qpn,
> +		    unsigned long dest_data_qpn, int dest_sl,
> +		    void *underdev, const char *symbolic_name,
> +		    u64 gw_discovery_handle,
> +		    fcoib_send_els_cb fcoib_send_els_cb,
> +		    enum mfc_net_type net_type, u64 wwpn, u64 wwnn)
> +{
> +	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
> +	struct mlx4_caps *caps = &mfc_dev->dev->caps;
> +	struct fc_lport *lp;
> +	struct mfc_vhba *vhba;
> +	int idx, port = fc_port->port;
> +	int err;
> +	unsigned long flags;
> +	struct Scsi_Host *shost;
> +
> +	mfc_driver_template.can_queue = (1 << mfc_log_exch_per_vhba) -
> +	    mfc_num_reserved_xids;
> +
> +	lp = libfc_host_alloc(&mfc_driver_template, sizeof(struct mfc_vhba));
> +	if (!lp) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Could not allocate lport on port %d\n", port);
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	shost = lp->host;
> +	vhba = lport_priv(lp);
> +	vhba->lp = lp;
> +	vhba->gw_discovery_handle = gw_discovery_handle;
> +	vhba->fcoib_send_els_cb = fcoib_send_els_cb;
> +
> +	err = mfc_lport_config(lp);
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Error configuring lport on port %d\n", port);
> +		goto err_host_put;
> +	}
> +
> +	idx = mfc_bitmap_slot_alloc(&fc_port->fexch_bulk_bm, 1);
> +	if (idx == -1) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Failed alloc fexchs for new vhba on port %d\n", port);
> +		err = -ENOMEM;
> +		goto err_lport_destroy;
> +	}
> +	vhba->idx = idx;
> +	vhba->mfc_port = fc_port;
> +	vhba->underdev = underdev;
> +	vhba->rfci[RFCI_DATA].fc_mac_idx = -1;
> +	/* TODO: needed? */
> +	vhba->rfci_rx_enabled = 0;
> +
> +	if (!mfc_t11_mode) {
> +		vhba->fcoe_hlen = sizeof(struct fcoe_hdr_old);
> +		vhba->fc_payload_size = mtu -
> +		    sizeof(struct fcoe_hdr_old) -
> +		    sizeof(struct fc_frame_header) -
> +		    sizeof(struct fcoe_crc_eof_old);
> +	} else {
> +		vhba->fcoe_hlen = sizeof(struct fcoe_hdr);
> +		vhba->fc_payload_size = mtu -
> +		    sizeof(struct fcoe_hdr) -
> +		    sizeof(struct fc_frame_header) -
> +		    sizeof(struct fcoe_crc_eof);
> +	}
> +
> +	if (net_type == NET_IB) {
> +		vhba->fc_payload_size -= 2;
> +		if (!mfc_t11_mode)
> +			/* in IB pre-T11 we have 3 padding in EOF */
> +			vhba->fc_payload_size -= 3;
> +	}
> +
> +	/*
> +	 * Enforcing the fc_payload_size to 8B multiple to work-around
> +	 * Tachyon/Tachlite DIF insertion/marshalling on 8B alignment.
> +	 */
> +	vhba->fc_payload_size = min(mfc_payload_size,
> +				    vhba->fc_payload_size) & 0xFFFFFFFFFFFFFFF0;
> +	vhba->num_fexch = 1 << fc_port->log_num_fexch_per_vhba;
> +	vhba->base_fexch_qpn = fc_port->base_fexch_qpn + idx * vhba->num_fexch;
> +	vhba->base_fexch_mpt = fc_port->base_fexch_mpt + idx * vhba->num_fexch;
> +
> +	dev_info(mfc_dev->dma_dev,
> +		 "vhba %d type %s on port %d b_qpn=0x%x, b_mpt=0x%x, n_fexch=%d"
> +		 " fc_payload_size=%d\n",
> +		 vhba->idx, (net_type == NET_IB) ? "NET_IB" : "NET_ETH", port,
> +		 vhba->base_fexch_qpn, vhba->base_fexch_mpt, vhba->num_fexch,
> +		 vhba->fc_payload_size);
> +
> +	vhba->net_type = net_type;
> +	vhba->dest_ib_lid = dest_lid;
> +	vhba->dest_ib_ctrl_qpn = dest_ctrl_qpn;
> +	vhba->dest_ib_data_qpn = dest_data_qpn;
> +	vhba->dest_ib_sl = dest_sl;
> +
> +	vhba->fc_vlan_id = vlan_id;
> +	vhba->fc_vlan_prio = prio;
> +	if (vlan_id != -1) {
> +		err = mlx4_register_vlan(mfc_dev->dev, port, vlan_id,
> +					 &vhba->fc_vlan_idx);
> +		if (err) {
> +			dev_err(mfc_dev->dma_dev,
> +				"Fail to reg VLAN %d err=0x%x port%d vhba%d\n",
> +				vlan_id, err, port, idx);
> +			goto err_free_fexch_bulk;
> +		}
> +		dev_info(mfc_dev->dma_dev,
> +			 "Reg vlan %d prio %d to index %d on port %d vhba %d\n",
> +			 vlan_id, prio, vhba->fc_vlan_idx, port, idx);
> +	}
> +	u64_to_mac(vhba->rfci[RFCI_CTRL].mac, caps->def_mac[port]);
> +
> +	err = mfc_create_rfci(vhba, &vhba->rfci[RFCI_CTRL],
> +			      caps->def_mac[port]);
> +
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"port%d vhba%d: Could not create CTRL RFCI, err=%d\n",
> +			port, idx, err);
> +		goto err_unreg_vlan;
> +	}
> +
> +	err = mfc_create_fcmd(vhba);
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"port%d vhba%d: Could not create FCMD, err=%d\n",
> +			port, idx, err);
> +		goto err_destroy_rfci_ctrl;
> +	}
> +
> +	err = mfc_libfc_init(lp, vhba->base_reserved_xid,
> +			     vhba->base_reserved_xid + vhba->num_reserved_xid,
> +			     symbolic_name, wwpn, wwnn);
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Could not init libfc port %d vhba %d\n", port, idx);
> +
> +		goto err_destroy_fcmd;
> +	}
> +
> +	err = mfc_init_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Could not init CTRL RFCI err=%x port %d vhba %d\n",
> +			err, port, idx);
> +		goto err_destroy_libfc;
> +	}
> +
> +	memcpy(vhba->dest_addr, gw_mac, ETH_ALEN);
> +	INIT_DELAYED_WORK(&vhba->delayed_work, mfc_link_work);
> +
> +	spin_lock_irqsave(&fc_port->lock, flags);
> +	list_add(&vhba->list, &fc_port->vhba_list);
> +	spin_unlock_irqrestore(&fc_port->lock, flags);
> +
> +	mfc_vhba_create_dentry(vhba);
> +
> +	if (net_type == NET_IB)
> +		fc_linkup(lp);
> +	else if (net_type == NET_ETH) {
> +		mlx4_fip_ctrl_start(vhba);
> +		fcoe_ctlr_link_up(&vhba->ctlr);
> +		fc_fabric_login(lp);
> +		vhba->link_up = 1;
> +	}
> +
> +	return 0;
> +
> +err_destroy_libfc:
> +	mfc_libfc_destroy(lp);
> +err_destroy_fcmd:
> +	mfc_destroy_fcmd(vhba);
> +err_destroy_rfci_ctrl:
> +	mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
> +err_unreg_vlan:
> +	if (vhba->fc_vlan_id != -1)
> +		mlx4_unregister_vlan(mfc_dev->dev, port, vhba->fc_vlan_idx);
> +err_free_fexch_bulk:
> +	mfc_bitmap_slot_free(&fc_port->fexch_bulk_bm, idx);
> +err_lport_destroy:
> +	mfc_lport_destroy(lp);
> +err_host_put:
> +	scsi_host_put(lp->host);
> +err_out:
> +	return err;
> +}
> +
> +/* vhba->mfc_port->lock must be held */
> +void mfc_remove_vhba(struct mfc_vhba *vhba)
> +{
> +	struct mfc_port *fc_port = vhba->mfc_port;
> +	struct mfc_dev *mfc_dev = fc_port->mfc_dev;
> +	int port = fc_port->port, idx = vhba->idx;
> +	struct fc_lport *lp = vhba->lp;
> +	unsigned long flags;
> +
> +	vhba->need_reset = 1;
> +	mfc_vhba_delete_dentry(vhba);
> +
> +	/* Logout of the fabric */
> +	fc_fabric_logoff(lp);
> +
> +	if (vhba->net_type == NET_ETH)
> +		mlx4_fip_ctrl_stop(vhba);
> +
> +	spin_lock_irqsave(&fc_port->lock, flags);
> +	list_del(&vhba->list);
> +	spin_unlock_irqrestore(&fc_port->lock, flags);
> +
> +	fc_linkdown(lp);
> +
> +	mfc_destroy_fcmd(vhba);
> +
> +	mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_CTRL]);
> +	if (vhba->rfci[RFCI_DATA].fc_mac_idx != -1)
> +		mfc_destroy_rfci(vhba, &vhba->rfci[RFCI_DATA]);
> +	if (vhba->fc_vlan_id != -1)
> +		mlx4_unregister_vlan(mfc_dev->dev, port, vhba->fc_vlan_idx);
> +	mfc_bitmap_slot_free(&fc_port->fexch_bulk_bm, idx);
> +
> +	mfc_libfc_destroy(vhba->lp);
> +	mfc_lport_destroy(lp);
> +	scsi_host_put(lp->host);
> +}
> +
> +int mfc_init_port(struct mfc_dev *mfc_dev, int port)
> +{
> +	struct mfc_port *mfc_port = &mfc_dev->mfc_port[port];
> +	int err = 0;
> +	int mvp = (1 << mfc_dev->log_num_mac) * (1 << mfc_dev->log_num_vlan) *
> +	    (1 << mfc_dev->log_num_prio);
> +	struct mfc_basic_config_params params = { 0 };
> +	int count = 0;
> +	char wq_name[16];
> +
> +	memset(&mfc_port->npid_table, 0,
> +	       sizeof(struct nport_id) * MFC_NUM_NPORT_IDS);
> +	mfc_port->port = port;
> +	mfc_port->mfc_dev = mfc_dev;
> +	mfc_port->lock = __SPIN_LOCK_UNLOCKED(mfc_port->lock);
> +	INIT_LIST_HEAD(&mfc_port->vhba_list);
> +	mfc_port->num_fexch_qps =
> +	    (1 << mfc_log_exch_per_vhba) * max_vhba_per_port;
> +	mfc_port->log_num_fexch_per_vhba = mfc_log_exch_per_vhba;
> +	err = mlx4_qp_reserve_range(mfc_dev->dev, mfc_port->num_fexch_qps,
> +				    MFC_MAX_PORT_FEXCH,
> +				    &mfc_port->base_fexch_qpn);
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Could not allocate QP range for FEXCH."
> +			" Need 0x%x QPs aligned to 0x%x on port %d\n",
> +			mfc_port->num_fexch_qps, MFC_MAX_PORT_FEXCH, port);
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	/* TODO: for bidirectional SCSI we'll need to double the amount of
> +	   reserved MPTs, with proper spanning */
> +	err = mlx4_mr_reserve_range(mfc_dev->dev, mfc_port->num_fexch_qps,
> +				    2 * MFC_MAX_PORT_FEXCH,
> +				    &mfc_port->base_fexch_mpt);
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Could not allocate MPT range for FEXCH."
> +			" Need 0x%x MPTs aligned to 0x%x on port %d\n",
> +			mfc_port->num_fexch_qps, 2 * MFC_MAX_PORT_FEXCH, port);
> +		err = -ENOMEM;
> +		goto err_free_qp_range;
> +	}
> +
> +	switch (mfc_dev->dev->caps.port_type[port]) {
> +	case MLX4_PORT_TYPE_IB:
> +		count = max_vhba_per_port;
> +		break;
> +	case MLX4_PORT_TYPE_ETH:
> +		count = mvp;
> +		break;
> +	default:
> +		err = 1;
> +		goto err_free_qp_range;
> +	}
> +
> +	err = mlx4_qp_reserve_range(mfc_dev->dev, count, count,
> +				    &mfc_port->base_rfci_qpn);
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Could not allocate QP range for RFCIs."
> +			" Need 0x%x QPs naturally aligned on port %d\n",
> +			max_vhba_per_port, port);
> +		err = -ENOMEM;
> +		goto err_out;
> +	}
> +
> +	params.rfci_base = mfc_port->base_rfci_qpn;
> +	params.fexch_base = mfc_port->base_fexch_qpn;
> +	params.fexch_base_mpt = mfc_port->base_fexch_mpt;
> +	params.nm = mfc_port->n_m = mfc_dev->log_num_mac;
> +	params.nv = mfc_port->n_v = mfc_dev->log_num_vlan;
> +	params.np = mfc_port->n_p = mfc_dev->log_num_prio;
> +	params.log_num_rfci = ilog2(count);
> +	params.def_fcoe_promisc_qpn = 0x77;
> +	params.def_fcoe_mcast_qpn = 0x78;
> +
> +	dev_info(mfc_dev->dma_dev,
> +		 "port %d b_fexch=0x%x, n_fexch=0x%x, b_mpt=0x%x,"
> +		 " b_rfci=0x%x, num_rfci=0x%x\n",
> +		 port, mfc_port->base_fexch_qpn, mfc_port->num_fexch_qps,
> +		 mfc_port->base_fexch_mpt, mfc_port->base_rfci_qpn, count);
> +
> +	err = mlx4_CONFIG_FC_BASIC(mfc_dev->dev, port, &params);
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Failed issue CONFIG_FC Basic on port %d\n", port);
> +		goto err_free_mr_range;
> +	}
> +
> +	err = mfc_bitmap_alloc(&mfc_port->fexch_bulk_bm,
> +			       mfc_port->num_fexch_qps >> mfc_port->
> +			       log_num_fexch_per_vhba);
> +
> +	if (err) {
> +		dev_err(mfc_dev->dma_dev,
> +			"Failed alloc fexch bulks bitmap on port %d\n", port);
> +		goto err_free_mr_range;
> +	}
> +
> +	snprintf(wq_name, 16, "rfci_wq_%d_%d", mfc_dev_idx, port);
> +
> +	mfc_port->rfci_wq = create_singlethread_workqueue(wq_name);
> +	if (!mfc_port->rfci_wq)
> +		goto err_free_qp_range;
> +
> +	snprintf(wq_name, 16, "async_wq_%d_%d", mfc_dev_idx, port);
> +	mfc_port->async_wq = create_singlethread_workqueue(wq_name);
> +	if (!mfc_port->async_wq)
> +		goto err_free_wq;
> +
> +	mfc_port->initialized = 1;
> +	mfc_port_create_dentry(mfc_port);
> +
> +	return 0;
> +
> +err_free_wq:
> +	destroy_workqueue(mfc_port->rfci_wq);
> +err_free_qp_range:
> +	mlx4_qp_release_range(mfc_dev->dev, mfc_port->base_fexch_qpn,
> +			      mfc_port->num_fexch_qps);
> +err_free_mr_range:
> +	mlx4_mr_release_range(mfc_dev->dev, mfc_port->base_fexch_mpt,
> +			      mfc_port->num_fexch_qps);
> +err_out:
> +	return err;
> +}
> +
> +void mfc_free_port(struct mfc_dev *mfc_dev, int port)
> +{
> +	struct mfc_port *fc_port = &mfc_dev->mfc_port[port];
> +	struct mfc_vhba *vhba, *tmp;
> +
> +	mfc_port_delete_dentry(fc_port);
> +	fc_port->initialized = 0;
> +
> +	flush_workqueue(fc_port->rfci_wq);
> +	flush_workqueue(fc_port->async_wq);
> +
> +	list_for_each_entry_safe(vhba, tmp, &fc_port->vhba_list, list)
> +	    mfc_remove_vhba(vhba);
> +
> +	/*
> +	 * make sure the bitmap is empty, meaning, no vhba's left using
> +	 * fexch bulk
> +	 */
> +	mfc_bitmap_free(&fc_port->fexch_bulk_bm);
> +	mlx4_qp_release_range(mfc_dev->dev, fc_port->base_fexch_qpn,
> +			      fc_port->num_fexch_qps);
> +	mlx4_mr_release_range(mfc_dev->dev, fc_port->base_fexch_mpt,
> +			      fc_port->num_fexch_qps);
> +
> +	destroy_workqueue(fc_port->rfci_wq);
> +	destroy_workqueue(fc_port->async_wq);
> +}
> +
> +static void *mfc_add_dev(struct mlx4_dev *dev)
> +{
> +	struct mfc_dev *mfc_dev;
> +	int port;
> +	int err;
> +	unsigned long flags;
> +	int pre_t11_enable = 0;
> +	int t11_supported = 0;
> +
> +	dev_info(&dev->pdev->dev, "Adding device[%d] %.*s at %s\n",
> +		 mfc_dev_idx + 1, MLX4_BOARD_ID_LEN, dev->board_id,
> +		 dev_driver_string(&dev->pdev->dev));
> +
> +	mfc_dev = kzalloc(sizeof(struct mfc_dev), GFP_KERNEL);
> +	if (!mfc_dev) {
> +		dev_err(&dev->pdev->dev, "Alloc mfc_dev failed\n");
> +		goto err_out;
> +	}
> +
> +	mfc_dev->idx = mfc_dev_idx++;
> +
> +	err = mlx4_pd_alloc(dev, &mfc_dev->priv_pdn);
> +	if (err) {
> +		dev_err(&dev->pdev->dev, "PD alloc failed %d\n", err);
> +		goto err_free_dev;
> +	}
> +
> +	err = mlx4_mr_alloc(dev, mfc_dev->priv_pdn, 0, ~0ull,
> +			    MLX4_PERM_LOCAL_WRITE | MLX4_PERM_LOCAL_READ, 0, 0,
> +			    &mfc_dev->mr);
> +	if (err) {
> +		dev_err(&dev->pdev->dev, "mr alloc failed %d\n", err);
> +		goto err_free_pd;
> +	}
> +
> +	err = mlx4_mr_enable(dev, &mfc_dev->mr);
> +	if (err) {
> +		dev_err(&dev->pdev->dev, "mr enable failed %d\n", err);
> +		goto err_free_mr;
> +	}
> +
> +	if (mlx4_uar_alloc(dev, &mfc_dev->priv_uar))
> +		goto err_free_mr;
> +
> +	mfc_dev->uar_map =
> +	    ioremap(mfc_dev->priv_uar.pfn << PAGE_SHIFT, PAGE_SIZE);
> +	if (!mfc_dev->uar_map)
> +		goto err_free_uar;
> +
> +	MLX4_INIT_DOORBELL_LOCK(&mfc_dev->uar_lock);
> +
> +	INIT_LIST_HEAD(&mfc_dev->pgdir_list);
> +	mutex_init(&mfc_dev->pgdir_mutex);
> +
> +	mfc_dev->dev = dev;
> +	mfc_dev->dma_dev = &dev->pdev->dev;
> +	mfc_dev->log_num_mac = dev->caps.log_num_macs;
> +	mfc_dev->log_num_vlan = dev->caps.log_num_vlans;
> +	mfc_dev->log_num_prio = dev->caps.log_num_prios;
> +
> +	mlx4_get_fc_t11_settings(dev, &pre_t11_enable, &t11_supported);
> +
> +	if (pre_t11_enable) {
> +		mfc_t11_mode = 0;
> +		dev_info(&dev->pdev->dev, "Starting FC device PRE-T11 mode\n");
> +	} else if (t11_supported && !pre_t11_enable) {
> +		mfc_t11_mode = 1;
> +		dev_info(mfc_dev->dma_dev, "Starting FC device T11 mode\n");
> +	} else {
> +		dev_err(mfc_dev->dma_dev, "FAIL start fc device in T11 mode, "
> +			"please enable PRE-T11 in mlx4_core\n");
> +		goto err_free_uar;
> +	}
> +
> +	for (port = 1; port <= mfc_dev->dev->caps.num_ports; port++) {
> +		err = mfc_init_port(mfc_dev, port);
> +		if (err)
> +			goto err_free_ports;
> +	}
> +
> +	spin_lock_irqsave(&mfc_dev_list_lock, flags);
> +	list_add(&mfc_dev->list, &mfc_dev_list);
> +	spin_unlock_irqrestore(&mfc_dev_list_lock, flags);
> +
> +	return mfc_dev;
> +
> +err_free_ports:
> +	while (--port)
> +		mfc_free_port(mfc_dev, port);
> +	iounmap(mfc_dev->uar_map);
> +err_free_uar:
> +	mlx4_uar_free(dev, &mfc_dev->priv_uar);
> +err_free_mr:
> +	mlx4_mr_free(mfc_dev->dev, &mfc_dev->mr);
> +err_free_pd:
> +	mlx4_pd_free(dev, mfc_dev->priv_pdn);
> +err_free_dev:
> +	kfree(mfc_dev);
> +err_out:
> +	return NULL;
> +}
> +
> +static void mfc_remove_dev(struct mlx4_dev *dev, void *fcdev_ptr)
> +{
> +	struct mfc_dev *mfc_dev = fcdev_ptr;
> +	int port;
> +	unsigned long flags;
> +
> +	dev_info(&dev->pdev->dev, "%.*s: removing\n", MLX4_BOARD_ID_LEN,
> +		 dev->board_id);
> +
> +	spin_lock_irqsave(&mfc_dev_list_lock, flags);
> +	list_del(&mfc_dev->list);
> +	spin_unlock_irqrestore(&mfc_dev_list_lock, flags);
> +
> +	for (port = 1; port <= mfc_dev->dev->caps.num_ports; port++)
> +		mfc_free_port(mfc_dev, port);
> +
> +	iounmap(mfc_dev->uar_map);
> +	mlx4_uar_free(dev, &mfc_dev->priv_uar);
> +	mlx4_mr_free(dev, &mfc_dev->mr);
> +	mlx4_pd_free(dev, mfc_dev->priv_pdn);
> +
> +	kfree(mfc_dev);
> +}
> +
> +static inline struct mfc_vhba *find_vhba_for_netdev(struct net_device *netdev)
> +{
> +	struct mfc_dev *mfc_dev;
> +	struct mfc_port *fc_port;
> +	struct mfc_vhba *vhba;
> +	int p;
> +	unsigned long flags2;
> +
> +	spin_lock_irqsave(&mfc_dev_list_lock, flags2);
> +	list_for_each_entry(mfc_dev, &mfc_dev_list, list)
> +	    for (p = 1; p <= MLX4_MAX_PORTS; ++p) {
> +		unsigned long flags;
> +		fc_port = &mfc_dev->mfc_port[p];
> +		if (!fc_port->initialized)
> +			continue;
> +		spin_lock_irqsave(&fc_port->lock, flags);
> +		list_for_each_entry(vhba, &fc_port->vhba_list, list)
> +		    if (vhba->underdev == netdev) {
> +			spin_unlock_irqrestore(&fc_port->lock, flags);
> +			spin_unlock_irqrestore(&mfc_dev_list_lock, flags2);
> +			return vhba;
> +		}
> +		spin_unlock_irqrestore(&fc_port->lock, flags);
> +	}
> +	spin_unlock_irqrestore(&mfc_dev_list_lock, flags2);
> +	return NULL;
> +}
> +
> +static void mfc_link_change(struct mfc_vhba *vhba, int link_up)
> +{
> +	struct fc_lport *lp = vhba->lp;
> +
> +	if (link_up) {
> +		if (vhba->net_type == NET_ETH)
> +			fcoe_ctlr_link_up(&vhba->ctlr);
> +
> +		fc_linkup(lp);

This is harmless, but fc_linkup() is also called by fcoe_ctlr_link_up().
Similarly for fc_linkdown() below.  So you might want to put those in
else clauses.

> +	} else {
> +		if (vhba->net_type == NET_ETH)
> +			fcoe_ctlr_link_down(&vhba->ctlr);
> +
> +		fc_linkdown(lp);
> +	}
> +}
> +
> +static void mfc_link_work(struct work_struct *work)
> +{
> +	struct mfc_vhba *vhba =
> +	    container_of(work, struct mfc_vhba, delayed_work.work);
> +
> +	if (!vhba->link_up)
> +		vhba->need_reset = 1;
> +	mfc_link_change(vhba, vhba->link_up);
> +}
> +
> +static void mfc_async_event(struct mlx4_dev *dev, void *mfc_dev_ptr,
> +			    enum mlx4_dev_event event, int port)
> +{
> +	struct mfc_dev *mfc_dev = (struct mfc_dev *)mfc_dev_ptr;
> +	struct mfc_port *fc_port = &mfc_dev->mfc_port[port];
> +	struct mfc_vhba *vhba, *tmp;
> +	int link_up;
> +
> +	switch (event) {
> +	case MLX4_DEV_EVENT_PORT_UP:
> +		link_up = 1;
> +		break;
> +	case MLX4_DEV_EVENT_CATASTROPHIC_ERROR:
> +	case MLX4_DEV_EVENT_PORT_DOWN:
> +		link_up = 0;
> +		break;
> +	case MLX4_DEV_EVENT_PORT_REINIT:
> +	default:
> +		return;
> +	}
> +
> +	list_for_each_entry_safe(vhba, tmp, &fc_port->vhba_list, list) {
> +		if (vhba->link_up != link_up) {
> +			vhba->link_up = link_up;
> +
> +			cancel_delayed_work(&vhba->delayed_work);
> +			dev_warn(&dev->pdev->dev,
> +				 "link %s on vhba %d port %d\n",
> +				 (link_up ? "UP" : "DOWN"), vhba->idx, port);
> +			queue_delayed_work(fc_port->async_wq,
> +					   &vhba->delayed_work,
> +					   MFC_ASYNC_DELAY);
> +		}
> +	}
> +}
> +
> +static int mfc_register_netdev(struct net_device *netdev, int vlan_id, int prio)
> +{
> +	struct mfc_vhba *vhba;
> +	struct mlx4_dev *dev;
> +	int port;
> +	struct mfc_dev *mfc_dev;
> +	struct net_device *tmp_netdev, *query_netdev;
> +	int err;
> +	unsigned long flags;
> +	u64 wwn, wwpn, wwnn;
> +	int found;
> +
> +	vhba = find_vhba_for_netdev(netdev);
> +	if (vhba) {
> +		dev_info(vhba->mfc_port->mfc_dev->dma_dev,
> +			 "warning: already got vhba for %s. skipping\n",
> +			 netdev->name);
> +		return 0;
> +	}
> +
> +	tmp_netdev = (netdev->priv_flags & IFF_802_1Q_VLAN) ?
> +		     vlan_dev_real_dev(netdev) : netdev;
> +
> +	spin_lock_irqsave(&mfc_dev_list_lock, flags);
> +	list_for_each_entry(mfc_dev, &mfc_dev_list, list) {
> +		dev = mfc_dev->dev;
> +		for (port = 1; port <= dev->caps.num_ports; ++port) {
> +			query_netdev = mlx4_get_prot_dev(dev, MLX4_PROT_EN,
> +							 port);
> +			if (query_netdev == tmp_netdev) {
> +				found = 1;
> +				goto unlock;
> +			}
> +		}
> +	}
> +unlock:
> +	spin_unlock_irqrestore(&mfc_dev_list_lock, flags);
> +
> +	if (!found) {
> +		printk(KERN_ERR PFX "%s does not belong to mlx4_en.\n",
> +		       netdev->name);
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	dev_info(&dev->pdev->dev,
> +		 "%s belongs to mlx4_en. port=%d\n", netdev->name, port);
> +
> +	wwn = mfc_dev->dev->caps.def_mac[port];
> +	wwnn = wwn | ((u64) 0x10 << 56);
> +	wwpn = wwn | ((u64) 0x20 << 56);
> +
> +	err = mfc_create_vhba(&mfc_dev->mfc_port[port], netdev->mtu, vlan_id,
> +			      prio, -1, 0, 0, 0, netdev, netdev->name,
> +			      0, NULL, NET_ETH, wwpn, wwnn);
> +	if (err)
> +		dev_err(&dev->pdev->dev,
> +			"Could not create vhba for net device %s vlan %d\n",
> +			netdev->name, vlan_id);
> +out:
> +	return err;
> +}
> +
> +static int mfc_unregister_netdev(struct net_device *netdev)
> +{
> +	struct mfc_vhba *vhba;
> +
> +	vhba = find_vhba_for_netdev(netdev);
> +	if (!vhba) {
> +		printk(KERN_ERR PFX "No vhba for %s. skipping.\n",
> +		       netdev->name);
> +		return 0;
> +	}
> +
> +	mfc_remove_vhba(vhba);
> +	return 0;
> +}
> +
> +static struct mlx4_interface mfc_interface = {
> +	.add = mfc_add_dev,
> +	.remove = mfc_remove_dev,
> +	.event = mfc_async_event
> +};
> +
> +static void trimstr(char *str, int len)
> +{
> +	char *cp = str + len;
> +	while (--cp >= str && *cp == '\n')
> +		*cp = '\0';
> +}
> +
> +static ssize_t mfc_sys_destroy(struct class *cl, struct class_attribute *attr,
> +			       const char *buf, size_t count)
> +{
> +	char ifname[IFNAMSIZ];
> +	struct net_device *netdev = NULL;
> +
> +	strncpy(ifname, buf, sizeof(ifname));
> +	trimstr(ifname, strlen(ifname));
> +
> +	netdev = dev_get_by_name(&init_net, ifname);
> +	if (!netdev) {
> +		printk(KERN_ERR "Couldn't get a network device for '%s'",
> +		       ifname);
> +		goto out;
> +	}
> +
> +	mfc_unregister_netdev(netdev);
> +
> +out:
> +	if (netdev)
> +		dev_put(netdev);
> +	return count;
> +}
> +
> +static CLASS_ATTR(destroy, 0222, NULL, mfc_sys_destroy);
> +
> +static ssize_t mfc_sys_create(struct class *cl, struct class_attribute *attr,
> +			      const char *buf, size_t count)
> +{
> +	char ifname[IFNAMSIZ + 1];
> +	char *ch;
> +	char test;
> +	int cnt = 0;
> +	int vlan_id = -1;
> +	int prio = 0;
> +	struct net_device *netdev = NULL;
> +
> +	strncpy(ifname, buf, sizeof(ifname));

This doesn't guarantee a terminated string.
You might want to do:

	ifname[sizeof(ifname) - 1] = '\0';

to force the end.

Also, your optional arguments won't fit if the specified interface name
is already IFNAMSIZ long.

I think adding comma separated args is fine, but maybe they should
be of the form name=value and fcoe can use that method, too.
We could putthe arg parsing somewhere shared like libfcoe.

> +	trimstr(ifname, strlen(ifname));
> +
> +	ch = strchr(ifname, ',');
> +	if (ch) {
> +		*ch = '\0';
> +		cnt = sscanf(ch + 1, "%d%c", &prio, &test);
> +		if (cnt != 1 || prio < 0 || prio > 7)
> +			prio = 0;
> +	}
> +
> +	netdev = dev_get_by_name(&init_net, ifname);
> +	if (!netdev) {
> +		printk(KERN_ERR "Couldn't get a network device for '%s'\n",
> +		       ifname);
> +		goto out;

This should return an error, not just return count.  Otherwise the user
gets no indication unless they're looking at the console log.

> +	}
> +	if (netdev->priv_flags & IFF_802_1Q_VLAN) {
> +		vlan_id = vlan_dev_vlan_id(netdev);
> +		printk(KERN_INFO PFX "vlan id %d prio %d\n", vlan_id, prio);
> +		if (vlan_id < 0)
> +			goto out;

Same here.

> +	}
> +
> +	mfc_register_netdev(netdev, vlan_id, prio);
> +
> +out:
> +	if (netdev)
> +		dev_put(netdev);
> +	return count;
> +}
> +
> +static CLASS_ATTR(create, 0222, NULL, mfc_sys_create);

<snip>

	Cheers,
	Joe
