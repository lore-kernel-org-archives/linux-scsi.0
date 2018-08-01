From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] driver/scsi/pmcraid: Use pci_zalloc_consistent instead of pci_alloc_consistent+memset
Date: Wed, 1 Aug 2018 13:07:48 +0300
Message-ID: <CAHp75Vf=Mfhvq1==F=tXHf+2hA84+jPwHPNmFGmhxq_LrrERHw@mail.gmail.com>
References: <1533107309-7073-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533107309-7073-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Cc: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Aug 1, 2018 at 10:08 AM, zhong jiang <zhongjiang@huawei.com> wrote:
> Pci_alloc_consistent+memset is better than pci_alloc_consistent+memset,
> and it make the code concise

It should use dma_*alloc_*() functions directly. PCI ones are not for
new code AFAIK.

>
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
> ---
>  drivers/scsi/pmcraid.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index 4e86994..8a6facc 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -4736,11 +4736,9 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
>         buffer_size = HRRQ_ENTRY_SIZE * PMCRAID_MAX_CMD;
>
>         for (i = 0; i < pinstance->num_hrrq; i++) {
> -               pinstance->hrrq_start[i] =
> -                       pci_alloc_consistent(
> -                                       pinstance->pdev,
> -                                       buffer_size,
> -                                       &(pinstance->hrrq_start_bus_addr[i]));
> +               pinstance->hrrq_start[i] = pci_zalloc_consistent(pinstance->pdev,
> +                                                               buffer_size,
> +                                                               &(pinstance->hrrq_start_bus_addr[i]));
>
>                 if (!pinstance->hrrq_start[i]) {
>                         pmcraid_err("pci_alloc failed for hrrq vector : %d\n",
> @@ -4749,7 +4747,6 @@ static int pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
>                         return -ENOMEM;
>                 }
>
> -               memset(pinstance->hrrq_start[i], 0, buffer_size);
>                 pinstance->hrrq_curr[i] = pinstance->hrrq_start[i];
>                 pinstance->hrrq_end[i] =
>                         pinstance->hrrq_start[i] + PMCRAID_MAX_CMD - 1;
> --
> 1.7.12.4
>



-- 
With Best Regards,
Andy Shevchenko
