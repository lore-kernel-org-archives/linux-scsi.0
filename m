From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [Patch V2 4/9] [SCSI] aacraid: Enable 64-bit write to controller
  register
Date: Thu, 11 Jun 2015 12:01:43 +0200
Message-ID: <20150611100143.GA2865@c203.arch.suse.de>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-6-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbbFKKBy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jun 2015 06:01:54 -0400
Content-Disposition: inline
In-Reply-To: <1433986951-9033-6-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On Wed, Jun 10, 2015 at 06:42:26PM -0700, rajinikanth.pandurangan@pmcs.=
com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
>=20
> Description:
>         If writeq() not supported, then do atomic two 32bit write
>=20
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.=
com>
> ---
>  drivers/scsi/aacraid/aacraid.h  |  9 +++++++++
>  drivers/scsi/aacraid/comminit.c |  1 +
>  drivers/scsi/aacraid/src.c      | 12 ++++++++++--
>  3 files changed, 20 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aa=
craid.h
> index 62b0999..e54f597 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -844,6 +844,10 @@ struct src_registers {
>  						&((AEP)->regs.src.bar0->CSR))
>  #define src_writel(AEP, CSR, value)	writel(value, \
>  						&((AEP)->regs.src.bar0->CSR))
> +#if defined(writeq)
> +#define	src_writeq(AEP, CSR, value)	writeq(value, \
> +						&((AEP)->regs.src.bar0->CSR))
> +#endif
> =20
>  #define SRC_ODR_SHIFT		12
>  #define SRC_IDR_SHIFT		9
> @@ -1163,6 +1167,11 @@ struct aac_dev
>  	struct fsa_dev_info	*fsa_dev;
>  	struct task_struct	*thread;
>  	int			cardtype;
> +	/*
> +	 *This lock will protect the two 32-bit
> +	 *writes to the Inbound Queue
> +	 */
> +	spinlock_t		iq_lock;
> =20
>  	/*
>  	 *	The following is the device specific extension.
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/c=
omminit.c
> index e0a76d5..e4ff47e 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -424,6 +424,7 @@ struct aac_dev *aac_init_adapter(struct aac_dev *=
dev)
>  	dev->management_fib_count =3D 0;
>  	spin_lock_init(&dev->manage_lock);
>  	spin_lock_init(&dev->sync_lock);
> +	spin_lock_init(&dev->iq_lock);
>  	dev->max_fib_size =3D sizeof(struct hw_fib);
>  	dev->sg_tablesize =3D host->sg_tablesize =3D (dev->max_fib_size
>  		- sizeof(struct aac_fibhdr)
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index eb07b3d..1409a0b 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -447,6 +447,10 @@ static int aac_src_deliver_message(struct fib *f=
ib)
>  	u32 fibsize;
>  	dma_addr_t address;
>  	struct aac_fib_xporthdr *pFibX;
> +#if !defined(writeq)
> +	unsigned long flags;
> +#endif
> +
>  	u16 hdr_size =3D le16_to_cpu(fib->hw_fib_va->header.Size);
> =20
>  	atomic_inc(&q->numpending);
> @@ -511,10 +515,14 @@ static int aac_src_deliver_message(struct fib *=
fib)
>  			return -EINVAL;
>  		address |=3D fibsize;
>  	}
> -
> +#if defined(writeq)
> +	src_writeq(dev, MUnit.IQ_L, (u64)address);
> +#else
> +	spin_lock_irqsave(&fib->dev->iq_lock, flags);
>  	src_writel(dev, MUnit.IQ_H, upper_32_bits(address) & 0xffffffff);
>  	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
> -
> +	spin_unlock_irqrestore(&fib->dev->iq_lock, flags);
> +#endif
>  	return 0;
>  }

Why not make src_writeq() a wrapper over either writeq() or
spin_lock_irqsave(); src_writel() x2; spin_unlock_irqrestore(), dependi=
ng on
the presence of writeq?


> =20
> --=20
> 1.9.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
