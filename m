From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 09/10] mlx4_fc: Implement fcoe/fcoib offload driver,
 fcoib initialization protocol driver
Date: Wed, 18 Aug 2010 10:10:39 -0700
Message-ID: <4C6C140F.3060501@mellanox.com>
References: <4C69B8D5.20908@mellanox.com> <4C6AC621.7000401@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C6AC621.7000401-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Eykholt <jeykholt-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux SCSI <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


> 
> <snip>
> 
> I skimmed through the patch and just noticed a few issues.  I didn't
> do anything like a full review.  I'm copying devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, although
> some of them have seen this on the linux-scsi list.
>

Thanks for your review and comments.

 
>> +static int mlx4_fip_recv(struct sk_buff *skb, struct net_device *dev,
>> +			 struct packet_type *ptype, struct net_device *orig_dev)
>> +{
>> +	struct mfc_vhba *vhba =
>> +	    container_of(ptype, struct mfc_vhba, fip_packet_type);
>> +	struct ethhdr *eh = eth_hdr(skb);
>> +
>> +	fcoe_ctlr_recv(&vhba->ctlr, skb);
>> +
>> +	/* XXX: This is ugly */
>> +	memcpy(vhba->dest_addr, eh->h_source, 6);
> 
> Not just ugly.  First of all, picking up the dest addr from the FIP packet
> source means you may be changing it each time you receive an advertisement
> from an FCF, whether its appropriate or not.
> 
> Also, the skb may have been freed by fcoe_ctlr_recv().  It is responsible
> for it being freed eventually and this could be done before it returns.
> Since eh points into the skb it is garbage at this point.
> 
> The gateway MAC address will be in vhba->ctlr.dest_addr.
> 

I clean this up on next revision.


>> +static void mlx4_fip_send(struct fcoe_ctlr *fip, struct sk_buff *skb)
>> +{
>> +	skb->dev = (struct net_device *)mlx4_from_ctlr(fip)->underdev;
>> +	dev_queue_xmit(skb);
>> +}
<snip>
>> +
>> +static void mfc_flogi_resp(struct fc_seq *seq, struct fc_frame *fp, void *arg)
>> +{
<snip>
>> +	mfc_update_src_mac(lport, mac);
>> +done:
>> +	fc_lport_flogi_resp(seq, fp, lport);
>> +}
<snip>
>> +static struct fc_seq *mfc_elsct_send(struct fc_lport *lport, u32 did,
>> +				     struct fc_frame *fp, unsigned int op,
>> +				     void (*resp) (struct fc_seq *,
>> +						   struct fc_frame *,
>> +						   void *), void *arg,
>> +						   u32 timeout)
>> +{
>> +	struct mfc_vhba *vhba = lport_priv(lport);
>> +	struct fcoe_ctlr *fip = &vhba->ctlr;
>> +	struct fc_frame_header *fh = fc_frame_header_get(fp);
>> +
>> +	switch (op) {
>> +	case ELS_FLOGI:
>> +	case ELS_FDISC:
>> +		return fc_elsct_send(lport, did, fp, op, mfc_flogi_resp,
>> +				     fip, timeout);
>> +	case ELS_LOGO:
>> +		/* only hook onto fabric logouts, not port logouts */
>> +		if (ntoh24(fh->fh_d_id) != FC_FID_FLOGI)
>> +			break;
>> +		return fc_elsct_send(lport, did, fp, op, mfc_logo_resp,
>> +				     lport, timeout);
>> +	}
>> +	return fc_elsct_send(lport, did, fp, op, resp, arg, timeout);
> 
> A better way to pick up the assigned MAC address after FLOGI succeeds
> is by providing a callback in the libfc_function_template for lport_set_port_id().
> 
> That gets a copy of the original frame and fcoe_ctlr_recv_flogi()
> can get the granted_mac address out of that for the non-FIP case.
> It also gets called at LOGO when the port_id is being set to 0.
> See how fnic does it.  That's cleaner than intercepting FLOGI and
> LOGO ELSes.  Also, the callback for set_mac_addr()
> should take care of the assigned MAC address.
> 
> I forget why fcoe.ko did it this way, and its OK for you to do this, too,
> but I think the fnic way is cleaner.
> 

I recently just synced up with latest libfc/libfcoe and used fcoe as example.
Thanks for pointing this out. I'll take a look at fnic way

>> +
>> +static ssize_t mfc_sys_create(struct class *cl, struct class_attribute *attr,
>> +			      const char *buf, size_t count)
>> +{
>> +	char ifname[IFNAMSIZ + 1];
>> +	char *ch;
>> +	char test;
>> +	int cnt = 0;
>> +	int vlan_id = -1;
>> +	int prio = 0;
>> +	struct net_device *netdev = NULL;
>> +
>> +	strncpy(ifname, buf, sizeof(ifname));
> 
> This doesn't guarantee a terminated string.
> You might want to do:
> 
> 	ifname[sizeof(ifname) - 1] = '\0';
> 
> to force the end.
> 
> Also, your optional arguments won't fit if the specified interface name
> is already IFNAMSIZ long.
> 
> I think adding comma separated args is fine, but maybe they should
> be of the form name=value and fcoe can use that method, too.
> We could putthe arg parsing somewhere shared like libfcoe.
>

The comma is for the priority associated particularly with that interface.
If openfc-dev can formalize the format, we adapt to it.
 

>> +
>> +	netdev = dev_get_by_name(&init_net, ifname);
>> +	if (!netdev) {
>> +		printk(KERN_ERR "Couldn't get a network device for '%s'\n",
>> +		       ifname);
>> +		goto out;
> 
> This should return an error, not just return count.  Otherwise the user
> gets no indication unless they're looking at the console log.
> 

Ok

>> +	}
>> +	if (netdev->priv_flags & IFF_802_1Q_VLAN) {
>> +		vlan_id = vlan_dev_vlan_id(netdev);
>> +		printk(KERN_INFO PFX "vlan id %d prio %d\n", vlan_id, prio);
>> +		if (vlan_id < 0)
>> +			goto out;
> 
> Same here.
> 
Ok
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
