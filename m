From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: lots and lots of disks again
Date: Tue, 17 Feb 2004 16:50:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217155024.GB4282@pclin040.win.tue.nl>
References: <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de> <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave> <20040216124047.GG4011@tpkurt.garloff.de> <20040216225704.GA3420@pclin040.win.tue.nl> <1076979373.1758.688.camel@mulgrave> <20040217144959.GA4282@pclin040.win.tue.nl> <1077031099.1757.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kweetal.tue.nl ([131.155.3.6]:16137 "EHLO kweetal.tue.nl")
	by vger.kernel.org with ESMTP id S266340AbUBQRng (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 12:43:36 -0500
Content-Disposition: inline
In-Reply-To: <1077031099.1757.24.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, Kurt Garloff <garloff@suse.de>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Tue, Feb 17, 2004 at 10:18:07AM -0500, James Bottomley wrote:
> On Tue, 2004-02-17 at 09:49, Andries Brouwer wrote:
> > On Mon, Feb 16, 2004 at 07:56:10PM -0500, James Bottomley wrote:
> > > We also need to flip the switch entirely one way or the other for
> > > increased partition numbers since a mixed scheme would be asking for an
> > > admin nightmare.
> > 
> > Why would that be?
> > 
> > Suppose /dev/sdAA is (1049,0) and has 256 partitions.
> > And /dev/sda is (8,0) and has 16 partitions.
> > Where is the nightmare?
> 
> You're kidding, right?

I was not.

> Think of the code paths: at the moment we tell the gendisk the number of
> minors we need when we register it.  It then probes the partition tables
> and fills in the values.  If we have a large partition major, we need to
> know *before* we call add_disk().  The only thing that determines this
> is the on disc partitioning scheme, so now you need to know the
> partition type before you register the gendisk.  This type of layering
> violation is a sure sign of a bad design.

Ah, you think that I want to assign the name depending on what one finds
on the disk. That was not my intention at all. After all, we bought the disk
and it had no partition table. Should it shift major when it is partitioned?

> The correct way to solve this is an all or nothing migration gated by a
> boot time flag.

Yes, I was also thinking of boot time flags, but not all-or-nothing.
Almost nobody actually needs these five thousand disks, and programs
like LILO know about major 8, so I can even imagine that someone with
lots of disks would like the boot disk to remain sda (8,0) even when
all the others become (1049,*)-(1073,*).

Then what is the boot parameter? I don't know. Anything.
Say, scsi-legacy=sda,sdb,sde.

Andries
