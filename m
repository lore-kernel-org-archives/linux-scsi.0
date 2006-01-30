From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] st: cleanup new_tape_buffer
Date: Mon, 30 Jan 2006 21:14:19 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0601302056060.6463@kai.makisara.local>
References: <20060130181941.GA6185@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:45422 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S964892AbWA3TMP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 14:12:15 -0500
In-Reply-To: <20060130181941.GA6185@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, 30 Jan 2006, Christoph Hellwig wrote:

>  - remove superflous forward prototype
>  - remove whitespace before function name
>  - update header comment
>  - remove from_initialization parametes.  It was always 1, but should
>    always be 0 because all callers can sleep

True in 2.6. The other allocations in the only caller (st_probe) could 
also be changed to use GFP_KERNEL.

>  - use kzalloc
>  - remove variable 'got', it was always 0
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: scsi-misc-2.6/drivers/scsi/st.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/st.c	2006-01-30 19:14:29.000000000 +0100
> +++ scsi-misc-2.6/drivers/scsi/st.c	2006-01-30 19:15:13.000000000 +0100
> @@ -180,7 +180,6 @@
>  
>  static int modes_defined;
>  
> -static struct st_buffer *new_tape_buffer(int, int, int);
>  static int enlarge_buffer(struct st_buffer *, int, int);
>  static void normalize_buffer(struct st_buffer *);
>  static int append_to_buffer(const char __user *, struct st_buffer *, int);
> @@ -3574,35 +3573,27 @@
>  
>  

>  
> -/* Try to allocate a new tape buffer. Calling function must not hold
> -   dev_arr_lock. */
> +/* Allocate a new tape buffer. */
>  static struct st_buffer *
> - new_tape_buffer(int from_initialization, int need_dma, int max_sg)
> +new_tape_buffer(int need_dma, int max_sg)

You could remove the newline instead of the blank to put the function 
type and rest of declaration to the same line.

Thanks for the cleanup.

Acked-by: Kai Makisara <Kai.Makisara@kolumbus.fi>

-- 
Kai
