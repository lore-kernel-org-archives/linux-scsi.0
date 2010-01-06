From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [dm-devel] [PATCH] dm-mpath: Fixing unnecessary argument casting
Date: Wed, 06 Jan 2010 10:38:33 +0900
Message-ID: <4B43E999.70103@ct.jp.nec.com>
References: <E463DF2B2E584B4A82673F53D62C2EF4877BC84E@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41070 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab0AFBnG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2010 20:43:06 -0500
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4877BC84E@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chandra Seetharaman <chandra.seetharaman@us.ibm.com>

Hi,

I have the exact same patch.

On 2010/01/06 3:39 +0900, Moger, Babu wrote:
> This patch removes couple of unnecessary argument casting. There is no functional change with this patch.
> Tested the changes with LSI storage..
> 
> CC: Chandra Seetharaman <chandra.seetharaman@us.ibm.com>
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> ---
> --- linux-2.6.33-rc2/drivers/md/dm-mpath.c.orig	2010-01-05 12:47:26.000000000 -0400
> +++ linux-2.6.33-rc2/drivers/md/dm-mpath.c	2010-01-05 12:34:00.000000000 -0400
> @@ -1128,8 +1128,7 @@ static int pg_init_limit_reached(struct
>  
>  static void pg_init_done(void *data, int errors)
>  {
> -	struct dm_path *path = data;
> -	struct pgpath *pgpath = path_to_pgpath(path);
> +	struct pgpath *pgpath = data;
>  	struct priority_group *pg = pgpath->pg;
>  	struct multipath *m = pg->m;
>  	unsigned long flags;
> @@ -1198,7 +1197,7 @@ static void activate_path(struct work_st
>  		container_of(work, struct pgpath, activate_path);
>  
>  	scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
> -				pg_init_done, &pgpath->path);
> +				pg_init_done, pgpath);
>  }
>  
>  /*

Acked-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>

Thanks,
Kiyoshi Ueda
