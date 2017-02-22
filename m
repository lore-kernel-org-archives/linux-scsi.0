From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH] target/user: Add daynmic growing data area feature
 support
Date: Wed, 22 Feb 2017 12:32:24 -0800
Message-ID: <09891673-0d95-8b66-ddce-0ace7aea43d1@redhat.com>
References: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934260AbdBVUkO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 15:40:14 -0500
In-Reply-To: <1487323472-20481-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org, mchristi@redhat.com, shli@kernel.org
Cc: hch@lst.de, sheng@yasker.org, namei.unix@gmail.com, bart.vanassche@sandisk.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Jianfei Hu <hujianfei@cmss.chinamobile.com>

On 02/17/2017 01:24 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> Currently for the TCMU, the ring buffer size is fixed to 64K cmd
> area + 1M data area, and this will be bottlenecks for high iops.

Hi Xiubo, thanks for your work.

daynmic -> dynamic

Have you benchmarked this patch and determined what kind of iops
improvement it allows? Do you see the data area reaching its
fully-allocated size?

> 
> The struct tcmu_cmd_entry {} size is fixed about 44 bytes without
> iovec[N], and the size of struct iovec[N] is about (16 * N) bytes.
> 
> The sizeof(cmd entry) will be [44B, N *16 + 44B], and corresponding
> iovec[N] size will be [0, N * 4096], so the ratio of
> sizeof(cmd entry) : sizeof(entry datas) ==
> (N * 16 + 44)Bytes : (N * 4096)Bytes == (N * 16)/(N * 4096) +
> 44/(N*4096) == 4/1024 + 11/(N * 1024).
> 
> When N is bigger, the ratio will be smaller. If N >= 1, the ratio
> will be [15/1024, 4/1024), for this the ratio 15 : 1024 will be
> enough. But maybe some iscsi cmds has no datas, N == 0. So the ratio
> should be bigger.
> 
> For now we will increase the data area size to 1G, and the cmd area
> size to 128M. The tcmu-runner should mmap() about (128M + 1G) when
> running and the TCMU will dynamically grows the data area from 0 to
> max 1G size.

Cool. This is a good approach for an initial patch but this raises
concerns about efficiently managing kernel memory usage -- the data area
grows but never shrinks, and total possible usage increases per
backstore. (What if there are 1000?) Any ideas how we could also improve
these aspects of the design? (Global TCMU data area usage limit?)

> 
> The cmd area memory will be allocated through vmalloc(), and the data
> area's blocks will be allocated individually later when needed.
> 
> The allocated data area block memory will be managed via radix tree.
> For now the bitmap still be the most efficient way to search and
> manage the block index, this could be update later.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> Signed-off-by: Jianfei Hu <hujianfei@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 241 ++++++++++++++++++++++++++------------
>  1 file changed, 167 insertions(+), 74 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 2e33100..f2e3769 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2,6 +2,7 @@
>   * Copyright (C) 2013 Shaohua Li <shli@kernel.org>
>   * Copyright (C) 2014 Red Hat, Inc.
>   * Copyright (C) 2015 Arrikto, Inc.
> + * Copyright (C) 2017 Chinamobile, Inc.
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms and conditions of the GNU General Public License,
> @@ -25,6 +26,7 @@
>  #include <linux/parser.h>
>  #include <linux/vmalloc.h>
>  #include <linux/uio_driver.h>
> +#include <linux/radix-tree.h>
>  #include <linux/stringify.h>
>  #include <linux/bitops.h>
>  #include <linux/highmem.h>
> @@ -65,12 +67,15 @@
>  
>  #define TCMU_TIME_OUT (30 * MSEC_PER_SEC)
>  
> -#define DATA_BLOCK_BITS 256
> -#define DATA_BLOCK_SIZE 4096
> +/* For cmd area, the size is fixed 64M */
> +#define CMDR_SIZE (64 * 1024 * 1024)

Commitmsg mistakenly says 128M..?

> -#define CMDR_SIZE (16 * 4096)
> +/* For data area, the size is fixed 1G */
> +#define DATA_BLOCK_BITS (256 * 1024)
> +#define DATA_BLOCK_SIZE 4096
>  #define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
>  
> +/* The ring buffer size is 64M + 1G */
>  #define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
>  
>  static struct device *tcmu_root_device;
> @@ -103,6 +108,7 @@ struct tcmu_dev {
>  	size_t data_size;
>  
>  	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
> +	struct radix_tree_root data_blocks;
>  
>  	wait_queue_head_t wait_cmdr;
>  	/* TODO should this be a mutex? */
> @@ -120,15 +126,22 @@ struct tcmu_dev {
>  
>  #define CMDR_OFF sizeof(struct tcmu_mailbox)
>  
> +struct tcmu_data_block_index {
> +	struct list_head list;
> +	uint32_t index;
> +};

is this used anywhere? leftover from an earlier version?

> +
>  struct tcmu_cmd {
>  	struct se_cmd *se_cmd;
>  	struct tcmu_dev *tcmu_dev;
>  
> -	uint16_t cmd_id;
> +	uint32_t cmd_id;

why this? tcmu_cmd_entry_hdr has a u16 cmd_id, so making this bigger
doesn't really help anything. (natural alignment? But, compiler should
be inserting padding as needed.)

>  
>  	/* Can't use se_cmd when cleaning up expired cmds, because if
>  	   cmd has been completed then accessing se_cmd is off limits */
> -	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
> +	uint32_t dbi_cnt;
> +	uint32_t dbi_cur;
> +	uint32_t *dbi;

Ah, cool. Saves tcmu_cmd from being huge, now that data_bitmap is 32MiB.

<snip>

> @@ -919,7 +999,7 @@ static int tcmu_configure_device(struct se_device *dev)
>  
>  	info->name = str;
>  
> -	udev->mb_addr = vzalloc(TCMU_RING_SIZE);
> +	udev->mb_addr = vzalloc(CMDR_SIZE);

I'm still concerned about this -- 64M vmalloc'd for cmd ring seems like
too much. (again: what if there are 1000 tcmu backstores?) and is only
needed if data area grows to max size.

<snip>

Very promising, thanks again for doing this work.

Regards -- Andy
