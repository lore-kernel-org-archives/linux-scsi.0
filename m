From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] sg driver against lk 2.6.6
Date: Fri, 4 Jun 2004 08:21:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040604082107.A20637@beaverton.ibm.com>
References: <20040502214525.5ad05bed.akpm@osdl.org> <20040503122948.GI2281@parcelfarce.linux.theplanet.co.uk> <20040503203512.GP2281@parcelfarce.linux.theplanet.co.uk> <40A36286.4020604@torque.net> <40A6D00D.7070306@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:31986 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S265790AbUFDPVv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jun 2004 11:21:51 -0400
Content-Disposition: inline
In-Reply-To: <40A6D00D.7070306@torque.net>; from dougg@torque.net on Sun, May 16, 2004 at 12:21:01PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>, James.Bottomley@steeleye.com
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

James -

Is this patch in your queue?

I tried it out, and it worked fine for me with up to 16k of scsi_debug
devices.

-- Patrick Mansfield

On Sun, May 16, 2004 at 12:21:01PM +1000, Douglas Gilbert wrote:
> subject was: 2.6.6-rc3 ia64 smp_call_function() called with
>               interrupts disabled
> 
> Douglas Gilbert wrote:
> > Matthew Wilcox wrote:
> <snip>
> >>
> >> Does anybody like this patch?  It survived booting on my test box which
> >> only has one scsi device.  More testing welcomed.
> > 
> > 
> > Sorry, I missed this thread. The change looks good and survived
> > about one hour of scsi_debug bashing (on i386). I also checked
> > it against the previous version.
> > 
> > Attached is my version with only a superficial change to 2
> > printk()s plus:
> >   - bump version number
> >   - introduce MODULE_VERSION
> >   - increase over allocation of sg_dev_arr from 6 to 32
> 
> Here are some further refinements to this patch with help
> from Pat Mansfield:
>      - replace vmalloc() with kmalloc(,GFP_KERNEL)
>      - bump max sg devices from 8192 to 32768
> 
> Tested to 16k devices (and 8k devices on a box with 512MB
> ram), Patch is against lk 2.6.6 (or 2.6.6-bk1).
> 
> Doug Gilbert
> 

> --- linux/drivers/scsi/sg.c	2004-05-10 23:08:46.000000000 +1000
> +++ linux/drivers/scsi/sg.c266mw3	2004-05-16 11:55:07.000000000 +1000
> @@ -7,7 +7,7 @@
>   * Original driver (sg.c):
>   *        Copyright (C) 1992 Lawrence Foard
>   * Version 2 and 3 extensions to driver:
> - *        Copyright (C) 1998 - 2002 Douglas Gilbert
> + *        Copyright (C) 1998 - 2004 Douglas Gilbert
>   *
>   *  Modified  19-JAN-1998  Richard Gooch <rgooch@atnf.csiro.au>  Devfs support
>   *
> @@ -17,27 +17,18 @@
>   * any later version.
>   *
>   */
> -#include <linux/config.h>
> -static int sg_version_num = 30530;	/* 2 digits for each component */
> +
> +static int sg_version_num = 30531;	/* 2 digits for each component */
> +#define SG_VERSION_STR "3.5.31"
> +
>  /*
>   *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
>   *      - scsi logging is available via SCSI_LOG_TIMEOUT macros. First
>   *        the kernel/module needs to be built with CONFIG_SCSI_LOGGING
>   *        (otherwise the macros compile to empty statements).
> - *        Then before running the program to be debugged enter:
> - *          # echo "scsi log timeout 7" > /proc/scsi/scsi
> - *        This will send copious output to the console and the log which
> - *        is usually /var/log/messages. To turn off debugging enter:
> - *          # echo "scsi log timeout 0" > /proc/scsi/scsi
> - *        The 'timeout' token was chosen because it is relatively unused.
> - *        The token 'hlcomplete' should be used but that triggers too
> - *        much output from the sd device driver. To dump the current
> - *        state of the SCSI mid level data structures enter:
> - *          # echo "scsi dump 1" > /proc/scsi/scsi
> - *        To dump the state of sg's data structures use:
> - *          # cat /proc/scsi/sg/debug
>   *
>   */
> +#include <linux/config.h>
>  #include <linux/module.h>
>  
>  #include <linux/fs.h>
> @@ -51,7 +42,6 @@
>  #include <linux/fcntl.h>
>  #include <linux/init.h>
>  #include <linux/poll.h>
> -#include <linux/vmalloc.h>
>  #include <linux/smp_lock.h>
>  #include <linux/moduleparam.h>
>  #include <linux/devfs_fs_kernel.h>
> @@ -69,7 +59,7 @@
>  
>  #ifdef CONFIG_SCSI_PROC_FS
>  #include <linux/proc_fs.h>
> -static char *sg_version_str = "3.5.30 [20040124]";
> +static char *sg_version_date = "20040516";
