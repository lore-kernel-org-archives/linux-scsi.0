From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH] scsi: pm8001: clean up structurally dead code when
 PM8001_USE_MSIX is defined
Date: Fri, 29 Mar 2019 09:16:23 +0100
Message-ID: <CAMGffE=F-NUsfiBpDTO=U_7vOaEQ3QeUQ1+pw4GiEs9WMNj-sg@mail.gmail.com>
References: <20190328234328.15860-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328234328.15860-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, lindar_liu <lindar_liu@usish.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 29, 2019 at 12:43 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> When macro PM8001_USE_MSIX is defined there are redundant dead code
> calls to pm8001_chip_intx_interrupt_{enable|disable}. Clean this up
> by compiling in the appropriate enable/disable handlers for the
> defined PM8001_USE_MSIX and undefined PM8001_USE_MSIX cases.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Thanks, Colin,
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index e4209091c1da..7d81246a432b 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -1204,6 +1204,7 @@ void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
>         }
>  }
>
> +#ifndef PM8001_USE_MSIX
>  /**
>   * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
>   * @pm8001_ha: our hba card information
> @@ -1225,6 +1226,8 @@ pm8001_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
>         pm8001_cw32(pm8001_ha, 0, MSGU_ODMR, ODMR_MASK_ALL);
>  }
>
> +#else
> +
>  /**
>   * pm8001_chip_msix_interrupt_enable - enable PM8001 chip interrupt
>   * @pm8001_ha: our hba card information
> @@ -1256,6 +1259,7 @@ pm8001_chip_msix_interrupt_disable(struct pm8001_hba_info *pm8001_ha,
>         msi_index += MSIX_TABLE_BASE;
>         pm8001_cw32(pm8001_ha, 0,  msi_index, MSIX_INTERRUPT_DISABLE);
>  }
> +#endif
>
>  /**
>   * pm8001_chip_interrupt_enable - enable PM8001 chip interrupt
> @@ -1266,10 +1270,9 @@ pm8001_chip_interrupt_enable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  {
>  #ifdef PM8001_USE_MSIX
>         pm8001_chip_msix_interrupt_enable(pm8001_ha, 0);
> -       return;
> -#endif
> +#else
>         pm8001_chip_intx_interrupt_enable(pm8001_ha);
> -
> +#endif
>  }
>
>  /**
> @@ -1281,10 +1284,9 @@ pm8001_chip_interrupt_disable(struct pm8001_hba_info *pm8001_ha, u8 vec)
>  {
>  #ifdef PM8001_USE_MSIX
>         pm8001_chip_msix_interrupt_disable(pm8001_ha, 0);
> -       return;
> -#endif
> +#else
>         pm8001_chip_intx_interrupt_disable(pm8001_ha);
> -
> +#endif
>  }
>
>  /**
> --
> 2.20.1
>


-- 
Jack Wang
Linux Kernel Developer

1&1 IONOS Cloud GmbH | Greifswalder Str. 207 | 10405 Berlin | Germany
Phone: +49 30 57700-8042 | Fax: +49 30 57700-8598
E-mail: jinpu.wang@cloud.ionos.com | Web: www.ionos.de


Head Office: Berlin, Germany
District Court Berlin Charlottenburg, Registration number: HRB 125506 B
Executive Management: Christoph Steffens, Matthias Steinberg, Achim Weiss

Member of United Internet

This e-mail may contain confidential and/or privileged information. If
you are not the intended recipient of this e-mail, you are hereby
notified that saving, distribution or use of the content of this
e-mail in any way is prohibited. If you have received this e-mail in
error, please notify the sender and delete the e-mail.
