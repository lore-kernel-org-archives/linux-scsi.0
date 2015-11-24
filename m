From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH 2/2] arcmsr: adds code for support areca new adapter
 ARC1203
Date: Tue, 24 Nov 2015 17:53:18 +0800
Message-ID: <1448358798.14472.3.camel@Centos6.3-64>
References: <1448353024.12861.56.camel@Centos6.3-64>
	 <1448357586.14504.12.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36675 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbbKXJxf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2015 04:53:35 -0500
Received: by pacdm15 with SMTP id dm15so17509365pac.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Nov 2015 01:53:35 -0800 (PST)
In-Reply-To: <1448357586.14504.12.camel@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: hch@infradead.org, thenzl@redhat.com, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de

On Tue, 2015-11-24 at 01:33 -0800, Joe Perches wrote:
> On Tue, 2015-11-24 at 16:17 +0800, Ching Huang wrote:
> > From: Ching Huang <ching2048@areca.com.tw>
> >=20
> > Support areca new PCIe to SATA RAID adapter ARC1203
>=20
> Why add the dma_free_coherent to an old data path?
> Is that a general bug fix that should be backported?

That's right. It's need to release the allocated resource for failed co=
ndition.
>=20
> btw: the printk above the dma_free_coherent use
>      shouldn't use a \ line continuation.
>      it adds undesired whitespace to the format.
>=20
> > diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr=
/arcmsr_hba.c
> []
> > @@ -2660,10 +2670,19 @@ static bool arcmsr_hbaB_get_config(struc
> >  	iop_firm_version =3D (char __iomem *)(=C2=AE->message_rwbuffer[17=
]);> 	> /*firm_version,17,68-83*/
> >  	iop_device_map =3D (char __iomem *)(=C2=AE->message_rwbuffer[21])=
;> 	> /*firm_version,21,84-99*/
> > =20
> > +	arcmsr_wait_firmware_ready(acb);
> > +	writel(ARCMSR_MESSAGE_START_DRIVER_MODE, reg->drv2iop_doorbell);
> > +	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> > +		printk(KERN_ERR "arcmsr%d: can't set driver mode.\n", acb->host-=
>host_no);
> > +		goto gcfg1;
> > +	}
> >  	writel(ARCMSR_MESSAGE_GET_CONFIG, reg->drv2iop_doorbell);
> >  	if (!arcmsr_hbaB_wait_msgint_ready(acb)) {
> >  		printk(KERN_NOTICE "arcmsr%d: wait 'get adapter firmware \
> >  			miscellaneous data' timeout \n", acb->host->host_no);
> > +gcfg1:
> > +		dma_free_coherent(&acb->pdev->dev, acb->roundup_ccbsize,
> > +			acb->dma_coherent2, acb->dma_coherent_handle2);
> >  		return false;
> >  	}
> >  	count =3D 8;
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
