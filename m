From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [GIT PULL] iscsi-target: Merge for .40-rc1
Date: Sun, 19 Jun 2011 01:55:14 +0900
Message-ID: <20110619015025V.fujita.tomonori@lab.ntt.co.jp>
References: <1306551592.23461.506.camel@haakon2.linux-iscsi.org>
	<BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com>
	<20110530130949.GB13494@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35286 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1FRQ4R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Jun 2011 12:56:17 -0400
In-Reply-To: <20110530130949.GB13494@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: torvalds@linux-foundation.org, nab@linux-iscsi.org, michaelc@cs.wisc.edu, agrover@redhat.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 30 May 2011 15:09:49 +0200
Christoph Hellwig <hch@lst.de> wrote:

> On Sun, May 29, 2011 at 11:49:08AM -0700, Linus Torvalds wrote:
> > I don't feel confident or motivated enough about iscsi-target, so
> > after some (little) thought I ended up not pulling this. I really need
> > a lot of acks from people who actually work on and care about SCSI,
> > and right now I feel like with me being away for the next week, I
> > can't handle it.
> > 
> > I just don't want to be in the situation where I pull something that
> > is apparently contentious in the SCSI space in general, but that's
> > _particularly_ true this release. So I'm afraid that this essentially
> > got pushed out to the next release.
> 
> The main contention right now is wether to put the authentification
> into kernel space or not.  Doing the slow path in userspace worked
> out okay but not great on the initiator, but it has the potential
> to become a nightmare worse than oprofile if the split ends up not
> beeing perfect.

As I said earlier, the split is pretty simple for target code unlike
initiator code. Doing operations before SCSI nexus establishment in
userspace and then the kernel takes over nexuses. The information that
the user space needs for the login negotiation is exported via
configfs. Unlike open-iscsi split, the nexuses don't go back and forth
between user and kernel space.


> Given that we pretty well tested and working code that's used in lots
> of production setups my vote is for taking it as-is unless someone can
> actually show a prototype for a nicely working user/kernel split.

ok, I implemented something like that. It's not finished at all but
my open-iscsi box successfully logged in. The daemon just passes a file
descriptor to kernel space after the negotiation finishes.

ssh://master.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git lio-4.1-ud

The user space code is at:
ssh://master.kernel.org/pub/scm/linux/kernel/git/tomo/iscsi-tcmd.git
