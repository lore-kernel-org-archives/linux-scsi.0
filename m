From: Bill Nottingham <notting@redhat.com>
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Date: Thu, 26 Mar 2009 10:47:16 -0400
Message-ID: <20090326144716.GA5696@nostromo.devel.redhat.com>
References: <1238007647-25752-1-git-send-email-notting@redhat.com> <20090325190137.GA8509@infradead.org> <20090325190321.GB25176@nostromo.devel.redhat.com> <20090325192653.GS14127@parisc-linux.org> <20090325194756.GA26465@nostromo.devel.redhat.com> <20090325203624.GT14127@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:47039 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbZCZOr2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 10:47:28 -0400
Content-Disposition: inline
In-Reply-To: <20090325203624.GT14127@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, pjones@redhat.com

Matthew Wilcox (matthew@wil.cx) said: 
> > Sure, but asking all people who might eventually have to use it
> > to always watch any possible interface addition isn't practical.
> 
> Right.  I asked several people at Red Hat about the interface and I got a
> "yeah, OK, whatever" kind of response.  Clearly you need to educate your
> colleagues to pass these kinds of interface questions along to you.

Heh. Of course, I suspect many of them and I wouldn't see eye-to-eye
in any case.

> > Well, in the case I'm looking at, udev is what's loading the host
> > controllers, and there needs to be some sort of synchronization point
> > between that and LVM invocations, fsck, mount, etc. Since scans
> > aren't sent over as events for udev to catch, 'udevadm settle'
> > isn't enough.
> 
> So ... if we sent a udev event when the scan list was empty, you'd be OK?

I'm CC'ing Peter, who has some more ideas - it would definitely be a good
start, but we'd probably at least need to know when the scan list started
being filled as well.

This also doesn't help with USB, where the scan isn't scheduled until some
indeterminate time after the host is registered, but given that USB is
always hotpluggable, you can never fully be sure there.

Ideally, once we get to the point where:

- MD
- DM/LVM/etc
- fsck
- mount

can all be event-driven on startup, we won't need this. But we're not
there yet.

> > Removing, loading, and removing scsi_wait_scan works
> > here, but it just seems like a kludge.
> 
> I don't quite understand why it was loaded, and not unloaded immediately.

In the initramfs (as we use it) it is, but any time later in userspace it
seems prudent to make sure it's removed first. I toyed with the idea of
having module_init() return an error so that the module unregisters itself
after doing the wait-for-scans, but the error of course propagates back
to userspace, giving lots of ugly messages in the default config.
(You could do a modprobe rule that automatically removes it after
insertion.)

Bill
