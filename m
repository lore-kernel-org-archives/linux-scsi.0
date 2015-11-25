From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v3 2/5] arcmsr: fixes not release allocated resource
Date: Wed, 25 Nov 2015 13:00:06 +0100
Message-ID: <1448452806.2877.75.camel@suse.de>
References: <1448451683.4670.35.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448451683.4670.35.camel@Centos6.3-64>
Sender: linux-kernel-owner@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@lst.de, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-11-25 at 19:41 +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Releasing allocated resource if get configuration data failed.
>=20
> Signed-of-by: Ching Huang <ching2048@areca.com.tw>
>=20
> ---
>=20
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c
> b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-24 11:35:26.000000000
> +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2015-11-25 19:04:44.590970000
> +0800
> @@ -2664,7 +2664,7 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> =C2=A0		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
> =C2=A0			miscellaneous data' timeout \n", acb->host-
> >host_no);
> -		return false;
> +		goto err_free_dma;
> =C2=A0	}
> =C2=A0	count =3D 8;
> =C2=A0	while (count){
> @@ -2707,6 +2707,10 @@ static bool arcmsr_hbaB_get_config(struc
> =C2=A0	acb->firm_cfg_version =3D readl(&reg-
> >message_rwbuffer[25]);=C2=A0=C2=A0/*firm_cfg_version,25,100-103*/
> =C2=A0	/*firm_ide_channels,4,16-19*/
> =C2=A0	return true;
> +err_free_dma:
> +	dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
> +			acb->dma_coherent2, acb->dma_coherent_handle2);
> +	return false;
> =C2=A0}
> =C2=A0
> =C2=A0static bool arcmsr_hbaC_get_config(struct AdapterControlBlock *=
pACB)
>=20
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
