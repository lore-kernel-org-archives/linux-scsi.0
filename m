From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] eata: remove driver_lock
Date: Tue, 05 Aug 2014 17:20:47 +0200
Message-ID: <53E0F64F.3050008@suse.de>
References: <1405326393-18559-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbaHEPU4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Aug 2014 11:20:56 -0400
In-Reply-To: <1405326393-18559-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 07/14/2014 10:26 AM, Christoph Hellwig wrote:
> port_detect is only called from the module_init routine and thus impl=
icitly
> serialized, so remove the driver lock which was held over potentially
> sleeping function calls.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reported-by: Arthur Marsh <arthur.marsh@internode.on.net>
> Tested-by: Arthur Marsh <arthur.marsh@internode.on.net>
> ---
>   drivers/scsi/eata.c | 9 ---------
>   1 file changed, 9 deletions(-)
>
> diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
> index 03372cf..980898e 100644
> --- a/drivers/scsi/eata.c
> +++ b/drivers/scsi/eata.c
> @@ -837,7 +837,6 @@ struct hostdata {
>   static struct Scsi_Host *sh[MAX_BOARDS];
>   static const char *driver_name =3D "EATA";
>   static char sha[MAX_BOARDS];
> -static DEFINE_SPINLOCK(driver_lock);
>
>   /* Initialize num_boards so that ihdlr can work while detect is in =
progress */
>   static unsigned int num_boards =3D MAX_BOARDS;
> @@ -1097,8 +1096,6 @@ static int port_detect(unsigned long port_base,=
 unsigned int j,
>   		goto fail;
>   	}
>
> -	spin_lock_irq(&driver_lock);
> -
>   	if (do_dma(port_base, 0, READ_CONFIG_PIO)) {
>   #if defined(DEBUG_DETECT)
>   		printk("%s: detect, do_dma failed at 0x%03lx.\n", name,
> @@ -1265,10 +1262,7 @@ static int port_detect(unsigned long port_base=
, unsigned int j,
>   	}
>   #endif
>
> -	spin_unlock_irq(&driver_lock);
>   	sh[j] =3D shost =3D scsi_register(tpnt, sizeof(struct hostdata));
> -	spin_lock_irq(&driver_lock);
> -
>   	if (shost =3D=3D NULL) {
>   		printk("%s: unable to register host, detaching.\n", name);
>   		goto freedma;
> @@ -1345,8 +1339,6 @@ static int port_detect(unsigned long port_base,=
 unsigned int j,
>   	else
>   		sprintf(dma_name, "DMA %u", dma_channel);
>
> -	spin_unlock_irq(&driver_lock);
> -
>   	for (i =3D 0; i < shost->can_queue; i++)
>   		ha->cp[i].cp_dma_addr =3D pci_map_single(ha->pdev,
>   							  &ha->cp[i],
> @@ -1439,7 +1431,6 @@ static int port_detect(unsigned long port_base,=
 unsigned int j,
>         freeirq:
>   	free_irq(irq, &sha[j]);
>         freelock:
> -	spin_unlock_irq(&driver_lock);
>   	release_region(port_base, REGION_SIZE);
>         fail:
>   	return 0;
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
