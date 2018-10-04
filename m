From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 4/7] mpt3sas: Convert logging uses with MPT3SAS_FMT and
 reply_q_name to %s:
Date: Thu, 4 Oct 2018 15:59:36 +0530
Message-ID: <CA+RiK66nSLgzqt4atCctiH+DkB=2Z=5RgsR_oT8NareCe1e+DQ@mail.gmail.com>
References: <cover.1537183087.git.joe@perches.com> <80a0b24fd5be85fcd87b92958691ab19484a4295.1537183088.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <80a0b24fd5be85fcd87b92958691ab19484a4295.1537183088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Please consider this patch as Acked-by: Suganath Prabu
<suganath-prabu.subramani@broadcom.com>

Thanks.
On Mon, Sep 17, 2018 at 8:31 PM Joe Perches <joe@perches.com> wrote:
>
> Convert the existing 2 uses to make the format and arguments
> matching more obvious.
>
> Miscellanea:
>
> o Move the word "enabled" into the format to trivially reduce object size
> o Remove unnecessary parentheses
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 5c6634b7ca74..386af6739867 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2705,7 +2705,7 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
>         r = request_irq(pci_irq_vector(pdev, index), _base_interrupt,
>                         IRQF_SHARED, reply_q->name, reply_q);
>         if (r) {
> -               pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
> +               pr_err("%s: unable to allocate interrupt %d!\n",
>                        reply_q->name, pci_irq_vector(pdev, index));
>                 kfree(reply_q);
>                 return -EBUSY;
> @@ -3034,10 +3034,10 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>         }
>
>         list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
> -               pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
> -                   reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X enabled" :
> -                   "IO-APIC enabled"),
> -                   pci_irq_vector(ioc->pdev, reply_q->msix_index));
> +               pr_info("%s: %s enabled: IRQ %d\n",
> +                       reply_q->name,
> +                       ioc->msix_enable ? "PCI-MSI-X" : "IO-APIC",
> +                       pci_irq_vector(ioc->pdev, reply_q->msix_index));
>
>         ioc_info(ioc, "iomem(%pap), mapped(0x%p), size(%d)\n",
>                  &chip_phys, ioc->chip, memap_sz);
> --
> 2.15.0
>
