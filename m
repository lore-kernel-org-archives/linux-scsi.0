From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] iscsi-target: Merge for .40-rc1
Date: Sun, 29 May 2011 13:58:38 -0700
Message-ID: <1306702718.13640.39.camel@haakon2.linux-iscsi.org>
References: <1306551592.23461.506.camel@haakon2.linux-iscsi.org>
	 <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimt5qisV7EH7NMv1tG8gR_9d-kA3g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Andy Grover <agrover@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-05-29 at 11:49 -0700, Linus Torvalds wrote:
> Gaah.
> 
> I don't feel confident or motivated enough about iscsi-target, so
> after some (little) thought I ended up not pulling this. I really need
> a lot of acks from people who actually work on and care about SCSI,
> and right now I feel like with me being away for the next week, I
> can't handle it.
> 
> I just don't want to be in the situation where I pull something that
> is apparently contentious in the SCSI space in general, but that's
> _particularly_ true this release. So I'm afraid that this essentially
> got pushed out to the next release.
> 

Hi again Linus,

Thanks for your consideration here.  I understand your concern and the
time pressures involved that make this difficult for you to merge this
round.

To clarify one point however, the contentious piece in question between
James and myself is something that I am not willing to compromise on for
this (or the next) round considering the serious technical implications
of doing so as discussed in the PATCH-v5 thread.

My real frustration here is the fact that this is the second time in as
many merge windows where at the very last minute this same point has
been raised to effectively delay the merging of this code.  There have
been many folks ready to sign-off on the current design (including
upstream distro folks), and the number of target patches from full time
developers like Andy have been piling up waiting for this to be merged.

So that said, aside from my differences of opinion on this particular
topic with James wrt to iscsi-target, the bigger issue here having to go
through the SCSI tree for all drivers/target/ related changes.  This is
really starting to slow down the number of target core changes getting
to mainline, and is causing the lio-core-2.6.git tree (that full time
developers like Andy are using) to quickly diverge from mainline.

So, I am asking for you to consider start pulling directly from .41 and
onwards for target core pieces now that drivers/target/ has finally been
added to MAINTAINERS.  I am not interested in trying to push anything
related to drivers/scsi/ outside of the SCSI tree, but for pieces of
target core that are not directly related to drivers/scsi/, it would be
very helpful for you to start pulling directly in order to keep the
mainline target better in-sync with lio-core-2.6.git tree that full time
target developers are using and moving forward with.

Thank you,

--nab


>                     Linus
> 
> On Fri, May 27, 2011 at 7:59 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> > Hi Linus,
> >
> > This is a GIT PULL request for the initial merge of the iscsi-target
> > fabric driver for mainline target core v4.0 infrastructure.
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-40-iscsi-target
> >
> > This series has been made against the following linux-2.6.git HEAD:
> >
> > commit dc7acbb2518f250050179c8581a972df3b6a24f1
> > Merge: f01e1af 4bf0ff2
> > Author: Linus Torvalds <torvalds@linux-foundation.org>
> > Date:   Thu May 26 19:01:15 2011 -0700
> >
> >    Merge branch 'upstream/tidy-xen-mmu-2.6.39' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen
> >
> > This code has undergone a number of review cycles on linux-scsi over the
> > last six months by Christoph, Mike and other interested folks.  This has
> > included a number of cleanups to follow mainline conventions, and
> > conversion to use mainline include/scsi/iscsi_proto.h RFC definitions.
> > There has been an good amount of testing feedback on this code so far,
> > and with the LIO communities help we have been able to resolve the
> > reported cleanup/conversion regressions, and fix one long-standing
> > shutdown bug.
> >
> > Unfortuately James and I have been unable to come to an aggreement on
> > implementation details wrt to proper kernel/user split ahead of his
> > final SCSI pull for .40.  I have no interest to take the mainline
> > iscsi-target development effort in this direction again, so I am
> > offically committing to you to support iscsi-target in good-faith
> > together with rtslib community edition moving forward.  I am also
> > committing to extending iscsi-target to address the non-standard
> > authentication pieces that James has mentioned, but by the time .40
> > ships we are still not going to have iSCSI clients that actually support
> > them.
> >
> > I believe that Christoph is happy with the current iscsi-target code for
> > an initial merge now, and am asking for the merge to avoid slipping
> > (again) for this type of 'mass-market' code that has a large audience,
> > and poses minimal risk considering the small amount of external changes.
> > [...]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
