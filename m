From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] remove unused includes and misleading comments from scsi_lib.c
Date: Wed, 20 Nov 2002 08:47:09 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021120084709.A18453@eng2.beaverton.ibm.com>
References: <20021117235449.B9824@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021117235449.B9824@lst.de>; from hch@lst.de on Sun, Nov 17, 2002 at 11:54:49PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 17, 2002 at 11:54:49PM +0100, Christoph Hellwig wrote:

> --- 1.46/drivers/scsi/scsi_lib.c	Thu Nov 14 18:09:17 2002
> +++ edited/drivers/scsi/scsi_lib.c	Sun Nov 17 21:37:05 2002
> @@ -7,50 +7,18 @@
>   *                        of people at Linux Expo.
>   */
>  
> -/*
> - * The fundamental purpose of this file is to contain a library of utility
> - * routines that can be used by low-level drivers.   Ultimately the idea
> - * is that there should be a sufficiently rich number of functions that it
> - * would be possible for a driver author to fashion a queueing function for
> - * a low-level driver if they wished.   Note however that this file also
> - * contains the "default" versions of these functions, as we don't want to
> - * go through and retrofit queueing functions into all 30 some-odd drivers.
> - */
> -
> -#include <linux/module.h>
> -
> -#include <linux/sched.h>
> -#include <linux/timer.h>
>  #include <linux/string.h>
>  #include <linux/slab.h>
>  #include <linux/bio.h>
> -#include <linux/ioport.h>
>  #include <linux/kernel.h>
> -#include <linux/stat.h>
>  #include <linux/blk.h>
> -#include <linux/interrupt.h>
> -#include <linux/delay.h>
> -#include <linux/smp_lock.h>
>  #include <linux/completion.h>
>  
> -
> -#define __KERNEL_SYSCALLS__
> -
> -#include <linux/unistd.h>

I had to add back the smp_lock.h include to compile with CONFIG_PREEMPT,
as kernel_locked was not defined and is used by in_atomic().

Patch against the latest scsi-misc-2.5:

--- 1.48/drivers/scsi/scsi_lib.c	Tue Nov 19 17:13:41 2002
+++ edited/drivers/scsi/scsi_lib.c	Wed Nov 20 08:33:50 2002
@@ -12,6 +12,7 @@
 #include <linux/bio.h>
 #include <linux/kernel.h>
 #include <linux/blk.h>
+#include <linux/smp_lock.h>
 #include <linux/completion.h>
 
 #include "scsi.h"

-- Patrick Mansfield
