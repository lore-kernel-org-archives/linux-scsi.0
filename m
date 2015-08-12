From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2] fnic: check pci_map_single() return value
Date: Wed, 12 Aug 2015 15:33:30 +0200
Message-ID: <mqdmvxwk4wl.fsf@c203.arch.suse.de>
References: <1439385964-4599-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50312 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754429AbbHLNdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 09:33:32 -0400
In-Reply-To: <1439385964-4599-1-git-send-email-mlombard@redhat.com> (Maurizio
	Lombardi's message of "Wed, 12 Aug 2015 15:26:04 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, sramars@cisco.com, jbottomley@parallels.com

Hi Maurizio,

Sorry but it looks like you've forgotten one change in fnic_eth_send().

Maurizio Lombardi <mlombard@redhat.com> writes:

> the kernel prints some warnings when compiled with CONFIG_DMA_API_DEB=
UG.
> This is because the fnic driver doesn't check the return value of
> pci_map_single().
>
> [   11.942770] scsi host12: fnic
>  }

[..]
> =20
>  void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
> @@ -981,6 +993,7 @@ void fnic_eth_send(struct fcoe_ctlr *fip, struct =
sk_buff *skb)
>  	struct ethhdr *eth_hdr;
>  	struct vlan_ethhdr *vlan_hdr;
>  	unsigned long flags;
> +	int r;
> =20
>  	if (!fnic->vlan_hw_insert) {
>  		eth_hdr =3D (struct ethhdr *)skb_mac_header(skb);
> @@ -1003,6 +1016,13 @@ void fnic_eth_send(struct fcoe_ctlr *fip, stru=
ct sk_buff *skb)
> =20
>  	pa =3D pci_map_single(fnic->pdev, skb->data, skb->len, PCI_DMA_TODE=
VICE);
> =20
> +	r =3D pci_dma_mapping_error(fnic->pdev, pa);
> +	if (r) {
> +		printk(KERN_ERR "PCI mapping failed with error %d\n", r);
> +		kfree_skb(skb);
> +		return;
> +	}
> +
>  	spin_lock_irqsave(&fnic->wq_lock[0], flags);
>  	if (!vnic_wq_desc_avail(wq)) {
>  		pci_unmap_single(fnic->pdev, pa, skb->len, PCI_DMA_TODEVICE);
> @@ -1071,6 +1091,12 @@ static int fnic_send_frame(struct fnic *fnic, =
struct fc_frame *fp)
> =20
>  	pa =3D pci_map_single(fnic->pdev, eth_hdr, tot_len, PCI_DMA_TODEVIC=
E);
[..]

Otherwise:

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
