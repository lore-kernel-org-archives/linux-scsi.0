From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] st.c: possible memory use after free after MTSETBLK
 ioctl
Date: Fri, 25 Sep 2009 22:15:02 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.0909252203330.6291@kai.makisara.local>
References: <2123868472.308991253824360715.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:52866 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZIYTYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Sep 2009 15:24:14 -0400
In-Reply-To: <2123868472.308991253824360715.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Jeffery <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 24 Sep 2009, David Jeffery wrote:

> A memory use after free bug can manifest if the MTSETBLK or SET_DENS_AND_BLK
> ioctl features are used to set the tape's blocksize from 0 to non-zero.
> After the driver sets the new block size, in this one case it calls
> normalize_buffer() to free the device's internal data buffers.  However, the
> ioctl code assumes there is always a buffer and does not check or allocate
> a buffer if there isn't one.  So any following ioctl calls can corrupt
> a part of memory by writing data to memory that the st driver had freed.
> 
> This small patch forces the st driver to allocate a minimal one page buffer
> using enlarge_buffer() after the previous buffers were freed.
> 
> 
> Signed-of-by: David Jeffery <djeffery@redhat.com>
> 
> 
> --- a/drivers/scsi/st.c	2009-09-24 12:34:14.000000000 -0400
> +++ b/drivers/scsi/st.c	2009-09-23 22:10:17.000000000 -0400
> @@ -2776,8 +2776,12 @@
>  			int old_block_size = STp->block_size;
>  			STp->block_size = arg & MT_ST_BLKSIZE_MASK;
>  			if (STp->block_size != 0) {
> -				if (old_block_size == 0)
> +				if (old_block_size == 0){
>  					normalize_buffer(STp->buffer);
> +					if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
> +						printk(KERN_ERR "No st buffer!\n");
> +					}
> +				}
>  				(STp->buffer)->buffer_blocks =
>  				    (STp->buffer)->buffer_size / STp->block_size;
>  			}

Good catch. This bug probably has not manifested itself because the next 
commands have either been ioctls not needing a buffer or a read/write that 
has enlarged the buffer.

The patch has one problem: it prints an error if the page can't be 
allocated but it does not do prevent using a non-allocated buffer in this 
case. Although this is a nearly theoretical possibility, it should be 
handled in some way. At least a comment should be added.

Is the patch against a current kernel? The line numbers don't match either 
2.6.30 or 2.6.31?

Thanks,
Kai


