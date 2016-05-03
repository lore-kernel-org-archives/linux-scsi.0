From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/3] libata-scsi: Set CmdQue=1 when NCQ is enabled
Date: Tue, 3 May 2016 17:50:14 +0800
Message-ID: <CAGnHSEk_5C167fBkOk1gPwqLJ2sJn35nAfnJVb_ddNZvitV6xg@mail.gmail.com>
References: <5727b4e8.c923620a.641f4.17a2@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5727b4e8.c923620a.641f4.17a2@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Btw I wonder if the CmdQue bit should be statically set to 1 instead.
It is not specified in the SAT standard (as of SAT-4 Rev. 05a) that
the bit should be correlated to ATA NCQ. Neither does the kernel care
about the bit (or the 'queue_type' sysfs file), apparently. However,
it seems that there is still an advantage to have the bit set to 1
even when we, for example, need `libata.force=noncq` for some reason:

https://github.com/YanVugenfirer/kvm-guest-drivers-windows/issues/63#issuecomment-216480833

What do you guys think? Is there any concern (with rigid reasoning)
over setting the bit statically to 1?

On 3 May 2016 at 04:13,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=105931
>
> This might look trivial at first sight. However, it can be
> important to have the bit set accordingly when the device/SATL is
> SCSI-passthrough'd to a virtual machine with scsi-block in qemu:
>
> https://github.com/YanVugenfirer/kvm-guest-drivers-windows/issues/63#issuecomment-216199929
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 567859c..cd30f11 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2007,7 +2007,10 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
>                 0,
>                 0x5,    /* claim SPC-3 version compatibility */
>                 2,
> -               95 - 4
> +               95 - 4,
> +               0,
> +               0,
> +               0
>         };
>
>         VPRINTK("ENTER\n");
> @@ -2024,6 +2027,9 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
>                 hdr[2] = 0x6; /* ZBC is defined in SPC-4 */
>         }
>
> +       if (ata_ncq_enabled(args->dev))
> +               hdr[7] |= (1 << 1);
> +
>         memcpy(rbuf, hdr, sizeof(hdr));
>         memcpy(&rbuf[8], "ATA     ", 8);
>         ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
> --
> 2.8.2
>
