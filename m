From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] iscsi-target: Merge for .40-rc1
Date: Mon, 25 Jul 2011 16:15:05 -0700
Message-ID: <1311635705.17766.183.camel@haakon2.linux-iscsi.org>
References: <1306551592.23461.506.camel@haakon2.linux-iscsi.org>
	 <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com>
	 <20110530130949.GB13494@lst.de>
	 <20110619015025V.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50927 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab1GYXY1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2011 19:24:27 -0400
In-Reply-To: <20110619015025V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hch@lst.de, torvalds@linux-foundation.org, michaelc@cs.wisc.edu, agrover@redhat.com, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, 2011-06-19 at 01:55 +0900, FUJITA Tomonori wrote:
> On Mon, 30 May 2011 15:09:49 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Sun, May 29, 2011 at 11:49:08AM -0700, Linus Torvalds wrote:
> > > I don't feel confident or motivated enough about iscsi-target, so
> > > after some (little) thought I ended up not pulling this. I really need
> > > a lot of acks from people who actually work on and care about SCSI,
> > > and right now I feel like with me being away for the next week, I
> > > can't handle it.
> > > 
> > > I just don't want to be in the situation where I pull something that
> > > is apparently contentious in the SCSI space in general, but that's
> > > _particularly_ true this release. So I'm afraid that this essentially
> > > got pushed out to the next release.
> > 
> > The main contention right now is wether to put the authentification
> > into kernel space or not.  Doing the slow path in userspace worked
> > out okay but not great on the initiator, but it has the potential
> > to become a nightmare worse than oprofile if the split ends up not
> > beeing perfect.
> 
> As I said earlier, the split is pretty simple for target code unlike
> initiator code. Doing operations before SCSI nexus establishment in
> userspace and then the kernel takes over nexuses. The information that
> the user space needs for the login negotiation is exported via
> configfs. Unlike open-iscsi split, the nexuses don't go back and forth
> between user and kernel space.
> 
> 
> > Given that we pretty well tested and working code that's used in lots
> > of production setups my vote is for taking it as-is unless someone can
> > actually show a prototype for a nicely working user/kernel split.
> 
> ok, I implemented something like that. It's not finished at all but
> my open-iscsi box successfully logged in. The daemon just passes a file
> descriptor to kernel space after the negotiation finishes.
> 
> ssh://master.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git lio-4.1-ud
> 
> The user space code is at:
> ssh://master.kernel.org/pub/scm/linux/kernel/git/tomo/iscsi-tcmd.git

Hi Tomo and Co,

Just to clarify my position on your efforts here, as I do agree with
James that they deserve a reply, regardless of my personal thoughts..

My main problem was that I was not expecting a port of IET userspace to
lio-4.1 for the main -> default login control path, so it makes it very
difficult for me to consider this type of split when the userspace code
is AFAICT not aware of any dynamic changes to the iscsi-target control
plane in /sys/kernel/config/target/iscsi/, which makes it extremely
fragile in it's current state.

So that said, I would be willing to consider merging this type of code
as an EXPERIMENTAL feature into a lio-core-2.6.git working tree for you,
if:

*) It can be made completely optional, and the currently proposed v3.1
login path runs in-kernel as the default so that it can function
cooperatively in the same tree with my own 'optional to implement'
authentication efforts in LIO upstream.
*) You commit to producing a userspace daemon that is aware of dynamic
changes to the configfs layout by userspace driven within an individual
iscsi-target contexts.  I don't care if this is IET or LIO, but the
daemon cannot be static to configfs layout changes.
*) We consider the fully in-kernel approach with 10,000+ endpoint layout
configurations for the non authenticated (CSG=1) login path for the
large scale demo-mode public iscsi-target setups.

So with this we can both have what we want in LIO upstream working tree,
with little effect on the current in-kernel code proposed for v3.1.
This is what I care most about personally and am committing to support
for v3.1 and beyond, and must be absoulutely rock solid for all possible
dynamic configfs configuration changes.  This is the control plane
design that I believe has been presented in the v3.1-rc1 merge request.

Thanks,

--nab



