From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/2] arcmsr: adds code for support areca new adapter
 ARC1203
Date: Tue, 24 Nov 2015 01:33:06 -0800
Message-ID: <1448357586.14504.12.camel@perches.com>
References: <1448353024.12861.56.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:44928 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753620AbbKXJdL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 04:33:11 -0500
In-Reply-To: <1448353024.12861.56.camel@Centos6.3-64>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ching Huang <ching2048@areca.com.tw>, hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: hch@lst.de

On Tue, 2015-11-24 at 16:17 +0800, Ching Huang wrote:
> From: Ching Huang <ching2048@areca.com.tw>
>=20
> Support areca new PCIe to SATA RAID adapter ARC1203

Why add the dma_free_coherent to an old data path?
Is that a general bug fix that should be backported?

btw: the printk above the dma_free_coherent use
     shouldn't use a \ line continuation.
     it adds undesired whitespace to the format.

> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/a=
rcmsr_hba.c
[]
> @@ -2660,10 +2670,19 @@ static bool arcmsr_hbaB_get_config(struc
>  	iop_firm_version =3D (char __iomem *)(=AE->message_rwbuffer[17]);> =
	> /*firm_version,17,68-83*/
>  	iop_device_map =3D (char __iomem *)(=AE->message_rwbuffer[21]);> 	>=
 /*firm_version,21,84-99*/
> =20
> +	arcmsr_wait_firmware_ready(acb);
> +	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
> +	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> +		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb->host->h=
ost_no);
> +		goto gcfg1;
> +	}
>  	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
>  	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
>  		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
>  			miscellaneous data' timeout \n", acb->host->host_no);
> +gcfg1:
> +		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
> +			acb->dma_coherent2, acb->dma_coherent_handle2);
>  		return false;
>  	}
>  	count =3D 8;

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
