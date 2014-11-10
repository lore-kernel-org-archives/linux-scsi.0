From: Andras Kovacs <akovacs@fixstars.com>
Subject: Re: UNMAP command parameter list
Date: Mon, 10 Nov 2014 18:10:23 +0000 (UTC)
Message-ID: <loom.20141110T190036-243@post.gmane.org>
References: <loom.20141108T001847-741@post.gmane.org> <94D0CD8314A33A4D9D801C0FE68B40295937B4CE@G4W3202.americas.hpqcorp.net> <loom.20141108T211736-836@post.gmane.org> <loom.20141110T164410-58@post.gmane.org> <yq17fz36m4o.fsf@sermon.lab.mkp.net> <20141110174043.GA26944@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53825 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaKJSKf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 13:10:35 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1XntQ9-00042b-N0
	for linux-scsi@vger.kernel.org; Mon, 10 Nov 2014 19:10:34 +0100
Received: from S0106602ad06f2965.gv.shawcable.net ([24.68.136.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2014 19:10:33 +0100
Received: from akovacs by S0106602ad06f2965.gv.shawcable.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2014 19:10:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Christoph Hellwig <hch <at> infradead.org> writes:

> 
> On Mon, Nov 10, 2014 at 11:44:39AM -0500, Martin K. Petersen wrote:
> > You'll have to traverse scatterlist and extract the descriptor from
> > there. You can use scsi_for_each_sg() to walk the list.

  Thank you; I'm working on it.

> > 
> > If you only care about in-kernel discards it's pretty easy since we only
> > issue a single descriptor. If you want to support arbitrary block pc
> > UNMAP commands you'll have to be able to deal with multiple descriptors
> > across multiple scatterlist elements. But the accessor macro makes that
> > easy so I suggest you take that approach.
> 
> Note that if the hardware doesn't actually implement UNMAP and you have
> to emulate something you're probably better off emulating WRITE SAME
> (16) with the UNMAP bit, as the format is a lot easier to handle,
> and it's much better specified to start with.

  Actually, my case is that the HW (at least in its current iteration)
doesn't support WRITE SAME but does support UNMAP. But it seems that the
discard option given to ext4 at mount time is "ineffective" in the sense of
not keeping up a high write transfer rate to the device (it looks like write
amplification is happening, something which discard -- and UNMAP -- ought to
preempt). So now I'm writing code to 'debug' the UNMAP commands which get
passed to the device.


