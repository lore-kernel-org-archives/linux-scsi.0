From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: lots and lots of disks again
Date: 17 Feb 2004 10:18:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077031099.1757.24.camel@mulgrave>
References: <20040211220918.GJ4010@tpkurt.garloff.de>
	<20040211142933.484ca978.akpm@osdl.org>
	<20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
	<20040212150035.GN1780@tpkurt.garloff.de>
	<20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk>
	<20040212161800.GU1780@tpkurt.garloff.de>
	<1076604183.2576.89.camel@mulgrave>
	<20040216124047.GG4011@tpkurt.garloff.de>
	<20040216225704.GA3420@pclin040.win.tue.nl>
	<1076979373.1758.688.camel@mulgrave>
	<20040217144959.GA4282@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:3464 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264454AbUBQPTY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 10:19:24 -0500
In-Reply-To: <20040217144959.GA4282@pclin040.win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Kurt Garloff <garloff@suse.de>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Tue, 2004-02-17 at 09:49, Andries Brouwer wrote:
> On Mon, Feb 16, 2004 at 07:56:10PM -0500, James Bottomley wrote:
> > We also need to flip the switch entirely one way or the other for
> > increased partition numbers since a mixed scheme would be asking for an
> > admin nightmare.
> 
> Why would that be?
> 
> Suppose /dev/sdAA is (1049,0) and has 256 partitions.
> And /dev/sda is (8,0) and has 16 partitions.
> Where is the nightmare?

You're kidding, right?

Think of the code paths: at the moment we tell the gendisk the number of
minors we need when we register it.  It then probes the partition tables
and fills in the values.  If we have a large partition major, we need to
know *before* we call add_disk().  The only thing that determines this
is the on disc partitioning scheme, so now you need to know the
partition type before you register the gendisk.  This type of layering
violation is a sure sign of a bad design.

Even assuming we can come up with a clean coding solution that doesn't
cause everyone to blow chunks when reading it, think what you've done to
the administrator of the system:  Accidentally repartition a drive with
a big partition table and it migrates majors and device names.  Also,
our device node assignment now isn't simply discovery order, it's
partition type order followed by discovery order.

The correct way to solve this is an all or nothing migration gated by a
boot time flag.

James


