From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/1] scsi: fcoe: return value of
 skb_linearize should be handled
Date: Wed, 7 Dec 2016 09:28:01 +0100
Message-ID: <20161207082801.GA3688@linux-x5ow.site>
References: <1481097600-25604-1-git-send-email-zhouzhouyi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481097600-25604-1-git-send-email-zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://lists.open-fcoe.org/mailman/options/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.open-fcoe.org/pipermail/fcoe-devel/>
List-Post: <mailto:fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://lists.open-fcoe.org/mailman/listinfo/fcoe-devel>,
 <mailto:fcoe-devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Errors-To: fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Sender: "fcoe-devel" <fcoe-devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
To: Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhouyi Zhou <yizhouzhou-6xnC4QlcT6v/PtFMR13I2A@public.gmane.org>, fcoe-devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, jth-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Zhouyi,
On Wed, Dec 07, 2016 at 04:00:00PM +0800, Zhouyi Zhou wrote:
> Return value of skb_linearize should be handled.
> =

> Signed-off-by: Zhouyi Zhou <yizhouzhou-6xnC4QlcT6v/PtFMR13I2A@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =

> ---
>  drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 6 ++++--
>  drivers/scsi/fcoe/fcoe.c          | 5 ++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> =

> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2=
fc_fcoe.c
> index f9ddb61..142f7e2 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> @@ -542,8 +542,10 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
>  		return;
>  	}
>  =

> -	if (skb_is_nonlinear(skb))
> -		skb_linearize(skb);
> +	if (skb_linearize(skb)) {
> +		kfree_skb(skb);
> +		return;
> +	}
>  	mac =3D eth_hdr(skb)->h_source;
>  	dest_mac =3D eth_hdr(skb)->h_dest;
>  =

> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 9bd41a3..4e3499c 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -1685,7 +1685,10 @@ static void fcoe_recv_frame(struct sk_buff *skb)
>  			skb->dev ? skb->dev->name : "<NULL>");
>  =

>  	port =3D lport_priv(lport);
> -	skb_linearize(skb); /* check for skb_is_nonlinear is within skb_lineari=
ze */
> +	if (skb_linearize(skb)) {
> +		kfree_skb(skb);
> +		return;
> +	}
>  =

>  	/*
>  	 * Frame length checks and setting up the header pointers
> -- =

> 1.9.1
> =

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'd personally prefer something like:

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 9bd41a3..bc6fa6c 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1673,8 +1673,7 @@ static void fcoe_recv_frame(struct sk_buff *skb)
        lport =3D fr->fr_dev;
        if (unlikely(!lport)) {
                FCOE_NETDEV_DBG(skb->dev, "NULL lport in skb\n");
-               kfree_skb(skb);
-               return;
+               goto free_skb;
        }
 =

        FCOE_NETDEV_DBG(skb->dev,
@@ -1685,8 +1684,8 @@ static void fcoe_recv_frame(struct sk_buff *skb)
                        skb->dev ? skb->dev->name : "<NULL>");
 =

        port =3D lport_priv(lport);
-       skb_linearize(skb); /* check for skb_is_nonlinear is within skb_lin=
earize */
-
+       if (skb_linearize(skb))
+               goto free_skb;
        /*
         * Frame length checks and setting up the header pointers
         * was done in fcoe_rcv already.
@@ -1732,6 +1731,7 @@ static void fcoe_recv_frame(struct sk_buff *skb)
 drop:
        stats->ErrorFrames++;
        put_cpu();
+free_skb:
        kfree_skb(skb);
 }


For bnx2fc as well if Chad agrees.

Thanks,
	Johannes

-- =

Johannes Thumshirn                                          Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
