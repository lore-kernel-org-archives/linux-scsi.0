From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: lots and lots of disks again
Date: 16 Feb 2004 19:56:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076979373.1758.688.camel@mulgrave>
References: <20040211145614.GA4010@tpkurt.garloff.de>
	<20040211132848.49eece0d.akpm@osdl.org>
	<20040211220918.GJ4010@tpkurt.garloff.de>
	<20040211142933.484ca978.akpm@osdl.org>
	<20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
	<20040212150035.GN1780@tpkurt.garloff.de>
	<20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk>
	<20040212161800.GU1780@tpkurt.garloff.de>
	<1076604183.2576.89.camel@mulgrave>
	<20040216124047.GG4011@tpkurt.garloff.de>
	<20040216225704.GA3420@pclin040.win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:30387 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264233AbUBQA4k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 19:56:40 -0500
In-Reply-To: <20040216225704.GA3420@pclin040.win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Kurt Garloff <garloff@suse.de>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Mon, 2004-02-16 at 17:57, Andries Brouwer wrote:
> I am not quite sure what you mean.
> In my opinion we must continue supporting the old 16-bit space
> for a long time to come. But can of course do what we want in
> the new space.

The problem is that we cannot have /dev/sda1 at both (8,1) and (1049, 1)
or whatever new major is chosen.

We also need to flip the switch entirely one way or the other for
increased partition numbers since a mixed scheme would be asking for an
admin nightmare.

Thus it makes sense to have a boot time switch for this, for 2.6 it
would be an "opt in" to the new major, for 2.7 it would be an "opt out".

I don't see a reason to keep the old majors hanging around after 2.7 if
this is the chosen solution ... any user application relying on hard
coded device numbers is by definition broken.

> It is not either or, but both.
> Old devices must not change number.

I don't understand this.  The user does not know devices by number but
by device node name (which is chosen by the OS vendor who populated
/dev/ now, or by udev in future).  I agree the node name should not
change, but don't see any reason why the major/minor might not.

James


