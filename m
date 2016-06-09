From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH] Add support for SCT Write Same
Date: Thu, 9 Jun 2016 01:32:21 -0500
Message-ID: <CAJVOszDbtwOpd=OtitFOUpzHaSRTHZcrSJ9uU_r_+8eEgUXnzw@mail.gmail.com>
References: <1465235890-15703-1-git-send-email-shaun@tancheff.com>
 <1465235890-15703-2-git-send-email-shaun@tancheff.com> <yq1bn3bjait.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1bn3bjait.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 8, 2016 at 10:39 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
> >>>>> "Shaun" == Shaun Tancheff <shaun@tancheff.com> writes:
>
> Shaun,
>
> Shaun> SATA drives may support write same via SCT. This is useful for
> Shaun> setting the drive contents to a specific pattern (0's).
>
> index 428c03e..c5c8424 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -52,6 +52,7 @@
>  #include <linux/slab.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/pr.h>
> +#include <linux/ata.h>
>  #include <asm/uaccess.h>
>  #include <asm/unaligned.h>
>
> No ATA stuff in sd.c, please.
>
>
> @@ -2761,24 +2762,26 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
>  {
>         struct scsi_device *sdev = sdkp->device;
>
> -       if (sdev->host->no_write_same) {
> -               sdev->no_write_same = 1;
> -
> -               return;
> -       }
> -
>         if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
> -               /* too large values might cause issues with arcmsr */
> -               int vpd_buf_len = 64;
> -
>                 sdev->no_report_opcodes = 1;
>
>                 /* Disable WRITE SAME if REPORT SUPPORTED OPERATION
>                  * CODES is unsupported and the device has an ATA
>                  * Information VPD page (SAT).
>                  */
>
> The above comment tells you how to enable WRITE SAME in libata's
> SCSI-ATA translation.
>
>
> -               if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
> +               if (!scsi_get_vpd_page(sdev, 0x89, buffer, SD_BUF_SIZE))
>
> That vpd_buf_len is intentional.



Got it. Looking at it again all of hacking here is not required.
Posting a cleaner v2 without this.

Thanks!

>
>
> --
> Martin K. Petersen      Oracle Linux Engineering




-- 
Shaun Tancheff
