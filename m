From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Wed, 24 Jun 2015 20:46:02 +0800
Message-ID: <CAGnHSEk_PoY=UQXrcEeBVpWBJApsUcySKSRnHuLM5vOdC429Eg@mail.gmail.com>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
	<CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
	<CAGnHSEnBvgWKw6g=c4vpCNEfpdh_45orz5JcSmfM7jadxjpxzQ@mail.gmail.com>
	<CAGnHSEnLACL6XisaFn3axRETAD3CjOa7fGrHKR7s6GOroQXkew@mail.gmail.com>
	<yq1616f796w.fsf@sermon.lab.mkp.net>
	<CAGnHSEn4EPC_RHTJXtvFC8dj8L+aDd_pRvSsDWNaqHz3Tdxj5w@mail.gmail.com>
	<yq1bng65te8.fsf@sermon.lab.mkp.net>
	<CAGnHSEm89yFPPTVUtbk1s84wanKK6RTY5hdZCMdbw+a+vwecDA@mail.gmail.com>
	<yq1mvzq4at7.fsf@sermon.lab.mkp.net>
	<CAGnHSEkF+uXh2=wpq9dwjK8_NrjF5kqcasXeuCF_=TONu6Q7Cw@mail.gmail.com>
	<yq1egl246yd.fsf@sermon.lab.mkp.net>
	<CAGnHSEnJ=_NV8Ed_=Ykr+30C+YSLFDPzyzeSY9b4p6pyaNOE4A@mail.gmail.com>
	<yq1616d4xxe.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq1616d4xxe.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

To be honest I don't think this patch should get in as well. First of
all it wouldn't really solve problem for all devices which have
different limits. Secondly I doubt it's related to Deterministic Zero
AT ALL. (For one the SanDisk drive I have shows Deterministic Zero,
still it behaves similarly as the Intel drive.) IHMO adding "switch"
base on characteristics which is uncertain to be / not at all relevant
is the worst thing to do ever. (Yeah I recall how Intel "follows"
HDMI/DP color range spec senselessly again.)

The only patching which would really mean something is to allow user
to configure blocks per range and ranges per command, so that for
users can tune kernel TRIM per device if they really want to, while
leaving the "safe default" intact.

However I am really curious how the drives "blow up" on less blocks
per range. Isn't that even more of a firmware bug than the problem I
have? If they blow up even with single range with less then 65535
blocks addressed, wouldn't they blow up anytime if they do filesystem
TRIM?

On 24 June 2015 at 10:55, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:
>
> Tom> total untrimmed sectors: (310635 - 1 - 2410) / 32 = 9632 total
> Tom> ranges: (43 GiB * (1024 ^ 3) / 512) / 65535 ~= 1376 average
> Tom> untrimmed sectors per range: (9632 / 1376) = 7 = (65535 % 8)
>
> Every type of drive has its own internal restrictions. Unless the drive
> guarantees zero after TRIM it is perfectly normal for heads, tails or
> random pieces in-between to be left untouched.
>
> I am surprised that the common case of contiguous range entries was not
> handled properly by your drive. Most of them deal with that just fine
> (regardless of their internal granularity and alignment constraints). It
> is normally only the partial block tracking between command invocations
> that causes grief.
>
> In any case. Unless discard_zeroes_data is 1 (and that requires
> guarantees above and beyond what can be discovered via the ATA Command
> Set) all bets are off wrt. dependable behavior.
>
> The code below is an untested proof of concept to see what it would take
> to alleviate your particular issue. I am, however, not at all convinced
> that introducing such a change is worth the risk. I know of at least a
> couple of devices that would blow up as a result of this patch...
>
> --
> Martin K. Petersen      Oracle Linux Engineering
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 3131adcc1f87..9c270a303f0b 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2238,8 +2238,24 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
>          * with the unmap bit set.
>          */
>         if (ata_id_has_trim(args->id)) {
> -               put_unaligned_be64(65535 * 512 / 8, &rbuf[36]);
> -               put_unaligned_be32(1, &rbuf[28]);
> +               /*
> +                * If the drive supports reliable zero after trim we set
> +                * the granularity to 1 and the blocks per range to
> +                * 0xffff. Otherwise we set set the granularity to 8 and
> +                * restrict the blocks per range to 0xfff8. This is done
> +                * to accommodate older drives which prefer 4K-alignment.
> +                */
> +
> +               if (ata_id_has_zero_after_trim(args->id) &&
> +                   args->dev->horkage & ATA_HORKAGE_ZERO_AFTER_TRIM) {
> +                       put_unaligned_be64(ATA_MAX_TRIM_RANGE * 512 / 8,
> +                                          &rbuf[36]);
> +                       put_unaligned_be32(1, &rbuf[28]);
> +               } else {
> +                       put_unaligned_be64(ATA_ALIGNED_TRIM_RANGE * 512 / 8,
> +                                          &rbuf[36]);
> +                       put_unaligned_be32(8, &rbuf[28]);
> +               }
>         }
>
>         return 0;
> @@ -3168,7 +3184,14 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
>                 goto invalid_fld;
>
>         buf = page_address(sg_page(scsi_sglist(scmd)));
> -       size = ata_set_lba_range_entries(buf, 512, block, n_block);
> +
> +       if (ata_id_has_zero_after_trim(dev->id) &&
> +           dev->horkage & ATA_HORKAGE_ZERO_AFTER_TRIM)
> +               size = ata_set_lba_range_entries(buf, 512, block, n_block,
> +                                                ATA_MAX_TRIM_RANGE);
> +       else
> +               size = ata_set_lba_range_entries(buf, 512, block, n_block,
> +                                                ATA_ALIGNED_TRIM_RANGE);
>
>         if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
>                 /* Newer devices support queued TRIM commands */
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index fed36418dd1c..8a17fa22cdbe 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -47,6 +47,8 @@ enum {
>         ATA_MAX_SECTORS         = 256,
>         ATA_MAX_SECTORS_LBA48   = 65535,/* TODO: 65536? */
>         ATA_MAX_SECTORS_TAPE    = 65535,
> +       ATA_MAX_TRIM_RANGE      = 0xffff,
> +       ATA_ALIGNED_TRIM_RANGE  = 0xfff8,
>
>         ATA_ID_WORDS            = 256,
>         ATA_ID_CONFIG           = 0,
> @@ -1012,19 +1014,20 @@ static inline void ata_id_to_hd_driveid(u16 *id)
>   * TO NV CACHE PINNED SET.
>   */
>  static inline unsigned ata_set_lba_range_entries(void *_buffer,
> -               unsigned buf_size, u64 sector, unsigned long count)
> +               unsigned buf_size, u64 sector, unsigned long count,
> +               u16 bpe)
>  {
>         __le64 *buffer = _buffer;
>         unsigned i = 0, used_bytes;
>
>         while (i < buf_size / 8 ) { /* 6-byte LBA + 2-byte range per entry */
>                 u64 entry = sector |
> -                       ((u64)(count > 0xffff ? 0xffff : count) << 48);
> +                       ((u64)(count > bpe ? bpe : count) << 48);
>                 buffer[i++] = __cpu_to_le64(entry);
> -               if (count <= 0xffff)
> +               if (count <= bpe)
>                         break;
> -               count -= 0xffff;
> -               sector += 0xffff;
> +               count -= bpe;
> +               sector += bpe;
>         }
>
>         used_bytes = ALIGN(i * 8, 512);
