From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 5/6] fcoe: implement FIP VLAN responder
Date: Mon, 4 Jul 2016 12:05:47 +0200
Message-ID: <20160704100547.fy7ima6fwkcs4aha@c203.arch.suse.de>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
 <1467620963-67047-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbcGDKFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2016 06:05:50 -0400
Content-Disposition: inline
In-Reply-To: <1467620963-67047-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, Jul 04, 2016 at 10:29:22AM +0200, Hannes Reinecke wrote:
> When running in VN2VN mode there is no central instance which
> would send out any FIP VLAN discovery notifications. So this
> patch adds a new sysfs attribute 'fip_vlan_responder' which
> will activate a FIP VLAN discovery responder.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

[...]

> +/**
> + * fcoe_ctlr_vlan_send() - Send a FIP VLAN Notification
> + * @fip: The FCoE controller
> + * @sub: sub-opcode for vlan notification or vn2vn vlan notification
> + * @dest: The destination Ethernet MAC address
> + * @min_len: minimum size of the Ethernet payload to be sent
> + */
> +static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *fip,
> +			      enum fip_vlan_subcode sub,
> +			      const u8 *dest)
> +{
> +	struct sk_buff *skb;
> +	struct fip_frame {
> +		struct ethhdr eth;
> +		struct fip_header fip;
> +		struct fip_mac_desc mac;
> +		struct fip_vlan_desc vlan;
> +	} __packed * frame;

Hmmm this is the 2nd time fip_frame is defined in  fcoe_ctlr.c. I'd pre=
fere
having the type definition somewhere else in this file and then use it =
in
fcoe_ctlr_vlan_send() and fcoe_ctlr_vn_send().

> +	size_t len;
> +	size_t dlen;
> +
> +	len =3D sizeof(*frame);
> +	dlen =3D sizeof(frame->mac) + sizeof(frame->vlan);
> +	len =3D max(len, sizeof(struct ethhdr));
> +
> +	skb =3D dev_alloc_skb(len);
> +	if (!skb)
> +		return;

dev_alloc_skb() uses GFP_ATOMIC so it's actually not unlikely to fail
so please return -ENOMEM here, just so the caller knows what happened.

> +
> +	LIBFCOE_FIP_DBG(fip, "fip %s vlan notification, vlan %d\n",
> +			fip->mode =3D=3D FIP_MODE_VN2VN ? "vn2vn" : "fcf",
> +			fip->lp->vlan);
> +
> +	frame =3D (struct fip_frame *)skb->data;
> +	memset(frame, 0, len);
> +	memcpy(frame->eth.h_dest, dest, ETH_ALEN);
> +
> +	memcpy(frame->eth.h_source, fip->ctl_src_addr, ETH_ALEN);
> +	frame->eth.h_proto =3D htons(ETH_P_FIP);
> +
> +	frame->fip.fip_ver =3D FIP_VER_ENCAPS(FIP_VER);
> +	frame->fip.fip_op =3D htons(FIP_OP_VLAN);
> +	frame->fip.fip_subcode =3D sub;
> +	frame->fip.fip_dl_len =3D htons(dlen / FIP_BPW);
> +
> +	frame->mac.fd_desc.fip_dtype =3D FIP_DT_MAC;
> +	frame->mac.fd_desc.fip_dlen =3D sizeof(frame->mac) / FIP_BPW;
> +	memcpy(frame->mac.fd_mac, fip->ctl_src_addr, ETH_ALEN);
> +
> +	frame->vlan.fd_desc.fip_dtype =3D FIP_DT_VLAN;
> +	frame->vlan.fd_desc.fip_dlen =3D sizeof(frame->vlan) / FIP_BPW;
> +	put_unaligned_be16(fip->lp->vlan, &frame->vlan.fd_vlan);
> +
> +	skb_put(skb, len);
> +	skb->protocol =3D htons(ETH_P_FIP);
> +	skb->priority =3D fip->priority;
> +	skb_reset_mac_header(skb);
> +	skb_reset_network_header(skb);
> +
> +	fip->send(fip, skb);
> +}

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
