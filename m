From: Matthew Wilcox <willy@debian.org>
Subject: Re: 2.6.0 stability and the BK scsi trees
Date: Thu, 16 Oct 2003 14:28:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031016132804.GA18370@parcelfarce.linux.theplanet.co.uk>
References: <1066265974.16761.426.camel@fuzzy> <3F8E8786.2020502@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:31894 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262914AbTJPN2K
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2003 09:28:10 -0400
Content-Disposition: inline
In-Reply-To: <3F8E8786.2020502@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 16, 2003 at 09:56:54PM +1000, Douglas Gilbert wrote:
> What was the point of putting 32 dev_t's into the
> kernel? Many people who were advocating it used
> the increased number of scsi disks (> 256) and
> partitions (from 15 to 63 [to match the ide subsystem])
> as a major reason.
> 
> The sd driver is still littered with hacks to distribute
> its 256 (max) disks over 8 majors. Shouldn't this be
> fixed?

Well, let's see some fixes and then decide whether it's worth merging
before 2.6.0 or after 2.6.0.  We can be sure that vendors will integrate
this patch even if it's not in mainline kernel.org ... and i'd rather
see one variant of the patch which everybody uses than a different one
in RH, SuSE and Linux 2.7.

Here's some things that need to be done ...

 * Maintain backward compatibility for NFS's purposes and on-disc
   representations of /dev.  ie we still need to keep the major numbers
   the same, no question.
 * Come up with a sensible naming scheme.  Is everybody happy with
   /dev/sdabc for discs after #702?  And /dev/sdabcd for discs after #18954?
 * Decide whether we want to sacrifice two bits for increasing the number
   of partitions beyond 15.  I've never personally seen more than 11
   partitions on a single device, and that was a very strange partitioning
   scheme involving mixed BSD disclabels and FAT.
 * If we're seriously considering allocating thousands of scsi discs, I
   guess we'll want a custom slab for them rather than just using kmalloc.
 * Need to get rid of that index bitmap.

We have 16 majors for SCSI currently (and, as discussed above, they need
to be kept the same).  We have 20 bits of minor per major, so in total
we have 16 million minor numbers available to use for discs & their
partitions.  Staying at 15 partitions gives us up to 1 million scsi discs.
At 8 Watts/drive, that's 8 megawatts which would practically require your
own power plant to operate.  So if there's need, I suppose we can grow the
number of partitions which would limit us to a quarter-million discs
(and a mere 2MW of power ;-).

    major     p2    disc2   disc  p1
|............|..|..........|....|....| <- dev_t
 31        20    17       8 7  4 3  0

This layout makes sense to me, let me explain it ;-)

partitions 0-15 fit in p1.  Overflow into p2 (bits 18 & 19) for partitions
16-63.

discs are allocated as:

0-15 in sd_major(0), 16-31 in sd_major(1), ... , 240-255 in sd_major(15)
256-16639 in sd_major(0), 16640-33023 in sd_major(1), ...

Stop explaining and give us the code, I hear you cry.  I guess it's ...

unsigned int dev_to_sd_nr(unsigned int dev) {
	return	((dev >> 4) & 15) | (inv_sd_major(dev >> 20) << 4) |
		(dev & 0x3ff00);
}

unsigned int dev_to_sd_part(unsigned int dev) {
	return	(dev & 15) | ((dev >> 14) & 0x30);
}

unsigned int make_sd_dev(unsigned int sd_nr, unsigned int part) {
	return	(part & 0xf) | ((part & 0x30) << 14) | ((dev & 0xf) << 4) |
		(sd_major(dev & 0xf0) << 20) | (dev & 0x3ff00);
}

Everybody happy with this?  Didn't think so.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
