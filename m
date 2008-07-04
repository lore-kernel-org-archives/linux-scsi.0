From: Ankita Garg <ankita@in.ibm.com>
Subject: Re: [patch 16/16] lkdtm: fix for CONFIG_SCSI=n
Date: Fri, 4 Jul 2008 12:25:26 +0530
Message-ID: <20080704065526.GD7298@in.ibm.com>
References: <200807040647.m646lYpD017514@imap1.linux-foundation.org>
Reply-To: Ankita Garg <ankita@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:55334 "EHLO
	e28esmtp01.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751262AbYGDKri (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jul 2008 06:47:38 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m64Al6GX030118
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jul 2008 16:17:06 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m64AjnqC860318
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jul 2008 16:15:49 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m64Al5Mx002728
	for <linux-scsi@vger.kernel.org>; Fri, 4 Jul 2008 16:17:06 +0530
Content-Disposition: inline
In-Reply-To: <200807040647.m646lYpD017514@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com

Hi,

On Thu, Jul 03, 2008 at 11:47:34PM -0700, akpm@linux-foundation.org wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix lkdtm test code for case of CONFIG_SCSI=n, to avoid build errors:
> 
> In file included from linux-next-20080618/tests/lkdtm.c:55:
> linux-next-20080618/include/scsi/scsi_cmnd.h:28:25: warning: "BLK_MAX_CDB" is not defined
> linux-next-20080618/include/scsi/scsi_cmnd.h:29:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
> In file included from linux-next-20080618/tests/lkdtm.c:55:
> linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_bidi_cmnd':
> linux-next-20080618/include/scsi/scsi_cmnd.h:183: error: implicit declaration of function 'blk_bidi_rq'
> linux-next-20080618/include/scsi/scsi_cmnd.h:184: error: dereferencing pointer to incomplete type
> linux-next-20080618/include/scsi/scsi_cmnd.h: In function 'scsi_in':
> linux-next-20080618/include/scsi/scsi_cmnd.h:190: error: dereferencing pointer to incomplete type
> make[2]: *** [tests/lkdtm.o] Error 1
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: <ankita@in.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Ankita Garg <ankita@in.ibm.com> 

> ---
> 
>  tests/lkdtm.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff -puN tests/lkdtm.c~lkdtm-fix-for-config_scsi=n tests/lkdtm.c
> --- a/tests/lkdtm.c~lkdtm-fix-for-config_scsi=n
> +++ a/tests/lkdtm.c
> @@ -52,7 +52,9 @@
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/hrtimer.h>
> +#ifdef CONFIG_SCSI
>  #include <scsi/scsi_cmnd.h>
> +#endif
> 
>  #ifdef CONFIG_IDE
>  #include <linux/ide.h>
> @@ -175,12 +177,14 @@ static int jp_hrtimer_start(struct hrtim
>  	return 0;
>  }
> 
> +#ifdef CONFIG_SCSI
>  static int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  {
>  	lkdtm_handler();
>  	jprobe_return();
>  	return 0;
>  }
> +#endif
> 
>  #ifdef CONFIG_IDE
>  int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
> @@ -307,8 +311,12 @@ static int __init lkdtm_module_init(void
>  		lkdtm.entry = (kprobe_opcode_t*) jp_hrtimer_start;
>  		break;
>  	case SCSI_DISPATCH_CMD:
> +#ifdef CONFIG_SCSI
>  		lkdtm.kp.symbol_name = "scsi_dispatch_cmd";
>  		lkdtm.entry = (kprobe_opcode_t*) jp_scsi_dispatch_cmd;
> +#else
> +		printk(KERN_INFO "lkdtm : Crash point not available\n");
> +#endif
>  		break;
>  	case IDE_CORE_CP:
>  #ifdef CONFIG_IDE
> _

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
