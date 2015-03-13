From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] sd, mmc, virtio_blk, string_helpers: fix block size units
Date: Fri, 13 Mar 2015 11:07:52 +0100
Message-ID: <CAPDyKFqOeXKYH0ohqDTvXFu+0qyzHivg_Th888KcXFyahVP76Q@mail.gmail.com>
References: <1425610021.2169.86.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34860 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbbCMKHx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2015 06:07:53 -0400
Received: by qgfh3 with SMTP id h3so24610544qgf.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2015 03:07:52 -0700 (PDT)
In-Reply-To: <1425610021.2169.86.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mmc <linux-mmc@vger.kernel.org>, virtualization@lists.linux-foundation.org

On 6 March 2015 at 03:47, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> From: James Bottomley <JBottomley@Parallels.com>
>
> The current string_get_size() overflows when the device size goes over
> 2^64 bytes because the string helper routine computes the suffix from
> the size in bytes.  However, the entirety of Linux thinks in terms of
> blocks, not bytes, so this will artificially induce an overflow on very
> large devices.  Fix this by making the function string_get_size() take
> blocks and the block size instead of bytes.  This should allow us to
> keep working until the current SCSI standard overflows.
>
> Also fix virtio_blk and mmc (both of which were also artificially
> multiplying by the block size to pass a byte side to string_get_size()).
>
> The mathematics of this is pretty simple:  we're taking a product of
> size in blocks (S) and block size (B) and trying to re-express this in
> exponential form: S*B = R*N^E (where N, the exponent is either 1000 or
> 1024) and R < N.  Mathematically, S = RS*N^ES and B=RB*N^EB, so if RS*RB
> < N it's easy to see that S*B = RS*RB*N^(ES+EB).  However, if RS*BS > N,
> we can see that this can be re-expressed as RS*BS = R*N (where R =
> RS*BS/N < N) so the whole exponent becomes R*N^(ES+EB+1)
>
> Signed-off-by: James Bottomley <JBottomley@Parallels.com>

For the mmc parts;

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

Kind regards
Uffe

>
> ---
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index cdfbd21..26d2440 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -344,7 +344,7 @@ static void virtblk_config_changed_work(struct work_struct *work)
>         struct request_queue *q = vblk->disk->queue;
>         char cap_str_2[10], cap_str_10[10];
>         char *envp[] = { "RESIZE=1", NULL };
> -       u64 capacity, size;
> +       u64 capacity;
>
>         /* Host must always specify the capacity. */
>         virtio_cread(vdev, struct virtio_blk_config, capacity, &capacity);
> @@ -356,9 +356,10 @@ static void virtblk_config_changed_work(struct work_struct *work)
>                 capacity = (sector_t)-1;
>         }
>
> -       size = capacity * queue_logical_block_size(q);
> -       string_get_size(size, STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
> -       string_get_size(size, STRING_UNITS_10, cap_str_10, sizeof(cap_str_10));
> +       string_get_size(capacity, queue_logical_block_size(q),
> +                       STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
> +       string_get_size(capacity, queue_logical_block_size(q),
> +                       STRING_UNITS_10, cap_str_10, sizeof(cap_str_10));
>
>         dev_notice(&vdev->dev,
>                   "new size: %llu %d-byte logical blocks (%s/%s)\n",
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index c69afb5..2fc4269 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -2230,7 +2230,7 @@ static int mmc_blk_alloc_part(struct mmc_card *card,
>         part_md->part_type = part_type;
>         list_add(&part_md->part, &md->part);
>
> -       string_get_size((u64)get_capacity(part_md->disk) << 9, STRING_UNITS_2,
> +       string_get_size((u64)get_capacity(part_md->disk), 512, STRING_UNITS_2,
>                         cap_str, sizeof(cap_str));
>         pr_info("%s: %s %s partition %u %s\n",
>                part_md->disk->disk_name, mmc_card_id(card),
> @@ -2436,7 +2436,7 @@ static int mmc_blk_probe(struct device *dev)
>         if (IS_ERR(md))
>                 return PTR_ERR(md);
>
> -       string_get_size((u64)get_capacity(md->disk) << 9, STRING_UNITS_2,
> +       string_get_size((u64)get_capacity(md->disk), 512, STRING_UNITS_2,
>                         cap_str, sizeof(cap_str));
>         pr_info("%s: %s %s %s %s\n",
>                 md->disk->disk_name, mmc_card_id(card), mmc_card_name(card),
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6b78476..3c7fe4e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2235,11 +2235,11 @@ got_data:
>
>         {
>                 char cap_str_2[10], cap_str_10[10];
> -               u64 sz = (u64)sdkp->capacity << ilog2(sector_size);
>
> -               string_get_size(sz, STRING_UNITS_2, cap_str_2,
> -                               sizeof(cap_str_2));
> -               string_get_size(sz, STRING_UNITS_10, cap_str_10,
> +               string_get_size(sdkp->capacity, sector_size,
> +                               STRING_UNITS_2, cap_str_2, sizeof(cap_str_2));
> +               string_get_size(sdkp->capacity, sector_size,
> +                               STRING_UNITS_10, cap_str_10,
>                                 sizeof(cap_str_10));
>
>                 if (sdkp->first_scan || old_capacity != sdkp->capacity) {
> diff --git a/include/linux/string_helpers.h b/include/linux/string_helpers.h
> index 6575718..2633280 100644
> --- a/include/linux/string_helpers.h
> +++ b/include/linux/string_helpers.h
> @@ -10,7 +10,7 @@ enum string_size_units {
>         STRING_UNITS_2,         /* use binary powers of 2^10 */
>  };
>
> -void string_get_size(u64 size, enum string_size_units units,
> +void string_get_size(u64 size, u64 blk_size, enum string_size_units units,
>                      char *buf, int len);
>
>  #define UNESCAPE_SPACE         0x01
> diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> index 8f8c441..6ac8d5a 100644
> --- a/lib/string_helpers.c
> +++ b/lib/string_helpers.c
> @@ -4,6 +4,7 @@
>   * Copyright 31 August 2008 James Bottomley
>   * Copyright (C) 2013, Intel Corporation
>   */
> +#include <linux/bug.h>
>  #include <linux/kernel.h>
>  #include <linux/math64.h>
>  #include <linux/export.h>
> @@ -14,7 +15,8 @@
>
>  /**
>   * string_get_size - get the size in the specified units
> - * @size:      The size to be converted
> + * @size:      The size to be converted in blocks
> + * @blk_size:  Size of the block (use 1 for size in bytes)
>   * @units:     units to use (powers of 1000 or 1024)
>   * @buf:       buffer to format to
>   * @len:       length of buffer
> @@ -24,14 +26,14 @@
>   * at least 9 bytes and will always be zero terminated.
>   *
>   */
> -void string_get_size(u64 size, const enum string_size_units units,
> +void string_get_size(u64 size, u64 blk_size, const enum string_size_units units,
>                      char *buf, int len)
>  {
>         static const char *const units_10[] = {
> -               "B", "kB", "MB", "GB", "TB", "PB", "EB"
> +               "B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"
>         };
>         static const char *const units_2[] = {
> -               "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"
> +               "B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"
>         };
>         static const char *const *const units_str[] = {
>                 [STRING_UNITS_10] = units_10,
> @@ -42,31 +44,58 @@ void string_get_size(u64 size, const enum string_size_units units,
>                 [STRING_UNITS_2] = 1024,
>         };
>         int i, j;
> -       u32 remainder = 0, sf_cap;
> +       u32 remainder = 0, sf_cap, exp;
>         char tmp[8];
> +       const char *unit;
>
>         tmp[0] = '\0';
>         i = 0;
> -       if (size >= divisor[units]) {
> -               while (size >= divisor[units]) {
> -                       remainder = do_div(size, divisor[units]);
> -                       i++;
> -               }
> +       if (!size)
> +               goto out;
>
> -               sf_cap = size;
> -               for (j = 0; sf_cap*10 < 1000; j++)
> -                       sf_cap *= 10;
> +       while (blk_size >= divisor[units]) {
> +               remainder = do_div(blk_size, divisor[units]);
> +               i++;
> +       }
>
> -               if (j) {
> -                       remainder *= 1000;
> -                       remainder /= divisor[units];
> -                       snprintf(tmp, sizeof(tmp), ".%03u", remainder);
> -                       tmp[j+1] = '\0';
> -               }
> +       exp = divisor[units];
> +       do_div(exp, blk_size);
> +       if (size >= exp) {
> +               remainder = do_div(size, divisor[units]);
> +               remainder *= blk_size;
> +               i++;
> +       } else {
> +               remainder *= size;
> +       }
> +
> +       size *= blk_size;
> +       size += (remainder/divisor[units]);
> +       remainder %= divisor[units];
> +
> +       while (size >= divisor[units]) {
> +               remainder = do_div(size, divisor[units]);
> +               i++;
>         }
>
> +       sf_cap = size;
> +       for (j = 0; sf_cap*10 < 1000; j++)
> +               sf_cap *= 10;
> +
> +       if (j) {
> +               remainder *= 1000;
> +               remainder /= divisor[units];
> +               snprintf(tmp, sizeof(tmp), ".%03u", remainder);
> +               tmp[j+1] = '\0';
> +       }
> +
> + out:
> +       if (i >= ARRAY_SIZE(units_2))
> +               unit = "UNK";
> +       else
> +               unit = units_str[units][i];
> +
>         snprintf(buf, len, "%u%s %s", (u32)size,
> -                tmp, units_str[units][i]);
> +                tmp, unit);
>  }
>  EXPORT_SYMBOL(string_get_size);
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
