From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [patch] fcoe: use kfree_skb() to free an skb
Date: Thu, 4 Aug 2016 10:12:28 +0200
Message-ID: <20160804081228.ie7yuhi37bjlatrw@c203.arch.suse.de>
References: <20160804052756.GH775@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160804052756.GH775@mwanda>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, Johannes Thumshirn <jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 04, 2016 at 08:27:56AM +0300, Dan Carpenter wrote:
> This should be doing kfree_skb() instead of kfree().
> =

> Fixes: 9a6cf881df02 ('fcoe: implement FIP VLAN responder')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> =

> diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
> index a569c65..dcf3653 100644
> --- a/drivers/scsi/fcoe/fcoe_ctlr.c
> +++ b/drivers/scsi/fcoe/fcoe_ctlr.c
> @@ -2923,7 +2923,7 @@ static int fcoe_ctlr_vlan_recv(struct fcoe_ctlr *fi=
p, struct sk_buff *skb)
>  	mutex_unlock(&fip->ctlr_mutex);
>  =

>  drop:
> -	kfree(skb);
> +	kfree_skb(skb);
>  	return rc;
>  }
>  =

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Dan,

This was already sent by Wei Yongjun and is
https://patchwork.kernel.org/patch/9245273/. Should be queued in Martin's t=
ree
already.

Thanks,
	Johannes

-- =

Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
