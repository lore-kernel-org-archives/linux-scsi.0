From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH]: Fix old SCSI adapter crashes with CD-ROM (take 2)
Date: Tue, 8 May 2007 18:52:58 +0200
Message-ID: <20070508165258.GE4163@kernel.dk>
References: <20070508171710.1ac730cd@the-village.bc.nu> <20070508161444.GA4163@kernel.dk> <1178642376.3737.36.camel@mulgrave.il.steeleye.com> <4640A972.3010108@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:36162 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966168AbXEHQz2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 12:55:28 -0400
Content-Disposition: inline
In-Reply-To: <4640A972.3010108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org

On Tue, May 08 2007, Mike Christie wrote:
> James Bottomley wrote:
> > On Tue, 2007-05-08 at 18:14 +0200, Jens Axboe wrote:
> >> On Tue, May 08 2007, Alan Cox wrote:
> >>> The CD-ROM layer doesn't bounce requests for old ISA controllers (and
> >>> nor should it). However they get injected into the SCSI layer via
> >>> sr_ioctl which also doesn't bounce them and SCSI then passes the buffer
> >>> along to a device with unchecked_isa_dma set which either panics or
> >>> truncates the buffer to 24bits.
> >>>
> >>> According to Jens the right long term fix is for the CD layer to route
> >>> the requests differently but in the mean time this has been tested by a
> >>> victim and verified to sort the problem out. For the other 99.9% of users
> >>> it's a no-op and doesn't bounce data.
> >>>
> >>> Signed-off-by: Alan Cox <alan@redhat.com>
> >> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> >>
> >> Christoph passed me his patch to get rid of ->generic_packet() in the
> >> cdrom layer, so the work is almost complete. This patch is fine as a
> >> work-around until that gets merged, though.
> > 
> > Actually, I think the new scsi request infrastructure should be doing
> > the bouncing (rather than have it done in each problem path we
> > discover).
> > 
> > Mike Christie tells me we're missing bouncing by accident in the
> > scsi_execute path (but not the scsi_execute_async path).  He says this
> > is the fix he proposed:
> > 
> > http://marc.info/?l=linux-scsi&m=115981479822790&w=2
> > 
> 
> Hey Jens and James, one thing I forgot to mention is that I could not
> remember if I needed an extra bio_get in there. I thought I did not
> because the caller is not touching the bio after the bio_endio calls
> like is done with the blk/bio_map_user path. But I did that patch so
> long ago I do not remember now.

If you don't touch it after bio_endio(), then you don't need to hold an
extra reference to it. I'll add your patch.

-- 
Jens Axboe

