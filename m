From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] compile out scsi_ioctl when no SCSI/IDE/etc.  (take 2)
Date: Mon, 4 Apr 2005 15:44:07 +0100
Message-ID: <20050404144407.GG18349@parcelfarce.linux.theplanet.co.uk>
References: <1CFEB358338412458B21FAA0D78FE86D4F0D29@rennsmail02.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9397 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261247AbVDDOoI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2005 10:44:08 -0400
Content-Disposition: inline
In-Reply-To: <1CFEB358338412458B21FAA0D78FE86D4F0D29@rennsmail02.eu.thmulti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fillod Stephane <stephane.fillod@thomson.net>
Cc: Matt Mackall <mpm@selenic.com>, linux-tiny@selenic.com, linux-scsi@vger.kernel.org

On Mon, Apr 04, 2005 at 03:47:01PM +0200, Fillod Stephane wrote:
> --- linux/drivers/ide/ide.c	26 Mar 2005 03:28:17 -0000	1.1.1.2
> +++ linux/drivers/ide/ide.c	4 Apr 2005 13:24:29 -0000
> @@ -1562,9 +1562,11 @@
>  			return 0;
>  		}
>  
> +#ifdef CONFIG_SCSI_IOCTL
>  		case CDROMEJECT:
>  		case CDROMCLOSETRAY:
>  			return scsi_cmd_ioctl(file, bdev->bd_disk, cmd,
> p);
> +#endif
>  
>  		case HDIO_GET_BUSSTATE:
>  			if (!capable(CAP_SYS_ADMIN))

Rather than putting ifdefs in the middle of functions, the normal way is
to define a dummy function:

+++ include/linux/blkdev.h      4 Apr 2005 14:41:23 -0000
@@ -548,7 +548,14 @@ extern int blk_remove_plug(request_queue
 extern void blk_recount_segments(request_queue_t *, struct bio *);
 extern int blk_phys_contig_segment(request_queue_t *q, struct bio *, struct bio *);
 extern int blk_hw_contig_segment(request_queue_t *q, struct bio *, struct bio *);
+#ifdef CONFIG_SCSI_IOCTL
 extern int scsi_cmd_ioctl(struct file *, struct gendisk *, unsigned int, void __user *);
+#else
+static inline int scsi_cmd_ioctl(struct file *f, struct gendisk *g, unsigned int cmd, void __user *ptr)
+{
+       return -ENOTTY;
+}
+#endif
 extern void blk_start_queue(request_queue_t *q);
 extern void blk_stop_queue(request_queue_t *q);
 extern void blk_sync_queue(struct request_queue *q);


(I'm not sure about the error number; ide.c returns -EINVAL if it doesn't
recognise the ioctl, which I think is wrong, it should return -ENOTTY.
OTOH, aren't we supposed to return -ENOSYS for "I recognise this ioctl,
it's supported on this device, but it's not implemented"?  Is there a
good reference for how errnos are supposed to be implemented in kernel?)

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
