From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [regression] CD-DA delay needed after insertion
	(http://bugzilla.kernel.org/show_bug.cgi?id=10974)
Date: Mon, 30 Jun 2008 10:51:42 -0500
Message-ID: <1214841102.3381.5.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0806131352360.2141@vixen.sonytel.be>
	 <1213540781.3517.18.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806161659440.30122@vixen.sonytel.be>
	 <1213648258.3420.12.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806171530340.22840@vixen.sonytel.be>
	 <1214605634.3394.91.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37958 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752072AbYF3Pvs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2008 11:51:48 -0400
In-Reply-To: <Pine.LNX.4.64.0806301120570.10868@vixen.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>

On Mon, 2008-06-30 at 11:25 +0200, Geert Uytterhoeven wrote:
> 	Hi James,
> 
> On Fri, 27 Jun 2008, James Bottomley wrote:
> > > git-bisect taught me it was introduced by
> > > 
> > > commit 38582a62ecd337de4212004c7d4844899dc57890
> > > Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > Date:   Wed Feb 6 13:01:58 2008 -0600
> > > 
> > >     [SCSI] sr: fix test unit ready responses
> > >     
> > >     Commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 updated sr.c to use
> > >     the scsi_test_unit_ready() function.  Unfortunately, this has the
> > >     wrong characteristic of eating NOT_READY returns which sr.c relies on
> > >     for tray status.
> > >     
> > >     Fix by rolling an internal sr_test_unit_ready() that doesn't do this.
> > 
> > OK, I thought I had a test case for this, but when I revert this commit
> > on git head (and fix up the one reject which just leaves the sr_
> > function in place) I still produce the same behaviour.
> > 
> > What I'm trying is 
> > 
> > sg_start -i -l <cdrom>
> > 
> > to close the tray followed by your cdparanoia command
> > 
> > Could you see if reverting this commit on git head works for you (in
> > which case I'm not reproducing it correctly)?
> 
> On 9bedbcb207ed9a571b239231d99c8fd4a34ae24d, the sequence
> 
>     eject; sg_start -i -l /dev/scd0; cdparanoia \
> 	-d /dev/scd0 -Z -q 1-1[:1] /dev/null || echo failed
> 
> fails with
> 
>     004: Unable to read table of contents header
> 
> After reverting 38582a62ecd337de4212004c7d4844899dc57890, it works.
> 
> I added the eject as the PS3 has a slot-loading drive.
> 
> With kind regards,

OK ... but this doesn't happen for me with or without this commit
reverted.  This is what I see from stracing cdparanoia:

lstat64("/dev/scd0", {st_mode=S_IFBLK|0660, st_rdev=makedev(11, 0), ...}) = 0
open("/dev/scd0", O_RDWR|O_NONBLOCK)    = 3
ioctl(3, SG_IO, 0xbfc0afdc)             = -1 EINVAL (Invalid argument)
close(3)                                = 0
open("/dev/scd0", O_RDWR|O_NONBLOCK)    = 3
dup(3)                                  = 4
ioctl(3, CDROMAUDIOBUFSIZ or SCSI_IOCTL_GET_IDLUN, 0xbfc0b240) = 0
ioctl(3, SCSI_IOCTL_GET_BUS_NUMBER, 0xbfc0b248) = 0
ioctl(3, SG_IO, 0xbfc0af8c)             = 0
ioctl(4, SG_EMULATED_HOST, 0xbfc0b2b8)  = 0
ioctl(3, SG_IO, 0xbfc0b07c)             = 0
ioctl(3, SG_IO, 0xbfc0b04c)             = 0
write(2, "004: Unable to read table of con"..., 45004: Unable to read table of contents header) = 45

The O_NONBLOCK tells the cdrom layer not to do drive ready processing.

The three SG_IOs are INQUIRY, MODE_SENSE(10) and READ TOC/PMA/ATIP

The latter one is returned with a check condition and sense data not
ready; medium not present - tray open.

There's no way the drive ready processing can have an effect on this
sequence unless cdparanoia either invokes it from the cdrom layer or
processes the not ready itself.  Could you strace your cdparanoia and
see what sequence it is using?

Thanks,

James



