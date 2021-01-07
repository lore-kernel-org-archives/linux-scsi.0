Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9645C43381
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F85723435
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbhAGQoi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:44:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:34994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbhAGQoi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 11:44:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610037830; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5d5fBq0ErCpsBtMRLAvsiYNNftcQCFNgXkUW6Xnbwqo=;
        b=X87Qui9rA5SZ+ngjG2+Tr0k7xX25TesyU1FDpNfBRaKpIU30yKnu0T+/B9/a4Jgwc7iCHc
        k0UaMCMwmPbOXLUldOqOq5IZciGOxkwJ1Bs4KESoyveGJhiQWwpQsRWCk8+rJaflcNyzN5
        rNXSR3q6qjKhw7LWKTK6bM8w93e7LE4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26207AD5C;
        Thu,  7 Jan 2021 16:43:50 +0000 (UTC)
Message-ID: <2b8ec404c0270a66d0f8b33ccf6422acb174555e.camel@suse.com>
Subject: Re: [PATCH V3 02/25] smartpqi: refactor aio submission code
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 07 Jan 2021 17:43:49 +0100
In-Reply-To: <160763247186.26927.2277580027307471315.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763247186.26927.2277580027307471315.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:34 -0600, Don Brace wrote:
> * No functional changes.
>   * Refactor aio submission code:
>     1. break-up function into smaller functions.
>     2. add common block of data to carry around
>        into newly added functions.
>     3. Prepare for new AIO functionality.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

I've got a few nitpicks, see below. But they should rather go
into a separate patch, so

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
>  drivers/scsi/smartpqi/smartpqi.h      |   52 +++
>  drivers/scsi/smartpqi/smartpqi_init.c |  554 ++++++++++++++++++-----
> ----------
>  2 files changed, 360 insertions(+), 246 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h
> b/drivers/scsi/smartpqi/smartpqi.h
> index 7d3f956e949f..d486a2ec3045 100644
> --- a/drivers/scsi/smartpqi/smartpqi.h
> +++ b/drivers/scsi/smartpqi/smartpqi.h
> @@ -908,6 +908,58 @@ struct raid_map {
>  
>  #pragma pack()
>  
> +struct pqi_scsi_dev_raid_map_data {
> +       bool    is_write;
> +       u8      raid_level;
> +       u32     map_index;
> +       u64     first_block;
> +       u64     last_block;
> +       u32     data_length;
> +       u32     block_cnt;
> +       u32     blocks_per_row;
> +       u64     first_row;
> +       u64     last_row;
> +       u32     first_row_offset;
> +       u32     last_row_offset;
> +       u32     first_column;
> +       u32     last_column;
> +       u64     r5or6_first_row;
> +       u64     r5or6_last_row;
> +       u32     r5or6_first_row_offset;
> +       u32     r5or6_last_row_offset;
> +       u32     r5or6_first_column;
> +       u32     r5or6_last_column;
> +       u16     data_disks_per_row;
> +       u32     total_disks_per_row;
> +       u16     layout_map_count;
> +       u32     stripesize;
> +       u16     strip_size;
> +       u32     first_group;
> +       u32     last_group;
> +       u32     current_group;
> +       u32     map_row;
> +       u32     aio_handle;
> +       u64     disk_block;
> +       u32     disk_block_cnt;
> +       u8      cdb[16];
> +       u8      cdb_length;
> +       int     offload_to_mirror;
> +
> +       /* RAID1 specific */
> +#define NUM_RAID1_MAP_ENTRIES 3
> +       u32     num_it_nexus_entries;
> +       u32     it_nexus[NUM_RAID1_MAP_ENTRIES];
> +
> +       /* RAID5 RAID6 specific */
> +       u32     p_parity_it_nexus; /* aio_handle */
> +       u32     q_parity_it_nexus; /* aio_handle */
> +       u8      xor_mult;
> +       u64     row;
> +       u64     stripe_lba;
> +       u32     p_index;
> +       u32     q_index;
> +};

There seem to be more Raid 5/6 specific fields above.
Have you considered using a union?


> +
>  #define RAID_CTLR_LUNID                "\0\0\0\0\0\0\0\0"
>  
>  struct pqi_scsi_dev {
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 68fc4327944e..2348b9f24d8c 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -2237,332 +2237,394 @@ static inline void pqi_set_encryption_info(
>   * Attempt to perform RAID bypass mapping for a logical volume I/O.
>   */
>  
> +static bool pqi_aio_raid_level_supported(struct
> pqi_scsi_dev_raid_map_data *rmd)
> +{
> +       bool is_supported = true;
> +
> +       switch (rmd->raid_level) {
> +       case SA_RAID_0:
> +               break;
> +       case SA_RAID_1:
> +               if (rmd->is_write)
> +                       is_supported = false;
> +               break;
> +       case SA_RAID_5:
> +               fallthrough;

I don't think "fallthrough" is necessary here.

> +       case SA_RAID_6:
> +               if (rmd->is_write)
> +                       is_supported = false;
> +               break;
> +       case SA_RAID_ADM:
> +               if (rmd->is_write)
> +                       is_supported = false;
> +               break;
> +       default:
> +               is_supported = false;
> +       }
> +
> +       return is_supported;
> +}
> +
>  #define PQI_RAID_BYPASS_INELIGIBLE     1
>  
> -static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info
> *ctrl_info,
> -       struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
> -       struct pqi_queue_group *queue_group)
> +static int pqi_get_aio_lba_and_block_count(struct scsi_cmnd *scmd,
> +                       struct pqi_scsi_dev_raid_map_data *rmd)
>  {
> -       struct raid_map *raid_map;
> -       bool is_write = false;
> -       u32 map_index;
> -       u64 first_block;
> -       u64 last_block;
> -       u32 block_cnt;
> -       u32 blocks_per_row;
> -       u64 first_row;
> -       u64 last_row;
> -       u32 first_row_offset;
> -       u32 last_row_offset;
> -       u32 first_column;
> -       u32 last_column;
> -       u64 r0_first_row;
> -       u64 r0_last_row;
> -       u32 r5or6_blocks_per_row;
> -       u64 r5or6_first_row;
> -       u64 r5or6_last_row;
> -       u32 r5or6_first_row_offset;
> -       u32 r5or6_last_row_offset;
> -       u32 r5or6_first_column;
> -       u32 r5or6_last_column;
> -       u16 data_disks_per_row;
> -       u32 total_disks_per_row;
> -       u16 layout_map_count;
> -       u32 stripesize;
> -       u16 strip_size;
> -       u32 first_group;
> -       u32 last_group;
> -       u32 current_group;
> -       u32 map_row;
> -       u32 aio_handle;
> -       u64 disk_block;
> -       u32 disk_block_cnt;
> -       u8 cdb[16];
> -       u8 cdb_length;
> -       int offload_to_mirror;
> -       struct pqi_encryption_info *encryption_info_ptr;
> -       struct pqi_encryption_info encryption_info;
> -#if BITS_PER_LONG == 32
> -       u64 tmpdiv;
> -#endif
> -
>         /* Check for valid opcode, get LBA and block count. */
>         switch (scmd->cmnd[0]) {
>         case WRITE_6:
> -               is_write = true;
> +               rmd->is_write = true;
>                 fallthrough;
>         case READ_6:
> -               first_block = (u64)(((scmd->cmnd[1] & 0x1f) << 16) |
> +               rmd->first_block = (u64)(((scmd->cmnd[1] & 0x1f) <<
> 16) |
>                         (scmd->cmnd[2] << 8) | scmd->cmnd[3]);
> -               block_cnt = (u32)scmd->cmnd[4];
> -               if (block_cnt == 0)
> -                       block_cnt = 256;
> +               rmd->block_cnt = (u32)scmd->cmnd[4];
> +               if (rmd->block_cnt == 0)
> +                       rmd->block_cnt = 256;
>                 break;
>         case WRITE_10:
> -               is_write = true;
> +               rmd->is_write = true;
>                 fallthrough;
>         case READ_10:
> -               first_block = (u64)get_unaligned_be32(&scmd-
> > cmnd[2]);
> -               block_cnt = (u32)get_unaligned_be16(&scmd->cmnd[7]);
> +               rmd->first_block = (u64)get_unaligned_be32(&scmd-
> > cmnd[2]);
> +               rmd->block_cnt = (u32)get_unaligned_be16(&scmd-
> > cmnd[7]);
>                 break;
>         case WRITE_12:
> -               is_write = true;
> +               rmd->is_write = true;
>                 fallthrough;
>         case READ_12:
> -               first_block = (u64)get_unaligned_be32(&scmd-
> > cmnd[2]);
> -               block_cnt = get_unaligned_be32(&scmd->cmnd[6]);
> +               rmd->first_block = (u64)get_unaligned_be32(&scmd-
> > cmnd[2]);
> +               rmd->block_cnt = get_unaligned_be32(&scmd->cmnd[6]);
>                 break;
>         case WRITE_16:
> -               is_write = true;
> +               rmd->is_write = true;
>                 fallthrough;
>         case READ_16:
> -               first_block = get_unaligned_be64(&scmd->cmnd[2]);
> -               block_cnt = get_unaligned_be32(&scmd->cmnd[10]);
> +               rmd->first_block = get_unaligned_be64(&scmd-
> > cmnd[2]);
> +               rmd->block_cnt = get_unaligned_be32(&scmd->cmnd[10]);
>                 break;
>         default:
>                 /* Process via normal I/O path. */
>                 return PQI_RAID_BYPASS_INELIGIBLE;
>         }
>  
> -       /* Check for write to non-RAID-0. */
> -       if (is_write && device->raid_level != SA_RAID_0)
> -               return PQI_RAID_BYPASS_INELIGIBLE;
> +       put_unaligned_le32(scsi_bufflen(scmd), &rmd->data_length);
>  
> -       if (unlikely(block_cnt == 0))
> -               return PQI_RAID_BYPASS_INELIGIBLE;
> +       return 0;
> +}
>  
> -       last_block = first_block + block_cnt - 1;
> -       raid_map = device->raid_map;
> +static int pci_get_aio_common_raid_map_values(struct pqi_ctrl_info
> *ctrl_info,
> +                                       struct
> pqi_scsi_dev_raid_map_data *rmd,
> +                                       struct raid_map *raid_map)
> +{
> +#if BITS_PER_LONG == 32
> +       u64 tmpdiv;
> +#endif
> +
> +       rmd->last_block = rmd->first_block + rmd->block_cnt - 1;
>  
>         /* Check for invalid block or wraparound. */
> -       if (last_block >= get_unaligned_le64(&raid_map-
> > volume_blk_cnt) ||
> -               last_block < first_block)
> +       if (rmd->last_block >=
> +               get_unaligned_le64(&raid_map->volume_blk_cnt) ||
> +               rmd->last_block < rmd->first_block)
>                 return PQI_RAID_BYPASS_INELIGIBLE;
>  
> -       data_disks_per_row = get_unaligned_le16(&raid_map-
> > data_disks_per_row);
> -       strip_size = get_unaligned_le16(&raid_map->strip_size);
> -       layout_map_count = get_unaligned_le16(&raid_map-
> > layout_map_count);
> +       rmd->data_disks_per_row =
> +                       get_unaligned_le16(&raid_map-
> > data_disks_per_row);
> +       rmd->strip_size = get_unaligned_le16(&raid_map->strip_size);
> +       rmd->layout_map_count = get_unaligned_le16(&raid_map-
> > layout_map_count);
>  
>         /* Calculate stripe information for the request. */
> -       blocks_per_row = data_disks_per_row * strip_size;
> +       rmd->blocks_per_row = rmd->data_disks_per_row * rmd-
> > strip_size;
>  #if BITS_PER_LONG == 32

Just wondering - why don't you use do_div() for 64 bit, too?
Same question for pqi_calc_aio_r5_or_r6() below.

> -       tmpdiv = first_block;
> -       do_div(tmpdiv, blocks_per_row);
> -       first_row = tmpdiv;
> -       tmpdiv = last_block;
> -       do_div(tmpdiv, blocks_per_row);
> -       last_row = tmpdiv;
> -       first_row_offset = (u32)(first_block - (first_row *
> blocks_per_row));
> -       last_row_offset = (u32)(last_block - (last_row *
> blocks_per_row));
> -       tmpdiv = first_row_offset;
> -       do_div(tmpdiv, strip_size);
> -       first_column = tmpdiv;
> -       tmpdiv = last_row_offset;
> -       do_div(tmpdiv, strip_size);
> -       last_column = tmpdiv;
> +       tmpdiv = rmd->first_block;
> +       do_div(tmpdiv, rmd->blocks_per_row);
> +       rmd->first_row = tmpdiv;
> +       tmpdiv = rmd->last_block;
> +       do_div(tmpdiv, rmd->blocks_per_row);
> +       rmd->last_row = tmpdiv;
> +       rmd->first_row_offset = (u32)(rmd->first_block - (rmd-
> > first_row * rmd->blocks_per_row));
> +       rmd->last_row_offset = (u32)(rmd->last_block - (rmd->last_row
> * rmd->blocks_per_row));
> +       tmpdiv = rmd->first_row_offset;
> +       do_div(tmpdiv, rmd->strip_size);
> +       rmd->first_column = tmpdiv;
> +       tmpdiv = rmd->last_row_offset;
> +       do_div(tmpdiv, rmd->strip_size);
> +       rmd->last_column = tmpdiv;
>  #else
> -       first_row = first_block / blocks_per_row;
> -       last_row = last_block / blocks_per_row;
> -       first_row_offset = (u32)(first_block - (first_row *
> blocks_per_row));
> -       last_row_offset = (u32)(last_block - (last_row *
> blocks_per_row));
> -       first_column = first_row_offset / strip_size;
> -       last_column = last_row_offset / strip_size;
> +       rmd->first_row = rmd->first_block / rmd->blocks_per_row;
> +       rmd->last_row = rmd->last_block / rmd->blocks_per_row;
> +       rmd->first_row_offset = (u32)(rmd->first_block -
> +                               (rmd->first_row * rmd-
> > blocks_per_row));
> +       rmd->last_row_offset = (u32)(rmd->last_block - (rmd->last_row
> *
> +                               rmd->blocks_per_row));
> +       rmd->first_column = rmd->first_row_offset / rmd->strip_size;
> +       rmd->last_column = rmd->last_row_offset / rmd->strip_size;
>  #endif
>  
>         /* If this isn't a single row/column then give to the
> controller. */
> -       if (first_row != last_row || first_column != last_column)
> +       if (rmd->first_row != rmd->last_row ||
> +                       rmd->first_column != rmd->last_column)
>                 return PQI_RAID_BYPASS_INELIGIBLE;

You could save a few cycles here by testing rows and columns
separately.

>  
>         /* Proceeding with driver mapping. */
> -       total_disks_per_row = data_disks_per_row +
> +       rmd->total_disks_per_row = rmd->data_disks_per_row +
>                 get_unaligned_le16(&raid_map-
> > metadata_disks_per_row);
> -       map_row = ((u32)(first_row >> raid_map-
> > parity_rotation_shift)) %
> +       rmd->map_row = ((u32)(rmd->first_row >>
> +               raid_map->parity_rotation_shift)) %
>                 get_unaligned_le16(&raid_map->row_cnt);
> -       map_index = (map_row * total_disks_per_row) + first_column;
> +       rmd->map_index = (rmd->map_row * rmd->total_disks_per_row) +
> +                       rmd->first_column;
>  
> -       /* RAID 1 */
> -       if (device->raid_level == SA_RAID_1) {
> -               if (device->offload_to_mirror)
> -                       map_index += data_disks_per_row;
> -               device->offload_to_mirror = !device-
> > offload_to_mirror;
> -       } else if (device->raid_level == SA_RAID_ADM) {
> -               /* RAID ADM */
> -               /*
> -                * Handles N-way mirrors  (R1-ADM) and R10 with # of
> drives
> -                * divisible by 3.
> -                */
> -               offload_to_mirror = device->offload_to_mirror;
> -               if (offload_to_mirror == 0)  {
> -                       /* use physical disk in the first mirrored
> group. */
> -                       map_index %= data_disks_per_row;
> -               } else {
> -                       do {
> -                               /*
> -                                * Determine mirror group that
> map_index
> -                                * indicates.
> -                                */
> -                               current_group = map_index /
> data_disks_per_row;
> -
> -                               if (offload_to_mirror !=
> current_group) {
> -                                       if (current_group <
> -                                               layout_map_count - 1)
> {
> -                                               /*
> -                                                * Select raid index
> from
> -                                                * next group.
> -                                                */
> -                                               map_index +=
> data_disks_per_row;
> -                                               current_group++;
> -                                       } else {
> -                                               /*
> -                                                * Select raid index
> from first
> -                                                * group.
> -                                                */
> -                                               map_index %=
> data_disks_per_row;
> -                                               current_group = 0;
> -                                       }
> +       return 0;
> +}
> +
> +static int pqi_calc_aio_raid_adm(struct pqi_scsi_dev_raid_map_data
> *rmd,
> +                               struct pqi_scsi_dev *device)
> +{
> +       /* RAID ADM */
> +       /*
> +        * Handles N-way mirrors  (R1-ADM) and R10 with # of drives
> +        * divisible by 3.
> +        */
> +       rmd->offload_to_mirror = device->offload_to_mirror;
> +
> +       if (rmd->offload_to_mirror == 0)  {
> +               /* use physical disk in the first mirrored group. */
> +               rmd->map_index %= rmd->data_disks_per_row;
> +       } else {
> +               do {
> +                       /*
> +                        * Determine mirror group that map_index
> +                        * indicates.
> +                        */
> +                       rmd->current_group =
> +                               rmd->map_index / rmd-
> > data_disks_per_row;
> +
> +                       if (rmd->offload_to_mirror !=
> +                                       rmd->current_group) {
> +                               if (rmd->current_group <
> +                                       rmd->layout_map_count - 1) {
> +                                       /*
> +                                        * Select raid index from
> +                                        * next group.
> +                                        */
> +                                       rmd->map_index += rmd-
> > data_disks_per_row;
> +                                       rmd->current_group++;
> +                               } else {
> +                                       /*
> +                                        * Select raid index from
> first
> +                                        * group.
> +                                        */
> +                                       rmd->map_index %= rmd-
> > data_disks_per_row;
> +                                       rmd->current_group = 0;
>                                 }
> -                       } while (offload_to_mirror != current_group);
> -               }
> +                       }
> +               } while (rmd->offload_to_mirror != rmd-
> > current_group);
> +       }
>  
> -               /* Set mirror group to use next time. */
> -               offload_to_mirror =
> -                       (offload_to_mirror >= layout_map_count - 1) ?
> -                               0 : offload_to_mirror + 1;
> -               device->offload_to_mirror = offload_to_mirror;
> -               /*
> -                * Avoid direct use of device->offload_to_mirror
> within this
> -                * function since multiple threads might
> simultaneously
> -                * increment it beyond the range of device-
> > layout_map_count -1.
> -                */
> -       } else if ((device->raid_level == SA_RAID_5 ||
> -               device->raid_level == SA_RAID_6) && layout_map_count
> > 1) {
> -               /* RAID 50/60 */
> -               /* Verify first and last block are in same RAID group
> */
> -               r5or6_blocks_per_row = strip_size *
> data_disks_per_row;
> -               stripesize = r5or6_blocks_per_row * layout_map_count;
> +       /* Set mirror group to use next time. */
> +       rmd->offload_to_mirror =
> +               (rmd->offload_to_mirror >= rmd->layout_map_count - 1)
> ?
> +                       0 : rmd->offload_to_mirror + 1;
> +       device->offload_to_mirror = rmd->offload_to_mirror;
> +       /*
> +        * Avoid direct use of device->offload_to_mirror within this
> +        * function since multiple threads might simultaneously
> +        * increment it beyond the range of device->layout_map_count
> -1.
> +        */
> +
> +       return 0;
> +}
> +
> +static int pqi_calc_aio_r5_or_r6(struct pqi_scsi_dev_raid_map_data
> *rmd,
> +                               struct raid_map *raid_map)
> +{
> +#if BITS_PER_LONG == 32
> +       u64 tmpdiv;
> +#endif
> +       /* RAID 50/60 */
> +       /* Verify first and last block are in same RAID group */
> +       rmd->stripesize = rmd->blocks_per_row * rmd-
> > layout_map_count;
>  #if BITS_PER_LONG == 32
> -               tmpdiv = first_block;
> -               first_group = do_div(tmpdiv, stripesize);
> -               tmpdiv = first_group;
> -               do_div(tmpdiv, r5or6_blocks_per_row);
> -               first_group = tmpdiv;
> -               tmpdiv = last_block;
> -               last_group = do_div(tmpdiv, stripesize);
> -               tmpdiv = last_group;
> -               do_div(tmpdiv, r5or6_blocks_per_row);
> -               last_group = tmpdiv;
> +       tmpdiv = rmd->first_block;
> +       rmd->first_group = do_div(tmpdiv, rmd->stripesize);
> +       tmpdiv = rmd->first_group;
> +       do_div(tmpdiv, rmd->blocks_per_row);
> +       rmd->first_group = tmpdiv;
> +       tmpdiv = rmd->last_block;
> +       rmd->last_group = do_div(tmpdiv, rmd->stripesize);
> +       tmpdiv = rmd->last_group;
> +       do_div(tmpdiv, rmd->blocks_per_row);
> +       rmd->last_group = tmpdiv;
>  #else
> -               first_group = (first_block % stripesize) /
> r5or6_blocks_per_row;
> -               last_group = (last_block % stripesize) /
> r5or6_blocks_per_row;
> +       rmd->first_group = (rmd->first_block % rmd->stripesize) /
> rmd->blocks_per_row;
> +       rmd->last_group = (rmd->last_block % rmd->stripesize) / rmd-
> > blocks_per_row;
>  #endif
> -               if (first_group != last_group)
> -                       return PQI_RAID_BYPASS_INELIGIBLE;
> +       if (rmd->first_group != rmd->last_group)
> +               return PQI_RAID_BYPASS_INELIGIBLE;
>  
> -               /* Verify request is in a single row of RAID 5/6 */
> +       /* Verify request is in a single row of RAID 5/6 */
>  #if BITS_PER_LONG == 32
> -               tmpdiv = first_block;
> -               do_div(tmpdiv, stripesize);
> -               first_row = r5or6_first_row = r0_first_row = tmpdiv;
> -               tmpdiv = last_block;
> -               do_div(tmpdiv, stripesize);
> -               r5or6_last_row = r0_last_row = tmpdiv;
> +       tmpdiv = rmd->first_block;
> +       do_div(tmpdiv, rmd->stripesize);
> +       rmd->first_row = tmpdiv;
> +       rmd->r5or6_first_row = tmpdiv;
> +       tmpdiv = rmd->last_block;
> +       do_div(tmpdiv, rmd->stripesize);
> +       rmd->r5or6_last_row = tmpdiv;
>  #else
> -               first_row = r5or6_first_row = r0_first_row =
> -                       first_block / stripesize;
> -               r5or6_last_row = r0_last_row = last_block /
> stripesize;
> +       rmd->first_row = rmd->r5or6_first_row =
> +               rmd->first_block / rmd->stripesize;
> +       rmd->r5or6_last_row = rmd->last_block / rmd->stripesize;
>  #endif
> -               if (r5or6_first_row != r5or6_last_row)
> -                       return PQI_RAID_BYPASS_INELIGIBLE;
> +       if (rmd->r5or6_first_row != rmd->r5or6_last_row)
> +               return PQI_RAID_BYPASS_INELIGIBLE;
>  
> -               /* Verify request is in a single column */
> +       /* Verify request is in a single column */
>  #if BITS_PER_LONG == 32
> -               tmpdiv = first_block;
> -               first_row_offset = do_div(tmpdiv, stripesize);
> -               tmpdiv = first_row_offset;
> -               first_row_offset = (u32)do_div(tmpdiv,
> r5or6_blocks_per_row);
> -               r5or6_first_row_offset = first_row_offset;
> -               tmpdiv = last_block;
> -               r5or6_last_row_offset = do_div(tmpdiv, stripesize);
> -               tmpdiv = r5or6_last_row_offset;
> -               r5or6_last_row_offset = do_div(tmpdiv,
> r5or6_blocks_per_row);
> -               tmpdiv = r5or6_first_row_offset;
> -               do_div(tmpdiv, strip_size);
> -               first_column = r5or6_first_column = tmpdiv;
> -               tmpdiv = r5or6_last_row_offset;
> -               do_div(tmpdiv, strip_size);
> -               r5or6_last_column = tmpdiv;
> +       tmpdiv = rmd->first_block;
> +       rmd->first_row_offset = do_div(tmpdiv, rmd->stripesize);
> +       tmpdiv = rmd->first_row_offset;
> +       rmd->first_row_offset = (u32)do_div(tmpdiv, rmd-
> > blocks_per_row);
> +       rmd->r5or6_first_row_offset = rmd->first_row_offset;
> +       tmpdiv = rmd->last_block;
> +       rmd->r5or6_last_row_offset = do_div(tmpdiv, rmd->stripesize);
> +       tmpdiv = rmd->r5or6_last_row_offset;
> +       rmd->r5or6_last_row_offset = do_div(tmpdiv, rmd-
> > blocks_per_row);
> +       tmpdiv = rmd->r5or6_first_row_offset;
> +       do_div(tmpdiv, rmd->strip_size);
> +       rmd->first_column = rmd->r5or6_first_column = tmpdiv;
> +       tmpdiv = rmd->r5or6_last_row_offset;
> +       do_div(tmpdiv, rmd->strip_size);
> +       rmd->r5or6_last_column = tmpdiv;
>  #else
> -               first_row_offset = r5or6_first_row_offset =
> -                       (u32)((first_block % stripesize) %
> -                       r5or6_blocks_per_row);
> +       rmd->first_row_offset = rmd->r5or6_first_row_offset =
> +               (u32)((rmd->first_block %
> +                               rmd->stripesize) %
> +                               rmd->blocks_per_row);
> +
> +       rmd->r5or6_last_row_offset =
> +               (u32)((rmd->last_block % rmd->stripesize) %
> +               rmd->blocks_per_row);
> +
> +       rmd->first_column =
> +                       rmd->r5or6_first_row_offset / rmd-
> > strip_size;
> +       rmd->r5or6_first_column = rmd->first_column;
> +       rmd->r5or6_last_column = rmd->r5or6_last_row_offset / rmd-
> > strip_size;
> +#endif
> +       if (rmd->r5or6_first_column != rmd->r5or6_last_column)
> +               return PQI_RAID_BYPASS_INELIGIBLE;
> +
> +       /* Request is eligible */
> +       rmd->map_row =
> +               ((u32)(rmd->first_row >> raid_map-
> > parity_rotation_shift)) %
> +               get_unaligned_le16(&raid_map->row_cnt);
>  
> -               r5or6_last_row_offset =
> -                       (u32)((last_block % stripesize) %
> -                       r5or6_blocks_per_row);
> +       rmd->map_index = (rmd->first_group *
> +               (get_unaligned_le16(&raid_map->row_cnt) *
> +               rmd->total_disks_per_row)) +
> +               (rmd->map_row * rmd->total_disks_per_row) + rmd-
> > first_column;
>  
> -               first_column = r5or6_first_row_offset / strip_size;
> -               r5or6_first_column = first_column;
> -               r5or6_last_column = r5or6_last_row_offset /
> strip_size;
> -#endif
> -               if (r5or6_first_column != r5or6_last_column)
> -                       return PQI_RAID_BYPASS_INELIGIBLE;
> +       return 0;
> +}
> +
> +static void pqi_set_aio_cdb(struct pqi_scsi_dev_raid_map_data *rmd)
> +{
> +       /* Build the new CDB for the physical disk I/O. */
> +       if (rmd->disk_block > 0xffffffff) {
> +               rmd->cdb[0] = rmd->is_write ? WRITE_16 : READ_16;
> +               rmd->cdb[1] = 0;
> +               put_unaligned_be64(rmd->disk_block, &rmd->cdb[2]);
> +               put_unaligned_be32(rmd->disk_block_cnt, &rmd-
> > cdb[10]);
> +               rmd->cdb[14] = 0;
> +               rmd->cdb[15] = 0;
> +               rmd->cdb_length = 16;
> +       } else {
> +               rmd->cdb[0] = rmd->is_write ? WRITE_10 : READ_10;
> +               rmd->cdb[1] = 0;
> +               put_unaligned_be32((u32)rmd->disk_block, &rmd-
> > cdb[2]);
> +               rmd->cdb[6] = 0;
> +               put_unaligned_be16((u16)rmd->disk_block_cnt, &rmd-
> > cdb[7]);
> +               rmd->cdb[9] = 0;
> +               rmd->cdb_length = 10;
> +       }
> +}
> +
> +static int pqi_raid_bypass_submit_scsi_cmd(struct pqi_ctrl_info
> *ctrl_info,
> +       struct pqi_scsi_dev *device, struct scsi_cmnd *scmd,
> +       struct pqi_queue_group *queue_group)
> +{
> +       struct raid_map *raid_map;
> +       int rc;
> +       struct pqi_encryption_info *encryption_info_ptr;
> +       struct pqi_encryption_info encryption_info;
> +       struct pqi_scsi_dev_raid_map_data rmd = {0};
> +
> +       rc = pqi_get_aio_lba_and_block_count(scmd, &rmd);
> +       if (rc)
> +               return PQI_RAID_BYPASS_INELIGIBLE;
> +
> +       rmd.raid_level = device->raid_level;
> +
> +       if (!pqi_aio_raid_level_supported(&rmd))
> +               return PQI_RAID_BYPASS_INELIGIBLE;
> +
> +       if (unlikely(rmd.block_cnt == 0))
> +               return PQI_RAID_BYPASS_INELIGIBLE;
> +
> +       raid_map = device->raid_map;
>  
> -               /* Request is eligible */
> -               map_row =
> -                       ((u32)(first_row >> raid_map-
> > parity_rotation_shift)) %
> -                       get_unaligned_le16(&raid_map->row_cnt);
> +       rc = pci_get_aio_common_raid_map_values(ctrl_info, &rmd,
> raid_map);
> +       if (rc)
> +               return PQI_RAID_BYPASS_INELIGIBLE;
>  
> -               map_index = (first_group *
> -                       (get_unaligned_le16(&raid_map->row_cnt) *
> -                       total_disks_per_row)) +
> -                       (map_row * total_disks_per_row) +
> first_column;
> +       /* RAID 1 */
> +       if (device->raid_level == SA_RAID_1) {
> +               if (device->offload_to_mirror)
> +                       rmd.map_index += rmd.data_disks_per_row;
> +               device->offload_to_mirror = !device-
> > offload_to_mirror;
> +       } else if (device->raid_level == SA_RAID_ADM) {
> +               rc = pqi_calc_aio_raid_adm(&rmd, device);

You don't use this return value. Actually, pqi_calc_aio_raid_adm()
could be a void function.



