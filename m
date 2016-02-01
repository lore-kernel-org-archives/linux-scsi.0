From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 08/12] be2iscsi: Fix MCC WRB leak in open_connection
Date: Mon, 1 Feb 2016 12:45:43 +0100
Message-ID: <20160201114543.GH27969@c203.arch.suse.de>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
 <1454321571-16167-9-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641AbcBALpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 06:45:45 -0500
Content-Disposition: inline
In-Reply-To: <1454321571-16167-9-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu

On Mon, Feb 01, 2016 at 03:42:47PM +0530, Jitendra Bhivare wrote:
> In open with IP of unknown address family, only tag is freed and erro=
r
> returned. MCC WRB allocated for the operation is not freed.
>=20
> Added check for supported family of IP in the beginning before
> allocating the tag and WRB.
>=20
> Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be_mgmt.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/=
be_mgmt.c
> index 85044b8..ccac1d7 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -829,6 +829,13 @@ int mgmt_open_connection(struct beiscsi_hba *phb=
a,
>  	unsigned short cid =3D beiscsi_ep->ep_cid;
>  	struct be_sge *sge;
> =20
> +	if (dst_addr->sa_family !=3D PF_INET && dst_addr->sa_family !=3D PF=
_INET6) {
> +		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
> +			    "BG_%d : unknown addr family %d\n",
> +			    dst_addr->sa_family);
> +		return -EINVAL;
> +	}
> +
>  	phwi_ctrlr =3D phba->phwi_ctrlr;
>  	phwi_context =3D phwi_ctrlr->phwi_ctxt;
> =20
> @@ -868,7 +875,8 @@ int mgmt_open_connection(struct beiscsi_hba *phba=
,
>  		beiscsi_ep->dst_addr =3D daddr_in->sin_addr.s_addr;
>  		beiscsi_ep->dst_tcpport =3D ntohs(daddr_in->sin_port);
>  		beiscsi_ep->ip_type =3D BE2_IPV4;
> -	} else if (dst_addr->sa_family =3D=3D PF_INET6) {
> +	} else {
> +		/* else its PF_INET6 family */
>  		req->ip_address.ip_type =3D BE2_IPV6;
>  		memcpy(&req->ip_address.addr,
>  		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
> @@ -877,14 +885,6 @@ int mgmt_open_connection(struct beiscsi_hba *phb=
a,
>  		memcpy(&beiscsi_ep->dst6_addr,
>  		       &daddr_in6->sin6_addr.in6_u.u6_addr8, 16);
>  		beiscsi_ep->ip_type =3D BE2_IPV6;
> -	} else{
> -		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_CONFIG,
> -			    "BG_%d : unknown addr family %d\n",
> -			    dst_addr->sa_family);
> -		mutex_unlock(&ctrl->mbox_lock);
> -		free_mcc_tag(&phba->ctrl, tag);
> -		return -EINVAL;
> -
>  	}
>  	req->cid =3D cid;
>  	i =3D phba->nxt_cqid++;
> --=20
> 2.5.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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
