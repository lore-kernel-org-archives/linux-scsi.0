From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] pm80xx: Remove bogus address masking in pm8001_ioremap()
Date: Thu, 14 Apr 2016 14:22:44 +0200
Message-ID: <CAMGffEk=kRZ4QcpNTYsnMw90W0TwFjgwB_GcjOq4pg4DbsfSCg@mail.gmail.com>
References: <1460582816-12703-1-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460582816-12703-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: lindar_liu <lindar_liu@usish.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, pmchba@pmcs.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 13, 2016 at 11:26 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
>
> It is unclear what the original intent of the masking was, but it is
> clearly incorrect to truncate a physical address before calling
> ioremap().  On systems where there are valid physical address bits
> above bit-31 (arm64 for example) the result is an eventual OOPs when
> initializing the driver.
>
> Remove the bogus code to fix it.
>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 062ab34..6bd7bf4 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -418,8 +418,6 @@ static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
>                 if (pci_resource_flags(pdev, bar) & IORESOURCE_MEM) {
>                         pm8001_ha->io_mem[logicalBar].membase =
>                                 pci_resource_start(pdev, bar);
> -                       pm8001_ha->io_mem[logicalBar].membase &=
> -                               (u32)PCI_BASE_ADDRESS_MEM_MASK;
>                         pm8001_ha->io_mem[logicalBar].memsize =
>                                 pci_resource_len(pdev, bar);
>                         pm8001_ha->io_mem[logicalBar].memvirtaddr =
> --
> 1.8.3.1
>

Thanks, looks good to me.
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
