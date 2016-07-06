From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v3 2/2] libata-scsi: avoid repeated calculation of number
 of TRIM ranges
Date: Thu, 7 Jul 2016 00:47:27 +0800
Message-ID: <CAGnHSEkEN-bgfiGbxn=Lp1C5Dk=4TsWzUwk4SaDqrfN5Ee7fgg@mail.gmail.com>
References: <577d3583.46c0620a.b8b1b.ffff9a06@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <577d3583.46c0620a.b8b1b.ffff9a06@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Oops I missed the block limit VPD this time. Will send a v4.

On 7 July 2016 at 00:44,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> Currently libata statically allows only 1-block (512-byte) payload
> for each TRIM command. Each payload can carry 64 TRIM ranges since
> each range requires 8 bytes.
>
> It is silly to keep doing the calculation (512 / 8) in different
> places. Hence, define the new ATA_MAX_TRIM_RNUM for the result.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index a1f061a..05a5f44 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3306,8 +3306,8 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>
>         buf = page_address(sg_page(scsi_sglist(scmd)));
>
> -       if (n_block <= 65535 * 512 / 8)
> -               size = ata_set_lba_range_entries(buf, 512, block, n_block);
> +       if (n_block <= 65535 * ATA_MAX_TRIM_RNUM)
> +               size = ata_set_lba_range_entries(buf, ATA_MAX_TRIM_RNUM, block, n_block);
>         else
>                 goto invalid_fld;
>
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 99346be..ce59500 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -48,6 +48,7 @@ enum {
>         ATA_MAX_SECTORS_1024    = 1024,
>         ATA_MAX_SECTORS_LBA48   = 65535,/* TODO: 65536? */
>         ATA_MAX_SECTORS_TAPE    = 65535,
> +       ATA_MAX_TRIM_RNUM       = 64,   /* 512-byte payload / (6-byte LBA + 2-byte range per entry) */
>
>         ATA_ID_WORDS            = 256,
>         ATA_ID_CONFIG           = 0,
> @@ -1071,7 +1072,7 @@ static inline unsigned ata_set_lba_range_entries(void *_buffer,
>         __le64 *buffer = _buffer;
>         unsigned i = 0, used_bytes;
>
> -       while (i < buf_size / 8 ) { /* 6-byte LBA + 2-byte range per entry */
> +       while (i < buf_size) {
>                 u64 entry = sector |
>                         ((u64)(count > 0xffff ? 0xffff : count) << 48);
>                 buffer[i++] = __cpu_to_le64(entry);
> --
> 2.9.0
>
