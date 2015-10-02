From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] [SCSI] fnic: use kzalloc in fnic_fcoe_process_vlan_resp
Date: Fri, 02 Oct 2015 09:05:06 +0200
Message-ID: <mqd8u7ln42l.fsf@c203.arch.suse.de>
References: <1443729543-19362-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443729543-19362-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Thu, 1 Oct 2015 21:59:02 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> This saves a little .text and avoids the sizeof(...) style
> inconsistency.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/scsi/fnic/fnic_fcs.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fc=
s.c
> index bf0bbd42efb5..2d013076bfba 100644
> --- a/drivers/scsi/fnic/fnic_fcs.c
> +++ b/drivers/scsi/fnic/fnic_fcs.c
> @@ -415,15 +415,13 @@ static void fnic_fcoe_process_vlan_resp(struct =
fnic *fnic, struct sk_buff *skb)
>  			vid =3D ntohs(((struct fip_vlan_desc *)desc)->fd_vlan);
>  			shost_printk(KERN_INFO, fnic->lport->host,
>  				  "process_vlan_resp: FIP VLAN %d\n", vid);
> -			vlan =3D kmalloc(sizeof(*vlan),
> -							GFP_ATOMIC);
> +			vlan =3D kzalloc(sizeof(*vlan), GFP_ATOMIC);
>  			if (!vlan) {
>  				/* retry from timer */
>  				spin_unlock_irqrestore(&fnic->vlans_lock,
>  							flags);
>  				goto out;
>  			}
> -			memset(vlan, 0, sizeof(struct fcoe_vlan));
>  			vlan->vid =3D vid & 0x0fff;
>  			vlan->state =3D FIP_VLAN_AVAIL;
>  			list_add_tail(&vlan->list, &fnic->vlans);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
