From: Shaun Tancheff <shaun@tancheff.com>
Subject: Re: [PATCH] ata: do not hard code limit in ata_set_lba_range_entries()
Date: Mon, 22 Aug 2016 14:58:47 -0500
Message-ID: <CAJ48U8UsFFD=fb6WQEVAam9-9RajVjLNrgiKmXCXvkCFOg2JnQ@mail.gmail.com>
References: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <e35afc461c9a79f568f2bcd4ef2cd1e07fb50082.1471890326.git.tom.ty89@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 22, 2016 at 1:55 PM,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> In commit 5c79097a28c2 ("libata-scsi: reject WRITE SAME (16) with
> n_block that exceeds limit"), it is made sure that
> ata_set_lba_range_entries() will never be called with a request
> size (n_block) that is larger than the number of blocks that a
> 512-byte block TRIM payload can describe (65535 * 64 = 4194240),
> in addition to acknowlegding the SCSI/block layer with the same
> limit by advertising it as the Maximum Write Same Length.
>
> Therefore, it is unnecessary to hard code the same limit in
> ata_set_lba_range_entries() itself, which would only cost extra
> maintenance effort. Such effort can be noticed in, for example,
> commit 2983860c7668 ("libata-scsi: avoid repeated calculation of
> number of TRIM ranges").
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index be9c76c..9b74ecb 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3322,7 +3322,7 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>         buf = page_address(sg_page(scsi_sglist(scmd)));
>
>         if (n_block <= 65535 * ATA_MAX_TRIM_RNUM) {
> -               size = ata_set_lba_range_entries(buf, ATA_MAX_TRIM_RNUM, block, n_block);
> +               size = ata_set_lba_range_entries(buf, block, n_block);
>         } else {
>                 fp = 2;
>                 goto invalid_fld;
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index adbc812..5e2e9ad 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -1077,19 +1077,19 @@ static inline void ata_id_to_hd_driveid(u16 *id)
>   * TO NV CACHE PINNED SET.
>   */
>  static inline unsigned ata_set_lba_range_entries(void *_buffer,
> -               unsigned num, u64 sector, unsigned long count)
> +               u64 sector, unsigned long count)
>  {
>         __le64 *buffer = _buffer;
>         unsigned i = 0, used_bytes;
>
> -       while (i < num) {
> -               u64 entry = sector |
> -                       ((u64)(count > 0xffff ? 0xffff : count) << 48);
> +       while (count > 0) {
> +               u64 range, entry;
> +
> +               range = count > 0xffff ? 0xffff : count;
> +               entry = sector | (range << 48);
>                 buffer[i++] = __cpu_to_le64(entry);
> -               if (count <= 0xffff)
> -                       break;
> -               count -= 0xffff;
> -               sector += 0xffff;
> +               count -= range;
> +               sector += range;
>         }

I think the problem here is that I can now inject a buffer overflow
via SG_IO.

>         used_bytes = ALIGN(i * 8, 512);
> --
> 2.9.3
>
