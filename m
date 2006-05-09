From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] make kernel ignore bogus partitions
Date: Tue, 9 May 2006 12:41:38 -0700
Message-ID: <20060509124138.43e4bac0.akpm@osdl.org>
References: <20060503210055.GB31048@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750853AbWEITm3@vger.kernel.org>
In-Reply-To: <20060503210055.GB31048@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, aeb@cwi.nl
List-Id: linux-scsi@vger.kernel.org

"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
>
> Patch 1/1
> Sometimes partitions claim to be larger than the reported capacity of a
> disk device. This patch makes the kernel ignore those partitions.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> Signed-off-by: Stephen Cameron <steve.cameron@hp.com>
> 
> Please consider this for inclusion.
> 
> 
>  fs/partitions/check.c |    5 +++++
>  1 files changed, 5 insertions(+)
> 
> --- linux-2.6.14/fs/partitions/check.c~partition_vs_capacity	2006-01-06 09:32:14.000000000 -0600
> +++ linux-2.6.14-root/fs/partitions/check.c	2006-01-06 11:24:50.000000000 -0600
> @@ -382,6 +382,11 @@ int rescan_partitions(struct gendisk *di
>  		sector_t from = state->parts[p].from;
>  		if (!size)
>  			continue;
> +		if (from+size-1 > get_capacity(disk)) {
> +			printk(" %s: p%d exceeds device capacity, ignoring.\n", 
> +				disk->disk_name, p);
> +			continue;
> +		}
>  		add_partition(disk, p, from, size);
>  #ifdef CONFIG_BLK_DEV_MD
>  		if (state->parts[p].flags)

Shouldn't that be

	if (from+size > get_capacity(disk)) {

?
