From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Mon, 23 Feb 2004 13:52:51 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402231329480.1749@kai.makisara.local>
References: <403512B8.2060403@ics.uci.edu> <4036867C.60803@ics.uci.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep22-0.kolumbus.fi ([193.229.0.60]:931 "EHLO
	fep22-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261915AbUBWLwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2004 06:52:53 -0500
In-Reply-To: <4036867C.60803@ics.uci.edu>
List-Id: linux-scsi@vger.kernel.org
To: Joachim Feise <jfeise@ics.uci.edu>
Cc: linux-scsi@vger.kernel.org, Michael Guntsche <mike@it-loops.com>, Andrew Morton <akpm@osdl.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Frank Pieczynski <pieczy@web.de>, Jens Axboe <axboe@suse.de>

Please trim the cc list as appropriate. I am including all of the people 
from the various messages related to probably one problem to get all of us 
on the same track. Jens is included because he might directly see a 
solution.

On Fri, 20 Feb 2004, Joachim Feise wrote:

> Joachim Feise wrote on 2/19/2004 11:47:
> 
> > [1.] One line summary of the problem:
> > 2.6.3 hangs when writing to scsi-dvd
> > 
> > [2.] Full description of the problem/report:
> > 
> > I have a DVD drive (BTC1004) connected via an IDE-SCSI bridge to
> > an Adaptec 29160 host adapter.
> > With kernel 2.6.3, I experience a complete system hang whenever I try
> > to record data on a DVD.
> > It requires a reboot.
> 
> More info:
> on the cdwrite list, somebody reported a similar problem
> (http://lists.debian.org/cdwrite/2004/cdwrite-200402/msg00081.html)
> 
> His quick-n-dirty fix works for me:
> 
> --- linux-2.6.3/drivers/scsi/scsi_lib.c.orig    2004-02-17 19:57:57.000000000 -0800
> +++ linux-2.6.3/drivers/scsi/scsi_lib.c 2004-02-20 13:52:46.000000000 -0800
> @@ -1292,7 +1292,7 @@
>          * host adapters.  A host driver can alter this mask in its
>          * slave_alloc() or slave_configure() callback if necessary.
>          */
> -       blk_queue_dma_alignment(q, (8 - 1));
> +       /* blk_queue_dma_alignment(q, (8 - 1)); */
> 
>         if (!shost->use_clustering)
>                 clear_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
> 
> But without knowing what this particular line does, it is impossible for me
> to say if commenting out the line is the right thing to do.
> 
This line has has several duties. For me, it sets the alignment constaint 
used by st for deciding whether to use direct i/o or internal buffer. For 
other people more important is that it is used for similar purpose in 
linux/fs/bio.c. The beginning of __bio_map_user contains the following:

        /*
         * transfer and buffer must be aligned to at least hardsector
         * size for now, in the future we can relax this restriction
         */
        if ((uaddr & queue_dma_alignment(q)) || (len & queue_dma_alignment(q)))
                return NULL;

Without the call to blk_queue_alignment() in scsi_lib.c, the queue 
alignment is to 512 byte boundary and the transfer size must be a multiple 
of 512 bytes. With the calls, the unit is 8 bytes.

The function sg_io in linux/drivers/scsi/scsi_ioctl.c contains this:

                /*
                 * first try to map it into a bio. reading from device will
                 * be a write to vm.
                 */
                bio = bio_map_user(q, NULL, (unsigned long) hdr->dxferp,
                                   hdr->dxfer_len, reading);

                /*
                 * if bio setup failed, fall back to slow approach
                 */
                if (!bio) {

bio_map_user() calls __bio_map_user() and so the previous conditions are 
used in sg_io() to decide on bouncing.

I made a test program that uses sg_io() to send a command to a SCSI 
device. I tested it with a SCSI tape device. Without any changes the 
program hung. The SCSI driver was sym53c8xx_2 and it loops on the 
following error:

Feb 23 13:24:17 box kernel: sym1:5:0:extraneous data discarded.
Feb 23 13:24:17 box kernel: sym1:5:0:COMMAND FAILED (87 0 1).
Feb 23 13:24:17 box kernel: SCSI error : <1 0 5 0> return code = 0x70000

The I modified the program to align the buffer to 512 byte boundary. This 
did not help. The next step was to set the transfer size to 512 bytes. 
This helps!! Restoring the non-512 byte alignment did not cause any 
problems.

The conclusion at this phase is that _the tranfer length in bio must be a 
multiple of 512 bytes_.

I hope someone sees no where the real problem is.

-- 
Kai
