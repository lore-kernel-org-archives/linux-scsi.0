From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: PS3 Storage Driver O_DIRECT issue
Date: Wed, 18 Jul 2007 19:57:56 +0200
Message-ID: <20070718175756.GC11657@kernel.dk>
References: <20070704132212.726923000@pademelon.sonytel.be> <20070713122752.GA854@aepfle.de> <Pine.LNX.4.62.0707181808030.15632@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:15237 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761032AbXGRR6V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 13:58:21 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0707181808030.15632@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Olaf Hering <olaf@aepfle.de>, Paul Mackerras <paulus@samba.org>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, Alessandro Rubini <rubini@ipvvis.unipv.it>, Geoff Levand <geoffrey.levand@am.sony.com>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, Jul 18 2007, Geert Uytterhoeven wrote:
> On Fri, 13 Jul 2007, Olaf Hering wrote:
> > This driver (or the generic PS3 code) has appearently problems with
> > O_DIRECT. 
> > glibc aborts parted because the malloc metadata get corrupted. While it
> > is reproducible, the place where it crashes changes with every version
> > of the debug attempt.
> > I dont have a handle right now, all I know is that the metadata after a
> > malloc area get overwritten with zeros.
> > 
> > 
> > Can you have a look at this? 
> > parted /dev/ps3da
> > print (a few times)
> 
> I could reproduce it with parted 1.8.0 and later.
> 
> The patch below fixes it (tested with 1.8.0, 1.8.2 (FC6), 1.9.0 (git)).
> 
> Apparently sometimes bio_cur_sectors(bio)*KERNEL_SECTOR_SIZE != bvec->bv_len
> when using O_DIRECT. Is that true (or a bug?)?
> 
> If it's OK, I'll fold this patch into the main ps3disk patch.

The bug is in your code - you iterate the bio segments, but always
reference the current one. Which of course makes no sense, you may as
well just kill the loop in that case, the code would be the same.

-- 
Jens Axboe

