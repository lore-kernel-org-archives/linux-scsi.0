From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Mon, 11 Aug 2003 17:29:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308111729.04184.gene.heskett@verizon.net>
References: <20030810224402.5c7fa063.rddunlap@osdl.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out002pub.verizon.net ([206.46.170.141]:7918 "EHLO
	out002.verizon.net") by vger.kernel.org with ESMTP id S272910AbTHKV3F
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Aug 2003 17:29:05 -0400
In-Reply-To: <20030810224402.5c7fa063.rddunlap@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: rddunlap@osdl.org, willy@debian.org

On Monday 11 August 2003 01:44, Randy.Dunlap wrote:
>Gene,
>
>This patch should make the advansys driver build on 2.6.0-test3
>after you #define ADVANSYS_DEBUG so that run-time debug output
>can be generated.
>
>--

Ok Randy, I have some logs, stripped down to about 1650 lines from 
just under half a million.

Should I send them privately?

>~Randy
>
>
>patch_name:	scsi_advan_260t3.patch
>patch_version:	2003-08-10.22:37:15
>author:		Randy.Dunlap <rddunlap@osdl.org>
>description:	enable compile with ADVANSYS_DEBUG #defined
>product:	Linux
>product_versions: linux-260-test3
>maintainer:	unknown
>diffstat:	=
> drivers/scsi/advansys.c |   13 +++++++------
> 1 files changed, 7 insertions(+), 6 deletions(-)
>
>
>diff -Naur ./drivers/scsi/advansys.c~advan ./drivers/scsi/advansys.c
>--- ./drivers/scsi/advansys.c~advan	2003-08-08 21:34:08.000000000
> -0700 +++ ./drivers/scsi/advansys.c	2003-08-10 22:34:51.000000000
> -0700 @@ -826,6 +826,7 @@
>
> /* Enable driver tracing. */
> /* #define ADVANSYS_DEBUG */
>+#define ADVANSYS_DEBUG
>
>
> /*
>@@ -6360,8 +6361,8 @@
>     } else {
> 	scsi_adjust_queue_depth(device, 0, device->host->cmd_per_lun);
>     }
>-    ASC_DBG3(1, "advansys_slave_configure: shp 0x%lx, id %d, depth
> %d\n", -            (ulong) shp, device->id, device->queue_depth);
> +    ASC_DBG4(1, "advansys_slave_configure: device 0x%lx, boardp
> 0x%lx, id %d, depth %d\n", +            (ulong) device, (ulong)
> boardp, device->id, device->queue_depth); return 0;
> }
>
>@@ -9352,8 +9353,8 @@
>
>     printk("Scsi_Host at addr 0x%lx\n", (ulong) s);
>     printk(
>-" next 0x%lx, host_busy %u, host_no %d, last_reset %d,\n",
>-        (ulong) s->next, s->host_busy, s->host_no,
>+" host_busy %u, host_no %d, last_reset %d,\n",
>+        s->host_busy, s->host_no,
>         (unsigned) s->last_reset);
>
> #if ASC_LINUX_KERNEL24
>@@ -9397,8 +9398,8 @@
>
>     printk(
> " host 0x%lx, device 0x%lx, target %u, lun %u, channel %u,\n",
>-        (ulong) s->host, (ulong) s->device, s->target, s->lun,
>-        s->channel);
>+        (ulong) s->device->host, (ulong) s->device, s->device->id,
> s->device->lun, +        s->device->channel);
>
>     asc_prt_hex(" CDB", s->cmnd, s->cmd_len);

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

