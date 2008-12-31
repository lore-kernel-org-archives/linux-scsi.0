From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix sg_io_hdr.info corruption.
Date: Wed, 31 Dec 2008 01:15:47 -0800
Message-ID: <20081231011547.745e579d.akpm@linux-foundation.org>
References: <20081228144946.30288.67559.stgit@zaytsev.su>
	<20081230154603.4fd60167.akpm@linux-foundation.org>
	<20081231180759X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbYLaJQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2008 04:16:03 -0500
In-Reply-To: <20081231180759X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: alexey.zaytsev@gmail.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Wed, 31 Dec 2008 18:08:02 +0900 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 30 Dec 2008 15:46:03 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 28 Dec 2008 17:50:35 +0300
> > Alexey Zaytsev <alexey.zaytsev@gmail.com> wrote:
> > 
> > > sizeof(unsigned (short)) is actually sizeof(function), == 1.
> > > Spotted by sparse.
> > > 
> > > Signed-off-by: Alexey Zaytsev <alexey.zaytsev@gmail.com>
> > > ---
> > >  fs/compat_ioctl.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
> > > index 5235c67..7c2d617 100644
> > > --- a/fs/compat_ioctl.c
> > > +++ b/fs/compat_ioctl.c
> > > @@ -784,7 +784,7 @@ static int sg_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
> > >  
> > >  	if (copy_in_user(&sgio->status, &sgio32->status,
> > >  			 (4 * sizeof(unsigned char)) +
> > > -			 (2 * sizeof(unsigned (short))) +
> > > +			 (2 * sizeof(unsigned short)) +
> > >  			 (3 * sizeof(int))))
> > >  		return -EFAULT;
> > 
> > gack.
> > 
> > akpm:/home/akpm> cat t.c
> > main()
> > {
> > 	        printf("%d\n", sizeof(unsigned (short)));
> > 	        printf("%d\n", sizeof(unsigned short));
> > }
> > akpm:/home/akpm> ./a.out
> > 1
> > 2
> > 
> > 
> > the code has been like this for years and years.  Why hasn't anyone
> > noticed?  
> 
> The members from 'status' in struct sg_io_hdr to the last are used to
> transfer information from kernel to user space. The values that user
> space sets are just ignored.

OK.

> typedef struct sg_io_hdr
> {
>     int interface_id;           /* [i] 'S' for SCSI generic (required) */
>     int dxfer_direction;        /* [i] data transfer direction  */
>     unsigned char cmd_len;      /* [i] SCSI command length ( <= 16 bytes) */
>     unsigned char mx_sb_len;    /* [i] max length to write to sbp */
>     unsigned short iovec_count; /* [i] 0 implies no scatter gather */
>     unsigned int dxfer_len;     /* [i] byte count of data transfer */
>     void __user *dxferp;	/* [i], [*io] points to data transfer memory
> 					      or scatter gather list */
>     unsigned char __user *cmdp; /* [i], [*i] points to command to perform */
>     void __user *sbp;		/* [i], [*o] points to sense_buffer memory */
>     unsigned int timeout;       /* [i] MAX_UINT->no timeout (unit: millisec) */
>     unsigned int flags;         /* [i] 0 -> default, see SG_FLAG... */
>     int pack_id;                /* [i->o] unused internally (normally) */
>     void __user * usr_ptr;      /* [i->o] unused internally */
>     unsigned char status;       /* [o] scsi status */
>     unsigned char masked_status;/* [o] shifted, masked scsi status */
>     unsigned char msg_status;   /* [o] messaging level data (optional) */
>     unsigned char sb_len_wr;    /* [o] byte count actually written to sbp */
>     unsigned short host_status; /* [o] errors from host adapter */
>     unsigned short driver_status;/* [o] errors from software driver */
>     int resid;                  /* [o] dxfer_len - actual_transferred */
>     unsigned int duration;      /* [o] time taken by cmd (unit: millisec) */
>     unsigned int info;          /* [o] auxiliary information */
> } sg_io_hdr_t;  /* 64 bytes long (on i386) */

So if for some reason the kernel doesn't write to .info, we'll leak two
bytes of kernel memory. 

