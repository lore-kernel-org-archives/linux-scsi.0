From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v2] mvsas: Generalize Marvell 9485 in pci_device_id
Date: Thu, 7 Apr 2016 21:36:07 +0300
Message-ID: <CAHp75Vd9JLXnPY1VNas7tD9QSzXQ4v-OQgTVNv4XOE++6dVDhA@mail.gmail.com>
References: <1460048767-5112-1-git-send-email-leonid.moiseichuk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460048767-5112-1-git-send-email-leonid.moiseichuk@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Leonid Moiseichuk <leonid.moiseichuk@gmail.com>
Cc: jejb@linux.vnet.ibm.com, yuxiangl@marvell.com, Wilfried.Weissmann@gmx.at, Dan Williams <dan.j.williams@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 7, 2016 at 8:06 PM, Leonid Moiseichuk
<leonid.moiseichuk@gmail.com> wrote:
> For generic subvendor has sense to use generic subdevice.
> If subdevice ID not equal to 0x9480/0x9485 mvsas will be not activated.
>
> Tested on ASUS P9A-I/C2550/SAS/4L which uses vendor-specific 1043:8635.

Minors below.

FWIW:
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

>
> Signed-off-by: Leonid Moiseichuk <leonid.moiseichuk@gmail.com>
> ---

Missed changelog vfrom v1 to v2.

>  drivers/scsi/mvsas/mv_init.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
>
> diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
> index c7c250519c4b..a6a4f09df0be 100644
> --- a/drivers/scsi/mvsas/mv_init.c
> +++ b/drivers/scsi/mvsas/mv_init.c
> @@ -704,24 +704,7 @@ static struct pci_device_id mvs_pci_table[] = {
>                 .class_mask     = 0,
>                 .driver_data    = chip_9445,
>         },
> -       {
> -               .vendor         = PCI_VENDOR_ID_MARVELL_EXT,
> -               .device         = 0x9485,
> -               .subvendor      = PCI_ANY_ID,
> -               .subdevice      = 0x9480,
> -               .class          = 0,
> -               .class_mask     = 0,
> -               .driver_data    = chip_9485,
> -       },
> -       {
> -               .vendor         = PCI_VENDOR_ID_MARVELL_EXT,
> -               .device         = 0x9485,
> -               .subvendor      = PCI_ANY_ID,
> -               .subdevice      = 0x9485,
> -               .class          = 0,
> -               .class_mask     = 0,
> -               .driver_data    = chip_9485,
> -       },
> +       { PCI_VDEVICE(MARVELL_EXT, 0x9485), chip_9485 },

+ commentary line?

... /* MARVELL bla-bla-bla */

>         { PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
>         { PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
>         { PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ RevoDrive3/zDriveR4 (exact model unknown) */
> --
> 2.8.0.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
With Best Regards,
Andy Shevchenko
