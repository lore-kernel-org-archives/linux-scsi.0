From: Shaun Tancheff <shaun@tancheff.com>
Subject: Re: [RFC] libata-scsi: make sure Maximum Write Same Length is not too large
Date: Thu, 11 Aug 2016 12:04:34 -0500
Message-ID: <CAJ48U8Wan45qaE2cSanyxdy5xppDwiFWZBRs-WDOyUuDgt4-zw@mail.gmail.com>
References: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: tj@kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 11, 2016 at 3:26 AM,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> Currently we advertise Maximum Write Same Length based on the
> maximum number of sectors that one-block TRIM payload can cover.
> The field are used to derived discard_max_bytes and
> write_same_max_bytes limits in the block layer, which currently can
> at max be 0xffffffff (32-bit).
>
> However, with a AF 4Kn drive, the derived limits would be 65535 *
> 64 * 4096 = 0x3fffc0000 (34-bit). Therefore, we now devide
> ATA_MAX_TRIM_RNUM with (logical sector size / 512), so that the
> derived limits will not overflow.
>
> The limits are now also consistent among drives with different
> logical sector sizes. (Although that may or may not be what we
> want ultimately when the SCSI / block layer allows larger
> representation in the future.)
>
> Although 4Kn ATA SSDs may not be a thing on the market yet, this
> patch is necessary for forthcoming SCT Write Same translation
> support, which could be available on traditional HDDs where 4Kn is
> already a thing. Also it should not change the current behavior on
> drives with 512-byte logical sectors.
>
> Note: this patch is not about AF 512e drives.
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index be9c76c..dcadcaf 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2295,6 +2295,7 @@ static unsigned int ata_scsiop_inq_89(struct ata_scsi_args *args, u8 *rbuf)
>  static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
>  {
>         u16 min_io_sectors;
> +       u32 sector_size;
>
>         rbuf[1] = 0xb0;
>         rbuf[3] = 0x3c;         /* required VPD size with unmap support */
> @@ -2309,17 +2310,27 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
>         min_io_sectors = 1 << ata_id_log2_per_physical_sector(args->id);
>         put_unaligned_be16(min_io_sectors, &rbuf[6]);
>
> -       /*
> -        * Optimal unmap granularity.
> -        *
> -        * The ATA spec doesn't even know about a granularity or alignment
> -        * for the TRIM command.  We can leave away most of the unmap related
> -        * VPD page entries, but we have specifify a granularity to signal
> -        * that we support some form of unmap - in thise case via WRITE SAME
> -        * with the unmap bit set.
> -        */
> +       sector_size = ata_id_logical_sector_size(args->id);
>         if (ata_id_has_trim(args->id)) {
> -               put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM, &rbuf[36]);
> +               /*
> +                * Maximum write same length.
> +                *
> +                * Avoid overflow in discard_max_bytes and write_same_max_bytes
> +                * with AF 4Kn drives. Also make them consistent among drives
> +                * with different logical sector sizes.
> +                */
> +               put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM /
> +                                  (sector_size / 512), &rbuf[36]);

I think the existing fixups in sd_setup_discard_cmnd() and
sd_setup_write_same_cmnd()
are 'doing the right thing'.

If I understand the stack correctly:

libata-scsi.c (and sd.c) both report a maximum in terms of 512 byte sectors.
The upper layer stack works (mostly) on a mix of bytes and 512 byte sectors
agnostic of the underlying hardware ... mostly. There are some bits in the
files systems and block layer that are honoring the logical block size being
larger 512 bytes as all I/O being generated are multiples of the logical block
size as per block device's request_queue / queue_limits.

So regardless of a 4Kn device being able to handle an 8x larger I/O as per
the logical sector being bigger that's basically ignored, for convenience.

In the scsi upper layer as the command are being setup the shift from
512 to 'sector_size' is handled to the number of device sectors is
matched up to the request:

    sector >>= ilog2(sdp->sector_size) - 9;
    nr_sectors >>= ilog2(sdp->sector_size) - 9;

So if you correctly report number of logical sectors here you break
the 'fix' in sd.c

At least that is my understanding.

> +
> +               /*
> +                * Optimal unmap granularity.
> +                *
> +                * The ATA spec doesn't even know about a granularity or alignment
> +                * for the TRIM command.  We can leave away most of the unmap related
> +                * VPD page entries, but we have specifify a granularity to signal
> +                * that we support some form of unmap - in thise case via WRITE SAME
> +                * with the unmap bit set.
> +                */
>                 put_unaligned_be32(1, &rbuf[28]);
>         }
>
> --
> 2.9.2
>

Regards,
Shaun
