From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 2/5] arcmsr: fixes not release allocated resource
Date: Wed, 25 Nov 2015 13:05:17 +0100
Message-ID: <5655A3FD.5040202@suse.de>
References: <1448451683.4670.35.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448451683.4670.35.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jthumshirn@suse.de
Cc: hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 11/25/2015 12:41 PM, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Releasing allocated resource if get configuration data failed.
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/a=
rcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 11:35:26.000000000 =
+0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:04:44.590970000 =
+0800
> @@ -2664,7 +2664,7 @@ static bool arcmsr_hbaB_get_config(struc
>  	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
>  		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
>  			miscellaneous data' timeout \n", acb->host->host_no);
> -		return false;
> +		goto err_free_dma;
>  	}
>  	count =3D 8;
>  	while (count){
> @@ -2707,6 +2707,10 @@ static bool arcmsr_hbaB_get_config(struc
>  	acb->firm_cfg_version =3D readl(&reg->message_rwbuffer[25]);  /*fir=
m_cfg_version,25,100-103*/
>  	/*firm_ide_channels,4,16-19*/
>  	return true;
> +err_free_dma:
> +	dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
> +			acb->dma_coherent2, acb->dma_coherent_handle2);
> +	return false;
>  }
> =20
>  static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *pACB)
>=20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
