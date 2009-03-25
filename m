From: Bill Nottingham <notting@redhat.com>
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Date: Wed, 25 Mar 2009 15:47:56 -0400
Message-ID: <20090325194756.GA26465@nostromo.devel.redhat.com>
References: <1238007647-25752-1-git-send-email-notting@redhat.com> <20090325190137.GA8509@infradead.org> <20090325190321.GB25176@nostromo.devel.redhat.com> <20090325192653.GS14127@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55662 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699AbZCYTsK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Mar 2009 15:48:10 -0400
Content-Disposition: inline
In-Reply-To: <20090325192653.GS14127@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Matthew Wilcox (matthew@wil.cx) said: 
> On Wed, Mar 25, 2009 at 03:03:21PM -0400, Bill Nottingham wrote:
> > Then where is a better place to put this, as scsi_wait_scan.ko is
> > a ridiculous interface for userspace?
> 
> It would be nice if people would comment on "ridiculous interface"s when
> they're asked for feedback, instead of waiting more than two years.

Sure, but asking all people who might eventually have to use it
to always watch any possible interface addition isn't practical.

I would have hoped that the fact that the interface required loading
a module and immediately removing it by hand is suboptimal enough
that it wouldn't have gotten in in the first place.

> I think you're misunderstanding how to use scsi_wait_scan.  The idea was
> that the bit of userspace that probes all the device drivers would do:
> 
> modprobe fusion.ko
> modprobe aic79xx.ko
> modprobe sym53c8xx.ko
> modprobe scsi_wait_scan
> rmmod scsi_wait_scan
> 
> et voila, you're done.  It seems like you want random other bits of
> userspace to wait for scsi scanning to be done, and that wasn't the
> original intent.

Well, in the case I'm looking at, udev is what's loading the host
controllers, and there needs to be some sort of synchronization point
between that and LVM invocations, fsck, mount, etc. Since scans
aren't sent over as events for udev to catch, 'udevadm settle'
isn't enough. Removing, loading, and removing scsi_wait_scan works
here, but it just seems like a kludge.

I can trigger a load of scsi_wait_scan when hosts are registered
in udev, but that's still ugly, and sort of overkill.

Bill
