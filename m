From: Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v5 2/3] libahci: Add support to handle HOST_IRQ_STAT as
 edge trigger latch.
Date: Sat, 9 May 2015 00:43:49 +0530
Message-ID: <CAOHikRA9uiqVcmN0x3CaBp7Pd9bAidfqL3UzSTC3hYESRnSdTQ@mail.gmail.com>
References: <1430853672-6227-1-git-send-email-stripathi@apm.com>
	<1430853672-6227-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1430853672-6227-3-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Olof Johansson <olof@lixom.net>, Tejun Heo <tj@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Langsdorf <mlangsdo@redhat.com>, Jon Masters <jcm@redhat.com>, patches <patches@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hi Tejun

On Wed, May 6, 2015 at 12:51 AM, Suman Tripathi <stripathi@apm.com> wrote:
>
> This patch adds the support to handle HOST_IRQ_STAT as edge trigger
> latch.
>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  drivers/ata/ahci.h    |  2 ++
>  drivers/ata/libahci.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
>
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 71262e0..f442960 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -238,6 +238,8 @@ enum {
>         AHCI_HFLAG_MULTI_MSI            = (1 << 16), /* multiple PCI MSIs */
>         AHCI_HFLAG_NO_DEVSLP            = (1 << 17), /* no device sleep */
>         AHCI_HFLAG_NO_FBS               = (1 << 18), /* no FBS */
> +       AHCI_HFLAG_EDGE_IRQ             = (1 << 19), /* HOST_IRQ_STAT behaves as
> +                                                       Edge Triggered */
>
>         /* ap->flags bits */
>
> diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
> index aa89c8e..1add5ba 100644
> --- a/drivers/ata/libahci.c
> +++ b/drivers/ata/libahci.c
> @@ -1853,6 +1853,43 @@ static u32 ahci_handle_port_intr(struct ata_host *host, u32 irq_masked)
>         return handled;
>  }
>
> +static irqreturn_t ahci_single_edge_irq_intr(int irq, void *dev_instance)
> +{
> +       struct ata_host *host = dev_instance;
> +       struct ahci_host_priv *hpriv;
> +       unsigned int rc = 0;
> +       void __iomem *mmio;
> +       u32 irq_stat, irq_masked;
> +
> +       VPRINTK("ENTER\n");
> +
> +       hpriv = host->private_data;
> +       mmio = hpriv->mmio;
> +
> +       /* sigh.  0xffffffff is a valid return from h/w */
> +       irq_stat = readl(mmio + HOST_IRQ_STAT);
> +       if (!irq_stat)
> +               return IRQ_NONE;
> +
> +       irq_masked = irq_stat & hpriv->port_map;
> +
> +       spin_lock(&host->lock);
> +
> +       /*
> +        * HOST_IRQ_STAT behaves as edge triggered latch meaning that
> +        * it should be cleared before all the port events are cleared.
> +        */
> +       writel(irq_stat, mmio + HOST_IRQ_STAT);
> +
> +       rc = ahci_handle_port_intr(host, irq_masked);
> +
> +       spin_unlock(&host->lock);
> +
> +       VPRINTK("EXIT\n");
> +
> +       return IRQ_RETVAL(rc);
> +}
> +
>  static irqreturn_t ahci_single_level_irq_intr(int irq, void *dev_instance)
>  {
>         struct ata_host *host = dev_instance;
> @@ -2495,6 +2532,9 @@ int ahci_host_activate(struct ata_host *host, int irq,
>
>         if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
>                 rc = ahci_host_activate_multi_irqs(host, irq, sht);
> +       else if (hpriv->flags & AHCI_HFLAG_EDGE_IRQ)
> +               rc = ata_host_activate(host, irq, ahci_single_edge_irq_intr,
> +                                      IRQF_SHARED, sht);
>         else
>                 rc = ata_host_activate(host, irq, ahci_single_level_irq_intr,
>                                        IRQF_SHARED, sht);
> --
> 1.8.2.1
>

Any comments on this version ??

-- 
Thanks,
with regards,
Suman Tripathi
