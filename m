From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/6] ibmvscsi: Use of_root to access OF device tree root
 node
Date: Thu, 4 Feb 2016 09:45:36 +0100
Message-ID: <20160204084536.GX27969@c203.arch.suse.de>
References: <1454542114-1797-1-git-send-email-tyreld@linux.vnet.ibm.com>
 <1454542114-1797-5-git-send-email-tyreld@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852AbcBDIpj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Feb 2016 03:45:39 -0500
Content-Disposition: inline
In-Reply-To: <1454542114-1797-5-git-send-email-tyreld@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, hare@suse.de

On Wed, Feb 03, 2016 at 05:28:32PM -0600, Tyrel Datwyler wrote:
> The root node of the OF device tree is exported as of_root. No need
> to look up the root by path name. Instead just get a reference
> directly via of_root.
>=20
> Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvscsi.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi=
/ibmvscsi.c
> index 7e51615..47cfe33 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -248,25 +248,23 @@ static void ibmvscsi_task(void *data)
> =20
>  static void gather_partition_info(void)
>  {
> -	struct device_node *rootdn;
> -
>  	const char *ppartition_name;
>  	const __be32 *p_number_ptr;
> =20
>  	/* Retrieve information about this partition */
> -	rootdn =3D of_find_node_by_path("/");
> -	if (!rootdn) {
> +	if (!of_root)
>  		return;
> -	}
> =20
> -	ppartition_name =3D of_get_property(rootdn, "ibm,partition-name", N=
ULL);
> +	of_node_get(of_root);
> +
> +	ppartition_name =3D of_get_property(of_root, "ibm,partition-name", =
NULL);
>  	if (ppartition_name)
>  		strncpy(partition_name, ppartition_name,
>  				sizeof(partition_name));
> -	p_number_ptr =3D of_get_property(rootdn, "ibm,partition-no", NULL);
> +	p_number_ptr =3D of_get_property(of_root, "ibm,partition-no", NULL)=
;
>  	if (p_number_ptr)
>  		partition_number =3D of_read_number(p_number_ptr, 1);
> -	of_node_put(rootdn);
> +	of_node_put(of_root);
>  }
> =20
>  static void set_adapter_info(struct ibmvscsi_host_data *hostdata)
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
